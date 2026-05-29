section .text
    global contar_vogais

; int contar_vogais(char *str, int len)

contar_vogais:
    ; Argumentos 
    ; rdi (edi) = ponteiro para string 
    ; rsi (esi) = tamanho da string 
    ; Retorno da Função 
    ; rax (eax) = retornar a quantidade de vogais
    push rbx

    xor rcx, rcx      ; índice
    xor rbx, rbx      ; contador

.loop:
    cmp rcx, rsi
    jge .fim

    mov al, [rdi + rcx]

    cmp al, 'a'
    je .inc_vogal
    cmp al, 'e'
    je .inc_vogal
    cmp al, 'i'
    je .inc_vogal
    cmp al, 'o'
    je .inc_vogal
    cmp al, 'u'
    je .inc_vogal

    cmp al, 'A'
    je .inc_vogal
    cmp al, 'E'
    je .inc_vogal
    cmp al, 'I'
    je .inc_vogal
    cmp al, 'O'
    je .inc_vogal
    cmp al, 'U'
    je .inc_vogal

    jmp .proximo

.inc_vogal:
    inc rbx

.proximo:
    inc rcx
    jmp .loop

.fim:
    mov eax, ebx
    pop rbx
    ret