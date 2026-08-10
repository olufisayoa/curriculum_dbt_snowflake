
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__registersessionlecturer
  
  
  
  
  as (
    SELECT 
    LecturerSessionID,
	RegisterSessionID,
	StartTime,
	EndTime,
	CreatedBy,
	CreatedDate,
	LastModifiedBy,
	LastModifiedDate,
	Duration,
	RegisterLecturerHoursTypeID,
	StaffID,
	OLD_ID,
	OLD_ID2
FROM CURRICULUM_DB.RAW.PROSOLUTION_REGISTERSESSIONLECTURER
  );

