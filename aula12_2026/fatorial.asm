; Calcular o Fatorial de um número
section .data
    msg db "Digite um numero (0 a 9): ", 0
    tam_msg EQU $ - msg

    resultado_msg db "Fatorial = ", 0
    tam_resultado_msg EQU $ - resultado_msg

section .bss
    entrada resb 2
    saida resb 10

section .text
    global _start

_start:
    ; Exibir a Mensagem
    mov rax, 1 ; SysWrite
    mov rdi, 1 ; Stdout
    mov rsi, msg
    mov rdx, tam_msg
    syscall

    ; Ler o Número
    mov rax, 0 ; SysRead
    mov rdi, 0 ; Stdin
    mov rsi, entrada
    mov rdx, 2
    syscall

    ; Encerrar
    mov rax, 60 ; SysExit
    mov rdi, 0 ; StdExit (0 = sem erro)
    syscall
