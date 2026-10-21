section .data
    str1 db "Ricardo", 10   ; "Ricardo" + newline(\n)
    str2 db "Andrade", 10   ; "Andrade" + newline(\n)

    section .text
        global _start
    
_start:
    ; Escrever na tela a str1 (Ricardo)
    mov rax, 1 ; syscal: sys_write
    mov rdi, 1 ; stdout
    mov rsi, str1
    mov rdx, 24
    syscall

    ; Finalizar o programa
    mov rax, 60 ; Syscall: sys_exit
    mov rdi, 0  ; código de saída: 0 sem erros
    syscall