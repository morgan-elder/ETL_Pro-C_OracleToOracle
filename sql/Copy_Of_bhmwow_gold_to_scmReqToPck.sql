/*
------------------------------------------------------------------------------
bhmwow_gold_to_scmReqToPck.sql
----------------------------------------------------------------------------
PURPOSE:	The purpose of this PL/SQL script is to update/insert 
		the scm.requests_to_pick data when the GOLD data changed.
CHANGE HISTORY:     	
	DATE       	PROGRAMMER      CHANGE
	---------  	--------------  ----------------------
	06/12/06   	Rena Huang	Initial coding
	10/23/2007	Steve Burns	add STGENWOW and use SABRELINER as the deliver to location.
	03/03/2009      Steve Burns     change the datasource names for a new cold fusion server.
----------------------------------------------------------------------------- */
set serveroutput on size 1000000
set linesize 170
spool /data/scm/PROD/bhmwow_gold_to_scmReqToPck.out
WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT OSCODE
BEGIN
	DECLARE
		
		vSegCode		scm.wow_seg_code_info.seg_code%type;
		vSystem                 scm.wow_seg_code_info.system%type;
		vDaysFromNeedDate	number := 2;
		vQty			number;
		vReserve_voucher1	rsv1.reserve_voucher1%type;
		vRequest_id		req1.request_id%type;
		vRequest_priority	req1.request_priority%type;
		vSelect_from_sc		rsv1.current_sc%type;
		vNeed_date		varchar2(12);
		vSysdate2 		varchar2(12);
		vNowTime		varchar2(12);
		vGoldDataSource		varchar2(100);
		vDelivery_loc		varchar2(10);
		vRequest_nbr		scm.requests_to_pick.request_nbr%type;
		vNeedEndDate		varchar2(12);
		vCount_goldBatchReq	number;
		vCount_whPckActvty	number;
		vNeedEndDatetime	date;
		vReqSeq			number;	
		vCountInsert		number := 0;
		vCountUpdate		number := 0;
		
		vWrkOffsetHrsForToday  	number := 2.5;					
		vShift1StartTime	varchar2(10) := '07:00:00';
		vNeedEndDateUpdt	varchar2(10);
		vNeed_end_datetime	varchar2(30);
			--Line 26	
		--Get Seg Code listing
		CURSOR get_segCode_cur IS
			SELECT 	seg_code, system
			FROM	scm.wow_seg_code_info
			WHERE	system in ('GSNBHM', 'STGENWOW') 
				AND status = 'ACTIVE';
			
		--Get GOLD Batch Reqs and scm data
		CURSOR get_goldBatchReq_cur IS
			SELECT 		sum(rs.qty) as qty,
					rs.reserve_voucher1, r.request_id,
					r.request_priority, rs.current_sc, 
					to_char(r.need_date, 'YYYY/MM/DD') as needDate,
					to_char(sysdate, 'YYYY/MM/DD') as sysdate2, 
					to_char(sysdate, 'HH24:MI:SS') as nowtime,
					'pgoldsa' as datasourceIn
			FROM 		req1 r, rsv1 rs, cat1 c
			WHERE 		length(r.request_id) > 2 AND
					length(rs.current_sc) > 2 AND
					c.part = r.select_from_part AND
					r.request_id = rs.request_id AND
					r.request_priority in (1,2,3) AND
					rs.status = 'O' AND
					(r.status = 'R' OR r.status = 'O') AND
					rs.current_sc in (vSegCode) AND
					rs.tcn = 'DII' AND 
					r.need_date is not null
					AND r.need_date BETWEEN (sysdate - 180) AND 
					(sysdate + (vDaysFromNeedDate + DECODE(to_char(sysdate, 'D'), 
					'1', 0,'2', 0, '3', 0, '4', 0, '5', 1, '6', 2, '7', 0)))
			GROUP BY	rs.reserve_voucher1, r.request_id, r.request_priority, 
					rs.current_sc, r.need_date, 'xgold_sa_wichita'
			ORDER BY	r.request_id, rs.reserve_voucher1; 			
		--Line 58
		BEGIN				
			OPEN get_segCode_cur;
			
			-- vNeedEndDateUpdt := to_char(sysdate, 'HH24:MI:SS') + 2.5 hours;
			SELECT 		to_char(sysdate + vWrkOffsetHrsForToday/24, 'HH24:MI:SS') 
			INTO		vNeedEndDateUpdt
			FROM		dual;
			
			LOOP
				FETCH get_segCode_cur INTO
					vSegCode, vSystem;
				EXIT WHEN get_segCode_cur%NOTFOUND;
			
				--dbms_output.put_line(vSegCode);
						
				IF vSystem = 'GSNBHM'
				THEN 
					vDelivery_loc := 'PEMCO';
				ELSE
					vDelivery_loc := 'SABRELINER';
				END IF;
				
				OPEN get_goldBatchReq_cur;
				
				LOOP
					FETCH get_goldBatchReq_cur INTO
						vQty, vReserve_voucher1, vRequest_id,
						vRequest_priority, vSelect_from_sc, vNeed_date,  
						vSysdate2, vNowTime, vGoldDataSource;
					EXIT WHEN get_goldBatchReq_cur%NOTFOUND;
					
					dbms_output.put_line('Gold: request_ID: '||vRequest_id ||' reserve_voucher1: '||vReserve_voucher1);
					
					dbms_output.put_line('vSystem: '||vSystem ||' vGoldDataSource: '||vGoldDataSource);
					
										
					SELECT 		COUNT(*)					
					INTO 		vCount_goldBatchReq
					FROM 		scm.requests_to_pick
					WHERE 		system = vSystem
							AND gold_datasource = vGoldDataSource
							AND request_id = vRequest_id
							AND reserve_voucher1 = vReserve_voucher1;
					
					dbms_output.put_line('COUNT: '||vCount_goldBatchReq||' request_id: '||vRequest_id||' reserve_voucher1: '||vReserve_voucher1||' to_location: '||vDelivery_loc);
						--Line 92				
					IF vCount_goldBatchReq < 1
					THEN
						SELECT 		scm.request_seq.nextval seq 
						INTO		vReqSeq
						FROM		dual;
						
						--dbms_output.put_line('ReqSeq: '||vReqSeq);
						
						IF vNeed_date > vSysdate2
						THEN
							vNeed_end_datetime := vNeed_date||' '||vShift1StartTime;
							INSERT INTO scm.requests_to_pick 
							(	
								request_nbr, system, gold_datasource, request_id, reserve_voucher1,
								select_from_sc, user_id, need_begin_datetime, need_end_datetime, request_priority,
								wow_priority, red_ball_yn, delivery_location, required_date, entry_datetime, shift_no
							)	
							VALUES
							(	
								vReqSeq, vSystem, vGoldDataSource, vRequest_id, vReserve_voucher1, 
								vSelect_from_sc,'BATCHRUN', sysdate, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
								vRequest_priority, 3, 'N', vDelivery_loc, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
								sysdate, '1'
							);
							dbms_output.put_line('Insert(NeedDate>Today): request_id: '||vRequest_id||' voucher1:'||vReserve_voucher1||' need_end_date: '|| vNeed_end_datetime);	
							vCountInsert := vCountInsert + 1;						
						ELSIF vNeed_date = vSysdate2
						THEN
							IF vNeedEndDateUpdt >= vShift1StartTime
							THEN
								vNeed_end_datetime := vNeed_date||' '||vNeedEndDateUpdt;								
								INSERT INTO scm.requests_to_pick 
								(	
									request_nbr, system, gold_datasource, request_id, reserve_voucher1,
									select_from_sc, user_id, need_begin_datetime, need_end_datetime, request_priority,
									wow_priority, red_ball_yn, delivery_location, required_date, entry_datetime, shift_no
								)	
								VALUES
								(	
									vReqSeq, vSystem, vGoldDataSource, vRequest_id, vReserve_voucher1, 
									vSelect_from_sc,'BATCHRUN', sysdate, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									vRequest_priority, 3, 'N', vDelivery_loc, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									sysdate, '1'
								);								
								dbms_output.put_line('Insert(Now+2.5>=7): request_id: '||vRequest_id||' voucher1: '||vReserve_voucher1||' need-end_date: '|| vNeed_end_datetime);
								vCountInsert := vCountInsert + 1;
							ELSE
								vNeed_end_datetime := vNeed_date||' '||vShift1StartTime;
								INSERT INTO scm.requests_to_pick 
								(	
									request_nbr, system, gold_datasource, request_id, reserve_voucher1,
									select_from_sc, user_id, need_begin_datetime, need_end_datetime, request_priority,
									wow_priority, red_ball_yn, delivery_location, required_date, entry_datetime, shift_no
								)	
								VALUES
								(	
									vReqSeq, vSystem, vGoldDataSource, vRequest_id, vReserve_voucher1, 
									vSelect_from_sc,'BATCHRUN', sysdate, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									vRequest_priority, 3, 'N', vDelivery_loc, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									sysdate, '1'
								);
								dbms_output.put_line('Insert(Now+2.5<7): request_id: '||vRequest_id||' voucher1:'||vReserve_voucher1||' ned_end-date: '|| vNeed_end_datetime);
								vCountInsert := vCountInsert + 1;
							END IF;
						ELSE
							vNeed_end_datetime := vSysdate2||' '||vNeedEndDateUpdt;
							INSERT INTO scm.requests_to_pick 
							(	
								request_nbr, system, gold_datasource, request_id, reserve_voucher1,
								select_from_sc, user_id, need_begin_datetime, need_end_datetime, request_priority,
								wow_priority, red_ball_yn, delivery_location, required_date, entry_datetime, shift_no
							)	
							VALUES
							(	
								vReqSeq, vSystem, vGoldDataSource, vRequest_id, vReserve_voucher1, 
								vSelect_from_sc,'BATCHRUN', sysdate, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
								vRequest_priority, 3, 'N', vDelivery_loc, to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
								sysdate, '1'
							);
							dbms_output.put_line('Insert(NeedDate<Today): request_id: '||vRequest_id||' voucher1: '||vReserve_voucher1||' need_end_date: '|| vNeed_end_datetime);
							vCountInsert := vCountInsert + 1;		
						END IF;  --Line 116
					ELSIF vCount_goldBatchReq >= 1 
					THEN
						SELECT 	request_nbr, 
							to_char(need_end_datetime, 'YYYY/MM/DD') as needEndDatetime
						INTO	vRequest_nbr, vNeedEndDate
						FROM	scm.requests_to_pick
						WHERE	system  = vSystem 
							AND gold_datasource = vGoldDataSource
							AND reserve_voucher1 = vReserve_voucher1
							AND request_id = vRequest_id;
						
						SELECT 	COUNT('X')
						INTO	vCount_whPckActvty
						FROM	scm.warehouse_picking_activity a, scm.requests_to_pick b
						WHERE	a.request_nbr = b.request_nbr AND a.request_nbr = vRequest_nbr;
					
						IF vNeed_date <> vNeedEndDate AND vCount_whPckActvty < 1
						THEN						
							IF vNeed_date > vSysdate2
							THEN
								vNeed_end_datetime := vNeed_date ||' '||vShift1StartTime;
								UPDATE 	scm.requests_to_pick
								SET 	need_begin_datetime 	= sysdate, 
									need_end_datetime 	= to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									required_date 		= to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									entry_datetime 		= sysdate
								WHERE 	
									system 			= vSystem AND 
									gold_datasource 	= vGoldDataSource AND 
									request_id 		= vRequest_id AND
									reserve_voucher1 	= vReserve_voucher1 AND
									request_nbr 		= vRequest_nbr AND
									user_id			= 'BATCHRUN';
								dbms_output.put_line('Update(NeedDate>Today): request_id: '||vRequest_id||' voucjer1: '||vReserve_voucher1||' need_end-date: '|| vNeed_end_datetime);
								vCountUpdate := vCountUpdate + 1;
							
							--ELSE 
								--vNeed_end_datetime := vNeed_date ||' '||vNeedEndDateUpdt;
								--UPDATE 	scm.requests_to_pick
								--SET 	need_begin_datetime 	= sysdate, 
									--need_end_datetime 	= to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									--required_date 		= to_date(vNeed_end_datetime, 'YYYY/MM/DD HH24:MI:SS'),
									--entry_datetime 		= sysdate
								--WHERE 	
									--system 		= vSystem AND 
									--gold_datasource 	= vGoldDataSource AND 
									--request_id 		= vRequest_id AND
									--reserve_voucher1 	= vReserve_voucher1 AND
									--request_nbr 		= vRequest_nbr AND
									--user_id			= 'BATCHRUN';
								--dbms_output.put_line('Update(NeedDate<=Today): '||vRequest_id||' '||vReserve_voucher1||' '|| vNeed_end_datetime);
								--vCountUpdate := vCountUpdate + 1;
							END IF;
						END IF;						
					END IF;				
				END LOOP;
				CLOSE get_goldBatchReq_cur;
				COMMIT;	
				
			END LOOP;
			CLOSE get_segCode_cur; 
			COMMIT;		
			
			dbms_output.put_line(chr(9));
			dbms_output.put_line(vCountInsert||' rows inserted into the requests_to_pick table.');
			dbms_output.put_line(vCountUpdate||' rows updated into the requests_to_pick table.');
		END;	--Line 172	
END;
/
spool off
exit

----
