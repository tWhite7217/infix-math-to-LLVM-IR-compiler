#include "ExpressionTerm.h"

bool ExpressionTerm::is_conditional_operator()
{
    return (type == TermType::OP) && (value == "?");
}

bool ExpressionTerm::is_not_left_parenthesis()
{
    return (type != TermType::OP) || (value != "(");
}