SELECT 
{{ dbt_utils.generate_surrogate_key(['RegisterID']) }} AS RegisterKey,
RegisterNo,
Title
FROM {{ ref('stg_prosolution__register') }}