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
  %ifcond = icmp eq i32 %k, 0
  br i1 %ifcond, label %eblock, label %itrue

eblock:                                           ; preds = %entry, %itrue
  %res.0 = phi i32 [ %mul, %itrue ], [ 1, %entry ]
  ret i32 %res.0
  ret i32 0

itrue:                                            ; preds = %entry
  %minus = add i32 %k, -1
  %calltmp = call i32 @fact(i32 %minus)
  %mul = mul i32 %calltmp, %k
  br label %eblock
}

define void @main() {
entry:
  %t22 = alloca [11 x i32], align 4
  br label %while

while:                                            ; preds = %entry, %loop
  %i.0 = phi i32 [ 0, %entry ], [ %plus, %loop ]
  %while2 = icmp eq i32 %i.0, 11
  br i1 %while2, label %while6, label %loop

loop:                                             ; preds = %while
  %0 = sext i32 %i.0 to i64
  %assignarray = getelementptr [11 x i32]* %t22, i64 0, i64 %0
  %calltmp = call i32 @fact(i32 %i.0)
  store i32 %calltmp, i32* %assignarray, align 4
  %plus = add i32 %i.0, 1
  br label %while

while6:                                           ; preds = %while, %loop11
  %i.1 = phi i32 [ %plus21, %loop11 ], [ 0, %while ]
  %while9 = icmp eq i32 %i.1, 11
  br i1 %while9, label %eblock10, label %loop11

eblock10:                                         ; preds = %while6
  ret void

loop11:                                           ; preds = %while6
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"f(", i64 0, i64 0))
  %callprint13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %i.1)
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @") = ", i64 0, i64 0))
  %1 = sext i32 %i.1 to i64
  %assignarray16 = getelementptr [11 x i32]* %t22, i64 0, i64 %1
  %t17 = load i32* %assignarray16, align 4
  %callprint18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %t17)
  %callprint19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  %plus21 = add i32 %i.1, 1
  br label %while6
}
