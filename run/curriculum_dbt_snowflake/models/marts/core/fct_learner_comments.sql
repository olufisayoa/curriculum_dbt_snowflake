
  
    

create or replace transient table CURRICULUM_DB.core.fct_learner_comments
    
    
    
    as (SELECT 
    ActionPlanKey AS "ActionPlanKey",
    StudentKey AS "StudentKey",
    MeetingTypeKey AS "MeetingTypeKey",
    CommentTypeKey AS "CommentTypeKey",
    ActionTypeKey AS "ActionTypeKey",
    DateKey AS "DateKey",
    CommentStaffName AS "CommentStaffName",
    CAST(IncludesComment AS BOOLEAN) AS "IncludesComment",
    Reason AS "Reason"
    FROM CURRICULUM_DB.int.int_learner_comments
    )
;


  