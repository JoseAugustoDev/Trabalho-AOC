// Problema 3 - MDC

#include <stdio.h>

int mdc(int a, int b) 
{
    while (b != 0) 
    {
        int r = a % b;
        a = b;
        b = r;
    }
    return a;
}

int main() 
{
    int a, b;
    printf("Digite dois numeros inteiros positivos: ");
    scanf("%d %d", &a, &b);

    while (a <= 0 || b <= 0) 
    {
        printf("Numeros invalidos. Devem ser positivos.\n");
        
        printf("Digite dois numeros inteiros positivos: ");
        scanf("%d %d", &a, &b);
    }

    int resultado = mdc(a, b);
    printf("MDC de %d e %d: %d\n", a, b, resultado);

    return 0;
}