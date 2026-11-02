<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

This page maps the FHIR profiles in this guide to the NHS England
[FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0, and highlights data elements that are important for closed loop referrals
and care coordination but are missing from the CDM or not represented well.

The CDM is a **persistence model** (the archetype layer - see
[Composition, Archetypes and Templates](Templates.html)): objects as they are stored for
operational products such as the Unified Pathway Manager. It is **downstream** of the
source systems and exchange standards: its data is derived from PAS, eRS and other
feeds. It is used here as evidence of what NHS operations record, **not** as a source
for this guide's design - the guide follows IHE 360X, HL7 v2 and FHIR. This guide is an **exchange
model** between organisations. Some differences are expected; the gaps below are those
that matter when a referral, its workflow state and its outcome must be held and shared.

Checked 2026-11-02 against the CDM Object Explorer (property lists of each object).
Element-level mappings are indicative - **To confirm**.

### Summary of Gaps

| # | Gap | Why it matters | CDM today | This guide |
|---|---|---|---|---|
| 1 | **No referral workflow (fulfilment) state** | Closed loop referral depends on both parties knowing the referral's state and who owns it next | [Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Referral) `status` is one provider-side string (e.g. Accepted, Rejected, Open, Awaiting Triage); `latestTriageOutcome`; no owner, requester or status history | [Referral Task](StructureDefinition-ReferralTask.html) `businessStatus`, `statusReason`, `owner`, `lastModified`, `input` / `output` |
| 2 | **No link from a referral to its outcome report** | The loop is closed by the report answering the referral (PCC-57) | [Clinic Letter](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicLetter) links only to `appointmentId`; no `referralId` | `Task.output` (outcome report), `DocumentReference.context.related` |
| 3 | **Placer and filler identifiers not distinguished** | The initiator's referral ID (placer, PLAC) must be returned on every message; the recipient's ID is separate | `referralId`, `sourceUniqueId` ("ID in the original source system") and `ubrn`; no identifier type or assigning organisation | [Referral Identifier](StructureDefinition-ReferralIdentifier.html) (PLAC, `assigner` ODS); [UBRN](StructureDefinition-UniqueBookingReferenceNumber.html) |
| 4 | **"Encounter" means an elective waiting list entry** | Name clash: a CDM `Encounter` is not a FHIR `Encounter` (an attendance or stay) | [Encounter](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Encounter) - "present or past entries on the trust Elective Admission List" (TCI, theatre, pre-op assessment) | [Encounter](StructureDefinition-Encounter.html), [Hospital Spell](StructureDefinition-HospitalSpell.html), [Visit](StructureDefinition-Visit.html) |
| 5 | **Account / Spell Number (AN) and Visit Number (VN) not explicit** | These identifiers carry reports and results back to the right stay or attendance (PV1-19) | [Admission](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Admission) `admissionExternalId`; [Appointment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Appointment) `appointmentExternalId`, `cdsUniqueId`; no visit-to-spell link - **To confirm** | `HospitalProviderSpellIdentifier` (AN), `VisitNumber` (VN), `Visit.partOf` |
| 6 | **Care plan has no content** | A care plan is activities, goals, owners and progress; onward referrals are its activities | [Community Care Plan](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CommunityCarePlan): type, agreed by / when, implementation date only | [Care Plan](StructureDefinition-PatientCarePlan.html) `activity`, `goal`, `addresses`, `careTeam`, `period`, `status` |
| 7 | **No structured supporting information or forms** | Referral criteria, triage and pre-assessment use forms; answers become Observations | `referralLetterContent`, `referralLetterRid`, `referralNotes` (text / media); no Questionnaire or QuestionnaireResponse object ([Scored Assessment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ScoredAssessment) holds scores only) | `ServiceRequest.supportingInfo`, `Task.input` / `output` (Questionnaire, QuestionnaireResponse) |
| 8 | **Observation value is a string** | Numeric values, units and components (blood pressure) cannot be checked or charted reliably | [Observation](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Observation) `observationValue` (string), `ucumUnitOfMeasurement`, SNOMED / CTV3 code; no status, category, performer or components | [Observation](StructureDefinition-Observation.html) `valueQuantity` (UCUM), `component`, `status`, `category` |
| 9 | **Virtual ward stay not linked to its referral** | A virtual ward admission is the fulfilment of a referral (step-up / step-down) | [Virtual Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/VirtualWardStay) has no `referralId`; Referral has only `isReferralToVirtualWard` | `Encounter.basedOn`; `Task.output` (encounter) |
| 10 | **No practitioner-in-organisation (role)** | Requester, owner and author are a person acting for an organisation (ODS) | [Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CareProfessional) has role and specialty but no organisation; organisations are ODS code strings on each object; no Organisation object | [PractitionerRole](StructureDefinition-PractitionerRole.html) (practitioner + organisation ODS), [Organization](StructureDefinition-Organization.html) |
| 11 | **Onward referrals and replacements not linked** | Referrals made from a care plan or from another referral (redirect, re-referral) | No `basedOn` / `replaces` on Referral; triage outcome "redirected" is text | `ServiceRequest.basedOn`, `replaces` |
| 12 | **Clinical documents are metadata only** | Reports are the referral outcome; recipients and type are needed for routing | Clinic Letter: type, date, consultant, status, content / media reference; no document type code, author organisation, recipients or sections | [Discharge Report](StructureDefinition-DischargeReport.html) (HDR `Composition`), `DocumentReference` |
{:.grid}

Represented well: patient identifiers ([Patient Identifier History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientIdentifierHistory)
type, value, assigning authority), GP practice registration (ODS code, named GP),
referral reason (SNOMED CT and ICD-10), priority, referrer and referring / provider
organisation ODS codes, appointment to referral link (`Appointment.referralId`), clinic
slots and sessions, professional registration (body and entry ID), related persons.

### Profile to CDM Object

| Profile (this guide) | FDP CDM object(s) | Fit |
|---|---|---|
| [Referral Request](StructureDefinition-ReferralRequest.html) (`ServiceRequest`) | [Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Referral), [UEC Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/UecReferral), [eRS Service](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ErsService) | Good for the request; gaps 3, 7, 11 |
| [Referral Task](StructureDefinition-ReferralTask.html) (`Task`) | Referral (`status`, `latestTriageOutcome`, dates) | **Gap 1** - no equivalent object |
| [Referral Appointment](StructureDefinition-ReferralAppointment.html) (`Appointment`) | [Appointment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Appointment) | Good |
| [Schedule](StructureDefinition-Schedule.html) / [Slot](StructureDefinition-Slot.html) | [Clinic Session](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicSession) / [Clinic Slot](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicSlot) | Good (outpatient clinics) |
| [Patient](StructureDefinition-Patient.html) | [Patient](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Patient), [Patient Identifier History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientIdentifierHistory), [GP Practice Registration](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/GpPracticeRegistration) | Good |
| [RelatedPerson](StructureDefinition-RelatedPerson.html) | [Patient Relationship History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientRelationshipHistory); Patient `nextOfKin*` | Good |
| [Organization](StructureDefinition-Organization.html) | None - ODS code strings on each object; [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site) `siteOdsCode` | Gap 10 |
| [Practitioner](StructureDefinition-Practitioner.html) | [Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CareProfessional) | Good |
| [PractitionerRole](StructureDefinition-PractitionerRole.html) | Care Professional (`role`, `mainSpecialty`); [Assigned Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/AssignedCareProfessional) | Gap 10 |
| [Location](StructureDefinition-Location.html) | [Location](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Location) (id, name, site), [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site) | Partial - no type or physical type |
| [Encounter](StructureDefinition-Encounter.html) | Appointment (attendance), Admission, Virtual Ward Stay - **not** CDM Encounter | Gap 4 |
| [Hospital Spell](StructureDefinition-HospitalSpell.html) | [Admission](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Admission) (Hospital Provider Spell), [Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/WardStay), [Consultant Episode](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ConsultantEpisode) | Good; gap 5 |
| [Visit](StructureDefinition-Visit.html) | Appointment (`attendanceId`), [Outpatient Activity](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/OutpatientActivity), [Virtual Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/VirtualWardStay) | Partial; gaps 5, 9 |
| [EpisodeOfCare](StructureDefinition-EpisodeOfCare.html) | [Patient Pathway](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientPathway) (RTT), Outpatient Activity (waiting list) - **To confirm** | Partial - RTT pathway, not a care episode |
| [Observation](StructureDefinition-Observation.html) | [Observation](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Observation), [Scored Assessment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ScoredAssessment) | Gap 8 |
| [Care Plan](StructureDefinition-PatientCarePlan.html) | [Community Care Plan](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CommunityCarePlan), [Team](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CdmTeam) | **Gap 6** |
| HDR `Composition` / `DocumentReference` | [Clinic Letter](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicLetter), [Clinical Note](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicalNote) | Gaps 2, 12 |
| [MessageHeader](StructureDefinition-MessageHeader.html), [Bundle](StructureDefinition-BundleMessage.html) | Not applicable - exchange, not persistence | - |
{:.grid}

### Referral Request and Referral Task

| FHIR element | CDM Referral property | Notes |
|---|---|---|
| `ServiceRequest.identifier[referralId]` (PLAC, assigner ODS) | `referralId`, `sourceUniqueId` | **Gap 3** - whose ID is not stated |
| `ServiceRequest.identifier[ubrn]` | `ubrn` | Good |
| `ServiceRequest.status` | `status`, `removed` | Combined with workflow state |
| `ServiceRequest.category` | `referralType`, `serviceTypeRequested` | Partial |
| `ServiceRequest.code` | `treatmentFunctionCode`, `serviceId` (eRS), `requestedAppointmentType` | Good |
| `ServiceRequest.priority` | `priorityCode` (NHS Data Dictionary priority type) | Good |
| `ServiceRequest.subject` | `patientId`, `mrn` | Good |
| `ServiceRequest.authoredOn` | `dateReferralCreated` | Good |
| `ServiceRequest.requester` | `referrerId` (not a foreign key), `referringOrganisationOdsCode`, `referralSource` | Partial - gap 10 |
| `ServiceRequest.performer` | `providerOrganisationOdsCode`, `trustOdsCode`, `siteId`, `specialtyId` | Good |
| `ServiceRequest.reasonCode` | `primaryReferralReasonCode`, `presentingComplaintSnomedCtCode`, `presentingComplaintIcd10Code` | Good |
| `ServiceRequest.reasonReference` | - | Gap 7 |
| `ServiceRequest.supportingInfo` | `referralLetterRid`, `referralLetterContent` | **Gap 7** - letter only |
| `ServiceRequest.note` | `referralNotes` | Good |
| `ServiceRequest.basedOn`, `replaces` | - (`pathwayId` links to the RTT pathway) | Gap 11 |
| `ServiceRequest.occurrence[x]` | `dueDate`, `earliestDueDate`, `daysToBookWithin` | Good |
| `Task.businessStatus` | `status` ([17 values](#referral-status-values)), `isPatientBookable`, `didNotProceed` | **Gap 1** - no history |
| `Task.statusReason` | `referralRejectionReasonCode`, `latestTriageOutcome` | Partial - rejection only |
| `Task.lastModified` | `latestTriageOutcomeTimestamp`, `referralRejectionTimestamp`, `dateReferralAccepted` | Partial - event dates, not a state history |
| `Task.owner` | - | **Gap 1** |
| `Task.input` (forms to complete) | - | Gap 7 |
| `Task.output` (appointment, outcome report) | Appointment `referralId` (appointment only) | **Gap 2** |
{:.grid}

### Patient Administration

| FHIR element | CDM property | Notes |
|---|---|---|
| `Patient.identifier[nhsNumber]` | Patient `nhsNumber`, `nhsNumberStatusIndicatorCode` | Good |
| `Patient.identifier[MedicalRecordNumber]`, `[PatientIdentifier]` (assigner ODS) | Patient `mrn`, `localPatientId`, `localPatientIdOrganisationOdsCode`; Patient Identifier History `identifierType`, `assigningAuthority` | Good |
| `Patient.name`, `birthDate`, `deceasedDateTime`, `address`, `telecom` | `firstName`, `middleName`, `surname`, `dateOfBirth`, `dateOfDeath`, `addressLine1`, `postcode`, `phoneNumber`, `email` | Good |
| `Patient.gender`, sex for clinical use | `phenotypicSexCode`, `statedGenderCode`, `genderIdentityCode` | Good |
| `Patient.generalPractitioner` (ODS) | GP Practice Registration `generalMedicalPracticeOdsCode`, `namedGeneralPractitionerId`; Patient `registeredGp` | Good |
| `HospitalSpell.identifier` (AN) | Admission `admissionId`, `admissionExternalId` | Gap 5 - **To confirm** |
| `HospitalSpell.period`, `hospitalization.admitSource`, `dischargeDisposition` | Admission `admissionTimestamp`, `dischargeTimestamp`, `admissionSourceCode`, `destinationOfDischargeCode`, `methodOfDischargeCode` | Good |
| `HospitalSpell.participant` (admitting, referring) | Consultant Episode, Assigned Care Professional | Partial |
| `HospitalSpell.location` | Ward Stay `wardId`; Admission `ward`, `bedLocation` | Good |
| `Visit.identifier` (VN), `Visit.partOf` (spell) | Appointment `attendanceId`, `appointmentExternalId`, `cdsUniqueId` | Gap 5 - no link to a spell |
| `Encounter.basedOn` (referral) | Appointment `referralId`; Outpatient Activity `referralId` | Good for outpatients; **gap 9** for virtual wards |
| `Encounter.status` | Appointment `attendanceStatusCode`, `bookingStatus`, `outcomeOfAttendanceCode` | Good |
| `Appointment.slot` | Clinic Slot `appointmentId` (link from slot) | Good |
| `PractitionerRole.organization` | - | Gap 10 |
| `Practitioner.identifier` | Care Professional `professionalRegistrationBodyCode`, `professionalRegistrationEntryId` | Good |
| `Location.type`, `physicalType`, `managingOrganization` | Location `siteId`; Site `siteType`, `siteOdsCode` | Partial |
{:.grid}

### Observations and Care Plan

| FHIR element | CDM property | Notes |
|---|---|---|
| `Observation.code` | `observationSnomedCtCode`, `observationCtv3code` | No LOINC |
| `Observation.value[x]` (`valueQuantity`, UCUM) | `observationValue` (string), `ucumUnitOfMeasurement` | **Gap 8** |
| `Observation.component` | - | Gap 8 |
| `Observation.status`, `category`, `performer` | - | Gap 8 |
| `Observation.effective[x]` | `observationTimestamp` | Good |
| `Observation.method`, `interpretation` | `method`, `interpretation` | Good |
| `Observation.encounter` | `admissionId`, `appointmentId`, `virtualWardStayId`, `uecAttendanceId` | Good |
| `CarePlan.category` | `communityCarePlanType` | Good |
| `CarePlan.status`, `period` | `implementationDate`, `isContentAgreed`, `isRemoved` | Partial |
| `CarePlan.author` / agreement | `contentAgreedBy`, `contentAgreedTimestamp` | Good |
| `CarePlan.activity` (referrals, visits, tasks) | - | **Gap 6** |
| `CarePlan.goal`, `addresses`, `supportingInfo` (assessment) | - | **Gap 6** |
| `CarePlan.careTeam` | - ([Team](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CdmTeam) is not linked) | Gap 6 |
{:.grid}

### Referral Status Values

The 17 allowed values of CDM `Referral.status` compared with this guide's
[referral workflow statuses](CodeSystem-referral-workflow-status.html)
(`Task.businessStatus`, from the 360X state transitions). Checked 2026-11-02; the CDM
gives no definitions for the values, so the mapping is by name - **To confirm**.

| CDM `Referral.status` | Workflow status (this guide) | Notes |
|---|---|---|
| Requested | `requested` | Match |
| Referral | `requested` | **To confirm** - meaning not defined |
| Awaiting triage | `requested` | Received, not yet triaged (`Task.status` received) |
| Accepted | `accepted` | Match |
| Open | `accepted` | **To confirm** - an open referral after acceptance |
| Waiting | `accepted` | **To confirm** - on a waiting list, not yet booked |
| Due | `accepted` | Not a state: derived from `dueDate` (booking deadline) |
| Past due | `accepted` | Not a state: derived from `dueDate` |
| Call letter sent | `accepted` / `appointment-booked` | **To confirm** - an invitation to book, or a booked appointment |
| Deferred | `deferred` (provisional) | Match; `Task.status` on-hold |
| Rejected | `declined` | Match; reason in `referralRejectionReasonCode` |
| Redirect | `redirected` (provisional) | Match; the referral to the other service is a new referral (`ServiceRequest.replaces`) |
| Complete | `completed` | Match only if the outcome report has been sent [PCC-57] |
| Closed | `completed` or `cancelled` | **To confirm** - ambiguous |
| Removed | `cancelled` | **To confirm** - removed from the waiting list, or entered in error (`Referral.removed`) |
| No referral status | - | Data quality value, not a state |
| NULL | - | Data quality value, not a state |
{:.grid}

This guide's statuses with no CDM status value:

| Workflow status | Where the CDM holds it, if anywhere |
|---|---|
| `information-requested` | - (eRS "return to referrer"; triage outcome text at best) |
| `appointment-booked`, `appointment-rescheduled`, `appointment-cancelled` | [Appointment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Appointment) `bookingStatus`, `dateTimeBooked`, `dateTimeCancelled` |
| `no-show` | Appointment `attendanceStatus`, `dnaCount`; Referral `didNotProceed` |
| `interim-report` | - |
| `cancel-requested` | - (no initiator-side states) |
| `cancelled` | Removed / Closed - **To confirm** |
{:.grid}

Findings:

- The CDM status list mixes three kinds of value: **workflow states** (Requested,
  Accepted, Rejected, Complete), **derived timing flags** (Due, Past due) and **data
  quality values** (No referral status, NULL). Only the first belongs in a workflow
  status; the others should be derived or validated.
- The CDM values are the **Referral Recipient's** view. States driven by the Referral
  Initiator (cancel requested) or by the closing report (completed with outcome,
  interim report) are missing - gap 1 and gap 2 above.
- Redirect and Deferred point to NHS operations missing from 360X. Provisional
  `redirected` and `deferred` workflow statuses are based on HL7 v2 (ORC-1 `RU`, `OH`)
  and FHIR Task, not on the CDM (see [State Transitions](360X.html#state-transitions)) -
  the processes are **To confirm** against eRS and provider practice.

### Open Questions

- Which CDM property carries the Hospital Provider Spell Number and the Visit Number
  (`admissionExternalId`, `appointmentExternalId`, `cdsUniqueId`) - **To confirm**.
- Whether `Referral.sourceUniqueId` is the Referral Initiator's (placer) ID or the
  receiving system's ID - **To confirm**.
- Definitions of the CDM `Referral.status` values (Referral, Open, Waiting, Closed,
  Removed, Call letter sent) - **To confirm**; see [Referral Status Values](#referral-status-values).
- Whether [Task](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/RttTask)
  (`RttTask`) is a work-list item or could hold referral fulfilment - **To confirm**.
