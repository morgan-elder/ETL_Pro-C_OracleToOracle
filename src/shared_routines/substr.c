/*                           substr.c
 **************************************************************************
 *  PROGRAM NAME: substr.c
 *
 *  PURPOSE: This application is a c function which is used to extract
 *           substrings from within larger strings.  
 *        
 *
 *  INPUTS:  Input arguments are: destination string, source string,
 *           starting byte offset within the source string, and length
 *           or number of bytes to be extracted.
 *            
 *
 *  OUTPUTS: substring 
 *           
 *
 *  CHANGE HISTORY:
 *   REV     DATE    Programmer                 CHANGE
 *   ---  --------   ----------------------     ------
 *    00  10/16/95   LARRY MILLS                Initial coding 
 *
 **************************************************************************
 **************************************************************************
 * $Header: /mcair/dev/pss/lsaprov/c/shared/source/substr.c,v 1.1 1999/02/15 21:24:35 m181203 Exp m181203 $                                                             
 * $Log: substr.c,v $
 * Revision 1.1  1999/02/15 21:24:35  m181203
 * Initial revision
 *
 * Revision 1.4  1996/09/04 16:05:47  m181203
 * *** empty log message ***
 *
 * Revision 1.3  1995/11/06 17:32:48  m124639
 * Source from Release devel
 *
 * Revision 1.1  1995/11/05  21:04:12  m124639
 * Initial revision
 *
# Revision 1.1  1995/11/04  15:46:35  m124639
# Initial revision
#                                                                
 * $Author: m181203 $                                                             
 * $Locker: m181203 $                                                             
 ************************************************************************** 
*/
/*                    substr.c
 *
 *    This function is used to copy portions of a character string
 *       to another character string.  
 *
 *	errcode=substr(inStruct.fld1,myData,0,2);
 *
 *
 *  To Use:
 *	1.  Declare the following:i
 *          a. int  start, lngth, errcode
 *	    b. char source[]
 *	    c. char dest[]
 *	    d. int  start
 *    	    e. int  lngth
 *
 *
 *      2.  Invoke as follows:
 *
 *	errcode=substr(dest, source, start, lngth)
 *           
 *        Note:  source is the Character String that contains the information
 *               you want to move to the dest. start is the starting position
 *               of the data and lngth is the number of characters to be moved.
 *
 *        example:
 *	    char   source[]="This is a test";
 *	    char   dest[];
 *          int    start=5;
 *	    int	   lngth=2;
 *
 *         errcode=substr(dest, source,start,lngth)
 *
 *            dest will contain "is".
 *
 */
int	substr(target, source, start, lngth)
char	target[];
char	source[];
int	start;
int	lngth;
{
	int	errcode=0;
	int	target_pos=0;

	if (start>=0 && lngth >0)
	{
		for (target_pos=0; target_pos<=(lngth-1); target_pos++)
		{
			target[target_pos]=source[start];
			start++;
		}
	}
	else
	{
		errcode=1;
	}

	return(errcode);
}
