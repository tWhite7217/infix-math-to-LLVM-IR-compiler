%{
#include <string>
#include <iostream>
#include <stack>
#include <vector>

#include "ExpressionTerm.h"

int line_num;

std::stack<ExpressionTerm> operator_stack;
std::vector<ExpressionTerm> postfix_expression_terms;

std::string postfix_string;

std::stack<bool> parentheses_conditional_or_not_stack;

ExpressionTerm opening_bracket(TermType::OP, '[', "");
ExpressionTerm closing_bracket(TermType::OP, ']', "");
ExpressionTerm previous_term(TermType::NUM, -1, "");

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

int top_operand_precedence_difference(ExpressionTerm op) {
	return order_of_operator(operator_stack.top().value) - order_of_operator(op.value);
}

int top_operand_should_be_popped(ExpressionTerm op) {
	int diff = top_operand_precedence_difference(op);
	if (op.value == '^') {
		return diff > 0;
	} else {
		return diff >= 0;
	}
}

void handle_new_operator(ExpressionTerm op) {
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
	ExpressionTerm popped_operator = operator_stack.top();
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

void handle_left_parenthesis(ExpressionTerm term) {
	if (previous_term.value == '?') {
		parentheses_conditional_or_not_stack.push(true);
	} else {
		parentheses_conditional_or_not_stack.push(false);
	}
	operator_stack.push(term);
}

void handle_new_term(ExpressionTerm term) {
	if (term.type == TermType::OP) {
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
		if (term.type == TermType::NUM) {
			postfix_string += std::to_string(term.value);
		} else if (term.type == TermType::VAR) {
			postfix_string += term.text;
		} else {
			postfix_string += term.value;
		}
	}
	postfix_string += "\n";
}

void set_operand_string(std::string& operand_string, ExpressionTerm operand) {
	if (operand.type == TermType::NUM) {
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
	
[()+\-*/!?=] {
		ExpressionTerm term(TermType::OP, yytext[0], "");
		handle_new_term(term);
	}
	
"**" {
		ExpressionTerm term(TermType::OP, '^', "");
		handle_new_term(term);
	}

[0-9]+ {
	ExpressionTerm term(TermType::NUM, atoi(yytext), "");
	handle_new_term(term);
	}

[A-z][A-z0-9_]* {
	ExpressionTerm term(TermType::VAR, 0, std::string(yytext));
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
