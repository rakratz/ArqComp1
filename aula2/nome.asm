section .data
    pergunta db "Informe seu Nome:", 10
    tam_pergunta EQU $ - pergunta 

    mensagem db "Ola, "
    tam_mensagem EQU $ - mensagem

section .bss
    nome resb 100 ; reserva de 100 Bytes

section .text
    global _start

_start:
    ; Escrever a Pergunta na Tela
    mov rax, 1 ; syscal_write
    mov rdi, 1 ; saída padrão
    mov rsi, pergunta
    mov rdx, tam_pergunta
    syscall

    ; Ler o nome (Entrada) de Dados
    mov rax, 0 ; syscal_read
    mov rdi, 0 ; entrada padrão
    mov rsi, nome
    mov rdx, 100
    syscall
    
    ; Escrever a Mensagem Ola,  (Saída)
    mov rax, 1 ; syscal_write
    mov rdi, 1 ; saída padrão
    mov rsi, mensagem
    mov rdx, tam_mensagem
    syscall

    ; Escrever a Mensagem nome  (Saída)
    mov rax, 1 ; syscal_write
    mov rdi, 1 ; saída padrão
    mov rsi, nome
    mov rdx, 100
    syscall
    
    ; Encerrar o programa
    mov rax, 60 ; sys_exit
    mov rdi, 0  ; sem erro
    syscall