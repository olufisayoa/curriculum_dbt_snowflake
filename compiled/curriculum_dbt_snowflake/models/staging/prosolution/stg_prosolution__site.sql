SELECT 
md5(cast(coalesce(cast(SiteID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "SiteKey",
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
FROM CURRICULUM_DB.RAW.PROSOLUTION_SITE