; Prints the hex value of the content in a set of sequential addresses in the RAM

; PARAMETERS
; BX = Starting address of the first byte
; CH = Number of bytes to print

[bits 16]
print_memory_content:
    pusha
    mov cl, 0; Initialize the iteration counter
    do_block$print_memory_content:
        mov al, [bx]
        call print_byte_in_hex
        add bx, 1; Increment the BX
        add cl, 1; Increment the CH
    while_block$print_memory_content:
        cmp cl, ch
        jl do_block$print_memory_content
    popa
    ret

%include "src/16bit_util/print_byte_in_hex.asm"