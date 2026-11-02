# Research Notes

Working notes for the Closed Loop Referral IG. **Not published** - this folder is
outside `input/`. Dates are when the source was checked.

## Open Questions

| # | Question | Who could answer | Status |
|---|---|---|---|
| 1 | Health Data API discharge report document type is LOINC 18842-5; HDR fixes Composition.type to 34105-7. Which goes in DocumentReference.type? | HL7 Europe / Xt-EHR | Open |
| 2 | HDR Encounter only allows inpatient classes. Is a virtual ward stay an inpatient (IMP) encounter in NHS PAS and the Virtual Wards SitRep / MDS? | NHS England virtual wards team, trust PAS teams | To confirm |
| 3 | National code set for virtual ward step-up / step-down (local CodeSystem used) | NHS Data Dictionary / SNOMED CT UK | To confirm |
| 4 | eRS R4 ServiceRequest API: UBRN system, status codes for triage outcomes (accept, return to referrer, reject), reject reason codes | NHS England eRS team | To confirm |
| 5 | BaRS gap analysis against 360X: status after first response, cancellation, outcome and its link to the referral, coded reason / question. BaRS is not used as the model (general standards take precedence) | IG authors, against the BaRS IG | Open |
| 6 | Do Transfer of Care documents or Kettering XML carry a referral reference (UBRN or referral ID)? | NHS England, EDT / Docman suppliers | To confirm |
| 7 | MESH workflow IDs for referral and status messages | NHS England MESH team | To confirm |
| 8 | FHIR MessageHeader.eventCoding codes for the 360X events (align with BaRS?) | IG authors | Open |
| 9 | HL7 v2 equivalent of "more information requested" (eRS / BaRS return to referrer) | IG authors | Open |
| 10 | LOINC 42349-1 (Reason for referral) could not be checked on tx.fhir.org ($lookup error); 29299-5 used | IG authors | To confirm |
| 11 | Where HL7 v2 MDM^T02 carries the referral ID - v2.5.1 MDM_T02 has an order group (ORC-2 / OBR-2) and TXA-14 placer order number; examples use both. Confirm against the NW GMSA MDM_T02 conventions | NW GMSA HL7 v2 authors | To confirm |
| 12 | ORC-5 to Task.status is not one-to-one (IP covers accepted and in progress) | IG authors | Open |
| 13 | NHS equivalent of the 360X newborn hearing screening use case (NHSP IT system) | NHS England screening | Open |
| 14 | Advice and Guidance (eRS) as Communication / Task conversation | IG authors | Open |
| 15 | Emergency care discharge (Transfer of Care) - HDR assumes an inpatient encounter | IG authors | Open |
| 16 | Create an NW core package for shared identifier conventions, replacing the copies in this guide | NW GMSA IG authors | Open (same as Imaging IG #16) |
| 18 | Can GP Connect Send Document metadata carry the Referral ID / UBRN? | NHS England GP Connect team | To confirm |
| 19 | GP Connect Update Record: how the community pharmacy consultation is linked to the referral (BaRS / 111) | NHS England GP Connect / BaRS teams | To confirm |
| 20 | GP Connect FHIR versions and transport per capability (STU3 via Spine Secure Proxy; messaging via MESH) | GP Connect specifications | To confirm |
| 21 | Which IM1 write capabilities (documents, coded entries, tasks) EMIS Web and SystmOne offer, and whether the Referral ID can be stored | Optum, TPP | To confirm |
| 22 | Is the EPS dispense notification returned to the prescriber's system, or only visible in the prescription tracker? | NHS England EPS team | To confirm |
| 23 | EPS FHIR API message / operation names (prescription, cancel, release, return, dispense notification) and the prescription ID element | EPS FHIR API specification | To confirm |
| 24 | How virtual wards prescribe today (EPS in secondary / community care, FP10, hospital pharmacy) | NHS England virtual wards / EPS teams | To confirm |
| 25 | How a service publishes its referral form (HealthcareService, directory, ActivityDefinition / PlanDefinition) | IG authors | Open |
| 26 | Align Task.input / output types with the SDC form-request pattern and the Physical Activity IG | IG authors | To confirm |
| 27 | HL7 v2 for a form requested after referral (no 360X equivalent) | IG authors | Open |
| 28 | PAR-Q+ licence terms for publishing it as a FHIR Questionnaire (example form is illustrative, not PAR-Q+) | PAR-Q+ Collaboration | To confirm |
| 29 | Health Data API Document Access Provider lacks the `related` search parameter, so documents cannot be found by referral | HL7 Europe / Xt-EHR | Open |
| 30 | Does an accepted referral establish the legitimate relationship for the Recipient to query the record before the patient is seen? | IG authors, information governance | To confirm |
| 31 | Single Patient Record architecture and APIs (fact sheet 19 May 2026 gives none) | NHS England / DHSC | Open |
| 32 | QEDm covers procedures; Health Data API Resource Access Provider does not list Procedure | IG authors | To confirm |
| 33 | Which HL7 v2 field each trust uses for the spell (Account Number): PID-18 (HL7 v2 definition) or PV1-19 with CX.5 AN (NW GMSA PV1) | Trust integration teams | To confirm |
| 34 | Consultant episode (NHS Data Dictionary) - model as Encounter partOf the spell, or not at all? | IG authors | Open |
| 35 | A&E attendance followed by admission: NW GMSA Hospital Spell + Visit vs Interweave Encounter Grouping | NW GMSA / Interweave authors | To confirm |
| 36 | Replace the copied NW GMSA admin profiles with a shared NW core package (see #16) | NW GMSA IG authors | Open |
| 37 | FHIR code system for NHS Data Dictionary ACCOMMODATION STATUS CODE (Social Context uses free text) | NHS England terminology | To confirm |
| 38 | Can the IG Publisher / tx.fhir.org expand the UK refsets used by Social Context (1027891000000106, 999001571000000109, 999000891000000102)? Same issue as Imaging #15 | IG authors | To confirm |
| 39 | RF1-11 External Referral Identifier for the UBRN in REF_I12 - NHS practice? | Trust integration teams | To confirm |
| 40 | PAR-Q+ in a FHIR Questionnaire needs written permission from the PAR-Q+ Collaboration (eparmedx@gmail.com); the example is structure-only | IG authors | Open |
| 41 | Should the Referral Order (O19) FHIR message carry a Task (status requested, focus the ServiceRequest) and use the Task as its focus, so every 360X message focuses on the Task? (BaRS review, point 2) | IG authors | Open |
| 42 | BaRS: does any Application carry a referral business identifier (ServiceRequest.identifier)? Correlation found only via MessageHeader.response.identifier (original Bundle.id) and the Journey ID (EpisodeOfCare reference) | NHS England BaRS team | To confirm |
| 43 | BaRS: later decline (PCC-56) and cancel confirmation (PCC-58) equivalents | NHS England BaRS team | To confirm |
| 44 | Referral supporting information for receivers without record access (e.g. community pharmacy): consultation note, IPS patient summary, or both? (BaRS review, Application 5) | IG authors, PRSB | Open |
| 45 | SNOMED CT 2140231000000104 "Referral to Community Pharmacy Pharmacy First Service" (BaRS Application 5 Task.code) - not in the tx.fhir.org UK Edition (2023-04-12) | IG authors | To confirm |
| 46 | PRSB standards (111 Referral, Community Pharmacy, Core Information Standard) to HL7 Europe HDR / EPS section mappings | IG authors, PRSB | To confirm |
| 47 | Outpatient letters: HDR allows only inpatient encounters and fixes Composition.type to 34105-7; outpatient letters use a plain Composition with HDR section codes. Ask HL7 Europe whether HDR (or a sibling) will cover outpatient / ambulatory encounters | IG authors, HL7 Europe | Open |
| 48 | HL7 Europe HDR composition-eu-hdr slices `extension:basedOn` with the core R4 `event-basedOn` extension, whose context does not include Composition - the validator rejects it (Extension_EXTP_Context_Wrong). This guide links documents to the referral from the workflow instead (Task.output, TXA-14, DocumentReference.context.related). Raise with HL7 Europe | IG authors, HL7 Europe | Open |
| 17 | Publisher / canonical: copied the NHS North West Genomics publisher and `fhir.nwgenomics.nhs.uk` canonical from the sibling IGs - confirm this is right for a general referral guide | IG authors | To confirm |

## Sources Checked (2026-11-01)

- 2026-11-02: Genomic Order Management Service (FHIR) API, OpenAPI 3.0.6-beta
  (digital.nhs.uk/restapi/oas/genomic-order-management-service). REST, FHIR R4;
  `POST /FHIR/R4` transaction Bundle; searches on ServiceRequest, RequestGroup, Task
  (business-status, code), DiagnosticReport (based-on), Specimen; MNS for events.
  Business status codes and cancellation not checked (Genomics IG on Simplifier).
- 2026-11-02: National Imaging Registry (NIR) - MHD FHIR API OpenAPI 0.43.0
  (digital.nhs.uk/restapi/oas/national-imaging-registry). In production (beta), bronze
  service; federated XCA (ITI-38, ITI-39) and XCA-I (RAD-75) over SOAP, mTLS + XUA
  SAML; MHD endpoint planned; PDM as a document reference source. Not checked: which
  document metadata (order / accession number) can be searched.
- 2026-11-02: PRSB section lists for logical model mappings - Clinical Referral
  Information Standard v1.0 (page; Excel v1.2), Transfer of Care - Acute Inpatient
  Discharge v2.1 (page, 22 sections), Outpatient Letter v2.2 (Excel, 27 sections), Core
  Information Standard v2.01 (JSON). Since 1 January 2026 the referral standard is
  "owned and managed by NHS England" (PRSB page).
- 2026-11-02: HL7 Europe Patient Summary (EPS) - package hl7.fhir.eu.eps, 1.0.0-ballot
  (2026-06-06, STU 1 ballot), CI build 1.0.0-ci-build; scope: European patient summary
  aligned with eHN guidelines, links to IPS 2.0. Section list not checked.
- 2026-11-02: BaRS. API v1.0.7 OpenAPI "Booking and Referral API" 1.0.0
  (digital.nhs.uk/restapi/oas/413106): $process-message, MessageDefinition, Slot,
  Appointment, ServiceRequest; MessageDefinition example lists 15 focus entries (incl.
  Bundle, MessageHeader) each 1..1. Simplifier guide v1.12.1 / Core 1.6.0 / package
  1.42.0: Standard Pattern For Composites (pseudo-code), Message Headers ("manual,
  business logic, check"), Use Case Categories, Journey ID (EpisodeOfCare); Applications
  1 (UEC), 4 (validation: interim and full responses), 5 (pharmacy) payload tables:
  CarePlan status fixed completed with triage outcome codes; Patient.identifier local
  identifier with no type / assigner; Organization referenced as a resource.
  Application 5 v1.2.1 (guide 1.12.1): Task carries code (2140231000000104) and
  restriction.period, referenced from CarePlan.activity; ServiceRequest.reasonCode only
  for cancellation; requester -> Practitioner; MedicationStatement = new medication at
  the encounter; requirements ask for BMI, BP service type, new meds / allergies.
- 2026-11-02: MNS Genomic Order Management Event (genomic-order-event-1), private beta,
  last edited 18 August 2026. Triggers: ServiceRequest, Task, DiagnosticReport created /
  updated; Specimen status; consent. Notification only (read from GOMS); FHIR history
  Bundle with Parameters (focus, timestamp, event-number); filters by status, business
  status, task code, requester / performer / owner ODS; MESH or AWS SQS. R5
  Subscriptions backport conformance not checked.
- 2026-11-02: Pathology FHIR IG 0.5.1 (Simplifier, released 09/09/2026). Reporting
  only, replaces PMIP EDIFACT NHS003 over MESH; Bundle type document; HL7 Europe Lab
  Report profiles; ServiceRequest "Test Request Summary" with EDIFACT E152 (ROI) / E153
  in ServiceRequest.identifier; Error Handling and Acknowledgement Framework TBC.
  DiagnosticReport.basedOn listed in the mapping without a source - to confirm.
- IHE PCC 360X Rev. 1.2 Trial Implementation, 2021-04-14 (116 pages). Transactions
  PCC-55 to PCC-61; HL7 v2.5.1 OMG^O19, OSU^O51, SIU^S12/S13/S15/S26; ORC-1/ORC-5
  values per transaction taken from Vol 2 tables.
- IHE PCC DCP Rev. 3.1 Trial Implementation, 2019-09-27 (FHIR R4). Transactions
  PCC-37 to PCC-41, PCC-45 to PCC-49, PCC-63 to PCC-70.
  `profiles.ihe.net/PCC/DCP/` returns 404 - the PDF supplement is the reference.
- `hl7.fhir.eu.hdr` 1.0.0 STU 1 published 2026-10-16. Depends on eu.base 2.0.1,
  eu.extensions.r4 1.3.1, ips 2.0.1, xver-r5.r4 0.1.0, xtehr.eu.ehds.models 1.0.0,
  ihe.pharm.mpd.r4 1.0.0-comment-2. Composition has event-basedOn extension
  (ServiceRequest target) and informationRecipient.
- `hl7.fhir.eu.health-data-api` 1.0.0-ballot (2026-03-13), depends on eu.base
  2.0.0-ballot (conflicts with HDR's 2.0.1) - not taken as a dependency; linked only.
- NHS England Virtual wards operational framework PRN01289, published 2024-08-27,
  updated 2025-07-04.
- BaRS FHIR API catalogue lists versions 1.0.7, 1.4.1, 1.5.0, 1.6.0 in production.
- eRS FHIR API catalogue page is rendered by JavaScript; eRS details taken from the
  NW GMSA Genetic Referrals analysis.
- SNOMED CT UK Edition codes and LOINC codes in terminology.md checked on tx.fhir.org.
- HL7 Physical Activity IG 1.0.1 STU 1, workflow page (continuous build): Care Manager, Full / Light
  Service Provider, Patient Engagement App; Task drives the workflow; outcome DiagnosticReport (PDF);
  Questionnaire only for patient feedback; no PAR-Q.
- GOV.UK Health Bill single patient record fact sheet, published 2026-05-19: clinicians 80% by March
  2027, NHS App from 2028; "build on and connect with existing ... source systems"; no architecture.
- IHE QEDm 3.0.0 (2024-12-12), IHE MHD 4.2.5 (package 2026-10-18).
- Interweave IG 0.1.0 (2024-09-30): Encounter (one encounter per continuous care setting, one level of
  hierarchy, no planned status, account discouraged), Encounter Grouping (class GROUPING),
  EpisodeOfCare (referralRequest, careManager, team), Location, Schedule, Slot.
- NW GMSA artifacts section 7 = Resource Profiles; Encounter / HospitalSpell / Visit / HospitalProviderSpellIdentifier
  copied from ../FHIRGenomics (commit 82022faf).
- PRSB Core Information Standard v2.01 JSON (Core-Information-Standard-v2_01_FINAL.json, April 2026): Social context
  elements and code sets used for the Social Context questionnaire.
- PAR-Q+ 2025 for individuals (PARQPlus2025Fillable.pdf) and terms and conditions: reproduction and electronic
  incorporation need prior written authorisation.
- GP Connect specifications page: Access Record HTML 0.7.4, Appointment Management
  1.2.7-beta, Access Record Structured 1.5.0-beta, Access Document 1.5.1-beta (link points
  to 1.5.0-beta), Send Document 2.0.2, Update Record 1.2.1-public-beta.
- EPS service page (last edited 2026-10-15): primary, secondary and community care; over 95%
  of prescriptions electronic; does not say dispense information returns to the prescriber.
  IHE MPD 1.0.0-comment-2 (FHIR R5): PHARM-5, PHARM-7, PHARM-8, PHARM-9.
- IM1 pairing page: foundation suppliers Optum (EMIS Web) and TPP (SystmOne); no mention of FHIR.
