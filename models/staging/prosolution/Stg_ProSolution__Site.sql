SELECT 
SiteID ,
Code ,
Description ,
Address1,
Address2 ,
Address3 ,
Address4 ,
PostcodeOut ,
PostcodeIn ,
Tel,
Fax,
Enabled 
FROM {{ source('ProSolution', 'PROSOLUTION_SITE') }}