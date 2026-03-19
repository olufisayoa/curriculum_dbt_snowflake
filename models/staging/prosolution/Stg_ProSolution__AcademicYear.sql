SELECT 
"AcademicYearID" ,
"StartDate" ,
"EndDate",
"Number" 
FROM {{ source('ProSolution', 'ProSolution_Academic_Year') }}