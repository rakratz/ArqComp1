section .data
    msg_fim db "Fim da contagem!", 10
    tam_fim equ $ - msg_fim

section .bss
    num resb 3   ; até 2 dígitos + '\n'

section .text
    global _start

_start:
    mov r8, 10

loop_contador:

    mov rax, r8

    cmp rax, 10
    jl um_digito

    ; dois dígitos
    mov rbx, 10
    xor rdx, rdx
    div rbx        ; rax = dezena, rdx = unidade

    add al, '0'
    mov [num], al

    add dl, '0'
    mov [num+1], dl

    mov byte [num+2], 10

    mov rax, 1
    mov rdi, 1
    mov rsi, num
    mov rdx, 3
    syscall

    jmp continua

um_digito:
    add al, '0'
    mov [num], al

    mov byte [num+1], 10

    mov rax, 1
    mov rdi, 1
    mov rsi, num
    mov rdx, 2
    syscall

continua:
    dec r8
    cmp r8, 0
    jg loop_contador

; mensagem final
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_fim
    mov rdx, tam_fim
    syscall

; saída
    mov rax, 60
    xor rdi, rdi
    syscall
