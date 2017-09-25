
define spoolfile=&1

set time on
set timing on

set echo on
set term on
set feedback on

/* use temp tables to improve performance */

whenever sqlerror continue
whenever oserror continue

DROP TABLE STLSCM.gold_parts CASCADE CONSTRAINTS;

whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

CREATE GLOBAL TEMPORARY TABLE gold_parts ON COMMIT PRESERVE ROWS
AS
   SELECT c1.prime,
          NVL (c2.manuf_cage, 'N/A') prime_cage,
          c1.part,
          NVL (c1.manuf_cage, 'N/A') part_cage,
          NVL (c1.nin, '???????????') nsn
     FROM cat1 c1, cat1 c2
    WHERE c1.prime = c2.part;


whenever sqlerror continue
whenever oserror continue

DROP TABLE STLSCM.f18_whse_parts CASCADE CONSTRAINTS;

whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

CREATE GLOBAL TEMPORARY TABLE f18_whse_parts ON COMMIT PRESERVE ROWS
AS
   SELECT DISTINCT w.part
     FROM whse w
    WHERE sc LIKE 'F18%';

whenever sqlerror continue
whenever oserror continue

DROP TABLE STLSCM.acdc_parts CASCADE CONSTRAINTS;

whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

CREATE GLOBAL TEMPORARY TABLE acdc_parts ON COMMIT PRESERVE ROWS
AS
   SELECT DISTINCT a.part
     FROM scm.acdc_order_data a, gold_parts c1
    WHERE c1.part = a.part
   UNION
   SELECT b.part
     FROM scm.scm_price_logic b, gold_parts d1
    WHERE d1.part = b.part;


set linesize 200
set trimspool on
set pagesize 0
set echo off
set feedback off
set term off
set newpage 0
set heading off
set trimout on
set timing off
set wrap off

column PRIME format A50
column PRIME_CAGE format A5
column PART format A50
column PART_CAGE format A5
column NSN format A11

spool &spoolfile

SELECT prime,
       prime_cage,
       part,
       part_cage,
       nsn
  FROM gold_parts c1
 WHERE     EXISTS
              (SELECT part
                 FROM f18_whse_parts w
                WHERE w.part = c1.part)
       AND NOT EXISTS
              (SELECT part
                 FROM acdc_parts
                WHERE c1.part = part);


spool off

set echo on
set term on
set feedback on

whenever sqlerror continue
whenever oserror continue

exit
