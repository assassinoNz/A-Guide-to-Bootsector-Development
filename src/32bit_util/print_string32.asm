[bits 32]
; Prints the ASCII value of the content in a set of sequential addresses in the RAM untill null is occured

; PARAMETERS
; EBX = Starting address of the null terminating string

print_string32:
    pusha
    mov edx, 0xB8000; Location of the memory mapped video device
    ; NOTE: The screen is divided into 80x25 cells with each cell confuguration is stored in 2bytes of memory. So there are 80*25*2 bytes allocated starting from the address 0xB8000

    do_block$print_string32:
        mov al, [ebx]
        mov ah, 0x0F; Set white on black mode
        mov [edx], ax
        add ebx, 1
        add edx, 2
    while_block$print_string32:
        cmp al, 0
        jne do_block$print_string32
    
    popa
    ret