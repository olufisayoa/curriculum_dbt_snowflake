

SELECT			M.RegisterMarkID,
				md5(cast(coalesce(cast(TRIM(R.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey,
				md5(cast(coalesce(cast(TRIM(R.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(SD.RefNo) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
                md5(cast(coalesce(cast(TRIM(R.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(SD.RefNo) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(O.Code) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(O.QualID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(E.StartDate AS DATE) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(E.CompletionStatusID AS INTEGER) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS EnrolmentKey,
			md5(cast(coalesce(cast(R.RegisterID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS RegisterKey,
        md5(cast(coalesce(cast(TRIM(O.OfferingID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey,
				md5(cast(coalesce(cast(TRIM(O.SID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CollegeLevelKey,
				md5(cast(coalesce(cast(TRIM(O.SiteID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS SiteKey,
                md5(cast(coalesce(cast(TRIM(M.MarkTypeID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS MarkTypeKey,
                (YEAR(S.Date) * 10000) + (MONTH(S.Date) * 100) + DAY(S.Date) AS DateKey,
				CAST(S.Date AS DATE) AS RegisterSessionDate,
				CASE WHEN MT.MarkTypeStatusID = 1 THEN 1 ELSE 0 END AS MrkPresent,           
				CASE WHEN MT.MarkTypeStatusID = 0 THEN 1 ELSE 0 END AS MrkAbsent,            
				CASE WHEN MT.MarkTypeStatusID NOT IN (0,1) THEN 1 ELSE 0 END AS MrkNotReq,   

				CASE WHEN MT.MarkTypeStatusID IN (0,1) 
						 AND MT.IsAuthorisedAbsence = 1 THEN 1 ELSE 0 END AS MrkAuthAbsent,

				CASE WHEN MT.MarkTypeStatusID = 1 
						 AND MT.IsLate = 1 THEN 1 ELSE 0 END AS MrkLate,
                    
                CASE WHEN MT.MarkTypeStatusID IN (0,1) THEN 1 ELSE 0 END AS MrkRequired


FROM			CURRICULUM_DB.stg.stg_prosolution__registermark  M
JOIN            CURRICULUM_DB.stg.stg_prosolution__marktype  MT
ON				M.MarkTypeID = MT.MarkTypeID

JOIN			CURRICULUM_DB.stg.stg_prosolution__registersession  S
ON				M.RegisterSessionID = S.RegisterSessionID

JOIN			CURRICULUM_DB.stg.stg_prosolution__register  R
ON				S.RegisterID = R.RegisterID

JOIN			CURRICULUM_DB.stg.stg_prosolution__registerstudent  RS
ON				M.RegisterStudentID = RS.RegisterStudentID

LEFT JOIN		CURRICULUM_DB.stg.stg_prosolution__enrolment  E
ON				RS.EnrolmentID = E.EnrolmentID

LEFT JOIN		CURRICULUM_DB.stg.stg_prosolution__offering  O
ON				E.OfferingID = O.OfferingID

LEFT JOIN		CURRICULUM_DB.stg.stg_prosolution__student SD 
ON			    E.StudentDetailID = SD.StudentDetailID



WHERE RegisterSessionDate >= (SELECT MAX(RegisterSessionDate) FROM CURRICULUM_DB.int.int_attendance)
