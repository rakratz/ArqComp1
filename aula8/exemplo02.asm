; Passando dois n[umero via pilha para um função soma
section .text 
    global _start
_start:
    mov rax, 5
    push rax

    mov rax, 7
    push rax

    call somar

    ; Encerrar o programa
    mov rax, 60
    xor rdi, rdi
    syscall

somar:
    pop rax ; Segundo valor (7) em RAX
    pop rbx ; Primeiro valor (5) em RBX

    add rax, rbx    ; RAX = RAX + RBX ou RAX += RBX
    ret
