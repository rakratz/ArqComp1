section .data
    msg1 db "Digite o primeiro numero: "
    tam_msg1 EQU $ - msg1

    msg2 db "Digite o segundo numero: "
    tam_msg2 EQU $ - msg2

    msg_maior db "O Primeiro Valor eh Maior!", 10
    tam_msg_maior EQU $ - msg_maior

    msg_menor db "O Segundo Valor eh Maior!", 10
    tam_msg_menor EQU $ - msg_menor
    
    msg_igual db "Os Valores sao Iguais!", 10
    tam_msg_igual EQU $ - msg_igual


section .bss
    num1 resb 10
    num2 resb 10


section .text
    global _start


_start:

    ; ==========================================
    ; Leitura do primeiro número
    ; ==========================================

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, msg1
    mov rdx, tam_msg1
    syscall

    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, num1
    mov rdx, 10
    syscall


    ; ==========================================
    ; Leitura do segundo número
    ; ==========================================

    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, msg2
    mov rdx, tam_msg2
    syscall

    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, num2
    mov rdx, 10
    syscall


    ; ==========================================
    ; Converter primeiro número
    ; ==========================================

    mov rsi, num1
    call str_to_int

    mov r8, rax             ; r8 = primeiro número


    ; ==========================================
    ; Converter segundo número
    ; ==========================================

    mov rsi, num2
    call str_to_int

    mov r9, rax             ; r9 = segundo número


    ; ==========================================
    ; Comparação
    ; ==========================================

    cmp r8, r9

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
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    syscall


encerrar_programa:
    mov rax, 60             ; sys_exit
    mov rdi, 0
    syscall


; ==========================================
; Função: string -> inteiro
;
; Entrada:
;   RSI = endereço da string
;
; Saída:
;   RAX = número inteiro
; ==========================================

str_to_int:

    mov rax, 0              ; número convertido
    mov rcx, 0              ; posição atual

.loop:

    movzx rdx, byte [rsi + rcx]

    cmp rdx, 10             ; encontrou ENTER?
    je .done

    sub rdx, '0'            ; ASCII -> número

    imul rax, rax, 10
    add rax, rdx

    inc rcx
    jmp .loop

.done:
    ret