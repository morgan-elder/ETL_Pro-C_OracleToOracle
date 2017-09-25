/*
 *                               leftstr.c
 *
 *  this program functions performs the function of the basic command
 *  LEFT$.
 *
 *  To Use:
 *	1.  Declare the following:i
 *          a. char *cp, *Leftstr()
 *
 *      2.  Invoke as follows:
 *          cp = Leftstr(string,start,length)
 *           
 *        Note:  string is your Character String that contains the information
 *               you want to check, While length is the number of characters
 *               in string that contains the information you want to check.
 *
 *        example:
 *	    char   string[]="This is a test";
 *          char   *cp, *Leftstr();
 *
 *         if ((cp=Leftstr(string,4));
 *
 *            cp should contain "This".
 *
 *
 */

#include <stdio.h>

char *Leftstr(str,cnt)
char	*str;
int	cnt;
{
   static char *cp = NULL;
   char *malloc();

   if (cnt > strlen(str))
	cnt = strlen(str);
   if (cp != NULL)
	free(cp);
   if((cp = malloc(cnt + 1)) == NULL)
	return (NULL);
   strncpy(cp,str,cnt);
   return(cp);
}

