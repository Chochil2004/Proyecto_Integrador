%{
#include <stdio.h>
#include <stdlib.h>
int total = 0;
int precios[10] = {10, 15, 12, 18, 14, 13, 9, 11, 16, 20};
%}

/* DEFINICIONES */
BILLETE     \$1|\$5|\$10|\$20|\$50
PRODUCTO    P[0-9]
ESPACIO     [ \t\n]+

%%

{BILLETE} {
    int valor = atoi(yytext + 1); // +1 para saltar el $
    total += valor;
    printf("Ingresaste: %d pesos. Total acumulado: %d\n", valor, total);
}

{PRODUCTO} {
    int id = yytext[1] - '0';
    int precio = precios[id];
    printf("Seleccionaste el producto P%d (precio: %d)\n", id, precio);
    if (total >= precio) {
        int cambio = total - precio;
        printf("Producto entregado. Cambio: %d pesos\n", cambio);
        total = 0;
    } else {
        printf("Saldo insuficiente. Te faltan %d pesos.\n", precio - total);
    }
}

{ESPACIO} { /* Ignora espacios y saltos de línea */ }

. { printf("Entrada inválida: %s\n", yytext); }

%%

int main() {
    printf("=== Máquina Autovend ===\n");
    printf("Ingresa dinero ($1, $5, $10, $20, $50) y selecciona un producto (P0–P9):\n");
    printf("\nLista de productos disponibles:\n");
    
    // Mostrar la lista de productos
    for (int i = 0; i < 10; i++) {
        printf("Producto P%d - Precio: %d pesos\n", i, precios[i]);
    }
    
    printf("\nSelecciona un producto escribiendo el código (P0–P9):\n");
    yylex();
    return 0;
}

int yywrap() {
    return 1;  // Fin del archivo
}

