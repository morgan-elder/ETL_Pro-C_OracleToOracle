typedef struct {
        char    start_quote;
	char	vendor_site_code[40];
        char    delimitr02[3];
	char	seq[20];
        char    delimitr02[3];
	char	vendor_code[20];
        char    delimitr02[3];
	char	site_code[20];
        char    delimitr02[3];
	char	contact[60];
        char    delimitr02[3];
	char	phone[20];
        char    delimitr02[3];
	char	remarks[75];
        char    delimitr02[3];
	char	po_b[1];
        char    delimitr02[3];
	char	jo_b[1];
        char    delimitr02[3];
	char	fax[20];
        char    delimitr02[3];
	char	email[75];
        char    end_quote;
        char    eol;
	} vnco;
