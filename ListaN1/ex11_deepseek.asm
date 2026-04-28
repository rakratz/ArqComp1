; ======================================================================
; Programa: Conjuntos a partir de dois vetores (NASM - Linux 64 bits)
; Descrição: Lê 5 valores para A e 5 para B e exibe:
;            1) Elementos somente em A
;            2) Elementos somente em B
;            3) Elementos em A e B (interseção)
;            4) Elementos em A ou B (união)
;            Sem repetições em cada conjunto.
; Compilação: nasm -f elf64 programa.asm -o programa.o
; Linkagem:   ld programa.o -o programa
; Uso:        ./programa
; ======================================================================

section .data
    msgA        db  "Digite A:", 10
    tA          equ $ - msgA

    msgB        db  "Digite B:", 10
    tB          equ $ - msgB

    msg1        db  "1 Somente em A: "
    t1          equ $ - msg1

    msg2        db  "2 Somente em B: "
    t2          equ $ - msg2

    msg3        db  "3 Em A e B : "
    t3          equ $ - msg3

    msg4        db  "4 Em A ou B : "
    t4          equ $ - msg4

    espaco      db  " "
    nl          db  10

section .bss
    ; Vetores principais (5 elementos de 64 bits cada)
    A           resq    5
    B           resq    5

    ; Conjuntos resultado
    onlyA       resq    5       ; máximo 5 elementos
    onlyB       resq    5
    intersect   resq    5
    union       resq    10      ; máximo 10 (5+5)

    ; Contadores de elementos em cada conjunto
    countA      resq    1       ; usado para onlyA
    countB      resq    1       ; usado para onlyB
    countI      resq    1       ; usado para intersect
    countU      resq    1       ; usado para union

    ; Buffers auxiliares
    buffer      resb    32
    out_buffer  resb    32

section .text
    global _start

; =========================
; Sub-rotina: le_vetor
; Entrada: RDI = endereço do vetor, RSI = mensagem, RDX = tamanho da mensagem
; Saída: vetor preenchido com 5 inteiros
; =========================
le_vetor:
    push    rbp
    mov     rbp, rsp
    push    rdi                ; salva endereço do vetor
    push    rsi                ; salva mensagem
    push    rdx

    ; imprime mensagem
    mov     rax, 1             ; sys_write
    mov     rdi, 1             ; stdout
    syscall

    pop     rdx
    pop     rsi
    pop     rdi

    mov     rcx, 5             ; contador
.loop:
    cmp     rcx, 0
    je      .fim

    push    rcx
    push    rdi

    ; lê uma linha
    mov     rax, 0             ; sys_read
    mov     rdi, 0             ; stdin
    mov     rsi, buffer
    mov     rdx, 32
    syscall

    pop     rdi
    pop     rcx

    ; converte string para inteiro (resultado em RAX)
    mov     rsi, buffer
    call    str_to_int

    ; armazena no vetor
    mov     [rdi], rax
    add     rdi, 8
    dec     rcx
    jmp     .loop
.fim:
    leave
    ret

; =========================
; Sub-rotina: pertence
; Verifica se o valor em RAX está presente no vetor apontado por RSI,
; que contém RDX elementos.
; Saída: ZF = 1 se não pertence, ZF = 0 se pertence (ou seja, RETorna com
;        zero flag indicando ausência, mas usaremos RAX = 1/0)
; =========================
pertence:
    push    rcx
    push    rsi
    push    rdx

    xor     rcx, rcx
.loop:
    cmp     rcx, rdx
    jge     .nao_encontrado
    cmp     [rsi + rcx*8], rax
    je      .encontrado
    inc     rcx
    jmp     .loop
.encontrado:
    pop     rdx
    pop     rsi
    pop     rcx
    mov     rax, 1
    ret
.nao_encontrado:
    pop     rdx
    pop     rsi
    pop     rcx
    xor     rax, rax
    ret

; =========================
; Sub-rotina: adiciona_se_unico
; Se o valor em RAX não estiver no vetor (RDI) que possui (RSI) elementos,
; adiciona-o e incrementa o contador apontado por RDX.
; =========================
adiciona_se_unico:
    push    rbx
    push    rcx
    push    rdx
    push    rsi
    push    rdi

    ; salva argumentos
    mov     rbx, rax           ; valor a adicionar
    mov     rcx, rdi           ; endereço do vetor
    mov     rdx, rsi           ; número atual de elementos
    mov     r8,  rdx           ; guarda contador para incremento

    ; verifica duplicata
    mov     rax, rbx
    mov     rsi, rcx
    call    pertence
    cmp     rax, 1
    je      .fim               ; já existe, não adiciona

    ; adiciona no final do vetor
    mov     [rcx + r8*8], rbx
    inc     qword [r8]         ; incrementa o contador (passado por referência em RDX)

.fim:
    pop     rdi
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx
    ret

; =========================
; Sub-rotina: imprime_conjunto
; Entrada: RSI = mensagem, RDX = tamanho, RDI = endereço do vetor, RCX = número de elementos
; =========================
imprime_conjunto:
    push    rbp
    mov     rbp, rsp
    push    rsi
    push    rdx
    push    rdi
    push    rcx

    ; imprime mensagem
    mov     rax, 1
    mov     rdi, 1
    syscall

    pop     rcx
    pop     rdi

    ; imprime os elementos
    xor     rbx, rbx
.loop:
    cmp     rbx, rcx
    jge     .fim_loop
    mov     rax, [rdi + rbx*8]
    push    rcx
    push    rdi
    push    rbx
    call    print_int          ; imprime número
    ; imprime espaço (ou não se for último)
    pop     rbx
    pop     rdi
    pop     rcx
    inc     rbx
    cmp     rbx, rcx
    je      .pula_espaco
    push    rcx
    push    rdi
    push    rbx
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, espaco
    mov     rdx, 1
    syscall
    pop     rbx
    pop     rdi
    pop     rcx
.pula_espaco:
    jmp     .loop
.fim_loop:
    ; imprime quebra de linha
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, nl
    mov     rdx, 1
    syscall

    leave
    ret

; =========================
; print_int: imprime inteiro em RAX (sem sinal)
; =========================
print_int:
    mov     rbx, 10
    mov     rdi, out_buffer + 31
    mov     byte [rdi], 0

.converte:
    xor     rdx, rdx
    div     rbx
    add     dl, '0'
    dec     rdi
    mov     [rdi], dl
    test    rax, rax
    jnz     .converte

    mov     rsi, rdi
    mov     rdx, out_buffer + 31
    sub     rdx, rsi
    mov     rax, 1
    mov     rdi, 1
    syscall
    ret

; =========================
; str_to_int: converte string (buffer) em inteiro (RAX)
; =========================
str_to_int:
    xor     rax, rax
    xor     rcx, rcx
.loop:
    cmp     rcx, 32
    je      .fim
    movzx   rdx, byte [rsi + rcx]
    cmp     rdx, 10            ; ENTER
    je      .fim
    cmp     rdx, 0
    je      .fim
    sub     rdx, '0'
    imul    rax, rax, 10
    add     rax, rdx
    inc     rcx
    jmp     .loop
.fim:
    ret

; =========================
; Programa principal
; =========================
_start:
    ; ----- Leitura do vetor A -----------------------------------------
    mov     rdi, A
    mov     rsi, msgA
    mov     rdx, tA
    call    le_vetor

    ; ----- Leitura do vetor B -----------------------------------------
    mov     rdi, B
    mov     rsi, msgB
    mov     rdx, tB
    call    le_vetor

    ; ----- Inicializa contadores --------------------------------------
    mov     qword [countA], 0
    mov     qword [countB], 0
    mov     qword [countI], 0
    mov     qword [countU], 0

    ; ----- Montar "somente em A" (elementos de A que não estão em B) --
    xor     rcx, rcx
.loop_onlyA:
    cmp     rcx, 5
    jge     .fim_onlyA
    mov     rax, [A + rcx*8]

    ; verifica se rax está em B
    mov     rsi, B
    mov     rdx, 5
    call    pertence
    test    rax, rax
    jnz     .prox_onlyA        ; se está em B, pula

    ; tenta adicionar em onlyA (sem repetir)
    mov     rax, [A + rcx*8]
    mov     rdi, onlyA
    mov     rsi, [countA]
    lea     rdx, [countA]      ; contador passado por referência
    call    adiciona_se_unico

.prox_onlyA:
    inc     rcx
    jmp     .loop_onlyA
.fim_onlyA:

    ; ----- Montar "somente em B" (elementos de B que não estão em A) --
    xor     rcx, rcx
.loop_onlyB:
    cmp     rcx, 5
    jge     .fim_onlyB
    mov     rax, [B + rcx*8]

    ; verifica se rax está em A
    mov     rsi, A
    mov     rdx, 5
    call    pertence
    test    rax, rax
    jnz     .prox_onlyB

    ; tenta adicionar em onlyB
    mov     rax, [B + rcx*8]
    mov     rdi, onlyB
    mov     rsi, [countB]
    lea     rdx, [countB]
    call    adiciona_se_unico

.prox_onlyB:
    inc     rcx
    jmp     .loop_onlyB
.fim_onlyB:

    ; ----- Montar interseção (A e B) ---------------------------------
    xor     rcx, rcx
.loop_intersect:
    cmp     rcx, 5
    jge     .fim_intersect
    mov     rax, [A + rcx*8]

    ; verifica se está em B
    mov     rsi, B
    mov     rdx, 5
    call    pertence
    test    rax, rax
    jz      .prox_intersect

    ; adiciona em intersect (sem repetir)
    mov     rax, [A + rcx*8]
    mov     rdi, intersect
    mov     rsi, [countI]
    lea     rdx, [countI]
    call    adiciona_se_unico

.prox_intersect:
    inc     rcx
    jmp     .loop_intersect
.fim_intersect:

    ; ----- Montar união (A ou B) -------------------------------------
    ; primeiro adiciona todos os elementos de A
    xor     rcx, rcx
.loop_unionA:
    cmp     rcx, 5
    jge     .fim_unionA
    mov     rax, [A + rcx*8]
    mov     rdi, union
    mov     rsi, [countU]
    lea     rdx, [countU]
    call    adiciona_se_unico
    inc     rcx
    jmp     .loop_unionA
.fim_unionA:
    ; depois adiciona os de B (já tratando duplicatas)
    xor     rcx, rcx
.loop_unionB:
    cmp     rcx, 5
    jge     .fim_unionB
    mov     rax, [B + rcx*8]
    mov     rdi, union
    mov     rsi, [countU]
    lea     rdx, [countU]
    call    adiciona_se_unico
    inc     rcx
    jmp     .loop_unionB
.fim_unionB:

    ; ----- Exibição dos resultados ------------------------------------
    ; 1) Somente em A
    mov     rsi, msg1
    mov     rdx, t1
    mov     rdi, onlyA
    mov     rcx, [countA]
    call    imprime_conjunto

    ; 2) Somente em B
    mov     rsi, msg2
    mov     rdx, t2
    mov     rdi, onlyB
    mov     rcx, [countB]
    call    imprime_conjunto

    ; 3) Interseção (A e B)
    mov     rsi, msg3
    mov     rdx, t3
    mov     rdi, intersect
    mov     rcx, [countI]
    call    imprime_conjunto

    ; 4) União (A ou B)
    mov     rsi, msg4
    mov     rdx, t4
    mov     rdi, union
    mov     rcx, [countU]
    call    imprime_conjunto

    ; ----- Finalização ------------------------------------------------
    mov     rax, 60            ; sys_exit
    xor     rdi, rdi
    syscall
