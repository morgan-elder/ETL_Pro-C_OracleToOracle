whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

define spoolfile=&1
set linesize 250
set trimspool on
set pagesize 0
set echo off
set feedback off
set term off
set newpage 0
set heading off
set trimout on

column CUST format A20
column CUST_MODEL format A20
column CUST_CUST_MODEL format A41
column SCM_SYSTEM format A20
column PRIME format A50
column PRIME_CAGE format A5
column PART format A50
column PART_CAGE format A5
column NSN format A11

spool &spoolfile

/* Formatted on 3/20/2015 5:42:39 PM (QP5 v5.256.13226.35538) */
SELECT RPAD ('NAVICP', 20, ' ') "CUST",
       RPAD ('F18', 20, ' ') "CUST_MODEL",
       RPAD ('NAVICP~F18', 41, ' ') "CUST_CUST_MODEL",
       RPAD ('FSTACDC', 20, ' ') "SCM_SYSTEM",
       RPAD (c1.prime, 50, ' ') "PRIME",
       NVL (c1.manuf_cage, 'N/A') "PRIME_CAGE",
       RPAD (c1.part, 50, ' ') "PART",
       NVL (c1.manuf_cage, 'N/A') "PART_CAGE",
       NVL (RPAD (c1.nin, 11, ' '), '???????????') "NSN"
  FROM cat1 c1
 WHERE     c1.prime = c1.part
       AND EXISTS
              (SELECT NULL
                 FROM whse w
                WHERE w.part = c1.part AND sc LIKE 'F18%')
UNION ALL
SELECT RPAD ('NAVICP', 20, ' ') "CUST",
       RPAD ('AV8BH', 20, ' ') "CUST_MODEL",
       RPAD ('NAVICP~AV8BH', 41, ' ') "CUST_CUST_MODEL",
       RPAD ('HISSACDC', 20, ' ') "SCM_SYSTEM",
       RPAD (c1.prime, 50, ' ') "PRIME",
       NVL (c1.manuf_cage, 'N/A') "PRIME_CAGE",
       RPAD (c1.part, 50, ' ') "PART",
       NVL (c1.manuf_cage, 'N/A') "PART_CAGE",
       NVL (RPAD (c1.nin, 11, ' '), '???????????') "NSN"
  FROM cat1 c1
 WHERE     c1.prime = c1.part
       AND EXISTS
              (SELECT NULL
                 FROM whse w
                WHERE w.part = c1.part) ;

spool off
exit
