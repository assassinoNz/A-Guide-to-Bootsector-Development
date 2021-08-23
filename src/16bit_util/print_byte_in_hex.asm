; Prints the hex value of a byte

; PARAMETERS
; AL = Byte value

[bits 16]
print_byte_in_hex:
    pusha
    mov ah, 0xE; Select interrupt vector video services
    ; NOTE: we can only map 4bits to an ASCII character. So we will print AL's first and last 4bits seperately
    ; Copy AL byte to two places (In this case, to BL and BH). So we can isolate first 4bits and last 4bits by bit shifting.
    mov bl, al
    mov bh, al
    
    shr bl, 4; Shift BL two digits right
    mov al, bl
    mov cx, ret0$print_byte_in_hex; Store jump back location in cx. So if the branching is executed, that code will know what to execute next
    cmp al, 0x0A
    jl add_30_al$print_byte_in_hex; If the value is less than A, adding 0x30 will give its ASCII value
    add al, 0x37; Else, adding 0x37 will give its ASCII value
    ret0$print_byte_in_hex: int 0x0010
    ;Shift BH two digits left and then right again. Now BH contains only its last four bits
    shl bh, 0x4
    shr bh, 0x4
    mov al, bh
    mov cx, ret1$print_byte_in_hex
    cmp al, 0x0A
    jl add_30_al$print_byte_in_hex
    add al, 0x37
    ret1$print_byte_in_hex: int 0x0010

    ; Print additional space for clarity
    mov al, " "
    int 0x0010

    popa
    ret

    add_30_al$print_byte_in_hex: add al, 0x30
    jmp cx