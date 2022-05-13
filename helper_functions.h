#pragma once

#include <stack>
#include <string>

template <typename T>
T top_and_pop(std::stack<T> &stack)
{
    T top = stack.top();
    stack.pop();
    return top;
}

void replace_all_substrings(std::string &, const std::string, std::string);
void ltrim_inplace(std::string &s);
void rtrim_inplace(std::string &s);
std::string ltrim(std::string s);
std::string rtrim(std::string s);