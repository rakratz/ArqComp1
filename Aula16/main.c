#include <stdio.h>
#include <string.h>

// Declaração da função em Assembly
extern int contar_vogais(char *str, int len);

int main(){
    char texto[100];
    printf("Digite uma String: ");
    fgets(texto, sizeof(texto), stdin);
    int tamanho = sizeof(texto);
    int qtd = contar_vogais(texto, tamanho);
    printf("Quantidade de vogais: %d\n", qtd);
    return 0;
}
