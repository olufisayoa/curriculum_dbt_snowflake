select * 
from {{ source('Onegrade', 'ONEGRADE_COMPLETION') }}