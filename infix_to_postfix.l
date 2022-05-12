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

class termInfo {
public:
	TermType type;
	int value;
	std::string text;

	termInfo(TermType type, int value, std::string text) : 
		type(type), value(value), text(text) {}
		

	bool is_conditional_operator() {
		return (type == OP) && (value == '?');
	}

	bool is_not_left_parenthesis() {
		return (type != OP) || (value != '(');
	}
};

int line_num;

std::stack<termInfo> operator_stack;
std::vector<termInfo> postfix_expression_terms;

std::string postfix_string;

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

	if (previous_term.is_conditional_operator() && term.is_not_left_parenthesis()) {
		close_conditional();
	}

	previous_term = term;
}

void add_line_to_postfix_string() {
	for (auto term : postfix_expression_terms) {
		postfix_string += " ";
		if (term.type == NUM) {
			postfix_string += std::to_string(term.value);
		} else if (term.type == VAR) {
			postfix_string += term.text;
		} else {
			postfix_string += term.value;
		}
	}
	postfix_string += "\n";
}

void set_operand_string(std::string& operand_string, termInfo operand) {
	if (operand.type == NUM) {
		operand_string = std::to_string(operand.value);
	} else {
		operand_string = operand.text;
	}
}

void lex_newline_or_eof() {
	line_num++;

	while(!operator_stack.empty()) {
		postfix_expression_terms.push_back(operator_stack.top());
		operator_stack.pop();
	}

	add_line_to_postfix_string();
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
	
[()+\-*/!?=^] {
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
	std::cout << postfix_string;
	return 0;
}
