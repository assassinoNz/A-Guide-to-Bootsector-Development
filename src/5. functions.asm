[org 0x7C00]

mov bp, 0x8000; Set stack start pointer to a safe memory location
mov sp, bp; Set stack pointer to same as base pointer; NOTE: This will be adjusted by the CPU with every push and pop commands
; Push our printable values to the stack; NOTE: Our ASCII values will be padded to match 2byte length
push "O"
push "L"
push "L"
push "E"
push "H"

mov cx, 0x0000; Initiate an iteration counter for our do-while-loop

;do { 
;   bx = pop();
;   print();
;   i++;
;} while (i < 5)

do_block:
    pop ax
    call print_unsafe
    ; NOTE: call instruction pushes the current address(value of PC+1) in the stack. So after the function is executed, the CPU can come back here
    add cx, 0x0001; Increment iteration counter
while_block:
    cmp cx, 0x0005; Since wee need 5 iterations, compare current iteration counter with 5
    jl do_block

infinte_loop: jmp $

; This function is unsafe as it is altering the AX register without reverting it into the original state before execution
print_unsafe:
    mov ah, 0xE; Use BIOS TTY
    int 0x10; Call the intterupt
    ret; Pops the last address from the stack to PC and jumps to it

; This function is safe as it caches all register values in the stack before execution and restores them after execution
print_safe:
    pusha; Push all register values to the stack
    mov ah, 0xE; Use BIOS TTY
    int 0x10; Call the intterupt
    popa; Restore all register values from the stack
    ret; Pops the last address from the stack and jumps to it

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55