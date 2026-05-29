#include <stdio.h>
#include <string.h>

// Declaração da função em Assembly
extern int contar_vogais(char *str, int len);

int main(){
    char texto[100];
    printf("Digite uma string: ");
    fgets(texto, sizeof(texto), stdin);
    int tamanho = strlen(texto);
    // Remove o \n do final (opcional)
    if (texto[tamanho - 1] == '\n') {
        texto[tamanho - 1] = '\0';
        tamanho--;
    }
    int qtd = contar_vogais(texto, tamanho);
    printf("Quantidade de vogais: %d\n", qtd);
    return 0;
}
