; Estrutura FOR de 2 até 20, incrementando de 2 em 2

section .data
    msg db "Contador: "
    tam_msg equ $ - msg
    newline db 10

section .bss
    contador resq 1
    buffer resb 16

section .text
    global _start

_start:
    mov qword [contador], 2

for_inicio:
    mov rax, [contador]
    cmp rax, 22
    jge fim

    ; Exibir mensagem
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, tam_msg
    syscall

    ; Converter número para string
    mov rax, [contador]
    mov rdi, buffer
    call int_to_string

    ; Imprimir número convertido
    mov rdx, rax            ; Quantidade de dígitos
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    ; Imprimir nova linha
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Incrementar de 2 em 2
    add qword [contador], 2
    jmp for_inicio

fim:
    mov rax, 60
    xor rdi, rdi
    syscall

; Função: converter inteiro para string
; Entrada: RAX = número, RDI = buffer
; Saída: RAX = quantidade de dígitos

int_to_string:
    mov rbx, 10
    xor rcx, rcx

.loop:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .loop

    mov r8, rcx            ; Guarda a quantidade de dígitos

.reverse:
    pop rax
    mov [rdi], al
    inc rdi
    loop .reverse

    mov byte [rdi], 0
    mov rax, r8            ; Retorna o tamanho da string
    ret