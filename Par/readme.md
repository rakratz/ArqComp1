nasm -f elf64 ehPar.asm -o ehPar.o

gcc -no-pie main.c ehPar.o -o paridade

./paridade
