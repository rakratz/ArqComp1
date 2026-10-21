
section .data
    msg_igual db "Os números são iguais!",10,0 ; Mensagem para números iguais
    tam_msg_igual EQU $ - msg_igual
    msg_diferente db "Os números são diferentes!",10,0 ; Mensagem para números diferentes
    tam_msg_diferente EQU $ - msg_diferente

section .bss
    resultado resb 1 ; Reserva 1 byte para armazenar o resultado da instrução SET

section .text
    global _start


_start:
    ; Inicializa os registradores com valores para comparação
    mov rax, 7     ; Número 1 (valor 7)
    mov rbx, 7     ; Número 2 (valor 7)

    ; Compara os valores em RAX e RBX
    cmp rax, rbx   ; Compara RAX e RBX (subtrai RBX de RAX e define as flags)

    ; Define o byte em [resultado] como 1 se RAX == RBX (flag ZF = 1), caso contrário 0
    sete byte [resultado] ; SETE: Define o destino como 1 se a comparação for igual (ZF = 1)

     ; Carrega o valor de [resultado] em RDI (estendendo com zeros para 64 bits)
    movzx rdi, byte [resultado]  ; MOVZX: Move com extensão de zeros (8 bits -> 64 bits)

    ; Testa o valor em RDI (verifica se é 0 ou 1)
    test rdi, rdi   ; TEST: Faz um AND lógico entre RDI e RDI (define as flags)
    jnz print_igual ; Se RDI != 0 (números iguais), pula para print_igual
    jmp print_diferente ; Caso contrário, pula para print_diferente

    
print_igual:
    ; Exibe a mensagem "Os números são iguais!"
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; stdout
    mov rsi, msg_igual          ; Mensagem para números iguais
    mov rdx, tam_msg_igual      ; Tamanho da mensagem (incluindo o caractere de nova linha e o terminador nulo)
    syscall                     ; Chama a syscall
    jmp fim                     ; Pula para o fim do programa

print_diferente:
    ; Exibe a mensagem "Os números são diferentes!"
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; stdout
    mov rsi, msg_diferente      ; Mensagem para números diferentes
    mov rdx, tam_msg_diferente  ; Tamanho da mensagem (incluindo o caractere de nova linha e o terminador nulo)
    syscall                     ; Chama a syscall

fim:
    ; Encerra o programa
    mov rax, 60                 ; syscall exit
    xor rdi, rdi                ; Código de saída 0
    syscall                     ; Chama a syscall
