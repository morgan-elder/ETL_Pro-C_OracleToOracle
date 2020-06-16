/*  Function prototype area  */

/* The following functions are defined and used in main program

	*/
static void getCurrentWorkingDirectory(void);
static void    getConfig(struct config_rcd *CONFIG_RCD);
static void showConfig(void);

static int     btchslpf_signon(void);
static void    btchslpf_dberr(void);
static int	   get_btchsp_argmnt(int argc, char **argv,struct cntrl_rcd *CNTRL_RCD);	

/*  The following functions are used in btchsp45 programs  */
static int	initlze_segmnt08_host_var();
static int	initlze_segmnt08(struct prtsc08 *SEGMNT08);

static int	initlze_segmnt05_host_var();
static int	create_f18_05(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);

static int	initlze_segmnt04_host_var();
static int	initlze_segmnt04(struct prtsc04 *SEGMNT04);
static int	create_f18_04(struct cntrl_rcd *CNTRL_RCD, struct prtsc04 *SEGMNT04);


static int	initlze_segmnt03_host_var();
static int	initlze_segmnt03(struct prtsc03 *SEGMNT03);

static int	initlze_segmnt0102(struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	initlze_segmnt0102_host_var();

static int	fetch_f18_pricing_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);

static int	get_customer_model(struct cntrl_rcd *CNTRL_RCD);
static int	gather_f18_proof_data(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int     build_f18_prtsc08_rcd(struct prtsc08 *SEGMNT08, struct cntrl_rcd *CNTRL_RCD);
static int     get_PRTSC01A_f18_ha(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);

static int	write_f18_rcd(char * outData, struct cntrl_rcd *CNTRL_RCD);
static int	create_f18_0102(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);


static int	qualify_f18_proof_candidates(char *filename,struct cntrl_rcd *CNTRL_RCD);
static int	fetch_f18_proof_HA_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	select_f18_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	check_f18_hb_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	fetch_f18_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	check_f18_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	get_f18_hgx_data(struct cntrl_rcd *CNTRL_RCD);
static int	validate_f18_hg_rcd(struct cntrl_rcd *CNTRL_RCD);
static int	validate_f18_lcn(struct cntrl_rcd *CNTRL_RCD);
static int	check_f18_eff_exist(struct cntrl_rcd *CNTRL_RCD);
static int	check_f18_itmcathg(struct cntrl_rcd *CNTRL_RCD);
static int	build_f18_prtsc08_rcd(struct prtsc08 *SEGMNT08,struct cntrl_rcd *CNTRL_RCD);

static int	create_f18_0102_rcd(struct cntrl_rcd CNTRL_RCD, struct prtsc01 SEGMNT01,struct prtsc02 *SEGMNT02);
static int     get_PRTSC01A_f18_ha(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int     get_f18_hax01_data(struct cntrl_rcd *CNTRL_RCD);
static int     get_f18_hax01a_data(struct cntrl_rcd *CNTRL_RCD);
static int	updte_f18_hax_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int     get_PRTSC01A_f18_hb(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int     get_f18_hbx_data(struct cntrl_rcd *CNTRL_RCD);
static int	updte_f18_hbx_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int	get_PRTSC01A_f18_hf(struct cntrl_rcd *CNTRL_RCD);
static int     get_f18_SE_info_ea(struct cntrl_rcd *CNTRL_RCD);
static int	get_f18_arn_info(struct cntrl_rcd *CNTRL_RCD);
static int	determine_f18_se_data(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01);
static int	determine_f18_cat_resp(struct cntrl_rcd *CNTRL_RCD);
static int	build_f18_prtsc0102_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int	write_f18_segmnt02(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);
static int	set_f18_custmr(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);

static int	fetch_f18_eff(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
static int	build_f18_prtsc03_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
static int	create_f18_04_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	get_f18_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	fetch_f18_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	create_f18_05_rcd(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	get_f18_pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
static int	fetch_f18__pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
static int	write_f18_rcd(char *outData,struct cntrl_rcd *CNTRL_RCD);

/*  The following functions are used in btchsp18 programs  */

int	qualify_hrp_proof_candidates(char *filename,struct cntrl_rcd *CNTRL_RCD);
int	fetch_hrp_proof_HA_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
int	select_hrp_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
int	check_hrp_hb_cntrl(struct cntrl_rcd *CNTRL_RCD);
int	fetch_hrp_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
int	check_hrp_cntrl(struct cntrl_rcd *CNTRL_RCD);
int	get_hrp_hgx_data(struct cntrl_rcd *CNTRL_RCD);
int	validate_hrp_hg_rcd(struct cntrl_rcd *CNTRL_RCD);
int	check_hrp_eff_exist(struct cntrl_rcd *CNTRL_RCD);
int	gt_hrp_customer_model(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
int	get_hrp_prf_model(struct cntrl_rcd *CNTRL_RCD);
int	build_hrp_prtsc08_rcd(struct prtsc08 *SEGMNT08,struct cntrl_rcd *CNTRL_RCD);

int	create_hrp_0102_rcd(struct cntrl_rcd CNTRL_RCD, struct prtsc01 SEGMNT01,struct prtsc02 *SEGMNT02);
int     get_PRTSC01A_hrp_ha(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
int     get_hrp_ha01(struct cntrl_rcd *CNTRL_RCD);
int     get_hrp_ha01x(struct cntrl_rcd *CNTRL_RCD);
int	updte_hrp_hax_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
int     get_PRTSC01A_hrp_hb(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
int     get_hrp_hbx_data(struct cntrl_rcd *CNTRL_RCD);
int	updte_hrp_hbx_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
int	get_PRTSC01A_hrp_hf(struct cntrl_rcd *CNTRL_RCD);
int     get_hrp_SE_info_ea(struct cntrl_rcd *CNTRL_RCD);
int	get_hrp_arn_info(struct cntrl_rcd *CNTRL_RCD);
int	determine_hrp_se_data(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01);
int	determine_hrp_cat_resp(struct cntrl_rcd *CNTRL_RCD);
int	build_hrp_prtsc0102_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
int	write_hrp_segmnt02(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);
int	set_hrp_custmr(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);

int	fetch_hrp_eff(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
int	setup_hrp_prtsc03_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
int	build_hrp_prtsc03_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
int	create_hrp_04_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
int	get_hrp_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
int	fetch_hrp_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
int	create_hrp_05_rcd(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
int	get_hrp_pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
int	fetch_hrp__pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
int	write_hrp_rcd(char *outData,struct cntrl_rcd *CNTRL_RCD);

#ifdef _WIN32
static void pause();
#endif
#ifdef __cplusplus
extern "C" {
#endif
	void sqlglm(char   *message_buffer,
		size_t *buffer_size,
		size_t *message_length);
#ifdef __cplusplus
}
#endif
