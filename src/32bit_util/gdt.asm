; A GDT contains a set of segment discriptors(SD) each with 8bytes
; GDT doesn't have a predefined length. It's length is based on the number of SDs inside it
; An SD holds the structural data about a segement in RAM
; Address of each SD is stored in segment registers
; Each SD must either store data or instructions

; NOTE: There are several ways to segement the memory using SDs. In here we use the basic flat model. It uses 3 SDs (null SD, code SD, instruction SD) where code and instruction SDs fully overlap each other

gdt_start:
sd_null:; Null SD
    dd 0x0; ’dd ’ means define double word (4 bytes)
    dd 0x0
sd_code:; Instruction SD
    ; base=0x0 , limit=0xFFFFF,
    ; 1st flags : ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
    ; type flags : ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
    ; 2nd flags : ( granularity )1 (32 - bit default )1 (64 - bit seg )0 ( AVL )0 -> 1100 b
    dw 0xFFFF ; Limit ( bits 0 -15)
    dw 0x0 ; Base ( bits 0 -15)
    db 0x0 ; Base ( bits 16 -23)
    db 10011010b ; 1st flags , type flags
    db 11001111b ; 2nd flags , Limit ( bits 16 -19)
    db 0x0 ; Base ( bits 24 -31)
sd_data:; Data SD
    ; Same as code segment except for the type flags :
    ; type flags : ( code )0 ( expand down )0 ( writable )1 ( accessed )0 -> 0010 b
    dw 0xffff ; Limit ( bits 0 -15)
    dw 0x0 ; Base ( bits 0 -15)
    db 0x0 ; Base ( bits 16 -23)
    db 10010010b ; 1st flags , type flags
    db 11001111b ; 2nd flags , Limit ( bits 16 -19)
    db 0x0 ; Base ( bits 24 -31)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1; Size of our GDT. Always less one of the true size
    dd gdt_start; Start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0 x10 in PM , the CPU knows that we mean it to use the
; segment described at offset 0 x10 ( i.e. 16 bytes ) in our GDT , which in our
; case is the DATA segment (0 x0 -> NULL ; 0x08 -> CODE ; 0 x10 -> DATA )
CODE_SD_OFFSET equ sd_code - gdt_start; Store the code SD offset from the start of GDT
DATA_SD_OFFSET equ sd_data - gdt_start; Store the data SD offset from the start of GDT