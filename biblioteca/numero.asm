section .data
    input_str db "123", 10 ; String "123\n" (com terminador de linha)
    msg_original db "Valor original: "      ; Mensagem valor original
    msg_modificado db "Valor modificado: "  ; Mensagem valor modificado
    newline db 10, 0                        ; Nova linha

section .bss
    result resb 16      ; Buffer para armazenar o número convertido (string)
    modificado resb 16  ; Buffer para armazenar o número convertido (string)

section .text
    global _start

_start:

     ; --- Converter string "123" para inteiro ---
    mov rsi, input_str   ; Colocar a string para converter em rsi
    call str_to_int

    ; --- Encerrar o programa ---
    mov rax, 60
    xor rdi, rdi
    syscall

;-----------------------------
; Função: str_to_int
; Converte de String para Int
; Inicio da String em RSI
; Retorna o valor em RAX
;-----------------------------
str_to_int:
    xor rax, rax        ; Zera o rax para armazenar o número
    xor rcx, rcx        ; Zera o rcx (contador)
.loop
    movzx rdx, byte [rsi + rcx]   ; Pega um caractere da string e salva em rdx
    cmp rdx, 10                   ; Se for '\n' (10), termina a conversão
    je .done                      ; Se for igual pula para .done
    sub rdx, '0'                  ; Converte ASCII para número (0-9)
    imul rax, rax, 10             ; Multiplica o acumulado por 10
    add rax, rdx                  ; Adiciona um novo dígito ao resultado final
    inc rcx                       ; Incrementa o contador, avança para próximo caractere
    jmp .loop                     ; Vai (goto) para o loop
.done
    ret
