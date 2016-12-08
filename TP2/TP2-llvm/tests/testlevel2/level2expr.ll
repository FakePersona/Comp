; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"+" = global [2 x i8] c"+\00"
@"%d1" = global [3 x i8] c"%d\00"
@" = " = global [4 x i8] c" = \00"
@"%d2" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"
@"%d3" = global [3 x i8] c"%d\00"
@- = global [2 x i8] c"-\00"
@"%d4" = global [3 x i8] c"%d\00"
@" = 5" = global [4 x i8] c" = \00"
@"%d6" = global [3 x i8] c"%d\00"
@"\0A7" = global [2 x i8] c"\0A\00"
@"%d8" = global [3 x i8] c"%d\00"
@"*" = global [2 x i8] c"*\00"
@"%d9" = global [3 x i8] c"%d\00"
@" = 10" = global [4 x i8] c" = \00"
@"%d11" = global [3 x i8] c"%d\00"
@"\0A12" = global [2 x i8] c"\0A\00"
@"%d13" = global [3 x i8] c"%d\00"
@"/" = global [2 x i8] c"/\00"
@"%d14" = global [3 x i8] c"%d\00"
@" = 15" = global [4 x i8] c" = \00"
@"%d16" = global [3 x i8] c"%d\00"
@"\0A17" = global [2 x i8] c"\0A\00"
@"%d18" = global [3 x i8] c"%d\00"
@"+19" = global [2 x i8] c"+\00"
@"%d20" = global [3 x i8] c"%d\00"
@" = 21" = global [4 x i8] c" = \00"
@"%d22" = global [3 x i8] c"%d\00"
@"\0A23" = global [2 x i8] c"\0A\00"
@"%d24" = global [3 x i8] c"%d\00"
@"* (" = global [4 x i8] c"* (\00"
@"%d25" = global [3 x i8] c"%d\00"
@"+26" = global [2 x i8] c"+\00"
@"%d27" = global [3 x i8] c"%d\00"
@") = " = global [5 x i8] c") = \00"
@"%d28" = global [3 x i8] c"%d\00"
@"\0A29" = global [2 x i8] c"\0A\00"
@"%d30" = global [3 x i8] c"%d\00"
@"*  " = global [4 x i8] c"*  \00"
@"%d31" = global [3 x i8] c"%d\00"
@"+32" = global [2 x i8] c"+\00"
@"%d33" = global [3 x i8] c"%d\00"
@"  = " = global [5 x i8] c"  = \00"
@"%d34" = global [3 x i8] c"%d\00"
@"\0A35" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @expr(i32 %x, i32 %y) {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %x)
  %callprint4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"+", i64 0, i64 0))
  %callprint6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %y)
  %callprint7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" = ", i64 0, i64 0))
  %plus = add i32 %y, %x
  %callprint10 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32 %plus)
  %callprint11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  %callprint13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %x)
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @-, i64 0, i64 0))
  %callprint16 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d4", i64 0, i64 0), i32 %y)
  %callprint17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" = 5", i64 0, i64 0))
  %minus = sub i32 %x, %y
  %callprint20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d6", i64 0, i64 0), i32 %minus)
  %callprint21 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A7", i64 0, i64 0))
  %callprint23 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d8", i64 0, i64 0), i32 %x)
  %callprint24 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"*", i64 0, i64 0))
  %callprint26 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d9", i64 0, i64 0), i32 %y)
  %callprint27 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" = 10", i64 0, i64 0))
  %mul = mul i32 %y, %x
  %callprint30 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d11", i64 0, i64 0), i32 %mul)
  %callprint31 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A12", i64 0, i64 0))
  %callprint33 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d13", i64 0, i64 0), i32 %x)
  %callprint34 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"/", i64 0, i64 0))
  %callprint36 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d14", i64 0, i64 0), i32 %y)
  %callprint37 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" = 15", i64 0, i64 0))
  %div = udiv i32 %x, %y
  %callprint40 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d16", i64 0, i64 0), i32 %div)
  %callprint41 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A17", i64 0, i64 0))
  %callprint43 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d18", i64 0, i64 0), i32 %x)
  %callprint44 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"+19", i64 0, i64 0))
  %callprint45 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d20", i64 0, i64 0), i32 1)
  %callprint46 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" = 21", i64 0, i64 0))
  %plus48 = add i32 %x, 1
  %callprint49 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d22", i64 0, i64 0), i32 %plus48)
  %callprint50 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A23", i64 0, i64 0))
  %callprint52 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d24", i64 0, i64 0), i32 %x)
  %callprint53 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @"* (", i64 0, i64 0))
  %callprint55 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d25", i64 0, i64 0), i32 %x)
  %callprint56 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"+26", i64 0, i64 0))
  %callprint58 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d27", i64 0, i64 0), i32 %y)
  %callprint59 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @") = ", i64 0, i64 0))
  %mul64 = mul i32 %plus, %x
  %callprint65 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d28", i64 0, i64 0), i32 %mul64)
  %callprint66 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A29", i64 0, i64 0))
  %callprint68 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d30", i64 0, i64 0), i32 %x)
  %callprint69 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @"*  ", i64 0, i64 0))
  %callprint71 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d31", i64 0, i64 0), i32 %x)
  %callprint72 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"+32", i64 0, i64 0))
  %callprint74 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d33", i64 0, i64 0), i32 %y)
  %callprint75 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @"  = ", i64 0, i64 0))
  %mul78 = mul i32 %x, %x
  %plus80 = add i32 %mul78, %y
  %callprint81 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d34", i64 0, i64 0), i32 %plus80)
  %callprint82 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A35", i64 0, i64 0))
  ret void
}

define void @main() {
entry:
  call void @expr(i32 1, i32 3)
  call void @expr(i32 5, i32 2)
  ret void
}
