mov r1, 1
mov r2, 0
mov r3, 0
mov r4, 0
.fib
    mov r2, r1
    add r1, r1, r3
    mov r3, r2
    add r4, r4, 1
    cmp r4, 10
    pst 0, r1
    jlt .fib
hlt
