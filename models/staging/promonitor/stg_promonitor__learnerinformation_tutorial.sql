SELECT
Tutorial.TutorialID,
Tutorial.TutorialTypeID,
Tutorial.TutorialDate,
Tutorial.CancelledWhen,
Tutorial.DidNotTakePlace,
Tutorial.PMStudentID
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_TUTORIAL') }} Tutorial