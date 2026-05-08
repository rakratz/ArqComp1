section .data
    msg_entrada db "Digite um numero: "
    tam_msg_entrada EQU $ - msg_entrada

    msg_par db "O numero eh PAR!", 10
    tam_msg_par EQU $ - msg_par

    msg_impar db "O numero eh IMPAR!", 10
    tam_msg_impar EQU $ - msg_impar

section .bss
    buffer resb 16
    resultado resb 1

section .text
    global _start

_start:

    ; ==========================
    ; Exibir mensagem
    ; ==========================
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_entrada
    mov rdx, tam_msg_entrada
    syscall

    ; ==========================
    ; Ler teclado
    ; ==========================
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; ==========================
    ; Conversao string -> inteiro
    ; RSI precisa apontar para buffer
    ; Resultado volta em RAX
    ; ==========================
    mov rsi, buffer
    call str_to_int

    ; ==========================
    ; Verifica PAR ou IMPAR
    ; ==========================
    and rax, 1

    cmp rax, 0

    sete byte [resultado]

    movzx rdi, byte [resultado]

    test rdi, rdi

    jnz print_par

    jmp print_impar

; =========================================
; PRINT PAR
; =========================================
print_par:

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_par
    mov rdx, tam_msg_par
    syscall

    jmp fim

; =========================================
; PRINT IMPAR
; =========================================
print_impar:

    mov rax, 1
    mov rdi, 1
    mov rsi, msg_impar
    mov rdx, tam_msg_impar
    syscall

    jmp fim

; =========================================
; STR_TO_INT
; Entrada:
;   RSI -> string
;
; Saida:
;   RAX -> inteiro convertido
; =========================================
str_to_int:

    xor rax, rax ; Zera acumulador
    xor rcx, rcx ; Contador

.loop:

    movzx rdx, byte [rsi + rcx]

    ; Verifica ENTER
    cmp rdx, 10
    je .done

    ; ASCII -> numero
    sub rdx, '0'

    ; multiplica por 10
    imul rax, rax, 10

    ; soma digito
    add rax, rdx

    inc rcx
    jmp .loop

.done:
    ret

; =========================================
; FIM
; =========================================
fim:

    mov rax, 60
    xor rdi, rdi
    syscall