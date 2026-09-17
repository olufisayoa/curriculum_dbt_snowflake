SELECT "StudentKey", 'Gender' AS Category, "Gender" AS Value FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'SEND', "SEND" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'FSM', "FreeSchoolMeals" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'EHCP', "EducationHealthCarePlan" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'Age Group', "AgeGroupAt31Aug1" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'Care Leaver', "CareLeaver" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'High Needs', "HighNeeds" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'Looked After', "LookedAfter" FROM CURRICULUM_DB.core.dim_student
UNION ALL
SELECT "StudentKey", 'Safeguarding', "Safeguarding" FROM CURRICULUM_DB.core.dim_student