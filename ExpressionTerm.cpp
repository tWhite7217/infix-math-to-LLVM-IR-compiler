#include "ExpressionTerm.h"

bool ExpressionTerm::is_conditional_operator()
{
    return value == "?";
}

bool ExpressionTerm::is_not_left_parenthesis()
{
    return value != "(";
}