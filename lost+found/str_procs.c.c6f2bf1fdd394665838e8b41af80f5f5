#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <assert.h>
#include "str_procs.h"

/*
 * Takes a character string, in, and determines a substring
 * based on the start and end values.  The substring is then
 * copied into the output character string, out.
 *
 * Returns:  0 for success, 1 for failure
 */
int substr(char *out, char *in, int start, int end)
{
    char buffer[5000];
    int i,j;
	
	if (start >=  0 &&  end > 0)
	{
    	for(i = 0, j = start; j < end; i++)
    	{
			buffer[i] = in[j++];
    	}
    	buffer[i] = '\0';

    	strncpy(out,buffer,i);
		return(0);
	}
	else
		return(1);
}

/************  NEEDS WORK **************/
/* Function that takes in a string and returns the
 * reversed form of it.
 *
 * Returns:  reversed string
 */
char *strrev(char *str)
{
	char temp[5000];
	int i,j;
	int cnt = strlen(str);
	
	strncpy(temp,str,cnt);

	for(i = 0, j = cnt-1; i < cnt; i++, j--)
		temp[j]	= str[i];

	temp[i] = '\0';	
	return(temp);
}


/*
 * Takes a character string and trim spaces from the
 * right side
 * 
 * Returns:  newly trimmed string
 */
char *rtrim(char *s)
{
	char *t;

	assert(s != NULL);
	t = strchr(s,'\0');
	while(t > s && isspace(t[-1]))
		--t;

	*t = '\0';	
	return(s);
}


/*
 * Takes a character string and trim spaces from the
 * left side
 * 
 * Returns:  newly trimmed string
 */
char *ltrim(char *str)
{
	strrev(str);
	rtrim(str);
	strrev(str);

	return(str);
}

/*
 * Takes a character string, in, and determines a substring
 * based on the start value and the length.  The substring is
 * copied into the temp character string.
 *
 * Returns:  the substring or NULL
 */
char *substring(char *in, int start, int len)
{
    char *buffer;

	buffer = (char *) calloc(len,sizeof(char));	
	if (start >=  0 &&  len > 0)
	{
    	while(start--)
			in++;
		buffer = in;
		while(len--)
			in++;
    	*in = '\0';

		return(buffer);
	}
	else
		return(NULL);
}

/*
 * Checks if a string is alpha
 */
int isAlpha(char *in)
{
	int i;
	int found_alpha = 0;
	int found_digit = 0;

	for(i = 0; i < strlen(in); i++)
	{
		if(isalpha(in[i]))
			found_alpha++;
		else if(isdigit(in[i]))
			found_digit++;
	}

	if(found_alpha > 0 && found_digit == 0)
		return(1);
	else
		return(0);
}

/*
 * Checks to see if a string is a number
 */
int isNum(char *in)
{
	int i;
	int found_alpha = 0;
	int found_digit = 0;

	for(i = 0; i < strlen(in); i++)
	{
		if(isalpha(in[i]) || ispunct(in[i]))
			found_alpha++;
		else if(isdigit(in[i]))
			found_digit++;
	}

	if(found_digit > 0 && found_alpha == 0)
		return(1);
	else
		return(0);
}
