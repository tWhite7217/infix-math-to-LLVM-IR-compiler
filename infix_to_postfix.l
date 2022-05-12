%{
#include <string>
#include <iostream>
#include <stack>
#include <vector>

typedef enum {
	OP,
	NUM,
	VAR
} TermType;

typedef struct termInfo {
	TermType type;
	int value;
	std::string text;

	termInfo(TermType type, int value, std::string text) : 
		type(type), value(value), text(text) {}
} termInfo;

int line_num;

std::stack<termInfo> operator_stack;
std::vector<termInfo> postfix_expression_terms;

std::stack<bool> parentheses_conditional_or_not_stack;

termInfo opening_bracket(OP, '[', "");
termInfo closing_bracket(OP, ']', "");
termInfo previous_term(NUM, -1, "");

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
	bool was_conditional = parentheses_conditional_or_not_stack.top();
	parentheses_conditional_or_not_stack.pop();
	if (was_conditional) {
		close_conditional();
	}
}

void handle_left_parenthesis(termInfo term) {
	if (previous_term.value == '?') {
		parentheses_conditional_or_not_stack.push(true);
	} else {
		parentheses_conditional_or_not_stack.push(false);
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

void lex_newline_or_eof() {
	line_num++;

	while(!operator_stack.empty()) {
		postfix_expression_terms.push_back(operator_stack.top());
		operator_stack.pop();
	}

	print_postfix();
	postfix_expression_terms.clear();
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
	
[()+\-*/!?=] {
		termInfo term(OP, yytext[0], "");
		handle_new_term(term);
	}

"**" {
	termInfo term(OP, '^', "");
	handle_new_term(term);
	}

[0-9]+ {
	termInfo term(NUM, atoi(yytext), "");
	handle_new_term(term);
	}

[A-z][A-z0-9_]* {
	termInfo term(VAR, 0, std::string(yytext));
	handle_new_term(term);
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
	yylex();
	return 0;
}
