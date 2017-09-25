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

spool &spoolfile

select  '"'||rtrim(nvl(ACTIVITY_ID,' '))
	||'","'||
	rtrim(nvl(JOB,' '))
	||'","'||
	rtrim(nvl(PURCHASE_CONTRACT,' ')) 
	||'","'||
	rtrim(nvl(translate(PART,'"',' '),' '))
	||'","'||
	rtrim(nvl(PC_LINE_ITEM,' '))
	||'","'||
	rtrim(nvl(UM,' ' ))
	||'","'||
	rtrim(nvl(PC_PRICE_TYPE,' '))
	||'","'||
	rtrim(nvl(MATL_CLASS,' '))
	||'","'||
	rtrim(nvl(SUPPLIER_NAME,' '))
	||'","'||
	rtrim(nvl(RELEASE_ORDER_NBR,' '))
	||'","'||
	rtrim(nvl(SUPPLIER_CODE,' '))
	||'","'||
	rtrim(nvl(BUYER_NAME,' '))
	||'","'||
	rtrim(nvl(RSC,' '))
	||'","'||
	to_char(nvl(QTY,0),'0000000009')
	||'","'||
	to_char(nvl(AMT,0),'00000000.9999')
	||'","'||
	rtrim(nvl(REC_AUDIT_SOURCE,' '))
	||'","'||
	rtrim(nvl(REC_AUDIT_RECORD,' '))
	||'"'
from sysadm.first_procurement_mart_vw;

spool off

exit
