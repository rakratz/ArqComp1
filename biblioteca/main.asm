%include "lib.inc"

section .data
    input db "123", 10
    msg db "Resultado: ", 0
    newline db 10

section .bss
    buffer resb 16

section .text
    global _start

_start:
    ; string → int
    mov rsi, input
    call str_to_int

    ; cálculo
    add rax, rax

    ; int → string
    mov rdi, buffer
    call int_to_str

cle

    ; imprimir número
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; sair
    call exit_program