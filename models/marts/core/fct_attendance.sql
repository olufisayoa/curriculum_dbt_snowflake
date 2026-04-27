

SELECT	 AcademicYearKey AS "AcademicYearKey", 
	StudentKey AS "StudentKey",
    EnrolmentKey AS "EnrolmentKey",
	RegisterKey AS "RegisterKey",
	CollegeLevelKey AS "CollegeLevelKey",
	SiteKey AS "SiteKey",
    MarkTypeKey AS "MarkTypeKey",
	RegisterSessionDate AS "RegisterSessionDate",
	MrkPresent AS "MrkPresent",           
	MrkAbsent AS "MrkAbsent",            
	MrkNotReq   AS "MrkNotReq",   
    MrkAuthAbsent   AS "MrkAuthAbsent",
    MrkLate AS "MrkLate",             
    MrkRequired AS "MrkRequired"
FROM {{ ref('int_attendance') }}