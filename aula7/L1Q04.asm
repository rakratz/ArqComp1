; Crie um programa em NASM que leia do teclado dois números 
; inteiros positivos x e y, calcule xy (sem usar nenhuma fun 
; o do C, como a pow) e mostre o resultado na tela. Construa 
; uma estrutura de repetição para efetuar o cálculo.

section .data
    msg_x    db "Digite x: "
    len_x    equ $ - msg_x
    msg_y    db "Digite y: "
    len_y    equ $ - msg_y
    msg_res  db "x^y = "
    len_res  equ $ - msg_res
    nl       db 10

    section .bss
    entrada  resb 32  ; buffer de leitura do teclado
    saida    resb 32  ; buffer para o numero convertido em texto
 
section .text
    global _start

_start:
    ; ---------- le x ----------
    mov  rsi, msg_x
    mov  rdx, len_x
    call escrever
    call ler_numero             ; rax = x
    mov  r12, rax               ; r12 = x (base)
    mov  r12, rax               ; r12 = x (base)
 
    ; ---------- le y ----------
    mov  rsi, msg_y
    mov  rdx, len_y
    call escrever
    call ler_numero             ; rax = y
    mov  r13, rax               ; r13 = y (expoente)

; y em r13
; x em r12
; ---------- calcula x^y ----------
    mov  rax, 1                 ; resultado comeca em 1 (cobre y = 0)
    mov  rcx, r13               ; contador do laco = y
laco:
    cmp  rcx, 0
    je   fim_laco               ; terminou as y multiplicacoes
    imul rax, r12               ; resultado = resultado * x
    dec  rcx
    jmp  laco
fim_laco:
    mov  r14, rax               ; guarda o resultado




    ; ---------- mostra o resultado ----------
    mov  rsi, msg_res
    mov  rdx, len_res
    call escrever
    mov  rax, r14
    call imprimir_numero
    mov  rsi, nl
    mov  rdx, 1
    call escrever
 
    ; ---------- encerra ----------
    mov  rax, 60                ; syscall exit
    xor  rdi, rdi               ; codigo de retorno 0
    syscall
; ------------------------------------------------------------
; escrever: mostra rdx bytes a partir de rsi na tela
; ------------------------------------------------------------
escrever:
    mov  rax, 1                 ; syscall write
    mov  rdi, 1                 ; stdout
    syscall
    ret

; ------------------------------------------------------------
; ler_numero: le uma linha do teclado e converte para inteiro
; retorno: rax = numero lido
; ------------------------------------------------------------
ler_numero:
    mov  rax, 0                 ; syscall read
    mov  rdi, 0                 ; stdin
    mov  rsi, entrada
    mov  rdx, 32
    syscall
 
    xor  rax, rax               ; acumulador = 0
    mov  rsi, entrada
.prox_digito:
    movzx rdx, byte [rsi]
    cmp  dl, '0'
    jb   .fim                   ; nao e digito (ex.: Enter) -> para
    cmp  dl, '9'
    ja   .fim
    sub  dl, '0'                ; caractere -> valor do digito
    imul rax, rax, 10           ; acumulador = acumulador * 10
    add  rax, rdx               ;            + digito
    inc  rsi
    jmp  .prox_digito
.fim:
    ret

; ------------------------------------------------------------
; imprimir_numero: converte rax em texto decimal e mostra
; ------------------------------------------------------------
imprimir_numero:
    mov  rdi, saida + 32        ; preenche o buffer de tras para frente
    mov  rbx, 10
.prox:
    xor  rdx, rdx
    div  rbx                    ; rax = rax / 10, rdx = resto
    add  dl, '0'                ; resto -> caractere
    dec  rdi
    mov  [rdi], dl
    test rax, rax
    jnz  .prox                  ; continua enquanto sobrar valor
 
    mov  rsi, rdi               ; inicio do texto
    mov  rdx, saida + 32
    sub  rdx, rdi               ; tamanho do texto
    call escrever
    ret