; ModuleID = 'main'

@Toto = global [5 x i8] c"Toto\00"

declare i32 @printf(i8* nocapture, ...) nounwind

declare i32 @scanf(i8* nocapture, ...) nounwind

define void @main() {
entry:
  %callprint = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @Toto, i64 0, i64 0))
  br label %loop

loop:                                             ; preds = %loop, %entry
  br label %loop
}
