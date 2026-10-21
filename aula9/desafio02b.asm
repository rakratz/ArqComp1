
section .bss
    buffer resb 16
    resultado resb 21

section .data
    msg_pedir db "Digite um numero positivo: "
    tam_msg_pedir equ $ - msg_pedir

    msg_resultado db "Numero final: "
    tam_msg_resultado equ $ - msg_resultado

    msg_erro db "Entrada invalida ou numero muito grande!", 10
    tam_msg_erro equ $ - msg_erro

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

    ; Ler entrada do usuario
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; Verificar se houve leitura
    test rax, rax
    jle erro

    ; Converter string para inteiro
    mov rsi, buffer
    mov r8, rax
    call str_to_int

    ; Se conversao falhou, exibir erro
    jc erro

    ; Verificar se e maior que 10
    cmp rax, 10
    jle nao_dobrar

    ; Dobrar numero maior que 10
    shl rax, 1
    jc erro

nao_dobrar:
    ; Converter resultado para string
    mov rdi, resultado
    call int_to_string

    ; Guardar quantidade de caracteres
    mov r9, rax

    ; Exibir mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_resultado
    mov rdx, tam_msg_resultado
    syscall

    ; Exibir numero convertido
    mov rax, 1
    mov rdi, 1
    mov rsi, resultado
    mov rdx, r9
    syscall

    ; Exibir nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    jmp fim

erro:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_erro
    mov rdx, tam_msg_erro
    syscall

fim:
    mov rax, 60
    xor rdi, rdi
    syscall

; ----------------------------
; Funcao: str_to_int
; Converte string para inteiro
; RAX = numero convertido
; CF = 1 em caso de erro
; ----------------------------
str_to_int:
    xor rax, rax
    xor rcx, rcx

.loop:
    cmp rcx, r8
    jae .done

    movzx rdx, byte [rsi + rcx]

    cmp rdx, 10
    je .done

    cmp rdx, '0'
    jb .invalid

    cmp rdx, '9'
    ja .invalid

    ; Limitar a 15 digitos
    cmp rcx, 15
    jae .invalid

    sub rdx, '0'
    imul rax, rax, 10
    add rax, rdx

    inc rcx
    jmp .loop

.done:
    ; Exigir pelo menos um digito
    test rcx, rcx
    jz .invalid

    ; Exigir numero positivo
    test rax, rax
    jz .invalid

    clc
    ret

.invalid:
    stc
    ret

; ----------------------------
; Funcao: int_to_string
; Converte inteiro para string
; Retorna tamanho em RAX
; ----------------------------
int_to_string:
    mov rbx, 10
    xor rcx, rcx
    xor r10, r10

    test rax, rax
    jnz .loop

    mov byte [rdi], '0'
    mov rax, 1
    ret

.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .loop

    mov r10, rcx

.reverse:
    pop rax
    mov [rdi], al
    inc rdi
    loop .reverse

    mov rax, r10
    ret
