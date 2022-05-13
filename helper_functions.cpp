#include "helper_functions.h"

void replace_all_substrings(std::string &entire_string, const std::string old_substring, std::string new_substring)
{
    std::string::size_type pos = entire_string.find(old_substring, 0);
    while (pos != entire_string.npos)
    {
        entire_string.replace(pos, old_substring.length(), new_substring);
        pos = entire_string.find(old_substring, pos + new_substring.length());
    }
}