SELECT 
	  {{ dbt_utils.generate_surrogate_key(['BV.BadgeValueID']) }} AS BadgeValueKey
	  ,B.BadgeName
	  ,BV.BadgeValueName
	  ,BV.BadgeCode
	  ,BV.IsObsolete
	  ,P.Information1 AS Progression
	  ,{{ dbt_utils.generate_surrogate_key(['TRIM(S.AcademicYearID)']) }} AS AcademicYearKey
	  ,{{ dbt_utils.generate_surrogate_key(['TRIM(S.AcademicYearID)','S.StudentID']) }} AS StudentKey
  FROM   {{ ref('stg_promonitor__student') }} AS S
  INNER JOIN {{ ref('stg_promonitor__learnerinformation_badgestudent') }} AS BS ON S.PMStudentID=BS.PMStudentID
  LEFT JOIN {{ ref('stg_promonitor__learnerinformation_progression') }} AS P ON P.PMStudentID=S.PMStudentID
  INNER JOIN {{ ref('stg_promonitor__learnerinformation_badgevalue') }} AS BV ON BV.BadgeValueID=BS.BadgeValueID
  LEFT JOIN {{ ref('stg_promonitor__learnerinformation_badge') }} AS B ON B.BadgeID=BV.BadgeID