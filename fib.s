mov r1, 1
mov r2, 0
mov r3, 0

.fib
  pld r4, 0
  cmp r4, 1
  jeq .fib
  pst r1, r1
  mov r2, r1
  add r1, r3, r1
  mov r3, r2
  pst 0, r1
  cmp r1, 255
  jlt .fib
hlt
