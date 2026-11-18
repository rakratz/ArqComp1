
#include <stdio.h>

// Declaração da função implementada em Assembly
extern long fatorial(long numero);

int main()
{

    long numero;
    long resultado;

    // Solicita o número ao usuário
    printf("Digite um numero (0 a 20): ");

    // Lê e valida a entrada
    if (scanf("%ld", &numero) != 1)
    {
        printf("Entrada invalida!\n");
        return 1;
    }

    // Verifica se o número está dentro do intervalo permitido
    if (numero < 0 || numero > 20)
    {
        printf("Numero invalido!\n");
        return 1;
    }

    // Chama a função implementada em Assembly
    resultado = fatorial(numero);

    // Exibe o resultado
    printf("Fatorial = %ld\n", resultado);

    return 0;
}
