select distinct VA_Type
from {{ ref('stg_onegrade__estactva') }}