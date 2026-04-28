select 
"EnrolmentTypeID" AS EnrolmentTypeID,
"Description" AS Description
 from {{ source('ProSolution', 'PROSOLUTION_ENROLMENTTYPE') }}