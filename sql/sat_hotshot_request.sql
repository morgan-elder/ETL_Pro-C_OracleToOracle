/* Formatted on 1/4/2021 9:49:43 AM (QP5 v5.294) */
SET SERVEROUTPUT ON SIZE 1000000
SET SQLBLANKLINES ON
SET TRIMSPOOL ON
SET LINESIZE 170
SPOOL /data/scm/PROD/sat_hotshot_request.out
WHENEVER SQLERROR EXIT sql.sqlcode
WHENEVER OSERROR EXIT oscode

BEGIN
   DECLARE
      v_reserve_voucher1    VARCHAR2 (20);
      v_request_id          VARCHAR2 (20);
      v_request_priority    NUMBER (2);
      v_deliver_to_dodaac   VARCHAR2 (20);
      v_x                   CHAR (1);
      v_any_found           NUMBER := 0;

      CURSOR c1
      IS
         SELECT r.request_id,
                rs.reserve_voucher1,
                r.request_priority,
                NVL (r.deliver_to_dodaac, 'POU-NULL') deliver_to_dodaac
           FROM req1 r, rsv1 rs
          WHERE     r.proj_code = '999'
                AND rs.status = 'O'
                AND r.status IN ('R', 'O')
                AND rs.to_location = 'NEW-BREED-STX'
                AND LENGTH (r.request_id) > 2
                AND r.request_id = rs.request_id;

      CURSOR c2
      IS
         SELECT 'x'
           FROM requests_to_pick_nb
          WHERE     reserve_voucher1 = v_reserve_voucher1
                AND request_id = v_request_id;
   BEGIN
      OPEN c1;

      LOOP
         FETCH c1
            INTO v_request_id,
                 v_reserve_voucher1,
                 v_request_priority,
                 v_deliver_to_dodaac;

         EXIT WHEN c1%NOTFOUND OR c1%NOTFOUND IS NULL;

         OPEN c2;

         FETCH c2 INTO v_x;

         IF c2%ROWCOUNT = 0
         THEN
            v_any_found := 1;
            DBMS_OUTPUT.put_line (
                  'request_id = '
               || v_request_id
               || '; reserve_voucher1 = '
               || v_reserve_voucher1);

            INSERT INTO requests_to_pick_nb (request_seq_no,
                                             SYSTEM,
                                             gold_datasource,
                                             request_id,
                                             reserve_voucher1,
                                             user_id,
                                             request_priority_select,
                                             delivery_location,
                                             entry_datetime,
                                             hotshot_b)
                 VALUES (request_seq_nb.NEXTVAL,
                         'SATWOW',
                         'pgoldsa',
                         v_request_id,
                         v_reserve_voucher1,
                         'ADMIN',
                         v_request_priority,
                         v_deliver_to_dodaac,
                         SYSDATE,
                         'T');

            INSERT INTO gold_nb_hold (interface_name,
                                      interface_type,
                                      created_date_time,
                                      interface_key,
                                      data_source,
                                      old_sc)
                 VALUES ('IOBORDER',
                         'INSERT',
                         SYSDATE,
                         v_reserve_voucher1,
                         'PGOLDSA',
                         'HOTSHOT');
         END IF;

         CLOSE c2;
      END LOOP;

      CLOSE c1;

      COMMIT;

      IF v_any_found = 0
      THEN
         DBMS_OUTPUT.put_line ('None Found');
      END IF;
   END;
END;
/

SPOOL OFF
EXIT
