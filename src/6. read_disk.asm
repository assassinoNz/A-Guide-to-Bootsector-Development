; USING BIOS 0x02 (READ SECTORS) FUNCTION OF THE 0x13 (LOW LEVEL DISK SERVICES) INTERRUPT VECTOR
; NOTE: Here we have to use a drive that chan be addressed using CHS (Cylinder, Head, Sector) addressing
[org 0x7C00]

; Setup arguments
mov ah, 0x2; Select read sectors function
; NOTE: We usually have to specify the disk in DL. But by default BIOS assigns DL with the boot drive. So let's not change it (So the following line is commented)
; mov dl, 0; Use disk 0
mov ch, 0; Use cylinder 0
mov dh, 0; Use head 0
mov cl, 2; Start from sector 2 (Because first sector is boot sector)
mov al, 2; Read 2 sectors

; NOTE: BIOS will store the retrieved setors in the memory starting from ES:BX
; The following setup will retrieve disk sectors to memory adresses starting from 0x0000:0x9000=0x9000
mov bx, 0x0000
mov es, bx
mov bx, 0x9000

; Execute interrupt
int 0x13

; NOTE: If BIOS fails to execute the interrupt at all, it will set the carry flag to 1, otherwise 0
jc printDiskError; Jump if the carry flag is 1
; NOTE: If BIOS manages to parially read the sectors, the carry flag will be 0 (So we have to involve other means to detect this error)
; NOTE: BIOS will update the AL to represent the actual sectors read
cmp al, 2
jne printSectorError

printDiskError:
    mov bx, DISK_ERROR
    call print_string
    ; NOTE: After a disk error, AH will be updated with the error code
    mov al, ah
    call print_byte_in_hex
    jmp print_memory

printSectorError:
    mov bx, SECTOR_ERROR
    call print_string
    jmp print_memory

DISK_ERROR: db "DISK_ERROR", 0
SECTOR_ERROR: db "SECTOR_ERROR", 0



print_memory:
    mov bx, 0x9000
    mov ch, 5 
    call print_memory_content

    mov bx, 0x9000+512
    mov ch, 5 
    call print_memory_content

    mov bx, 0x9000+1024
    mov ch, 5 
    call print_memory_content

    jmp $

; Helper routines
%include "src/16bit_util/print_string.asm"
%include "src/16bit_util/print_memory_content.asm"

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55

; Create the 2nd, 3rd, 4th, 5th sectors with known bytes
times 512 db 0xCA
times 512 db 0xFE
times 512 db 0xFA
times 512 db 0xCE