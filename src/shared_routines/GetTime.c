#include <time.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
/* vim: ts=2:sw=2:sts=2:expandtab
* GetTime.c
* Author: Douglas S. Elder
* Date: 9/25/2014
* Rev: 1.0
*
*/
long  GetTime(char *pgmtime,int timesize)
{
  char *pgmtime_ptr=pgmtime;
  char buffer[81] ;


  struct tm *tmstruct;
  time_t  tnow;

  assert(pgmtime != NULL) ;
  assert(timesize >= 20 ) ; /* minimum buffer size */

  buffer[0] = '\0' ;

  time(&tnow);
  tmstruct=localtime(&tnow);
  strftime(buffer,timesize,"%m/%d/%Y-%H:%M:%S",tmstruct);

  #ifdef DEBUG
    printf("buffer=%s strlen(buffer)=%d timesize=%d\n", 
      buffer, strlen(buffer), timesize) ;
  #endif

  /* make sure the buffer is big enough for the formatted time */
  assert(strlen(buffer) <= timesize - 1) ;


  strcpy(pgmtime, buffer) ;

  return(tnow);

}
