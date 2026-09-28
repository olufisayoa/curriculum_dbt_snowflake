SELECT 
OfferingID,
Code,
Name,
StaffID,
Surname,
FirstName,
StaffRefNo,
Description,
FullName
FROM {{ source('ProSolution', 'PROSOLUTION_OFFERINGMAINSTAFF') }}