%{
#include <string>
#include <iostream>
#include <stack>
#include <vector>
#include <boost/range/irange.hpp>

#include "ExpressionTerm.h"

typedef struct {
	std::string value;
	std::string basic_block;
} PhiInfo;

int line_num;

int num_basic_blocks = 1;

std::string current_basic_block;
std::stack<std::string> basic_block_stack;
std::stack<PhiInfo> phi_stack;
std::stack<ExpressionTerm> llvm_stack;
int num_vars = 0;
int tmp_var_num = 0;
std::vector<std::string> var_names;
int last_instruction_wrote_to_tmp;

std::string llvm_string;

void start_new_basic_block() {
	// num_basic_blocks++;
	// std::cout << "\nBB" << num_basic_blocks << ":\n";
	current_basic_block = basic_block_stack.top();
	std::cout << "\n" << current_basic_block << ":\n";
	basic_block_stack.pop();
}

void set_operand_string(std::string& operand_string, ExpressionTerm operand) {
	if (operand.type == TermType::NUM) {
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

void print_opening_bracket_operation(std::string operand2_string, std::string tmp_var_string) {
	std::cout << "if(" << operand2_string << ") {\n";
	print_tabs(2);
	num_basic_blocks++;
	std::string if_label = "BB" + std::to_string(num_basic_blocks);
	std::cout << "goto " << if_label << ";\n";
	print_tabs(1);
	printf("} else {\n");
	print_tabs(2);
	std::cout << tmp_var_string << " = 0;\n";
	tmp_var_num++;
	print_tabs(2);
	num_basic_blocks++;
	std::string else_label = "BB" + std::to_string(num_basic_blocks);
	std::cout << "goto " << else_label << ";\n";
	print_tabs(1);
	printf("}\n");
	basic_block_stack.push(else_label);
	basic_block_stack.push(if_label);
	phi_stack.push({tmp_var_string, current_basic_block});
}

void print_closing_bracket_operation(std::string &tmp_var_string, std::string operand2_string) {
	std::cout << tmp_var_string << " = " << operand2_string << ";\n";
	phi_stack.push({tmp_var_string, current_basic_block});
	start_new_basic_block();
	tmp_var_num++;
	tmp_var_string = "tmp" + std::to_string(tmp_var_num);
	tmp_var_num++;
	print_tabs(1);
	PhiInfo phi_arg1 = phi_stack.top();
	phi_stack.pop();
	PhiInfo phi_arg2 = phi_stack.top();
	phi_stack.pop();
	std::cout << tmp_var_string << " = phi([" << phi_arg1.value << ", " << phi_arg1.basic_block << "], [" << phi_arg2.value << ", " << phi_arg2.basic_block << "]);\n";
}

void add_llvm_operation_to_string(ExpressionTerm op, bool next_term_is_equal_operator) {
	std::string operand2_string;
	ExpressionTerm operand2 = llvm_stack.top();
	llvm_stack.pop();
	set_operand_string(operand2_string, operand2);
	std::string tmp_var_string = "tmp" + std::to_string(tmp_var_num);

	print_tabs(1);

	if (op.value == '[') {
		print_opening_bracket_operation(operand2_string, tmp_var_string);
		start_new_basic_block();
	} else {
		std::string operand1_string;
		ExpressionTerm operand1 = llvm_stack.top();
		llvm_stack.pop();
		set_operand_string(operand1_string, operand1);

		if (op.value == '=') {
			std::cout << operand1_string << " = " << operand2_string << ";\n";
			llvm_stack.emplace(operand1);
		} else {
			if (op.value == '!') {
				llvm_stack.emplace(operand1);
				if (next_term_is_equal_operator) {
					std::cout << operand1_string << " = !" << operand2_string << ";\n";
				} else {
					std::cout << tmp_var_string << " = !" << operand2_string << ";\n";
					llvm_stack.emplace(TermType::VAR, 0, tmp_var_string);
					tmp_var_num++;
				}
			} else if (op.value == ']') {
				print_closing_bracket_operation(tmp_var_string, operand2_string);
				// start_new_basic_block();
				llvm_stack.emplace(operand1);
				llvm_stack.emplace(TermType::VAR, 0, tmp_var_string);
				tmp_var_num++;
			} else {
				if (next_term_is_equal_operator) {
					std::string operand0_string;
					ExpressionTerm operand0 = llvm_stack.top();
					llvm_stack.pop();
					set_operand_string(operand0_string, operand0);
					std::cout << operand0_string << " = " << operand1_string << " " << char(op.value) << " " << operand2_string << ";\n";
					llvm_stack.emplace(operand0);
				} else {
					std::cout << tmp_var_string << " = " << operand1_string << " " << char(op.value) << " " << operand2_string << ";\n";
					llvm_stack.emplace(TermType::VAR, 0, tmp_var_string);
					tmp_var_num++;
				}
			}
		}
	}
}

void lex_newline_or_eof() {
	line_num++;
}

%}

%%
[\n] {
		lex_newline_or_eof();
	}
	
<<EOF>> {
		lex_newline_or_eof();
		return 0;
	}
	
" "[+\-*/!?^]" =" {
		ExpressionTerm term(TermType::OP, yytext[1], "");
		add_llvm_operation_to_string(term, true);
	}
	
" "[\[\]+\-*/!?=^] {
		ExpressionTerm term(TermType::OP, yytext[1], "");
		add_llvm_operation_to_string(term, false);
	}

" "[0-9]+ {
		ExpressionTerm term(TermType::NUM, atoi(yytext), "");
		llvm_stack.push(term);
	}

" "[A-z][A-z0-9_]* {
		ExpressionTerm term(TermType::VAR, 0, std::string(yytext+1));
		llvm_stack.push(term);
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
	basic_block_stack.push("BB1");
	start_new_basic_block();
	yylex();
	std::cout << llvm_string;
	return 0;
}
