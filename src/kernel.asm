[org 0x1000]
[bits 32]

main:
    pusha
    mov ebx, STR
    call print_string32
    popa
    ret

STR: db "HELLO WORLD", 0

; Helper routines
%include "src/32bit_util/print_string32.asm"

; Create the 2nd, 3rd, 4th, 5th sectors with known bytes
times 512 db 0xCA
times 512 db 0xFE
times 512 db 0xFA
times 512 db 0xCE