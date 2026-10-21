section .text
    global _start

_start:
    mov rax, 50     ; rax = 50
    mov rbx, -20     ; rbx = 20

    sub rax, rbx    ; rax = rax - rbx

    mov rdi, rax ; No código de exit o valor da soma $?
    mov rax, 60   ; sys_exit
    syscall