section .data
    msg_result db "O maior número é: ", 0  ; Mensagem para exibir o resultado
    tam_msg_result EQU $ - msg_result
    newline db 10, 0  ; Caractere de nova linha

section .bss
    buffer resb 16  ; Buffer para armazenar a string do número convertido

section .text
    global _start

_start:
    ; Inicializa os registradores com valores para comparação
    mov rax, 10    ; Número 1 (valor 10)
    mov rbx, 25    ; Número 2 (valor 25)

    ; Compara os valores em RAX e RBX
    cmp rax, rbx   ; Compara RAX e RBX

    ; Move o maior número para RAX
    cmovl rax, rbx ; Se RAX for menor que RBX, move RBX para RAX

    
    ; Converte o número em RAX para uma string e armazena no buffer
    mov rdi, buffer       ; RDI aponta para o buffer onde a string será armazenada
    call int_to_string    ; Converte RAX para string

    ; Imprime a mensagem "O maior número é: "
    mov rax, 1                  ; syscall write
    mov rdi, 1                  ; stdout
    mov rsi, msg_result         ; Mensagem a ser exibida
    mov rdx, tam_msg_result     ; Tamanho da mensagem
    syscall                     ; Chama a syscall

    ; Imprime o número convertido (armazenado no buffer)
    mov rax, 1         ; syscall write
    mov rdi, 1         ; stdout
    mov rsi, buffer    ; Buffer contendo o número convertido
    mov rdx, 16        ; Tamanho máximo do buffer
    syscall            ; Chama a syscall

    ; Imprime nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 2
    syscall

    ; Finaliza o programa
    mov rax, 60        ; syscall exit
    xor rdi, rdi       ; Código de saída 0
    syscall


; ------------------------------
; Função: int_to_string
; Converte inteiro em RAX para string em RDI
; ------------------------------
int_to_string:
    mov rbx, 10             ; Base decimal
    xor rcx, rcx            ; Contador de dígitos

.loop:
    xor rdx, rdx            ; Limpa RDX para divisão
    div rbx                 ; Divide RAX por 10
    add rdx, '0'            ; Converte resto para ASCII (similar ao string_to_int)
    push rdx                ; Empilha caractere
    inc rcx                 ; Incrementa contador
    test rax, rax           ; Verifica se terminou
    jnz .loop               ; Continua se ainda há dígitos

    ; Desempilha dígitos na ordem correta
.reverse:
    pop rax                 ; Pega um dígito da pilha
    mov [rdi], al           ; Armazena no buffer
    inc rdi                 ; Próxima posição
    loop .reverse           ; Repete até todos os dígitos

    mov byte [rdi], 0       ; Adiciona terminador nulo
    ret
