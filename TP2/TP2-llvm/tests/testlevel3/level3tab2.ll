; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"%d1" = global [3 x i8] c"%d\00"
@"%d2" = global [3 x i8] c"%d\00"
@"t[0] = " = global [8 x i8] c"t[0] = \00"
@"%d3" = global [3 x i8] c"%d\00"
@"\0At[1] = " = global [9 x i8] c"\0At[1] = \00"
@"%d4" = global [3 x i8] c"%d\00"
@"\0At[2] = " = global [9 x i8] c"\0At[2] = \00"
@"%d5" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %t19 = alloca [3 x i32], align 4
  %z = alloca i32, align 4
  %y = alloca i32, align 4
  %x = alloca i32, align 4
  %t19.sub = getelementptr inbounds [3 x i32]* %t19, i64 0, i64 0
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %x)
  %callread1 = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32* %y)
  %callread2 = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32* %z)
  %x3 = load i32* %x, align 4
  store i32 %x3, i32* %t19.sub, align 4
  %assignarray4 = getelementptr [3 x i32]* %t19, i64 0, i64 1
  %y5 = load i32* %y, align 4
  store i32 %y5, i32* %assignarray4, align 4
  %assignarray6 = getelementptr [3 x i32]* %t19, i64 0, i64 2
  %z7 = load i32* %z, align 4
  store i32 %z7, i32* %assignarray6, align 4
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @"t[0] = ", i64 0, i64 0))
  %t9 = load i32* %t19.sub, align 4
  %callprint10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %t9)
  %callprint11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @"\0At[1] = ", i64 0, i64 0))
  %t13 = load i32* %assignarray4, align 4
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d4", i64 0, i64 0), i32 %t13)
  %callprint15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @"\0At[2] = ", i64 0, i64 0))
  %t17 = load i32* %assignarray6, align 4
  %callprint18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d5", i64 0, i64 0), i32 %t17)
  ret void
}
