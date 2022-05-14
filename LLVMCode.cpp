#include "LLVMCode.h"

LLVMCode::LLVMCode(std::string first_basic_block)
{
    basic_block_stack.push(first_basic_block);
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

    switch (op.value)
    {
    case '[':
        add_opening_bracket_operation(operand2_string);
        break;

    case '=':
        add_equals_operation(operand2_string);
        break;

    case ']':
        add_closing_bracket_operation(operand2_string, next_term_is_equal_operator);
        break;

    case '!':
        add_not_operation(operand2_string, next_term_is_equal_operator);
        break;

    case '^':
        add_exponent_operation(operand2_string, next_term_is_equal_operator);
        break;

    default:
        add_standard_operation(char(op.value), operand2_string, next_term_is_equal_operator);
        break;
    }
}

void LLVMCode::add_opening_bracket_operation(std::string operand2_string)
{
    num_basic_blocks++;
    std::string zero_label = "#" + std::to_string(num_basic_blocks);
    basic_block_stack.push(zero_label);

    num_basic_blocks++;
    std::string nonzero_label = "#" + std::to_string(num_basic_blocks);

    auto [tmp_var, tmp_var_string] = get_next_tmp_var_and_its_string();
    add_line(tmp_var_string + " = icmp eq i32 " + operand2_string + ", 0");
    add_line("br i1 " + tmp_var_string + ", label %" + nonzero_label + ", label %" + zero_label);
    // add_line("if(" + operand2_string + ") goto " + nonzero_label + " else goto " + zero_label + ";");

    basic_block_stack.push(nonzero_label);
    phi_stack.push({"0", "%" + current_basic_block});
    add_new_basic_block();
}

void LLVMCode::add_closing_bracket_operation(std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [tmp_var, tmp_var_string] = get_next_tmp_var_and_its_string();
    PhiInfo phi_arg1 = top_and_pop(phi_stack);
    PhiInfo phi_arg2 = {tmp_var_string, "%" + current_basic_block};

    add_line(tmp_var_string + " = or i32 " + operand2_string + ", 0");
    add_line("br label %" + basic_block_stack.top());
    add_new_basic_block();

    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = phi i32 [" + phi_arg1.value + ", " + phi_arg1.basic_block + "], [" + phi_arg2.value + ", " + phi_arg2.basic_block + "]");
    operand_stack.emplace(result_var);
}

void LLVMCode::add_assignment_line(std::string result_var_string, std::string value)
{
    add_line(result_var_string + " = or i32 " + value + ", 0");
}

void LLVMCode::add_not_operation(std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = xor i32 " + operand2_string + ", -1");
    operand_stack.emplace(result_var);
}

void LLVMCode::add_equals_operation(std::string operand2_string)
{
    auto [operand1, operand1_string] = get_next_operand_and_its_string(true);
    add_assignment_line(operand1_string, operand2_string);
    operand_stack.emplace(operand1);
}

void LLVMCode::add_exponent_operation(std::string operand2_string, bool next_term_is_equal_operator)
{
    auto [operand1, operand1_string] = get_next_operand_and_its_string(false);
    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = call i32 @pow(i32 " + operand1_string + ", i32 " + operand2_string + ")");
    operand_stack.emplace(result_var);
}

void LLVMCode::add_standard_operation(char op_value, std::string operand2_string, bool next_term_is_equal_operator)
{
    std::string operation_string = get_operation_string_for_standard_operation(op_value);
    auto [operand1, operand1_string] = get_next_operand_and_its_string(false);
    auto [result_var, result_var_string] = get_ambiguous_result_var(next_term_is_equal_operator);
    add_line(result_var_string + " = " + operation_string + " i32 " + operand1_string + ", " + operand2_string);
    operand_stack.emplace(result_var);
}

std::string LLVMCode::get_operation_string_for_standard_operation(char op_value)
{
    switch (op_value)
    {
    case '+':
        return "add";
    case '-':
        return "sub";
    case '*':
        return "mul";
    case '/':
        return "sdiv";
    default:
        std::cout << "Unknown standard operator.\n";
        exit(1);
    }
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

    return "%" + operand.text + "." + std::to_string(num_assignments_per_variable[operand.text]);
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
    std::string tmp_var_text = "%tmp." + std::to_string(tmp_var_num);
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
    llvm_string += "\n" + current_basic_block + ":\n";
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
        llvm_string += tab;
    }
}

void LLVMCode::fix_basic_blocks()
{
    int new_basic_block_num = 1;
    std::string new_basic_block_name;
    for (auto old_basic_block_name : basic_blocks_in_execution_order)
    {
        new_basic_block_name = "BB-" + std::to_string(new_basic_block_num);
        replace_all_substrings(llvm_string, old_basic_block_name, new_basic_block_name);
        new_basic_block_num++;
    }
}

void LLVMCode::handle_undefined_variables()
{
    strip_first_basic_block_label();

    LLVMCode assignments{"BB-1"};
    if (undefined_variables_are_user_input)
    {
        assignments.set_each_undefined_variable_to("get_user_input()", variables_that_are_used_before_defined);
    }
    else
    {
        assignments.set_each_undefined_variable_to("0", variables_that_are_used_before_defined);
    }
    concatenate_assignments_to_front(assignments);
}

void LLVMCode::strip_first_basic_block_label()
{
    auto basic_block_label_endpoint = llvm_string.find(":\n") + 1;
    llvm_string.erase(0, basic_block_label_endpoint);
}

void LLVMCode::set_each_undefined_variable_to(std::string value, std::vector<std::string> undefined_variables)
{
    for (auto variable : undefined_variables)
    {
        add_assignment_line("%" + variable + ".1", value);
    }
}

void LLVMCode::concatenate_assignments_to_front(LLVMCode assignments)
{
    llvm_string = rtrim(assignments.get_code()) + "\n" + tab + ltrim(llvm_string);
}

void LLVMCode::add_header_and_footer()
{
    std::string variable_string_constants = get_varaiable_string_constants();
    std::string header = get_header_with_string_constants(variable_string_constants);
    llvm_string = header + llvm_string + footer;
}

std::string LLVMCode::get_varaiable_string_constants()
{
    std::string variable_string_constants;
    for (auto [variable_name, num_assignments] : num_assignments_per_variable)
    {
        std::string length_string = std::to_string(variable_name.length() + 1);
        variable_string_constants += "@." + variable_name + " = private unnamed_addr constant [" + length_string + " x i8] c\"" + variable_name + "\\00\", align 1\n";
    }
    return variable_string_constants;
}

std::string LLVMCode::get_header_with_string_constants(std::string variable_string_constants)
{
    return header_start + variable_string_constants + header_end;
}

void LLVMCode::add_variable_printfs()
{
    for (auto [variable_name, num_assignments] : num_assignments_per_variable)
    {
        std::string length_string = std::to_string(variable_name.length() + 1);
        std::string variable_last_assignment = "%" + variable_name + "." + std::to_string(num_assignments);
        auto last_assignment_string_pos = llvm_string.find(variable_last_assignment + " = ");
        auto newline_pos_after_last_assignment = llvm_string.find("\n", last_assignment_string_pos);
        auto pos_to_insert = newline_pos_after_last_assignment + 1;
        std::string printf_line = tab + "call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.format_string, i64 0, i64 0), i8* getelementptr inbounds ([" + length_string + " x i8], [" + length_string + " x i8]* @." + variable_name + ", i64 0, i64 0), i32 " + variable_last_assignment + ")\n";
        llvm_string.insert(pos_to_insert, printf_line);
    }
}

std::string LLVMCode::get_code()
{
    return llvm_string;
}