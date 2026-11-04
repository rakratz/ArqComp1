section .bss
    contador resq 1 ; Reserva de memória para o contador

section .text
    global _start

_start:
    mov rcx, 10   ; Defnido o número de repições = 10
    mov rax, 0    ; Inicializando RAX com 0 (contador lógico)

loop_inicio:
    inc rax       ; Incrimentar o contador lógico
    loop loop_inicio

    ; Finalizar o programa
    mov rax, 60
    xor rdi, rdi
    syscall