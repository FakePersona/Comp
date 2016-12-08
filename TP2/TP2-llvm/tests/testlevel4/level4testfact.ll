; ModuleID = 'main'

@"f(" = global [3 x i8] c"f(\00"
@"%d" = global [3 x i8] c"%d\00"
@") = " = global [5 x i8] c") = \00"
@"%d1" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define i32 @fact(i32 %k) {
entry:
  %n = alloca i32
  store i32 %k, i32* %n
  br label %if

if:                                               ; preds = %entry
  %n1 = load i32* %n
  %ifcond = icmp ne i32 %n1, 0
  br i1 %ifcond, label %itrue, label %ifalse

eblock:                                           ; preds = %ifalse, %itrue
  ret i32 0

itrue:                                            ; preds = %if
  %n2 = load i32* %n
  %n3 = load i32* %n
  %minus = sub i32 %n3, 1
  %calltmp = call i32 @fact(i32 %minus)
  %mul = mul i32 %n2, %calltmp
  ret i32 %mul
  br label %eblock

ifalse:                                           ; preds = %if
  ret i32 1
  br label %eblock
}

define void @main() {
entry:
  %t = alloca i32, i32 11
  %i = alloca i32
  store i32 0, i32* %i
  br label %while

while:                                            ; preds = %entry, %loop
  %i1 = load i32* %i
  %minus = sub i32 11, %i1
  %while2 = icmp ne i32 %minus, 0
  br i1 %while2, label %loop, label %eblock

eblock:                                           ; preds = %while
  store i32 0, i32* %i
  br label %while6

loop:                                             ; preds = %while
  %i3 = load i32* %i
  %assignarray = getelementptr i32* %t, i32 %i3
  %i4 = load i32* %i
  %calltmp = call i32 @fact(i32 %i4)
  store i32 %calltmp, i32* %assignarray
  %i5 = load i32* %i
  %plus = add i32 %i5, 1
  store i32 %plus, i32* %i
  br label %while

while6:                                           ; preds = %eblock, %loop11
  %i7 = load i32* %i
  %minus8 = sub i32 11, %i7
  %while9 = icmp ne i32 %minus8, 0
  br i1 %while9, label %loop11, label %eblock10

eblock10:                                         ; preds = %while6
  ret void

loop11:                                           ; preds = %while6
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"f(", i32 0, i32 0))
  %i12 = load i32* %i
  %callprint13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i32 0, i32 0), i32 %i12)
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @") = ", i32 0, i32 0))
  %i15 = load i32* %i
  %assignarray16 = getelementptr i32* %t, i32 %i15
  %t17 = load i32* %assignarray16
  %callprint18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i32 0, i32 0), i32 %t17)
  %callprint19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i32 0, i32 0))
  %i20 = load i32* %i
  %plus21 = add i32 %i20, 1
  store i32 %plus21, i32* %i
  br label %while6
}
