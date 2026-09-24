SELECT 
	  md5(cast(coalesce(cast(BV.BadgeValueID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS BadgeValueKey
	  ,B.BadgeName
	  ,BV.BadgeValueName
	  ,BV.BadgeCode
	  ,BV.IsObsolete
	  ,md5(cast(coalesce(cast(TRIM(S.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey
	  ,md5(cast(coalesce(cast(TRIM(S.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(S.StudentID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey
  FROM   CURRICULUM_DB.stg.stg_promonitor__student AS S
  INNER JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgestudent AS BS ON S.PMStudentID=BS.PMStudentID
  INNER JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgevalue AS BV ON BV.BadgeValueID=BS.BadgeValueID
  INNER JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badge AS B ON B.BadgeID=BV.BadgeID