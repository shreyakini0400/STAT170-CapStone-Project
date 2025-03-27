-- The series of following codes
-- 1) adds the COVID-19 status for each patient, only keeping the records
-- that are more than 60 days apart
-- 2) as well as 19 comorbid conditions based on the Charlson Comorbidity Index,
-- 3) and keeping them binary (if multiple records, just yes; otherwise no).

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.8f1533d5-84fa-4687-bed1-fd75e5aab9f2"),
    covid_measurements=Input(rid="ri.foundry.main.dataset.a2a473ce-9b43-485e-bf79-74ef5a947cab")
)
SELECT DISTINCT person_id, measurement_date
FROM covid_measurements
WHERE value_as_concept_name in ('Positive', 'Reactive', 'Detected')

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.c8d194a5-9649-4c99-aaf3-949caedbcc99"),
    abx_30d=Input(rid="ri.foundry.main.dataset.d7dd15ef-0bb3-4b89-acca-e4710b76e60c"),
    covid_positive=Input(rid="ri.foundry.main.dataset.8f1533d5-84fa-4687-bed1-fd75e5aab9f2")
)
SELECT
    abx.*,
    covid.measurement_date AS covid_measurement_date,
    CASE WHEN abx.person_id = covid.person_id then 'Yes' else 'No' end as covid_status,
    CASE WHEN abx.person_id = covid.person_id AND DATEDIFF(covid.measurement_date, abx.uri_start_date) BETWEEN -30 AND 2 THEN 'Yes' else 'No' END AS covid_active,
    CASE WHEN abx.person_id = covid.person_id AND DATEDIFF(covid.measurement_date, abx.uri_start_date) BETWEEN -30 AND 2 
            THEN DATEDIFF(covid.measurement_date, abx.uri_start_date)
            ELSE null
            END AS covid_active_datediff
FROM abx_30d abx
LEFT JOIN covid_positive covid
ON abx.person_id = covid.person_id
ORDER BY person_id
;

-- for covid_status,
-- yes if a patient ever had a covid,
-- no if a patient never had a covid

-- for covid_active
-- yes if -30 <= (covid - URI) <= 2
-- no else

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.c497cdaf-16d5-40d8-a8fe-37037eb51c12"),
    covid_yes_no=Input(rid="ri.foundry.main.dataset.c8d194a5-9649-4c99-aaf3-949caedbcc99")
)
-- this calculates if a patient has covid positive less than 60 days apart, the subsequent records will be removed.
-- also, it removes the potential duplicates.

WITH cte AS
(
    SELECT
        *,
        LAG(covid_measurement_date, 1) OVER (
            PARTITION BY person_id
            ORDER BY covid_measurement_date ASC
        ) AS previous_covid_date,
        ROW_NUMBER() OVER (
            PARTITION BY person_id, visit_start_date, covid_measurement_date
            ORDER BY covid_measurement_date
        ) AS rn -- this will filter out the duplicate case
    FROM
        covid_yes_no
)

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.bdf77a47-34fb-4817-a5f6-16d6dca24b55"),
    condition_occurrence=Input(rid="ri.foundry.main.dataset.526c0452-7c18-46b6-8a5d-59be0b79a10b"),
    covid_60d=Input(rid="ri.foundry.main.dataset.c497cdaf-16d5-40d8-a8fe-37037eb51c12")
)
SELECT 
    p.*,
    case when (c.condition_concept_name like '%Cancer%') then 'Yes' else 'No' end as Cancer, 
    case when (c.condition_concept_name like '%Chronic kidney disease%') then 'Yes' else 'No' end as Chronic_Kidney_Disease,
    case when (c.condition_concept_name like '%Chronic liver disease%') then 'Yes' else 'No' end as Chronic_Liver_Disease,
    case when (c.condition_concept_name like '%Asthma%') then 'Yes' else 'No' end as Asthma,
    case when (c.condition_concept_name like '%Cystic fibrosis%') then 'Yes' else 'No' end as Cystic_Fibrosis,
    case when (c.condition_concept_name like '%Dementia%') then 'Yes' else 'No' end as Dementia,
    case when (c.condition_concept_name like '%Alzheimer%') then 'Yes' else 'No' end as Alzheimer
FROM covid_60d p, condition_occurrence c
where p.person_id = c.person_id
ORDER BY p.person_id

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.d171eac0-0b17-4490-ba34-e6615fe7d110"),
    condition_occurrence=Input(rid="ri.foundry.main.dataset.526c0452-7c18-46b6-8a5d-59be0b79a10b"),
    covid_60d=Input(rid="ri.foundry.main.dataset.c497cdaf-16d5-40d8-a8fe-37037eb51c12")
)
SELECT
    p.*,
    case when (c.condition_concept_name like '%Diabetes%') then 'Yes' else 'No' end as Diabetes, 
    case when (c.condition_concept_name like '%Disability%') then 'Yes' else 'No' end as Disability,
    case when (c.condition_concept_name like '%HIV%' or c.condition_concept_id = 4267414 ) then 'Yes' else 'No' end as HIV_Infection,
    case when (c.condition_concept_name like '%Immunocompromised%') then 'Yes' else 'No' end as Immunocompromised,
    case when (c.condition_concept_name like '%Overweight%' or c.condition_concept_name like '%Obesity%') then 'Yes' else 'No' end as Overweight,
    case when (c.condition_concept_name like '%Pregnancy%') then 'Yes' else 'No' end as Pregnancy,
    case when (c.condition_concept_name like '%Sickle cell disease%') then 'Yes' else 'No' end as Sickle_Cell_Disease,
    case when (c.condition_concept_name like '%Smoking%' or c.condition_concept_name like '%Smoke%' or c.condition_concept_id in (4209423,36716473)) then 'Yes' else 'No' end as Smoking,
    case when (c.condition_concept_id = 42537741) then 'Yes' else 'No' end as Solid_Organ,
    case when (c.condition_concept_name like '%Stroke%') then 'Yes' else 'No' end as Stroke,
    case when (c.condition_concept_name like '%Substance use%') then 'Yes' else 'No' end as Substance_Disorder,
    case when (c.condition_concept_name like '%Heart Failure%' or c.condition_concept_name like '%cardiomyopathies%' or c.condition_concept_name like '%coronary artery disease%') then 'Yes' else 'No' end as Heart_Conditions,
    case when (c.condition_concept_name like '%hypertension%') then 'Yes' else 'No' end as Hypertension
FROM covid_60d p, condition_occurrence c
WHERE p.person_id = c.person_id

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.42024a4c-a2ec-4a9b-b67f-9dd2e2764f0a"),
    comorbidities=Input(rid="ri.foundry.main.dataset.bdf77a47-34fb-4817-a5f6-16d6dca24b55")
)
SELECT
    c.person_id, c.visit_start_date, c.uri_start_date, c.drug_exposure_start_date, c.concept_name, c.abx_status, c.covid_measurement_date, c.covid_status, c.covid_active,
    max(c.Cancer) as Cancer,  
    max(c.Chronic_Kidney_Disease) as Chronic_Kidney_Disease,
    max(c.Chronic_Liver_Disease) as Chronic_Liver_Disease,
    max(c.Asthma) as Asthma,
    max(c.Cystic_Fibrosis) as Cystic_Fibrosis ,
    max(c.Dementia) as Dementia, 
    max(c.Alzheimer) as Alzheimer
FROM comorbidities c
GROUP BY c.person_id, c.visit_start_date, c.uri_start_date, c.drug_exposure_start_date, c.concept_name, c.abx_status, c.covid_measurement_date, c.covid_status, c.covid_active
ORDER BY c.person_id

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.a1c2a8bd-6c48-4f41-a06f-14438df05afe"),
    comorbidities_2=Input(rid="ri.foundry.main.dataset.d171eac0-0b17-4490-ba34-e6615fe7d110")
)
SELECT 
    c.person_id, c.visit_start_date, c.uri_start_date, c.drug_exposure_start_date, c.concept_name, c.abx_status, c.covid_measurement_date, c.covid_status,
    max(c.Diabetes) as Diabetes, 
    max(c.Disability) as Disability,
    max(c.HIV_Infection) as HIV_Infection, 
    max(c.Immunocompromised) as Immunocompromised,
    max(c.Overweight) as Overweight,
    max(c.Pregnancy) as Pregnancy,
    max(c.Sickle_Cell_Disease) as Sickle_Cell_Disease,
    max(c.Smoking) as Smoking,
    max(c.Solid_Organ) as Solid_Organ,
    max(c.Stroke) as Stroke,
    max(c.Substance_Disorder) as Substance_Disorder,
    max(c.Heart_Conditions) as Heart_Conditions,
    max(c.Hypertension) as Hypertension
FROM comorbidities_2 c
group by c.person_id, c.visit_start_date, c.uri_start_date, c.drug_exposure_start_date, c.concept_name, c.abx_status, c.covid_measurement_date, c.covid_status
order by c.person_id

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.7631ce6d-1b5f-4ed3-ac92-863ee564f225"),
    comorbidities_unique=Input(rid="ri.foundry.main.dataset.42024a4c-a2ec-4a9b-b67f-9dd2e2764f0a"),
    comorbidities_unique_2=Input(rid="ri.foundry.main.dataset.a1c2a8bd-6c48-4f41-a06f-14438df05afe")
)
SELECT 
    c1.*,
    c2.Disability, c2.HIV_Infection, c2.Overweight, c2.Pregnancy,
    c2.Smoking, c2.Solid_Organ, c2.Stroke, c2.Heart_Conditions, c2.Hypertension
FROM comorbidities_unique c1, comorbidities_unique_2 c2
WHERE c1.person_id = c2.person_id
ORDER BY c1.person_id

/*
List of Removed due to only No Values
Immunocompromised
Sickle_Cell_Disease
Substance_Disorder
*/

/*
Stroke only has 9 Yes -- potentially remove?
Heart Conditions only 99 Yes
HIV only 115 Yes
Disability 16 Yes
Cystic_Fibrosis 1.6k Yes
Chronic_Liver_Disease 25 Yes
Cancer 4200 Yes
*/