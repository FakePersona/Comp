; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"Le nombre lu est " = global [18 x i8] c"Le nombre lu est \00"
@"%d1" = global [3 x i8] c"%d\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %x = alloca i32, align 4
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %x)
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([18 x i8]* @"Le nombre lu est ", i64 0, i64 0))
  %x1 = load i32* %x, align 4
  %callprint2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %x1)
  ret void
}
