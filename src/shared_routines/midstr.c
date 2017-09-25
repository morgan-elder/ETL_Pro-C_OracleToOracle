/*
 *                               midstr.c
 *
 *  this program functions performs the function of the basic command
 *  MID$.
 *
 *
 *  To Use:
 *	1.  Declare the following:i
 *          a. char *cp, *Midstr()
 *
 *      2.  Invoke as follows:
 *          cp = Midstr(string,start,length)
 *           
 *        Note:  string is your Character String that contains the information
 *               you want to check, While start is the starting position where
 *               the information in string begins and length is the number of
 *               characters in string that contains the information you want
 *               to check.
 *
 *        example:
 *	    char   string[]="This is a test";
 *          char   *cp, *Midstr();
 *
 *         if ((cp=Midstr(string,6,4));
 *
 *            cp should contain "is a".
 *
 */

#include <stdio.h>

char *Midstr(str,where,cnt)
char	*str;
int	where;
int	cnt;
{
   static char *cp = NULL;
   char *malloc();

   if (cnt > strlen(str + where))
	cnt = strlen(str + where);
   if (cp != NULL)
	free(cp);
   if((cp = malloc(cnt + 1)) == NULL)
	return (NULL);
   strncpy(cp,str+where,cnt);
   return(cp);
}

