%{
#include <string>
#include <iostream>
#include <stack>
#include <vector>

#include "ExpressionTerm.h"

typedef struct {
	std::string value;
	std::string basic_block;
} PhiInfo;

int num_basic_blocks = 1;

std::string current_basic_block;
std::vector<std::string> basic_blocks_in_execution_order;
std::stack<std::string> basic_block_stack;
std::stack<PhiInfo> phi_stack;
std::stack<ExpressionTerm> operand_stack;
int num_vars = 0;
int tmp_var_num = 0;
std::vector<std::string> var_names;
int last_instruction_wrote_to_tmp;

std::string llvm_string;

template <typename T>
T top_and_pop(std::stack<T>& stack)
{
	T top = stack.top();
	stack.pop();
    return top;
}

void add_new_basic_block_to_llvm_string() {
	current_basic_block = top_and_pop(basic_block_stack);
	llvm_string += "\n " + current_basic_block + ":\n";
	basic_blocks_in_execution_order.push_back(current_basic_block);
}

void add_tabs_to_llvm_string(int num_tabs) {
	for (int i = 0; i < num_tabs; i++) {
		llvm_string += "    ";
	}
}

void add_line_to_llvm_string(std::string line) {
	add_tabs_to_llvm_string(1);
	llvm_string += line + "\n";
}

ExpressionTerm get_next_tmp_var() {
	std::string tmp_var_string = "tmp" + std::to_string(tmp_var_num);
	tmp_var_num++;
	ExpressionTerm tmp_var{TermType::VAR, 0, tmp_var_string};
	return tmp_var;
}

void print_opening_bracket_operation(ExpressionTerm operand2, std::string tmp_var_string) {
	num_basic_blocks++;
	std::string zero_label = "#" + std::to_string(num_basic_blocks);
	basic_block_stack.push(zero_label);

	num_basic_blocks++;
	std::string nonzero_label = "#" + std::to_string(num_basic_blocks);
	
	add_line_to_llvm_string("ifzero(" + operand2.text + ") goto " + zero_label + ";");

	basic_block_stack.push(nonzero_label);
	phi_stack.push({"0", current_basic_block});
}

void print_closing_bracket_operation(ExpressionTerm operand2, ExpressionTerm operand1) {
	ExpressionTerm tmp_var = get_next_tmp_var();
	PhiInfo phi_arg1 = top_and_pop(phi_stack);
	PhiInfo phi_arg2 = {tmp_var.text, current_basic_block};

	add_line_to_llvm_string(tmp_var.text + " = " + operand2.text + ";");
	add_new_basic_block_to_llvm_string();
	tmp_var = get_next_tmp_var();
	add_line_to_llvm_string(tmp_var.text + " = phi([" + phi_arg1.value + ", " + phi_arg1.basic_block + "], [" + phi_arg2.value + ", " + phi_arg2.basic_block + "]);");
	operand_stack.emplace(operand1);
	operand_stack.emplace(TermType::VAR, 0, tmp_var.text);
}

auto get_next_operand() {
	return top_and_pop(operand_stack);
}

auto get_ambiguous_result_var(bool next_term_is_equal_operator) {
	if (next_term_is_equal_operator) {
		return get_next_operand();
	} else {
		return get_next_tmp_var();
	}
}

void add_llvm_operation_to_string(ExpressionTerm op, bool next_term_is_equal_operator) {
	ExpressionTerm operand2 = get_next_operand();

	if (op.value == '[') {
		ExpressionTerm tmp_var = get_next_tmp_var();
		print_opening_bracket_operation(operand2, tmp_var.text);
		add_new_basic_block_to_llvm_string();
	} else if (op.value == '!') {
		ExpressionTerm result_var = get_ambiguous_result_var(next_term_is_equal_operator);
		add_line_to_llvm_string(result_var.text + " = !" + operand2.text + ";");
		operand_stack.emplace(result_var);
	} else {
		ExpressionTerm operand1 = get_next_operand();

		if (op.value == '=') {
			add_line_to_llvm_string(operand1.text + " = " + operand2.text + ";");
			operand_stack.emplace(operand1);
		} else {
			if (op.value == ']') {
				print_closing_bracket_operation(operand2, operand1);
			} else {
				ExpressionTerm result_var = get_ambiguous_result_var(next_term_is_equal_operator);
				add_line_to_llvm_string(result_var.text + " = " + operand1.text + " " + char(op.value) + " " + operand2.text + ";");
				operand_stack.emplace(result_var);
			}
		}
	}
}

void replace_all_substrings(std::string& entire_string, const std::string old_substring, std::string new_substring)
{
	std::string::size_type pos = entire_string.find(old_substring, 0);
    while (pos != entire_string.npos) {
		entire_string.replace(pos, old_substring.length(), new_substring);
		pos = entire_string.find(old_substring, pos + new_substring.length());
    }
}

void fix_basic_blocks() {
	int new_basic_block_num = 1;
	std::string new_basic_block_name;
	for(auto old_basic_block_name : basic_blocks_in_execution_order) {
		new_basic_block_name = "BB" + std::to_string(new_basic_block_num);
		replace_all_substrings(llvm_string, old_basic_block_name, new_basic_block_name);
		new_basic_block_num++;
	}
}

%}

%%
[\n] {
	}
	
" "[+\-*/!^]" =" {
		ExpressionTerm term{TermType::OP, yytext[1], ""};
		add_llvm_operation_to_string(term, true);
	}
	
" "[\[\]+\-*/!?=^] {
		ExpressionTerm term{TermType::OP, yytext[1], ""};
		add_llvm_operation_to_string(term, false);
	}

" "[0-9]+ {
		ExpressionTerm term{TermType::NUM, atoi(yytext), yytext+1};
		operand_stack.push(term);
	}

" "[A-z][A-z0-9_]* {
		ExpressionTerm term{TermType::VAR, 0, yytext+1};
		operand_stack.push(term);
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
	basic_block_stack.push("#1");
	add_new_basic_block_to_llvm_string();
	yylex();
	fix_basic_blocks();
	std::cout << llvm_string;
	return 0;
}
