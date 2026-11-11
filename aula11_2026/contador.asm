
section .data
    prompt db "Digite uma String: "
    prompt_len equ $ - prompt

    title db 10, "Quantidade de vogais", 10
    title_len equ $ - title

    text_a db "A: "
    text_e db "E: "
    text_i db "I: "
    text_o db "O: "
    text_u db "U: "

    quebra db 10

section .bss
    text resb 201
    numero resb 12

    ; Contadores de 32 bits
    cont_a resd 1
    cont_e resd 1
    cont_i resd 1
    cont_o resd 1
    cont_u resd 1

section .text
    global _start

; =========================================
; FUNCAO PRINCIPAL
; =========================================
_start:
main:
    ; Exibir mensagem
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, prompt
    mov rdx, prompt_len
    syscall

    ; Ler string
    mov rax, 0          ; sys_read
    mov rdi, 0          ; stdin
    mov rsi, text
    mov rdx, 200
    syscall

    ; Verificar se leu caracteres
    cmp rax, 0
    jle .sair

    ; Adicionar terminador da string
    mov byte [text + rax], 0

    ; Chamar contar_vogais
    push text
    call contar_vogais
    add rsp, 8

    ; Exibir titulo
    mov rax, 1
    mov rdi, 1
    mov rsi, title
    mov rdx, title_len
    syscall

    ; Exibir contagem de A
    mov rsi, text_a
    mov eax, [cont_a]
    call imprimir_resultado

    ; Exibir contagem de E
    mov rsi, text_e
    mov eax, [cont_e]
    call imprimir_resultado

    ; Exibir contagem de I
    mov rsi, text_i
    mov eax, [cont_i]
    call imprimir_resultado

    ; Exibir contagem de O
    mov rsi, text_o
    mov eax, [cont_o]
    call imprimir_resultado

    ; Exibir contagem de U
    mov rsi, text_u
    mov eax, [cont_u]
    call imprimir_resultado

.sair:
    ; Finalizar programa
    mov rax, 60
    xor rdi, rdi
    syscall


; =========================================
; FUNCAO: imprimir_resultado
; Entrada:
; RSI = endereco da mensagem
; EAX = quantidade de vogais
; =========================================
imprimir_resultado:
    push r12

    ; Guardar quantidade de vogais
    mov r12d, eax

    ; Exibir "A: ", "E: ", etc.
    mov rax, 1
    mov rdi, 1
    mov rdx, 3
    syscall

    ; Passar numero pela pilha
    mov eax, r12d
    push rax
    call imprime_numero
    add rsp, 8

    ; Exibir quebra de linha
    mov rax, 1
    mov rdi, 1
    mov rsi, quebra
    mov rdx, 1
    syscall

    pop r12
    ret


; =========================================
; FUNCAO: imprime_numero
; Parametro: numero inteiro na pilha
; Converte numero para ASCII
; =========================================
imprime_numero:
    push rbp
    mov rbp, rsp
    push rbx

    ; Recuperar numero
    mov eax, [rbp + 16]

    ; Apontar para final do buffer
    lea rsi, [numero + 11]

    ; Divisor decimal
    mov ebx, 10

.converter:
    ; Limpar parte alta da divisao
    xor edx, edx

    ; EAX / 10
    ; Quociente em EAX
    ; Resto em EDX
    div ebx

    ; Converter resto para ASCII
    add dl, '0'

    ; Armazenar digito
    dec rsi
    mov [rsi], dl

    ; Continuar se quociente != 0
    test eax, eax
    jnz .converter

    ; Calcular quantidade de digitos
    lea rdx, [numero + 11]
    sub rdx, rsi

    ; Exibir numero
    mov rax, 1
    mov rdi, 1
    syscall

    pop rbx
    pop rbp
    ret


; =========================================
; FUNCAO: minusculo
; Parametro: caractere na pilha
; Retorno: caractere em AL (8 bits)
; =========================================
minusculo:
    push rbp
    mov rbp, rsp

    ; Recuperar caractere da pilha
    mov rax, [rbp + 16]

    ; Verificar se esta entre A e Z
    cmp al, 'A'
    jb .fim

    cmp al, 'Z'
    ja .fim

    ; Converter maiusculo em minusculo
    add al, 32

.fim:
    pop rbp
    ret


; =========================================
; FUNCAO: contar_vogais
; Parametro: endereco do texto na pilha
; =========================================
contar_vogais:
    push rbp
    mov rbp, rsp

    ; Salvar registradores
    push rbx
    push r12

    ; Recuperar endereco do texto
    mov r12, [rbp + 16]

.loop:
    ; Ler caractere de 8 bits
    ; Expandir para 32 bits com zeros
    movzx ebx, byte [r12]

    ; Verificar fim da string
    cmp bl, 0
    je .fim

    ; Chamar minusculo(caractere)
    push rbx
    call minusculo
    add rsp, 8

    ; Comparar vogais
    cmp al, 'a'
    je .vogal_a

    cmp al, 'e'
    je .vogal_e

    cmp al, 'i'
    je .vogal_i

    cmp al, 'o'
    je .vogal_o

    cmp al, 'u'
    je .vogal_u

    jmp .proximo

.vogal_a:
    inc dword [cont_a]
    jmp .proximo

.vogal_e:
    inc dword [cont_e]
    jmp .proximo

.vogal_i:
    inc dword [cont_i]
    jmp .proximo

.vogal_o:
    inc dword [cont_o]
    jmp .proximo

.vogal_u:
    inc dword [cont_u]

.proximo:
    ; Avancar para proximo caractere
    inc r12
    jmp .loop

.fim:
    ; Restaurar registradores
    pop r12
    pop rbx
    pop rbp
    ret