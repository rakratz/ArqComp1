section .text
    global _start

_start:
    ; Soma
    mov rax, 10
    mov rbx, 20
    add rax, rbx ; rax = 30
    ; Suntração
    sub rax, 5 ; rax = 25
    ; Multiplicação
    imul rax, 2 ; rax = 50
    ; Divisão
    mov rbx, 3
    mov rdx, 0
    div rbx ;   rax = 16 e rdx = 2

    mov rdi, rax ; No código de exit o valor echo $?
    mov rax, 60   ; sys_exit
    syscall