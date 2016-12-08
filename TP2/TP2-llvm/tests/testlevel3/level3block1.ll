; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main(i32 %f) {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 100)
  ret void
}
