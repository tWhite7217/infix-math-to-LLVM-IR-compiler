define i32 @pow(i32 a, i32 b) {
  %fa = sitofp i32 %a to fp128
  %fres = call fp128 @llvm.powi.f128.i32(%fa, %b)
  %res = fptosi fp128 %fres to i32
  ret i32 %res
}