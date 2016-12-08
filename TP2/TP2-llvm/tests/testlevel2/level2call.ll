; ModuleID = 'main'

@"one() = " = global [9 x i8] c"one() = \00"
@"%d" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define i32 @one() {
entry:
  ret i32 1
  ret i32 0
}

define void @main() {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @"one() = ", i64 0, i64 0))
  %calltmp = call i32 @one()
  %callprint1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %calltmp)
  ret void
}
