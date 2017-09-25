whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode


set echo on
set termout on
set time on
set timing on


delete from scm.acdc_part_basic_avg_price;

commit ;

insert into scm.acdc_part_basic_avg_price 
	   (part_basic, 
	    noun,
	    avg_price, 
	    load_date) 		
select part_basic,
	noun,
	avg(best_price),
	sysdate 
 from scm.acdc_order_data
  where 1=1
   and best_price > 0
group by part_basic,noun,sysdate;

commit ;

update scm.acdc_order_data a
	set best_price = (select avg_price
			     from scm.acdc_part_basic_avg_price b
			     where 1=1
			 	and a.part_basic=b.part_basic
				and a.noun=b.noun),
	    best_price_source = 'BASIC PART FAMILY',
	    best_price_cat = 'AVG PRICE',
	    escalation_price = (select avg_price
                             from scm.acdc_part_basic_avg_price b
                             where 1=1
                                and a.part_basic=b.part_basic
                                and a.noun=b.noun),
           escalation_pcnt_amt = 1.00,
           escalation_fromdate = '9999'
where a.best_price=0
   and exists (select c.part_basic
		   from scm.acdc_part_basic_avg_price c
		   where 1=1
			and a.part_basic=c.part_basic
		        and a.noun=c.noun);
			
exit
