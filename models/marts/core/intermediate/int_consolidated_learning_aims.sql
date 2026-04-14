WITH DistinctOneGradeLearningAims AS (
        SELECT DISTINCT
            e.LearningAimRef AS LearningAimRef,
            e.WholeQualID AS WholeQualID,
            e.LearningAimTitle AS LearningAimTitle
        FROM {{ ref('stg_onegrade__estactva') }} e
    ),
  EnrichedOneGradeLearningAims AS (
        SELECT 
            ola.LearningAimRef,
            ola.WholeQualID,
            vla.Size,
            vla.QualType AS Cohort,
            vla.ValueAddedType,
            vla.GradeRange,
			ola.LearningAimTitle,
			 CAST(CASE 
                WHEN vla.ValueAddedType IS NOT NULL THEN 1 
                WHEN ofq."OverallGradingType" = 'Graded' THEN 1 
                ELSE 0 
            END AS BOOLEAN) AS IsGraded,
			ofq."QualificationLevel" AS QualificationLevel,
        CASE WHEN EXISTS (
                SELECT 1 FROM {{ ref('stg_onegrade__qualificationlearningaimcollege') }} coll 
                WHERE coll."LearningAimRef" = ola.LearningAimRef
                UNION
                SELECT 1 FROM {{ ref('stg_onegrade__qualificationlearningaimcoursecollege') }} ccoll 
                WHERE ccoll."LearningAimRef" = ola.LearningAimRef
            ) THEN 1 ELSE 0 END  AS CollegeMapped,
			 CASE 
                WHEN EXISTS (SELECT 1 FROM {{ ref('stg_onegrade__ca_learningaimacyr_scope')}} s WHERE s."LearningAimRef" = ola.LearningAimRef) THEN 1
                WHEN EXISTS (SELECT 1 FROM {{ ref('stg_onegrade__appliedgeneral_scope') }} s WHERE s."LearningAimRef" = ola.LearningAimRef) THEN 1
                WHEN EXISTS (SELECT 1 FROM {{ ref('stg_onegrade__l3va_techlevel_scope') }} s WHERE s."LearningAimRef" = ola.LearningAimRef) THEN 1
                ELSE 0 
            END AS InScope,
            CASE 
                WHEN ola.LearningAimTitle LIKE '%GCSE%English%' 
                  OR ola.LearningAimTitle LIKE '%GCSE%Math%' 
                  OR ola.LearningAimTitle LIKE '%Functional Skills%English%' 
                  OR ola.LearningAimTitle LIKE '%Functional Skills%Math%'
                THEN 1 ELSE 0 
            END AS IsMathsOrEnglish,
            
            CASE 
                WHEN vla.NOTIONALNVQLEVEL NOT LIKE '%3%' OR ola.LearningAimTitle LIKE '%Extended Project%'THEN 0
                WHEN vla.QualType NOT IN ('A level', 'Academic') THEN 0
                WHEN TRIM(vla.DC) LIKE 'RB%' 
                OR TRIM(vla.DC) IN ('2210','2230','2330','2340')                    THEN TRUE
                WHEN TRIM(vla.DC) IN ('FC4','5110')                                   THEN TRUE
                WHEN TRIM(vla.DC) LIKE 'RH3%' OR TRIM(vla.DC) = '1010'                 THEN TRUE
                WHEN TRIM(vla.DC) LIKE 'RD1%' OR TRIM(vla.DC) = '1110'                 THEN TRUE
                WHEN TRIM(vla.DC) LIKE 'RC1%' OR TRIM(vla.DC) LIKE 'RC5%' 
                OR TRIM(vla.DC) = '1210'                                            THEN TRUE
                WHEN TRIM(vla.DC) LIKE 'RF%'  OR TRIM(vla.DC) = '3910'                 THEN TRUE
                WHEN TRIM(vla.DC) LIKE 'DB%'  OR TRIM(vla.DC) = '4010'                 THEN TRUE
                WHEN (TRIM(vla.DC) LIKE 'F%' OR TRIM(vla.DC) LIKE 'G%' OR TRIM(vla.DC) LIKE 'H%')
                    AND TRIM(vla.DC) NOT LIKE 'FC%' 
                    AND TRIM(vla.DC) NOT LIKE 'FK2%' 
                    AND TRIM(vla.DC) NOT LIKE 'FKA%' 
                OR TRIM(vla.DC) IN ('5650','5670','5750','5690','6610','6550')     THEN TRUE
                ELSE FALSE 
            END AS IsFacilitatingSubject,
            vla.DC AS DC,
        sl."SubjectName" AS SectorSubjectArea
                    
        FROM DistinctOneGradeLearningAims ola    
        LEFT JOIN {{ ref('stg_onegrade__learningaim')}} vla 
            ON vla.LearningAimRef = ola.LearningAimRef
            AND (
                COALESCE(vla.WholeQualID,'') = COALESCE(ola.WholeQualID,'')
            )
		
		LEFT JOIN {{ ref('stg_onegrade__ofqual') }} ofq ON ofq."QualificationNumber" = ola.LearningAimRef 
        LEFT JOIN {{ ref('stg_onegrade__qualification_lookup') }} ql ON ql."WholeQualID" = ola.WholeQualID
        LEFT JOIN {{ ref('stg_onegrade__subject_lookup') }} sl ON ql."SubjectID" = sl."ID"
  )
    SELECT 
    {{ dbt_utils.generate_surrogate_key([
    'TRIM(LearningAimRef)', 'TRIM(WholeQualID)']) }} AS "LearningAimKey",
        CAST(COALESCE(LearningAimRef,'-') AS NVARCHAR(20)) AS "LearningAimRef",
        CAST(COALESCE(LearningAimTitle,'-') AS NVARCHAR(255)) AS "LearningAimTitle",
         CAST(COALESCE(Cohort,'-') AS NVARCHAR(50)) AS "Cohort",
        CAST(COALESCE(QualificationLevel,'-') AS NVARCHAR(20)) AS "QualificationLevel",
        CAST(COALESCE(IsMathsOrEnglish,0) AS BOOLEAN) AS "IsMathsOrEnglish",
        CAST(COALESCE(IsGraded,0) AS BOOLEAN) AS "IsGraded",
        CAST(COALESCE(CollegeMapped,0) AS BOOLEAN) AS "CollegeMapped",
        CAST(COALESCE(InScope,0) AS BOOLEAN) AS "InScope",
		CAST(COALESCE(IsFacilitatingSubject,0) AS BOOLEAN) AS "IsFacilitatingSubject",
        CAST(COALESCE(SectorSubjectArea,'-') AS NVARCHAR(150)) AS "SectorSubjectArea",
        CAST(COALESCE(WholeQualID,'-') AS NVARCHAR(20)) AS "WholeQualID",
        CAST(COALESCE(DC,'-') AS NVARCHAR(20)) AS "DC"
    FROM EnrichedOneGradeLearningAims
    