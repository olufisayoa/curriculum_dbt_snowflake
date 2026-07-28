select 
    ID ,
	AcademicYearID,
    StaffID,
    TeachingGroupCode
from {{ source('Onegrade', 'ONEGRADE_STAFFTEACHINGGROUP') }}