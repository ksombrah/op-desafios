#include <principal.h>

int main (int argc, char **argv)
	{
	int numero;
	printf("Teste de números primos entre 1 e 10000\n");
	for (numero = 1; numero <= 10000; numero++)
		{
		if (primo (numero) > 0)
			{
			printf("%d\t",numero);
			}
		}
  	return 0;
  	}
