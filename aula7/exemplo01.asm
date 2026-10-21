; Leia dois valores distintos e informe qual é o maior

global main
extern printf
extern scanf

section .data
    fmtin      db "%d", 0
    msgInputX  db "Digite o primeiro numero: ", 0
    msgInputY  db "Digite o segundo numero: ", 0
    msgMaior   db "Maior: %d", 10, 0
    msgMenor   db "Menor: %d", 10, 0

section .bss
    x  resd 1
    y  resd 1

section .text

main:
    ; Prepara a pilha
    push rbp
    mov rbp, rsp

    ; --------------------------------
    ; Solicita X
    ; --------------------------------
    xor eax, eax
    mov rdi, msgInputX
    call printf

    ; Leitura de X
    xor eax, eax
    mov rdi, fmtin
    mov rsi, x
    call scanf

    ; --------------------------------
    ; Solicita Y
    ; --------------------------------
    xor eax, eax
    mov rdi, msgInputY
    call printf

    ; Leitura de Y
    xor eax, eax
    mov rdi, fmtin
    mov rsi, y
    call scanf

    ; --------------------------------
    ; Comparação
    ; --------------------------------
    mov r8d, [x]
    mov r9d, [y]

    cmp r8d, r9d
    jg x_maior


y_maior:
    ; Y é maior
    mov rdi, msgMaior
    mov esi, r9d
    xor eax, eax
    call printf

    ; IMPORTANTE:
    ; printf pode alterar r8 e r9.
    ; Portanto, buscamos X novamente da memória.

    mov rdi, msgMenor
    mov esi, [x]
    xor eax, eax
    call printf

    jmp fim


x_maior:
    ; X é maior
    mov rdi, msgMaior
    mov esi, r8d
    xor eax, eax
    call printf

    ; printf pode alterar r8/r9.
    ; Busca Y novamente da memória.

    mov rdi, msgMenor
    mov esi, [y]
    xor eax, eax
    call printf


fim:
    xor eax, eax

    mov rsp, rbp
    pop rbp
    ret


; Informa ao linker que não precisamos de pilha executável
section .note.GNU-stack noalloc noexec nowrite progbits