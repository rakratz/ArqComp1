; Simular a Estrutura While contando de 5 até 1 na tela escrevendo New Hello 
section .data
    msg db "New Hello", 10, 0 ;Mensagem "Hello" com nova linha
    tam_msg equ $ - msg
section .bss
    contador resq 1 ; Reserva de memória para o contador
section .text
    global _start
_start:
    mov qword [contador], 5 ; Inicializa o contador na memória
while_inicio:
    mov rax, [contador]     ; Carrega o contador
    cmp rax, 0              ; Verificar se cehgou a zero
    je fim
     ; Escrever a mensagem "Hello"
    mov rax, 1 ; syscall write
    mov rdi, 1 ; stdout
    mov rsi, msg ; Mensagem
    mov rdx, tam_msg ; Tamanho da mensagem
    syscall
    ; Decrementar contador
    dec qword [contador]
    jmp while_inicio
fim:
    ; Finalizar o programa
    mov rax, 60
    xor rdi, rdi
    syscall