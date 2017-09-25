-- ACDC_Build_PartBasic_Avg_Price_M.sql
-- Author: Douglas S. Elder
-- Date: 3/13/15
-- load scm.acdc_part_basic_avg_price_m
-- update scm.acdc_order_data_nulti

whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on


delete from scm.acdc_part_basic_avg_price_m;

commit ;

insert into scm.acdc_part_basic_avg_price_m
	   (cust,
	   cust_model,
	   cust_cust_model,
	   system,
	   part_basic, 
	   noun,
	   avg_price, 
	   load_date) 		
select cust,
	cust_model,
	cust_cust_model,
	system,
	part_basic,
	noun,
	avg(best_price),
	sysdate 
 from scm.acdc_order_data_multi
  where 1=1
   and best_price > 0
group by cust,cust_model,cust_cust_model,system,part_basic,noun,sysdate;

commit ;

update scm.acdc_order_data_multi a
	set best_price = (select avg_price
			     from scm.acdc_part_basic_avg_price_m b
			     where 1=1
			 	and a.part_basic=b.part_basic
				and a.noun=b.noun
				and a.cust=b.cust
				and a.cust_model=b.cust_model
				and a.cust_cust_model=b.cust_cust_model
				and a.system=b.system),
	    best_price_source = 'BASIC PART FAMILY',
	    best_price_cat = 'AVG PRICE',
	    escalation_price = (select avg_price
                             from scm.acdc_part_basic_avg_price_m b
                             where 1=1
                                and a.part_basic=b.part_basic
                                and a.noun=b.noun
				and a.cust=b.cust
				and a.cust_model=b.cust_model
				and a.cust_cust_model=b.cust_cust_model
				and a.system=b.system),
           escalation_pcnt_amt = 1.00,
           escalation_fromdate = '9999'
where a.best_price=0
   and exists (select c.part_basic
		   from scm.acdc_part_basic_avg_price_m c
		   where 1=1
			and a.part_basic=c.part_basic
		        and a.noun=c.noun
			and a.cust=c.cust
			and a.cust_model=c.cust_model
			and a.cust_cust_model=c.cust_cust_model
			and a.system=c.system);
			
exit
