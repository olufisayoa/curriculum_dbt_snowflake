
  
    

create or replace transient table CURRICULUM_DB.int.int_consolidated_student_detail
    
    
    
    as (WITH Prosolution_Student AS (
		SELECT  
           s.StudentKey AS StudentKey,
              s.StudentDetailID AS StudentDetailID,
			CAST(s.AcademicYearID AS VARCHAR)                                 AS AcademicYearID,
			CAST(s.RefNo AS VARCHAR)                                        AS StudentID,
			CAST(s.FirstForename AS VARCHAR)                               AS FirstName,
			CAST(s.Surname AS VARCHAR)                                     AS Surname,
			CAST(TRIM(s.FirstForename) || ' ' ||
                   TRIM(s.Surname) || ' (' ||
                   TRIM(s.RefNo)  || ')' AS VARCHAR) AS StudentFullname,
			CAST(s.DateOfBirth AS TIMESTAMP)                                      AS DOB,
			CAST(s.Sex AS VARCHAR)                                              AS Gender,
			CAST(CASE WHEN s.FreeMealsEligibilityID IN (1,2) THEN 'Yes' ELSE 'No' END AS VARCHAR) AS Disadvantaged,
			CAST(CASE COALESCE(s.ReceivedFreeSchoolMeals, 0) WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS FreeSchoolMeals,
			CAST(CASE COALESCE(s.HighNeedsStudent, 0) WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS HighNeeds,
			CAST(CASE COALESCE(s.CareLeaver, 0)       WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS CareLeaver,
			CAST(CASE COALESCE(s.LookedAfter, 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS LookedAfter,
			CAST(CASE COALESCE(s.HasEducationHealthCarePlan, 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS EducationHealthCarePlan,
			CAST(CASE COALESCE(s.HasSpecialEducationNeeds, 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS SEND,
	CAST(CASE
        WHEN (
                (s.HasEducationHealthCarePlan = 1) OR
                (s.HasSpecialEducationNeeds = 1) OR
                (s.LearningDiffOrDisID IS NOT NULL AND s.LearningDiffOrDisID <> '0') 
            )
            AND
            (
                (s.ALSRequested = 1) OR
                (s.ALSRequired = 1) OR
                (s.HasDisabledStudentsAllowance = 1) OR
                (s.AdditionalLearningSupportLevelID IS NOT NULL AND s.AdditionalLearningSupportLevelID <> '0') OR
                (s.LearnerSupportType1ID IS NOT NULL AND s.LearnerSupportType1ID <> '0') OR
                (s.LearnerSupportType2ID IS NOT NULL AND s.LearnerSupportType2ID <> '0') OR
                (s.LearnerSupportType3ID IS NOT NULL AND s.LearnerSupportType3ID <> '0') OR
                (s.LearnerSupportType4ID IS NOT NULL AND s.LearnerSupportType4ID <> '0') OR
                (s.LearnerSupportType5ID IS NOT NULL AND s.LearnerSupportType5ID <> '0') OR
                (s.SupportNeed1ID IS NOT NULL AND s.SupportNeed1ID <> 0) OR
                (s.SupportNeed2ID IS NOT NULL AND s.SupportNeed2ID <> 0) OR
                (s.SupportNeed3ID IS NOT NULL AND s.SupportNeed3ID <> 0)
            )
        THEN 'Yes'
        ELSE 'No'
    END AS VARCHAR) AS SENDWithALSSupport,
			CAST(COALESCE(eg.Description, 'Not provided') AS VARCHAR)        AS EthnicGroup,
			CAST(CASE COALESCE(s.Safeguarding, 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS Safeguarding,
			CAST(CASE COALESCE(s.YoungCarer, 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS YoungCarer,
			CAST(CASE WHEN COALESCE(s.YoungCarer, 0)=1  AND s.Safeguarding=1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS WelfareCaseload,
			CAST(CASE COALESCE(s.EstrangedFromParents , 0)      WHEN 1 THEN 'Yes' ELSE 'No' END AS VARCHAR) AS EstrangedFromParents,
			CAST(CASE  WHEN s.GCSEEnglishQualificationGrade IN ( '4', '5', '6', '7', '8', '9', 'A*', 'A', 'B', 'C', 'A*A', 'AA', 'AB', 'BB', 'BC', 'CC' ) THEN 'Yes' ELSE 'No' END AS VARCHAR) AS AchievedEnglish,
			CAST(CASE  WHEN s.GCSEMathsQualificationGrade IN ( '4', '5', '6', '7', '8', '9', 'A*', 'A', 'B', 'C', 'A*A', 'AA', 'AB', 'BB', 'BC', 'CC' ) THEN 'Yes' ELSE 'No' END AS VARCHAR) AS AchievedMaths,
			CAST(COALESCE(ls."LearnerStatus" , 'Not Provided') AS VARCHAR)     AS RiskAssessment,
			
			CASE 
				WHEN s.DateOfBirth IS NOT NULL AND Y.Aug31Date IS NOT NULL 
				THEN FLOOR(DATEDIFF(DAY, s.DateOfBirth, Y.Aug31Date) / 365.25)
				ELSE NULL
			END AS AgeAt31Aug,
    
			CAST(CASE 
				WHEN s.DateOfBirth IS NULL OR Y.Aug31Date IS NULL THEN '19+'
				WHEN FLOOR(DATEDIFF(DAY, s.DateOfBirth, Y.Aug31Date) / 365.25) >= 24 THEN '24+'
				WHEN FLOOR(DATEDIFF(DAY, s.DateOfBirth, Y.Aug31Date) / 365.25) >= 19 THEN '19-23'
				WHEN FLOOR(DATEDIFF(DAY, s.DateOfBirth, Y.Aug31Date) / 365.25) >= 16 THEN '16-18'
				WHEN FLOOR(DATEDIFF(DAY, s.DateOfBirth, Y.Aug31Date) / 365.25) >= 14 THEN '14-15'
				ELSE 'U14'
			END AS VARCHAR) AS AgeGroupAt31Aug1,
		  'data:image/png;base64,' || COALESCE(BASE64_ENCODE(sp.THUMBNAIL), '') AS StudentPhotoThumbnail,
		  CONCAT('https://pro.the-etc.ac.uk/ProMonitor/ilp/information/details.aspx?pmstudentid=', sm.StudentCode) AS StudentProfileUrl

		FROM CURRICULUM_DB.stg.stg_prosolution__student AS s
		LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__student_code_mapping AS sm
			   ON TRIM(s.AcademicYearID) = TRIM(sm.AcademicYearID)    
                AND TRIM(s.RefNo) = TRIM(sm.StudentID)
		LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__studentphoto  AS sp
		ON s.StudentID=sp.StudentID
		LEFT  JOIN CURRICULUM_DB.stg.stg_prosolution__ethnicgroup  AS eg  
					ON s.EthnicGroupID = eg.EthnicGroupID
		LEFT JOIN	CURRICULUM_DB.stg.stg_prosolution__learnerinformation_learnerstatus AS ls
                    ON TRIM(s.LEARNERSTATUSID) = TRIM(ls."LearnerStatusID") 
		LEFT JOIN (
			SELECT  AcademicYearID,
					CAST(CONCAT(YEAR(StartDate), '-08-31') AS DATE) AS Aug31Date
			FROM    CURRICULUM_DB.stg.stg_prosolution__academicyear
		) Y 
			ON TRIM(s.AcademicYearID) = TRIM(Y.AcademicYearID)

	)
,
	Onegrade_Student AS (
		SELECT 
             _os.StudentKey AS StudentKey
			  ,_os.AcademicYearID
			  ,_os.StudentRef
			  ,_os.Surname
			  ,_os.Forenames
			  ,_os.DOB
			  ,_os.EthnicityID
			  ,_os.Gender
			  ,_os.TutorGroupCode
			  ,_os.FreeSchoolMeal
		  FROM CURRICULUM_DB.stg.stg_onegrade__student as _os
	)
,
Comment_Agg AS (
	SELECT 
	 "StudentKey",
	 SUM(CASE WHEN "IncludesComment" = TRUE THEN 1 ELSE 0 END) AS TotalComments
	 FROM CURRICULUM_DB.core.fct_learner_comments
	 GROUP BY "StudentKey"
),
Badges AS (
	WITH RankedBadges AS (
		SELECT 
		md5(cast(coalesce(cast(TRIM(S.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(S.StudentID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
		B.BadgeName,
		BV.BadgeValueName,
		ROW_NUMBER() OVER (PARTITION BY S.AcademicYearID, S.StudentID, B.BadgeName ORDER BY BS.AuditDateCreated DESC) AS rn
		FROM  CURRICULUM_DB.stg.stg_promonitor__student AS S
		LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgestudent AS BS ON S.PMStudentID = BS.PMStudentID
		LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badge AS B ON B.BadgeID = BS.BadgeID
		LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgevalue AS BV ON BV.BadgeValueID = BS.BadgeValueID
		WHERE COALESCE(BV.IsObsolete, 0) = 0 AND B.BadgeName IN ('Safeguarding', 'Welfare', 'Attendance')
	)
	SELECT
		RB.StudentKey,
		MAX(CASE WHEN RB.BadgeName = 'Safeguarding' THEN RB.BadgeValueName ELSE '-' END) AS SafeguardingFlag,
		MAX(CASE WHEN RB.BadgeName = 'Welfare' THEN RB.BadgeValueName ELSE '-' END) AS WelfareFlag,
		MAX(CASE WHEN RB.BadgeName = 'Attendance' THEN RB.BadgeValueName ELSE '-' END) AS AttendanceFlag
	FROM RankedBadges RB
	WHERE RB.rn=1
	GROUP BY RB.StudentKey
 ),
 Progression AS (
	SELECT 
	md5(cast(coalesce(cast(TRIM(S.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(S.StudentID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
	P.Information1 AS Progression
	FROM CURRICULUM_DB.stg.stg_promonitor__learnerinformation_progression P
	LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__student S ON P.PMStudentID=S.PMStudentID
 )
	SELECT 
          ps.StudentKey AS "StudentKey",
          CAST(COALESCE(TRIM(ps.AcademicYearID), '00/00') AS VARCHAR) AS "AcademicYear",
		  CAST(COALESCE(ps.StudentID, '-') AS VARCHAR) AS "StudentID",
		  CAST(COALESCE(ps.FirstName,'-') AS VARCHAR) AS "Firstname",
		  CAST(COALESCE(ps.Surname,'-') AS VARCHAR) AS "Surname",
		  CAST(COALESCE(ps.StudentFullname,'-') AS VARCHAR) AS "StudentFullname",
		  CAST(COALESCE(ps.DOB,'1753-01-01') AS TIMESTAMP) AS "DOB",
		  CAST(COALESCE(ps.AgeAt31Aug,0) AS VARCHAR) AS "AgeAt31Aug",
		  CAST(COALESCE(ps.AgeGroupAt31Aug1,'-') AS VARCHAR) AS "AgeGroupAt31Aug1",
		  CAST(COALESCE(ps.Gender, '-') AS VARCHAR) AS "Gender",
		  CAST(COALESCE(ps.FreeSchoolMeals,'No') AS VARCHAR) AS "FreeSchoolMeals",
		  CAST(COALESCE(ps.Disadvantaged,'No') AS VARCHAR) AS "Disadvantaged",
		  CAST(COALESCE(ps.EducationHealthCarePlan,'No') AS VARCHAR) AS "EducationHealthCarePlan",
		  CAST(COALESCE(ps.CareLeaver,'No') AS VARCHAR) AS "CareLeaver",
		  CAST(COALESCE(ps.LookedAfter,'No') AS VARCHAR) AS "LookedAfter",
		  CAST(COALESCE(ps.HighNeeds,'No') AS VARCHAR) AS "HighNeeds",
		  CAST(COALESCE(ps.EthnicGroup, 'unknown') AS VARCHAR) AS "EthnicGroup",
		  CAST(COALESCE(ps.SEND,'No') AS VARCHAR) AS "SEND",
		  CAST(COALESCE(ps.EstrangedFromParents,'No') AS VARCHAR) AS "EstrangedFromParents",
		  CAST(COALESCE(ps.SENDWithALSSupport,'No') AS VARCHAR) AS "SENDWithALSSupport",
		  CAST(COALESCE(ps.AchievedEnglish,'No') AS VARCHAR) AS "AchievedEnglish",
		  CAST(COALESCE(ps.AchievedMaths,'No') AS VARCHAR) AS "AchievedMaths",
		  CAST(COALESCE(ps.RiskAssessment,'-') AS VARCHAR) AS "RiskAssessment",
		  CAST(COALESCE(ps.Safeguarding,'No') AS VARCHAR) AS "Safeguarding",
		  COALESCE(ca.TotalComments, 0) AS "TotalComments",
		  COALESCE(p.Progression, '-') AS "Progression",
		  CAST(COALESCE(b.SafeguardingFlag, '-') AS VARCHAR) AS "SafeguardingFlag",
		  CASE WHEN b.SafeguardingFlag = 'Child In Our Care' THEN -4 
		  	WHEN b.SafeguardingFlag = 'Known to Safeguarding' THEN -3
			WHEN b.SafeguardingFlag = 'Care Experienced' THEN -2
    		WHEN b.SafeguardingFlag = 'Safeguarding Closed' THEN 0
    		ELSE 0 
			END AS SafeguardingScore,
		  CAST(COALESCE(b.WelfareFlag, '-') AS VARCHAR) AS "WelfareFlag",
		  CASE WHEN b.WelfareFlag = 'Know to Welfare' THEN -1
		  	WHEN b.WelfareFlag = 'Welfare Closed' THEN 0
			ELSE 0 
		  END AS WelfareScore,
		  CAST(COALESCE(b.AttendanceFlag, '-') AS VARCHAR) AS "AttendanceFlag",
		  CAST(COALESCE(ps.StudentPhotoThumbnail,'-') AS VARCHAR) AS "StudentPhotoThumbnail",
		  CAST(COALESCE(ps.StudentProfileUrl, '-') AS VARCHAR) AS "StudentProfileUrl"
	FROM Prosolution_Student AS ps
	LEFT JOIN Onegrade_Student AS _os
	 ON TRIM(ps.AcademicYearID) = TRIM(_os.AcademicYearID) AND TRIM(ps.StudentID) = TRIM(_os.StudentRef)
	LEFT JOIN Comment_Agg AS ca
	 ON ps.StudentKey = ca."StudentKey"
	LEFT JOIN Badges AS b
	 ON ps.StudentKey = b.StudentKey
	 LEFT JOIN Progression AS p
	 ON ps.StudentKey = p.StudentKey
    )
;


  