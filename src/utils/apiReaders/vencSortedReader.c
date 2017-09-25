#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "gold685_venc_api_sort_cntrl.h"
static void printHeader() {
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

static void printCsv(gold68_venc_api_sort_rcd *vencSorted) {
  printf("\"%20.20s\",",vencSorted->sort_cage);
  printf("\"%20.20s\",",vencSorted->customer);
  printf("\"%50.50s\",",vencSorted->part);
  printf("\"%3.3s\",",vencSorted->table_nbr);
  printf("\"%30.30s\",",vencSorted->table_name);
  printf("\"%c\",",vencSorted->update_create_delete);
  printf("\"%50.50s\",",vencSorted->vendor_part);
  printf("\"%20.20s\",",vencSorted->vendor_code);
  printf("\"%60.60s\",",vencSorted->vendor_name);
  printf("\"%15.15s\",",vencSorted->last_order_price);
  printf("\"%20.20s\",",vencSorted->vendor_flag);
  printf("\"%50.50s\",",vencSorted->vendor_model);
  printf("\"%c\",",vencSorted->approved_vendor_b);
  printf("\"%10.10s\",",vencSorted->approved_date);
  printf("\"%c\",",vencSorted->agency_approved_b);
  printf("\"%c\",",vencSorted->preferred_vendor_b);
  printf("\"%10.10s\",",vencSorted->last_order_date);
  printf("\"%15.15s\",",vencSorted->list_price);
  printf("\"%10.10s\",",vencSorted->list_price_date);
  printf("\"%10.10s\",",vencSorted->list_price_valid_date);
  printf("\"%3.3s\",",vencSorted->customer_discount);
  printf("\"%15.15s\",",vencSorted->customer_cost);
  printf("\"%4.4s\",",vencSorted->total_deliveries);
  printf("\"%4.4s\",",vencSorted->late_deliveries);
  printf("\"%4.4s\",",vencSorted->vendor_leadtime);
  printf("\"%5.5s\",",vencSorted->turnaround_time);
  printf("\"%2.2s\",",vencSorted->priority);
  printf("\"%15.15s\",",vencSorted->cost);
  printf("\"%5.5s\",",vencSorted->lead_time);
  printf("\"%10.10s\",",vencSorted->agency_approved_date);
  printf("\"%15.15s\",",vencSorted->minimum_order_qty);
  printf("\"%15.15s\",",vencSorted->total_days_late);
  printf("\"%8.8s\"\n",vencSorted->total_leadtime);
}

static void printRec(int cnt,gold68_venc_api_sort_rcd *vencSorted) {
  printf("record %d. ********************************\n",cnt) ;
  printf("%35.35s= 	%20.20s\n","sort_cage",vencSorted->sort_cage);
  printf("%35.35s= 	%20.20s\n","customer",vencSorted->customer);
  printf("%35.35s= 	%50.50s\n","part",vencSorted->part);
  printf("%35.35s= 	%3.3s\n","table_nbr",vencSorted->table_nbr);
  printf("%35.35s= 	%30.30s\n","table_name",vencSorted->table_name);
  printf("%35.35s= 	%c\n","update_create_delete",vencSorted->update_create_delete);
  printf("%35.35s= 	%50.50s\n","vendor_part",vencSorted->vendor_part);
  printf("%35.35s= 	%20.20s\n","vendor_code",vencSorted->vendor_code);
  printf("%35.35s= 	%60.60s\n","vendor_name",vencSorted->vendor_name);
  printf("%35.35s= 	%15.15s\n","last_order_price",vencSorted->last_order_price);
  printf("%35.35s= 	%20.20s\n","vendor_flag",vencSorted->vendor_flag);
  printf("%35.35s= 	%50.50s\n","vendor_model",vencSorted->vendor_model);
  printf("%35.35s= 	%c\n","approved_vendor_b",vencSorted->approved_vendor_b);
  printf("%35.35s= 	%10.10s\n","approved_date",vencSorted->approved_date);
  printf("%35.35s= 	%c\n","agency_approved_b",vencSorted->agency_approved_b);
  printf("%35.35s= 	%c\n","preferred_vendor_b",vencSorted->preferred_vendor_b);
  printf("%35.35s= 	%10.10s\n","last_order_date",vencSorted->last_order_date);
  printf("%35.35s= 	%15.15s\n","list_price",vencSorted->list_price);
  printf("%35.35s= 	%10.10s\n","list_price_date",vencSorted->list_price_date);
  printf("%35.35s= 	%10.10s\n","list_price_valid_date",vencSorted->list_price_valid_date);
  printf("%35.35s= 	%3.3s\n","customer_discount",vencSorted->customer_discount);
  printf("%35.35s= 	%15.15s\n","customer_cost",vencSorted->customer_cost);
  printf("%35.35s= 	%4.4s\n","total_deliveries",vencSorted->total_deliveries);
  printf("%35.35s= 	%4.4s\n","late_deliveries",vencSorted->late_deliveries);
  printf("%35.35s= 	%4.4s\n","vendor_leadtime",vencSorted->vendor_leadtime);
  printf("%35.35s= 	%5.5s\n","turnaround_time",vencSorted->turnaround_time);
  printf("%35.35s= 	%2.2s\n","priority",vencSorted->priority);
  printf("%35.35s= 	%15.15s\n","cost",vencSorted->cost);
  printf("%35.35s= 	%5.5s\n","lead_time",vencSorted->lead_time);
  printf("%35.35s= 	%10.10s\n","agency_approved_date",vencSorted->agency_approved_date);
  printf("%35.35s= 	%15.15s\n","minimum_order_qty",vencSorted->minimum_order_qty);
  printf("%35.35s= 	%15.15s\n","total_days_late",vencSorted->total_days_late);
  printf("%35.35s= 	%8.8s\n","total_leadtime",vencSorted->total_leadtime);
  printf("********************************\n\n") ;
}

int main(int argc, char **argv) {
  gold68_venc_api_sort_rcd *vencSorted ;
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
  vencSorted = (gold68_venc_api_sort_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(venc)=%d\n",sizeof(gold68_venc_api_sort_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_venc_api_sort_rcd)+1,fp) != NULL) {
    if (!(strlen(buf) == sizeof(gold68_venc_api_sort_rcd)))  {
      printf("buf=%s strlen(buf)=%d sizeof(gold68_venc_api_sort_rcd)=%d cnt=%d\n",buf, strlen(buf), sizeof(gold68_venc_api_sort_rcd), cnt) ;
    }
    assert(strlen(buf) == sizeof(gold68_venc_api_sort_rcd))  ;
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
      printCsv(vencSorted) ;
    } else {
      printRec(cnt,vencSorted) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;
}
