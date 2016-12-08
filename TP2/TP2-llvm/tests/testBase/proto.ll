; ModuleID = 'main'

@"1+3 = " = global [7 x i8] c"1+3 = \00"
@"%d" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define i32 @plus(i32 %x, i32 %y) {
entry:
  %plus = add i32 %y, %x
  ret i32 %plus
  ret i32 0
}

define void @main() {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([7 x i8]* @"1+3 = ", i64 0, i64 0))
  %calltmp = call i32 @plus(i32 1, i32 3)
  %callprint1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %calltmp)
  ret void
}
