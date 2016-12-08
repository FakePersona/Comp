; ModuleID = 'main'

@"%d" = global [3 x i8] c"%d\00"
@" est different de " = global [19 x i8] c" est different de \00"
@"%d1" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"
@"%d2" = global [3 x i8] c"%d\00"
@" est egal a " = global [13 x i8] c" est egal a \00"
@"%d3" = global [3 x i8] c"%d\00"
@"\0A4" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @compare(i32 %x, i32 %y) {
entry:
  %ifcond = icmp eq i32 %x, %y
  br i1 %ifcond, label %ifalse, label %itrue

eblock:                                           ; preds = %ifalse, %itrue
  ret void

itrue:                                            ; preds = %entry
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 %x)
  %callprint6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([19 x i8]* @" est different de ", i64 0, i64 0))
  %callprint8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 %y)
  %callprint9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  br label %eblock

ifalse:                                           ; preds = %entry
  %callprint11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d2", i64 0, i64 0), i32 %x)
  %callprint12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @" est egal a ", i64 0, i64 0))
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %x)
  %callprint15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A4", i64 0, i64 0))
  br label %eblock
}

define void @main() {
entry:
  call void @compare(i32 2, i32 1)
  call void @compare(i32 1, i32 2)
  call void @compare(i32 1, i32 1)
  ret void
}
