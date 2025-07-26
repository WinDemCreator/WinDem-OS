[org 0x1000]
bits 16

segment .data
prompt db '> ', 0
help_msg db 'Commands available:', 0

commands_count dw 2
command1 db ' help', 0
command2 db ' exit', 0

unknown_cmd_msg db 'Unknown command!', 0
exit_msg db 'Exiting shell...', 0

input_buffer times 32 db 0

segment .bss
line_num resb 1

segment .text
start:
    call clear_screen
    call enable_cursor
    mov byte [line_num], 0

shell_loop:
    call print_prompt_at_line
    call read_line
    call print_newline
    call process_command
    jmp shell_loop

clear_screen:
    mov ax, 0x0600
    mov bh, 0x1F         ; fond bleu, texte blanc
    mov cx, 0
    mov dx, 0x184F       ; écran entier
    int 0x10
    ret

print_prompt_at_line:
    mov al, [line_num]
    inc al
    mov [line_num], al
    mov ah, 0x02         ; position curseur
    mov bh, 0
    mov dh, al
    mov dl, 0
    int 0x10

    mov si, prompt
    call print_string
    ret

read_line:
    mov di, input_buffer
    mov cx, 0

.read_char:
    mov ah, 0
    int 0x16
    cmp al, 0x0D         ; Entrée ?
    je .done

    mov ah, 0x0E
    int 0x10

    mov [di], al
    inc di
    inc cx
    cmp cx, 31           ; max 31 chars
    jl .read_char
.done:
    mov byte [di], 0
    ret

print_newline:
    mov al, [line_num]
    inc al
    mov [line_num], al
    mov ah, 0x02         ; position curseur nouvelle ligne
    mov bh, 0
    mov dh, al
    mov dl, 0
    int 0x10
    ret

process_command:
    mov si, input_buffer

    mov di, help_str
    call str_compare
    je .do_help

    mov di, exit_str
    call str_compare
    je .do_exit

    mov si, unknown_cmd_msg
    call print_string
    jmp .done

.do_help:
    mov si, help_msg
    call print_string
    call print_newline

    mov cx, [commands_count]
    mov bx, 1

.print_cmd_loop:
    cmp bx, 1
    je .print_cmd1
    cmp bx, 2
    je .print_cmd2
    jmp .done

.print_cmd1:
    mov si, command1
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop

.print_cmd2:
    mov si, command2
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop

.do_exit:
    mov si, exit_msg
    call print_string
    cli
    hlt

.done:
    ret

str_compare:
    push si
    push di
.next_char:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .not_equal
    cmp al, 0
    je .equal
    inc si
    inc di
    jmp .next_char
.not_equal:
    mov ax, 1
    jmp .end
.equal:
    xor ax, ax
.end:
    pop di
    pop si
    ret

print_string:
    pusha
.print_loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .print_loop
.done:
    popa
    ret

enable_cursor:
    push ax
    mov dx, 0x3D4
    mov al, 0x0A
    out dx, al
    inc dx
    mov al, 0
    out dx, al
    dec dx
    mov al, 0x0B
    out dx, al
    inc dx
    mov al, 15
    out dx, al
    pop ax
    ret

help_str db 'help',0
exit_str db 'exit',0
