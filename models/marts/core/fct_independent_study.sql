SELECT  
	StudentKey AS "StudentKey",
	CardNumber AS "CardNumber",
	StudentID AS "StudentID",
	DateKey AS "DateKey",
	TapInTime AS "TapInTime",
	TapOutTime AS "TapOutTime",
	DurationInHours AS "DurationInHours"
FROM {{ ref('int_independent_study') }}
