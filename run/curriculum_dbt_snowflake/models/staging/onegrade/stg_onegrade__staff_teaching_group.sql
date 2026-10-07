
  create or replace   view CURRICULUM_DB.stg.stg_onegrade__staff_teaching_group
  
  
  
  
  as (
    select 
    ID ,
	AcademicYearID,
    StaffID,
    TeachingGroupCode
from CURRICULUM_DB.RAW.ONEGRADE_STAFFTEACHINGGROUP
  );

