-- ACDC_Build_NIIN_Avg_Price_M.sql
-- Author: Douglas S. Elder
-- Date: 3/13/15
-- Desc: load scm.acdc_niin_avg_price_m
-- update scm.acdc_order_data_multi
 
whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on


delete from scm.acdc_niin_avg_price_m;

commit ;

insert into scm.acdc_niin_avg_price_m 
	   (CUST,
	    CUST_MODEL,
	    CUST_CUST_MODEL,
	    SYSTEM,
	    niin, 
	    avg_price, 
	    load_date) 		
select CUST,
	CUST_MODEL,
	CUST_CUST_MODEL,
	SYSTEM,
	niin,
	avg(best_price),
	sysdate 
 from scm.acdc_order_data_multi
  where 1=1
   and best_price > 0
   and niin is not null 
   and substr(niin,1,2) <> 'LL'
group by cust,cust_model,cust_cust_model,system,niin,sysdate;

commit ;

update scm.acdc_order_data_multi a
     set best_price = (select avg_price
			from scm.acdc_niin_avg_price_m b
			   where 1=1
			      and a.niin=b.niin
			      and a.CUST=b.cust 
			      and a.CUST_MODEL=a.cust_model 
			      and a.CUST_CUST_MODEL=b.cust_cust_model
			      and a.SYSTEM=b.system),
        best_price_source = 'NIIN MATCH',
	best_price_cat = 'AVG PRICE',
	escalation_price = (select avg_price
			from scm.acdc_niin_avg_price_m b
			   where 1=1
			      and a.niin=b.niin
			      and a.CUST=b.cust 
			      and a.CUST_MODEL=b.cust_model 
			      and a.CUST_CUST_MODEL=b.cust_cust_model
			      and a.SYSTEM=b.system),
	escalation_pcnt_amt=1.00,
	escalation_fromdate='9999'
where a.best_price=0
  and exists (select c.niin
		from scm.acdc_niin_avg_price_m c
		where 1=1
		and a.niin=c.niin
	        and a.CUST=c.cust
	        and a.CUST_MODEL=c.cust_model 
	        and a.CUST_CUST_MODEL=c.cust_cust_model
	        and a.SYSTEM=c.system);
exit
