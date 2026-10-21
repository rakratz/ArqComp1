; Lê três números, passa-os pela pilha para soma_pilha e exibe a soma
section .data
    msg1 db "Digite o primeiro numero: "
    len1 equ $ - msg1
    msg2 db "Digite o segundo numero: "
    len2 equ $ - msg2
    msg3 db "Digite o terceiro numero: "
    len3 equ $ - msg3
    msg_result db "A soma dos numeros é: "
    len_result equ $ - msg_result
    newline db 10

section .bss
    buffer resb 16      ; buffer de leitura (reutilizado nas três leituras)
    result resb 24      ; resultado convertido para string

section .text
    global _start

_start:
    ; --- Lê três números e empilha ---
    mov rsi, msg1
    mov rdx, len1
    call read_num
    push rax            ; 1º número

    mov rsi, msg2
    mov rdx, len2
    call read_num
    push rax            ; 2º número

    mov rsi, msg3
    mov rdx, len3
    call read_num
    push rax            ; 3º número

    ; --- Soma via pilha ---
    call soma_pilha     ; RAX = soma (a função já desempilhou os parâmetros)

    ; --- Converte para string ---
    mov rdi, result
    call itoa           ; RSI aponta para o fim da string
    mov r12, rsi
    sub r12, result     ; R12 = número de dígitos (syscall preserva R12)

    ; --- Exibe ---
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_result
    mov rdx, len_result
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, r12
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; --- Encerra ---
    mov rax, 60
    xor rdi, rdi
    syscall

; ----------------------------
; soma_pilha: desempilha três valores e soma
; Pilha na entrada:
;   [rsp]    = endereço de retorno (empilhado pelo call)
;   [rsp+8]  = 3º número
;   [rsp+16] = 2º número
;   [rsp+24] = 1º número
; Saída: RAX = soma
; ----------------------------
soma_pilha:
    pop r8              ; guarda o endereço de retorno
    pop rax             ; 3º número (último empilhado)
    pop rbx             ; 2º número
    pop rcx             ; 1º número

    add rax, rbx        ; RAX = 3º + 2º
    add rax, rcx        ; RAX = 3º + 2º + 1º

    push r8             ; recoloca o endereço de retorno no topo
    ret                 ; volta para _start

; ----------------------------
; read_num: exibe a mensagem e lê um número
; Entrada: RSI = mensagem, RDX = tamanho
; Saída:   RAX = número lido
; ----------------------------
read_num:
    mov rax, 1          ; write
    mov rdi, 1
    syscall

    mov rax, 0          ; read
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 16
    syscall

    call atoi
    ret

; ----------------------------
; atoi: converte o conteúdo de buffer em inteiro
; Para no primeiro caractere que não seja dígito
; ----------------------------
atoi:
    xor rax, rax
    mov rsi, buffer
.next:
    movzx rcx, byte [rsi]
    cmp rcx, '0'
    jb .done
    cmp rcx, '9'
    ja .done
    sub rcx, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .next
.done:
    ret

; ----------------------------
; itoa: converte RAX em string no endereço RDI
; Saída: RSI aponta para o byte após o último dígito
; ----------------------------
itoa:
    mov rbx, 10
    xor rcx, rcx
.loop:
    xor rdx, rdx
    div rbx
    add rdx, '0'
    push rdx            ; empilha os dígitos (saem na ordem inversa)
    inc rcx
    test rax, rax
    jnz .loop

    mov rsi, rdi
.reverse:
    pop rax
    mov [rsi], al
    inc rsi
    loop .reverse
    mov byte [rsi], 0
    ret