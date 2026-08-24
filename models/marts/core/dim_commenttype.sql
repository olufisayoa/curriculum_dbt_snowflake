{{ config(materialized='table') }}

SELECT 
{{ dbt_utils.generate_surrogate_key(['CT.CommentTypeID']) }} AS "CommentTypeKey",
CT.CommentTypeID AS "CommentTypeID",
CT.CommentTypeName AS "CommentTypeName",
CAST(CT.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM {{ ref('stg_promonitor__learnerinformation_actionplan_commenttype') }} CT