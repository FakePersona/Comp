; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"y vaut " = global [8 x i8] c"y vaut \00"
@"%d1" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %x = alloca i32, align 4
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %x)
  %x1 = load i32* %x, align 4
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([8 x i8]* @"y vaut ", i64 0, i64 0))
  %callprint3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %x1)
  ret void
}
