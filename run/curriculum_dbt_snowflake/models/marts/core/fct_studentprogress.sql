
  
    

create or replace transient table CURRICULUM_DB.core.fct_studentprogress
    
    
    
    as (select 
        AcademicYear AS "AcademicYearKey"
        , StudentKey AS "StudentKey"
        , CourseKey AS "CourseKey"
        , EnrolmentKey AS "EnrolmentKey"
        , SiteKey AS "SiteKey"
        , CollegeLevelKey "CollegeLevelKey"
        , CohortKey AS "CohortKey"
        ,  VATypeKey AS "VATypeKey"
        , LearningAimKey AS "LearningAimKey"
        , PriorAttainmentPoint AS "PriorAttainmentPoint"
        , MinimumTargetGrade AS "MinimumTargetGrade"
        , MinimumTargetGradeNo AS "MinimumTargetGradeNo"
         , AspirationalTargetGrade AS "AspirationalTargetGrade"
        , MinimumTargetPoints AS "MinimumTargetPoints"
        , PersonalTargetGrade AS "PersonalTargetGrade"
        , IYMostRecentGradeNumeric AS "IYMostRecentGradeNumeric"
        , BandingCategory AS "Banding Category"
        , MPKey AS "MPKey"
        , CurrentGrade AS "Current Grade"
        , CurrentPoint AS "Current Point"
        , ValueAdded AS "Value Added"
        , TargetBand AS "Target Band"
        , DfeRules AS "Dfe Rules"
        , QualificationSize AS "Qualification Size"
from CURRICULUM_DB.int.int_student_progress
    )
;


  