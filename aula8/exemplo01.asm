; Este programa empinha e desempinha três números
section .text 
    global _start
_start:
    ; Empilhar valores na pilha (LIFO)
    mov rax, 10
    push rax     ; Empilha o valor 10
    mov rax, 20
    push rax     ; Empilha o valor 20
    mov rax, 30
    push rax     ; Empilha o valor 30
    ; Desempilhar os valores em ordem inversa
    pop rbx ; RBX recebe o valor 30
    pop rcx ; RCX recebe o valor 20
    pop rdx ; RDX recebe o valor 10
    ; Encerrar o programa
    mov rax, 60
    xor rdi, rdi
    syscall