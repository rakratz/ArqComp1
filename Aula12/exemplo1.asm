section .data
    msg_igual db "Os numeros sao iguais!", 10
    tam_msg_igual EQU $ - msg_igual

    msg_diferente db "Os numeros sao diferentes!", 10
    tam_msg_diferente EQU $ - msg_diferente

section .bss
    resultado resb 1 ; Reserva 1 byte para armazenar o resultado do SETE

section .text
    global _start

_start:

    ; Inicializar os registradores para comparação
    mov rax, 5      ; Número 1
    mov rbx, 5      ; Número 2

    ; CMP faz (RAX - RBX) internamente
    ; Apenas altera FLAGS, não altera os registradores
    cmp rax, rbx

    ; SETE = Set if Equal
    ; Se ZF = 1, grava 1 em [resultado]
    ; Se ZF = 0, grava 0
    sete byte [resultado]

    ; MOVZX = Move with Zero Extend
    ; Move 8 bits para 64 bits preenchendo com zeros
    movzx rdi, byte [resultado]

    ; TEST faz AND lógico entre os operandos
    ; Apenas altera FLAGS
    test rdi, rdi

    ; JNZ = Jump if Not Zero
    ; Se RDI != 0, então os números são iguais
    jnz print_igual

    ; Caso contrário
    jmp print_diferente

print_igual:
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; stdout
    mov rsi, msg_igual          ; mensagem
    mov rdx, tam_msg_igual      ; tamanho da mensagem
    syscall
    jmp fim

print_diferente:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_diferente
    mov rdx, tam_msg_diferente
    syscall

fim:
    ; Encerrar programa
    mov rax, 60     ; syscall exit
    xor rdi, rdi    ; código de saída 0
    syscall