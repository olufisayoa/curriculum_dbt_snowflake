SELECT
Tutorial.TutorialID,
Tutorial.TutorialTypeID,
Tutorial.TutorialDate
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_TUTORIAL') }} Tutorial