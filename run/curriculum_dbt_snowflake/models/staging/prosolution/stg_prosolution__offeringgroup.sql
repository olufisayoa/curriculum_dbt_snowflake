
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__offeringgroup
  
  
  
  
  as (
    SELECT 
    OfferingGroupID,
    OfferingID,
    Code,
    Description,
    BlockID,
    StaffID,
    Locked,
    MaxStudents,
    Categories,
    RoomID,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    MigrationID,
    UserDefined1,
    UserDefined2,
    UserDefined3,
    UserDefined4,
    UserDefined5,
    UserDefined6,
    UserDefined7,
    UserDefined8,
    UserDefined9,
    UserDefined10,
    UserDefined11,
    UserDefined12,
    UserDefined13,
    UserDefined14,
    UserDefined15,
    OLD_ID
FROM CURRICULUM_DB.RAW.PROSOLUTION_OFFERINGGROUP
  );

