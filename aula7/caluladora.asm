section .data
    prompt1 db 'Digite o primeiro número: ', 0
    tam_prompt1 EQU $ - prompt1

    prompt2 db 'Digite o segundo número: ', 0
    tam_prompt2 EQU $ - prompt2

    prompt_op db 'Digite o operador (+, -, *, /): ', 0
    tam_op EQU $ - prompt_op

    result_msg db 'Resultado: ', 0
    tam_result_msg EQU $ - result_msg

    newline db 10, 0

section .bss
    num1 resb 16
    num2 resb 16
    op resb 2
    result resb 16
    
section .text
    global _start

_start:

; *************************
; ENTRADA DO PRIMEIRO VALOR
; *************************
    ; Solicitar primeiro número
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt1
    mov rdx, tam_prompt1
    syscall

    ; Ler primeiro número
    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 16
    syscall
; *************************
;    ENTRADA DO OPERADOR
; *************************
    ; Solicitar operador
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt_op
    mov rdx, tam_op
    syscall

    ; Ler operador
    mov rax, 0
    mov rdi, 0
    mov rsi, op
    mov rdx, 2
    syscall
; *************************
; ENTRADA DO SEGUNDO VALOR
; *************************
    ; Solicitar segundo número
    mov rax, 1
    mov rdi, 1
    mov rsi, prompt2
    mov rdx, tam_prompt2
    syscall

    ; Ler segundo número
    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 16
    syscall

; *********************************
; CONVERTER OS VALORES PARA INTEIRO
; *********************************
    call atoi_num1
    call atoi_num2

; *********************************
; REALIZAR A OPERAÇÃO MATEMÁTICA
; *********************************
    mov bl, [op]
    cmp bl, '+'
    je add_valores
    cmp bl, '-'
    je sub_valores
    cmp bl, '*'
    je mul_valores
    cmp bl, '/'
    je div_valores

add_valores:
    mov rax, [num1]
    add rax, [num2]
    jmp print_result
sub_valores:
    mov rax, [num1]
    sub rax, [num2]
    jmp print_result
    
mul_valores:

div_valores:

print_result:

atoi_num1:
    xor rax, rax;
    mov rsi, num1
 .next:
    movzx rcx, byte [rsi]
    cmp rcx, 10
    je .done
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .next
.done:
    mov [num1], rax
    ret

atoi_num2:
    xor rax, rax;
    mov rsi, num2
 .next:
    movzx rcx, byte [rsi]
    cmp rcx, 10
    je .done
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .next
.done:
    mov [num2], rax
    ret