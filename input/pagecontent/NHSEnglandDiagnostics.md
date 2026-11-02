<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

This page assesses the national NHS England services for diagnostic test orders and
results - genomics, pathology and imaging - against the IHE laboratory (LTW) and
radiology (SWF.b) workflows and the 360X transactions. A referral to a diagnostic
service is the same order and report pattern as a referral to a clinical service.
Referral services (eRS, BaRS, Transfer of Care, GP Connect, IM1, EPS) are assessed on
[NHS England Referral and Report Services](NHSEngland.html).

<div class="alert alert-warning" role="alert">
<b>General standards take precedence.</b> A national standard is not assumed to be
correct. Mappings below show how a national service could be used as an implementation
of a step - not that it defines the step.
</div>

### References

- [Genomic Order Management Service (FHIR) API](https://digital.nhs.uk/developer/api-catalogue/genomic-order-management-service-fhir) (OpenAPI 3.0.6-beta, checked 2026-11-02) and [FHIR Genomics Implementation Guide](https://simplifier.net/guide/fhir-genomics-implementation-guide/Home)
- [MNS - Genomic Order Management Event](https://digital.nhs.uk/developer/api-catalogue/multicast-notification-service/genomic-order-event) (`genomic-order-event-1`, private beta, last edited 18 August 2026, checked 2026-11-02)
- [Pathology FHIR Implementation Guide 0.5.1](https://simplifier.net/guide/pathology-fhir-implementation-guide?version=0.5.1) (released 09/09/2026, checked 2026-11-02)
- [NW GMSA - Laboratory Testing Workflow](https://nw-gmsa.github.io/en/LTW.html) - GOMS in the regional order workflow
- [National Imaging Registry (NIR) API](https://digital.nhs.uk/developer/api-catalogue/national-imaging-registry-api) (0.43.0, checked 2026-11-02) and [NIR service](https://digital.nhs.uk/services/national-imaging-registry)
- [Enterprise Imaging - Radiology Scheduled Workflow (SWF.b)](https://kevinmayfield.github.io/Imaging/en/SWF.html)
- [IHE Laboratory Testing Workflow (LTW)](https://www.ihe.net/uploadedFiles/Documents/Laboratory/IHE_LAB_TF_Vol1.pdf)

### Coverage of the Closed Loop

The 360X steps for test orders - the IHE profiles (see
[Order and Report Workflow Pattern](WorkflowPatterns.html)) and the national services
that implement part of them:

| 360X transaction | IHE LTW (laboratory) | GOMS (genomic tests) | Pathology FHIR | IHE SWF.b (radiology) | National Imaging Registry |
|---|---|---|---|---|---|
| Referral Request [PCC-55] | Placer Order Management [LAB-1] `OML^O21` | Yes - `POST` transaction Bundle (`ServiceRequest`, `Task`, ...); test from the Genomic Test Directory | No - requests stay in local order comms | Placer Order Management [RAD-2] `OMG^O19` | No - not an order service |
| Accept / Decline [PCC-55] | [LAB-1] `ORL^O22` (ORC-1 OK / UA) | `Task` `status` / `businessStatus` - **To confirm** codes | No | Filler Order Management [RAD-3] | No |
| Referral Decline [PCC-56] | Filler Order Management [LAB-2] | **To confirm** | No | [RAD-3] | No |
| Referral Outcome [PCC-57] | Order Results Management [LAB-3] `ORU^R01` (final) | Yes - laboratory uploads the `DiagnosticReport`; requester searches or is notified (MNS) | Yes - FHIR Document Bundle (`DiagnosticReport-eu-lab`) to the Pathology FHIR API | Send Imaging Result [RAD-128] `ORU^R01` | Find and retrieve the report: Cross Gateway Query / Retrieve [ITI-38] / [ITI-39] |
| Referral Cancellation [PCC-58] | [LAB-1] (ORC-1 CA) | **To confirm** | No | [RAD-2] (ORC-1 CA) | No |
| Interim Consultation Note [PCC-59] | [LAB-3] (preliminary) | Task status updates on test progress | Interim reports are in the business process - **To confirm** `DiagnosticReport.status` | - | Preliminary reports, if the source shares them - **To confirm** |
| Appointment [PCC-60] | - | - | - | Procedure Scheduled [RAD-4] `OMI^O23` (to the modality, not the placer) | No |
| No-Show [PCC-61] | - | - | - | - | No |
| Link outcome to referral | Placer order number (ORC-2), filler order number (ORC-3) | Yes - `DiagnosticReport.basedOn` the `ServiceRequest` (search `based-on`) | Yes - the report returns the `ServiceRequest` with the requester's and laboratory's order identifiers | Placer order number, accession number | Document metadata - **To confirm** whether the order or accession number is searchable |
| Share images / results | - | Unified Genomic Record (search) | - | XDS-I / XCA-I, MHD | Yes - XCA, images by Cross Gateway Retrieve Imaging Document Set [RAD-75] (XCA-I); MHD planned |
{:.grid}

GOMS and Pathology FHIR each implement part of LTW nationally (genomic ordering and
reporting; pathology reporting to GPs). No national radiology order service was found - radiology
orders stay local (order comms to RIS, SWF.b) - **To confirm**. The NIR covers the
sharing half - finding and retrieving reports and images after the loop has closed.

### Genomic Order Management Service (GOMS)

GOMS is "the national service used to send electronic orders from NHS organisations to
Genomic Services". It covers "genomics test ordering and reporting": clinicians "create
requests for genomics tests", "track status updates to tests" and "retrieve
interpretation reports"; laboratories "provide status updates on test progress" and
"upload interpretation reports" (API specification 3.0.6-beta, **in development**).

| Step | GOMS | 360X equivalent | FHIR (this guide) |
|---|---|---|---|
| Order | `POST /FHIR/R4` transaction Bundle - "register a new test or update tests or add reports" | Referral Request [PCC-55] | [Referral Request](StructureDefinition-ReferralRequest.html) |
| Status | Laboratory updates the `Task` (`status`, genomic `business-status`); requester searches `Task` or subscribes through MNS | Accept / Decline [PCC-55], Interim [PCC-59] | [Referral Task](StructureDefinition-ReferralTask.html) `businessStatus` |
| Send away | Laboratories "manage send aways" and "reassign tasks" - **To confirm** how | Referral forwarded - not in 360X | `Task.owner` |
| Report | Laboratory uploads the `DiagnosticReport`; requester searches by patient or `based-on` | Referral Outcome [PCC-57] | `DiagnosticReport` / outcome document |
| Correlation | `ServiceRequest` (and `RequestGroup` for test packages) identifiers | Referral ID | `identifier:referralId` |
{:.grid}

#### Genomic Order Event (MNS)

GOMS publishes `genomic-order-event-1` through the
[Multicast Notification Service](https://digital.nhs.uk/developer/api-catalogue/multicast-notification-service/genomic-order-event)
(private beta). It is how the requester and the laboratory learn that something has
changed, without polling:

| Published when | 360X equivalent |
|---|---|
| Order (`ServiceRequest`) created or updated - information, status or ownership | Referral Request [PCC-55], Cancellation [PCC-58] |
| Workflow task (`Task`) created or updated - status, ownership or assignment | Accept / Decline [PCC-55, PCC-56], Interim [PCC-59]; send away |
| Report (`DiagnosticReport`) created or updated | Interim Consultation Note [PCC-59], Referral Outcome [PCC-57] |
| Sample (`Specimen`) status update | - (laboratory specimen tracking) |
| Consent change | - |
{:.grid}

- **Notify, then read.** The notification "does not include" the order, report or
  workflow data: the subscriber reads it from the GOMS FHIR API. The FHIR form is a
  `history` Bundle holding a `Parameters` resource with `focus` (the changed resource),
  `timestamp`, `event-number`, `event-type` and `subject` (the order,
  `https://fhir.nhs.uk/Id/GMSOrder`); a CloudEvents form is for internal subscribers only.
- **Subscription filters** by resource type, status (including `taskStatus`,
  `taskBusinessStatus`, `taskCode`) and organisation (requester, performer, Task owner
  ODS codes), so a laboratory or requester receives only its own orders. Delivery is by
  MESH or AWS SQS.
- This is the FHIR **Subscription** notify-then-fetch pattern (an `id-only` style
  notification). The Bundle shape looks like the R5 Subscriptions backport
  notification - **To confirm** conformance. It plays the role of the push messages in
  360X: the event says "status changed", the API gives the state.

Assessment against the general standards:

- **Aligned with FHIR Workflow.** `ServiceRequest` + `Task` + `DiagnosticReport` is the
  same model as this guide's Referral Request and Referral Task, and matches IHE LTW
  (LAB-1 order, LAB-3 result). It is a good model for referrals to diagnostic services.
- **Central store, not point to point.** Both the placer and the filler write to one
  national record (the Unified Genomic Record), so status and reports are read
  (`GET` after an [MNS genomic order event](#genomic-order-event-mns)) rather than pushed
  as in 360X. A trust integration engine
  converts GOMS orders to the HL7 v2 the local LIMS expects - see
  [NW GMSA LTW](https://nw-gmsa.github.io/en/LTW.html).
- Transactions, not FHIR Messages: the update is a REST transaction Bundle, so the
  event is implied by the resources - **To confirm** how cancellation and declined
  tests are represented (Task status values).

### Pathology FHIR

The [Pathology FHIR Implementation Guide](https://simplifier.net/guide/pathology-fhir-implementation-guide?version=0.5.1)
(0.5.1, under active development) replaces PMIP EDIFACT (NHS003) pathology reports,
which today go from laboratory middleware to the GP system over MESH. It covers
reporting only, initially for tests requested by GP practices (blood sciences and
microbiology).

| Step | Pathology FHIR | 360X equivalent | FHIR (this guide) |
|---|---|---|---|
| Order | Not in scope - requests stay in local order comms | Referral Request [PCC-55] | - |
| Report | FHIR Document Bundle (`England-Bundle-Lab-Pathology`, `Composition-eu-lab`, `DiagnosticReport-eu-lab`, result Observations, Specimen) sent to the Pathology FHIR API | Referral Outcome [PCC-57] | Same document approach as [HL7 Europe HDR](https://hl7.eu/fhir/hdr/) |
| Interim | "The laboratory may issue one or more interim reports before sending a final report" | Interim Consultation Note [PCC-59] | `DiagnosticReport.status` - **To confirm** |
| Correlation | "Test Request Summary" `ServiceRequest` returned with the report, carrying the requester's order ID (EDIFACT `ROI`) and the laboratory's in `ServiceRequest.identifier`; `DiagnosticReport.basedOn` - **To confirm** | Referral ID | `identifier:referralId` |
| Transformation | `Provenance` (Test Reporter Design Pattern) records the organisation that converted the data to FHIR | - | - |
{:.grid}

Assessment against the general standards:

- **Aligned.** It is built on the HL7 Europe Laboratory Report guide - the same family
  as the HL7 Europe HDR used for reports here - and uses a FHIR Document, which is this
  guide's report pattern.
- **Closes the report half of the loop only.** There is no order status (accept,
  decline, cancel); the report carries the request identifiers so the GP system can
  match it. Error handling and the Acknowledgement Framework are "TBC".

### National Imaging Registry (NIR)

The NIR "allows authorised systems to view a patient's imaging history, including
examinations, diagnostic reports, and imaging studies for use in direct care". It is
**federated**: "a consumer queries NIR once and then NIR forwards the query to
participating imaging networks, returning an aggregated list of results" (API 0.43.0,
in production (beta), checked 2026-11-02).

| NIR | IHE | Use in the closed loop |
|---|---|---|
| Find a patient's imaging documents (study metadata, diagnostic reports) | Cross Gateway Query [ITI-38] (XCA) | Referral Recipient checks previous imaging before triage [PCC-55]; referrer finds the result |
| Retrieve a document | Cross Gateway Retrieve [ITI-39] (XCA) | Read the radiology report (the outcome of an imaging referral) |
| Retrieve images | Cross Gateway Retrieve Imaging Document Set [RAD-75] (XCA-I) | View the images behind the report |
| Planned RESTful endpoint | [MHD](MHD.html) (FHIR R4) | Same as this guide's [MHD](MHD.html) interactions |
| Security | mTLS; XUA SAML assertion (user, role, organisation, purpose of use) | Application-restricted, with the local user asserted |
{:.grid}

Assessment against the general standards:

- **Aligned.** XCA, XCA-I and XUA are the IHE cross-community document sharing
  profiles, and the planned MHD endpoint matches this guide's
  [Document Sharing](MHD.html) approach. It is the national example of
  sharing data by query, leaving messaging for the workflow - see
  [Health Data API](HealthDataAPI.html).
- **Sharing, not workflow.** The NIR does not carry the order, status or the report
  back to the requester. The imaging order and report loop is SWF.b (RAD-2, RAD-3,
  RAD-128) in the trust or imaging network; NIR makes the result available to others.
- SOAP (XCA) is used today; FHIR (MHD) is planned. NIR will also use the Patient Data
  Manager (PDM) FHIR API as a source of document references.
