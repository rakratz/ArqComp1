section .data
    msg_maior db "O Primeiro Valor eh Maior!", 10, 0
    tam_msg_maior EQU $ - msg_maior

    msg_menor db "O Segundo Valor eh Maior!", 10, 0
    tam_msg_menor EQU $ - msg_menor
    
    msg_igual db "Os Valores são Iguais!", 10, 0
    tam_msg_igual EQU $ - msg_igual

section .text
    global _start

_start:
    mov rax, 5          ; Primeiro número
    mov rbx, 7          ; Segundo número

    cmp rax, rbx

    je numeros_iguais
    jg primeiro_maior
    jl segundo_maior


numeros_iguais:
    mov rsi, msg_igual
    mov rdx, tam_msg_igual
    jmp imprimir


primeiro_maior:
    mov rsi, msg_maior
    mov rdx, tam_msg_maior
    jmp imprimir


segundo_maior:
    mov rsi, msg_menor
    mov rdx, tam_msg_menor
    jmp imprimir


imprimir:
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    syscall


encerrar_programa:
    mov rax, 60         ; sys_exit
    mov rdi, 0
    syscall