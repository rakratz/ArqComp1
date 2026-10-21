section .data
    msg_pedir db "Digite um número: "
    tam_msg_pedir equ $ - msg_pedir

    msg_par db "Número par!", 10
    tam_msg_par equ $ - msg_par

    msg_impar db "Número ímpar!", 10
    tam_msg_impar equ $ - msg_impar

section .bss
    buffer resb 16      ; Buffer para entrada do usuário
    
section .text
    global _start

_start:
    ; Exibir mensagem para entrada do usuário
    mov rax, 1          ; syscall write
    mov rdi, 1          ; stdout
    mov rsi, msg_pedir
    mov rdx, tam_msg_pedir
    syscall

    ; Ler entrada do usuário
    mov rax, 0          ; syscall read
    mov rdi, 0          ; stdin
    mov rsi, buffer
    mov rdx, 16         ; Limite de bytes
    syscall

    ; Verifica se houve leitura
    test rax, rax
    jle fim

    ; Converter string para inteiro
    mov rsi, buffer
    mov r8, rax         ; Quantidade de bytes lidos
    call str_to_int     ; Retorna número em RAX

    ; Verificar se é par ou ímpar
    test rax, 1         ; Testa o último bit
    jz eh_par           ; Se ZF = 1, é par
    jmp eh_impar        ; Caso contrário, é ímpar

eh_par:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_par
    mov rdx, tam_msg_par
    syscall
    jmp fim

eh_impar:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_impar
    mov rdx, tam_msg_impar
    syscall

fim:
    mov rax, 60        ; syscall exit
    xor rdi, rdi       ; Código de saída 0
    syscall

; ----------------------------
; Função: str_to_int
; Converte string ASCII para inteiro
; ----------------------------
str_to_int:
    xor rax, rax       ; Zera o resultado
    xor rcx, rcx       ; Zera contador

.loop:
    cmp rcx, r8        ; Verifica limite de leitura
    jae .done

    movzx rdx, byte [rsi + rcx]
    cmp rdx, 10        ; Nova linha?
    je .done
    cmp rdx, 13        ; Retorno de carro?
    je .done
    cmp rdx, '0'       ; Verifica dígito mínimo
    jb .done
    cmp rdx, '9'       ; Verifica dígito máximo
    ja .done
    sub rdx, '0'       ; ASCII para número
    imul rax, rax, 10  ; Multiplica por 10
    add rax, rdx       ; Adiciona novo dígito
    inc rcx
    jmp .loop

.done:
    ret
