/*
VERSION:1.1
HEADER: WAREHOUSE
Gold Shared Table:IFI005008
LDM 	April, 2006	Added ims_designator_code
*/
typedef struct {
	char	customer[20];
	char	part[50];
	char	sc[20];
	char	table_nbr[3];
	char	table_name[30];
	char	update_create_delete;
        char    user_ref1[20];
        char    user_ref2[20];
        char    user_ref3[20];
        char    user_ref4[20];
        char    user_ref5[20];
        char    user_ref6[20];
        char    user_ref7[20];
        char    user_ref8[20];
        char    user_ref9[20];
        char    user_ref10[20];
        char    user_ref11[20];
        char    user_ref12[20];
        char    user_ref13[20];
        char    user_ref14[20];
        char    user_ref15[20];
        char    stock_level[15];
        char    reorder_point[15];
        char    remarks[60];
        char    default_bin[20];
        char    freeze_ordering_b;
        char    freeze_receiving_b;
        char    freeze_iss_disp_b;
        char    freeze_xfer_i_b;
        char    freeze_xfer_o_b;
        char    freeze_other_b;
        char    pi_recommend_b;
        char    auth_allow[15];
        char    c_elin[20];
	char    ims_designator_code[20];
	char	eol;
}gold68_whse_api_FMT_rcd;
