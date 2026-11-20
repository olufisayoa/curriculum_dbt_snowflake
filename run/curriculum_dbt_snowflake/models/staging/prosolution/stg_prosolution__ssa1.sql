
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__ssa1
  
  
  
  
  as (
    select 
"SSA_Tier1_code" AS SSA_Tier1_Code,
"SSA_Tier1_Desc" AS SSA_Tier1_Desc
from CURRICULUM_DB.RAW.PROSOLUTION_SSA1
  );

