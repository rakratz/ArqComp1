
; ============================================================
; PROGRAMA: Calcular o Fatorial de um Número
; ARQUITETURA: x86-64
; SINTAXE: NASM
; SISTEMA OPERACIONAL: Linux
;
; O programa solicita um número de 0 a 9, calcula seu
; fatorial e apresenta o resultado na tela.
; ============================================================

section .data

    ; Mensagem apresentada ao usuário
    msg db "Digite um numero (0 a 9): "
    tam_msg EQU $ - msg

    ; Texto apresentado antes do resultado
    resultado_msg db "Fatorial = "
    tam_resultado_msg EQU $ - resultado_msg


section .bss

    ; Reserva 2 bytes para armazenar a entrada do teclado
    ; Um byte para o número e outro para o ENTER
    entrada resb 2

    ; Reserva 20 bytes para armazenar o resultado convertido
    saida resb 20


section .text

    global _start

_start:

    ; --------------------------------------------------------
    ; 1. EXIBIR A MENSAGEM NA TELA
    ; --------------------------------------------------------

    mov rax, 1              ; Código 1: syscall write
    mov rdi, 1              ; Descritor 1: saída padrão (stdout)
    mov rsi, msg            ; Endereço da mensagem
    mov rdx, tam_msg        ; Quantidade de bytes a escrever
    syscall                 ; Executa a chamada de sistema


    ; --------------------------------------------------------
    ; 2. LER O NÚMERO DIGITADO PELO USUÁRIO
    ; --------------------------------------------------------

    mov rax, 0              ; Código 0: syscall read
    mov rdi, 0              ; Descritor 0: entrada padrão (stdin)
    mov rsi, entrada        ; Endereço onde será armazenada a entrada
    mov rdx, 2              ; Lê até 2 bytes (número + ENTER)
    syscall                 ; Executa a chamada de sistema


    ; --------------------------------------------------------
    ; 3. CONVERTER ASCII PARA INTEIRO
    ; --------------------------------------------------------

    movzx rcx, byte [entrada] ; Lê o caractere digitado para RCX
    sub rcx, '0'              ; Converte ASCII para valor numérico


    ; --------------------------------------------------------
    ; 4. CALCULAR O FATORIAL
    ; --------------------------------------------------------

    ; RAX armazenará o resultado do fatorial.
    ; RCX armazenará o número que será multiplicado.

    mov rax, 1              ; Inicializa o resultado com 1

fatorial:

    cmp rcx, 1              ; Verifica se o contador chegou a 1
    jle mostrar             ; Se RCX <= 1, encerra o cálculo

    imul rax, rcx           ; RAX = RAX * RCX
    dec rcx                 ; Decrementa o contador
    jmp fatorial            ; Retorna ao início do laço


mostrar:

    ; --------------------------------------------------------
    ; 5. CONVERTER O RESULTADO DE INTEIRO PARA ASCII
    ; --------------------------------------------------------

    call int_to_str         ; Converte RAX para uma sequência ASCII

    ; Preserva o endereço e o tamanho da string convertida.
    ; Isso é necessário porque os registradores serão usados
    ; novamente para realizar a chamada write.

    mov r8, rsi             ; Guarda o endereço do resultado
    mov r9, rdx             ; Guarda o tamanho do resultado


    ; --------------------------------------------------------
    ; 6. EXIBIR A MENSAGEM DO RESULTADO
    ; --------------------------------------------------------

    mov rax, 1              ; Código 1: syscall write
    mov rdi, 1              ; Saída padrão (stdout)
    mov rsi, resultado_msg  ; Endereço da mensagem
    mov rdx, tam_resultado_msg ; Tamanho da mensagem
    syscall


    ; --------------------------------------------------------
    ; 7. EXIBIR O RESULTADO DO FATORIAL
    ; --------------------------------------------------------

    mov rax, 1              ; Código 1: syscall write
    mov rdi, 1              ; Saída padrão (stdout)
    mov rsi, r8             ; Endereço do resultado convertido
    mov rdx, r9             ; Quantidade de bytes do resultado
    syscall


    ; --------------------------------------------------------
    ; 8. ENCERRAR O PROGRAMA
    ; --------------------------------------------------------

    mov rax, 60             ; Código 60: syscall exit
    mov rdi, 0              ; Código de saída 0 (sucesso)
    syscall


; ============================================================
; FUNÇÃO: int_to_str
;
; OBJETIVO:
; Converter um número inteiro em uma sequência de caracteres
; ASCII para que possa ser exibido na tela.
;
; ENTRADA:
; RAX = Número inteiro a ser convertido.
;
; SAÍDA:
; RSI = Endereço inicial da sequência ASCII.
; RDX = Quantidade de caracteres convertidos.
;
; ESTRATÉGIA:
; Divide o número por 10 sucessivamente.
; O resto da divisão representa cada algarismo.
; Os algarismos são armazenados da direita para a esquerda.
; ============================================================

int_to_str:

    mov rbx, 10             ; Divisor utilizado para separar os dígitos

    lea rsi, [saida + 20]   ; Aponta para o final do buffer


.converter:

    xor rdx, rdx            ; Zera RDX antes da divisão

    div rbx                  ; Divide RDX:RAX por 10
                             ; RAX recebe o quociente
                             ; RDX recebe o resto

    add dl, '0'              ; Converte o resto para caractere ASCII

    dec rsi                  ; Retrocede uma posição no buffer

    mov [rsi], dl            ; Armazena o caractere no buffer

    cmp rax, 0               ; Verifica se ainda existem dígitos
    jne .converter           ; Se houver, continua a conversão

    ; Calcula a quantidade de caracteres convertidos

    lea rdx, [saida + 20]    ; Endereço final do buffer
    sub rdx, rsi             ; RDX = tamanho da string

    ret                      ; Retorna para o programa principal
