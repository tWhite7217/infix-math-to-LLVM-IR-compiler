#pragma once

#include <string>

enum class TermType
{
    OP,
    NUM,
    VAR
};

class ExpressionTerm
{
public:
    TermType type;
    std::string value;
    bool is_tmp;

    ExpressionTerm() = default;
    ExpressionTerm(TermType type, std::string value)
        : type(type), value(value), is_tmp(false) {}
    ExpressionTerm(TermType type, std::string value, bool is_tmp)
        : type(type), value(value), is_tmp(is_tmp) {}

    bool is_conditional_operator();

    bool is_not_left_parenthesis();
};