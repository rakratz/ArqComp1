section .text
    global contar_vogais

; int contar_vogais(char *str, int len)
contar_vogais:
    ; Argumentos:
    ; rdi = ponteiro para string
    ; rsi = tamanho da string
    ; retorno: eax = quantidade de vogais

    xor rax, rax      ; caracter = 0
    xor rcx, rcx      ; índice = 0
    xor rbx, rbx      ; vogais = 0

.loop:
    cmp rcx, rsi
    jge .fim

    mov al, [rdi + rcx]

    cmp al, 'a'
    je .inc
    cmp al, 'e'
    je .inc
    cmp al, 'i'
    je .inc
    cmp al, 'o'
    je .inc
    cmp al, 'u'
    je .inc
    jmp .proximo

.inc:
    inc rbx           ; contador

.proximo:
    inc rcx
    jmp .loop


.fim:
    mov eax, ebx      ; return eax = contador
    ret
