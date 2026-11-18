
; ============================================================
; FUNCAO: fatorial
; ARQUITETURA: x86-64
; SINTAXE: NASM
; SISTEMA OPERACIONAL: Linux
;
; ENTRADA:
; RDI = Numero recebido do programa C
;
; SAIDA:
; RAX = Resultado do fatorial
; ============================================================

section .text
    global fatorial

fatorial:

    mov rcx, rdi        ; Copia o parâmetro recebido em RDI para RCX
    mov rax, 1           ; Inicializa o resultado com 1

calcular:

    cmp rcx, 1           ; Verifica se o contador chegou a 1
    jle fim              ; Se RCX <= 1, encerra o cálculo

    imul rax, rcx        ; Multiplica o resultado pelo contador
    dec rcx              ; Decrementa o contador
    jmp calcular         ; Retorna ao início do laço

fim:
    ret                  ; Retorna o resultado em RAX
