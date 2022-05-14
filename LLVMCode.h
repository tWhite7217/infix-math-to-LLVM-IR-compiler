#pragma once

#include <string>
#include <iostream>
#include <stack>
#include <vector>
#include <unordered_map>

#include "ExpressionTerm.h"
#include "helper_functions.h"

class LLVMCode
{
public:
    bool undefined_variables_are_user_input;

    std::string get_code();
    void print();
    void handle_new_operand(ExpressionTerm);
    void add_operation(ExpressionTerm, bool);
    void fix_basic_blocks();
    void handle_undefined_variables();
    void add_header();

    LLVMCode(std::string);

private:
    typedef struct
    {
        std::string value;
        std::string basic_block;
    } PhiInfo;

    typedef struct
    {
        ExpressionTerm term;
        std::string string;
    } OperandAndString;

    const std::string tab = "    ";

    std::string llvm_string;
    int num_basic_blocks = 1;
    std::stack<PhiInfo> phi_stack;
    std::stack<ExpressionTerm> operand_stack;
    std::unordered_map<std::string, int> num_assignments_per_variable;
    std::vector<std::string> variables_that_are_used_before_defined;
    std::string current_basic_block;
    std::vector<std::string> basic_blocks_in_execution_order;
    std::stack<std::string> basic_block_stack;
    int tmp_var_num = 0;

    void add_new_basic_block();
    void add_tabs(int);
    void add_line(std::string);
    void add_assignment_line(std::string, std::string);
    void add_opening_bracket_operation(std::string);
    void add_closing_bracket_operation(std::string, bool);
    void add_not_operation(std::string, bool);
    void add_equals_operation(std::string);
    void add_exponent_operation(std::string, bool);
    void add_standard_operation(char, std::string, bool);
    std::string get_operation_string_for_standard_operation(char);
    std::string get_operand_string(ExpressionTerm operand, bool is_being_assigned);
    OperandAndString get_next_operand_and_its_string(bool is_being_assigned);
    OperandAndString get_next_tmp_var_and_its_string();
    OperandAndString get_ambiguous_result_var(bool next_term_is_equal_operator);
    void strip_first_basic_block_label();
    void set_each_undefined_variable_to(std::string, std::vector<std::string>);
    void concatenate_assignments_to_front(LLVMCode);
};