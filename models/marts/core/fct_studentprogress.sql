select 
        AcademicYear
        , StudentKey
        , CourseKey
        , EnrolmentKey
        , SiteKey
        , CollegeLevelCode
        , CohortKey
        , PriorAttainmentPoint
        , MinimumTargetGrade
        , MinimumTargetGradeNo
        , AspirationalTargetGrade
        , MinimumTargetPoints
        , PersonalTargetGrade
        , IYMostRecentGradeNumeric
        , BandingCategory
        , MPKey
        , CurrentGrade
        , CurrentPoint
        , ValueAdded
        , EnrolmentGrade
        , EnrolmentPoint
        , DfeIncluded
from {{ ref('int_student_progress') }}