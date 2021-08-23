; NOTE: BIOS loads our boot sector to the address 0x7C00. But NASM by default thinks our code is loaded into 0x0
; If we were to access any memory belonging to our boot sector's 512 bytes, we have to offset it by 0x7C00
; Tell NASM to offset every momory address with 0x7C00
[org 0x7C00]

; Setup parameters for BIOS interrupt write char in TTY mode
mov ah, 0x0E
mov al, [my_char]; Load content at the address my_char to AL
; Because of our [org 0x7C00] directive, NASM will corecct [my_char] into [0x7C00+my_char]
int 0x10; Execute interrupt
jmp $; Infinite loop

; Define data addresses
my_char: db "N"

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55