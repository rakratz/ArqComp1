section .text
    global str_to_int
    global int_to_str
    global exit_program

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

;---------------------------------
; exit_program
;---------------------------------
exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall