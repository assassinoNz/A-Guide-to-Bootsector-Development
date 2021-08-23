; Reads the specified number of sectors from the specified disk
; The read data will be stored starting from ES:BX

; PARAMETERS
; DH = Number of sectors to read
; DL = Drive to read

[bits 16]
read_sectors:
    pusha
    push dx

    ; Setup arguments
    mov al, dh; Number of sectors
    mov ah, 0x2; Select read sectors function
    mov ch, 0; Use cylinder 0
    mov dh, 0; Use head 0
    mov cl, 2; Start from sector 2 (Because first sector is boot sector)

    ; Execute interrupt
    int 0x13
    jc print_disk_error$read_sectors

    pop dx
    cmp al, dh
    jne print_sector_error$read_sectors

    return:
    popa
    ret

print_disk_error$read_sectors:
    mov bx, DISK_ERROR$read_sectors
    call print_string
    jmp return

print_sector_error$read_sectors:
    mov bx, SECTOR_ERROR$read_sectors
    call print_string
    jmp return

DISK_ERROR$read_sectors: db "DISK READ ERROR OCCURED", 0
SECTOR_ERROR$read_sectors: db "SECTOR READ ERROR OCCURED", 0

%include "src/16bit_util/print_string.asm"