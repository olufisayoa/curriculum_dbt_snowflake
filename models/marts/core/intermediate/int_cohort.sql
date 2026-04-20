select distinct Cohort
from {{ ref('stg_onegrade__estactva') }}