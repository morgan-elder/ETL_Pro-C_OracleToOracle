#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gold685_cats_api.h"
static void printHeader() {
  printf("customer,");
  printf("part,");
  printf("table_nbr,");
  printf("table_name,");
  printf("update_create_delete,");
  printf("sc,");
  printf("category_instrument,");
  printf("security_code\n");
}

static void printCsv(gold68_cats_api_rcd *cats) {
  printf("\"%20.20s\",",cats->customer);
  printf("\"%50.50s\",",cats->part);
  printf("\"%3.3s\",",cats->table_nbr);
  printf("\"%30.30s\",",cats->table_name);
  printf("\"%c\",",cats->update_create_delete);
  printf("\"%20.20s\",",cats->sc);
  printf("\"%12.12s\",",cats->category_instrument);
  printf("\"%20.20s\"\n",cats->security_code);
}

static void printRec(int cnt,gold68_cats_api_rcd *cats) {
  printf("record %d. ********************************\n",cnt) ;
  printf("%35.35s= 	%20.20s\n","customer",cats->customer);
  printf("%35.35s= 	%50.50s\n","part",cats->part);
  printf("%35.35s= 	%3.3s\n","table_nbr",cats->table_nbr);
  printf("%35.35s= 	%30.30s\n","table_name",cats->table_name);
  printf("%35.35s= 	%c\n","update_create_delete",cats->update_create_delete);
  printf("%35.35s= 	%20.20s\n","sc",cats->sc);
  printf("%35.35s= 	%12.12s\n","category_instrument",cats->category_instrument);
  printf("%35.35s= 	%20.20s\n","security_code",cats->security_code);
  printf("********************************\n\n") ;
}

int main(int argc, char **argv) {
  gold68_cats_api_rcd *cats ;
  char *buf = NULL ;
  FILE *fp = NULL ;
  int cnt = 0 ;
  int dump = 0 ;
  int csv = 1;
  int i = 1;
  int quiet = 0;
  for (i = 1;i < argc; i++) {
    if (strcmp(argv[i],"-d") == 0) {
      dump = 1 ;
      csv = 0 ;
    } else if (strcmp(argv[i],"-q") == 0) {
      quiet = 1 ;
    } else {
      fp = fopen(argv[i],"r") ;
      if (fp == NULL) {
        fprintf(stderr,"Unable to open %s)\n", argv[i]) ;
    }
  }
  }
  buf = malloc(sizeof(gold68_cats_api_rcd)+1) ;
  cats = (gold68_cats_api_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(cats)=%d\n",sizeof(gold68_cats_api_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_cats_api_rcd)+1,fp) != NULL) {
    cnt = cnt + 1 ;

    { int i = 0  ;
      int unprintable = 0 ;
      for (i = 0; i < strlen(buf) ; i++) {
        if (!(isprint(buf[i]) || isspace(buf[i]))) {
          buf[i] = '?' ;
          unprintable++ ;
        }
      }
      if (unprintable && !quiet)
        fprintf(stderr,"Unprintable char found %d %s in record %d\n", unprintable, (unprintable > 1) ? "times" : "time", cnt) ;
    }

    if (csv) {
      if (cnt == 1)
        printHeader() ;
      printCsv(cats) ;
    } else {
      printRec(cnt,cats) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;
}
