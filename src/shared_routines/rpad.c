/*                           substr.c
 **************************************************************************
 *  PROGRAM NAME: rpad.c
 *
 *  PURPOSE: This application is a c function which is used to right
 *           pad or fill a string with the same character
 *        
 *
 *  INPUTS:  input args:
 *    destnation string
 *    source string,
 *    pad character,
 *    sizeof string - use sizeof function to get the total number
 *    of characters
 *            
 *
 *  OUTPUTS: padded string 
 *           
 *
 *  CHANGE HISTORY:
 *   REV     DATE    Programmer                 CHANGE
 *   ---  --------   ----------------------     ------
 *    00  09/23/14   Douglas Elder                Initial coding 
 *
 **************************************************************************
 **************************************************************************
 ************************************************************************** 
*/
/*                    rpad.c
 *
 *    This function is used to pad or fill a string with a character
 *    and the last char is the null terminator
 *
 *  rpad(dest, src,' ',20) ;
 *
 *
 *
 */

#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
char *rpad(char *dest, const char *src, const char pad, const size_t sz)
{
   assert(dest != NULL) ;
   assert(src != NULL) ;
   memset(dest, pad, sz);
   dest[sz - 1] = '\0';
   if (strlen(src) <= sz - 1)
     memcpy(dest, src, strlen(src));
   else
     memcpy(dest, src, sz - 1);
   return dest;
}

