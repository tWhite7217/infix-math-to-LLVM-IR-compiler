postfix_to_llvm: postfix_to_llvm.l ExpressionTerm.cpp
	flex -o lex.yy.1.c postfix_to_llvm.l; g++ -o postfix_to_llvm lex.yy.1.c ExpressionTerm.cpp -lboost_system -fconcepts -std=c++17

infix_to_postfix: infix_to_postfix.l ExpressionTerm.cpp
	flex infix_to_postfix.l; g++ -o infix_to_postfix lex.yy.c ExpressionTerm.cpp -lboost_system -fconcepts -std=c++17

clean:
	rm -f p2 infix_to_postfix.output *.o infix_to_postfix.tab.c lex.yy.c lex.yy.1.c infix_to_postfix infix_to_postfix.tab.h postfix_to_llvm
