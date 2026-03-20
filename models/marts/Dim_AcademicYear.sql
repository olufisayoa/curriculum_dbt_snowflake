WITH dim_academicyear AS (
SELECT 
       {{ dbt_utils.generate_surrogate_key(['AcademicYearID']) }} AS "AcademicYearKey"
      ,AcademicYearID AS "AcademicYear"
      ,StartDate AS "StartDate"
      ,EndDate AS "EndDate"
      ,Number AS "Number"
FROM {{ ref('stg_prosolution__academicyear') }} 

)
SELECT * FROM dim_academicyear