
  
    

create or replace transient table CURRICULUM_DB.core.dim_enrolment
    
    
    
    as (select 
"EnrolmentKey",
"AcademicYear",
"StudentID",
"CourseCode",
"CourseName",
"StartDate",
"PlannedEndDate",
"ActualEndDate",
"CompletionStatus",
"NotionalNVQLevel",
"WDNumDaysAfterStart",
"AgeOn31Aug",
"VAType",
"Cohort",
"QualificationLevel",
"StudyYear",
"EnrolmentType",
"Outcome",
"SubjectType"
"TotalPresent",
"TotalRequired",
"AttendanceRate",
"AttendanceScore"
from CURRICULUM_DB.int.int_consolidated_enrolments
    )
;


  