WITH college_offerrings AS (
    SELECT DISTINCT 
        O.AcademicYearID,
        O.QualID AS LearningAimRef
    FROM CURRICULUM_DB.stg.stg_prosolution__offering O
    WHERE O.QualID IS NOT NULL
),
learning_aim_details AS (
    SELECT 
        LA.LEARNING_AIM_REF,
        LAT.LEARNING_AIM_TYPE_DESC      AS QualificationTypeName,
        LA.NOTIONAL_NVQ_LEVEL_CODE       AS NVQLevel,
        LA.LEARNING_AIM_TYPE_CODE,
        LA.LEARNING_AIM_TITLE,
        s1.SSA_Tier1_Desc                AS SectorSubjectArea1,
        s2.SSA_Tier2_Desc                AS SectorSubjectArea2
    FROM CURRICULUM_DB.stg.stg_prosolution__learningaim LA
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__learningaim_types LAT 
        ON LA.Learning_Aim_Type_Code = LAT.Learning_Aim_Type_Code
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__ssa1 s1 
        ON LA.SSA1ID = s1.SSA_Tier1_Code
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__ssa2 s2 
        ON LA.SSA2ID = s2.SSA_Tier2_code
),

enriched_learning_aims AS (
        SELECT 
           co.AcademicYearID,
            lad.LEARNING_AIM_REF                  AS LearningAimRef,
            lad.LEARNING_AIM_TITLE               AS LearningAimTitle,
            lad.QualificationTypeName,
            lad.NVQLevel,
            lad.SectorSubjectArea1,
            lad.SectorSubjectArea2,
            ola.WholeQualID,
			 CASE 
                WHEN EXISTS (SELECT 1 FROM CURRICULUM_DB.stg.stg_onegrade__ca_learningaimacyr_scope s WHERE s."LearningAimRef" = ola.LearningAimRef AND s."AcademicYearID" = co.AcademicYearID) THEN 1
                WHEN EXISTS (SELECT 1 FROM CURRICULUM_DB.stg.stg_onegrade__appliedgeneral_scope s WHERE s."LearningAimRef" = ola.LearningAimRef) THEN 1
                WHEN EXISTS (SELECT 1 FROM CURRICULUM_DB.stg.stg_onegrade__l3va_techlevel_scope s WHERE s."LearningAimRef" = ola.LearningAimRef) THEN 1
                ELSE 0 
            END AS InScope,
           CASE
                WHEN lad.Learning_Aim_Title LIKE '%Literature%' THEN 'Not Maths or English'
                WHEN lad.LEARNING_AIM_TYPE_CODE = '0003' AND lad.Learning_Aim_Title LIKE '%Math%' THEN 'GCSE Maths'
                WHEN lad.LEARNING_AIM_TYPE_CODE= '1439' AND lad.Learning_Aim_Title LIKE '%Math%' THEN 'FSKL Maths'
                WHEN lad.LEARNING_AIM_TYPE_CODE = '0003' AND lad.Learning_Aim_Title LIKE '%English%' THEN 'GCSE English'
                WHEN lad.LEARNING_AIM_TYPE_CODE = '1439' AND lad.Learning_Aim_Title LIKE '%English%' THEN 'FSKL English'
                ELSE 'Not Maths or English'
		    END AS MathsAndEnglish,
            
            CASE 
                WHEN lad.Learning_Aim_Title LIKE '%Extended Project%'
                    OR lad.Learning_Aim_Title LIKE '%Complementary Therapy%'
                    OR lad.Learning_Aim_Title LIKE '%Beauty Therapy%'
                    OR lad.Learning_Aim_Title LIKE '%Hair%'
                    OR lad.Learning_Aim_Title LIKE '%Hairdressing%'
                    OR lad.Learning_Aim_Title LIKE '%Barbering%'
                    OR lad.Learning_Aim_Title LIKE '%Nail Services%'
                    OR lad.Learning_Aim_Title LIKE '%Massage%'
                    OR lad.Learning_Aim_Title LIKE '%Aromatherapy%'
                    OR lad.Learning_Aim_Title LIKE '%Reflexology%'
                    OR lad.Learning_Aim_Title LIKE '%Supporting Teaching%'
                    OR lad.Learning_Aim_Title LIKE '%T Level%'
                THEN 0

                WHEN COALESCE(TRIM(lad.NVQLevel), '') NOT LIKE '%3%' 
                    AND COALESCE(TRIM(ofq."QualificationLevel"), '') NOT LIKE '%3%'
                THEN 0

                WHEN COALESCE(TRIM(lad.QualificationTypeName), '') NOT IN ('A Level', 'GCE A level', 'A level') 
                    AND lad.Learning_Aim_Title NOT LIKE '%GCE A Level%'
                    AND lad.Learning_Aim_Title NOT LIKE '%Advanced GCE%'
                THEN 0

                WHEN lad.Learning_Aim_Title LIKE '%Biology%' 
                    OR lad.Learning_Aim_Title LIKE '%Chemistry%'
                    OR lad.Learning_Aim_Title LIKE '%Physics%'
                    OR lad.Learning_Aim_Title LIKE '%Mathematics%'
                    OR lad.Learning_Aim_Title LIKE '%Further Mathematics%'
                    OR lad.Learning_Aim_Title LIKE '%English Literature%'
                    OR lad.Learning_Aim_Title LIKE '%History%'
                    OR lad.Learning_Aim_Title LIKE '%Geography%'
                    OR lad.Learning_Aim_Title LIKE '%French%'
                    OR lad.Learning_Aim_Title LIKE '%Spanish%'
                    OR lad.Learning_Aim_Title LIKE '%German%'
                    OR lad.Learning_Aim_Title LIKE '%Latin%'
                THEN 1

                WHEN TRIM(COALESCE(q.DC, '')) IN ('FC4','5110')
                    OR TRIM(COALESCE(q.DC, '')) LIKE 'RB%'
                    OR TRIM(COALESCE(q.DC, '')) LIKE 'RH3%'
                    OR TRIM(COALESCE(q.DC, '')) LIKE 'RD1%'
                    OR TRIM(COALESCE(q.DC, '')) LIKE 'RC1%'
                    OR TRIM(COALESCE(q.DC, '')) LIKE 'RC5%'
                THEN 1

                ELSE 0 
            END AS IsFacilitatingSubject,

                    
        FROM college_offerrings co
        INNER JOIN learning_aim_details lad 
        ON lad.LEARNING_AIM_REF = co.LearningAimRef

        LEFT JOIN (
            SELECT DISTINCT AcademicYearID, LearningAimRef, WholeQualID
            FROM CURRICULUM_DB.stg.stg_onegrade__estactva
        ) ola 
            ON ola.LearningAimRef = co.LearningAimRef 
        AND ola.AcademicYearID = co.AcademicYearID

        LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__qan q 
            ON q.LearningAimRef = co.LearningAimRef

        LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__ofqual ofq 
            ON ofq."QualificationNumber" = co.LearningAimRef

        LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__learningaim vla 
            ON vla.LearningAimRef = co.LearningAimRef
)    
       
    SELECT 
    md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(LearningAimRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "LearningAimKey",
        CAST(COALESCE(LearningAimRef,'-') AS NVARCHAR(20)) AS "LearningAimRef",
        CAST(COALESCE(LearningAimTitle,'-') AS NVARCHAR(255)) AS "LearningAimTitle",
         CAST(COALESCE(QualificationTypeName,'-') AS NVARCHAR(150)) AS "QualificationTypeName",
        CAST(COALESCE(NVQLevel,'-') AS NCHAR(1)) AS "NVQLevel",
        CAST(COALESCE(SectorSubjectArea1,'-') AS NVARCHAR(150)) AS "SectorSubjectArea1",
        CAST(COALESCE(SectorSubjectArea2,'-') AS NVARCHAR(150)) AS "SectorSubjectArea2",
        CAST(COALESCE(WholeQualID,'-') AS NVARCHAR(20)) AS "WholeQualID",
        CAST(COALESCE(InScope,0) AS BOOLEAN) AS "InScope",
        CAST(COALESCE(MathsAndEnglish,'-') AS NVARCHAR(50)) AS "MathsAndEnglish",
		CAST(COALESCE(IsFacilitatingSubject,0) AS BOOLEAN) AS "IsFacilitatingSubject",

        
    FROM enriched_learning_aims
    QUALIFY ROW_NUMBER() OVER (
    PARTITION BY AcademicYearID, LearningAimRef 
    ORDER BY WholeQualID DESC, IsFacilitatingSubject DESC
) = 1
ORDER BY AcademicYearID, LearningAimRef