SELECT 
{{ dbt_utils.generate_surrogate_key(['BV.BadgeValueID']) }} AS "BadgeValueKey",
B.BadgeName AS "BadgeName",
BV.BadgeValueName AS "BadgeValueName",
BV.BadgeCode AS "BadgeCode",
CAST(BV.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM {{ ref('stg_promonitor__learnerinformation_badgevalue') }} BV
JOIN {{ ref('stg_promonitor__learnerinformation_badge') }} B ON BV.BadgeID = B.BadgeID