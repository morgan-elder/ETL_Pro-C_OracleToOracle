typedef struct {
	char	sort_cage[20];
	char	start_quote;
	char	part[50];
	char	delimitr01[3];
	char	seq[2];
	char	delimitr02[3];
	char	vendor_part[50];
	char	delimitr03[3];
	char	vendor_code[20];
	char	delimitr04[3];
	char	last_order_price[15];
	char	delimitr04a[3];
	char	vendor_flag;
	char	delimitr05[3];
	char	vendor_model[50];
	char	delimitr06[3];
	char	approved_vendor_b;
	char	delimitr07[3];
	char	approved_date[10];
	char	delimitr08[3];
	char	agency_approved_b;
	char	delimitr09[3];
	char	preferred_vendor_b;
	char	delimitr10[3];
	char	last_order_date[10];
	char	delimitr11[3];
	char	list_price[15];
	char	delimitr12[3];
	char	list_price_date[10];
	char	delimitr13[3];
	char	list_price_valid_date[10];
	char	delimitr14[3];
	char	customer_discount[3];
	char	delimitr15[3];
	char	customer_cost[15];
	char	delimitr16[3];
	char	total_deliveries[4];
	char	delimitr17[3];
	char	late_deliveries[4];
	char	delimitr18[3];
	char	system_calc_leadtime[4];
	char	delimitr19[3];
	char	vendor_leadtime[4];
	char	delimitr20[3];
	char	turnaround_time[5];
	char	delimitr21[3];
	char	priority[2];
	char	delimitr22[3];
	char	cost[15];
	char	delimitr23[3];
	char	lead_time[5];
	char	delimitr24[3];
	char	agency_approved_date;
	char	delimitr25[3];
	char	minimum_order_qty[15];
	char	delimitr26[3];
	char	total_days_late[15];
	char	delimitr27[3];
	char	total_leadtime[8];
	char	end_quote;
	char	eol;
	} gold68_venc_delmtd_rcd;
