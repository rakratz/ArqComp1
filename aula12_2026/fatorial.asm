; Calcular o Fatorial de um número
section .data
    msg db "Digite um numero (0 a 9): ", 0
    tam_msg EQU $ - msg

    resultado_msg db "Fatorial = ", 0
    tam_resultado_msg EQU $ - resultado_msg

section .bss
    entrada resb 2
    saida resb 10

section .text
    global _start

_start:
    ; Exibir a Mensagem
    mov rax, 1 ; SysWrite
    mov rdi, 1 ; Stdout
    mov rsi, msg
    mov rdx, tam_msg
    syscall

    ; Ler o Número
    mov rax, 0 ; SysRead
    mov rdi, 0 ; Stdin
    mov rsi, entrada
    mov rdx, 2
    syscall

    ; Conversão simples de ASCII para INT (de 1 dígito)
    movzx rcx, byte [entrada]
    sub rcx, '0'

    ; Calcular o Fatorial
    ; RAX vai armazenar o resultado do Fatorial
    ; RCX vai ser no numéro informado pelo usuário
    mov rax, 1      

fatorial:
    cmp rcx, 1   
    jle mostrar

    imul rax, rcx
    dec rcx
    jmp fatorial





mostrar:
    ; Converter de inteiro para ASCII e exibir o resultado
    call int_to_str ; int_to_str


    ; Encerrar
    mov rax, 60 ; SysExit
    mov rdi, 0 ; StdExit (0 = sem erro)
    syscall


; Funcao int_to_str
; Entrada: RAX = numero inteiro
; Saida:   RSI = endereco do texto
;          RDX = tamanho do texto
int_to_str: 
   mov rbx, 10
   lea rsi, [saida + 20]    ; 20 Bytes

.conveter:
    xor rdx, rdx ; Zerar o rdx
    div rbx

    add dl, '0'
    dec rsi
    mov [rsi], dl

    cmp rax, 0
    jne .converter

    lea rdx, [saida + 20]
    sub rdx, rsi
    
    ret
