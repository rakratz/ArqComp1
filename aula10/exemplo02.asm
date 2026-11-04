section .data
    msg db "Hello", 10, 0 ;Mensagem "Hello" com nova linha
    tam_msg equ $ - msg

section .text
    global _start

_start:
    mov r10, 5 ; R10 não é usado pela syscall. usar como contador

loop_inicio:
    ; Exibir a msg:Hello cinco vezes na tela
    mov rax, 1 ; syscall write
    mov rdi, 1 ; stdout
    mov rsi, msg ; Mensagem
    mov rdx, tam_msg ; Tamanho da mensagem
    syscall
    dec r10
    jnz loop_inicio
    ; Finalizar o programa
    mov rax, 60
    xor rdi, rdi
    syscall

