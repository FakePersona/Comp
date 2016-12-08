; ModuleID = 'main'

@"Et voila: " = global [11 x i8] c"Et voila: \00"
@"%d" = global [3 x i8] c"%d\00"
@"%d1" = global [3 x i8] c"%d\00"
@"%d2" = global [3 x i8] c"%d\00"
@"%d3" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @"Et voila: ", i64 0, i64 0))
  %callprint8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 0)
  %callprint10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 0)
  %callprint12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32 0)
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 1)
  ret void
}
