whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set time on
set timing on
set echo on


delete from scm.acdc_noun_avg_price_m;

commit ;

insert into scm.acdc_noun_avg_price_m
   (CUST,
    CUST_MODEL,
    CUST_CUST_MODEL,
    SYSTEM,
    noun, 
    avg_price, 
    load_date) 
select cust,
	cust_model,
	cust_cust_model,
	system,
	noun,
       avg(best_price),
       sysdate 
from scm.acdc_order_data_multi
where best_price > 0
group by cust,cust_model,cust_cust_model,system,noun,sysdate;

commit ;

update scm.acdc_order_data_multi a
	set best_price = (select avg_price
			     from scm.acdc_noun_avg_price_m b
				where 1=1
				  and a.noun=b.noun
				  and a.cust=b.cust
				  and a.cust_model=b.cust_model
				  and a.cust_cust_model=b.cust_cust_model
				  and a.system=b.system),
	best_price_source = 'NOUN MATCH',
	best_price_cat = 'AVG PRICE',
	escalation_price = (select avg_price
			     from scm.acdc_noun_avg_price_m b
				where 1=1
				  and a.noun=b.noun
				  and a.cust=b.cust
				  and a.cust_model=b.cust_model
				  and a.cust_cust_model=b.cust_cust_model
				  and a.system=b.system),
	escalation_pcnt_amt=1.00,
	escalation_fromdate='9999'
where a.best_price=0
  and exists (select c.noun
		from scm.acdc_noun_avg_price_m c
		where 1=1
		and a.noun=c.noun
		and a.cust=c.cust
		and a.cust_model=c.cust_model
		and a.cust_cust_model=c.cust_cust_model
		and a.system=c.system);

exit
