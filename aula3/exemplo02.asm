section .data
    msg db "Ciencia da Caomputacao", 10   ; Ponteiro para o inicio da String 
    len equ $ - msg                       ; Calcula o tamanho da String

    section .text
        global _start
    
_start:
    mov rax, 1 ; syscal: sys_write
    mov rdi, 1 ; stdout
    mov rsi, msg
    mov rdx, len
    syscall
    
    mov rax, 60 ; Syscall: sys_exit
    mov rdi, 0  ; código de saída: 0 sem erros
    syscall