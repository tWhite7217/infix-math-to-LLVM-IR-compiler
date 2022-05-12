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

    ExpressionTerm() = default;
    ExpressionTerm(TermType type, int value, std::string text) : type(type), value(value), text(text) {}

    bool is_conditional_operator();

    bool is_not_left_parenthesis();
};