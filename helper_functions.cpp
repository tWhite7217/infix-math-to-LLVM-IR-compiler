#include "helper_functions.h"

#include <algorithm>

void replace_all_substrings(std::string &entire_string, const std::string old_substring, std::string new_substring)
{
    std::string::size_type pos = entire_string.find(old_substring, 0);
    while (pos != entire_string.npos)
    {
        entire_string.replace(pos, old_substring.length(), new_substring);
        pos = entire_string.find(old_substring, pos + new_substring.length());
    }
}

void ltrim_inplace(std::string &s)
{
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](unsigned char ch)
                                    { return !std::isspace(ch); }));
}

void rtrim_inplace(std::string &s)
{
    s.erase(std::find_if(s.rbegin(), s.rend(), [](unsigned char ch)
                         { return !std::isspace(ch); })
                .base(),
            s.end());
}

std::string ltrim(std::string s)
{
    ltrim_inplace(s);
    return s;
}

std::string rtrim(std::string s)
{
    rtrim_inplace(s);
    return s;
}