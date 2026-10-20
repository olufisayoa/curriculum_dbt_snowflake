
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__student
  
  
  
  
  as (
    SELECT
S.StudentID,
S.AcademicYearID,
S.PMStudentID
FROM CURRICULUM_DB.RAW.PROMONITOR_VSTUDENT S
  );

