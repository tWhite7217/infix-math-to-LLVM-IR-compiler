# clang-12 -Xclang -disable-O0-optnone -emit-llvm $1.cpp -S -o $1.ll -std=c++17 & clang-12 -Xclang -disable-O0-optnone -emit-llvm $1.cpp -c -o $1.bc -std=c++17
# # clang-12 -emit-llvm $1.cpp -S -o $1.ll -std=c++17 & clang-12 -emit-llvm $1.cpp -c -std=c++17 -o - | sed s/optnone// > $1.bc
# # opt-12 -$2 $1.bc -o $1_$2.bc
# opt-12 -$2 $1.bc -o $1_$2.bc
# llvm-dis-12 $1_$2.bc -o $1_$2.ll

# clang-12 -Xclang -disable-O0-optnone -emit-llvm $1.cpp -S -o $1.ll -std=c++17
opt-12 -$2 $1.ll -S -o $1_$2.ll