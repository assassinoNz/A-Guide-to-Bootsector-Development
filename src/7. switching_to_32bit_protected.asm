[org 0x7C00]
; Update stack pointers to be at the top of the free space
mov bp, 0x9000
mov sp, bp

; call switch_to_protected; We will never return from this call
; jmp $

[bits 16]
switch_protected:
    ; Load 512x15bytes(15 sectors) which includes our kernel to the memory location 0x1000
    mov dh, 2
    mov bx, 0x0000
    mov es, bx
    mov bx, 0x1000
    call read_sectors

    ; Define GDT
    %include "src/32bit_util/gdt.asm"

    cli; Clear interrupts
    lgdt [gdt_descriptor]; Tell the CPU the start and the size of our GDT

    ; Set the last bit of the CR0 regiter to 1. All other bits should be kept intact
    ; NOTE: CR0 cannot be alterd directly
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SD_OFFSET:init_protected; Perform a far jump to flush CPU pipelines of old 16bit code
    ; NOTE: A far jump has the folllowing syntax jmp <offset_to_an_SD_from_GDT>:<offset_to_an_instruction_from_SD>
    ; NOTE: Since our code SD in the GDT has the base as 0x0 (the first address of RAM), we can safely assume "init_protected" is also the offset of "init_protected" from our code SD

[bits 32]
init_protected:
    ; Initialize segement registerd to point to our SDs in the GDT
    ; Note: Since our code and instruction SDs both fully overlap each other we only need one pointer
    mov ax, DATA_SD
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Update stack pointers to be at the top of the free space
    mov ebp, 0x90000
    mov esp, ebp


    jmp 0x1000; Jump to the initial address of the kernel code

; Helper routines
%include "src/32bit_util/read_sectors.asm"

; Padding of bootsector and addition of the magic number
times 510-($-$$) db 00
dw 0xAA55

; Kernel code
[org 0x1000]
mov ebx, STR
call print_string

jmp $

STR: db "HELLO WORLD", 0

%include "src/32bit_util/print_string.asm"