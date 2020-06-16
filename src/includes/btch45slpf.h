/*  Function prototype area  */
static int	get_btchsp_argmnt(int argc, char* argv[], struct cntrl_rcd *CNTRL_RCD);
static int	btchslpf_signon(void);
static void	btchslpf_dberr();
static int	qualify_t45_proof_candidates(char *filename, struct cntrl_rcd *CNTRL_RCD);
static int  fetch_t45_proof_HA_candidates(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int  select_t45_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int  fetch_t45_proof_HB_candidates(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int  build_t45_prtsc08_rcd(struct prtsc08 *SEGMNT08, struct cntrl_rcd *CNTRL_RCD);
static int  get_PRTSC01A_t45_ha(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int  get_t45_hax01_data(struct cntrl_rcd *CNTRL_RCD);
static int  get_t45_hax01a_data(struct cntrl_rcd *CNTRL_RCD);
static int  get_PRTSC01A_t45_hb(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int  get_t45_hbx_data(struct cntrl_rcd *CNTRL_RCD);
static int  get_t45_SE_info_ea(struct cntrl_rcd *CNTRL_RCD);
static int  fetch_t45_eff(struct cntrl_rcd *CNTRL_RCD, struct prtsc03 *SEGMNT03);
static int  build_t45_prtsc03_rcd(struct cntrl_rcd *CNTRL_RCD, struct prtsc03 *SEGMNT03);
static int	check_t45_hb_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	check_t45_cntrl(struct cntrl_rcd *CNTRL_RCD);
static int	validate_t45_hg_rcd(struct cntrl_rcd *CNTRL_RCD);
static int	check_t45_eff_exist(struct cntrl_rcd *CNTRL_RCD);
static int	check_t45_itmcathg(struct cntrl_rcd *CNTRL_RCD);
static int	gather_t45_proof_data(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02, struct prtsc03 *SEGMNT03, struct prtsc04 *SEGMNT04, struct prtsc05 *SEGMNT05, struct prtsc08 *SEGMNT08);
static int	write_t45_rcd(char *outData, struct cntrl_rcd *CNTRL_RCD);
static int	create_t45_0102(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	updte_t45_hax_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int	updte_t45_hbx_xfer_flag(struct cntrl_rcd *CNTRL_RCD);
static int	get_PRTSC01A_t45_hf(struct cntrl_rcd *CNTRL_RCD);
static int	get_t45_arn_info(struct cntrl_rcd *CNTRL_RCD);
static int	determine_t45_se_data(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01);
static int	determine_t45_cat_resp(struct cntrl_rcd *CNTRL_RCD);
static int	build_prtsc0102_rcd(struct cntrl_rcd *CNTRL_RCD, struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	write_t45_segmnt02(struct cntrl_rcd *CNTRL_RCD, struct prtsc02 *SEGMNT02);
static int	set_t45_custmr(struct cntrl_rcd *CNTRL_RCD, struct prtsc02 *SEGMNT02);
static int	create_t45_03(struct cntrl_rcd *CNTRL_RCD, struct prtsc03 *SEGMNT03);
static int	create_t45_04(struct cntrl_rcd *CNTRL_RCD, struct prtsc04 *SEGMNT04);
static int	get_t45_supsdure_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc04 *SEGMNT04);
static int	fetch_t45_supsdure_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc04 *SEGMNT04);
static int	create_t45_05(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	get_t45_pricing_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	fetch_t45_pricing_info(struct cntrl_rcd *CNTRL_RCD, struct prtsc05 *SEGMNT05);
static int	initlze_segmnt08(struct prtsc08 *SEGMNT08);
static int	initlze_segmnt08_host_var();
static int	initlze_segmnt0102(struct prtsc01 *SEGMNT01, struct prtsc02 *SEGMNT02);
static int	initlze_segmnt0102_host_var();
static int	initlze_segmnt03(struct prtsc03 *SEGMNT03);
static int	initlze_segmnt03_host_var();
static int	initlze_segmnt04(struct prtsc04 *SEGMNT04);
static int	initlze_segmnt04_host_var();
static int	initlze_segmnt05(struct prtsc05 *SEGMNT05);
static int	initlze_segmnt05_host_var();
static void initCNTRL_RCD(cntrl_rcd *CNTRL_RCD);
static void initCNT_RCD(cnt_rcd *CNT_RCD);
static void initOutData(char *outData, size_t len);
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




