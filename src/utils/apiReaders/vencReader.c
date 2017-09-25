#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "gold685_venc_api_sort_cntrl.h"
void printHeader() {
  printf("sort_cage,");
  printf("customer,");
  printf("part,");
  printf("table_nbr,");
  printf("table_name,");
  printf("update_create_delete,");
  printf("vendor_part,");
  printf("vendor_code,");
  printf("vendor_name,");
  printf("last_order_price,");
  printf("vendor_flag,");
  printf("vendor_model,");
  printf("approved_vendor_b,");
  printf("approved_date,");
  printf("agency_approved_b,");
  printf("preferred_vendor_b,");
  printf("last_order_date,");
  printf("list_price,");
  printf("list_price_date,");
  printf("list_price_valid_date,");
  printf("customer_discount,");
  printf("customer_cost,");
  printf("total_deliveries,");
  printf("late_deliveries,");
  printf("vendor_leadtime,");
  printf("turnaround_time,");
  printf("priority,");
  printf("cost,");
  printf("lead_time,");
  printf("agency_approved_date,");
  printf("minimum_order_qty,");
  printf("total_days_late,");
  printf("total_leadtime\n");
}

void printCsv(gold68_venc_api_sort_rcd *venc) {
  printf("\"%20.20s\",",venc->sort_cage);
  printf("\"%20.20s\",",venc->customer);
  printf("\"%50.50s\",",venc->part);
  printf("\"%3.3s\",",venc->table_nbr);
  printf("\"%30.30s\",",venc->table_name);
  printf("\"%c\",",venc->update_create_delete);
  printf("\"%50.50s\",",venc->vendor_part);
  printf("\"%20.20s\",",venc->vendor_code);
  printf("\"%60.60s\",",venc->vendor_name);
  printf("\"%15.15s\",",venc->last_order_price);
  printf("\"%20.20s\",",venc->vendor_flag);
  printf("\"%50.50s\",",venc->vendor_model);
  printf("\"%c\",",venc->approved_vendor_b);
  printf("\"%10.10s\",",venc->approved_date);
  printf("\"%c\",",venc->agency_approved_b);
  printf("\"%c\",",venc->preferred_vendor_b);
  printf("\"%10.10s\",",venc->last_order_date);
  printf("\"%15.15s\",",venc->list_price);
  printf("\"%10.10s\",",venc->list_price_date);
  printf("\"%10.10s\",",venc->list_price_valid_date);
  printf("\"%3.3s\",",venc->customer_discount);
  printf("\"%15.15s\",",venc->customer_cost);
  printf("\"%4.4s\",",venc->total_deliveries);
  printf("\"%4.4s\",",venc->late_deliveries);
  printf("\"%4.4s\",",venc->vendor_leadtime);
  printf("\"%5.5s\",",venc->turnaround_time);
  printf("\"%2.2s\",",venc->priority);
  printf("\"%15.15s\",",venc->cost);
  printf("\"%5.5s\",",venc->lead_time);
  printf("\"%10.10s\",",venc->agency_approved_date);
  printf("\"%15.15s\",",venc->minimum_order_qty);
  printf("\"%15.15s\",",venc->total_days_late);
  printf("\"%8.8s\"\n",venc->total_leadtime);
}

void printRec(int cnt, gold68_venc_api_sort_rcd *venc) {
  printf("\"%20.20s\",",venc->sort_cage);
  printf("\"%20.20s\",",venc->customer);
  printf("\"%50.50s\",",venc->part);
  printf("\"%3.3s\",",venc->table_nbr);
  printf("\"%30.30s\",",venc->table_name);
  printf("\"%c\",",venc->update_create_delete);
  printf("\"%50.50s\",",venc->vendor_part);
  printf("\"%20.20s\",",venc->vendor_code);
  printf("\"%60.60s\",",venc->vendor_name);
  printf("\"%15.15s\",",venc->last_order_price);
  printf("\"%20.20s\",",venc->vendor_flag);
  printf("\"%50.50s\",",venc->vendor_model);
  printf("\"%c\",",venc->approved_vendor_b);
  printf("\"%10.10s\",",venc->approved_date);
  printf("\"%c\",",venc->agency_approved_b);
  printf("\"%c\",",venc->preferred_vendor_b);
  printf("\"%10.10s\",",venc->last_order_date);
  printf("\"%15.15s\",",venc->list_price);
  printf("\"%10.10s\",",venc->list_price_date);
  printf("\"%10.10s\",",venc->list_price_valid_date);
  printf("\"%3.3s\",",venc->customer_discount);
  printf("\"%15.15s\",",venc->customer_cost);
  printf("\"%4.4s\",",venc->total_deliveries);
  printf("\"%4.4s\",",venc->late_deliveries);
  printf("\"%4.4s\",",venc->vendor_leadtime);
  printf("\"%5.5s\",",venc->turnaround_time);
  printf("\"%2.2s\",",venc->priority);
  printf("\"%15.15s\",",venc->cost);
  printf("\"%5.5s\",",venc->lead_time);
  printf("\"%10.10s\",",venc->agency_approved_date);
  printf("\"%15.15s\",",venc->minimum_order_qty);
  printf("\"%15.15s\",",venc->total_days_late);
  printf("\"%8.8s\"\n",venc->total_leadtime);
}


int main(int argc, char **argv) {
  gold68_venc_api_sort_rcd *venc ;
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

  buf = malloc(sizeof(gold68_venc_api_sort_rcd)+1) ;
  venc = (gold68_venc_api_sort_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(venc)=%d\n",sizeof(gold68_venc_api_sort_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_venc_api_sort_rcd)+1,fp) != NULL) {
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
      printCsv(venc) ;
    } else {
      printRec(cnt,venc) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;

}
