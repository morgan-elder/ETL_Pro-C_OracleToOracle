whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode

set echo on
set termout on
set time on
set timing on


delete 
    from scm.acdc_fdw_dtl_data a
    where rec_audit_source = 'CAPS'
      and exists (select purchase_order,po_line_item
		   from scm.acdc_fdw_dtl_data b
		   where b.rec_audit_source = 'NWPAP'
		     and b.purchase_order=a.purchase_order
		     and b.po_line_item=a.po_line_item
		     and b.rec_audit_record=a.rec_audit_record);

commit;

update scm.acdc_fdw_dtl_data a 
   set amt=0, 
       qty=0, 
       unit_price=0 
where rec_audit_record = 'COMMITMENT' 
  and amt > 0 
  and rec_audit_source = 'CAPS' 
  and not exists (select b.activity_id 
                    from scm.acdc_fdw_dtl_data b 
			where b.rec_audit_record = 'INVOICE' 
			  and b.rec_audit_source = 'CAPS' 
			  and b.activity_id=a.activity_id 
			  and b.purchase_order=a.purchase_order 
			  and b.po_line_item=a.po_line_item);

commit;

delete scm.acdc_fdw_summed_data;

commit;

insert into scm.acdc_fdw_summed_data
	   (activity_id,
	    job,
	    purchase_order,
	    po_line_item,
	    price_type,
	    nwp_commit_qty,
	    nwp_commit_amt,
	    nwp_invoice_qty,
	    nwp_invoice_amt,
	    caps_commit_qty,
	    caps_commit_amt,
	    caps_invoice_qty,
	    caps_invoice_amt
	   )
	 select distinct rtrim(a.activity_id), 
	        rtrim(a.job), 
	        rtrim(a.po), 
	        rtrim(a.po_line), 
	        rtrim(a.price_type), 
		a.nwp_commitment_qty,
		a.nwp_commitment_amt,
		a.nwp_invoice_qty,
		a.nwp_invoice_amt,
		a.caps_commitment_qty,
		a.caps_commitment_amt,
		a.caps_invoice_qty,
		a.caps_invoice_amt
	from stlscm.acdc_fdw_merge_record_v a;
exit;
