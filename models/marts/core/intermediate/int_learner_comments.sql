SELECT 
    {{ dbt_utils.generate_surrogate_key(['ActionPlan.ActionPlanID']) }} AS ActionPlanKey,
    {{ dbt_utils.generate_surrogate_key(['vStudent.AcademicYearID', 'vStudent.StudentID']) }} AS StudentKey,
    {{ dbt_utils.generate_surrogate_key(['MT.MeetingTypeID']) }} AS MeetingTypeKey,
    {{ dbt_utils.generate_surrogate_key(['ActionPlan.CommentTypeID']) }} AS CommentTypeKey,
    {{ dbt_utils.generate_surrogate_key(['ActionPlan.ActionTypeID']) }} AS ActionTypeKey,
	(YEAR(ActionPlan.CommentDate) * 10000 + MONTH(ActionPlan.CommentDate) * 100 + DAY(ActionPlan.CommentDate)) AS DateKey, 
    CommentStaff.StaffName AS CommentStaffName, 
    CASE 
		WHEN ActionPlan.CommentDate IS NOT NULL THEN 1
		ELSE 0
	END AS IncludesComment,  
    ActionType.ActionTypeDescription AS Reason

FROM {{ ref('stg_promonitor__learnerinformation_actionplan') }} AS ActionPlan 
LEFT JOIN {{ ref('stg_promonitor__learnerinformation_tutorial') }} AS Tutorial
    ON Tutorial.TutorialID = ActionPlan.TutorialID 
LEFT JOIN {{ ref('stg_promonitor__ilp_meetingtype') }} AS MT
    ON Tutorial.TutorialTypeID = MT.MeetingTypeID 
LEFT JOIN {{ ref('stg_promonitor_ilp_meetingcategory') }} AS MC
    ON MC.MeetingCategoryID = MT.MeetingCategoryID
LEFT JOIN {{ ref('stg_promonitor__staff') }} AS CommentStaff 
    ON ActionPlan.CommentStaffID = CommentStaff.StaffID 
LEFT JOIN {{ ref('stg_promonitor__learnerinformation_actionplan_commenttype') }} AS CommentType 
    ON ActionPlan.CommentTypeID = CommentType.CommentTypeID 
LEFT JOIN {{ ref('stg_promonitor__student') }} AS vStudent
    ON ActionPlan.PMStudentID = vStudent.PMStudentID 
LEFT JOIN {{ ref('stg_promonitor__learnerinformation_actionplan_actiontype') }} AS ActionType
    ON ActionPlan.ActionTypeID = ActionType.ActionTypeID 
