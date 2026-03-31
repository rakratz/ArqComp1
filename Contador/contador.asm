section .data
    msg_fim db "Fim da contagem!", 10
    tam_fim equ $ - msg_fim

section .bss
    num resb 2   ; número + '\n'

section .text
    global _start

_start:
    mov r8, 9          ; começa em 9 (mais simples)

loop_contador:

    ; converte número para ASCII
    mov rax, r8
    add rax, '0'
    mov [num], al

    ; quebra de linha
    mov byte [num+1], 10

    ; imprime número
    mov rax, 1
    mov rdi, 1
    mov rsi, num
    mov rdx, 2
    syscall

    ; decrementa
    dec r8

    ; continua enquanto r8 > 0
    cmp r8, 0
    jg loop_contador

; mensagem final
fim:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_fim
    mov rdx, tam_fim
    syscall

; encerra programa
    mov rax, 60
    xor rdi, rdi
    syscall
