section .text 
    global _start

_start:
    ; Saltos incondicionaias (jmp)
    jmp _rotina2

_rotina1:
    mov rax, "ABCD" ; 0 x 44 43 42 41  
    jmp _encerrar_programa

_rotina2:
    mov rax, "EFGH" ; 0 x 48 47 46 45
    jmp _rotina1

_encerrar_programa:
    mov rax, 60 ; SysExit
    mov rdi, 0
    syscall 