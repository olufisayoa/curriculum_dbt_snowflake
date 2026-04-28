

{{
  config(
    materialized='incremental',
    unique_key=['RegisterMarkID'],
    incremental_strategy='merge'
  )
}}

SELECT			M.RegisterMarkID,
				{{ dbt_utils.generate_surrogate_key(['TRIM( R.AcademicYearID)']) }} AS AcademicYearKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM( R.AcademicYearID)','TRIM(SD.RefNo)' ] ) }} AS StudentKey,
                {{ dbt_utils.generate_surrogate_key([
                    'TRIM(R.AcademicYearID)',   
                    'TRIM(SD.RefNo)',
                    'TRIM(O.Code)',   
                    'TRIM(O.QualID)',            
                    'CAST(E.StartDate AS DATE)',      
                    'CAST(E.CompletionStatusID AS INTEGER)'                            
                    ]) }} AS EnrolmentKey,
				{{ dbt_utils.generate_surrogate_key(['R.RegisterID']) }} AS RegisterKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM(O.SID)']) }} AS CollegeLevelKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM(O.SiteID)']) }} AS SiteKey,
                {{ dbt_utils.generate_surrogate_key(['TRIM(M.MarkTypeID)']) }} AS MarkTypeKey,
				CAST(S.Date AS DATE) AS RegisterSessionDate,
				CASE WHEN MT.MarkTypeStatusID = 1 THEN 1 ELSE 0 END AS MrkPresent,           
				CASE WHEN MT.MarkTypeStatusID = 0 THEN 1 ELSE 0 END AS MrkAbsent,            
				CASE WHEN MT.MarkTypeStatusID NOT IN (0,1) THEN 1 ELSE 0 END AS MrkNotReq,   

				CASE WHEN MT.MarkTypeStatusID IN (0,1) 
						 AND MT.IsAuthorisedAbsence = 1 THEN 1 ELSE 0 END AS MrkAuthAbsent,

				CASE WHEN MT.MarkTypeStatusID = 1 
						 AND MT.IsLate = 1 THEN 1 ELSE 0 END AS MrkLate,
                    
                CASE WHEN MT.MarkTypeStatusID IN (0,1) THEN 1 ELSE 0 END AS MrkRequired


FROM			{{ ref('stg_prosolution__registermark') }}  M
JOIN            {{ ref('stg_prosolution__marktype') }}  MT
ON				M.MarkTypeID = MT.MarkTypeID

JOIN			{{ ref('stg_prosolution__registersession') }}  S
ON				M.RegisterSessionID = S.RegisterSessionID

JOIN			{{ ref('stg_prosolution__register') }}  R
ON				S.RegisterID = R.RegisterID

JOIN			{{ ref('stg_prosolution__registerstudent') }}  RS
ON				M.RegisterStudentID = RS.RegisterStudentID

LEFT JOIN		{{ ref('stg_prosolution__enrolment') }}  E
ON				RS.EnrolmentID = E.EnrolmentID

LEFT JOIN		{{ ref('stg_prosolution__offering') }}  O
ON				E.OfferingID = O.OfferingID

LEFT JOIN		{{ ref('stg_prosolution__student') }} SD 
ON			    E.StudentDetailID = SD.StudentDetailID


{% if is_incremental() %}
WHERE RegisterSessionDate >= (SELECT MAX(RegisterSessionDate) FROM {{ this }})
{% endif %}