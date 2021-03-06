/* vim: ts=2:sw=2:sts=2:expandtab: */
#include <assert.h>
#include <stddef.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "varcharSetup.h" 

/* 
* varcharSetup.c
* Author: Douglas S. Elder
* Date: 9/26/2014
* Desc: Take a Pro*C varchar.arr, sizeof(varchar.arr)
* varchar.len, source of data, optional null indictor, & optional numeric value
* and set the arr to all null terminators, copy the source to the arr,
* set the len to strlen(arr), optionally the null indicator to -1 
* if the len is zero otherwise to 0 
* and optionally set num to the atoi(arr)
*
*
*/


void getInt(void *i, char *src) {
 assert(i != NULL) ;
 assert(src != NULL) ;
 *(int *) i = atoi(src);
}
void printInt(void *i) {
  assert(i != NULL);
  printf("%d", *(int *) i) ;
}

void getFloat(void *f, char *src) {
 assert(f != NULL) ;
 assert(src != NULL) ;
 *(float *) f = atof(src);
}

void printFloat(void *f) {
  assert(f != NULL) ;
  printf("%f", *(float *) f);
}

int varcharSetup2(struct interface *intf) {
  assert(intf != NULL);
  return varcharSetup(intf->arr, intf->size, intf->len, intf->src, intf->ind, intf->num, intf->f);
}

int varcharSetup(unsigned char *arr, size_t size, unsigned short *len, char *src, short *ind, void *num, convFn f) {
  int length = 0 ;
  assert(arr != NULL) ;
  assert(size > 0);
  assert(src != NULL);

  if (size > 1) {
    memset(arr,'\0',size) ;
    memcpy(arr,src,size - 1) ;
    if (len != NULL) {
      #if DEBUG
        printf("arr=%s src=%s len=%hd\n", arr, src, (*len)) ;
      #endif
      (*len) = strlen(arr) ;
      #if DEBUG
        printf("(*len)=%hd\n",  (*len)) ;
      #endif
      if (ind != NULL) {
        (*ind) = ((*len) == 0) ? -1 : 0 ;
        if (num != NULL && (*len) > 0 && f != NULL) {
          f(num, arr) ;
        }
      }
    }
    length = strlen(arr) ;
  } else if (size == 1) {
    #if DEBUG
      printf("size=%zu\n", size);
      printf("src=%c\n", src[0]);
      printf("before arr=%c\n", arr[0]);
    #endif
    (*arr) = (char) src[0];
    #if DEBUG
      printf("after arr=%c\n", arr[0]);
    #endif
    if (ind != NULL) {
      (*ind) = ((*arr) == ' ') ? -1 : 0 ;
      #if DEBUG
        printf("ind=%d\n", (*ind));
      #endif
    }
    length =  1 ;  
    #if DEBUG
      printf("arr=%c\n", arr[0]);
      printf("arr=%p\n", arr);
      printf("length=%d\n", length) ;
    #endif
  }
  assert(length <= size);
  return length ;
}

int varcharInit(unsigned char *arr, size_t size, unsigned short *len) {
  assert(arr != NULL) ;
  assert(size > 0) ;
  assert(len != NULL) ;
  memset(arr,'\0',size) ;
  (*len) = 0 ;
  return (*len);
}

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
int getLastNonBlank(char *string, size_t size) {
  int i = size - 1;
  unsigned int ch = string[i] ; 

  assert(string != NULL) ;
  assert(size > 0) ;

  #ifdef DEBUG
    printf("getLastNonBlank: size=%zu ", size) ;
    DUMPCHAR(string,size) ;
    printf("\ngetLastNonBlank: start for loop\n") ;
  #endif
  
  #ifdef DEBUG
  for (i = size - 1; i > -1 && (ch = string[i]) <= ASCII_SPACE  ; i--) {
    printf("getLastNonBlank: (in for loop) i=%d ch=%x (%c)\n", i, ch, ch) ;
  }
  #endif

  #ifdef DEBUG
  printf("getLastNonBlank: after for loop\n") ;
  printf("getLastNonBlank: return=%d\n", i) ;
  #endif
  return i ;
}

int getFirstNonBlank(char *string, size_t size) {
  unsigned int ch ;
  int i = 0 ;
  assert(string != NULL) ;
  assert(size > 0) ;
  #if DEBUG
    printf("getFirstNonBlank: size=%zu ", size) ;
    DUMPCHAR(string,size) ;
    printf("\ngetFirstNonBlank: start for loop\n") ;
  #endif
  for (i = 0 ;i < size && (ch = string[i]) <= ASCII_SPACE; i++) {
    #ifdef DEBUG
    printf("getFirstNonBlank: (in for loop) string[%d]=%#x\n", i, string[i]) ;
    #endif
  } 
  #ifdef DEBUG
  printf("getFirstNonBlank: after for loop\n") ;
  printf("getFirstNonBlank: ch=%#x i=%d\n", ch, i) ;
  printf("getFirstNonBlank: return=%d\n",  (ch > ASCII_SPACE) ? i : -1) ;
  #endif
  return (ch > ASCII_SPACE) ? i : -1 ;
}

