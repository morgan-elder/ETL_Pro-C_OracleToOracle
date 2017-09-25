whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on

delete from scm.acdc_niin_avg_price;

commit ;

insert into scm.acdc_niin_avg_price 
	   (niin, 
	    avg_price, 
	    load_date) 		
select niin,
	avg(best_price),
	sysdate 
 from scm.acdc_order_data
  where 1=1
   and best_price > 0
   and niin is not null 
   and substr(niin,1,2) <> 'LL'
group by niin,sysdate;

commit ;

update scm.acdc_order_data a
     set best_price = (select avg_price
			from scm.acdc_niin_avg_price b
			   where 1=1
			      and a.niin=b.niin),
        best_price_source = 'NIIN MATCH',
	best_price_cat = 'AVG PRICE',
	escalation_price = (select avg_price
			from scm.acdc_niin_avg_price b
			   where 1=1
			      and a.niin=b.niin),
	escalation_pcnt_amt=1.00,
	escalation_fromdate='9999'
where a.best_price=0
  and exists (select c.niin
		from scm.acdc_niin_avg_price c
		where 1=1
		and a.niin=c.niin);

exit
