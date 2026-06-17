SELECT 
md5(cast(coalesce(cast(RegisterID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS RegisterKey,
RegisterNo,
Title
FROM CURRICULUM_DB.stg.stg_prosolution__register