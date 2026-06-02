#include <stdio.h>
#include <stdlib.h>

#define ENTRADA "entrada.txt"
#define SAIDA "saida.txt"

/* Função externa Assembler */
extern int ehPar(int num);

int main() {
    FILE *entrada;
    FILE *saida;
    int num;

    entrada = fopen(ENTRADA, "r");
    saida = fopen(SAIDA, "w");

    if ((entrada == NULL) || (saida == NULL)){
        printf("Erro ao abrir os arquivos!\n");
        return 1;
    }
    while (fscanf(entrada, "%d", &num) == 1){
        if (ehPar(num)) {
            fprintf(saida,"%d -> PAR\n", num);
        } else {
            fprintf(saida, "%d -> IMPAR\n", num);
        }
    }
    fclose(entrada);
    fclose(saida);
    return 0; 
}