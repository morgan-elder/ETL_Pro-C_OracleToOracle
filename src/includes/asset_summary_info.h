/*
 * Structs for Asset Summary
 */

/* SLIC Variables */
typedef struct
{
    char lsaconxb[19];
    char altlcnxb[3];
    char flsacnxg[19];
    char refnumha[33];
    char cagecdxh[6];
    char niinsnha[10];
	char itnameha[20];
	char smrcodhg[7];
	char prdldtha[3];
    char scm_program[11];
} slic_vars;


/* Inventory Variables */
typedef struct
{
	long total_wholesale_rfi;
	long total_wholesale_nrfi;
	long total_retail_rfi;
	long total_retail_nrfi;
	long dla_qty;
	long dla_bo_qty;
	long dla_duein_qty;
} inv_vars;

/* Due-In Variables */
typedef struct
{
	char vendor_code_list[50][21];
	char vendor_name_list[50][61];
	long qty_due_list[50];
} due_in_vars;

/* STL Compass Contracts Variables */
typedef struct
{
	long inv_on_hand;
	long inv_frozen;
	long due_in_ord;
	long due_in_rcv;
	long due_in_avail;
	long wip_ord;
	long wip_rcv;
	long wip_avail;
	long dmd_ord;
	long dmd_packed;
	long dmd_shipped;
} imacs_vars;

/* Customer Reqs Variables */
typedef struct
{
	long total_bo;
	long nmcs;
	long pmcs;
} cust_reqs_vars;

/* Supply Position Variables */
typedef struct
{
	char loc_list[50][4];
	long rfi_qty_ary[50];
	long nrfi_qty_ary[50];
	long due_in_qty_ary[50];
	long bo_qty_ary[50];
	long stock_level[50];
	long reorder_point[50];
} sup_pos_vars;

/* Counts */
typedef struct
{
	long loc_cnt;
	long supplier_cnt;
} count_s;
/* Totals */
typedef struct
{
	long total_sup_pos;
	long total_stock_level;
	long total_reorder_point;
	long total_dla_qty;
	long total_dla_duein;
} totals;
