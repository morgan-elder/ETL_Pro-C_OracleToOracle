#include <string.h>

/*
 * Converts FSC & NIIN into NSN Format
 * Used for converting SLIC to GOLD
 */
void convert_to_nsn(char *nsn,char *fsc, char *niin)
{
	if(strncmp(fsc,"    ",4) == 0 || strncmp(niin,"         ",9) == 0)
	{
		memset(nsn,' ',16);
		strncpy(&nsn[0],"NSL",3);
	}
	else
	{
		strncpy(nsn,fsc,4);
		strncpy(&nsn[4],"-",1);
		strncpy(&nsn[5],&niin[0],2);
 		strncpy(&nsn[7],"-",1);
		strncpy(&nsn[8],&niin[2],3);
		strncpy(&nsn[11],"-",1);
		strncpy(&nsn[12],&niin[5],4);
	}
	nsn[16] = '\0';
}

/*
 * Converts NSN into FSC & NIIN Format
 * Used for converting GOLD to SLIC
 */
void convert_to_fsc_niin(char *nsn,char *fsc, char *niin)
{
	if(strlen(nsn) == 16)
	{
		if(strncmp(nsn,"                ",16) == 0 || strncmp(nsn,"NSL",3) == 0)
		{
			strncpy(fsc,"    ",4);
			strncpy(niin,"         ",9);
		}
		else
		{
			strncpy(fsc,&nsn[0],4);
			strncpy(niin,&nsn[5],2);
			strncpy(&niin[2],&nsn[8],3);
			strncpy(&niin[5],&nsn[12],4);
		}
	}
	else
	{
		if(strncmp(nsn,"             ",13) == 0 || strncmp(nsn,"NSL",3) == 0)
		{
			strncpy(fsc,"    ",4);
			strncpy(niin,"         ",9);
		}
		else
		{
			strncpy(fsc,&nsn[0],4);
			strncpy(niin,&nsn[4],9);
		}
	}
	fsc[4] = '\0';
	niin[9] = '\0';
}
