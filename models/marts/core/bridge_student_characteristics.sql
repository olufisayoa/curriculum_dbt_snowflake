SELECT "StudentKey", 'Gender' AS Category, "Gender" AS Value FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'SEND', "SEND" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'FSM', "FreeSchoolMeals" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'EHCP', "EducationHealthCarePlan" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'Age Group', "AgeGroupAt31Aug1" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'Care Leaver', "CareLeaver" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'High Needs', "HighNeeds" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'Looked After', "LookedAfter" FROM {{ ref('dim_student') }}
UNION ALL
SELECT "StudentKey", 'Safeguarding', "Safeguarding" FROM {{ ref('dim_student') }}
