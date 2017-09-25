#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gold685_prc1_api_FMT.h"
static void printHeader() {
  printf("customer,");
  printf("part,");
  printf("sc,");
  printf("table_nbr,");
  printf("table_name,");
  printf("update_create_delete,");
  printf("cmav,");
  printf("cap_price,");
  printf("gfp_price,");
  printf("price1,");
  printf("price2,");
  printf("price3,");
  printf("price4,");
  printf("price5,");
  printf("price6,");
  printf("price7,");
  printf("price8,");
  printf("price9,");
  printf("price10,");
  printf("price11,");
  printf("price12,");
  printf("price_date,");
  printf("price_type\n");

}

static void printCsv(gold68_prc1_api_FMT_rcd *prc) {
  printf("\"%20.20s\",",prc->customer);
  printf("\"%50.50s\",",prc->part);
  printf("\"%20.20s\",",prc->sc);
  printf("\"%3.3s\",",prc->table_nbr);
  printf("\"%30.30s\",",prc->table_name);
  printf("\"%c\",",prc->update_create_delete);
  printf("\"%15.15s\",",prc->cmav);
  printf("\"%15.15s\",",prc->cap_price);
  printf("\"%15.15s\",",prc->gfp_price);
  printf("\"%15.15s\",",prc->price1);
  printf("\"%15.15s\",",prc->price2);
  printf("\"%15.15s\",",prc->price3);
  printf("\"%15.15s\",",prc->price4);
  printf("\"%15.15s\",",prc->price5);
  printf("\"%15.15s\",",prc->price6);
  printf("\"%15.15s\",",prc->price7);
  printf("\"%15.15s\",",prc->price8);
  printf("\"%15.15s\",",prc->price9);
  printf("\"%15.15s\",",prc->price10);
  printf("\"%15.15s\",",prc->price11);
  printf("\"%15.15s\",",prc->price12);
  printf("\"%10.10s\",",prc->price_date);
  printf("\"%20.20s\"\n",prc->price_type);

}

static void printRec(int cnt,gold68_prc1_api_FMT_rcd *prc) {
  printf("record %d. ********************************\n",cnt) ;
  printf("%35.35s= 	%20.20s\n","customer",prc->customer);
  printf("%35.35s= 	%50.50s\n","part",prc->part);
  printf("%35.35s= 	%20.20s\n","sc",prc->sc);
  printf("%35.35s= 	%3.3s\n","table_nbr",prc->table_nbr);
  printf("%35.35s= 	%30.30s\n","table_name",prc->table_name);
  printf("%35.35s= 	%c\n","update_create_delete",prc->update_create_delete);
  printf("%35.35s= 	%15.15s\n","cmav",prc->cmav);
  printf("%35.35s= 	%15.15s\n","cap_price",prc->cap_price);
  printf("%35.35s= 	%15.15s\n","gfp_price",prc->gfp_price);
  printf("%35.35s= 	%15.15s\n","price1",prc->price1);
  printf("%35.35s= 	%15.15s\n","price2",prc->price2);
  printf("%35.35s= 	%15.15s\n","price3",prc->price3);
  printf("%35.35s= 	%15.15s\n","price4",prc->price4);
  printf("%35.35s= 	%15.15s\n","price5",prc->price5);
  printf("%35.35s= 	%15.15s\n","price6",prc->price6);
  printf("%35.35s= 	%15.15s\n","price7",prc->price7);
  printf("%35.35s= 	%15.15s\n","price8",prc->price8);
  printf("%35.35s= 	%15.15s\n","price9",prc->price9);
  printf("%35.35s= 	%15.15s\n","price10",prc->price10);
  printf("%35.35s= 	%15.15s\n","price11",prc->price11);
  printf("%35.35s= 	%15.15s\n","price12",prc->price12);
  printf("%35.35s= 	%10.10s\n","price_date",prc->price_date);
  printf("%35.35s= 	%20.20s\n","price_type",prc->price_type);
  printf("********************************\n\n") ;
}

int main(int argc, char **argv) {
  gold68_prc1_api_FMT_rcd *prc ;
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
  buf = malloc(sizeof(gold68_prc1_api_FMT_rcd)+1) ;
  prc = (gold68_prc1_api_FMT_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(prc)=%d\n",sizeof(gold68_prc1_api_FMT_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_prc1_api_FMT_rcd)+1,fp) != NULL) {
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
      printCsv(prc) ;
    } else {
      printRec(cnt,prc) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;
}
