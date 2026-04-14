section .data
    input_str db "123", 10
    tam_input_str EQU $ - input_str

    msg_original db "Valor original: "
    tam_msg_original EQU $ - msg_original

    msg_modificado db "Valor modificado: "
    tam_msg_modificado EQU $ - msg_modificado

    newline db 10

section .bss
    result resb 16
    modificado resq 1   ; agora guarda inteiro (64 bits)

section .text
    global _start

_start:

    ; --- string → int ---
    mov rsi, input_str
    call str_to_int          ; resultado em RAX

    ; salva valor original
    mov [modificado], rax

    ; altera valor
    call alterar_valor       ; RAX modificado

    ; salva valor modificado
    mov [modificado], rax

    ; imprime original
    call print_original

    ; imprime modificado
    call print_modificado

    ; encerra
    call encerra_programa

;---------------------------------
; altera_valor
;---------------------------------
alterar_valor:
    add rax, 10
    sub rax, 5
    ret

;---------------------------------
; print_original
;---------------------------------
print_original:
    ; mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_original
    mov rdx, tam_msg_original
    syscall

    ; string original
    mov rax, 1
    mov rdi, 1
    mov rsi, input_str
    mov rdx, tam_input_str
    syscall

    ret

;---------------------------------
; print_modificado
;---------------------------------
print_modificado:
    ; mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_modificado
    mov rdx, tam_msg_modificado
    syscall

    ; número → string
    mov rax, [modificado]
    mov rdi, result
    call int_to_str

    ; imprimir número convertido
    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, 16
    syscall

    ; nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ret

;---------------------------------
; encerra_programa
;---------------------------------
encerra_programa:
    mov rax, 60
    xor rdi, rdi
    syscall

;---------------------------------
; str_to_int
; RSI → string
; retorna em RAX
;---------------------------------
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

;---------------------------------
; int_to_str
; RAX → número
; RDI → buffer destino
;---------------------------------
int_to_str:
    mov rbx, 10
    xor rcx, rcx

.loop:
    xor rdx, rdx
    div rbx

    add dl, '0'
    push rdx
    inc rcx

    test rax, rax
    jnz .loop

.reverse:
    pop rax
    mov [rdi], al
    inc rdi
    loop .reverse

    mov byte [rdi], 0
    ret
