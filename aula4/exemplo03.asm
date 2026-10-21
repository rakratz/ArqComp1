section .text
    global _start

_start:
    mov rax, 10     ; rax =  10
    inc rax         ; rax += 1 ou rax = rax  + 1
    inc rax         ; rax += 1 ou rax = rax  + 1
    dec rax         ; rax -= 1 ou rax = rax  - 1

    mov rdi, rax ; No código de exit o valor echo $?
    mov rax, 60   ; sys_exit
    syscall