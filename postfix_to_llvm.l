%{
#include <string>
#include <iostream>
#include <stack>
#include <vector>
#include <unordered_map>

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
int tmp_var_num = 0;
std::unordered_map<std::string, int> num_assignments_per_variable;
std::vector<std::string> variables_that_are_used_before_defined;
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

std::string get_operand_string(ExpressionTerm operand, bool is_being_assigned) {
	if (operand.type == TermType::NUM || operand.is_tmp) {
		return operand.text;
	}
	
	if (is_being_assigned) {
		num_assignments_per_variable[operand.text]++;
	} else if (num_assignments_per_variable[operand.text] == 0) {
		variables_that_are_used_before_defined.push_back(operand.text);
		num_assignments_per_variable[operand.text]++;
	}

	return operand.text + "." + std::to_string(num_assignments_per_variable[operand.text]);
}

auto get_next_operand_and_its_string(bool is_being_assigned) {
	ExpressionTerm operand = top_and_pop(operand_stack);
	std::string operand_string = get_operand_string(operand, is_being_assigned);
	return std::pair(operand, operand_string);
}

auto get_next_tmp_var_and_its_string() {
	tmp_var_num++;
	std::string tmp_var_text = "tmp." + std::to_string(tmp_var_num);
	ExpressionTerm tmp_var{TermType::VAR, 0, tmp_var_text, true};
	return std::pair(tmp_var, tmp_var_text);
}

auto get_ambiguous_result_var(bool next_term_is_equal_operator) {
	if (next_term_is_equal_operator) {
		return get_next_operand_and_its_string(true);
	} else {
		return get_next_tmp_var_and_its_string();
	}
}

void add_opening_bracket_operation_to_llvm_string(std::string operand2_string) {
	num_basic_blocks++;
	std::string zero_label = "#" + std::to_string(num_basic_blocks);
	basic_block_stack.push(zero_label);

	num_basic_blocks++;
	std::string nonzero_label = "#" + std::to_string(num_basic_blocks);
	
	add_line_to_llvm_string("ifzero(" + operand2_string + ") goto " + zero_label + ";");

	basic_block_stack.push(nonzero_label);
	phi_stack.push({"0", current_basic_block});
	add_new_basic_block_to_llvm_string();
}

void add_closing_bracket_operation_to_llvm_string(std::string operand2_string, bool next_term_is_equal_operator) {
	auto [tmp_var, tmp_var_string] = get_next_tmp_var_and_its_string();
	PhiInfo phi_arg1 = top_and_pop(phi_stack);
	PhiInfo phi_arg2 = {tmp_var_string, current_basic_block};

	add_line_to_llvm_string(tmp_var_string + " = " + operand2_string + ";");
	add_new_basic_block_to_llvm_string();

	auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
	add_line_to_llvm_string(result_var_string + " = phi([" + phi_arg1.value + ", " + phi_arg1.basic_block + "], [" + phi_arg2.value + ", " + phi_arg2.basic_block + "]);");
	operand_stack.emplace(result_var);
}

void add_not_operation_to_llvm_string(std::string operand2_string, bool next_term_is_equal_operator) {
	auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
	add_line_to_llvm_string(result_var_string + " = !" + operand2_string + ";");
	operand_stack.emplace(result_var);
}

void add_equals_operation_to_llvm_string(std::string operand2_string) {
	auto [operand1, operand1_string] = get_next_operand_and_its_string(true);
	add_line_to_llvm_string(operand1_string + " = " + operand2_string + ";");
	operand_stack.emplace(operand1);
}

void add_standard_operation_to_llvm_string(char op_value, std::string operand2_string, bool next_term_is_equal_operator) {
	auto [operand1, operand1_string] = get_next_operand_and_its_string(false);
	auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
	add_line_to_llvm_string(result_var_string + " = " + operand1_string + " " + op_value + " " + operand2_string + ";");
	operand_stack.emplace(result_var);
}

void add_llvm_operation_to_string(ExpressionTerm op, bool next_term_is_equal_operator) {
	auto [operand2, operand2_string] = get_next_operand_and_its_string(false);

	if (op.value == '[') {
		add_opening_bracket_operation_to_llvm_string(operand2_string);
	} else if (op.value == '=') {
		add_equals_operation_to_llvm_string(operand2_string);
	} else if (op.value == ']') {
		add_closing_bracket_operation_to_llvm_string(operand2_string, next_term_is_equal_operator);
	} else if (op.value == '!') {
		add_not_operation_to_llvm_string(operand2_string, next_term_is_equal_operator);
	} else {
		add_standard_operation_to_llvm_string(char(op.value), operand2_string, next_term_is_equal_operator);
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
	
" "[\]+\-*/!^]" =" {
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

" tmp" { 
		/*This allows users to name a variable named "tmp" without conflicting with compilation */
		ExpressionTerm term{TermType::VAR, 0, "-tmp"};
		operand_stack.push(term);
		num_assignments_per_variable.insert({"-tmp", 0});
	}

" "[A-z][A-z0-9_]* {
		ExpressionTerm term{TermType::VAR, 0, yytext+1};
		operand_stack.push(term);
		num_assignments_per_variable.insert({yytext+1, 0});
	}

%%
int yywrap() { /* need this to avoid link problem */
	return 1;
}

int main(int argc, char** argv) {
	bool undefined_variables_are_user_input;
	if (argc < 3) {
		if (argc < 2) {
			std::cout << "A file must be provided in the command line.\n";
			return 0;
		} else {
			undefined_variables_are_user_input = false;
		}
	} else {
		undefined_variables_are_user_input = atoi(argv[2]);
	}
	yyin = fopen(argv[1], "r");
	basic_block_stack.push("#1");
	add_new_basic_block_to_llvm_string();
	yylex();
	fix_basic_blocks();
	std::cout << llvm_string;
	for (auto var : variables_that_are_used_before_defined) {
		std::cout << var << "\n";
	}
	return 0;
}
