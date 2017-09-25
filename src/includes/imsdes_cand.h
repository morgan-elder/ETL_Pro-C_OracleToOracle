/*
VERSION: 1.0
HEADER: CATALOG
*/
typedef	struct {
	char	refnumha[32];
	char    cagecdxh[5];
	char	part[50];
	char	manuf_cage[5];
	char	nsn[16];
	char	ims_designator_code[20];
	char	scm_program[10];
	char	eiacodxa[10];
	char	lsaconxb[18];
	char	lcntypxb[1];
	char	flsacnxg[18];
	char	falcncxg[2];
	char	suplyrcd[5];
	char	itmcathg[2];
	char    altlcnxb[2];
	char	pccnumxc[6];
	char	rsrefno[32];
	char	rsrefno_imsdes_code[20];
	char	eol;
	} imsdes_cand_rcd;
