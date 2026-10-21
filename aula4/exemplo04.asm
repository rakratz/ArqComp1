section .text
    global _start

_start:
    ; imul (multiplicação)
    mov rax, 10     ; rax =  10
    mov rbx, 5     ; rax =  5
    imul rax, rbx  ; rax = rax * rbx
   ; imul rax, rbx, 3 ; rax = rbx * 3

    mov rdi, rax ; No código de exit o valor echo $?
    mov rax, 60   ; sys_exit
    syscall