select 
{{ dbt_utils.generate_surrogate_key(['VA_Type']) }} AS "VATypeKey",
	VA_Type
from {{ ref('int_vatype') }}