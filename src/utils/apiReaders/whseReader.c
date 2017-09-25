#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gold685_whse_api_FMT_v2.h"
static void printHeader() {
  printf("customer,");
  printf("part,");
  printf("sc,");
  printf("table_nbr,");
  printf("table_name,");
  printf("update_create_delete,");
  printf("user_ref1,");
  printf("user_ref2,");
  printf("user_ref3,");
  printf("user_ref4,");
  printf("user_ref5,");
  printf("user_ref6,");
  printf("user_ref7,");
  printf("user_ref8,");
  printf("user_ref9,");
  printf("user_ref10,");
  printf("user_ref11,");
  printf("user_ref12,");
  printf("user_ref13,");
  printf("user_ref14,");
  printf("user_ref15,");
  printf("stock_level,");
  printf("reorder_point,");
  printf("remarks,");
  printf("default_bin,");
  printf("freeze_ordering_b,");
  printf("freeze_receiving_b,");
  printf("freeze_iss_disp_b,");
  printf("freeze_xfer_i_b,");
  printf("freeze_xfer_o_b,");
  printf("freeze_other_b,");
  printf("pi_recommend_b,");
  printf("auth_allow,");
  printf("c_elin,");
  printf("ims_designator_code,");
}

static void printCsv(gold68_whse_api_FMT_rcd *whse) {
  printf("\"%20.20s\",",whse->customer);
  printf("\"%50.50s\",",whse->part);
  printf("\"%20.20s\",",whse->sc);
  printf("\"%3.3s\",",whse->table_nbr);
  printf("\"%30.30s\",",whse->table_name);
  printf("\"%c\",",whse->update_create_delete);
  printf("\"%20.20s\",",whse->user_ref1);
  printf("\"%20.20s\",",whse->user_ref2);
  printf("\"%20.20s\",",whse->user_ref3);
  printf("\"%20.20s\",",whse->user_ref4);
  printf("\"%20.20s\",",whse->user_ref5);
  printf("\"%20.20s\",",whse->user_ref6);
  printf("\"%20.20s\",",whse->user_ref7);
  printf("\"%20.20s\",",whse->user_ref8);
  printf("\"%20.20s\",",whse->user_ref9);
  printf("\"%20.20s\",",whse->user_ref10);
  printf("\"%20.20s\",",whse->user_ref11);
  printf("\"%20.20s\",",whse->user_ref12);
  printf("\"%20.20s\",",whse->user_ref13);
  printf("\"%20.20s\",",whse->user_ref14);
  printf("\"%20.20s\",",whse->user_ref15);
  printf("\"%15.15s\",",whse->stock_level);
  printf("\"%15.15s\",",whse->reorder_point);
  printf("\"%60.60s\",",whse->remarks);
  printf("\"%20.20s\",",whse->default_bin);
  printf("\"%c\",",whse->freeze_ordering_b);
  printf("\"%c\",",whse->freeze_receiving_b);
  printf("\"%c\",",whse->freeze_iss_disp_b);
  printf("\"%c\",",whse->freeze_xfer_i_b);
  printf("\"%c\",",whse->freeze_xfer_o_b);
  printf("\"%c\",",whse->freeze_other_b);
  printf("\"%c\",",whse->pi_recommend_b);
  printf("\"%15.15s\",",whse->auth_allow);
  printf("\"%20.20s\",",whse->c_elin);
  printf("\"%20.20s\",",whse->ims_designator_code);
}

static void printRec(int cnt,gold68_whse_api_FMT_rcd *whse) {
  printf("record %d. ********************************\n",cnt) ;
  printf("%35.35s= 	%20.20s\n","customer",whse->customer);
  printf("%35.35s= 	%50.50s\n","part",whse->part);
  printf("%35.35s= 	%20.20s\n","sc",whse->sc);
  printf("%35.35s= 	%3.3s\n","table_nbr",whse->table_nbr);
  printf("%35.35s= 	%30.30s\n","table_name",whse->table_name);
  printf("%35.35s= 	%c\n","update_create_delete",whse->update_create_delete);
  printf("%35.35s= 	%20.20s\n","user_ref1",whse->user_ref1);
  printf("%35.35s= 	%20.20s\n","user_ref2",whse->user_ref2);
  printf("%35.35s= 	%20.20s\n","user_ref3",whse->user_ref3);
  printf("%35.35s= 	%20.20s\n","user_ref4",whse->user_ref4);
  printf("%35.35s= 	%20.20s\n","user_ref5",whse->user_ref5);
  printf("%35.35s= 	%20.20s\n","user_ref6",whse->user_ref6);
  printf("%35.35s= 	%20.20s\n","user_ref7",whse->user_ref7);
  printf("%35.35s= 	%20.20s\n","user_ref8",whse->user_ref8);
  printf("%35.35s= 	%20.20s\n","user_ref9",whse->user_ref9);
  printf("%35.35s= 	%20.20s\n","user_ref10",whse->user_ref10);
  printf("%35.35s= 	%20.20s\n","user_ref11",whse->user_ref11);
  printf("%35.35s= 	%20.20s\n","user_ref12",whse->user_ref12);
  printf("%35.35s= 	%20.20s\n","user_ref13",whse->user_ref13);
  printf("%35.35s= 	%20.20s\n","user_ref14",whse->user_ref14);
  printf("%35.35s= 	%20.20s\n","user_ref15",whse->user_ref15);
  printf("%35.35s= 	%15.15s\n","stock_level",whse->stock_level);
  printf("%35.35s= 	%15.15s\n","reorder_point",whse->reorder_point);
  printf("%35.35s= 	%60.60s\n","remarks",whse->remarks);
  printf("%35.35s= 	%20.20s\n","default_bin",whse->default_bin);
  printf("%35.35s= 	%c\n","freeze_ordering_b",whse->freeze_ordering_b);
  printf("%35.35s= 	%c\n","freeze_receiving_b",whse->freeze_receiving_b);
  printf("%35.35s= 	%c\n","freeze_iss_disp_b",whse->freeze_iss_disp_b);
  printf("%35.35s= 	%c\n","freeze_xfer_i_b",whse->freeze_xfer_i_b);
  printf("%35.35s= 	%c\n","freeze_xfer_o_b",whse->freeze_xfer_o_b);
  printf("%35.35s= 	%c\n","freeze_other_b",whse->freeze_other_b);
  printf("%35.35s= 	%c\n","pi_recommend_b",whse->pi_recommend_b);
  printf("%35.35s= 	%15.15s\n","auth_allow",whse->auth_allow);
  printf("%35.35s= 	%20.20s\n","c_elin",whse->c_elin);
  printf("%35.35s= 	%20.20s\n","ims_designator_code",whse->ims_designator_code);
  printf("********************************\n\n") ;
}

int main(int argc, char **argv) {
  gold68_whse_api_FMT_rcd *whse ;
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
  buf = malloc(sizeof(gold68_whse_api_FMT_rcd)+1) ;
  whse = (gold68_whse_api_FMT_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(whse)=%d\n",sizeof(gold68_whse_api_FMT_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_whse_api_FMT_rcd)+1,fp) != NULL) {
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
      printCsv(whse) ;
    } else {
      printRec(cnt,whse) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;
}
