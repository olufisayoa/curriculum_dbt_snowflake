
  
    

create or replace transient table CURRICULUM_DB.core.fct_learner_risk_factors
    
    
    
    as (SELECT
    r."StudentKey", r."EnrolmentKey", r."SiteKey", r."CollegeLevelKey",
    r."CourseKey", r."AcademicYearKey", r."MPKey", r."RiskBand",
    g.value:group::VARCHAR AS "RiskGrouping",
    g.value:flag::INTEGER  AS "HasConcern"
FROM CURRICULUM_DB.int.int_risk_register r,
LATERAL FLATTEN(input => ARRAY_CONSTRUCT(
    OBJECT_CONSTRUCT('group','Progress',                'flag', r."ProgressConcern"),
    OBJECT_CONSTRUCT('group','Attendance',              'flag', r."AttendanceConcern"),
    OBJECT_CONSTRUCT('group','EHCP & High Need',        'flag', r."EHCPHighNeedsConcern"),
    OBJECT_CONSTRUCT('group','Behaviour Concerns',      'flag', r."BehaviourConcern"),
    OBJECT_CONSTRUCT('group','Safeguarding & Welfare',  'flag', r."SafeguardingWelfareConcern"),
    OBJECT_CONSTRUCT('group','ProMonitor Comments',     'flag', r."ProMonitorCommentsConcern")
)) g
WHERE g.value:flag = 1
    )
;


  