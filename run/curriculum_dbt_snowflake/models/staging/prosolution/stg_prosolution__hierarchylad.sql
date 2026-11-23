
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__hierarchylad
  
  
  
  
  as (
    SELECT
	QA_AIM_R ,
	INSPCODE ,
	MAPCODE ,
	MAPAWB ,
	MAPTITLE ,
	MAPQTY ,
	MAP_PA ,
	MAP_SPA ,
	MAP_NL ,
	MAP_AOL
FROM CURRICULUM_DB.RAW.PROSOLUTION_HIERARCHYLAD
  );

