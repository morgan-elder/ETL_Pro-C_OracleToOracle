/*  Function prototype area  */

/* The following functions are defined and used in main program

	*/
static int     btchslpf_signon(void);
static void    btchslpf_dberr(void);
static int	get_btchsp_argmnt(char argc, char **argv,struct cntrl_rcd *CNTRL_RCD);	


/*  The following functions are used in btchspv8 programs  */

static int	qualify_av8b_proof_candidates(char *filename,struct cntrl_rcd *CNTRL_RCD);
static int	fetch_av8b_proof_HA_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	select_av8b_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	check_av8b_hb_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	fetch_av8b_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	get_av8b_hgx_data(struct cntrl_rcd *CNTRL_RCD);
static int	check_av8b_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	validate_av8b_hg_rcd(struct cntrl_rcd *CNTRL_RCD);
static int	check_av8b_eff_exist(struct cntrl_rcd *CNTRL_RCD);
static int	check_av8b_set_custmr_model(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02,struct prtsc03 *SEGMNT03,struct prtsc04 *SEGMNT04,struct prtsc05 *SEGMNT05,struct prtsc08 *SEGMNT08);
static int	build_av8b_prtsc08_rcd(struct prtsc08 *SEGMNT08,struct cntrl_rcd *CNTRL_RCD);
static int     get_av8b_hax01_data(struct cntrl_rcd *CNTRL_RCD);
static int     get_av8b_hax01a_data(struct cntrl_rcd *CNTRL_RCD);

static int	create_av8b_0102(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int     get_PRTSC01A_av8b_ha(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int     get_av8b_ha01(struct cntrl_rcd *CNTRL_RCD);
static int     get_av8b_ha01x(struct cntrl_rcd *CNTRL_RCD);
static int	updte_av8b_hax_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int     get_PRTSC01A_av8b_hb(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int	updte_av8b_hbx_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int	get_PRTSC01A_av8b_hf(struct cntrl_rcd *CNTRL_RCD);
static int     get_av8b_SE_info_ea(struct cntrl_rcd *CNTRL_RCD);
static int	get_av8b_arn_info(struct cntrl_rcd *CNTRL_RCD);
static int	determine_av8b_cat_resp(struct cntrl_rcd *CNTRL_RCD);
static int	build_av8b_prtsc0102_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc01 *SEGMNT01,struct prtsc02 *SEGMNT02);
static int	write_av8b_segmnt02(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);
static int	set_av8b_custmr(struct cntrl_rcd *CNTRL_RCD,struct prtsc02 *SEGMNT02);

static int	fetch_av8b_eff(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
static int	build_av8b_prtsc03_rcd(struct cntrl_rcd *CNTRL_RCD,struct prtsc03 *SEGMNT03);
static int	create_av8b_04(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	get_av8b_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	fetch_av8b_supsdure_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc04 *SEGMNT04);
static int	create_av8b_05_rcd(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	create_av8b_05(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	get_av8b_pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
static int	fetch_av8b__pricing_info(struct cntrl_rcd *CNTRL_RCD,struct prtsc05 *SEGMNT05);
static int	write_av8b_rcd(char *outData,struct cntrl_rcd *CNTRL_RCD);

static int	fetch_av8b_pricing_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	gather_av8b_proof_data(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int	initlze_AV8_segmnt0102(struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	initlze_segmnt0102(struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	initlze_segmnt0102_host_var();
static int	initlze_segmnt03(struct prtsc03 *SEGMNT03);
static int	initlze_segmnt03_host_var();
static int	initlze_segmnt04(struct prtsc04 *SEGMNT04);
static int	initlze_segmnt04_host_var();
static int	initlze_segmnt05(struct prtsc05 *SEGMNT05);
static int	initlze_segmnt05_host_var();
static int	initlze_segmnt08(struct prtsc08 *SEGMNT08);
static int	initlze_segmnt08_host_var();
#ifdef __cplusplus
extern "C" {
#endif
	void sqlglm(char   *message_buffer,
		size_t *buffer_size,
		size_t *message_length);
#ifdef __cplusplus
}
#endif

#ifdef _WIN32
static void my_pause();
#endif

/*
	Errcodes
*/
