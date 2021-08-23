; Prints the ASCII value of the content in a set of sequential addresses in the RAM untill null is occured

; PARAMETERS
; BX = Starting address of the null terminating string

[bits 16]
print_string:
    pusha
    mov ah, 0xE; Select interrupt vector video services
    do_block$print_string:
        mov al, [bx]
        int 0x10; Call the intterupt
        add bx, 1; Increment the BX
    while_block$print_string:
        cmp byte [bx], 0; Since our string is null terminated, compare with 0 to detect end of string
        jne do_block$print_string
    popa
    ret