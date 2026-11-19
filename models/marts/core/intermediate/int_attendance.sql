

{{
  config(
    materialized='incremental',
    unique_key=['RegisterMarkID'],
    incremental_strategy='merge'
  )
}}

SELECT			M.RegisterMarkID,
				{{ dbt_utils.generate_surrogate_key(['TRIM(R.AcademicYearID)']) }} AS AcademicYearKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM(R.AcademicYearID)', 'TRIM(SD.RefNo)']) }} AS StudentKey,
                {{ dbt_utils.generate_surrogate_key([
                    'TRIM(R.AcademicYearID)',   
                    'TRIM(SD.RefNo)',
                    'TRIM(O.Code)',   
                    'TRIM(O.QualID)',            
                    'CAST(E.StartDate AS DATE)'                          
                    ]) }} AS EnrolmentKey,
			{{ dbt_utils.generate_surrogate_key(['R.RegisterID']) }} AS RegisterKey,
        {{ dbt_utils.generate_surrogate_key(['O.OfferingID', 'OG.OfferingGroupID']) }} AS CourseKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM(O.SID)']) }} AS CollegeLevelKey,
				{{ dbt_utils.generate_surrogate_key(['TRIM(O.SiteID)']) }} AS SiteKey,
                {{ dbt_utils.generate_surrogate_key(['TRIM(M.MarkTypeID)']) }} AS MarkTypeKey,
                (YEAR(S.Date) * 10000) + (MONTH(S.Date) * 100) + DAY(S.Date) AS DateKey,
				CAST(S.Date AS DATE) AS RegisterSessionDate,
				CASE WHEN MT.MarkTypeStatusID = 1 AND MT.IsAuthorisedAbsence = 0 THEN 1 ELSE 0 END AS MrkPresent,           
				CASE WHEN MT.MarkTypeStatusID = 0 AND MT.IsAuthorisedAbsence = 0 THEN 1 ELSE 0 END AS MrkAbsent,              
				CASE WHEN MT.IsAuthorisedAbsence = 1 THEN 1 ELSE 0 END AS MrkAuthAbsent,
				CASE WHEN MT.MarkTypeStatusID = 1 AND MT.IsLate = 1 THEN 1 ELSE 0 END AS MrkLate,
        CASE WHEN MT.MarkTypeStatusID IN (0,1) THEN 1 ELSE 0 END AS MrkRequired,
        0 AS MrkNotReq
FROM			{{ ref('stg_prosolution__registermark') }}  M
JOIN            {{ ref('stg_prosolution__marktype') }}  MT
ON				M.MarkTypeID = MT.MarkTypeID

JOIN			{{ ref('stg_prosolution__registersession') }}  S
ON				M.RegisterSessionID = S.RegisterSessionID

JOIN			{{ ref('stg_prosolution__register') }}  R
ON				S.RegisterID = R.RegisterID

JOIN			{{ ref('stg_prosolution__registerstudent') }}  RS
ON				M.RegisterStudentID = RS.RegisterStudentID

JOIN		{{ ref('stg_prosolution__enrolment') }}  E
ON				RS.EnrolmentID = E.EnrolmentID

JOIN		{{ ref('stg_prosolution__offering') }}  O
ON				E.OfferingID = O.OfferingID

LEFT JOIN		{{ ref('stg_prosolution__offeringgroup') }} AS OG 
    ON OG.OfferingID = O.OfferingID AND E.OfferingGroupID = OG.OfferingGroupID

LEFT JOIN		{{ ref('stg_prosolution__student') }} SD 
ON			    E.StudentDetailID = SD.StudentDetailID

WHERE 1=1 
AND (E.ActualEndDate IS NULL OR S.Date <= E.ActualEndDate)
AND MT.MarkTypeStatusID IN (0,1)


{% if is_incremental() %}
AND S.Date >= DATEADD(day, -60, (SELECT MAX(RegisterSessionDate) FROM {{ this }}))
{% endif %}