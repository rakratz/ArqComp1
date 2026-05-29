section .data
    prompt db "Digite uma string: ", 0
    prompt_len  equ $ - prompt

    resultado   db "Quantidade de vogais: ", 0
    resultado_len equ $ - resultado

    fim_linha   db 10  ; \n

section .bss
    buffer resb 100    ; espaço para a string digitada
    count  resb 1      ; contador de vogais

section .text
    global _start

_start:
    ; Escreve o prompt
    mov rax, 1      ; sys_write
    mov rdi, 1      ; saída padrão
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Lê a string
    mov rax, 0      ; sys_read
    mov rdi, 0      ; entrada padrão
    mov rsi, buffer
    mov rdx, 100
    syscall
    mov rcx, rax    ; rcx = número de caracteres lidos

    ; Zera o contador
    mov byte [count], 0
    xor rbx, rbx            ; índice = 0

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
proximo:
    inc rbx
    jmp loop_caractere

inc_vogal: 
    inc byte [count]
    jmp proximo

imprime_resultado:
    ; Escreve o texto do resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado
    mov rdx, resultado_len
    syscall

    ; Convete de numérico para caracter ASCII (0 - 9) + '0' (0x30)
    movzx rax, byte [count]
    add al , '0'
    mov [count], al

    ; Escreve o número de vogais
    mov rax, 1
    mov rdi, 1
    mov rsi, count
    mov rdx, 1
    syscall

    ; Imprime nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, fim_linha
    mov rdx, 1
    syscall


    ; Finaliza o programa
    mov rax, 60
    xor rdi, rdi
    syscall
