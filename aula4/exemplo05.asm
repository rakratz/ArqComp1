section .text
    global _start

_start:
    ; div (divisão)
    ; rax = quociente
    ; rdx = resto
    ; exeplo 23 / 5 entao rax (4) e rdx (3)
    mov rax, 23     ; rax =  23
    mov rbx, 5     ; rax =  5
    xor rdx, rdx   ; rdx = 0 (boa prática)

    div rbx  ; rax = rax / rbx

    mov rdi, rax ; No código de exit o valor echo $?
    mov rax, 60   ; sys_exit
    syscall