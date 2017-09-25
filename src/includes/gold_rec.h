/*
 * Structs for Asset Summary
 */
EXEC SQL BEGIN DECLARE SECTION;
/* GOLD Variables */
typedef struct
{
   varchar part[51];
   varchar nsn[17]; 
   varchar manuf_cage[6]; 
   varchar prime[51]; 
   varchar noun[41]; 
   varchar smrc[7]; 
   long ave_cap_lead_time;
   varchar ims_designator_code[21]; 
   varchar user_name[41]; 
   varchar phone[21]; 
   float retail_demand_tot;
   long wholesale_demand_tot;
} gold_vars;
EXEC SQL END DECLARE SECTION;
