SELECT
       BadgeValueKey AS "BadgeValueKey"
      ,AcademicYearKey AS "AcademicYearKey"
      ,StudentKey AS "StudentKey"
	  ,BadgeName AS "BadgeName"
	  ,BadgeValueName AS "BadgeValueName"
	  ,BadgeCode AS "BadgeCode"
	  ,IsObsolete AS "IsObsolete"
	  ,Progression AS "Progression"
FROM {{ ref('int_learner_badges') }}
	  