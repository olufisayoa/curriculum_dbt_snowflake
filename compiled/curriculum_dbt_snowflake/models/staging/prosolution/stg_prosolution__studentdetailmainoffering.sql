SELECT 
    StudentDetailID,
    Name         AS MainOfferingCollegeLevelName,
    OfferingName AS MainOfferingName,
    SID,
    SiteDescription AS StudentMainSite
FROM CURRICULUM_DB.RAW.PROSOLUTION_VSTUDENTDETAILMAINOFFERING