; ModuleID = 'main'

@"\0A" = global [2 x i8] c"\0A\00"
@"%d" = global [3 x i8] c"%d\00"
@"^2 + " = global [6 x i8] c"^2 + \00"
@"1^2 = " = global [7 x i8] c"1^2 = \00"
@"%d1" = global [3 x i8] c"%d\00"
@"\0A2" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  br label %while

while:                                            ; preds = %entry, %loop
  %i.0 = phi i32 [ 5, %entry ], [ %minus, %loop ]
  %s.0 = phi i32 [ 0, %entry ], [ %plus, %loop ]
  %while3 = icmp eq i32 %i.0, 0
  br i1 %while3, label %eblock, label %loop

eblock:                                           ; preds = %while
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  br label %while9

loop:                                             ; preds = %while
  %mul = mul i32 %i.0, %i.0
  %plus = add i32 %s.0, %mul
  %minus = add i32 %i.0, -1
  br label %while

while9:                                           ; preds = %eblock, %loop14
  %i.1 = phi i32 [ 5, %eblock ], [ %minus19, %loop14 ]
  %while12 = icmp eq i32 %i.1, 1
  br i1 %while12, label %eblock13, label %loop14

eblock13:                                         ; preds = %while9
  %callprint20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([7 x i8]* @"1^2 = ", i64 0, i64 0))
  %callprint22 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %s.0)
  %callprint23 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A2", i64 0, i64 0))
  ret void

loop14:                                           ; preds = %while9
  %callprint16 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %i.1)
  %callprint17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([6 x i8]* @"^2 + ", i64 0, i64 0))
  %minus19 = add i32 %i.1, -1
  br label %while9
}
