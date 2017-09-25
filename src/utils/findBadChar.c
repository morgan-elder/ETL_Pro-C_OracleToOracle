#include <stdio.h>
#include <ctype.h>
int main(int argc, char **argv) {
  FILE *fp = NULL ;
  char c ;
  int charCnt = 0 ;
  int col = 0 ;
  int startCol = 0 ;
  int lineCnt = 0 ;
  int wordCnt = 0 ;
  int inWord = 0 ;
  int repeatCnt = 0 ;
  char prevChar  ;

  if (argc < 2) {
    fprintf(stderr,"Usage: findBadChar filename\n") ;
    return 2 ;
  }

  if ((fp = fopen(argv[1],"r")) == NULL) {
    fprintf(stderr,"Unable to open file %s\n", argv[1]) ;
    return 2 ;
  }

  while ((c = fgetc(fp)) != EOF) {
    charCnt++  ;

    if (c=='\n') {
      lineCnt++ ;
      col = 0 ;
    } else {
      col++ ;
    }

    if (!isspace(c) && !iscntrl(c) && isprint(c) ) {
      inWord = 1 ;
    } else if (ispunct(c) || isspace(c) ) {
      if (inWord) {
        wordCnt++ ;
        inWord = 0 ;
      }
    } else if ( isdigit(c) || isprint(c) ) {
      /* do nothing */
    } else {
      if (c == prevChar ) {
        repeatCnt++ ;
        startCol = col ;
      } else {
        /* need to increment the lineCnt by one since the \n char for the line being scanned
         * has not been found yet.  So the actual line # for the current character is one 
         * more than the current value of lineCnt
         */
        printf("For line %d column %d found ascii char=x%x (%d)\n",lineCnt+1,col,c & 0xff, c & 0xff) ;
      }
    }
    if (c != prevChar && repeatCnt > 0) {
      if (repeatCnt == 1) {
        /* do nothing */
      } else {
        printf("For line %d starting at column %d found ascii char=x%x (%d) it repeated %d times\n",lineCnt+1, startCol,prevChar & 0xff,prevChar & 0xff,repeatCnt) ;
      }
      repeatCnt = 0 ;
      startCol = 0 ;
    }
    prevChar = c ;
  }

  printf("%s\nnumber of lines=%d\nnumber of characters=%d\nnumber of words=%d\n",
    argv[1],lineCnt,charCnt, wordCnt);
}
