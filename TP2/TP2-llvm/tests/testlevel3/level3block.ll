; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"%d1" = global [3 x i8] c"%d\00"
@"y a l'interieur vaut " = global [22 x i8] c"y a l'interieur vaut \00"
@"%d2" = global [3 x i8] c"%d\00"
@", mais a l'exterieur du bloc il vaut " = global [38 x i8] c", mais a l'exterieur du bloc il vaut \00"
@"%d3" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %y1 = alloca i32, align 4
  %y = alloca i32, align 4
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %y)
  %callread2 = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32* %y1)
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([22 x i8]* @"y a l'interieur vaut ", i64 0, i64 0))
  %y3 = load i32* %y1, align 4
  %callprint4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32 %y3)
  %callprint5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([38 x i8]* @", mais a l'exterieur du bloc il vaut ", i64 0, i64 0))
  %y6 = load i32* %y, align 4
  %callprint7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %y6)
  ret void
}
