

SELECT 
md5(cast(coalesce(cast(CT.CommentTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CommentTypeKey",
CT.CommentTypeID AS "CommentTypeID",
CT.CommentTypeName AS "CommentTypeName",
CAST(CT.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_commenttype CT