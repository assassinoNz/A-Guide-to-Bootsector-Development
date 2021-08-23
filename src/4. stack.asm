[org 0x7C00]

; NOTE: Stack is implemented using 2 registeres. Namely BP and SP
; BP = Base/bottom of stack, SP = Top of stack
; Every stack element has a lenth of 16bits(only in 16bit mode)
; With every push instruction the SP will jump to SP-2(only in 16bit mode) and hence the stack will grow backwards (SP will jump towards lower addresses). This is counter intutive

mov bp, 0x8000; Set base pointer to a safe memory location
mov sp, bp; Set stack pointer to same as base pointer;
; Push our printable values to the stack;
push "O"
push "L"
push "L"
push "E"
push "H"
; NOTE: Our ASCII values will be padded to match 2byte length (because stack must always hold 16bit length  data in 16bit real mode)

mov ah, 0xE; Use BIOS TTY
mov cx, 0x0000; Initiate an iteration counter for our do-while-loop

;do { 
;   bx = pop();
;   print();
;   i++;
;} while (i < 5)

do_block:
    pop bx; Pop the stack to BX register;
    ; NOTE: The popped value is 2byte long. But we need a 1byte value. That is why we use another register
    mov al, bl; Copy the lower byte of to al
    int 0x10; Call the intterupt
    add cx, 0x0001; Increment iteration counter
while_block:
    cmp cx, 0x0005; Since wee need 5 iterations, compare current iteration counter with 5
    jl do_block
    jmp $

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55