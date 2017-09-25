#include <stdio.h>
#include <string.h>
#include "rpad.h"

int main(int argc, char **argv) {

	char dest[20];
	char src[] = "Douglas" ;
	char *src2 = NULL;
	char src3[] = "123456789012345678901" ;

	printf("rpad(dest, src, ' ', sizeof(dest))=(%s)\n",
		rpad(dest,src,' ',sizeof(dest)));
	printf("rpad(dest, src, 'X', sizeof(dest))=(%s)\n",
		rpad(dest,src,'X',sizeof(dest)));
	printf("rpad(dest, src2, 'X', sizeof(dest))=(%s)\n",
		rpad(dest,src2,'X',sizeof(dest)));
		printf("rpad(dest, src3, 'X', sizeof(dest))=(%s) len=%d strlen(src3)=%d\n",
		rpad(dest,src3,'X',sizeof(dest)),
		strlen(rpad(dest,src3,'X',sizeof(dest))),
		strlen(src3));
}
