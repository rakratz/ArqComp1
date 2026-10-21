
section .bss
    buffer resb 16
    resultado resb 16

section .data
    msg_pedir db "Digite um numero positivo: "
    tam_msg_pedir equ $ - msg_pedir

    msg_resultado db "Numero final: "
    tam_msg_resultado equ $ - msg_resultado

    newline db 10

section .text
    global _start

_start:
    ; Exibir mensagem de entrada
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_pedir
    mov rdx, tam_msg_pedir
    syscall

    ; Ler numero digitado
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; Converter string para inteiro
    mov rsi, buffer
    call str_to_int

    ; Verificar se o numero e maior que 10
    cmp rax, 10
    jle nao_dobrar

    ; Dobrar o numero
    shl rax, 1

nao_dobrar:
    ; Converter numero para string
    mov rdi, resultado
    call int_to_string

    ; Guardar tamanho da string
    mov r8, rax

    ; Exibir mensagem do resultado
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_resultado
    mov rdx, tam_msg_resultado
    syscall

    ; Exibir numero convertido
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado
    mov rdx, r8
    syscall

    ; Pular linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Finalizar programa
    mov rax, 60
    xor rdi, rdi
    syscall

; ----------------------------
; Funcao: str_to_int
; Converte string para inteiro
; ----------------------------
str_to_int:
    xor rax, rax
    xor rcx, rcx

.loop:
    movzx rdx, byte [rsi + rcx]
    cmp rdx, 10
    je .done

    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx

    inc rcx
    jmp .loop

.done:
    ret

; ----------------------------
; Funcao: int_to_string
; Converte inteiro para string
; ----------------------------
int_to_string:
    mov rbx, 10
    xor rcx, rcx

.loop:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx
    inc rcx

    test rax, rax
    jnz .loop

    ; Guardar quantidade de digitos
    mov r8, rcx

.reverse:
    pop rax
    mov [rdi], al
    inc rdi
    loop .reverse

    ; Retornar tamanho da string
    mov rax, r8
    ret
