
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__ssa2
  
  
  
  
  as (
    select 
"SSA_Tier2_code" AS SSA_Tier2_Code,
"SSA_Tier2_Desc" AS SSA_Tier2_Desc
from CURRICULUM_DB.RAW.PROSOLUTION_SSA2
  );

