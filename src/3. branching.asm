[org 0x7C00]

mov ax, 3
cmp ax, 2
jl less
je equal
jg great
jmp $

less:
    mov bx, LT
    call print_string
    jmp $

equal:
    mov bx, EQ
    call print_string
    jmp $

great:
    mov bx, GT
    call print_string
    jmp $

LT: db "LESS THAN", 0
EQ: db "EQUAL", 0
GT: db "GREATER THAN", 0

; Helper routines
%include "src/16bit_util/print_string.asm"

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55