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

SELECT o.part,
       c.prime,
       o.order_no,
       o.vendor_code,
       TO_CHAR (o.created_datetime, 'YYYYMMDD'),
       release_type,
       lisn_ssn,
       SUBSTR (lisn_ssn, 0, 6) || '    ' || '00' || SUBSTR (lisn_ssn, 7, 3)
  FROM ord1 o, cat1 c, scm.scm_lisn_ssn s
 WHERE     order_no LIKE 'F18S%'
       AND order_type = 'C'
       AND status = 'S'
       AND o.part = c.part
       AND c.part = s.part_no
       AND o.part = s.part_no
       AND o.order_no = s.gold_order_no
       AND o.vendor_code = '76301'
       AND s.release_type IN ('MM', 'PM') ;


spool off

exit
