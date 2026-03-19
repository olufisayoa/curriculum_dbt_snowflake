WITH dim_site AS (
SELECT 
       {{ dbt_utils.generate_surrogate_key(['SiteID']) }} AS SiteKey
      ,s.Code
      ,s.Description
      ,s.Address1
      ,s.Address2
      ,s.Address3
      ,s.Address4
      ,s.PostcodeOut
      ,s.PostcodeIn
      ,s.Tel
      ,s.Fax
      ,s.Enabled
FROM {{ ref('stg_prosolution_site') }} s
)

SELECT * FROM dim_site