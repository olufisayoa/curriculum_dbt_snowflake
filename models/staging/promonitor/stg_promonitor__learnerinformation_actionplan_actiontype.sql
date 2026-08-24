SELECT 
ActionType.ID AS ActionTypeID,
ActionType.ActionDescription AS ActionTypeDescription,
ActionType.OrderBy AS ActionTypeOrderBy,
ActionType.IsObsolete AS IsObsolete
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_ACTIONPLAN_ACTIONTYPE') }} ActionType