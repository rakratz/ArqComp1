section .text 
    global _start

_start:
    mov rcx, 5      ; Inicializando o contador (RCX) em 5

loop_dec:
    dec rcx         ; Decrementar o contador (RCX) RCX -= 1
    cmp rcx, 0      ; Compara se RCX == 0 (setas as eflags)
    jne loop_dec    ; Pula se não for zero (repetição-loop)

_encerrar_programa:
    mov rax, 60 ; SysExit
    mov rdi, 0
    syscall 