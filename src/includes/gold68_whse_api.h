typedef struct {
	char	part[50];
	char	sc[20];
	char	prime[50];
	char	user_ref1[20];
	char	user_ref2[20];
	char	user_ref3[20];
	char	user_ref4[20];
	char	user_ref5[20];
	char	user_ref6[20];
	char	user_ref7[20];
	char	user_ref8[20];
	char	user_ref9[20];
	char	user_ref10[20];
	char	user_ref11[20];
	char	user_ref12[20];
	char	user_ref13[20];
	char	user_ref14[20];
	char	user_ref15[20];
	char	stock_level[15];
	char	reorder_point[15];
	char	price_cap[15];
	char	price_gfp[15];
	char	price_actual[15];
	char	price_ave[15];
	char	price_last_receipt[15];
	char	last_physical_qty[15];
	char	last_physical_date[10];
	char	created_datetime[10];
	char	created_userid[20];
	char	last_changed_datetime[10];
	char	last_changed_userid[20];
	char	price_changed_datetime[10];
	char	price_changed_userid[20];
	char	date_last_issue[10];
	char	date_last_activity[10];
	char	mur[15];
	char	mur_start_date[10];
	char	mur_end_date[10];
	char	mdr[15];
	char	mdr_start_date[10];
	char	mdr_end_date[10];
	char	remarks	[60];
	char	default_bin[20];
	char	archive_yn;
	char	last_archive_datetime[10];
	char	govg_1662_type[2];
	char	govg_price[15];
	char	govg_qty[15];
	char	govc_1662_type[2];
	char	govc_price[15];
	char	govc_qty[15];
	char	usage_mrl_percent[15];
	char	freeze_codes[20];
	char	record_changed1_yn;
	char	record_changed2_yn;
	char	record_changed3_yn;
	char	record_changed4_yn;
	char	record_changed5_yn;
	char	record_changed6_yn;
	char	record_changed7_yn;
	char	record_changed8_yn;
	char	auth_allow[15];
	char	best_estimate_qty[15];
	char	qty_per_assembly[15];
	char	last_acquisition_price[15];
	char	stock_level_floor[15];
	char	stock_level_ceiling[15];
	char	stock_level_additive[15];
	char	last_level_userid[20];
	char	last_level_method[20];
	char	last_level_datetime[10];
	char	computed_ord_qty[10];
	char	computed_exc_oh_qty[10];
	char	computed_exc_di_qty[10];
	char	min_ord_qty[10];
	char	c_elin	[20];
	char	eol;
}gold68_whse_api_rcd;
