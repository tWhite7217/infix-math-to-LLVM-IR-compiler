%{
#include <stdlib.h> /* for atoi call */
#include <string.h>
#include <string>
#include <iostream>
#include <stack>
#include <vector>
#include <boost/range/irange.hpp>
/* #include "cal.tab.h" */

// #define DEBUG /* for debuging: print tokens and their line numbers */
#define VARIABLE 258 /* copy this from cal.tab.c */
#define NUMBER 259 /* copy this from cal.tab.c */

typedef union { /* copy this from cal.tab.c */
int d;
} YYSTYPE;

typedef enum {
	OP,
	NUM,
	VAR
} TermType;

typedef struct termInfo {
	TermType type;
	int value;
	std::string text;

	termInfo(TermType type, int value, std::string text) {
		this->type = type;
		this->value = value;
		this->text = text;
	}
} termInfo;

YYSTYPE yylval; /* for passing value to parser */
// extern int lineNum; /* line number from cal.tab.c */
int line_num;

int current_basic_block_num = 0;

int parenthesesLevel = 0;
char parenthesesIssue = 0;
std::stack<termInfo> operator_stack;
std::vector<termInfo> postfix_expression_terms;
std::stack<termInfo> llvm_stack;
int num_vars = 0;
int tmp_var_num = 0;
std::vector<std::string> var_names;
int last_instruction_wrote_to_tmp;

int parentheses_conditional_or_not_stack[100];
int parentheses_stack_index = -1;

std::string output_LLVM;

termInfo opening_bracket(OP, '[', "");
termInfo closing_bracket(OP, ']', "");
termInfo previous_term(NUM, -1, "");

void print_debug_info_if_necessary(char *yytext) {
	#ifdef DEBUG
		printf("token %s at line %d\n", yytext, line_num);
	#endif
}

int get_variable_number(char *var_name) {
	for (auto i : boost::irange(var_names.size())) {
		if (var_names[i] == var_name) {
			return i;
		}
	}
	return -1;
}

int add_variable_name(char *var_name) {
	var_names.emplace_back(var_name);
	return var_names.size() - 1;
}

int order_of_operator(char op) {
	switch(op) {
		case '(':
			return 0;
		case '=':
			return 1;
		case '+':
		case '-':
			return 2;
		case '*':
		case '/':
			return 3;
		case '^':
			return 4;
		case '?':
			return 5;
		case '!':
			return 6;
		default:
			exit(1);
	}
}

int top_operand_precedence_difference(termInfo op) {
	return order_of_operator(operator_stack.top().value) - order_of_operator(op.value);
}

int top_operand_should_be_popped(termInfo op) {
	int diff = top_operand_precedence_difference(op);
	if (op.value == '^') {
		return diff > 0;
	} else {
		return diff >= 0;
	}
}

void handle_new_operator(termInfo op) {
	while (!operator_stack.empty() && top_operand_should_be_popped(op)) {
		postfix_expression_terms.push_back(operator_stack.top());
		operator_stack.pop();
	}
	operator_stack.push(op);
}

void open_conditional() {
	postfix_expression_terms.push_back(opening_bracket);
}

void close_conditional() {
	postfix_expression_terms.push_back(closing_bracket);
}

void handle_right_parenthesis() {
	termInfo popped_operator = operator_stack.top();
	operator_stack.pop();
	while(popped_operator.value != '(') {
		postfix_expression_terms.push_back(popped_operator);
		popped_operator = operator_stack.top();
		operator_stack.pop();
	}
	int was_conditional = parentheses_conditional_or_not_stack[parentheses_stack_index];
	parentheses_stack_index--;
	if (was_conditional) {
		close_conditional();
	}
}

void handle_left_parenthesis(termInfo term) {
	parentheses_stack_index++;
	if (previous_term.value == '?') {
		parentheses_conditional_or_not_stack[parentheses_stack_index] = TRUE;
	} else {
		parentheses_conditional_or_not_stack[parentheses_stack_index] = FALSE;
	}
	operator_stack.push(term);
}

int is_conditional_operator(termInfo term) {
	return (previous_term.type == OP) && (previous_term.value == '?');
}

int is_not_left_parenthesis(termInfo term) {
	return (term.type != OP) || (term.value != '(');
}

void handle_exclamation(termInfo term) {
	postfix_expression_terms.push_back(term);
}

void handle_new_term(termInfo term) {
	if (term.type == OP) {
		if (term.value == '?') {
			open_conditional();
		} else if (term.value == ')') {
			handle_right_parenthesis();
		} else if (term.value == '(') {
			handle_left_parenthesis(term);
		} else {
			handle_new_operator(term);
		}
	} else {
		postfix_expression_terms.push_back(term);
	}

	if (is_conditional_operator(previous_term) && is_not_left_parenthesis(term)) {
		close_conditional();
	}

	previous_term = term;
}

void print_postfix() {
	for (int i = 0; i < postfix_expression_terms.size(); i++) {
		termInfo term = postfix_expression_terms[i];
		if (term.type == NUM) {
			printf("%d ", term.value);
		} else if (term.type == VAR) {
			std::cout << term.text << " ";
		} else if (term.value == '^') {
			printf("** ");
		} else {
			printf("%c ", term.value);
		}
	}
	printf("\n");
}

void start_new_basic_block() {
	current_basic_block_num++;
	std::cout << "\nBB" << current_basic_block_num << ":\n";
}

void set_operand_string(std::string& operand_string, termInfo operand) {
	if (operand.type == NUM) {
		operand_string = std::to_string(operand.value);
	} else {
		operand_string = operand.text;
	}
}

void print_tabs(int num_tabs) {
	for (int i = 0; i < num_tabs; i++) {
		printf("    ");
	}
}

int get_number_of_nested_ifs(auto current_i) {
	int number_nested = 0;
	int nested_level = 0;
	int i = 1;
	termInfo next_term = postfix_expression_terms[current_i + i];
	while (!((nested_level == 0) && (next_term.type == OP) && (next_term.value == ']'))) {
		if ((next_term.type == OP) && (next_term.value == '[')) {
			number_nested++;
			nested_level++;
		} else if ((next_term.type == OP) && (next_term.value == ']')) {
			nested_level--;
		}
		i++;
		next_term = postfix_expression_terms[current_i + i];
	}
	return number_nested;
}

void print_opening_bracket_operation(std::string operand2_string, auto current_i) {
	std::cout << "if(" << operand2_string << ") {\n";
	print_tabs(2);
	std::cout << "goto BB" << current_basic_block_num + 1 << ";\n";
	print_tabs(1);
	printf("} else {\n");
	print_tabs(2);
	std::cout << "goto BB" << current_basic_block_num + 2 + (3 * get_number_of_nested_ifs(current_i)) << ";\n";
	print_tabs(1);
	printf("}\n");
}

void print_closing_bracket_operation(std::string tmp_var_string, std::string operand2_string) {
	std::cout << tmp_var_string << " = " << operand2_string << ";\n";
	print_tabs(1);
	std::cout << "goto BB" << current_basic_block_num + 2 << ";\n";
	start_new_basic_block();
	print_tabs(1);
	std::cout << tmp_var_string << " = 0;\n";
	print_tabs(1);
	std::cout << "goto BB" << current_basic_block_num + 1 << ";\n";
}

bool next_term_is_equal_operator(auto current_i) {
	return 	(current_i+1 < postfix_expression_terms.size()) &&
			(postfix_expression_terms[current_i+1].type == OP) &&
			(postfix_expression_terms[current_i+1].value == '=');
}

bool add_llvm_operation(termInfo op, auto current_i) {
	std::string operand2_string;
	termInfo operand2 = llvm_stack.top();
	llvm_stack.pop();
	set_operand_string(operand2_string, operand2);

	print_tabs(1);

	if (op.value == '[') {
		print_opening_bracket_operation(operand2_string, current_i);
		start_new_basic_block();
	} else {
		std::string operand1_string;
		termInfo operand1 = llvm_stack.top();
		llvm_stack.pop();
		set_operand_string(operand1_string, operand1);

		if (op.value == '=') {
			std::cout << operand1_string << " = " << operand2_string << ";\n";
			llvm_stack.emplace(operand1);
		} else {
			std::string tmp_var_string = "tmp" + std::to_string(tmp_var_num);
			if (op.value == '!') {
				llvm_stack.emplace(operand1);
				if (next_term_is_equal_operator(current_i)) {
					std::cout << operand1_string << " = !" << operand2_string << ";\n";
					return 1;
				} else {
					std::cout << tmp_var_string << " = !" << operand2_string << ";\n";
					llvm_stack.emplace(VAR, 0, tmp_var_string);
					tmp_var_num++;
				}
			} else if (op.value == ']') {
				print_closing_bracket_operation(tmp_var_string, operand2_string);
				start_new_basic_block();
				llvm_stack.emplace(operand1);
				llvm_stack.emplace(VAR, 0, tmp_var_string);
				tmp_var_num++;
			} else {
				if (next_term_is_equal_operator(current_i)) {
					std::string operand0_string;
					termInfo operand0 = llvm_stack.top();
					llvm_stack.pop();
					set_operand_string(operand0_string, operand0);
					std::cout << operand0_string << " = " << operand1_string << " " << char(op.value) << " " << operand2_string << ";\n";
					llvm_stack.emplace(operand0);
					return 1;
				} else {
					std::cout << tmp_var_string << " = " << operand1_string << " " << char(op.value) << " " << operand2_string << ";\n";
					llvm_stack.emplace(VAR, 0, tmp_var_string);
					tmp_var_num++;
				}
			}
		}
	}
	return 0;
}

void create_llvm_output() {
	for (int i = 0; i < postfix_expression_terms.size(); i++) {
		termInfo term = postfix_expression_terms[i];
		if (term.type == OP) {
			bool added_operation_and_assignment_on_same_line =
				add_llvm_operation(term, i);
			if (added_operation_and_assignment_on_same_line) {
				i++;
			}
		} else {
			llvm_stack.push(term);
		}
	}
}

void lex_newline_or_eof() {
	line_num++;
	if (parenthesesLevel != 0) {
		printf("Parentheses mismatch!\n");
	}

	while(!operator_stack.empty()) {
		postfix_expression_terms.push_back(operator_stack.top());
		operator_stack.pop();
	}

	// print_postfix();
	create_llvm_output();
	postfix_expression_terms.clear();

	parenthesesIssue = 0;
	parenthesesLevel = 0;
}

%}

%%
[ \t]+ {}

[\n] {
	lex_newline_or_eof();
	}
	
<<EOF>> {
	lex_newline_or_eof();
	return 0;
	}
	
"(" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '(', "");
	handle_new_term(term);
	parenthesesLevel++;
	// return '(';
	}

")" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, ')', "");
	handle_new_term(term);
	parenthesesLevel--;
	if (parenthesesLevel < 0) {
		printf("Parentheses mismatch!\n");
	}
	// return ')';
	}

"**" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '^', "");
	handle_new_term(term);
	// return '^';
	}

"+" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '+', "");
	handle_new_term(term);
	// return '+';
	}

"-" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '-', "");
	handle_new_term(term);
	// return '-';
	}

"*" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '*', "");
	handle_new_term(term);
	// return '*';
	}

"/" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '/', "");
	handle_new_term(term);
	// return '/';
	}

"!" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '!', "");
	handle_new_term(term);
	// return '!';
	}

	
"?" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '?', "");
	handle_new_term(term);
	// return '?';
	}

"=" {
	print_debug_info_if_necessary(yytext);
	termInfo term(OP, '=', "");
	handle_new_term(term);
	// return '=';
	}

[0-9]+ {
	print_debug_info_if_necessary(yytext);
	yylval.d = atoi(yytext);
	termInfo term(NUM, yylval.d, "");
	handle_new_term(term);
	// return NUMBER;
	}

[A-z][A-z0-9_]* {
	print_debug_info_if_necessary(yytext);
	int var_num = get_variable_number(yytext);
	if (var_num == -1) {
		var_num = add_variable_name(yytext);
	}
	yylval.d = var_num;
	termInfo term(VAR, var_num, var_names[var_num]);
	handle_new_term(term);
	// return VARIABLE;
	}

%%
int yywrap() { /* need this to avoid link problem */
	return 1;
}

int main(int argc, char** argv) {
	if (argc < 2) {
		return 0;
	}
	yyin = fopen(argv[1], "r");
	// yyparse();
	start_new_basic_block();
	yylex();
	return 0;
}
