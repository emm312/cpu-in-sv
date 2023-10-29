.main
    pst 0, 170
	 cal .button
	 jmp .input_loop
	 jmp .main
.input_loop
    pld r1, 1
    cmp r1, 0
    jeq .collatz_init
    jgr .fib_init
	 jmp .main

.collatz_init
    mov r1, 5
.collatz // r1 = cur_num
         // r2 = is_even
    cal .button
    pst 0, r1
    cmp r1, 1
    jeq .halt
    and r2, r1, 1
    cmp r2, 1
    jeq .odd
    jmp .even
.even
    rsh r1, r1
    jmp .collatz
.odd
    mul r1, r1, 3
    add r1, r1, 1
    jmp .collatz
.halt
   jmp .main

.fib_init
mov r1, 1
mov r2, 0
mov r3, 0

mov r4, 0

.fib
  cal .button
  mov r2, r1
  add r1, r3, r1
  mov r3, r2
  pst 0, r1
  cmp r1, 255
  jge .halt
  jmp .fib
  .halt
jmp .main


.button
    pld r5, 0
    cmp r5, 0
    jeq .button
    .pressed
    pld r5, 0
    cmp r5, 1
    jeq .pressed

    ret