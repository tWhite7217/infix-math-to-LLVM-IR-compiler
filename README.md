# infix-math-to-LLVM-IR-compiler

A program to convert a simple "calculator language" to LLVM IR.

Created for the University of Delaware's Compiler Design course.

Two flex files are used. The first converts the calculator code to a "modified-postfix" intermediate representation. The second converts the modified-postfix code to LLVM IR.

All testing was done in WSL2 with LLVM 12 and clang 12 installed.

This program can offer a useful way to see some of the optimzations that can be performed on LLVM IR code.

## How to use

Two bash scripts simplify use of the program.

infix_to_llvm.sh expects two arguments: An input filename for the calculator code and an output filename for the LLVM code.

Example: `./infix_to_llvm.sh testing/infix1.txt output_llvm.ll`

do_opt.sh also expects two arguments: The base name of an LLVM IR file (the part before .ll) and the name of the optimization to be performed.
It will output a \[base name\]\_\[optimization\].ll file containing the optimized code.

Example: `./do_opt.sh output_llvm O3`
