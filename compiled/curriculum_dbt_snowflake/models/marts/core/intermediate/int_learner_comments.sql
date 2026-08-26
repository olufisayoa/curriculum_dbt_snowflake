SELECT 
    md5(cast(coalesce(cast(ActionPlan.ActionPlanID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS ActionPlanKey,
    md5(cast(coalesce(cast(vStudent.AcademicYearID as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(vStudent.StudentID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
    md5(cast(coalesce(cast(MT.MeetingTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS MeetingTypeKey,
    md5(cast(coalesce(cast(ActionPlan.CommentTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CommentTypeKey,
    md5(cast(coalesce(cast(ActionPlan.ActionTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS ActionTypeKey,
    md5(cast(coalesce(cast(TRIM(vStudent.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey,
	(YEAR(ActionPlan.CommentDate) * 10000 + MONTH(ActionPlan.CommentDate) * 100 + DAY(ActionPlan.CommentDate)) AS DateKey, 
    CommentStaff.StaffName AS CommentStaffName, 
    CASE 
		WHEN ActionPlan.CommentDate IS NOT NULL THEN 1
		ELSE 0
	END AS IncludesComment,  
    ActionType.ActionTypeDescription AS Reason

FROM CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan AS ActionPlan 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_tutorial AS Tutorial
    ON Tutorial.TutorialID = ActionPlan.TutorialID 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__ilp_meetingtype AS MT
    ON Tutorial.TutorialTypeID = MT.MeetingTypeID 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor_ilp_meetingcategory AS MC
    ON MC.MeetingCategoryID = MT.MeetingCategoryID
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__staff AS CommentStaff 
    ON ActionPlan.CommentStaffID = CommentStaff.StaffID 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_commenttype AS CommentType 
    ON ActionPlan.CommentTypeID = CommentType.CommentTypeID 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__student AS vStudent
    ON ActionPlan.PMStudentID = vStudent.PMStudentID 
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_actiontype AS ActionType
    ON ActionPlan.ActionTypeID = ActionType.ActionTypeID