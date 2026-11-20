
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__offeringmainstaff
  
  
  
  
  as (
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
FROM CURRICULUM_DB.RAW.PROSOLUTION_OFFERINGMAINSTAFF
  );

