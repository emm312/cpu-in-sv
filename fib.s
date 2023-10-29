mov r1, 1
mov r2, 0
mov r3, 0

mov r4, 0

.fib
  pld r5, 0
  cmp r5, r0
  jnq .fib
  mov r2, r1
  add r1, r3, r1
  mov r3, r2
  pst 0, r1
  cmp r1, 255
  jge .halt
  .zr
  //add r5, r5, 1
  pld r5, 0
  cmp r5, 1
  jnq .zr
  jmp .fib
  .halt
jmp .main
