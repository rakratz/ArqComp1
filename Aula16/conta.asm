section .data
    prompt db "Digite uma string: "
    prompt_len equ $ - prompt

    resultado db "Quantidade de vogais: "
    resultado_len equ $ - resultado

    fim_linha db 10

section .bss
    buffer resb 100
    count  resb 1

section .text
    global _start

_start:

    ; Inicializações
    mov byte [count], 0
    xor rbx, rbx

    ; Prompt
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Leitura
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 100
    syscall

    mov rcx, rax

loop_caractere:

    cmp rbx, rcx
    jge imprime_resultado

    mov al, [buffer + rbx]

    cmp al, 'a'
    je inc_vogal
    cmp al, 'e'
    je inc_vogal
    cmp al, 'i'
    je inc_vogal
    cmp al, 'o'
    je inc_vogal
    cmp al, 'u'
    je inc_vogal

    ; Maiúsculas
    cmp al, 'A'
    je inc_vogal
    cmp al, 'E'
    je inc_vogal
    cmp al, 'I'
    je inc_vogal
    cmp al, 'O'
    je inc_vogal
    cmp al, 'U'
    je inc_vogal

proximo:
    inc rbx
    jmp loop_caractere

inc_vogal:
    inc byte [count]
    jmp proximo

imprime_resultado:

    ; Texto
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado
    mov rdx, resultado_len
    syscall

    ; Conversão simples
    movzx rax, byte [count]
    add al, '0'
    mov [count], al

    ; Impressão do número
    mov rax, 1
    mov rdi, 1
    mov rsi, count
    mov rdx, 1
    syscall

    ; Quebra de linha
    mov rax, 1
    mov rdi, 1
    mov rsi, fim_linha
    mov rdx, 1
    syscall

    ; Encerrar
    mov rax, 60
    xor rdi, rdi
    syscall