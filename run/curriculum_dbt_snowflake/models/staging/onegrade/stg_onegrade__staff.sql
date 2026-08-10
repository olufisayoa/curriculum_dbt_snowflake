
  create or replace   view CURRICULUM_DB.stg.stg_onegrade__staff
  
  
  
  
  as (
    select 
    StaffID ,
	StaffCode ,
	UserID ,
    Title,
	Forenames,
	Surname,
	EmailAddress,
	MobileTelephone,
	Enabled,
	CreatedBy,
	CreatedDate,
	LastModifiedBy,
	LastModifiedDate
from CURRICULUM_DB.RAW.ONEGRADE_STAFF
  );

