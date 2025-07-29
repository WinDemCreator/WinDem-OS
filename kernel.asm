[org 0x1000]
bits 16

segment .data
prompt db 'Z:\> ', 0
help_msg db 'Commands available:', 0
ver_msg db 'WinDem OS V4.0', 0
unknown_cmd_msg db 'Commande Inconnue !', 0
exit_msg db 'Exiting shell...', 0
mem_msg db 'Memory used: ', 0
echo_prefix db '', 0
play_msg db 'Launching game... (Desollée, le jeu ne peux pas se lancer).', 0

commands_count dw 8

command1 db ' help', 0
command2 db ' exit', 0
command3 db ' ver', 0
command4 db ' create', 0
command5 db ' read', 0
command6 db ' clear', 0
command7 db ' mem', 0
command8 db ' echo', 0
command9 db ' play', 0

help_str db 'help',0
exit_str db 'exit',0
ver_str db 'ver',0
create_str db 'create',0
read_str db 'read',0
clear_str db 'clear',0
mem_str db 'mem',0
echo_str db 'echo',0
play_str db 'play',0

input_buffer times 64 db 0
file_buffer times 512 db 0

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
    call process_command
    call print_newline
    jmp shell_loop

clear_screen:
    mov ax, 0x0600
    mov bh, 0x1F
    mov cx, 0
    mov dx, 0x184F
    int 0x10
    mov byte [line_num], 0
    ret

scroll_screen:
    mov ax, 0x0601
    mov bh, 0x1F
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    ret

print_prompt_at_line:
    mov al, [line_num]
    cmp al, 24
    jbe .no_scroll
    call scroll_screen
    mov al, 24
    mov [line_num], al
.no_scroll:
    mov ah, 0x02
    mov bh, 0
    mov dh, al
    mov dl, 0
    int 0x10
    mov si, prompt
    call print_string
    ret

read_line:
    mov di, input_buffer
    xor cx, cx
.read_char:
    mov ah, 0
    int 0x16
    call map_azerty
    cmp al, 8
    je .backspace
    cmp al, 13
    je .done
    mov [di], al
    inc di
    inc cx
    mov ah, 0x0E
    int 0x10
    cmp cx, 63
    jl .read_char
.done:
    mov byte [di], 0
    ret
.backspace:
    cmp cx, 0
    je .read_char
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    jmp .read_char

print_newline:
    mov al, [line_num]
    inc al
    cmp al, 25
    jl .no_scroll
    call scroll_screen
    mov al, 24
.no_scroll:
    mov [line_num], al
    mov ah, 0x02
    mov bh, 0
    mov dh, al
    mov dl, 0
    int 0x10
    ret

process_command:
    mov si, input_buffer
    mov di, help_str
    call str_compare
    je do_help
    mov di, exit_str
    call str_compare
    je do_exit
    mov di, ver_str
    call str_compare
    je do_ver
    mov di, create_str
    call str_compare_prefix
    je do_create
    mov di, read_str
    call str_compare_prefix
    je do_read
    mov di, clear_str
    call str_compare
    je do_clear
    mov di, mem_str
    call str_compare
    je do_mem
    mov di, echo_str
    call str_compare_prefix
    je do_echo
    mov di, play_str
    call str_compare
    je do_play

    call print_newline
    mov si, unknown_cmd_msg
    call print_string
    jmp done

do_help:
    call print_newline
    mov si, help_msg
    call print_string
    call print_newline
    mov cx, [commands_count]
    mov bx, 1
.print_cmd_loop:
    cmp bx, 1
    je .print1
    cmp bx, 2
    je .print2
    cmp bx, 3
    je .print3
    cmp bx, 4
    je .print4
    cmp bx, 5
    je .print5
    cmp bx, 6
    je .print6
    cmp bx, 7
    je .print7
    cmp bx, 8
    je .print8
    jmp done
.print1:
    mov si, command1
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print2:
    mov si, command2
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print3:
    mov si, command3
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print4:
    mov si, command4
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print5:
    mov si, command5
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print6:
    mov si, command6
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print7:
    mov si, command7
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop
.print8:
    mov si, command9
    call print_string
    call print_newline
    inc bx
    jmp .print_cmd_loop

do_exit:
    call print_newline
    mov si, exit_msg
    call print_string
    cli
    hlt

do_ver:
    call print_newline
    mov si, ver_msg
    call print_string
    jmp done

do_clear:
    call clear_screen
    jmp done

do_mem:
    call print_newline
    mov al, 0
    add al, '0'
    mov si, mem_msg
    call print_string
    mov ah, 0x0E
    mov al, al
    int 0x10
    jmp done

do_echo:
    call print_newline
    mov si, echo_prefix
    call print_string
    mov si, input_buffer
    call skip_command_name
.echo_loop:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp .echo_loop

do_create:
    call clear_screen
    mov di, file_buffer
    xor cx, cx
.text_input:
    mov ah, 0
    int 0x16
    call map_azerty
    cmp al, 1
    je .save_and_exit
    cmp al, 8
    je .del
    mov [di], al
    inc di
    inc cx
    mov ah, 0x0E
    int 0x10
    cmp cx, 511
    jl .text_input
.save_and_exit:
    mov byte [di], 0
    call clear_screen
    jmp done
.del:
    cmp cx, 0
    je .text_input
    dec di
    dec cx
    mov ah, 0x0E
    mov al, 8
    int 0x10
    mov al, ' '
    int 0x10
    mov al, 8
    int 0x10
    jmp .text_input

do_read:
    call print_newline
    mov si, file_buffer
.read_loop:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp .read_loop

do_play:
    call print_newline
    mov si, play_msg
    call print_string

    jmp 0x2000:0000

done:
    ret

; ----------------------------
; Map AZERTY keyboard to QWERTY
map_azerty:
    cmp al, 'q'
    jne .not_q
    mov al, 'a'
    ret
.not_q:
    cmp al, 'a'
    jne .not_a
    mov al, 'q'
    ret
.not_a:
    cmp al, 'w'
    jne .not_w
    mov al, 'z'
    ret
.not_w:
    cmp al, 'z'
    jne .not_z
    mov al, 'w'
    ret
.not_z:
    cmp al, ';'
    jne .not_m
    mov al, 'm'
    ret
.not_m:
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

str_compare_prefix:
    push si
    push di
.prefix_loop:
    mov al, [di]
    cmp al, 0
    je .match
    cmp al, [si]
    jne .no_match
    inc si
    inc di
    jmp .prefix_loop
.match:
    xor ax, ax
    pop di
    pop si
    ret
.no_match:
    mov ax, 1
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

skip_command_name:
.skip_letters:
    mov al, [si]
    cmp al, ' '
    je .skip_spaces
    cmp al, 0
    je .done_skip
    inc si
    jmp .skip_letters
.skip_spaces:
    inc si
.skip_spaces_loop:
    mov al, [si]
    cmp al, ' '
    jne .done_skip
    inc si
    jmp .skip_spaces_loop
.done_skip:
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
