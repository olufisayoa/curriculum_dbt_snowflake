
  
    

create or replace transient table CURRICULUM_DB.core.fct_learner_badges
    
    
    
    as (SELECT
       BadgeValueKey AS "BadgeValueKey"
      ,AcademicYearKey AS "AcademicYearKey"
      ,StudentKey AS "StudentKey"
	  ,BadgeName AS "BadgeName"
	  ,BadgeValueName AS "BadgeValueName"
	  ,BadgeCode AS "BadgeCode"
	  ,IsObsolete AS "IsObsolete"
	  ,Progression AS "Progression"
FROM CURRICULUM_DB.int.int_learner_badges
    )
;


  