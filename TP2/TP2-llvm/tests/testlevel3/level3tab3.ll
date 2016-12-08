; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"t[" = global [3 x i8] c"t[\00"
@"%d1" = global [3 x i8] c"%d\00"
@"] = " = global [5 x i8] c"] = \00"
@"%d2" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %x = alloca i32, align 4
  %t22 = alloca [8 x i32], align 4
  br label %while

while:                                            ; preds = %entry, %loop
  %i.0 = phi i32 [ 0, %entry ], [ %plus, %loop ]
  %while2 = icmp eq i32 %i.0, 8
  br i1 %while2, label %while6, label %loop

loop:                                             ; preds = %while
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %x)
  %0 = sext i32 %i.0 to i64
  %assignarray = getelementptr [8 x i32]* %t22, i64 0, i64 %0
  %x4 = load i32* %x, align 4
  store i32 %x4, i32* %assignarray, align 4
  %plus = add i32 %i.0, 1
  br label %while

while6:                                           ; preds = %while, %loop11
  %i.1 = phi i32 [ %plus21, %loop11 ], [ 0, %while ]
  %while9 = icmp eq i32 %i.1, 8
  br i1 %while9, label %eblock10, label %loop11

eblock10:                                         ; preds = %while6
  ret void

loop11:                                           ; preds = %while6
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"t[", i64 0, i64 0))
  %callprint13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %i.1)
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @"] = ", i64 0, i64 0))
  %1 = sext i32 %i.1 to i64
  %assignarray16 = getelementptr [8 x i32]* %t22, i64 0, i64 %1
  %t17 = load i32* %assignarray16, align 4
  %callprint18 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32 %t17)
  %callprint19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  %plus21 = add i32 %i.1, 1
  br label %while6
}
