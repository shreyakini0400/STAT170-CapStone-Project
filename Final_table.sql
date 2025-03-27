-- On top of the table from Comorbidity.sql, each patient's demographics are added.
-- So, it has information on antibiotics status, comorbidity presence, and demographics.
-- This table contains all the necessary information for modeling purposes.


@transform_pandas(
    Output(rid="ri.foundry.main.dataset.b249738f-df08-4d2e-960c-bebf6b2a1c8e"),
    comorbidities_final=Input(rid="ri.foundry.main.dataset.7631ce6d-1b5f-4ed3-ac92-863ee564f225"),
    person=Input(rid="ri.foundry.main.dataset.af5e5e91-6eeb-4b14-86df-18d84a5aa010")
)
SELECT DISTINCT 
    c.*,
    (2022 - p.year_of_birth) as Age, 
    CASE WHEN p.gender_concept_name = 'FEMALE' THEN 'FEMALE'
        WHEN p.gender_concept_name = 'MALE' THEN 'MALE' 
        ELSE 'OTHER' END AS Gender,
    p.race_concept_name as Race,
    CASE WHEN p.ethnicity_concept_name = 'Not Hispanic or Latino' THEN 'Not Hispanic or Latino'
        WHEN p.ethnicity_concept_name = 'Hispanic or Latino' THEN 'Hispanic or Latino'
        END AS Ethnicity
FROM comorbidities_final c, person p
WHERE c.person_id = p.person_id
ORDER by c.person_id

-- final comorb+person table