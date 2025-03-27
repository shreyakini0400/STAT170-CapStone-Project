-- From all of the patients hospital visits,
-- 1) inpatient records are excluded (since the scope of our study is purely outpatients),
-- 2) using 1) and URI records table from URI_patients.sql, get the URI outpatients,
-- 3) and only keep the records that are at least 31 days apart for each patient.


@transform_pandas(
    Output(rid="ri.foundry.main.dataset.fa0e6771-f7ce-418b-81e2-46b0a7d47e17"),
    visit_occurrence=Input(rid="ri.foundry.main.dataset.3f74d43a-d981-4e17-93f0-21c811c57aab")
)
-- exclude patients that are 100% sure as inpatients.

SELECT *
FROM visit_occurrence
WHERE visit_concept_name NOT IN 
('Inpatient Visit',
'Inpatient Hospital',
'Emergency Room and Inpatient Visit',
'Inpatient Critical Care Facility',
'Intensive Care',
'Pre-admission',
'Skilled Nursing Facility',
'Psychiatric Facility-Partial Hospitalization',
'Nursing Facility',
'Hospice',
'Skilled nursing facility',
'Epilepsy Hospital Unit',
'Preadmission Screening and Resident Review (PASRR)',
'Inpatient Psychiatric Facility');

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.8f33b341-ad48-497a-bc2a-5d2dd1800887"),
    no_inpatient=Input(rid="ri.foundry.main.dataset.fa0e6771-f7ce-418b-81e2-46b0a7d47e17")
)
-- IMPORTANT: CODE INCOMPLETE (NOT ACCOUNTING FOR NO INFO PATIENTS.)
-- NEED TO ACCOUNT FOR NO INFO PATIENTS LATER.
-- CURRENTLY ONLY EXPLICIT OUTPATIENTS.

-- UPDATE: from no info patients, if either of their date is null, then we exclude.
-- CODE COMPLETE

SELECT *
FROM no_inpatient
EXCEPT
SELECT *
FROM no_inpatient
WHERE 
    visit_concept_name IN ('No matching concept', 'No information')
    AND 
    (visit_start_date IS NULL OR visit_end_date IS NULL OR visit_start_date <> visit_end_date)
;

-- From no matching concept or no information patients,
-- if their visit_start_date != visit_end_date,
-- we exclude them.
-- (if their dates are different then they are inpatients.)
-- NOTE: the null values remain. i.e.) 2020-04-04 AND null will stay in record.

-- BEFORE: 581,241,211 rows
-- AFTER:  it should increase: 626,083,246 rows


@transform_pandas(
    Output(rid="ri.foundry.main.dataset.79ca4d70-b485-4cdc-8347-bf52989be2be"),
    URI_patients=Input(rid="ri.foundry.main.dataset.9239ebbe-ace8-4998-866a-bff3c759b87a"),
    final_outpatients=Input(rid="ri.foundry.main.dataset.8f33b341-ad48-497a-bc2a-5d2dd1800887")
)
-- multiple occurences of URI allowed per patient.

SELECT DISTINCT uri.person_id, uri.visit_occurrence_id, visit_start_date, condition_start_date AS uri_start_date
FROM final_outpatients outp, URI_patients uri
WHERE uri.visit_occurrence_id = outp.visit_occurrence_id -- more accurate to join by visit id
ORDER BY uri.person_id
;

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.7f64808e-8851-4349-8603-3ff3292d1e15"),
    Uri_outp=Input(rid="ri.foundry.main.dataset.79ca4d70-b485-4cdc-8347-bf52989be2be")
)
-- multiple occurences of URI allowed per patient.
-- but they have to be at least 31 days apart.

WITH cte AS
(
    SELECT 
        *,
        LAG(uri_start_date, 1) OVER ( 
            PARTITION BY person_id
            ORDER BY uri_start_date ASC
        ) AS previous_uri_date 

    FROM 
        Uri_outp
) 
SELECT *
FROM cte
WHERE ISNULL(previous_uri_date) OR DATEDIFF(uri_start_date, previous_uri_date) > 30
ORDER BY person_id
;

