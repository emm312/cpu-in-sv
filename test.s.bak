mov r1, 9
.collatz // r1 = cur_num
         // r2 = is_even
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
    hlt