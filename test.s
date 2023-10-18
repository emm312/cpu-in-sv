//.main
//	mov r1, 170
//    pst 1, 1
//	 pld r2, 0
//	 cmp r2, 0
//	 jeq .input_loop
//	 jmp .main
//.input_loop
//    pld r1, 1
//    cmp r1, 0
//    jeq .collatz_init
//	 jmp .main
//
.collatz_init
    mov r1, 9
.collatz // r1 = cur_num
         // r2 = is_even
    pld r3, 0
    cmp r3, 1
    jeq .collatz
    pst 0, r1
    cmp r1, 1
    jeq .halt
    and r2, r1, 1
    cmp r2, 1
    jeq .odd
    jmp .even
.even
    lsh r1, r1
    jmp .collatz
.odd
    mul r1, r1, 3
    add r1, r1, 1
    jmp .collatz
.halt
hlt
   // jmp .main
