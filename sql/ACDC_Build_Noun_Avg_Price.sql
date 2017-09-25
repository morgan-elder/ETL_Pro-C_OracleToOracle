whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on


delete from scm.acdc_noun_avg_price;

commit ;

insert into scm.acdc_noun_avg_price 
   (noun, 
    avg_price, 
    load_date) 
select noun,
       avg(best_price),
       sysdate 
from scm.acdc_order_data 
where best_price > 0
group by noun,sysdate;

commit ;

update scm.acdc_order_data a
	set best_price = (select avg_price
			     from scm.acdc_noun_avg_price b
				where 1=1
				  and a.noun=b.noun),
	best_price_source = 'NOUN MATCH',
	best_price_cat = 'AVG PRICE',
	escalation_price = (select avg_price
			     from scm.acdc_noun_avg_price b
				where 1=1
				  and a.noun=b.noun),
	escalation_pcnt_amt=1.00,
	escalation_fromdate='9999'
where a.best_price=0
  and exists (select c.noun
		from scm.acdc_noun_avg_price c
		where 1=1
		and a.noun=c.noun);

exit
