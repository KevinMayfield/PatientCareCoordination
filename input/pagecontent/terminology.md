<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

SNOMED CT codes are from the UK Edition; expansions use the UK Edition
(`path-expansion-params`), as in the NW GMSA IG. Codes were checked on
[tx.fhir.org](https://tx.fhir.org) on 2026-11-01.

### Code Systems and Value Sets

| Artefact | Binding | Notes |
|---|---|---|
| [Referral Workflow Status](CodeSystem-referral-workflow-status.html) / [value set](ValueSet-referral-workflow-status-vs.html) | `Task.businessStatus` (required) | The 360X states, plus `information-requested` for eRS / BaRS |
| [Referral Status Reason](CodeSystem-referral-status-reason.html) / [value set](ValueSet-referral-status-reason-vs.html) | `Task.statusReason` (example) | Example only - **To confirm** eRS / BaRS reject reasons |
| [Referral Category](ValueSet-referral-category.html) | `ServiceRequest.category` (extensible) | SNOMED CT referral, virtual ward, hospital at home |
| [Referral Service Type](ValueSet-referral-service-type.html) | `ServiceRequest.code` (extensible) | SNOMED CT descendants of 3457005 Patient referral |
| [Referral Document Type](ValueSet-referral-document-type.html) | Document type (`DocumentReference.type`) | LOINC (360X, HL7 Europe) and SNOMED CT record types (Transfer of Care, NRL) |
| [Referral Task Parameter](CodeSystem-referral-task-parameter.html) / [value set](ValueSet-referral-task-parameter-vs.html) | `Task.input.type`, `Task.output.type` (extensible) | Form to complete, completed form, appointment, observation, interim / outcome report, encounter - **To confirm** against SDC |
| [Virtual Ward Admission Route](CodeSystem-virtual-ward-admission-route.html) / [value set](ValueSet-virtual-ward-admission-route-vs.html) | `Encounter.hospitalization.admitSource` (extensible) | Step-up, step-down - **To confirm** a national code set |
{:.grid}

### Codes Used

| Code | System | Display | Use |
|---|---|---|---|
| 3457005 | SNOMED CT | Patient referral | Referral category |
| 729021000000108 | SNOMED CT | Referral to virtual ward | Referral category and code |
| 112951000000109 | SNOMED CT | Referral to intermediate care - hospital at home | Referral category |
| 784431000000109 | SNOMED CT | Admission to virtual ward | Procedure, if recorded |
| 708252004 | SNOMED CT | Discharge from virtual ward | Procedure, if recorded |
| 183519002 | SNOMED CT | Referral to cardiology service | Example referral code |
| 960751000000107 | SNOMED CT | Remote health monitoring care plan | Virtual ward care plan category |
| 25611000000107 | SNOMED CT | Referral letter | Document type |
| 823681000000100 | SNOMED CT | Outpatient letter | Document type |
| 823701000000103 | SNOMED CT | Discharge letter | Document type |
| 57133-1 | LOINC | Referral Note | 360X OBR-4 default; document type |
| 11488-4 | LOINC | Consult Note | Consultation Note type |
| 34105-7 | LOINC | Hospital Discharge Summary | HDR Composition type |
| 18842-5 | LOINC | Discharge summary | Health Data API document type - see [Reports](Reports.html) **Open** |
| 18776-5 | LOINC | Plan of Care Note | Plan of care section |
| 526151000000109 | SNOMED CT | Referral to exercise on referral programme | Example referral code |
| 89574-8 | LOINC | Exercise Vital Sign (EVS) | Physical activity observation |
{:.grid}

### HL7 v2 Tables

| Table | Values used | Use |
|---|---|---|
| 0119 Order control | NW, OK, UA, SC, CA, CR | ORC-1 |
| 0038 Order status | IP, CA, CM, A | ORC-5 |
| 0203 Identifier type | PLAC, NH, MR | Referral ID, NHS Number, MRN |
| 0003 Event type | O19, O51, S12, S13, S15, S26 | MSH-9 trigger events |
{:.grid}
