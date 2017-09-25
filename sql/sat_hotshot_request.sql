set serveroutput on size 1000000
set linesize 170
spool /data/scm/PROD/sat_hotshot_request.out
whenever sqlerror exit sql.sqlcode
whenever oserror exit oscode
begin
declare
    v_reserve_voucher1    varchar2(20);
    v_request_id          varchar2(20);
    v_request_priority    number(2);
    v_deliver_to_dodaac   varchar2(20);
    v_x                   char(1);
    v_any_found           number := 0;

    cursor c1 is
        select r.request_id,
               rs.reserve_voucher1,
               r.request_priority,
               nvl(r.deliver_to_dodaac,'POU-NULL') deliver_to_dodaac
          from req1 r, rsv1 rs 
         where r.proj_code = '999'
           and rs.status = 'O'
           and r.status in ('R','O')
           and rs.to_location = 'NEW-BREED-STX'
           and length(r.request_id) > 2
           and r.request_id = rs.request_id;
           
    cursor c2 is
        select 'x' from requests_to_pick_nb
         where reserve_voucher1 = v_reserve_voucher1
           and request_id = v_request_id;
begin
    open c1;
    loop
        fetch c1 into v_request_id, v_reserve_voucher1, v_request_priority, v_deliver_to_dodaac;
        exit when c1%notfound or c1%notfound is null;
        
        open c2;
        fetch c2 into v_x;
           
        if c2%rowcount = 0 then
            v_any_found := 1;
            dbms_output.put_line('request_id = '||v_request_id||'; reserve_voucher1 = '||v_reserve_voucher1);
        
            insert into requests_to_pick_nb (
                request_seq_no,
                system,
                gold_datasource,
                request_id,
                reserve_voucher1,
                user_id,
                request_priority_select,
                delivery_location,
                entry_datetime,
                hotshot_b)
              values (
                request_seq_nb.nextval,
                'SATWOW',
                'pgoldsa',
                v_request_id,
                v_reserve_voucher1,
                'ADMIN',
                v_request_priority,
                v_deliver_to_dodaac,
                sysdate,
                'T');

            insert into gold_nb_hold (
                interface_name,
                interface_type,
                created_date_time,
                interface_key,
                data_source,
                old_sc)
              values (
                'IOBORDER',
                'INSERT',
                SYSDATE,
                v_reserve_voucher1,
                'PGOLDSA',
                'HOTSHOT');
        end if;
        close c2;
    end loop;
    close c1;
    commit;
    if v_any_found = 0 then
        dbms_output.put_line('None Found');
    end if;
end;
end;
/
spool off
exit
