#include <stdio.h>

int main() 
{
    int M, N;
    printf("Digite dois numeros (M e N): ");
    scanf("%d %d", &M, &N);

    while (M < 3 || N <= M) 
    {
        printf("Condicoes invalidas! M deve ser >= 3 e N > M.\n");

        printf("Digite novamente M e N: ");
        scanf("%d %d", &M, &N);
    } 
    
    int ant = 1, atual = 1, prox = ant + atual;
    int contador = 0;

    while (prox < N) 
    {
        if (prox >= M) 
        {
            printf("%d ", prox);
            contador++;
        }
        ant = atual;
        atual = prox;
        prox = ant + atual;
    }

    printf("\nTotal de termos exibidos: %d\n", contador);
   

    return 0;
}