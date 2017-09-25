/*
		acdc_set_processing_mdl.h

	This include is used in the ACDC Applications to set the SLIC Prefix
	value for the SLIC Tables.  Example - F18_ha, 'F18' is the SLIC Prefix.

	The value is set off of the cust_mdl value.

	*/

       		memset(processing_mdl,' ',10);
		if(strncmp((char *) cust_mdl.arr,"F18",3)==0)
		{
			strncpy(processing_mdl,"F18",3);
		}
		else
		{
																							if(strncmp((char *) cust_mdl.arr,"AV8",3)==0)
			{
				strncpy(processing_mdl,"AV8B",4);
																							}
			else
			{
				strncpy(processing_mdl,"????",4);
			}
		}

