#include <principal.h>

int primo(int n) 
	{
	int d, retorno;
	
	retorno = n;
	if(n <= 1) 
		{
		retorno = 0;
		}
	for (d = 2; d < n; d++) 
		{
		if (n % d == 0)
			{
			retorno = 0;
			}
		}
	return retorno;
	}