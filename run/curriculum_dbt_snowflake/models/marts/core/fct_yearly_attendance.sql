
  
    

create or replace transient table CURRICULUM_DB.core.fct_yearly_attendance
    
    
    
    as (SELECT 
    StudentKey AS "StudentKey",
    AcademicYearKey AS "AcademicYearKey",
    SUM(MrkPresent) as "MrkPresent",
    SUM(MrkRequired) as "MrkRequired",
    DIV0(SUM(MrkPresent), SUM(MrkRequired)) as "AttendanceRate"
FROM CURRICULUM_DB.int.int_attendance
GROUP BY 1, 2
    )
;


  