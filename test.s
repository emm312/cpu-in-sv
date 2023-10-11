mov r1, 1
mov r2, 0
mov r3, 0
.fib
    mov r2, r1
    add r1, r1, r3
    mov r3, r2
    jmp .fib
hlt
