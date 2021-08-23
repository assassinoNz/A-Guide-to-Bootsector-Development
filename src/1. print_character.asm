; USING BIOS 0x0E (WRITE CHAR IN TTY MODE) FUNCTION OF THE 0x10 (VIDEO SERVICES) INTERRUPT VECTOR

; Setup arguments
mov ah, 0xE; Select write character in TTY mode function
mov al, "H"; Load ASCII value of H to AL

; Execute interrupt
int 0x10

; Execute interrupt several times by changing the arguments
mov al, "e"
int 0x10
mov al, "l"
int 0x10
mov al, "l"
int 0x10
mov al, "o"
int 0x10

jmp $; Infinite loop

; Make the bootsector 512bytes long
times 510-($-$$) db 00; pad with "0" until it reaches 510th byte

; Mark the end of the bootsector with the magic number
; NOTE: The magic number is AA55. Because of littile endian notation, it will be converted to 55AA
dw 0xAA55; write magic number at the end