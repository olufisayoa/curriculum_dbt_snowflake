

SELECT			R.AcademicYearID,
				SD.RefNo,
				E.StartDate,
				E.CompletionStatusID AS CompletionStatus,
				O.Code AS CourseCode,
				O.QualID AS LearningAimRef,
				O.Name AS CourseTile,
				R.RegisterID,
				O.SID,
				O.SiteID,
				CAST(S.Date AS DATE) AS RegisterSessionDate,
				M.MarkTypeID,
				SUM(CASE WHEN MT.MarkTypeStatusID = 1 THEN 1 ELSE 0 END) AS MrkPresent,           
				SUM(CASE WHEN MT.MarkTypeStatusID = 0 THEN 1 ELSE 0 END) AS MrkAbsent,            
				SUM(CASE WHEN MT.MarkTypeStatusID NOT IN (0,1) THEN 1 ELSE 0 END) AS MrkNotReq,   

				SUM(CASE WHEN MT.MarkTypeStatusID IN (0,1) 
						 AND MT.IsAuthorisedAbsence = 1 THEN 1 ELSE 0 END) AS MrkAuthAbsent,

				SUM(CASE WHEN MT.MarkTypeStatusID = 1 
						 AND MT.IsLate = 1 THEN 1 ELSE 0 END) AS MrkLate,
    
				CAST(
					CASE WHEN SUM(CASE WHEN MT.MarkTypeStatusID IN (0,1) THEN 1 ELSE 0 END) = 0 
						 THEN 0 
						 ELSE CAST(
									  SUM(CASE WHEN MT.MarkTypeStatusID = 1 THEN 1 ELSE 0 END) AS decimal(6,3)) 
							/ CAST(
									  SUM(CASE WHEN MT.MarkTypeStatusID IN (0,1) THEN 1 ELSE 0 END) AS decimal(6,3))
				END AS decimal(6,3)) AS PcntAtt


FROM			{{ ref('stg_prosolution__registermark') }}  M
JOIN            {{ ref('stg_prosolution__marktype') }}  MT
ON				M.MarkTypeID = MT.MarkTypeID

JOIN			{{ ref('stg_prosolution__registersession') }}  S
ON				M.RegisterSessionID = S.RegisterSessionID

JOIN			{{ ref('stg_prosolution__register') }}  R
ON				S.RegisterID = R.RegisterID

JOIN			{{ ref('stg_prosolution__registerstudent') }}  T
ON				M.RegisterStudentID = T.RegisterStudentID

JOIN			{{ ref('stg_prosolution__enrolment') }}  E
ON				T.EnrolmentID = E.EnrolmentID

JOIN			{{ ref('stg_prosolution__offering') }}  O
ON				E.OfferingID = O.OfferingID

JOIN			{{ ref('stg_prosolution__student') }} SD 
ON				E.StudentDetailID = SD.StudentDetailID

WHERE MT.MarkTypeStatusID IN (0,1)

GROUP BY
	R.AcademicYearID,
	SD.RefNo,
	E.StartDate,
	E.CompletionStatusID ,
	O.Code ,
	O.QualID ,
	O.Name,
	R.RegisterID,
	O.SID,
	O.SiteID,
	S.Date,
	M.MarkTypeID