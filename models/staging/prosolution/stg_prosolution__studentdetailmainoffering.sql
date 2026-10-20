SELECT 
    StudentDetailID,
    Name         AS MainOfferingCollegeLevelName,
    OfferingName AS MainOfferingName,
    SiteDescription AS StudentMainSite
FROM {{ source('ProSolution', 'PROSOLUTION_VSTUDENTDETAILMAINOFFERING') }}