section .text
    global _start

_start:
    mov rax, -10
    mov rbx, 20

    add rax, rbx

    mov rdi, rax ; No código de exit o valor da soma $?
    mov rax, 60   ; sys_exit
    syscall