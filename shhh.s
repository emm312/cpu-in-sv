mov r1, 0
mov r2, 0
mov r3, 255
lsh r3, r3
lsh r3, r3
lsh r3, r3
lsh r3, r3
lsh r3, r3
lsh r3, r3
lsh r3, r3
lsh r3, r3
or r3, r3, 255
.lbl
    add r2, r2, 1
    cmp r2, r3
    jeq .add
    jmp .lbl
.add
    add r1, r1, 1
    jmp .lbl