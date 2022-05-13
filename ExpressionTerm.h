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
    int value;
    std::string text;
    bool is_tmp;

    ExpressionTerm() = default;
    ExpressionTerm(TermType type, int value, std::string text)
        : type(type), value(value), text(text), is_tmp(false) {}
    ExpressionTerm(TermType type, int value, std::string text, bool is_tmp)
        : type(type), value(value), text(text), is_tmp(is_tmp) {}

    bool is_conditional_operator();

    bool is_not_left_parenthesis();
};