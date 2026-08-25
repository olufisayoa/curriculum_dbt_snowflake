SELECT
Tutorial.TutorialID,
Tutorial.TutorialTypeID
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_TUTORIAL') }} Tutorial