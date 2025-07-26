[org 0x7C00]
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov si, msg
.print_msg:
    lodsb
    or al, al
    jz load_kernel
    mov ah, 0x0E
    int 0x10
    jmp .print_msg

load_kernel:
    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    mov bx, 0x1000
    int 0x13
    jc disk_error

    jmp 0x0000:0x1000

disk_error:
    mov si, err_msg
.print_err:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0E
    int 0x10
    jmp .print_err

halt:
    cli
    hlt
    jmp halt

msg db "Loading WinDem Installer", 0
err_msg db "Disk read error!", 0

times 510-($-$$) db 0
dw 0xAA55
