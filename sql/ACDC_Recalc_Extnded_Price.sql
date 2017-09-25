whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on

update scm.acdc_order_data a
	set best_ext_price = best_price * qty ;

exit
