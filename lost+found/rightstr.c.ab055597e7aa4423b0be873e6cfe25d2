/*
 *                               rightstr.c
 *
 *  this program functions performs the function of the basic command
 *  RIGHT$.
 *
 *  To Use:
 *	1.  Declare the following:i
 *          a. char *cp, *Rightstr()
 *
 *      2.  Invoke as follows:
 *          cp = Rightstr(string,length)
 *           
 *        Note:  string is your Character String that contains the information
 *               you want to check, While length is the number of characters
 *               in string that contains the information you want to check.
 *
 *        example:
 *	    char   string[]="This is a test";
 *          char   *cp, *Righttr();
 *
 *         if ((cp=Rightstr(string,4));
 *
 *            cp should contain "test".
 *
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *Rightstr(char *str,int cnt)
{
   static char *cp = NULL;

   if (cnt > strlen(str))
	cnt = strlen(str);
   if (cp != NULL)
	free(cp);
   if((cp = (char *) malloc(cnt + 1)) == NULL)
	return (NULL);
   strncpy(cp,str+strlen(str)-cnt,cnt);
   return(cp);
}

