select *
from {{ source('ProSolution', 'PROSOLUTION_OUTCOME') }}