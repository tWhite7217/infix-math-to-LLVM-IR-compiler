#include "LLVMCode.h"

LLVMCode::LLVMCode()
{
    basic_block_stack.push("#1");
    add_new_basic_block();
}

void LLVMCode::print()
{
    std::cout << llvm_string;
}

void LLVMCode::handle_new_operand(ExpressionTerm term)
{
    operand_stack.push(term);
    if (term.type == TermType::VAR)
    {
        num_assignments_per_variable.insert({term.text, 0});
    }
}

void LLVMCode::add_operation(ExpressionTerm op, bool next_term_is_equal_operator)
{
    auto [operand2, operand2_string] = get_next_operand_and_its_string(false);

    if (op.value == '[')
    {
        add_opening_bracket_operation(operand2_string);
    }
    else if (op.value == '=')
    {
        add_equals_operation(operand2_string);
    }
    else if (op.value == ']')
    {
        add_closing_bracket_operation(operand2_string, next_term_is_equal_operator);
    }
    else if (op.value == '!')
    {
        add_not_operation(operand2_string, next_term_is_equal_operator);
    }
    else
    {
        add_standard_operation(char(op.value), operand2_string, next_term_is_equal_operator);
    }
}

void LLVMCode::add_opening_bracket_operation(std::string operand2_string)
{
    num_basic_blocks++;
    std::string zero_label = "#" + std::to_string(num_basic_blocks);
    basic_block_stack.push(zero_label);

    num_basic_blocks++;
    std::string nonzero_label = "#" + std::to_string(num_basic_blocks);

    add_line("ifzero(" + operand2_string + ") goto " + zero_label + ";");

    basic_block_stack.push(nonzero_label);
    phi_stack.push({"0", current_basic_block});
    add_new_basic_block();
}

void LLVMCode::add_closing_bracket_operation(std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [tmp_var, tmp_var_string] = get_next_tmp_var_and_its_string();
    PhiInfo phi_arg1 = top_and_pop(phi_stack);
    PhiInfo phi_arg2 = {tmp_var_string, current_basic_block};

    add_line(tmp_var_string + " = " + operand2_string + ";");
    add_new_basic_block();

    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = phi([" + phi_arg1.value + ", " + phi_arg1.basic_block + "], [" + phi_arg2.value + ", " + phi_arg2.basic_block + "]);");
    operand_stack.emplace(result_var);
}

void LLVMCode::add_not_operation(std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = !" + operand2_string + ";");
    operand_stack.emplace(result_var);
}

void LLVMCode::add_equals_operation(std::string operand2_string)
{
    auto [operand1, operand1_string] = get_next_operand_and_its_string(true);
    add_line(operand1_string + " = " + operand2_string + ";");
    operand_stack.emplace(operand1);
}

void LLVMCode::add_standard_operation(char op_value, std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [operand1, operand1_string] = get_next_operand_and_its_string(false);
    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = " + operand1_string + " " + op_value + " " + operand2_string + ";");
    operand_stack.emplace(result_var);
}

std::string LLVMCode::get_operand_string(ExpressionTerm operand, bool is_being_assigned)
{
    if (operand.type == TermType::NUM || operand.is_tmp)
    {
        return operand.text;
    }

    if (is_being_assigned)
    {
        num_assignments_per_variable[operand.text]++;
    }
    else if (num_assignments_per_variable[operand.text] == 0)
    {
        variables_that_are_used_before_defined.push_back(operand.text);
        num_assignments_per_variable[operand.text]++;
    }

    return operand.text + "." + std::to_string(num_assignments_per_variable[operand.text]);
}

LLVMCode::OperandAndString LLVMCode::get_next_operand_and_its_string(bool is_being_assigned)
{
    ExpressionTerm operand = top_and_pop(operand_stack);
    std::string operand_string = get_operand_string(operand, is_being_assigned);
    return {operand, operand_string};
}

LLVMCode::OperandAndString LLVMCode::get_next_tmp_var_and_its_string()
{
    tmp_var_num++;
    std::string tmp_var_text = "tmp." + std::to_string(tmp_var_num);
    ExpressionTerm tmp_var{TermType::VAR, 0, tmp_var_text, true};
    return {tmp_var, tmp_var_text};
}

LLVMCode::OperandAndString LLVMCode::get_ambiguous_result_var(bool next_term_is_equal_operator)
{
    if (next_term_is_equal_operator)
    {
        return get_next_operand_and_its_string(true);
    }
    else
    {
        return get_next_tmp_var_and_its_string();
    }
}

void LLVMCode::add_new_basic_block()
{
    current_basic_block = top_and_pop(basic_block_stack);
    llvm_string += "\n " + current_basic_block + ":\n";
    basic_blocks_in_execution_order.push_back(current_basic_block);
}

void LLVMCode::add_line(std::string line)
{
    add_tabs(1);
    llvm_string += line + "\n";
}

void LLVMCode::add_tabs(int num_tabs)
{
    for (int i = 0; i < num_tabs; i++)
    {
        llvm_string += "    ";
    }
}

void LLVMCode::fix_basic_blocks()
{
    int new_basic_block_num = 1;
    std::string new_basic_block_name;
    for (auto old_basic_block_name : basic_blocks_in_execution_order)
    {
        new_basic_block_name = "BB" + std::to_string(new_basic_block_num);
        replace_all_substrings(llvm_string, old_basic_block_name, new_basic_block_name);
        new_basic_block_num++;
    }
}

void LLVMCode::handle_undefined_variables()
{
    std::string assignments;
    if (undefined_variables_are_user_input)
    {
    }
    else
    {
        for (auto variable : variables_that_are_used_before_defined)
        {
            // assignments += ;
        }
    }
}