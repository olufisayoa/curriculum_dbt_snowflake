select 
md5(cast(coalesce(cast(VA_Type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "VATypeKey",
	VA_Type AS "VAType"
from CURRICULUM_DB.int.int_vatype