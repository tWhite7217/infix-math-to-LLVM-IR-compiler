%{
#include <iostream>

#include "LLVMCode.h"

LLVMCode code_body{"#1:\n"};

%}

%%
[\n] {
	}
	
" "[\]+\-*/!^]" =" {
		ExpressionTerm term{TermType::OP, yytext[1], ""};
		code_body.add_operation(term, true);
	}
	
" "[\[\]+\-*/!?=^] {
		ExpressionTerm term{TermType::OP, yytext[1], ""};
		code_body.add_operation(term, false);
	}

" "[0-9]+ {
		ExpressionTerm term{TermType::NUM, atoi(yytext), yytext+1};
		code_body.handle_new_operand(term);
	}

" tmp" { 
		/*This allows users to name a variable "tmp" without conflicting with compilation */
		ExpressionTerm term{TermType::VAR, 0, "-tmp"};
		code_body.handle_new_operand(term);
	}

" "[A-z][A-z0-9_]* {
		ExpressionTerm term{TermType::VAR, 0, yytext+1};
		code_body.handle_new_operand(term);
	}

%%
int yywrap() { /* need this to avoid link problem */
	return 1;
}

int main(int argc, char** argv) {
	if (argc < 3) {
		if (argc < 2) {
			std::cout << "A file must be provided in the command line.\n";
			return 0;
		} else {
			code_body.undefined_variables_are_user_input = false;
		}
	} else {
		code_body.undefined_variables_are_user_input = atoi(argv[2]);
	}
	yyin = fopen(argv[1], "r");
	yylex();
	code_body.fix_basic_blocks();
	code_body.handle_undefined_variables();
	code_body.print();
	return 0;
}
