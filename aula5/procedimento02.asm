section .data
    input_str db "123", 10, 0 ; String \n no final
    msg_original db "Valor original: ", 0
    msg_modificado db "Valor modificado: ", 0
    new_line db 10, 0 ; 10 = \n e 0 = end of line em ASCII

section .bss
    result resb 16
    modificado resb 16

section .text
    global _start

_start:
    ; converter "123" para inteiro
    mov rsi, input_str
    call str_to_int

    mov [modificado], rax
    call print_original
    call print_alterado

    ; Encerrar o programa
    mov rax, 60
    mov rdi, 0
    syscall

str_to_int:
    mov rax, 0 ; Armazenar o número
    mov rcx, 0 ; Contador
    .loop:
        movzx rdx, bytes[rsi + rcx]
        cmp rdx, 10
        je .done
        sub rdx, '0'        ; retornat um valor de 0 até 9
        imul rax, rax, 10
        add rax, rdx
        inc rcx
        jmp .loop
    .done:
        ret

print_original:
    mov rax, 1      ; Syswrite
    mov rdi, 1
    mov rsi, msg_original
    mov rdx, 17
    syscall
    mov rax, 1      ; Syswrite
    mov rdi, 1
    mov rsi, input_str
    mov rdx, 4
    syscall
    ret

print_alterado:
    
    ret