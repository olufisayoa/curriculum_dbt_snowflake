WITH Dim_Site AS (
SELECT 
       {{ dbt_utils.generate_surrogate_key(['"SiteID"']) }} AS "SiteKey"
      ,"Code"
      ,"Description"
      ,"Address1"
      ,"Address2"
      ,"Address3"
      ,"Address4"
      ,"PostcodeOut"
      ,"PostcodeIn"
      ,"Tel"
      ,"Fax"
      ,"Enabled"
FROM {{ ref('Stg_ProSolution__Site') }} 
)

SELECT * FROM Dim_Site