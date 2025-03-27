-- The series of following codes
-- 1) extract all of available antibiotics names,
-- 2) right join them to the existing URI outpatient record from URI_outpatients.sql,
-- 3) create a binary column of antibiotic status (yes/no),
-- 4) and only keep the records that are at least 31 days apart for each patient.

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.7b71c08e-9a4b-4f83-9d2f-146db1f84867"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Doxycycline%' or c.concept_name like '%doxycycline%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.b826b149-4a40-4bfd-8170-97cb42881ea8"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Minocycline%' or c.concept_name like '%minocycline%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.92e00990-03c5-4f54-ad9f-ff2e5ad56cbc"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%amoxicillin%' or c.concept_name like '%Amoxicillin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.4d4109ec-dbd7-4e0c-a074-92a5134a6088"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
-- get all concept_ids for azithromycin

SELECT DISTINCT c.*
FROM concept c
WHERE c.concept_name like '%azithromycin%' and c.domain_id = 'Drug';-- azithromycin intravenous

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.7dbc5837-04f4-41d7-9a53-e57947ee0a6c"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%cefadroxil%' or c.concept_name like '%Cefadroxil%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.b082b4fd-a277-4425-b6e8-11eb01085fdc"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Cefdinir%' or c.concept_name like '%cefdinir%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.f5d6778d-dca6-4f5c-8b7a-495d35319f6e"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%cefpodoxime%' or c.concept_name like '%Cefpodoxime%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.b5665def-c622-436c-a050-6ab2a0f7d7f1"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%cephalexin%' or c.concept_name like '%Cephalexin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.72dce185-b41f-420f-b418-14ab2e2222a3"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Clarithromycin%' or c.concept_name like '%clarithromycin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.f8175a1e-af7b-4961-93ba-f35a05fa8d80"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%clavulanate%' or c.concept_name like '%Clavulanate%' OR c.concept_name like '%amoxicillin%' or c.concept_name like '%Amoxicillin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.429b2237-7c07-4c76-bcbb-40b70224c7d0"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Clindamycin%' or c.concept_name like '%clindamycin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.45b9f504-5681-4bff-9b6d-5a89faf9f0cb"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%erythromycin%' or c.concept_name like '%Erythromycin%' or c.concept_name like '%sulfisoxazole%' or c.concept_name like '%Sulfisoxazole%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.e0becd81-e7b7-4a06-9192-73c076dd74b0"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%levofloxacin%' or c.concept_name like '%Levofloxacin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.54cc47e8-1043-4a5d-b516-adbf70543508"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Moxifloxacin%' or c.concept_name like '%moxifloxacin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.113f7ce7-ec5f-4250-92e9-4d7d768b9552"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%Penicillin%' or c.concept_name like '%penicillin%'
and c.domain_id = 'Drug'; 

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.6d059a06-4f70-45a2-8b1d-3fcff6afb185"),
    concept=Input(rid="ri.foundry.main.dataset.5cb3c4a3-327a-47bf-a8bf-daf0cafe6772")
)
SELECT c.*
FROM concept c
WHERE c.concept_name like '%trimethoprim%' or c.concept_name like '%Trimethoprim%' or c.concept_name like '%sulfamethoxazole%' or c.concept_name like '%Sulfamethoxazole%'
and c.domain_id = 'Drug'; 


@transform_pandas(
    Output(rid="ri.foundry.main.dataset.0af4b91b-f6ee-420e-88df-5c323513d7b9"),
    Amoxicillin_con=Input(rid="ri.foundry.main.dataset.93abf9f7-1cb6-452b-aa96-f9516464fd98"),
    Con_azithromycin=Input(rid="ri.foundry.main.dataset.4d4109ec-dbd7-4e0c-a074-92a5134a6088"),
    Con_cefadroxil=Input(rid="ri.foundry.main.dataset.7dbc5837-04f4-41d7-9a53-e57947ee0a6c"),
    Con_cefdinir=Input(rid="ri.foundry.main.dataset.b082b4fd-a277-4425-b6e8-11eb01085fdc"),
    Con_cefpodoxime=Input(rid="ri.foundry.main.dataset.f5d6778d-dca6-4f5c-8b7a-495d35319f6e"),
    Con_cephalexin=Input(rid="ri.foundry.main.dataset.b5665def-c622-436c-a050-6ab2a0f7d7f1"),
    Con_clarithromycin=Input(rid="ri.foundry.main.dataset.72dce185-b41f-420f-b418-14ab2e2222a3"),
    Con_clavulanate=Input(rid="ri.foundry.main.dataset.f8175a1e-af7b-4961-93ba-f35a05fa8d80"),
    Con_clindamycin=Input(rid="ri.foundry.main.dataset.429b2237-7c07-4c76-bcbb-40b70224c7d0"),
    Con_doxycycline=Input(rid="ri.foundry.main.dataset.7b71c08e-9a4b-4f83-9d2f-146db1f84867"),
    Con_erythromycin=Input(rid="ri.foundry.main.dataset.45b9f504-5681-4bff-9b6d-5a89faf9f0cb"),
    Con_levofloxacin=Input(rid="ri.foundry.main.dataset.e0becd81-e7b7-4a06-9192-73c076dd74b0"),
    Con_minocycline=Input(rid="ri.foundry.main.dataset.b826b149-4a40-4bfd-8170-97cb42881ea8"),
    Con_moxifloxacin=Input(rid="ri.foundry.main.dataset.54cc47e8-1043-4a5d-b516-adbf70543508"),
    Con_penicillin=Input(rid="ri.foundry.main.dataset.113f7ce7-ec5f-4250-92e9-4d7d768b9552"),
    Con_trimethoprim=Input(rid="ri.foundry.main.dataset.6d059a06-4f70-45a2-8b1d-3fcff6afb185")
)
SELECT * FROM Con_cefdinir
UNION
SELECT * FROM Con_trimethoprim
UNION
SELECT * FROM Con_penicillin
UNION
SELECT * FROM Con_doxycycline
UNION
SELECT * FROM Con_levofloxacin
UNION
SELECT * FROM Con_clarithromycin
UNION
SELECT * FROM Con_moxifloxacin
UNION
SELECT * FROM Con_erythromycin
UNION
SELECT * FROM Con_cephalexin
UNION
SELECT * FROM Con_clindamycin
UNION
SELECT * FROM Con_minocycline
UNION
SELECT * FROM Con_clavulanate
UNION
SELECT * FROM Con_cefpodoxime
UNION
SELECT * FROM Con_azithromycin
UNION
SELECT * FROM Con_cefadroxil
UNION
SELECT * FROM Amoxicillin_con
;

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.1c7ef270-3b78-4920-aaa3-5ce03ecc1e06"),
    all_abx_concept=Input(rid="ri.foundry.main.dataset.0af4b91b-f6ee-420e-88df-5c323513d7b9"),
    drug_exposure=Input(rid="ri.foundry.main.dataset.fd499c1d-4b37-4cda-b94f-b7bf70a014da"),
    uri_outp_30d=Input(rid="ri.foundry.main.dataset.7f64808e-8851-4349-8603-3ff3292d1e15")
)
SELECT DISTINCT u.person_id, u.visit_start_date, u.uri_start_date, d.drug_exposure_start_date, a.concept_name
FROM drug_exposure d
JOIN all_abx_concept a 
ON d.drug_concept_id = a.concept_id -- all abx
RIGHT JOIN uri_outp_30d u
ON d.visit_occurrence_id = u.visit_occurrence_id -- URI outpatients visit
AND DATEDIFF(d.drug_exposure_start_date, u.uri_start_date) BETWEEN -2 AND 14
ORDER BY person_id, drug_exposure_start_date;

-- all records of people who were prescribed all antibiotic types.

-- for reference: for amox:
-- joined by visit id (158,650 rows) 
-- -2 <= DIFF <= 14: (151,997 rows)
-- not too much difference

-- for all abx:
-- 334,361 rows

/*
SELECT DISTINCT u.person_id, u.visit_start_date, u.uri_start_date, d.drug_exposure_start_date
FROM drug_exposure d, all_abx_concept a, uri_outp_30d u
WHERE d.drug_concept_id = a.concept_id -- all abx
AND d.visit_occurrence_id = u.visit_occurrence_id -- URI outpatients visit
AND DATEDIFF(d.drug_exposure_start_date, u.uri_start_date) BETWEEN -2 AND 14
ORDER BY person_id, drug_exposure_start_date;
*/

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.a7718768-b3ad-43d4-b4ea-70de205ede02"),
    all_abx_patients=Input(rid="ri.foundry.main.dataset.1c7ef270-3b78-4920-aaa3-5ce03ecc1e06")
)
SELECT 
    *, 
    CASE WHEN drug_exposure_start_date IS NULL THEN 'No' ELSE 'Yes' END AS abx_status
FROM all_abx_patients
;

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.d7dd15ef-0bb3-4b89-acca-e4710b76e60c"),
    abx_yes_no=Input(rid="ri.foundry.main.dataset.a7718768-b3ad-43d4-b4ea-70de205ede02")
)
-- There might be multiple types of antibitics prescribed per patient per visit.
-- So this is another criterion that if antibiotics prescription is subsequent (<= 30d)
-- then they will be removed.

WITH cte AS
(
    SELECT
        *,
        LAG(drug_exposure_start_date, 1) OVER (
            PARTITION BY person_id
            ORDER BY drug_exposure_start_date
        ) AS previous_abx_date
    FROM abx_yes_no abx
)
