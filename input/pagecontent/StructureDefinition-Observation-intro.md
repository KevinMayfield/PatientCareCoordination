<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Observation](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Observation), [Scored Assessment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ScoredAssessment).

Differences:

- **`observationValue` is a string**, with a separate UCUM unit; this profile uses `valueQuantity` (UCUM).
- No components (e.g. blood pressure systolic / diastolic), status, category or performer.
- Codes are SNOMED CT and CTV3 (legacy); no LOINC.
- Good: links to the admission, appointment, virtual ward stay or UEC attendance it was taken in.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
