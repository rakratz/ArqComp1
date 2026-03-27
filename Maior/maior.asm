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

converter_numeros:
    mov rsi, num1
    call str_to_int
    mov r8, rax        ; Armazena o primeiro número em R8

    mov rsi, num2
    call str_to_int
    mov r9, rax        ; Armazena o segundo número em R9

comparacao:
    cmp r8, r9
    jg maior_label
    jl menor_label
    je igual_label

maior_label:
    mov rsi, msg_maior
    mov r10, tam_maior
    jmp imprime_resultado

menor_label:
    mov rsi, msg_menor
    mov r10, tam_menor
    jmp imprime_resultado

igual_label:
    mov rsi, msg_igual
    mov r10, tam_igual
    jmp imprime_resultado

imprime_resultado: 
     mov rax, 1 ; SYSWRITE
     mov rdi, 1
     mov rdx, r10
     syscall

finaliza_programa:
    mov rax, 60 ; SYSEXIT
    xor rdi, rdi
    syscall

; Sub-rotina para converter string para inteiro
str_to_int:
    xor rax, rax        ; Zera RAX para armazenar o número
    xor rcx, rcx        ; Zera RCX (contador)
.loop:
    movzx rdx, byte [rsi + rcx] ; Pega um caractere
    cmp rdx, 10  ; Se for '\n', termina a conversão
    je .done
    sub rdx, '0'         ; Converte ASCII para inteiro
    imul rax, rax, 10    ; Multiplica o número acumulado por 10
    add rax, rdx         ; Adiciona o novo dígito
    inc rcx              ; Passa para o próximo caractere
    jmp .loop
.done:
    ret
