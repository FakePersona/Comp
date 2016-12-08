; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@"%d1" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define i32 @pair(i32 %x) {
entry:
  %minus = and i32 %x, 1
  %ifcond = icmp eq i32 %minus, 0
  %. = select i1 %ifcond, i32 1, i32 0
  ret i32 %.
  ret i32 0
}

define i32 @syracuse(i32 %y) {
entry:
  %calltmp = call i32 @pair(i32 %y)
  %ifcond = icmp eq i32 %calltmp, 0
  br i1 %ifcond, label %ifalse, label %itrue

eblock:                                           ; preds = %ifalse, %itrue
  %s.0 = phi i32 [ %div, %itrue ], [ %plus, %ifalse ]
  ret i32 %s.0
  ret i32 0

itrue:                                            ; preds = %entry
  %div = lshr i32 %y, 1
  br label %eblock

ifalse:                                           ; preds = %entry
  %mul = mul i32 %y, 3
  %plus = add i32 %mul, 1
  br label %eblock
}

define void @main() {
entry:
  %t22 = alloca [6 x i32], align 4
  %k = alloca i32, align 4
  %callread = call i32 (i8*, ...)* @scanf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32* %k)
  %assignarray = getelementptr [6 x i32]* %t22, i64 0, i64 5
  %k1 = load i32* %k, align 4
  %calltmp = call i32 @syracuse(i32 %k1)
  store i32 %calltmp, i32* %assignarray, align 4
  br label %while

while:                                            ; preds = %entry, %loop
  %i.0 = phi i32 [ 0, %entry ], [ %plus, %loop ]
  %while3 = icmp eq i32 %i.0, 5
  br i1 %while3, label %while10, label %loop

loop:                                             ; preds = %while
  %0 = sext i32 %i.0 to i64
  %assignarray5 = getelementptr [6 x i32]* %t22, i64 0, i64 %0
  %calltmp7 = call i32 @syracuse(i32 %i.0)
  store i32 %calltmp7, i32* %assignarray5, align 4
  %plus = add i32 %i.0, 1
  br label %while

while10:                                          ; preds = %while, %loop15
  %i.1 = phi i32 [ %plus21, %loop15 ], [ 0, %while ]
  %while13 = icmp eq i32 %i.1, 6
  br i1 %while13, label %eblock14, label %loop15

eblock14:                                         ; preds = %while10
  ret void

loop15:                                           ; preds = %while10
  %1 = sext i32 %i.1 to i64
  %assignarray17 = getelementptr [6 x i32]* %t22, i64 0, i64 %1
  %t18 = load i32* %assignarray17, align 4
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %t18)
  %callprint19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  %plus21 = add i32 %i.1, 1
  br label %while10
}
