; ModuleID = 'sudoku.cpp'
source_filename = "sudoku.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@board = dso_local global [9 x [9 x i32]] zeroinitializer, align 16
@.str = private unnamed_addr constant [10 x i8] c"******3**\00", align 1
@.str.1 = private unnamed_addr constant [10 x i8] c"*8***3**9\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"*24*7**86\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"9****54*8\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"***4*2***\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"1*69****5\00", align 1
@.str.6 = private unnamed_addr constant [10 x i8] c"56**3*14*\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"4**5***9*\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"**7******\00", align 1
@easy_board_init = dso_local global [9 x i8*] [i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i32 0, i32 0)], align 16
@.str.9 = private unnamed_addr constant [10 x i8] c"*94******\00", align 1
@.str.10 = private unnamed_addr constant [10 x i8] c"1**79****\00", align 1
@.str.11 = private unnamed_addr constant [10 x i8] c"**3*86**1\00", align 1
@.str.12 = private unnamed_addr constant [10 x i8] c"92*****3*\00", align 1
@.str.13 = private unnamed_addr constant [10 x i8] c"****7****\00", align 1
@.str.14 = private unnamed_addr constant [10 x i8] c"*8*****25\00", align 1
@.str.15 = private unnamed_addr constant [10 x i8] c"4**52*9**\00", align 1
@.str.16 = private unnamed_addr constant [10 x i8] c"****61**3\00", align 1
@.str.17 = private unnamed_addr constant [10 x i8] c"******64*\00", align 1
@hard_board_init = dso_local global [9 x i8*] [i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.10, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.12, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.13, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.15, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.16, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.17, i32 0, i32 0)], align 16
@.str.18 = private unnamed_addr constant [10 x i8] c"*3*2****6\00", align 1
@.str.19 = private unnamed_addr constant [10 x i8] c"*****9**4\00", align 1
@.str.20 = private unnamed_addr constant [10 x i8] c"76*******\00", align 1
@.str.21 = private unnamed_addr constant [10 x i8] c"****5*7**\00", align 1
@.str.22 = private unnamed_addr constant [10 x i8] c"*****186*\00", align 1
@.str.23 = private unnamed_addr constant [10 x i8] c"*5*48**9*\00", align 1
@.str.24 = private unnamed_addr constant [10 x i8] c"8********\00", align 1
@.str.25 = private unnamed_addr constant [10 x i8] c"****76***\00", align 1
@.str.26 = private unnamed_addr constant [10 x i8] c"*75**81**\00", align 1
@third_board_init = dso_local global [9 x i8*] [i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.18, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.19, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.20, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.21, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.22, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.23, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.24, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.25, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.26, i32 0, i32 0)], align 16
@.str.27 = private unnamed_addr constant [3 x i8] c"%c\00", align 1
@.str.28 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.29 = private unnamed_addr constant [10 x i8] c"SUCCESS!\0A\00", align 1
@.str.30 = private unnamed_addr constant [9 x i8] c"FAILED!\0A\00", align 1
@.str.31 = private unnamed_addr constant [22 x i8] c"bit_count(0x34) = %d\0A\00", align 1
@.str.32 = private unnamed_addr constant [23 x i8] c"bit_count(0x1ff) = %d\0A\00", align 1
@.str.33 = private unnamed_addr constant [31 x i8] c"get_nth_set_bit(0x34, 1) = %d\0A\00", align 1
@.str.34 = private unnamed_addr constant [22 x i8] c"singleton(0x40) = %s\0A\00", align 1
@.str.35 = private unnamed_addr constant [5 x i8] c"TRUE\00", align 1
@.str.36 = private unnamed_addr constant [6 x i8] c"FALSE\00", align 1
@.str.37 = private unnamed_addr constant [27 x i8] c"get_singleton(0x40) = %d\0A\0A\00", align 1
@.str.38 = private unnamed_addr constant [13 x i8] c"EASY BOARD:\0A\00", align 1
@.str.39 = private unnamed_addr constant [13 x i8] c"HARD BOARD:\0A\00", align 1
@.str.40 = private unnamed_addr constant [15 x i8] c"THIRD BOARD: \0A\00", align 1

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local void @_Z10init_boardPPc(i8** %0) #0 {
  %2 = alloca i8**, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8, align 1
  store i8** %0, i8*** %2, align 8
  store i32 0, i32* %3, align 4
  br label %6

6:                                                ; preds = %50, %1
  %7 = load i32, i32* %3, align 4
  %8 = icmp slt i32 %7, 9
  br i1 %8, label %9, label %53

9:                                                ; preds = %6
  store i32 0, i32* %4, align 4
  br label %10

10:                                               ; preds = %46, %9
  %11 = load i32, i32* %4, align 4
  %12 = icmp slt i32 %11, 9
  br i1 %12, label %13, label %49

13:                                               ; preds = %10
  %14 = load i8**, i8*** %2, align 8
  %15 = load i32, i32* %3, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds i8*, i8** %14, i64 %16
  %18 = load i8*, i8** %17, align 8
  %19 = load i32, i32* %4, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds i8, i8* %18, i64 %20
  %22 = load i8, i8* %21, align 1
  store i8 %22, i8* %5, align 1
  %23 = load i8, i8* %5, align 1
  %24 = sext i8 %23 to i32
  %25 = icmp eq i32 %24, 42
  br i1 %25, label %26, label %33

26:                                               ; preds = %13
  %27 = load i32, i32* %3, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %28
  %30 = load i32, i32* %4, align 4
  %31 = sext i32 %30 to i64
  %32 = getelementptr inbounds [9 x i32], [9 x i32]* %29, i64 0, i64 %31
  store i32 511, i32* %32, align 4
  br label %45

33:                                               ; preds = %13
  %34 = load i8, i8* %5, align 1
  %35 = sext i8 %34 to i32
  %36 = sub nsw i32 %35, 48
  %37 = sub nsw i32 %36, 1
  %38 = shl i32 1, %37
  %39 = load i32, i32* %3, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %40
  %42 = load i32, i32* %4, align 4
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds [9 x i32], [9 x i32]* %41, i64 0, i64 %43
  store i32 %38, i32* %44, align 4
  br label %45

45:                                               ; preds = %33, %26
  br label %46

46:                                               ; preds = %45
  %47 = load i32, i32* %4, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, i32* %4, align 4
  br label %10, !llvm.loop !2

49:                                               ; preds = %10
  br label %50

50:                                               ; preds = %49
  %51 = load i32, i32* %3, align 4
  %52 = add nsw i32 %51, 1
  store i32 %52, i32* %3, align 4
  br label %6, !llvm.loop !4

53:                                               ; preds = %6
  ret void
}

; Function Attrs: noinline uwtable mustprogress
define dso_local zeroext i1 @_Z10board_donePA9_i([9 x i32]* %0) #1 {
  %2 = alloca i1, align 1
  %3 = alloca [9 x i32]*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store [9 x i32]* %0, [9 x i32]** %3, align 8
  store i32 0, i32* %4, align 4
  br label %6

6:                                                ; preds = %29, %1
  %7 = load i32, i32* %4, align 4
  %8 = icmp slt i32 %7, 9
  br i1 %8, label %9, label %32

9:                                                ; preds = %6
  store i32 0, i32* %5, align 4
  br label %10

10:                                               ; preds = %25, %9
  %11 = load i32, i32* %5, align 4
  %12 = icmp slt i32 %11, 9
  br i1 %12, label %13, label %28

13:                                               ; preds = %10
  %14 = load [9 x i32]*, [9 x i32]** %3, align 8
  %15 = load i32, i32* %4, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [9 x i32], [9 x i32]* %14, i64 %16
  %18 = load i32, i32* %5, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [9 x i32], [9 x i32]* %17, i64 0, i64 %19
  %21 = load i32, i32* %20, align 4
  %22 = call zeroext i1 @_Z9singletoni(i32 %21)
  br i1 %22, label %24, label %23

23:                                               ; preds = %13
  store i1 false, i1* %2, align 1
  br label %33

24:                                               ; preds = %13
  br label %25

25:                                               ; preds = %24
  %26 = load i32, i32* %5, align 4
  %27 = add nsw i32 %26, 1
  store i32 %27, i32* %5, align 4
  br label %10, !llvm.loop !5

28:                                               ; preds = %10
  br label %29

29:                                               ; preds = %28
  %30 = load i32, i32* %4, align 4
  %31 = add nsw i32 %30, 1
  store i32 %31, i32* %4, align 4
  br label %6, !llvm.loop !6

32:                                               ; preds = %6
  store i1 true, i1* %2, align 1
  br label %33

33:                                               ; preds = %32, %23
  %34 = load i1, i1* %2, align 1
  ret i1 %34
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local zeroext i1 @_Z9singletoni(i32 %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = and i32 %3, 511
  store i32 %4, i32* %2, align 4
  %5 = load i32, i32* %2, align 4
  %6 = icmp sgt i32 %5, 0
  br i1 %6, label %7, label %14

7:                                                ; preds = %1
  %8 = load i32, i32* %2, align 4
  %9 = load i32, i32* %2, align 4
  %10 = sub nsw i32 %9, 1
  %11 = and i32 %8, %10
  %12 = icmp ne i32 %11, 0
  %13 = xor i1 %12, true
  br label %14

14:                                               ; preds = %7, %1
  %15 = phi i1 [ false, %1 ], [ %13, %7 ]
  ret i1 %15
}

; Function Attrs: noinline uwtable mustprogress
define dso_local void @_Z11print_boardPA9_i([9 x i32]* %0) #1 {
  %2 = alloca [9 x i32]*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  store [9 x i32]* %0, [9 x i32]** %2, align 8
  store i32 0, i32* %3, align 4
  br label %7

7:                                                ; preds = %39, %1
  %8 = load i32, i32* %3, align 4
  %9 = icmp slt i32 %8, 9
  br i1 %9, label %10, label %42

10:                                               ; preds = %7
  store i32 0, i32* %4, align 4
  br label %11

11:                                               ; preds = %34, %10
  %12 = load i32, i32* %4, align 4
  %13 = icmp slt i32 %12, 9
  br i1 %13, label %14, label %37

14:                                               ; preds = %11
  %15 = load [9 x i32]*, [9 x i32]** %2, align 8
  %16 = load i32, i32* %3, align 4
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds [9 x i32], [9 x i32]* %15, i64 %17
  %19 = load i32, i32* %4, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds [9 x i32], [9 x i32]* %18, i64 0, i64 %20
  %22 = load i32, i32* %21, align 4
  store i32 %22, i32* %5, align 4
  store i8 42, i8* %6, align 1
  %23 = load i32, i32* %5, align 4
  %24 = call zeroext i1 @_Z9singletoni(i32 %23)
  br i1 %24, label %25, label %30

25:                                               ; preds = %14
  %26 = load i32, i32* %5, align 4
  %27 = call i32 @_Z13get_singletoni(i32 %26)
  %28 = add nsw i32 %27, 49
  %29 = trunc i32 %28 to i8
  store i8 %29, i8* %6, align 1
  br label %30

30:                                               ; preds = %25, %14
  %31 = load i8, i8* %6, align 1
  %32 = sext i8 %31 to i32
  %33 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.27, i64 0, i64 0), i32 %32)
  br label %34

34:                                               ; preds = %30
  %35 = load i32, i32* %4, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, i32* %4, align 4
  br label %11, !llvm.loop !7

37:                                               ; preds = %11
  %38 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28, i64 0, i64 0))
  br label %39

39:                                               ; preds = %37
  %40 = load i32, i32* %3, align 4
  %41 = add nsw i32 %40, 1
  store i32 %41, i32* %3, align 4
  br label %7, !llvm.loop !8

42:                                               ; preds = %7
  ret void
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local i32 @_Z13get_singletoni(i32 %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  store i32 %0, i32* %3, align 4
  store i8 0, i8* %4, align 1
  br label %5

5:                                                ; preds = %19, %1
  %6 = load i8, i8* %4, align 1
  %7 = sext i8 %6 to i32
  %8 = icmp slt i32 %7, 9
  br i1 %8, label %9, label %22

9:                                                ; preds = %5
  %10 = load i32, i32* %3, align 4
  %11 = srem i32 %10, 2
  %12 = icmp ne i32 %11, 0
  br i1 %12, label %13, label %16

13:                                               ; preds = %9
  %14 = load i8, i8* %4, align 1
  %15 = sext i8 %14 to i32
  store i32 %15, i32* %2, align 4
  br label %23

16:                                               ; preds = %9
  %17 = load i32, i32* %3, align 4
  %18 = ashr i32 %17, 1
  store i32 %18, i32* %3, align 4
  br label %19

19:                                               ; preds = %16
  %20 = load i8, i8* %4, align 1
  %21 = add i8 %20, 1
  store i8 %21, i8* %4, align 1
  br label %5, !llvm.loop !9

22:                                               ; preds = %5
  store i32 -1, i32* %2, align 4
  br label %23

23:                                               ; preds = %22, %13
  %24 = load i32, i32* %2, align 4
  ret i32 %24
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline uwtable mustprogress
define dso_local void @_Z19print_board_verbosev() #1 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i8, align 1
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  store i32 0, i32* %1, align 4
  br label %7

7:                                                ; preds = %61, %0
  %8 = load i32, i32* %1, align 4
  %9 = icmp slt i32 %8, 9
  br i1 %9, label %10, label %64

10:                                               ; preds = %7
  store i32 0, i32* %2, align 4
  br label %11

11:                                               ; preds = %57, %10
  %12 = load i32, i32* %2, align 4
  %13 = icmp slt i32 %12, 9
  br i1 %13, label %14, label %60

14:                                               ; preds = %11
  %15 = load i32, i32* %1, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %16
  %18 = load i32, i32* %2, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [9 x i32], [9 x i32]* %17, i64 0, i64 %19
  %21 = load i32, i32* %20, align 4
  store i32 %21, i32* %3, align 4
  store i8 32, i8* %4, align 1
  %22 = load i32, i32* %3, align 4
  %23 = call zeroext i1 @_Z9singletoni(i32 %22)
  br i1 %23, label %24, label %25

24:                                               ; preds = %14
  store i8 42, i8* %4, align 1
  br label %25

25:                                               ; preds = %24, %14
  store i32 0, i32* %5, align 4
  br label %26

26:                                               ; preds = %47, %25
  %27 = load i32, i32* %5, align 4
  %28 = icmp slt i32 %27, 9
  br i1 %28, label %29, label %50

29:                                               ; preds = %26
  %30 = load i32, i32* %3, align 4
  %31 = load i32, i32* %5, align 4
  %32 = shl i32 1, %31
  %33 = and i32 %30, %32
  %34 = icmp ne i32 %33, 0
  br i1 %34, label %35, label %38

35:                                               ; preds = %29
  %36 = load i32, i32* %5, align 4
  %37 = add nsw i32 49, %36
  br label %41

38:                                               ; preds = %29
  %39 = load i8, i8* %4, align 1
  %40 = sext i8 %39 to i32
  br label %41

41:                                               ; preds = %38, %35
  %42 = phi i32 [ %37, %35 ], [ %40, %38 ]
  %43 = trunc i32 %42 to i8
  store i8 %43, i8* %6, align 1
  %44 = load i8, i8* %6, align 1
  %45 = sext i8 %44 to i32
  %46 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.27, i64 0, i64 0), i32 %45)
  br label %47

47:                                               ; preds = %41
  %48 = load i32, i32* %5, align 4
  %49 = add nsw i32 %48, 1
  store i32 %49, i32* %5, align 4
  br label %26, !llvm.loop !10

50:                                               ; preds = %26
  %51 = load i32, i32* %2, align 4
  %52 = icmp eq i32 %51, 8
  %53 = zext i1 %52 to i64
  %54 = select i1 %52, i8 10, i8 124
  %55 = sext i8 %54 to i32
  %56 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.27, i64 0, i64 0), i32 %55)
  br label %57

57:                                               ; preds = %50
  %58 = load i32, i32* %2, align 4
  %59 = add nsw i32 %58, 1
  store i32 %59, i32* %2, align 4
  br label %11, !llvm.loop !11

60:                                               ; preds = %11
  br label %61

61:                                               ; preds = %60
  %62 = load i32, i32* %1, align 4
  %63 = add nsw i32 %62, 1
  store i32 %63, i32* %1, align 4
  br label %7, !llvm.loop !12

64:                                               ; preds = %7
  ret void
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local i32 @_Z16get_square_begini(i32 %0) #0 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = sdiv i32 %3, 3
  %5 = mul nsw i32 %4, 3
  ret i32 %5
}

; Function Attrs: noinline uwtable mustprogress
define dso_local zeroext i1 @_Z5rule1v() #1 {
  %1 = alloca i8, align 1
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i8 0, i8* %1, align 1
  store i32 0, i32* %2, align 4
  br label %10

10:                                               ; preds = %152, %0
  %11 = load i32, i32* %2, align 4
  %12 = icmp slt i32 %11, 9
  br i1 %12, label %13, label %155

13:                                               ; preds = %10
  store i32 0, i32* %3, align 4
  br label %14

14:                                               ; preds = %148, %13
  %15 = load i32, i32* %3, align 4
  %16 = icmp slt i32 %15, 9
  br i1 %16, label %17, label %151

17:                                               ; preds = %14
  %18 = load i32, i32* %2, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %19
  %21 = load i32, i32* %3, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [9 x i32], [9 x i32]* %20, i64 0, i64 %22
  %24 = load i32, i32* %23, align 4
  store i32 %24, i32* %4, align 4
  %25 = load i32, i32* %4, align 4
  %26 = call zeroext i1 @_Z9singletoni(i32 %25)
  br i1 %26, label %27, label %147

27:                                               ; preds = %17
  store i32 0, i32* %5, align 4
  br label %28

28:                                               ; preds = %86, %27
  %29 = load i32, i32* %5, align 4
  %30 = icmp slt i32 %29, 9
  br i1 %30, label %31, label %89

31:                                               ; preds = %28
  %32 = load i32, i32* %5, align 4
  %33 = load i32, i32* %3, align 4
  %34 = icmp ne i32 %32, %33
  br i1 %34, label %35, label %58

35:                                               ; preds = %31
  %36 = load i32, i32* %2, align 4
  %37 = sext i32 %36 to i64
  %38 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %37
  %39 = load i32, i32* %5, align 4
  %40 = sext i32 %39 to i64
  %41 = getelementptr inbounds [9 x i32], [9 x i32]* %38, i64 0, i64 %40
  %42 = load i32, i32* %41, align 4
  %43 = load i32, i32* %4, align 4
  %44 = and i32 %42, %43
  %45 = icmp ne i32 %44, 0
  br i1 %45, label %46, label %47

46:                                               ; preds = %35
  store i8 1, i8* %1, align 1
  br label %47

47:                                               ; preds = %46, %35
  %48 = load i32, i32* %4, align 4
  %49 = xor i32 %48, -1
  %50 = load i32, i32* %2, align 4
  %51 = sext i32 %50 to i64
  %52 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %51
  %53 = load i32, i32* %5, align 4
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds [9 x i32], [9 x i32]* %52, i64 0, i64 %54
  %56 = load i32, i32* %55, align 4
  %57 = and i32 %56, %49
  store i32 %57, i32* %55, align 4
  br label %58

58:                                               ; preds = %47, %31
  %59 = load i32, i32* %5, align 4
  %60 = load i32, i32* %2, align 4
  %61 = icmp ne i32 %59, %60
  br i1 %61, label %62, label %85

62:                                               ; preds = %58
  %63 = load i32, i32* %5, align 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %64
  %66 = load i32, i32* %3, align 4
  %67 = sext i32 %66 to i64
  %68 = getelementptr inbounds [9 x i32], [9 x i32]* %65, i64 0, i64 %67
  %69 = load i32, i32* %68, align 4
  %70 = load i32, i32* %4, align 4
  %71 = and i32 %69, %70
  %72 = icmp ne i32 %71, 0
  br i1 %72, label %73, label %74

73:                                               ; preds = %62
  store i8 1, i8* %1, align 1
  br label %74

74:                                               ; preds = %73, %62
  %75 = load i32, i32* %4, align 4
  %76 = xor i32 %75, -1
  %77 = load i32, i32* %5, align 4
  %78 = sext i32 %77 to i64
  %79 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %78
  %80 = load i32, i32* %3, align 4
  %81 = sext i32 %80 to i64
  %82 = getelementptr inbounds [9 x i32], [9 x i32]* %79, i64 0, i64 %81
  %83 = load i32, i32* %82, align 4
  %84 = and i32 %83, %76
  store i32 %84, i32* %82, align 4
  br label %85

85:                                               ; preds = %74, %58
  br label %86

86:                                               ; preds = %85
  %87 = load i32, i32* %5, align 4
  %88 = add nsw i32 %87, 1
  store i32 %88, i32* %5, align 4
  br label %28, !llvm.loop !13

89:                                               ; preds = %28
  %90 = load i32, i32* %2, align 4
  %91 = call i32 @_Z16get_square_begini(i32 %90)
  store i32 %91, i32* %6, align 4
  %92 = load i32, i32* %3, align 4
  %93 = call i32 @_Z16get_square_begini(i32 %92)
  store i32 %93, i32* %7, align 4
  %94 = load i32, i32* %6, align 4
  store i32 %94, i32* %8, align 4
  br label %95

95:                                               ; preds = %143, %89
  %96 = load i32, i32* %8, align 4
  %97 = load i32, i32* %6, align 4
  %98 = add nsw i32 %97, 3
  %99 = icmp slt i32 %96, %98
  br i1 %99, label %100, label %146

100:                                              ; preds = %95
  %101 = load i32, i32* %7, align 4
  store i32 %101, i32* %9, align 4
  br label %102

102:                                              ; preds = %139, %100
  %103 = load i32, i32* %9, align 4
  %104 = load i32, i32* %7, align 4
  %105 = add nsw i32 %104, 3
  %106 = icmp slt i32 %103, %105
  br i1 %106, label %107, label %142

107:                                              ; preds = %102
  %108 = load i32, i32* %8, align 4
  %109 = load i32, i32* %2, align 4
  %110 = icmp eq i32 %108, %109
  br i1 %110, label %111, label %116

111:                                              ; preds = %107
  %112 = load i32, i32* %9, align 4
  %113 = load i32, i32* %3, align 4
  %114 = icmp eq i32 %112, %113
  br i1 %114, label %115, label %116

115:                                              ; preds = %111
  br label %139

116:                                              ; preds = %111, %107
  %117 = load i32, i32* %8, align 4
  %118 = sext i32 %117 to i64
  %119 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %118
  %120 = load i32, i32* %9, align 4
  %121 = sext i32 %120 to i64
  %122 = getelementptr inbounds [9 x i32], [9 x i32]* %119, i64 0, i64 %121
  %123 = load i32, i32* %122, align 4
  %124 = load i32, i32* %4, align 4
  %125 = and i32 %123, %124
  %126 = icmp ne i32 %125, 0
  br i1 %126, label %127, label %128

127:                                              ; preds = %116
  store i8 1, i8* %1, align 1
  br label %128

128:                                              ; preds = %127, %116
  %129 = load i32, i32* %4, align 4
  %130 = xor i32 %129, -1
  %131 = load i32, i32* %8, align 4
  %132 = sext i32 %131 to i64
  %133 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %132
  %134 = load i32, i32* %9, align 4
  %135 = sext i32 %134 to i64
  %136 = getelementptr inbounds [9 x i32], [9 x i32]* %133, i64 0, i64 %135
  %137 = load i32, i32* %136, align 4
  %138 = and i32 %137, %130
  store i32 %138, i32* %136, align 4
  br label %139

139:                                              ; preds = %128, %115
  %140 = load i32, i32* %9, align 4
  %141 = add nsw i32 %140, 1
  store i32 %141, i32* %9, align 4
  br label %102, !llvm.loop !14

142:                                              ; preds = %102
  br label %143

143:                                              ; preds = %142
  %144 = load i32, i32* %8, align 4
  %145 = add nsw i32 %144, 1
  store i32 %145, i32* %8, align 4
  br label %95, !llvm.loop !15

146:                                              ; preds = %95
  br label %147

147:                                              ; preds = %146, %17
  br label %148

148:                                              ; preds = %147
  %149 = load i32, i32* %3, align 4
  %150 = add nsw i32 %149, 1
  store i32 %150, i32* %3, align 4
  br label %14, !llvm.loop !16

151:                                              ; preds = %14
  br label %152

152:                                              ; preds = %151
  %153 = load i32, i32* %2, align 4
  %154 = add nsw i32 %153, 1
  store i32 %154, i32* %2, align 4
  br label %10, !llvm.loop !17

155:                                              ; preds = %10
  %156 = load i8, i8* %1, align 1
  %157 = trunc i8 %156 to i1
  ret i1 %157
}

; Function Attrs: noinline uwtable mustprogress
define dso_local zeroext i1 @_Z5solvePPc(i8** %0) #1 {
  %2 = alloca i1, align 1
  %3 = alloca i8**, align 8
  %4 = alloca i8, align 1
  store i8** %0, i8*** %3, align 8
  %5 = load i8**, i8*** %3, align 8
  call void @_Z10init_boardPPc(i8** %5)
  br label %6

6:                                                ; preds = %17, %1
  %7 = call zeroext i1 @_Z5rule1v()
  %8 = zext i1 %7 to i8
  store i8 %8, i8* %4, align 1
  %9 = call zeroext i1 @_Z5rule2v()
  %10 = zext i1 %9 to i32
  %11 = load i8, i8* %4, align 1
  %12 = trunc i8 %11 to i1
  %13 = zext i1 %12 to i32
  %14 = or i32 %13, %10
  %15 = icmp ne i32 %14, 0
  %16 = zext i1 %15 to i8
  store i8 %16, i8* %4, align 1
  br label %17

17:                                               ; preds = %6
  %18 = load i8, i8* %4, align 1
  %19 = trunc i8 %18 to i1
  br i1 %19, label %6, label %20, !llvm.loop !18

20:                                               ; preds = %17
  %21 = call zeroext i1 @_Z10board_donePA9_i([9 x i32]* getelementptr inbounds ([9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 0))
  br i1 %21, label %22, label %25

22:                                               ; preds = %20
  %23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.29, i64 0, i64 0))
  call void @_Z11print_boardPA9_i([9 x i32]* getelementptr inbounds ([9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 0))
  %24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28, i64 0, i64 0))
  store i1 true, i1* %2, align 1
  br label %28

25:                                               ; preds = %20
  %26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.30, i64 0, i64 0))
  call void @_Z19print_board_verbosev()
  %27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.28, i64 0, i64 0))
  store i1 false, i1* %2, align 1
  br label %28

28:                                               ; preds = %25, %22
  %29 = load i1, i1* %2, align 1
  ret i1 %29
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local zeroext i1 @_Z5rule2v() #0 {
  %1 = alloca i8, align 1
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i8 0, i8* %1, align 1
  store i32 0, i32* %3, align 4
  br label %12

12:                                               ; preds = %162, %0
  %13 = load i32, i32* %3, align 4
  %14 = icmp slt i32 %13, 9
  br i1 %14, label %15, label %165

15:                                               ; preds = %12
  store i32 0, i32* %5, align 4
  br label %16

16:                                               ; preds = %158, %15
  %17 = load i32, i32* %5, align 4
  %18 = icmp slt i32 %17, 9
  br i1 %18, label %19, label %161

19:                                               ; preds = %16
  store i32 0, i32* %4, align 4
  store i32 0, i32* %6, align 4
  store i32 0, i32* %8, align 4
  %20 = load i32, i32* %3, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %21
  %23 = load i32, i32* %5, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds [9 x i32], [9 x i32]* %22, i64 0, i64 %24
  %26 = load i32, i32* %25, align 4
  store i32 %26, i32* %2, align 4
  %27 = load i32, i32* %2, align 4
  %28 = call zeroext i1 @_Z9singletoni(i32 %27)
  br i1 %28, label %157, label %29

29:                                               ; preds = %19
  store i32 0, i32* %7, align 4
  br label %30

30:                                               ; preds = %48, %29
  %31 = load i32, i32* %7, align 4
  %32 = icmp slt i32 %31, 9
  br i1 %32, label %33, label %51

33:                                               ; preds = %30
  %34 = load i32, i32* %7, align 4
  %35 = load i32, i32* %3, align 4
  %36 = icmp ne i32 %34, %35
  br i1 %36, label %37, label %47

37:                                               ; preds = %33
  %38 = load i32, i32* %7, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %39
  %41 = load i32, i32* %5, align 4
  %42 = sext i32 %41 to i64
  %43 = getelementptr inbounds [9 x i32], [9 x i32]* %40, i64 0, i64 %42
  %44 = load i32, i32* %43, align 4
  %45 = load i32, i32* %4, align 4
  %46 = or i32 %45, %44
  store i32 %46, i32* %4, align 4
  br label %47

47:                                               ; preds = %37, %33
  br label %48

48:                                               ; preds = %47
  %49 = load i32, i32* %7, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %7, align 4
  br label %30, !llvm.loop !19

51:                                               ; preds = %30
  %52 = load i32, i32* %4, align 4
  %53 = xor i32 %52, -1
  %54 = call zeroext i1 @_Z9singletoni(i32 %53)
  br i1 %54, label %55, label %64

55:                                               ; preds = %51
  %56 = load i32, i32* %4, align 4
  %57 = xor i32 %56, -1
  %58 = load i32, i32* %3, align 4
  %59 = sext i32 %58 to i64
  %60 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %59
  %61 = load i32, i32* %5, align 4
  %62 = sext i32 %61 to i64
  %63 = getelementptr inbounds [9 x i32], [9 x i32]* %60, i64 0, i64 %62
  store i32 %57, i32* %63, align 4
  store i8 1, i8* %1, align 1
  br label %64

64:                                               ; preds = %55, %51
  store i32 0, i32* %7, align 4
  br label %65

65:                                               ; preds = %83, %64
  %66 = load i32, i32* %7, align 4
  %67 = icmp slt i32 %66, 9
  br i1 %67, label %68, label %86

68:                                               ; preds = %65
  %69 = load i32, i32* %7, align 4
  %70 = load i32, i32* %5, align 4
  %71 = icmp ne i32 %69, %70
  br i1 %71, label %72, label %82

72:                                               ; preds = %68
  %73 = load i32, i32* %3, align 4
  %74 = sext i32 %73 to i64
  %75 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %74
  %76 = load i32, i32* %7, align 4
  %77 = sext i32 %76 to i64
  %78 = getelementptr inbounds [9 x i32], [9 x i32]* %75, i64 0, i64 %77
  %79 = load i32, i32* %78, align 4
  %80 = load i32, i32* %6, align 4
  %81 = or i32 %80, %79
  store i32 %81, i32* %6, align 4
  br label %82

82:                                               ; preds = %72, %68
  br label %83

83:                                               ; preds = %82
  %84 = load i32, i32* %7, align 4
  %85 = add nsw i32 %84, 1
  store i32 %85, i32* %7, align 4
  br label %65, !llvm.loop !20

86:                                               ; preds = %65
  %87 = load i32, i32* %6, align 4
  %88 = xor i32 %87, -1
  %89 = call zeroext i1 @_Z9singletoni(i32 %88)
  br i1 %89, label %90, label %99

90:                                               ; preds = %86
  %91 = load i32, i32* %6, align 4
  %92 = xor i32 %91, -1
  %93 = load i32, i32* %3, align 4
  %94 = sext i32 %93 to i64
  %95 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %94
  %96 = load i32, i32* %5, align 4
  %97 = sext i32 %96 to i64
  %98 = getelementptr inbounds [9 x i32], [9 x i32]* %95, i64 0, i64 %97
  store i32 %92, i32* %98, align 4
  store i8 1, i8* %1, align 1
  br label %99

99:                                               ; preds = %90, %86
  %100 = load i32, i32* %3, align 4
  %101 = call i32 @_Z16get_square_begini(i32 %100)
  store i32 %101, i32* %10, align 4
  %102 = load i32, i32* %5, align 4
  %103 = call i32 @_Z16get_square_begini(i32 %102)
  store i32 %103, i32* %11, align 4
  %104 = load i32, i32* %10, align 4
  store i32 %104, i32* %7, align 4
  br label %105

105:                                              ; preds = %140, %99
  %106 = load i32, i32* %7, align 4
  %107 = load i32, i32* %10, align 4
  %108 = add nsw i32 %107, 3
  %109 = icmp slt i32 %106, %108
  br i1 %109, label %110, label %143

110:                                              ; preds = %105
  %111 = load i32, i32* %11, align 4
  store i32 %111, i32* %9, align 4
  br label %112

112:                                              ; preds = %136, %110
  %113 = load i32, i32* %9, align 4
  %114 = load i32, i32* %11, align 4
  %115 = add nsw i32 %114, 3
  %116 = icmp slt i32 %113, %115
  br i1 %116, label %117, label %139

117:                                              ; preds = %112
  %118 = load i32, i32* %7, align 4
  %119 = load i32, i32* %3, align 4
  %120 = icmp eq i32 %118, %119
  br i1 %120, label %121, label %125

121:                                              ; preds = %117
  %122 = load i32, i32* %9, align 4
  %123 = load i32, i32* %5, align 4
  %124 = icmp eq i32 %122, %123
  br i1 %124, label %135, label %125

125:                                              ; preds = %121, %117
  %126 = load i32, i32* %7, align 4
  %127 = sext i32 %126 to i64
  %128 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %127
  %129 = load i32, i32* %9, align 4
  %130 = sext i32 %129 to i64
  %131 = getelementptr inbounds [9 x i32], [9 x i32]* %128, i64 0, i64 %130
  %132 = load i32, i32* %131, align 4
  %133 = load i32, i32* %8, align 4
  %134 = or i32 %133, %132
  store i32 %134, i32* %8, align 4
  br label %135

135:                                              ; preds = %125, %121
  br label %136

136:                                              ; preds = %135
  %137 = load i32, i32* %9, align 4
  %138 = add nsw i32 %137, 1
  store i32 %138, i32* %9, align 4
  br label %112, !llvm.loop !21

139:                                              ; preds = %112
  br label %140

140:                                              ; preds = %139
  %141 = load i32, i32* %7, align 4
  %142 = add nsw i32 %141, 1
  store i32 %142, i32* %7, align 4
  br label %105, !llvm.loop !22

143:                                              ; preds = %105
  %144 = load i32, i32* %8, align 4
  %145 = xor i32 %144, -1
  %146 = call zeroext i1 @_Z9singletoni(i32 %145)
  br i1 %146, label %147, label %156

147:                                              ; preds = %143
  %148 = load i32, i32* %8, align 4
  %149 = xor i32 %148, -1
  %150 = load i32, i32* %3, align 4
  %151 = sext i32 %150 to i64
  %152 = getelementptr inbounds [9 x [9 x i32]], [9 x [9 x i32]]* @board, i64 0, i64 %151
  %153 = load i32, i32* %5, align 4
  %154 = sext i32 %153 to i64
  %155 = getelementptr inbounds [9 x i32], [9 x i32]* %152, i64 0, i64 %154
  store i32 %149, i32* %155, align 4
  store i8 1, i8* %1, align 1
  br label %156

156:                                              ; preds = %147, %143
  br label %157

157:                                              ; preds = %156, %19
  br label %158

158:                                              ; preds = %157
  %159 = load i32, i32* %5, align 4
  %160 = add nsw i32 %159, 1
  store i32 %160, i32* %5, align 4
  br label %16, !llvm.loop !23

161:                                              ; preds = %16
  br label %162

162:                                              ; preds = %161
  %163 = load i32, i32* %3, align 4
  %164 = add nsw i32 %163, 1
  store i32 %164, i32* %3, align 4
  br label %12, !llvm.loop !24

165:                                              ; preds = %12
  %166 = load i8, i8* %1, align 1
  %167 = trunc i8 %166 to i1
  ret i1 %167
}

; Function Attrs: noinline norecurse uwtable mustprogress
define dso_local i32 @main() #3 {
  %1 = alloca i32, align 4
  %2 = alloca i8, align 1
  store i32 0, i32* %1, align 4
  %3 = call i32 @_Z9bit_counti(i32 52)
  %4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.31, i64 0, i64 0), i32 %3)
  %5 = call i32 @_Z9bit_counti(i32 511)
  %6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.32, i64 0, i64 0), i32 %5)
  %7 = call i32 @_Z15get_nth_set_bitii(i32 52, i32 1)
  %8 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.33, i64 0, i64 0), i32 %7)
  %9 = call zeroext i1 @_Z9singletoni(i32 64)
  %10 = zext i1 %9 to i64
  %11 = select i1 %9, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.35, i64 0, i64 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.36, i64 0, i64 0)
  %12 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.34, i64 0, i64 0), i8* %11)
  %13 = call i32 @_Z13get_singletoni(i32 64)
  %14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.37, i64 0, i64 0), i32 %13)
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.38, i64 0, i64 0))
  %16 = call zeroext i1 @_Z5solvePPc(i8** getelementptr inbounds ([9 x i8*], [9 x i8*]* @easy_board_init, i64 0, i64 0))
  %17 = zext i1 %16 to i8
  store i8 %17, i8* %2, align 1
  %18 = load i8, i8* %2, align 1
  %19 = trunc i8 %18 to i1
  br i1 %19, label %20, label %23

20:                                               ; preds = %0
  %21 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.39, i64 0, i64 0))
  %22 = call zeroext i1 @_Z5solvePPc(i8** getelementptr inbounds ([9 x i8*], [9 x i8*]* @hard_board_init, i64 0, i64 0))
  br label %23

23:                                               ; preds = %20, %0
  %24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.40, i64 0, i64 0))
  %25 = call zeroext i1 @_Z5solvePPc(i8** getelementptr inbounds ([9 x i8*], [9 x i8*]* @third_board_init, i64 0, i64 0))
  ret i32 0
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local i32 @_Z9bit_counti(i32 %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store i32 %0, i32* %2, align 4
  store i8 0, i8* %3, align 1
  store i8 0, i8* %4, align 1
  br label %5

5:                                                ; preds = %18, %1
  %6 = load i8, i8* %4, align 1
  %7 = sext i8 %6 to i32
  %8 = icmp slt i32 %7, 9
  br i1 %8, label %9, label %21

9:                                                ; preds = %5
  %10 = load i8, i8* %3, align 1
  %11 = sext i8 %10 to i32
  %12 = load i32, i32* %2, align 4
  %13 = srem i32 %12, 2
  %14 = add nsw i32 %11, %13
  %15 = trunc i32 %14 to i8
  store i8 %15, i8* %3, align 1
  %16 = load i32, i32* %2, align 4
  %17 = ashr i32 %16, 1
  store i32 %17, i32* %2, align 4
  br label %18

18:                                               ; preds = %9
  %19 = load i8, i8* %4, align 1
  %20 = add i8 %19, 1
  store i8 %20, i8* %4, align 1
  br label %5, !llvm.loop !25

21:                                               ; preds = %5
  %22 = load i8, i8* %3, align 1
  %23 = sext i8 %22 to i32
  ret i32 %23
}

; Function Attrs: noinline nounwind uwtable mustprogress
define dso_local i32 @_Z15get_nth_set_bitii(i32 %0, i32 %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i8, align 1
  %7 = alloca i8, align 1
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i8 0, i8* %6, align 1
  store i8 0, i8* %7, align 1
  br label %8

8:                                                ; preds = %31, %2
  %9 = load i8, i8* %7, align 1
  %10 = sext i8 %9 to i32
  %11 = icmp slt i32 %10, 9
  br i1 %11, label %12, label %34

12:                                               ; preds = %8
  %13 = load i32, i32* %4, align 4
  %14 = srem i32 %13, 2
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %16, label %28

16:                                               ; preds = %12
  %17 = load i8, i8* %6, align 1
  %18 = sext i8 %17 to i32
  %19 = load i32, i32* %5, align 4
  %20 = icmp eq i32 %18, %19
  br i1 %20, label %21, label %24

21:                                               ; preds = %16
  %22 = load i8, i8* %7, align 1
  %23 = sext i8 %22 to i32
  store i32 %23, i32* %3, align 4
  br label %35

24:                                               ; preds = %16
  %25 = load i8, i8* %6, align 1
  %26 = add i8 %25, 1
  store i8 %26, i8* %6, align 1
  br label %27

27:                                               ; preds = %24
  br label %28

28:                                               ; preds = %27, %12
  %29 = load i32, i32* %4, align 4
  %30 = ashr i32 %29, 1
  store i32 %30, i32* %4, align 4
  br label %31

31:                                               ; preds = %28
  %32 = load i8, i8* %7, align 1
  %33 = add i8 %32, 1
  store i8 %33, i8* %7, align 1
  br label %8, !llvm.loop !26

34:                                               ; preds = %8
  store i32 -1, i32* %3, align 4
  br label %35

35:                                               ; preds = %34, %21
  %36 = load i32, i32* %3, align 4
  ret i32 %36
}

attributes #0 = { noinline nounwind uwtable mustprogress "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noinline uwtable mustprogress "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline norecurse uwtable mustprogress "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!2 = distinct !{!2, !3}
!3 = !{!"llvm.loop.mustprogress"}
!4 = distinct !{!4, !3}
!5 = distinct !{!5, !3}
!6 = distinct !{!6, !3}
!7 = distinct !{!7, !3}
!8 = distinct !{!8, !3}
!9 = distinct !{!9, !3}
!10 = distinct !{!10, !3}
!11 = distinct !{!11, !3}
!12 = distinct !{!12, !3}
!13 = distinct !{!13, !3}
!14 = distinct !{!14, !3}
!15 = distinct !{!15, !3}
!16 = distinct !{!16, !3}
!17 = distinct !{!17, !3}
!18 = distinct !{!18, !3}
!19 = distinct !{!19, !3}
!20 = distinct !{!20, !3}
!21 = distinct !{!21, !3}
!22 = distinct !{!22, !3}
!23 = distinct !{!23, !3}
!24 = distinct !{!24, !3}
!25 = distinct !{!25, !3}
!26 = distinct !{!26, !3}
