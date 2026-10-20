
  
    

create or replace transient table CURRICULUM_DB.core.fct_independent_study
    
    
    
    as (SELECT  
	StudentKey AS "StudentKey",
	CardNumber AS "CardNumber",
	StudentID AS "StudentID",
	DateKey AS "DateKey",
	TapInTime AS "TapInTime",
	TapOutTime AS "TapOutTime",
	DurationInHours AS "DurationInHours"
FROM CURRICULUM_DB.int.int_independent_study
    )
;


  