<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

This page assesses the national NHS England services for referrals and reports against
the 360X transactions. Test orders (pathology, genomics, imaging) are assessed on
[NHS England Diagnostic Order Services](NHSEnglandDiagnostics.html). Each covers part of the closed loop for particular settings; none
covers all of it.

<div class="alert alert-warning" role="alert">
<b>General standards take precedence.</b> A national standard is not assumed to be
correct. Where one under-specifies the data or the process of the closed loop, this
guide follows the general standard (IHE 360X, HL7 v2, FHIR REST / messaging, CDA / FHIR
Documents) and records the gap. Mappings below show how a national service could be
used as an implementation of a step - not that it defines the step.
</div>

National standards are not all equal. **eRS** and **EPS** are mature, well-engineered
services and are good references for their own scope (outpatient referral and triage;
prescribing and dispensing) - their gaps are of scope, not design. **BaRS** under-specifies
both data and process and is mapped onto the general pattern, not used as a model.

### References

- [NHS e-Referral Service (eRS)](https://digital.nhs.uk/services/e-referral-service) and [eRS FHIR API](https://digital.nhs.uk/developer/api-catalogue/e-referral-service-fhir)
- [Booking and Referral Standard (BaRS)](https://digital.nhs.uk/services/booking-and-referral-standard) and [Booking and Referral FHIR API](https://digital.nhs.uk/developer/api-catalogue/booking-and-referral-fhir) (versions 1.0.7 to 1.6.0 listed as in production, checked 2026-11-01)
- [Transfer of Care](https://digital.nhs.uk/services/transfer-of-care-initiative)
- [Message Exchange for Social Care and Health (MESH) API](https://digital.nhs.uk/developer/api-catalogue/message-exchange-for-social-care-and-health-api)
- [National Record Locator (NRL)](https://digital.nhs.uk/developer/api-catalogue/national-record-locator-fhir) and [Multicast Notification Service (MNS)](https://digital.nhs.uk/developer/api-catalogue/multicast-notification-service)
- [PRSB standards](https://theprsb.org/standards/) - clinical headings for letters and discharge summaries
- [NW GMSA - Genetic Referrals](https://nw-gmsa.github.io/en/GeneticReferrals.html) - analysis of the eRS FHIR resource model and BaRS
- [Virtually Healthcare - Kettering XML](https://virtually-healthcare.github.io/kettering.html)
- [GP Connect](https://digital.nhs.uk/services/gp-connect) and [GP Connect specifications](https://digital.nhs.uk/services/gp-connect/gp-connect-specifications-for-developers) (checked 2026-11-01)
- [IM1 pairing integration](https://digital.nhs.uk/services/gp-it-futures-systems/im1-pairing-integration)
- [Electronic Prescription Service (EPS)](https://digital.nhs.uk/services/electronic-prescription-service), [EPS FHIR API](https://digital.nhs.uk/developer/api-catalogue/electronic-prescription-service-fhir) and [Prescription Status Update API](https://digital.nhs.uk/developer/api-catalogue/prescription-status-update-fhir) (checked 2026-11-01)
- [IHE Pharmacy Medication Prescription and Delivery (MPD)](https://profiles.ihe.net/PHARM/MPD/index.html)

### Coverage of the Closed Loop

| 360X transaction | eRS | BaRS | Transfer of Care | MESH + Kettering XML | GP Connect | IM1 | HL7 v2 (trust) |
|---|---|---|---|---|---|---|---|
| Referral Request [PCC-55] | Yes - referral with attachments, UBRN | Yes - referral `ServiceRequest` | - | - | Clinical information: Access Record, Access Document (read by the Referral Recipient) | Read GP record (supplier API) | `REF_I12`, `OMG^O19` (rare) |
| Accept / Decline [PCC-55] | Yes - triage, accept, reject / return to referrer | Yes - response message - **To confirm** | - | - | - | - | `RRI_I12` (rare) |
| Referral Decline [PCC-56] | Partly - **To confirm** | **To confirm** | - | - | - | - | - |
| Referral Outcome [PCC-57] | No | No - not defined | Yes - discharge summary, outpatient letter, ED attendance, mental health discharge | Yes - letters as documents | Send Document (to GP); Update Record (structured, community pharmacy) | Enter data into the GP record (supplier API) | `MDM^T02`, `ORU^R01` |
| Referral Cancellation [PCC-58] | Yes - cancel referral | Yes - cancel - **To confirm** | - | - | - | - | - |
| Interim Consultation Note [PCC-59] | No | No | Yes - outpatient letter | Yes - clinic letters | Send Document | Enter data (supplier API) | `MDM^T02` |
| Appointment [PCC-60] | Yes - booking | Yes - booking | - | - | Appointment Management (GP appointments) | Supplier API - **To confirm** | `SIU^S12` |
| No-Show [PCC-61] | Partly (DNA recorded by provider) - **To confirm** | **To confirm** | - | DNA letter | **To confirm** | - | `SIU^S26` |
| Link outcome to referral | No | No - not defined | No - **To confirm** | No | **To confirm** | Supplier-specific | Only if the placer order number is kept |
{:.grid}

The most common gap is the last row: the clinic letter or discharge summary that
comes back to the GP does not identify the referral it answers, so the referrer's
system cannot close the loop automatically. The national test ordering services do
link the report to the request - see
[NHS England Diagnostic Order Services](NHSEnglandDiagnostics.html).

### e-Referral Service (eRS)

eRS is the national service GP practices use to refer patients to consultant-led
first outpatient appointments, with booking, **Referral Assessment Services (RAS)**
for triage, and **Advice and Guidance**. Each referral has a **Unique Booking
Reference Number (UBRN)**.

| eRS concept | 360X | FHIR (this guide) |
|---|---|---|
| Referral and referral letter | Referral Request [PCC-55] | [Referral Request](StructureDefinition-ReferralRequest.html) with the UBRN in `identifier:ubrn`, the letter in `supportingInfo` |
| UBRN | Referral ID (shared) | [UBRN identifier](StructureDefinition-UniqueBookingReferenceNumber.html) |
| eRS service (shortlist) | Referral Recipient | `HealthcareService` (eRS service ID), `ServiceRequest.performer` |
| Triage: accept, return to referrer, reject | Accept / Decline [PCC-55] | [Referral Task](StructureDefinition-ReferralTask.html) `businessStatus` `accepted`, `information-requested`, `declined` |
| Booked appointment | Appointment Notification [PCC-60] | [Referral Appointment](StructureDefinition-ReferralAppointment.html) |
| Advice and Guidance | Not in 360X | `Communication` / `Task` conversation - **Open** |
| Clinic outcome letter | Referral Outcome [PCC-57] | Not in eRS - sent by Transfer of Care, MESH or HL7 v2 |
{:.grid}

eRS covers the **input** side only: clinical information and patient summaries attached
to the referral (`ServiceRequest.supportingInfo`). The same kinds of document - a
discharge report ([HL7 Europe HDR](https://hl7.eu/fhir/hdr/)) or patient summary
([HL7 Europe EPS](https://hl7.eu/fhir/eps/1.0.0-ballot/)) - are also the **output** of a
referral, which eRS does not carry. BaRS is the same - see
[BaRS](BaRS.html#referral-clinical-document-or-patient-summary).

The eRS FHIR API is mainly STU3 (`ReferralRequest`); an R4 `ServiceRequest` API is in
development, with the UBRN in `ServiceRequest.identifier` (system
`https://fhir.nhs.uk/Id/UBRN`) - see the
[NW GMSA eRS analysis](https://nw-gmsa.github.io/en/GeneticReferrals.html#referral-via-nhs-e-referral-service-ers).
**To confirm** against the current eRS API.

**Closing the loop with eRS.** If the provider keeps the UBRN with the referral, its
clinic letters can carry the UBRN as the referral identifier
(`Composition` `basedOn`, or HL7 v2 ORC-2 / TXA), so the GP system can match the
outcome to the referral it made.

### Booking and Referral Standard (BaRS)

BaRS is a FHIR R4 standard for sending booking and referral information between NHS
services, using FHIR Messaging (`$process-message` at both ends) through a national API
that routes each request to the target service. Its Applications cover urgent and
emergency care (NHS 111, integrated urgent care and ambulance services referring to and
booking into emergency departments, urgent treatment centres and community services)
and referrals into community pharmacy.

| BaRS concept | 360X | FHIR (this guide) |
|---|---|---|
| Referral request (`servicerequest-request`, `new`) | Referral Request [PCC-55] | [Referral Request](StructureDefinition-ReferralRequest.html) |
| Interim validation response - accepted or rejected (Application 4) | Accept / Decline [PCC-55] | [Referral Task](StructureDefinition-ReferralTask.html) |
| Referral update with `ServiceRequest.status` `revoked` | Cancellation [PCC-58] | Referral Task |
| Full validation response (Application 4) | Referral Outcome [PCC-57] (status only, no clinical document) | Referral Task; [HL7 Europe HDR](https://hl7.eu/fhir/hdr/) |
| Booking request (get slots, book, update, cancel) | Appointment Notification [PCC-60] | [Referral Appointment](StructureDefinition-ReferralAppointment.html) |
| Did-not-attend response | No-Show [PCC-61] | Referral Task |
| Get referrals / bookings for a patient | Not in 360X (query) | Search `ServiceRequest`, `Appointment` (REST) |
{:.grid}

**Assessment.** BaRS covers most of the closed loop and has the same shape as 360X:
asynchronous request and response messages between sender and receiver. The gaps are
in how the messages are defined:

- payloads are loosely defined;
- workflow state is inferred from combinations of resource statuses rather than an
  explicit status;
- the BaRS `CarePlan` carries the sender's assessment;
- a patient without an NHS Number has only an untyped local identifier;
- parties are sent as full resources rather than identifier references.

The detailed review, with the evidence, is in the
[Booking and Referral Standard (BaRS)](BaRS.html) appendix. Where BaRS is the route,
map it onto 360X and this guide's resources as described there.

### Transfer of Care

Transfer of Care defines FHIR documents for information sent from hospital to the GP
(and other providers): inpatient discharge, emergency care discharge, mental health
discharge and outpatient letters, using the PRSB clinical headings. They are sent as
ITK3 FHIR (STU3) messages over MESH.

| Transfer of Care document | 360X | This guide |
|---|---|---|
| eDischarge (inpatient) | Referral Outcome [PCC-57] | [HL7 Europe HDR](https://hl7.eu/fhir/hdr/) |
| Outpatient letter | Interim Consultation Note [PCC-59] or Referral Outcome [PCC-57] | `Composition` with the HDR section codes |
| Emergency care discharge | Referral Outcome [PCC-57] (for referrals to ED) | HDR - **Open** (HDR assumes an inpatient encounter) |
| Mental health discharge | Referral Outcome [PCC-57] | HDR - **To confirm** |
{:.grid}

Adoption of the Transfer of Care FHIR documents has been limited; most trusts send
letters by MESH with Kettering XML (below). HL7 Europe HDR is the likely successor,
see [Referral Outcome Reports](Reports.html).

### MESH and Kettering XML

**MESH** is the national store-and-forward service for sending messages and files
between NHS organisations, addressed by mailbox. Most trusts send clinic letters and
discharge summaries to GP practices through MESH in **Kettering XML** (the EDT / Docman
format): a small XML envelope with patient demographics, document metadata and the
letter as an attachment (usually PDF or RTF), which the GP workflow tool files into the
GP record.

| Kettering XML | Meaning | FHIR equivalent |
|---|---|---|
| Patient details (NHS Number, name, date of birth) | Patient | `Patient` |
| Sender, recipient practice | Author, recipient | `Composition.author`, `custodian`; MESH mailbox |
| Document type, date, specialty | Metadata | `DocumentReference.type`, `date`, `context.practiceSetting` |
| Attachment | The letter | `DocumentReference.content.attachment` / `Binary` |
| Referral reference | Not present - **To confirm** | `DocumentReference.context.related` / `Composition` `basedOn` |
{:.grid}

Kettering XML is a **Document Messaging** pattern: the letter is pushed and filed, and
cannot be queried later. It is the
[MHD-style DocumentReference](Reports.html#from-document-messaging-to-document-sharing)
with a PDF attachment, which makes it straightforward to also publish to a Document
Access Provider.

### GP Connect

GP Connect is the national set of FHIR APIs and messaging specifications for GP
practice systems. The GP practice is the most common Referral Initiator, and the usual
recipient of outcomes even when it is not, so GP Connect appears at both ends of the
loop. Capabilities as listed by NHS England (checked 2026-11-01):

| Capability | Version | NHS England description | Closed loop use |
|---|---|---|---|
| [Access Record: HTML](https://digital.nhs.uk/services/gp-connect/gp-connect-specifications-for-developers) | API 0.7.4 | "Enables a read-only view of the patient's GP practice record." | Referral Recipient views the GP record while triaging [PCC-55] |
| [Access Record: Structured](https://digital.nhs.uk/developer/api-catalogue/gp-connect-access-record-structured-fhir) | API 1.5.0-beta | "Enables structured information to be retrieved from the patient's GP practice record." | Clinical information pulled instead of sent with the referral (medications, allergies, problems); a Resource Sharing pattern |
| [Access Document](https://digital.nhs.uk/developer/api-catalogue/gp-connect-access-document-fhir) | API 1.5.1-beta | "...enables access to documents that can be retrieved from the patient's GP practice record." | Retrieve the referral letter or earlier correspondence |
| [Appointment Management](https://digital.nhs.uk/developer/api-catalogue/gp-connect-appointment-management-fhir) | API 1.2.7-beta | "Enables the management of GP practice appointments between different systems." | Appointment [PCC-60] when the **GP practice is the Referral Recipient** (e.g. NHS 111 or a virtual ward booking a GP follow-up) |
| [Send Document](https://digital.nhs.uk/developer/api-catalogue/gp-connect-send-document-fhir) | Messaging 2.0.2 | "...a simple and standardised means of sending a document to a GP practice system." | Interim Consultation Note [PCC-59] and Referral Outcome [PCC-57] to the GP - a standard alternative to Kettering XML |
| Update Record | Messaging 1.2.1-public-beta | "...update a patient's GP record from a community pharmacy with structured data." | Structured Referral Outcome [PCC-57] for referrals to community pharmacy |
{:.grid}

Points for the closed loop:

- **Pull versus push.** 360X pushes the clinical information with the referral. With
  Access Record the Referral Recipient pulls it when it needs it, so the referral can
  carry less. The referral still **SHALL** carry the reason for referral and the
  referral question; the Recipient's view of the record is not a substitute.
- **Send Document** delivers a document (e.g. PDF) into the GP practice's document
  workflow over MESH - the same Document Messaging pattern as Kettering XML, but a
  national specification. **To confirm** whether its metadata can carry the Referral ID
  or UBRN, which is what closes the loop.
- **Update Record** is the nearest national example of a closed loop with a
  **structured** outcome: a patient referred to a community pharmacy (for example from
  NHS 111 or the GP practice) has the pharmacy consultation returned to the GP record as
  structured data. **To confirm** how the referral and the update are linked.
- Appointment Management makes the GP practice a Referral Recipient that other
  services can book into, i.e. the 360X Scheduling Option in the reverse direction.

| GP Connect | This guide |
|---|---|
| Access Record: Structured bundle | Clinical information for `ServiceRequest.supportingInfo`, or read on demand |
| Access Document `DocumentReference` | Referral letter (`supportingInfo`), consultation notes |
| Appointment Management `Appointment` | [Referral Appointment](StructureDefinition-ReferralAppointment.html) |
| Send Document payload | [HL7 Europe HDR](https://hl7.eu/fhir/hdr/) or outpatient letter, rendered as PDF |
| Update Record structured message | Outpatient letter (HDR section codes) with coded entries - **To confirm** mapping |
{:.grid}

GP Connect APIs are mostly FHIR STU3 and are reached through the Spine Secure Proxy;
the messaging specifications use MESH - **To confirm** against each specification.

### IM1 (Interface Mechanism 1)

IM1 is "the process that allows suppliers to integrate their system with any principal
clinical system through an interface mechanism". The foundation suppliers, Optum (EMIS
Web) and TPP (SystmOne), must offer interfaces that let third-party systems "read
patient information", "extract information in bulk" and "enter data into the other
system". Each consuming product is checked against **each provider supplier's API** and
needs a Model Interface Licence with each one.

| IM1 capability | Closed loop use |
|---|---|
| Read patient information | Referral Recipient (or a referral management / virtual ward platform) reads the GP record when triaging or monitoring |
| Extract information in bulk | Case finding - e.g. identifying patients for a virtual ward or a long-term condition pathway; population health |
| Enter data into the other system | Supplier-specific workaround for filing results into the GP record - the general pattern is to send `ORU^R01` / a document for the GP system to import |
{:.grid}

IM1 is how many third-party products used in primary care today (referral management,
document workflow, remote monitoring and virtual ward platforms) read from and write to
the GP record. **Writing directly into another organisation's record is not the general
pattern.** The general pattern is that the producer **sends** a result or document
(HL7 v2 `ORU^R01` / `MDM^T02`, a CDA / FHIR Document, or a FHIR message) or makes it
available through a **REST API**, and the consumer's own system imports and files it
(360X Document Import Option). For this guide:

- IM1 interfaces are **supplier-specific**, not a national standard, so an IM1
  integration is an **implementation** of a step in the loop (for example "file the
  Referral Outcome [PCC-57] into the GP record"), not an interface between the Referral
  Initiator and Referral Recipient.
- Where IM1 is used to file an outcome, the content **SHOULD** still be the documents
  and identifiers in this guide, so the same outcome can be sent by HL7 v2, FHIR Document
  or MESH without remapping, and IM1 can be replaced.
- IM1 read access is a supplier-specific form of the general **REST query** pattern
  (FHIR REST / IHE QEDm, MHD); GP Connect Access Record is the national equivalent.
- The virtual wards operational framework asks for "read/write functionality" across
  delivery partners. This guide does **not** follow that as written - see
  [Virtual Wards](VirtualWards.html#records-and-write-access).

### Electronic Prescription Service (EPS)

EPS sends prescriptions electronically from prescribers to dispensers. NHS England
describes it as "for prescribers and dispensers and is used in primary, secondary and
community care"; "over 95% of all prescriptions in England" are now produced
electronically, and increasing adoption in secondary care is a roadmap priority
(service page, last edited 15 October 2026). EPS is workflow management, not clinical
prescribing: the prescribing decision is made in the prescriber's system.

A prescription is the same **order and report** pattern as a referral: the prescriber
places an order, a dispenser takes it, and the dispense is the report. IHE
[Medication Prescription and Delivery (MPD)](https://profiles.ihe.net/PHARM/MPD/index.html)
defines it with Submit Medication Order [PHARM-5], Retrieve Medication Order [PHARM-7],
Submit Medication Dispense [PHARM-8] and Retrieve Medication Dispense [PHARM-9]
(1.0.0-comment-2, FHIR R5). HL7 Europe HDR depends on the R4 version of MPD
(`ihe.pharm.mpd.r4`).

| Step | EPS | IHE MPD | 360X equivalent | FHIR |
|---|---|---|---|---|
| Order | Prescription sent by the prescriber to Spine (to a nominated pharmacy, or for any pharmacy to download) | Submit Medication Order [PHARM-5] | Referral Request [PCC-55] | `MedicationRequest` |
| Take the order | Dispenser downloads (releases) the prescription | Retrieve Medication Order [PHARM-7] | Accept [PCC-55] | `MedicationRequest` / `Task` - **To confirm** |
| Not dispensed / returned | Dispenser returns the prescription to Spine, or records items as not dispensed | - | Decline [PCC-55, PCC-56] | `MedicationDispense.status`, `statusReason` |
| Cancel | Prescriber cancels the prescription (if not yet dispensed) | - | Cancellation [PCC-58] (may be refused if already dispensed) | `MedicationRequest.status` `cancelled` |
| Report | Dispense notification | Submit Medication Dispense [PHARM-8] | Referral Outcome [PCC-57] | `MedicationDispense` |
| Status | Prescription tracker (professionals); NHS App tracking (patients); Prescription Status Update (dispenser to NHS App, e.g. "ready to collect") | Retrieve Medication Dispense [PHARM-9] | Task status, Appointment Notification [PCC-60] (to the patient) | `Task`, `MedicationDispense` |
| Correlation | Prescription ID | Prescription identifier | Referral ID | `MedicationRequest.groupIdentifier` - **To confirm** |
{:.grid}

Points for this guide:

- **The loop back to the prescriber.** NHS England lists dispense notifications and
  claims as dispenser actions but does not say the dispense is returned to the
  prescriber; prescribers check status with the prescription tracker - **To confirm**.
  This is the same gap as letters that do not reference the referral: the order is
  electronic, the closing of the loop is a lookup.
- **Prescriptions in referral outcomes.** A Referral Outcome [PCC-57] often changes
  medication. The HDR discharge medications section (and the Consultation Note plan)
  says what the patient is on; EPS (in secondary and community care) or a request to
  the GP is how the change is actioned. The [virtual wards](VirtualWards.html) framework
  asks for discharge medicines to be "shared with the patient's GP and community pharmacy".
- **Referral to community pharmacy** (for example from NHS 111 or a GP practice) is a
  referral, not a prescription: it uses [PCC-55](PCC-55.html) (BaRS is used today on some routes) and
  returns the consultation to the GP through [GP Connect Update Record](#gp-connect)
  [PCC-57]. The pharmacist may then issue or supply medicines.
- **Virtual wards** prescribe for patients at home. EPS in secondary and community
  care lets the virtual ward send prescriptions to a community pharmacy - **To confirm**
  how virtual wards prescribe today.

The EPS FHIR API (R4) and the older HL7 v3 messages carry the prescription, cancel,
release, return and dispense notification - **To confirm** message and operation names
against the specification. The Prescription Status Update API lets "dispensing
suppliers" push status to patients "via the NHS App".

### Other National Services

| Service | Use in the closed loop |
|---|---|
| PDS (Personal Demographics Service) | Trace the NHS Number before referring (the shared patient identifier) |
| ODS / Directory of Services / Service Finder | Find the Referral Recipient (`Organization`, `HealthcareService`) |
| NRL (National Record Locator) | Register a referral outcome document so others can find it (Document Sharing) |
| MNS (Multicast Notification Service) | Notify subscribers of events, for example a new document or an encounter - **To confirm** referral events |
{:.grid}
