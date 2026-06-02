section .text   ; 1 -> PAR ou 0 -> ÍMPAR
global ehPar    ; 1º RDI/EDI, 2º RSI/ESI, 3º RDX/EDX, 4º RCX/EDX, 5º R8 e 6º R9 
ehPar:          ; Retorno é no RAX/EAX
    mov eax, edi ; num para ver se é par ou impar
    mov ecx, 2
    xor edx, edx ; Zerando o resto
    div ecx      ;EAX/ECX e salva o resto em EDX
    cmp edx, 0  ; Comparando com 0 e seta as EFLAGS
    je par      ; Se for par goto par
impar:
    mov eax, 0 ; Retorna 0 ser for ímpar
    ret
par:
    mov eax, 1 ; Retorna 1 se for par
    ret