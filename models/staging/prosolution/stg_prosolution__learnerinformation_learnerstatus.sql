select *
from {{ source('ProSolution', 'PROSOLUTION_LEARNERINFORMATION_LEARNERSTATUS') }}