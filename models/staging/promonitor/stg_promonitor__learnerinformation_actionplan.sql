SELECT
AP.ActionPlanID,
AP.ActionTypeID,
AP.CommentTypeID,
AP.CommentStaffID,
AP.CommentDate,
AP.PMStudentID,
AP.TutorialID
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_ACTIONPLAN') }} AP