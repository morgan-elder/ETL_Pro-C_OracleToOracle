/*
 **************************************************************************
 *  PROGRAM NAME: 
 *
 *  PURPOSE: This application converts and String to an integer
 *           Format of call is
 *
 *                  INTGR = strng2int(STRING)
 *          
 *           The INTGR will contain a '\0' if it is unable to convert the
 *           string to an integer
 *         
 *        
 *
 *  INPUTS:   This application takes as its input a character string
 *            
 *           
 *
 *  OUTPUTS:  This application returns and integer
 *            
 *           
 *
 *  CHANGE HISTORY:
 *   REV     DATE    Programmer                 CHANGE
 *   ---  --------   ----------------------     ------
 *    00  12/11/95   Larry Mills                 Initial coding 
 *
 **************************************************************************
 **************************************************************************
 * $Header: /mcair/dev/pss/lsaprov/c/shared/source/strng2int.c,v 1.1 1999/02/15 21:24:32 m181203 Exp m181203 $                                                           
 * $Log: strng2int.c,v $
 * Revision 1.1  1999/02/15 21:24:32  m181203
 * Initial revision
 *
 * Revision 1.1  1996/08/30 17:38:27  m181203
 * Initial revision
 *
 * Revision 1.1  1995/12/12  00:08:55  m181203
 * Initial revision
 *
 * Revision 1.1  1995/12/11  23:45:53  m181203
 * Initial revision
 *
 * $Author: m181203 $                                                             
 * $Locker: m181203 $                                                             
 ************************************************************************** 
*/
#include <string.h>

int	strng2int (char string[])
{
	int i, integer_value, result = 0;
	int 	start=0;
	int	strnlength=0;
	char	negative;

	if (string[0] == '-')
	{
		start=1;
	}

	if (strlen(string) > 0)
	{
		for (i = start; i <= (strlen(string)-1); ++i)
		{
			if (string[i] >= '0' && string[i] <= '9')
			{
				integer_value = string[i] - '0';
				result = result * 10 + integer_value;
			}
			else
			{
				if (string[i] == ',' ||
				    string[i] == ' ')
				{
				}
				else
				{
					result='\0';
					i=strlen(string);
				}
			}
		}
	}
	else
	{
		result='\0';
	}
		

	if (string[0] == '-')
	{
		result = 0-result;
	}

	return(result);
}
