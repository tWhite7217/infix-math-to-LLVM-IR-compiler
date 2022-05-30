./infix_to_postfix $1 > .tmp_postfix.txt
./postfix_to_llvm .tmp_postfix.txt > $2
rm .tmp_postfix.txt
