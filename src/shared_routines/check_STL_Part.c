#include <string.h>

/*
 * This routine checks to see if the Part Number being passed
 * is a Boeing St. Louis Part Number.  This program will return
 * a '0' if the Part Number passed belongs to the  program being
 * passed.  It will return a '1' if it does not relate to the program
 * being passed.  It will return '-1' if it is unable to process
 * the request.  The calling program should check for this -1.
 */
int	check_STL_Part(char *pgm,char *partno)
{
	int	valid_part=0;

	if(strncmp(pgm,"F18",3)==0)
	{
		printf("\nPart Number Passed (%s)\n",partno);
		if(strncmp(partno,"74A",3)==0 ||
		    strncmp(partno,"74B",3)==0 ||
		    strncmp(partno,"74D",3)==0 ||
		    strncmp(partno,"3M",2)==0 ||
		    strncmp(partno,"4M",2)==0 ||
		    strncmp(partno,"5M",2)==0 ||
		    strncmp(partno,"7M",2)==0 ||
		    strncmp(partno,"8M",2)==0 ||
		    strncmp(partno,"9M",2)==0 ||
		    strncmp(partno,"11M",3)==0 ||
		    strncmp(partno,"20M",3)==0 ||
		    strncmp(partno,"ST3M",4)==0 ||
		    strncmp(partno,"ST4M",4)==0 ||
		    strncmp(partno,"ST5M",4)==0 ||
		    strncmp(partno,"ST7M",4)==0 ||
		    strncmp(partno,"ST9M",4)==0) 
		{
			return(0);
		}
		else
		{
			return(1);
		}
	}
	else
	{
		printf("\nUnable to determine if the Program for the Part Number\n");
		return(-1);
	}
}
