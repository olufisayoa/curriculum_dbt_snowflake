
  
    

create or replace transient table CURRICULUM_DB.core.dim_academicyear
    
    
    
    as (WITH dim_academicyear AS (
SELECT 
       "AcademicYearKey" AS "AcademicYearKey"
      ,AcademicYearID AS "AcademicYear"
      ,StartDate AS "StartDate"
      ,EndDate AS "EndDate"
      ,Number AS "Number"
FROM CURRICULUM_DB.stg.stg_prosolution__academicyear 

)
SELECT * FROM dim_academicyear
    )
;


  