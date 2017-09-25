MYSCHEMA/ACCESS@CONNECT
whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

define spoolfile=&1
--set serveroutput on size 1000000
set pagesize 0
set echo off
set feedback off
set term off
set newpage 0
set heading off
--set trimout on
set space 0
set linesize 167
column cust format A20
column cust_model format A20
column cust_cust_model format A41
column system format A20
column part format A50
column mfg_code format A5

spool &spoolfile

select distinct cust,
	cust_model,
	cust_cust_model,
	system,
	part,
	mfg_code
from scm.acdc_order_data_multi
where cust_model like 'AV8%'
order by 5,1,2,3,4;
exit
