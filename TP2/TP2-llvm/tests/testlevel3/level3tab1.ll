; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"%d1" = global [3 x i8] c"%d\00"
@"%d2" = global [3 x i8] c"%d\00"
@"%d3" = global [3 x i8] c"%d\00"
@"%d4" = global [3 x i8] c"%d\00"
@"%d5" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %t13 = alloca [3 x i32], align 4
  %t13.sub = getelementptr inbounds [3 x i32]* %t13, i64 0, i64 0
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %t13.sub)
  %assignarray1 = getelementptr [3 x i32]* %t13, i64 0, i64 1
  %callread2 = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32* %assignarray1)
  %assignarray3 = getelementptr [3 x i32]* %t13, i64 0, i64 2
  %callread4 = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32* %assignarray3)
  %t6 = load i32* %t13.sub, align 4
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %t6)
  %t8 = load i32* %assignarray1, align 4
  %callprint9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d4", i64 0, i64 0), i32 %t8)
  %t11 = load i32* %assignarray3, align 4
  %callprint12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d5", i64 0, i64 0), i32 %t11)
  ret void
}
