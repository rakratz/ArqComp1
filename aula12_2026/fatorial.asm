; Calcular o Fatorial de um número
section .data
    msg db "Digite um numero (0 a 9): ", 0
    tam_msg EQU $ - msg

    resultado_msg db "Fatorial = ", 0
    tam_resultado_msg EQU $ - resultado_msg

section .bss
    entrada resb 2
    saida resb 10

section .text
    global _start

_start: