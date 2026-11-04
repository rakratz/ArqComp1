; Simular a Estrtura de Repetição For de 1 até 5
; for (int i = 1; i <= 10; i++) {
;     // Corpo do laço
; }
section .bss
    contador resq 1 ; Reserva de memória para o contador
section .text
    global _start
_start:
    mov qword [contador], 1 ; Inicializando o contador com 1 (i = 1)
for_inicio:    
    mov rax, [contador]     ; Carrega o contador
    cmp rax, 11             ; Verificar se chegou a onze
    jge fim                 ; Se contador >= 11, sai do loop (i <= 10)

    inc qword [contador]    ; i++
    jmp for_inicio

fim:
    ; Finalizar o programa
    mov rax, 60
    xor rdi, rdi
    syscall