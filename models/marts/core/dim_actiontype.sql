SELECT 
{{ dbt_utils.generate_surrogate_key(['ActionType.ActionTypeID']) }} AS "ActionTypeKey",
ActionType.ActionTypeDescription AS "ActionTypeDescription",
ActionType.ActionTypeOrderBy AS "ActionTypeOrderBy",
CAST(ActionType.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM {{ ref('stg_promonitor__learnerinformation_actionplan_actiontype') }} ActionType