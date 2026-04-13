select 
{{ dbt_utils.generate_surrogate_key(['VA_Type']) }} AS "VATypeKey",
	VA_Type AS "VAType"
from {{ ref('int_vatype') }}