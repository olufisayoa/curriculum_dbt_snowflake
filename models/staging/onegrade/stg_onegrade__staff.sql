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
from {{ source('Onegrade', 'ONEGRADE_STAFF') }}