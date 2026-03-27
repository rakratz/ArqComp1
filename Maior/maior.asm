section .data
    msg_maior db "O primeiro numero e maior", 10, 0
    tam_maior equ $ - msg_maior
    msg_menor db "O primeiro numero e menor", 10, 0
    tam_menor equ $ - msg_menor
    msg_igual db "Os numeros sao iguais", 10, 0
    tam_igual equ $ - msg_igual 

    msg1 db "Digite o primeiro numero: ", 0
    tam1 equ $ - msg1
    msg2 db "Digite o segundo numero: ", 0
    tam2 equ $ - msg2

section .bss
    num1 resb 10
    num2 resb 10

section .text
    global _start

_start:

primeiro_numero: 
    mov rax, 1 ; Syswrite
    mov rdi, 1
    mov rsi, msg1
    mov rdx, tam1
    syscall

    mov rax, 0 ; Sysread
    mov rdi, 0
    mov rsi, num1
    mov rdx, 10
    syscall

segundo_numero: 
    mov rax, 1 ; Syswrite
    mov rdi, 1
    mov rsi, msg2
    mov rdx, tam2
    syscall

    mov rax, 0 ; Sysread
    mov rdi, 0
    mov rsi, num2
    mov rdx, 10
    syscall
