-- From the de-identified dataset (that is not available for download,)
-- based on OMOP Common Data Model, only the records of
-- upper respiratory infection are extracted,
-- and also a table which only contains unique records is made.

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.9239ebbe-ace8-4998-866a-bff3c759b87a"),
    condition_occurrence=Input(rid="ri.foundry.main.dataset.526c0452-7c18-46b6-8a5d-59be0b79a10b")
)
SELECT *
FROM condition_occurrence
WHERE condition_concept_id = 257011 OR condition_concept_id = 4181583;

-- select only patients that have history of URI.

-- 257011: 	Acute upper respiratory infection
-- 4181583:	Upper respiratory infection
-- https://athena.ohdsi.org/search-terms/start

@transform_pandas(
    Output(rid="ri.foundry.main.dataset.caf39532-e81f-411d-b5d2-02af3ac004f6"),
    URI_patients=Input(rid="ri.foundry.main.dataset.9239ebbe-ace8-4998-866a-bff3c759b87a"),
    final_outpatients=Input(rid="ri.foundry.main.dataset.8f33b341-ad48-497a-bc2a-5d2dd1800887")
)
SELECT DISTINCT uri.person_id
FROM URI_patients uri, final_outpatients outp
WHERE uri.person_id = outp.person_id;

-- unique URI OUTPATIENTS.
