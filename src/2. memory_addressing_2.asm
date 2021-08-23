; Load DS with 0x7C00
; NOTE: 7C00 is the absolute memory address to which BIOS loads the boot sector
mov ax, 0x7C0
mov ds, ax

; Setup parameters for BIOS interrupt write char in TTY mode
mov ah, 0x0E
mov al, [ds:my_char]; Load content at the address my_char to AL using segmented addressing
; Because of we are using the segmented addressing relative to DS, CPU will resolve [ds:my_char] as [16*0x7C0+my_char]=[0x7C00+my_char]
int 0x10; Execute interrupt
jmp $; Infinte loop

; Define data addresses
my_char: db "N"

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55