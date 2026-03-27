 
SELECT 
    {{ dbt_utils.generate_surrogate_key(['TRIM(_os.AcademicYearID)','TRIM(_os.StudentRef)']) }} AS StudentKey,         
    _os.*
FROM {{ source('Onegrade', 'ONEGRADE_STUDENT') }} as _os