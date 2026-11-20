
  
    

create or replace transient table CURRICULUM_DB.core.dim_cohort
    
    
    
    as (SELECT 
         md5(cast(coalesce(cast(TRIM(Cohort) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CohortKey",
         Cohort AS "Cohort"
FROM CURRICULUM_DB.int.int_cohort
    )
;


  