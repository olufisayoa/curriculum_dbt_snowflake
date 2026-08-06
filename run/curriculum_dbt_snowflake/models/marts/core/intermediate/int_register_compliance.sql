-- back compat for old kwarg name
  
  begin;
    
        
            
                
                
            
        
    

    

    merge into CURRICULUM_DB.int.int_register_compliance as DBT_INTERNAL_DEST
        using CURRICULUM_DB.int.int_register_compliance__dbt_tmp as DBT_INTERNAL_SOURCE
        on (
                    DBT_INTERNAL_SOURCE."RegisterComplianceKey" = DBT_INTERNAL_DEST."RegisterComplianceKey"
                )

    
    when matched then update set
        "RegisterComplianceKey" = DBT_INTERNAL_SOURCE."RegisterComplianceKey","LecturerSessionKey" = DBT_INTERNAL_SOURCE."LecturerSessionKey","RegisterSessionKey" = DBT_INTERNAL_SOURCE."RegisterSessionKey","RegisterKey" = DBT_INTERNAL_SOURCE."RegisterKey","CollegeLevelKey" = DBT_INTERNAL_SOURCE."CollegeLevelKey","AcademicYearKey" = DBT_INTERNAL_SOURCE."AcademicYearKey","CourseKey" = DBT_INTERNAL_SOURCE."CourseKey","Session Date" = DBT_INTERNAL_SOURCE."Session Date","Session Start Date" = DBT_INTERNAL_SOURCE."Session Start Date","Session End Date" = DBT_INTERNAL_SOURCE."Session End Date","Session Duration" = DBT_INTERNAL_SOURCE."Session Duration","Lecturer Name" = DBT_INTERNAL_SOURCE."Lecturer Name","Students Marked" = DBT_INTERNAL_SOURCE."Students Marked","Total Students" = DBT_INTERNAL_SOURCE."Total Students","Percentage Marked" = DBT_INTERNAL_SOURCE."Percentage Marked"
    

    when not matched then insert
        ("RegisterComplianceKey", "LecturerSessionKey", "RegisterSessionKey", "RegisterKey", "CollegeLevelKey", "AcademicYearKey", "CourseKey", "Session Date", "Session Start Date", "Session End Date", "Session Duration", "Lecturer Name", "Students Marked", "Total Students", "Percentage Marked")
    values
        ("RegisterComplianceKey", "LecturerSessionKey", "RegisterSessionKey", "RegisterKey", "CollegeLevelKey", "AcademicYearKey", "CourseKey", "Session Date", "Session Start Date", "Session End Date", "Session Duration", "Lecturer Name", "Students Marked", "Total Students", "Percentage Marked")

;
    commit;