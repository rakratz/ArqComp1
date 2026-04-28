section .data
    msgA db "Digite A:",10        ; Mensagem para entrada do vetor A
    tA equ $-msgA                 ; Tamanho da mensagem

    msgB db "Digite B:",10        ; Mensagem para entrada do vetor B
    tB equ $-msgB

    msg1 db 10,"Em A e B: "       ; Mensagem para interseção
    t1 equ $-msg1

    msg2 db 10,"Em A ou B: "      ; (não usado ainda)
    t2 equ $-msg2

    espaco db " "                 ; Espaço entre números
    nl db 10                      ; Quebra de linha

section .bss
    A resq 5                      ; Vetor A com 5 posições (8 bytes cada)
    B resq 5                      ; Vetor B

    intersec resq 5               ; Vetor resultado da interseção
    uniao resq 10                 ; (não usado ainda)

    buffer resb 32                ; Buffer para leitura de string
    out_buffer resb 32            ; Buffer para conversão de inteiro -> string

section .text
    global _start

_start:

; =========================
; Ler vetor A
; =========================
    mov rsi, msgA                ; Endereço da mensagem
    mov rdx, tA                  ; Tamanho da mensagem
    call print                   ; Imprime "Digite A:"

    mov rcx, 5                   ; Contador (5 elementos)
    mov rdi, A                   ; Ponteiro para o vetor A

lerA:
    cmp rcx, 0                   ; Terminou?
    je fim_lerA

    ; read altera registradores -> proteger
    push rcx
    push rdi
    call read                    ; Lê entrada do teclado
    pop rdi
    pop rcx

    mov rsi, buffer              ; buffer contém a string digitada

    ; str_to_int altera rcx -> proteger
    push rcx
    push rdi
    call str_to_int              ; Converte string para inteiro (resultado em RAX)
    pop rdi
    pop rcx

    mov [rdi], rax               ; Armazena o número no vetor
    add rdi, 8                   ; Avança para próxima posição (qword = 8 bytes)

    dec rcx                      ; Decrementa contador
    jmp lerA

fim_lerA:

; =========================
; Ler vetor B
; =========================
    mov rsi, msgB
    mov rdx, tB
    call print

    mov rcx, 5
    mov rdi, B

lerB:
    cmp rcx, 0
    je fim_lerB

    push rcx
    push rdi
    call read
    pop rdi
    pop rcx

    mov rsi, buffer

    push rcx
    push rdi
    call str_to_int
    pop rdi
    pop rcx

    mov [rdi], rax
    add rdi, 8

    dec rcx
    jmp lerB

fim_lerB:

; =========================
; Interseção A e B
; =========================
    mov rcx, 5                   ; Percorrer vetor A
    mov rdi, A
    xor r8, r8                   ; Contador de elementos da interseção

loopA:
    cmp rcx, 0
    je fim_intersec

    mov rax, [rdi]               ; Elemento atual de A

    mov rbx, B                   ; Ponteiro para vetor B
    mov rdx, 5                   ; Contador de B

buscaB:
    cmp rdx, 0                   ; Terminou B?
    je proxA

    cmp [rbx], rax               ; A[i] == B[j] ?
    je achou

    add rbx, 8                   ; Próximo elemento de B
    dec rdx
    jmp buscaB

achou:
    mov [intersec + r8*8], rax   ; Guarda na interseção
    inc r8                       ; Incrementa contador

proxA:
    add rdi, 8                   ; Próximo elemento de A
    dec rcx
    jmp loopA

fim_intersec:

; =========================
; PRINT INTERSEÇÃO
; =========================
    mov rsi, msg1
    mov rdx, t1
    call print                   ; Imprime "Em A e B:"

    mov rcx, r8                  ; Quantidade de elementos encontrados
    mov rdi, intersec            ; Ponteiro do vetor resultado

print_loop:
    cmp rcx, 0
    je fim_print

    mov rax, [rdi]               ; Carrega valor

    ; print_int destrói registradores -> proteger
    push rcx
    push rdi
    call print_int
    pop rdi
    pop rcx

    ; imprime espaço
    push rcx
    push rdi
    mov rsi, espaco
    mov rdx, 1
    call print
    pop rdi
    pop rcx

    add rdi, 8                   ; Próximo elemento
    dec rcx
    jmp print_loop

fim_print:
    mov rsi, nl
    mov rdx, 1
    call print

    ; Encerrar programa
    mov rax, 60                  ; syscall exit
    xor rdi, rdi
    syscall

; =========================
; print_int
; Converte inteiro em string e imprime
; =========================
print_int:
    mov rbx, 10                  ; base decimal
    mov rdi, out_buffer+31       ; começa do final do buffer
    mov byte [rdi], 0

conv:
    xor rdx, rdx
    div rbx                      ; divide por 10
    add dl, '0'                  ; converte para ASCII
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz conv

    mov rsi, rdi
    mov rdx, out_buffer+31
    sub rdx, rsi
    call print
    ret

; =========================
; read (entrada)
; =========================
read:
    mov rax, 0                   ; syscall read
    mov rdi, 0                   ; stdin
    mov rsi, buffer
    mov rdx, 32
    syscall
    ret

; =========================
; print (saida)
; =========================
print:
    mov rax, 1                   ; syscall write
    mov rdi, 1                   ; stdout
    syscall
    ret

; =========================
; str_to_int
; Converte string -> inteiro
; =========================
str_to_int:
    xor rax, rax                 ; resultado
    xor rcx, rcx                 ; índice

.loop:
    cmp rcx, 32                  ; limite do buffer
    je .done

    movzx rdx, byte [rsi + rcx]

    cmp rdx, 10                  ; ENTER
    je .done

    cmp rdx, 0                   ; segurança
    je .done

    sub rdx, '0'                 ; ASCII -> número
    imul rax, rax, 10            ; rax *= 10
    add rax, rdx                 ; soma dígito

    inc rcx
    jmp .loop

.done:
    ret
