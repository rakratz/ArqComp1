section .data
    ; Mensagem inicial
    msg db "Digite uma string: "
    len_msg equ $ - msg

    ; Labels de saída
    out_vogais db "Vogais: "
    len_vogais equ $ - out_vogais

    out_cons db "Consoantes: "
    len_cons equ $ - out_cons

    out_num db "Algarismos: "
    len_num equ $ - out_num

    out_outros db "Outros: "
    len_outros equ $ - out_outros

    newline db 10   ; \n

section .bss
    buffer resb 101     ; buffer para leitura da string
    num_str resb 10     ; buffer para conversão de número

section .text
    global _start

_start:

; ==================================================
; PRINT mensagem inicial
; ==================================================
    mov rax, 1      ; syscall write
    mov rdi, 1      ; stdout
    mov rsi, msg
    mov rdx, len_msg
    syscall

; ==================================================
; READ string do teclado
; ==================================================
    mov rax, 0      ; syscall read
    mov rdi, 0      ; stdin
    mov rsi, buffer
    mov rdx, 100
    syscall

    mov rcx, rax    ; quantidade de caracteres lidos
    mov rsi, buffer ; ponteiro para string

; ==================================================
; ZERAR CONTADORES
; ==================================================
    xor r8, r8      ; vogais
    xor r9, r9      ; consoantes
    xor r10, r10    ; números
    xor r12, r12    ; outros (⚠️ NÃO usar R11)

; ==================================================
; LOOP PRINCIPAL
; ==================================================
process_loop:
    cmp rcx, 0
    jle fim_loop

    xor rax, rax
    mov al, [rsi]   ; pega caractere atual

    ; Ignorar ENTER (\n) e CR (\r)
    cmp al, 10
    je proximo
    cmp al, 13
    je proximo

; --------------------------------------------------
; VERIFICAR SE É NÚMERO (0–9)
; --------------------------------------------------
    cmp al, '0'
    jl verifica_letra
    cmp al, '9'
    jg verifica_letra
    inc r10
    jmp proximo

; --------------------------------------------------
; VERIFICAR SE É LETRA
; --------------------------------------------------
verifica_letra:
    cmp al, 'A'
    jl eh_outro
    cmp al, 'Z'
    jle trata_letra
    cmp al, 'a'
    jl eh_outro
    cmp al, 'z'
    jg eh_outro

; --------------------------------------------------
; TRATAR LETRA (vogal ou consoante)
; --------------------------------------------------
trata_letra:
    or al, 0x20     ; converte para minúscula

    cmp al, 'a'
    je vogal
    cmp al, 'e'
    je vogal
    cmp al, 'i'
    je vogal
    cmp al, 'o'
    je vogal
    cmp al, 'u'
    je vogal

    inc r9          ; consoante
    jmp proximo

vogal:
    inc r8
    jmp proximo

; --------------------------------------------------
; OUTROS CARACTERES
; --------------------------------------------------
eh_outro:
    inc r12

; --------------------------------------------------
; AVANÇA NO LOOP
; --------------------------------------------------
proximo:
    inc rsi
    dec rcx
    jmp process_loop

; ==================================================
; FIM DO PROCESSAMENTO
; ==================================================
fim_loop:

    ; Vogais
    mov rdi, r8
    mov rsi, out_vogais
    mov rdx, len_vogais
    call print_result

    ; Consoantes
    mov rdi, r9
    mov rsi, out_cons
    mov rdx, len_cons
    call print_result

    ; Números
    mov rdi, r10
    mov rsi, out_num
    mov rdx, len_num
    call print_result

    ; Outros
    mov rdi, r12
    mov rsi, out_outros
    mov rdx, len_outros
    call print_result

; ==================================================
; EXIT
; ==================================================
    mov rax, 60
    xor rdi, rdi
    syscall

; ==================================================
; FUNÇÃO: print_result
; RDI = valor numérico
; RSI = texto
; RDX = tamanho do texto
; ==================================================
print_result:
    push rdi

    ; Imprime o texto (ex: "Vogais: ")
    mov rax, 1
    mov rdi, 1
    syscall

    pop rax         ; recupera número
    mov rdi, num_str
    call int_to_string

    ; Imprime o número convertido
    mov rax, 1
    mov rdi, 1
    mov rsi, num_str
    mov rdx, rax    ; tamanho retornado
    syscall

    ; newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ret

; ==================================================
; FUNÇÃO: int_to_string
; Entrada: RAX (número), RDI (buffer)
; Saída: RAX (tamanho da string)
; ==================================================
int_to_string:
    push rcx
    push rbx

    mov rbx, 10
    xor rcx, rcx

.conv_loop:
    xor rdx, rdx
    div rbx

    add dl, '0'
    push rdx
    inc rcx

    test rax, rax
    jnz .conv_loop

    mov rax, rcx    ; tamanho

.store_loop:
    pop rdx
    mov [rdi], dl
    inc rdi
    loop .store_loop

    pop rbx
    pop rcx
    ret