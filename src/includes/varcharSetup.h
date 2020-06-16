/* vim: ts=2:sw=2:sts=2:et:syn=c: 
 * */
#ifndef VARCHAR_SETUP
#define VARCHAR_SETUP
#include <string.h>
#include <assert.h>

/* allow for callback functions
* that can return either
* a float or an int
*/

typedef void (*convFn) (void *, char *);
typedef void (*printFn) (void *) ;

/*
* The interface struct will all the arguments voer
* the varcharSetup routine
*/
struct interface {
  char *name;
  unsigned char *arr;
  size_t size;
  unsigned short *len;
  char *src;
  short *ind;
  void *num;
  convFn f;
  printFn pf;
} ;



/* use the following with interface */
#define INTFI(s,src) { #s, s.arr, sizeof(s.arr), &s.len, src, &s ## _i }
/* return int */
#define INTFN(s,src) { #s, s.arr, sizeof(s.arr), &s.len, src, &s ## _i, &s ## _int, getInt, printInt }
/* return float */
#define INTFF(s,src) { #s, s.arr, sizeof(s.arr), &s.len, src, &s ## _i, &s ## _float, getFloat, printFloat }
#define INTF(s,src) { #s, s.arr, sizeof(s.arr), &s.len, src }
#define INTFC(s,src) { #s, &s, sizeof(s), NULL, &src, &s ## _i }
#define INITVCHAR(s) varcharInit(s.arr, sizeof(s.arr), &s.len)
#define SETVCHAR(s,src) varcharSetup(s.arr, sizeof(s.arr), &s.len, (char *) &src, NULL, NULL, NULL )
#define PVCHAR(s) printf(#s ".arr=%s " #s ".len=%d\n", s.arr, s.len)
#define NULLTERM(s) s[sizeof(s) - 1] = '\0' 
#define STRSET(s,src) \
do { \
  strncpy(s,src,sizeof(s) - 1) ; \
  s[sizeof(s) - 1] = '\0' ; \
} while (0)

#define RECFLDSET(s,src) \
	do { \
      { int f = 0 ; /* first char */ \
        int l = 0 ; /* last char */ \
        int len = 0 ; /* length of string */  \
      /* find first char not a space \
      * or a tab \
      */ \
      /* printf("strlen(src)=%d sizeof(src)=%d src=%s\n", strlen(src), sizeof(src),src) ; */ \
      for (f = 0; f < strlen(src) && (src[f] == ' ' || src[f] == '\t') ; f++) { \
        /*printf("src[%d]=%#2x ", f, src[f]) ; */ \
      }; \
      /*printf("\n") ; */ \
      /* find last char not a space \
      * or a tab \
      */ \
      for (l = strlen(src) - 1; l > -1 && (src[l] == ' ' || src[l] == '\t') ; l--) { \
        /* printf("src[%d]=%#2x ", l, src[l]) ; */ \
      }; \
      /* printf("\n") ; */ \
      len = l - f + 1 ; \
      /*printf("RECFLDSET: s=" #s " src=" #src " len=%d, l=%d, f=%d src=%s\n", len, l, f, src) ; */ \
      assert(len <= sizeof(s)) ; \
      strncpy(s,&src[f],len) ; \
    } \
	} while (0)

/* use this when the src is not null terminated */
#define REC2REC(s,src) \
	do { \
      { int f = 0 ; /* first char */ \
        int l = 0 ; /* last char */ \
        int len = 0 ; /* length of string */  \
      f = getFirstNonBlank(src,sizeof(src)); \
      if (f > -1) { \
        l = getLastNonBlank(src,sizeof(src)); \
        if (l > -1) \
          len = l - f + 1 ; \
      } \
      /* printf("REC2REC: s=" #s " src=" #src " len=%d, l=%d, f=%d src=%*.s\n", len, l, f, sizeof(src), src) ; */ \
      assert(len <= sizeof(s)) ; \
      strncpy(s,&src[f],len) ; \
    } \
	} while (0)

#define STRINIT(s) memset(s,'\0',sizeof(s))

#define STR2SPACES(s) \
do { \
  memset(s,' ',sizeof(s)) ; \
  s[sizeof(s) - 1] = '\0' ; \
} while (0)  

#define DUMPCHAR(s,size) \
do { \
  int i; \
  for (i=0;i < size; i++) \
  printf(" %c", s[i]) ; \
 }  while (0)

#define XDUMPCHAR(s,size) \
do { \
  int i; \
  for (i=0;i < size; i++) \
  printf(" %02x %c",s[i], s[i]) ; \
 }  while (0)

#define DUMPVCHAR(s) \
do { \
  int i; \
  printf(#s ".len=%d\n", s.len) ; \
  printf(#s ".arr="); \
  for (i=0;i < sizeof(s.arr); i++) \
    printf(" %02x",s.arr[i]) ; \
  printf("\n") ; \
 }  while (0)
  

int varcharSetup2(struct interface *intf) ;
int varcharSetup(unsigned char *arr, size_t size, unsigned short *len, char *src, short *ind, void *num, convFn f) ;

int varcharInit(unsigned char *arr, size_t size, unsigned short *len) ;

/*
* Accept a string that is not null terminated 
* and the size of the string 
* Scan from the right and find the last non-blank
* character and return the index of that 
* character.  This function eliminates tab,
* space, carriage return ... all ASCII
* characters from 0 to 32
*/
#define ASCII_SPACE 32
int getLastNonBlank(char *string, size_t size) ;
int getFirstNonBlank(char *string, size_t size) ;

/* default callbacks */
void getInt(void *i, char *src) ;
void printInt(void *i) ;
void getFloat(void *f, char *src) ;
void printFloat(void *f) ;

#endif
