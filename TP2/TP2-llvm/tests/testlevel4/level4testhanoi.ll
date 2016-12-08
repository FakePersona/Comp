; ModuleID = 'main'

@"\0A Hanoi avec " = global [14 x i8] c"\0A Hanoi avec \00"
@"%d" = global [3 x i8] c"%d\00"
@" disques\0A\0A" = global [11 x i8] c" disques\0A\0A\00"
@"\0A\0AHanoi avec " = global [14 x i8] c"\0A\0AHanoi avec \00"
@"%d1" = global [3 x i8] c"%d\00"
@" disques\0A\0A2" = global [11 x i8] c" disques\0A\0A\00"
@"Deplacer un disque de " = global [23 x i8] c"Deplacer un disque de \00"
@"%d3" = global [3 x i8] c"%d\00"
@" a " = global [4 x i8] c" a \00"
@"%d4" = global [3 x i8] c"%d\00"
@"\0A" = global [2 x i8] c"\0A\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define i32 @hanoi(i32 %n, i32 %delatour, i32 %alatour, i32 %parlatour) {
entry:
  %ifcond = icmp eq i32 %n, 0
  br i1 %ifcond, label %eblock, label %itrue

eblock:                                           ; preds = %entry, %itrue
  ret i32 1
  ret i32 0

itrue:                                            ; preds = %entry
  %minus = add i32 %n, -1
  %calltmp = call i32 @hanoi(i32 %minus, i32 %delatour, i32 %parlatour, i32 %alatour)
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([23 x i8]* @"Deplacer un disque de ", i64 0, i64 0))
  %callprint11 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d3", i64 0, i64 0), i32 %delatour)
  %callprint12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @" a ", i64 0, i64 0))
  %callprint14 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d4", i64 0, i64 0), i32 %alatour)
  %callprint15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @"\0A", i64 0, i64 0))
  %calltmp21 = call i32 @hanoi(i32 %minus, i32 %parlatour, i32 %alatour, i32 %delatour)
  br label %eblock
}

define void @main() {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([14 x i8]* @"\0A Hanoi avec ", i64 0, i64 0))
  %callprint2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d", i64 0, i64 0), i32 3)
  %callprint3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @" disques\0A\0A", i64 0, i64 0))
  %calltmp = call i32 @hanoi(i32 3, i32 1, i32 3, i32 2)
  %callprint5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([14 x i8]* @"\0A\0AHanoi avec ", i64 0, i64 0))
  %callprint7 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @"%d1", i64 0, i64 0), i32 4)
  %callprint8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([11 x i8]* @" disques\0A\0A2", i64 0, i64 0))
  %calltmp10 = call i32 @hanoi(i32 4, i32 1, i32 3, i32 2)
  ret void
}
