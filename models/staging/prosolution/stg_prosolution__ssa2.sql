select 
"SSA_Tier2_code" AS SSA_Tier2_Code,
"SSA_Tier2_Desc" AS SSA_Tier2_Desc
from {{ source('ProSolution', 'PROSOLUTION_SSA2') }}