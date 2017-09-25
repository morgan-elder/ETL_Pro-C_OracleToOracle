#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gold685_cat1_api.h"
static void printHeader() {
  printf("customer,");
  printf("part,");
  printf("table_nbr,");
  printf("table_name,");
  printf("update_create_delete,");
  printf("nsn,");
  printf("noun,");
  printf("nsn_smic,");
  printf("prime,");
  printf("noun_mod_1,");
  printf("noun_mod_2,");
  printf("smrc,");
  printf("errc,");
  printf("um_show_code,");
  printf("um_issue_code,");
  printf("um_issue_show_count,");
  printf("um_issue_code_count,");
  printf("um_issue_factor,");
  printf("um_cap_code,");
  printf("um_cap_show_count,");
  printf("um_cap_code_count,");
  printf("um_cap_factor,");
  printf("um_mil_code,");
  printf("um_mil_show_count,");
  printf("um_mil_code_count,");
  printf("um_mil_factor,");
  printf("category_instrument,");
  printf("security_code,");
  printf("source_code,");
  printf("order_cap_b,");
  printf("order_gfp_b,");
  printf("exp_warranty_code,");
  printf("buyer,");
  printf("cognizance_code,");
  printf("abbr_part,");
  printf("user_ref1,");
  printf("user_ref2,");
  printf("user_ref3,");
  printf("user_ref4,");
  printf("user_ref5,");
  printf("user_ref6,");
  printf("ship_reps_code,");
  printf("ship_reps_priority,");
  printf("delete_when_gone,");
  printf("asset_req_on_recipt,");
  printf("tracked_b,");
  printf("dodic,");
  printf("part_make_b,");
  printf("part_buy_b,");
  printf("remarks,");
  printf("ims_designator_code,");
  printf("demilitarization_code,");
  printf("hazardous_material_code,");
  printf("pmi_code,");
  printf("critical_item_code,");
  printf("inv_class_code,");
  printf("ata_chapter_no,");
  printf("hazardous_material_b,");
  printf("lot_batch_mandatory_b,");
  printf("serial_mandatory_b,");
  printf("tec,");
  printf("wip_type,");
  printf("manuf_cage,");
  printf("budget_code,");
  printf("isgp_group_no,");
  printf("user_ref7,");
  printf("user_ref8,");
  printf("user_ref9,");
  printf("user_ref10,");
  printf("user_ref11,");
  printf("user_ref12,");
  printf("user_ref13,");
  printf("user_ref14,");
  printf("user_ref15,");
  printf("agency_peculiar_b,");
  printf("es_designator_code,");
  printf("cat1_profile,");
  printf("mils_auto_process_b,");	
  printf("ave_cap_lead_time,");
  printf("ave_mil_lead_time,");
  printf("int_error_code\n");
}

static void printCsv(gold68_cat1_api_rcd *cat1) {
  printf("\"%20.20s\",", cat1->customer);
  printf("\"%50.50s\",", cat1->part);
  printf("\"%3.3s\",", cat1->table_nbr);
  printf("\"%30.30s\",", cat1->table_name);
  printf("\"%c\",", cat1->update_create_delete);
  printf("\"%16.16s\",", cat1->nsn);
  printf("\"%40.40s\",", cat1->noun);
  printf("\"%2.2s\",", cat1->nsn_smic);
  printf("\"%50.50s\",", cat1->prime);
  printf("\"%40.40s\",", cat1->noun_mod_1);
  printf("\"%40.40s\",", cat1->noun_mod_2);
  printf("\"%6.6s\",", cat1->smrc);
  printf("\"%3.3s\",", cat1->errc);
  printf("\"%3.3s\",", cat1->um_show_code);
  printf("\"%3.3s\",", cat1->um_issue_code);
  printf("\"%4.4s\",", cat1->um_issue_show_count);
  printf("\"%4.4s\",", cat1->um_issue_code_count);
  printf("\"%10.10s\",", cat1->um_issue_factor);
  printf("\"%3.3s\",", cat1->um_cap_code);
  printf("\"%4.4s\",", cat1->um_cap_show_count);
  printf("\"%4.4s\",", cat1->um_cap_code_count);
  printf("\"%10.10s\",", cat1->um_cap_factor);
  printf("\"%3.3s\",", cat1->um_mil_code);
  printf("\"%4.4s\",", cat1->um_mil_show_count);
  printf("\"%4.4s\",", cat1->um_mil_code_count);
  printf("\"%10.10s\",", cat1->um_mil_factor);
  printf("\"%12.12s\",", cat1->category_instrument);
  printf("\"%c\",", cat1->security_code);
  printf("\"%3.3s\",", cat1->source_code);
  printf("\"%c\",", cat1->order_cap_b);
  printf("\"%c\",", cat1->order_gfp_b);
  printf("\"%8.8s\",", cat1->exp_warranty_code);
  printf("\"%20.20s\",", cat1->buyer);
  printf("\"%2.2s\",", cat1->cognizance_code);
  printf("\"%15.15s\",", cat1->abbr_part);
  printf("\"%20.20s\",", cat1->user_ref1);
  printf("\"%20.20s\",", cat1->user_ref2);
  printf("\"%20.20s\",", cat1->user_ref3);
  printf("\"%20.20s\",", cat1->user_ref4);
  printf("\"%20.20s\",", cat1->user_ref5);
  printf("\"%20.20s\",", cat1->user_ref6);
  printf("\"%20.20s\",", cat1->ship_reps_code);
  printf("\"%2.2s\",", cat1->ship_reps_priority);
  printf("\"%c\",", cat1->delete_when_gone);
  printf("\"%c\",", cat1->asset_req_on_recipt);
  printf("\"%c\",", cat1->tracked_b);
  printf("\"%20.20s\",", cat1->dodic);
  printf("\"%c\",", cat1->part_make_b);
  printf("\"%c\",", cat1->part_buy_b);
  printf("\"%60.60s\",", cat1->remarks);
  printf("\"%20.20s\",", cat1->ims_designator_code);
  printf("\"%20.20s\",", cat1->demilitarization_code);
  printf("\"%20.20s\",", cat1->hazardous_material_code);
  printf("\"%20.20s\",", cat1->pmi_code);
  printf("\"%20.20s\",", cat1->critical_item_code);
  printf("\"%10.10s\",", cat1->inv_class_code);
  printf("\"%6.6s\",", cat1->ata_chapter_no);
  printf("\"%c\",", cat1->hazardous_material_b);
  printf("\"%c\",", cat1->lot_batch_mandatory_b);
  printf("\"%c\",", cat1->serial_mandatory_b);
  printf("\"%10.10s\",", cat1->tec);
  printf("\"%20.20s\",", cat1->wip_type);
  printf("\"%5.5s\",", cat1->manuf_cage);
  printf("\"%c\",", cat1->budget_code);
  printf("\"%20.20s\",", cat1->isgp_group_no);
  printf("\"%20.20s\",", cat1->user_ref7);
  printf("\"%20.20s\",", cat1->user_ref8);
  printf("\"%20.20s\",", cat1->user_ref9);
  printf("\"%20.20s\",", cat1->user_ref10);
  printf("\"%20.20s\",", cat1->user_ref11);
  printf("\"%20.20s\",", cat1->user_ref12);
  printf("\"%20.20s\",", cat1->user_ref13);
  printf("\"%20.20s\",", cat1->user_ref14);
  printf("\"%20.20s\",", cat1->user_ref15);
  printf("\"%c\",", cat1->agency_peculiar_b);
  printf("\"%20.20s\",", cat1->es_designator_code);
  printf("\"%20.20s\",", cat1->cat1_profile);
  printf("\"%c\",", cat1->mils_auto_process_b);	
  printf("\"%5.5s\",", cat1->ave_cap_lead_time);
  printf("\"%8.8s\",", cat1->ave_mil_lead_time);
  printf("\"%1.1s\"\n", cat1->int_error_code);
}

static void printRec(int cnt,gold68_cat1_api_rcd *cat1) {
  printf("%35.35s= \t%.s\n","customer",cat1->customer);
  printf("%35.35s= \t%.s\n","part",cat1->part);
  printf("%35.35s= \t%.s\n","table_nbr",cat1->table_nbr);
  printf("%35.35s= \t%.s\n","table_name",cat1->table_name);
  printf("%35.35s= \t%c\n","update_create_delete",cat1->update_create_delete);
  printf("%35.35s= \t%.s\n","nsn",cat1->nsn);
  printf("%35.35s= \t%.s\n","noun",cat1->noun);
  printf("%35.35s= \t%.s\n","nsn_smic",cat1->nsn_smic);
  printf("%35.35s= \t%.s\n","prime",cat1->prime);
  printf("%35.35s= \t%.s\n","noun_mod_1",cat1->noun_mod_1);
  printf("%35.35s= \t%.s\n","noun_mod_2",cat1->noun_mod_2);
  printf("%35.35s= \t%.s\n","smrc",cat1->smrc);
  printf("%35.35s= \t%.s\n","errc",cat1->errc);
  printf("%35.35s= \t%.s\n","um_show_code",cat1->um_show_code);
  printf("%35.35s= \t%.s\n","um_issue_code",cat1->um_issue_code);
  printf("%35.35s= \t%.s\n","um_issue_show_count",cat1->um_issue_show_count);
  printf("%35.35s= \t%.s\n","um_issue_code_count",cat1->um_issue_code_count);
  printf("%35.35s= \t%.s\n","um_issue_factor",cat1->um_issue_factor);
  printf("%35.35s= \t%.s\n","um_cap_code",cat1->um_cap_code);
  printf("%35.35s= \t%.s\n","um_cap_show_count",cat1->um_cap_show_count);
  printf("%35.35s= \t%.s\n","um_cap_code_count",cat1->um_cap_code_count);
  printf("%35.35s= \t%.s\n","um_cap_factor",cat1->um_cap_factor);
  printf("%35.35s= \t%.s\n","um_mil_code",cat1->um_mil_code);
  printf("%35.35s= \t%.s\n","um_mil_show_count",cat1->um_mil_show_count);
  printf("%35.35s= \t%.s\n","um_mil_code_count",cat1->um_mil_code_count);
  printf("%35.35s= \t%.s\n","um_mil_factor",cat1->um_mil_factor);
  printf("%35.35s= \t%.s\n","category_instrument",cat1->category_instrument);
  printf("%35.35s= \t%c\n","security_code",cat1->security_code);
  printf("%35.35s= \t%.s\n","source_code",cat1->source_code);
  printf("%35.35s= \t%c\n","order_cap_b",cat1->order_cap_b);
  printf("%35.35s= \t%c\n","order_gfp_b",cat1->order_gfp_b);
  printf("%35.35s= \t%.s\n","exp_warranty_code",cat1->exp_warranty_code);
  printf("%35.35s= \t%.s\n","buyer",cat1->buyer);
  printf("%35.35s= \t%.s\n","cognizance_code",cat1->cognizance_code);
  printf("%35.35s= \t%.s\n","abbr_part",cat1->abbr_part);
  printf("%35.35s= \t%.s\n","user_ref1",cat1->user_ref1);
  printf("%35.35s= \t%.s\n","user_ref2",cat1->user_ref2);
  printf("%35.35s= \t%.s\n","user_ref3",cat1->user_ref3);
  printf("%35.35s= \t%.s\n","user_ref4",cat1->user_ref4);
  printf("%35.35s= \t%.s\n","user_ref5",cat1->user_ref5);
  printf("%35.35s= \t%.s\n","user_ref6",cat1->user_ref6);
  printf("%35.35s= \t%.s\n","ship_reps_code",cat1->ship_reps_code);
  printf("%35.35s= \t%.s\n","ship_reps_priority",cat1->ship_reps_priority);
  printf("%35.35s= \t%c\n","delete_when_gone",cat1->delete_when_gone);
  printf("%35.35s= \t%c\n","asset_req_on_recipt",cat1->asset_req_on_recipt);
  printf("%35.35s= \t%c\n","tracked_b",cat1->tracked_b);
  printf("%35.35s= \t%.s\n","dodic",cat1->dodic);
  printf("%35.35s= \t%c\n","part_make_b",cat1->part_make_b);
  printf("%35.35s= \t%c\n","part_buy_b",cat1->part_buy_b);
  printf("%35.35s= \t%.s\n","remarks",cat1->remarks);
  printf("%35.35s= \t%.s\n","ims_designator_code",cat1->ims_designator_code);
  printf("%35.35s= \t%.s\n","demilitarization_code",cat1->demilitarization_code);
  printf("%35.35s= \t%.s\n","hazardous_material_code",cat1->hazardous_material_code);
  printf("%35.35s= \t%.s\n","pmi_code",cat1->pmi_code);
  printf("%35.35s= \t%.s\n","critical_item_code",cat1->critical_item_code);
  printf("%35.35s= \t%.s\n","inv_class_code",cat1->inv_class_code);
  printf("%35.35s= \t%.s\n","ata_chapter_no",cat1->ata_chapter_no);
  printf("%35.35s= \t%c\n","hazardous_material_b",cat1->hazardous_material_b);
  printf("%35.35s= \t%c\n","lot_batch_mandatory_b",cat1->lot_batch_mandatory_b);
  printf("%35.35s= \t%c\n","serial_mandatory_b",cat1->serial_mandatory_b);
  printf("%35.35s= \t%.s\n","tec",cat1->tec);
  printf("%35.35s= \t%.s\n","wip_type",cat1->wip_type);
  printf("%35.35s= \t%.s\n","manuf_cage",cat1->manuf_cage);
  printf("%35.35s= \t%c\n","budget_code",cat1->budget_code);
  printf("%35.35s= \t%.s\n","isgp_group_no",cat1->isgp_group_no);
  printf("%35.35s= \t%.s\n","user_ref7",cat1->user_ref7);
  printf("%35.35s= \t%.s\n","user_ref8",cat1->user_ref8);
  printf("%35.35s= \t%.s\n","user_ref9",cat1->user_ref9);
  printf("%35.35s= \t%.s\n","user_ref10",cat1->user_ref10);
  printf("%35.35s= \t%.s\n","user_ref11",cat1->user_ref11);
  printf("%35.35s= \t%.s\n","user_ref12",cat1->user_ref12);
  printf("%35.35s= \t%.s\n","user_ref13",cat1->user_ref13);
  printf("%35.35s= \t%.s\n","user_ref14",cat1->user_ref14);
  printf("%35.35s= \t%.s\n","user_ref15",cat1->user_ref15);
  printf("%35.35s= \t%c\n","agency_peculiar_b",cat1->agency_peculiar_b);
  printf("%35.35s= \t%.s\n","es_designator_code",cat1->es_designator_code);
  printf("%35.35s= \t%.s\n","cat1_profile",cat1->cat1_profile);
  printf("%35.35s= \t%c\n","mils_auto_process_b",cat1->mils_auto_process_b);	
  printf("%35.35s= \t%.s\n","ave_cap_lead_time",cat1->ave_cap_lead_time);
  printf("%35.35s= \t%.s\n","ave_mil_lead_time",cat1->ave_mil_lead_time);
  printf("%35.35s= \t%c\n","int_error_code",cat1->int_error_code);
}

static void printRec2(int cnt,gold68_cat1_api_rcd *cat1) {
  printf("record %d. ********************************\n",cnt) ;
	printf("customer=\t\t\t(%20.20s)\n", cat1->customer);
	printf("part=\t\t\t(%50.50s)\n", cat1->part);
	printf("table_nbr=\t\t\t(%3.3s)\n", cat1->table_nbr);
	printf("table_name=\t\t\t(%30.30s)\n", cat1->table_name);
	printf("update_create_delete=\t\t\t(%c)\n", cat1->update_create_delete);
	printf("nsn=\t\t\t(%16.16s)\n", cat1->nsn);
	printf("noun=\t\t\t(%40.40s)\n", cat1->noun);
	printf("nsn_smic=\t\t\t(%2.2s)\n", cat1->nsn_smic);
	printf("prime=\t\t\t(%50.50s)\n", cat1->prime);
	printf("noun_mod_1=\t\t\t(%40.40s)\n", cat1->noun_mod_1);
	printf("noun_mod_2=\t\t\t(%40.40s)\n", cat1->noun_mod_2);
	printf("smrc=\t\t\t(%6.6s)\n", cat1->smrc);
	printf("errc=\t\t\t(%3.3s)\n", cat1->errc);
	printf("um_show_code=\t\t\t(%3.3s)\n", cat1->um_show_code);
	printf("um_issue_code=\t\t\t(%3.3s)\n", cat1->um_issue_code);
	printf("um_issue_show_count=\t\t\t(%4.4s)\n", cat1->um_issue_show_count);
	printf("um_issue_code_count=\t\t\t(%4.4s)\n", cat1->um_issue_code_count);
	printf("um_issue_factor=\t\t\t(%10.10s)\n", cat1->um_issue_factor);
	printf("um_cap_code=\t\t\t(%3.3s)\n", cat1->um_cap_code);
	printf("um_cap_show_count=\t\t\t(%4.4s)\n", cat1->um_cap_show_count);
	printf("um_cap_code_count=\t\t\t(%4.4s)\n", cat1->um_cap_code_count);
	printf("um_cap_factor=\t\t\t(%10.10s)\n", cat1->um_cap_factor);
	printf("um_mil_code=\t\t\t(%3.3s)\n", cat1->um_mil_code);
	printf("um_mil_show_count=\t\t\t(%4.4s)\n", cat1->um_mil_show_count);
	printf("um_mil_code_count=\t\t\t(%4.4s)\n", cat1->um_mil_code_count);
	printf("um_mil_factor=\t\t\t(%10.10s)\n", cat1->um_mil_factor);
	printf("category_instrument=\t\t\t(%12.12s)\n", cat1->category_instrument);
	printf("security_code=\t\t\t(%c)\n", cat1->security_code);
	printf("source_code=\t\t\t(%3.3s)\n", cat1->source_code);
	printf("order_cap_b=\t\t\t(%c)\n", cat1->order_cap_b);
	printf("order_gfp_b=\t\t\t(%c)\n", cat1->order_gfp_b);
	printf("exp_warranty_code=\t\t\t(%8.8s)\n", cat1->exp_warranty_code);
	printf("buyer=\t\t\t(%20.20s)\n", cat1->buyer);
	printf("cognizance_code=\t\t\t(%2.2s)\n", cat1->cognizance_code);
	printf("abbr_part=\t\t\t(%15.15s)\n", cat1->abbr_part);
	printf("user_ref1=\t\t\t(%20.20s)\n", cat1->user_ref1);
	printf("user_ref2=\t\t\t(%20.20s)\n", cat1->user_ref2);
	printf("user_ref3=\t\t\t(%20.20s)\n", cat1->user_ref3);
	printf("user_ref4=\t\t\t(%20.20s)\n", cat1->user_ref4);
	printf("user_ref5=\t\t\t(%20.20s)\n", cat1->user_ref5);
	printf("user_ref6=\t\t\t(%20.20s)\n", cat1->user_ref6);
	printf("ship_reps_code=\t\t\t(%20.20s)\n", cat1->ship_reps_code);
	printf("ship_reps_priority=\t\t\t(%2.2s)\n", cat1->ship_reps_priority);
	printf("delete_when_gone=\t\t\t(%c)\n", cat1->delete_when_gone);
	printf("asset_req_on_recipt=\t\t\t(%c)\n", cat1->asset_req_on_recipt);
	printf("tracked_b=\t\t\t(%c)\n", cat1->tracked_b);
	printf("dodic=\t\t\t(%20.20s)\n", cat1->dodic);
	printf("part_make_b=\t\t\t(%c)\n", cat1->part_make_b);
	printf("part_buy_b=\t\t\t(%c)\n", cat1->part_buy_b);
	printf("remarks=\t\t\t(%60.60s)\n", cat1->remarks);
	printf("ims_designator_code=\t\t\t(%20.20s)\n", cat1->ims_designator_code);
	printf("demilitarization_code=\t\t\t(%20.20s)\n", cat1->demilitarization_code);
	printf("hazardous_material_code=\t\t\t(%20.20s)\n", cat1->hazardous_material_code);
	printf("pmi_code=\t\t\t(%20.20s)\n", cat1->pmi_code);
	printf("critical_item_code=\t\t\t(%20.20s)\n", cat1->critical_item_code);
	printf("inv_class_code=\t\t\t(%10.10s)\n", cat1->inv_class_code);
	printf("ata_chapter_no=\t\t\t(%6.6s)\n", cat1->ata_chapter_no);
	printf("hazardous_material_b=\t\t\t(%c)\n", cat1->hazardous_material_b);
	printf("lot_batch_mandatory_b=\t\t\t(%c)\n", cat1->lot_batch_mandatory_b);
	printf("serial_mandatory_b=\t\t\t(%c)\n", cat1->serial_mandatory_b);
	printf("tec=\t\t\t(%10.10s)\n", cat1->tec);
	printf("wip_type=\t\t\t(%20.20s)\n", cat1->wip_type);
	printf("manuf_cage=\t\t\t(%5.5s)\n", cat1->manuf_cage);
	printf("budget_code=\t\t\t(%c)\n", cat1->budget_code);
	printf("isgp_group_no=\t\t\t(%20.20s)\n", cat1->isgp_group_no);
	printf("user_ref7=\t\t\t(%20.20s)\n", cat1->user_ref7);
	printf("user_ref8=\t\t\t(%20.20s)\n", cat1->user_ref8);
	printf("user_ref9=\t\t\t(%20.20s)\n", cat1->user_ref9);
	printf("user_ref10=\t\t\t(%20.20s)\n", cat1->user_ref10);
	printf("user_ref11=\t\t\t(%20.20s)\n", cat1->user_ref11);
	printf("user_ref12=\t\t\t(%20.20s)\n", cat1->user_ref12);
	printf("user_ref13=\t\t\t(%20.20s)\n", cat1->user_ref13);
	printf("user_ref14=\t\t\t(%20.20s)\n", cat1->user_ref14);
	printf("user_ref15=\t\t\t(%20.20s)\n", cat1->user_ref15);
	printf("agency_peculiar_b=\t\t\t(%c)\n", cat1->agency_peculiar_b);
	printf("es_designator_code=\t\t\t(%20.20s)\n", cat1->es_designator_code);
	printf("cat1_profile=\t\t\t(%20.20s)\n", cat1->cat1_profile);
	printf("mils_auto_process_b=\t\t\t(%c)\n", cat1->mils_auto_process_b);
	printf("ave_cap_lead_time=\t\t\t(%5.5s)\n", cat1->ave_cap_lead_time);
	printf("ave_mil_lead_time=\t\t\t(%8.8s)\n", cat1->ave_mil_lead_time);
	printf("int_error_code=\t\t\t(%1.1s)\n", cat1->int_error_code);
	printf("eol=\t\t\t(%c)\n", cat1->eol);
  printf("********************************\n\n") ;
}

int main(int argc, char **argv) {
  gold68_cat1_api_rcd *cat1 ;
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
  buf = malloc(sizeof(gold68_cat1_api_rcd)+1) ;
  cat1 = (gold68_cat1_api_rcd *) buf ;

  #if DEBUG
    fprintf(stderr,"sizeof(cat1)=%d\n",sizeof(gold68_cat1_api_rcd)) ;
  #endif

  while (fgets(buf,sizeof(gold68_cat1_api_rcd)+1,fp) != NULL) {
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
      printCsv(cat1) ;
    } else {
      printRec(cnt,cat1) ;
    }
  }
  fprintf(stderr,"%d records found in %s\n",cnt,argv[1]) ;
}
