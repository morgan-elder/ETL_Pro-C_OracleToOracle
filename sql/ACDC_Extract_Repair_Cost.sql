whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

define spoolfile=&1
set linesize 350
set trimspool on
set pagesize 0
set echo off
set feedback off
set term off
set newpage 0
set heading off
set trimout on
set colsep ''

column CUST format A20
column CUST_MODEL format A20
column CUST_CUST_MODEL format A20
column part format A50
column gold_order_no format A20
column repair_type format A20
column CREATED_DATE format A19
column COMPLETED_DATE format A19
column LABOR_CODE format A10
column MATERIAL_COST format A13
column SYSTEM format A20
column CREATING_DATABASE format A20
column TOTAL_COST format A13
column vendor_code format A20
column JICC format A20
column JOB format A3
column ACTION_TAKEN format A1

spool &spoolfile

select  nvl(cust,'NAVICP') "CUST",
	   nvl(cust_model,'F18') "CUST_MODEL",
	   nvl(cust_cust_model,'NAVICP~F18') "CUST_CUST_MODEL",
	   part,
	   gold_order_no,
	   repair_type,
	   to_char(created_datetime,'YYYY-MM-DD HH24:MI:SS') "CREATED_DATE",
	   nvl(rtrim(to_char(completed_datetime,'YYYY-MM-DD HH24:MI:SS')),' ') "COMPLETED_DATE",
	   to_char(labor_cost,'000000009') "LABOR_COST",
	   to_char(sum(price),'000000009.99') "PRICE",
	   nvl(system,'FSTCOPPR') "SYSTEM",
	   nvl(creating_database,'PGOLDSL') "CREATING_DATABASE",
	   to_char(sum(price)+labor_cost,'000000009.99') "TOTAL_COST",
	   vendor_code,
	   nvl(jicc,'TBD') "JICC",
	   b.job "JOB",
	   nvl(action_taken,' ') "ACTION_TAKEN"
from stlscm.acdc_nadep_repair_cost_v a,
     scm.acdc_contract_job b
where 1=1 
 and (a.created_datetime >= b.start_date
      and a.created_datetime <= b.end_date)
group by cust,
	cust_model,
	cust_cust_model,
	part,
	gold_order_no,
	repair_type,
	to_char(created_datetime,'YYYY-MM-DD HH24:MI:SS'),
	nvl(rtrim(to_char(completed_datetime,'YYYY-MM-DD HH24:MI:SS')),' '),
	labor_cost,
	nvl(system,'FSTCOPPR'),
	nvl(creating_database,'PGOLDSL'),
	vendor_code,
	nvl(jicc,'TBD'),
	b.job,
	nvl(action_taken,' ')
union all
select  nvl(c.cust,'NAVICP'),
	   nvl(c.cust_model,'F18'),
	   nvl(c.cust_cust_model,'NAVICP~F18'),
	   a.part,
	   a.order_no,
	   a.repair_type,
	   to_char(a.created_datetime,'YYYY-MM-DD HH24:MI:SS'),
	   to_char(a.completed_docdate,'YYYY-MM-DD HH24:MI:SS'),
	   ' 000000000',
	   ' 000000000.00',
	   nvl(c.system,'FSTCOPPR'),
	   nvl(c.CREATING_DATABASE,'PGOLDSL'),
	   to_char(nvl(c.repair_cost,0),'000000009.99'),
	   a.vendor_code,
	   nvl(c.jicc,'TBD'),
	   d.job,
	   nvl(a.action_taken,' ')
from ord1 a,
--	 venn v,
         scm.acdc_contract_job d,
	 ror.metric_composite m,
	 ror.coppr_gold_order c
where a.order_no like 'F18R%'
  and a.order_no=c.gold_order_no (+)
  and a.order_no=m.gold_order_no (+)
--and a.vendor_code=v.vendor_code
--  and a.STATUS in ('C','R')
  and (a.action_taken <> 'Z' or
       a.action_taken is null)
  and order_type='J'
  and a.repair_type not like '%NADEP%'
  and (a.created_datetime >= d.start_date
      and a.created_datetime <= d.end_date)
order by 1,2;

spool off
 
exit
