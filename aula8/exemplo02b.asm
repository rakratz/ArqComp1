; Passando dois n[umero via pilha para um função soma
section .text 
    global _start
_start:
    mov rax, 3
    push rax    ; 1º parâmetro
    mov rax, 7
    push rax    ; 2º parâmetro
    call somar
    add rsp, 16 ; quem chamou limpa os 2 parâmetros ( 2 x 8 Bytes = 16)
    ; Encerrar o programa
    mov rdi, rax
    mov rax, 60
    syscall
somar:
    mov rax, [rsp+8]    ; 2º valor (7)
    mov rbx, [rsp+16]   ; 1º valor (5)
    add rax, rbx        ; RAX = RAX + RBX ou RAX += RBX
    ret
