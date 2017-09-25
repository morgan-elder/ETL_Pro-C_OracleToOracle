whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

define spoolfile=&1
set linesize 200
set trimspool on
set pagesize 0
set echo off
set feedback off
set term off
set newpage 0
set heading off
set trimout on

column part format A50
column mfg_code format A5

spool &spoolfile

select distinct part,
	mfg_code
from scm.acdc_order_data
order by 1;

spool off

exit
