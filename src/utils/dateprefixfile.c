/* fixNames.c
* Author: Douglas S. Elder
* Date: 3/7/15
* Desc: iterate through all the files in the current directory 
* and make sure they have a time stamp
**/

#include <sys/stat.h>
#include <unistd.h>
#include <time.h>
#include <string.h>
#include <dirent.h>
#include <stdio.h>
	
struct tm* lastMod;				/* create a time structure */
struct stat attrib;			/* create a file attribute structure */

int main(int argc, char **argv) {	
  char date[256] ;
  char newName[256] ;
  char theYear[256] ;
  int result = 0 ;
  char *ptr = NULL ;
  int prompt = 1 ;
  int debug = 0 ;
  char ans ;

  DIR           *d = NULL ;
  struct dirent *dir;
  int i ;
  char *lastSlash = NULL ;
  d = opendir(".");

  for (i = 1; i < argc; i++) {
    if (strcmp(argv[i],"-n") == 0) {
      prompt = 0 ;
      printf(" NOT prompting\n") ;
    }
    if (strcmp(argv[i],"-d") == 0) {
      debug = 1 ;
      printf(" debugging\n") ;
    }
  }

  if (d)
  {
    printf(" scan file names\n") ;
    while ((dir = readdir(d)) != NULL)
    {

      /* don't rename this app or irs source code */
      if (strcmp(dir->d_name,"fixnames") == 0 
        || strcmp(dir->d_name,"fixNames.c") == 0)
        continue ;

      printf("%s\n", dir->d_name) ;
      if (strcmp(dir->d_name,".") == 0 || strcmp(dir->d_name,"..") == 0) {
        if (debug) 
          printf("skip to end 1\n") ;
        continue ;
      }
      if (debug)  
        printf("get the attributes of %s\n", dir->d_name) ;
      stat(dir->d_name, &attrib);		/* get the attributes of the file */
      if (debug) 
        printf("get the Year of %s\n",dir->d_name) ;
      strftime(theYear, 20, "%Y", localtime(&(attrib.st_mtime))); 
      if (debug) { 
        strftime(newName, 25, "%Y_%m_%d_%H_%M_%S_", localtime(&(attrib.st_mtime)));
        printf("prefix=%s\n",newName) ;
      }
      ptr = strstr(dir->d_name,theYear) ;
      if ( ptr == NULL && prompt == 1 ) {
        printf("date prefix %s y or n:", dir->d_name)  ;
        ans = '\0' ;
        while((ans=getchar())!='n' && ans != 'y') ;
        if (debug)
          printf("ans=%c\n",ans);
        if (ans == 'n') {
          if (debug)
            printf( "skip to end 2\n") ;
          continue ;
        } 
      }
      if ( ptr == NULL ) {
        // create YYYY_MM_DD_HH_MM_SS_ time stamp prefix
        if (debug)
          printf("creating time stamp\n") ;
        strftime(newName, 25, "%Y_%m_%d_%H_%M_%S_", localtime(&(attrib.st_mtime)));
        if (debug)
          printf("%s\n", newName) ;
        if (debug) 
          printf("appendfing file %s\n", dir->d_name) ;
        strcat(newName,dir->d_name) ;
        char oldName[256] ;
        if (debug)
          printf("save old name\n") ;
        strcpy(oldName,dir->d_name) ;

        result= rename( dir->d_name , newName );
        if ( result == 0 )
          printf("%s date prefixed %s\n", oldName, newName) ;
        else
          fprintf(stderr,"error renaming %s\n",oldName) ;

      }
    }

    closedir(d);
  }	

	
}
