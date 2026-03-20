WITH dim_site AS (
SELECT 
       {{ dbt_utils.generate_surrogate_key(['SiteID']) }} AS "SiteKey"
      ,Code AS "Code"
      ,Description AS "Description"
      ,Address1 AS "Address1"
      ,Address2 AS "Address2"
      ,Address3 AS "Address3"
      ,Address4 AS "Address4"
      ,PostcodeOut AS "PostcodeOut"
      ,PostcodeIn AS "PostcodeIn"
      ,Tel AS "Tel"
      ,Fax AS "Fax"
      ,Enabled AS "Enabled"
FROM {{ ref('stg_prosolution__site') }} 
)

SELECT * FROM dim_site