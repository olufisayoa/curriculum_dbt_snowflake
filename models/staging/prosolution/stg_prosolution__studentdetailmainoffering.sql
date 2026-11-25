SELECT 
    StudentDetailID,
    Name         AS MainOfferingCollegeLevelName,
    OfferingName AS MainOfferingName,
    SID,
    SiteDescription AS StudentMainSite
FROM {{ source('ProSolution', 'PROSOLUTION_VSTUDENTDETAILMAINOFFERING') }}