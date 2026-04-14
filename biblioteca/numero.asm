section .data
    input_str db "123", 10, 0 ; String "123\n" (com terminador de linha)
    msg_original db "Valor original: ", 0       ; Mensagem valor original
    msg_modificado db "Valor modificado: ", 0   ; Mensagem valor modificado
    newline db 10, 0                            ; Nova linha

section .bss
    result resb 16      ; Buffer para armazenar o número convertido (string)
    modificado resb 16  ; Buffer para armazenar o número convertido (string)

section .text
    global _start

_start:

     ; --- Converter string "123" para inteiro ---
    mov rsi, input_str   ; Colocar a string para converter em rsi

    ; --- Encerrar o programa ---
    mov rax, 60
    xor rdi, rdi
    syscall