
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__registersession
  
  
  
  
  as (
    SELECT 
"RegisterSessionID" AS RegisterSessionID,
"RegisterID" AS RegisterID,
"SessionNo" AS SessionNo,
"Date" AS Date,
"StartTime" AS StartTime,
"EndTime" AS EndTime,
"Duration" AS Duration
FROM CURRICULUM_DB.RAW.PROSOLUTION_REGISTERSESSION
  );

