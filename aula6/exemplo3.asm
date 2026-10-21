section .text 
    global _start

_start:
    mov rcx, 1      ; Inicializando o contador (RCX) em 1

loop_dec:
    inc rcx         ; Incrementar o contador (RCX) RCX += 1
    cmp rcx, 10      ; Compara se RCX == 10 (setas as eflags)
    jne loop_dec    ; Pula se não for zero (repetição-loop)

_encerrar_programa:
    mov rax, 60 ; SysExit
    mov rdi, 0
    syscall 