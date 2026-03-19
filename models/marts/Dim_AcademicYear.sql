WITH Dim_AcademicYear AS (
SELECT 
       {{ dbt_utils.generate_surrogate_key(['"AcademicYearID"']) }} AS "AcademicYearKey"
      ,"AcademicYearID" AS "AcademicYear"
      ,"StartDate"
      ,"EndDate"
      ,"Number"
FROM {{ ref('Stg_ProSolution__AcademicYear') }}

)
SELECT * FROM Dim_AcademicYear