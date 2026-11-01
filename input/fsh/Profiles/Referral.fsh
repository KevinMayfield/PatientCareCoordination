Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $task-code = http://hl7.org/fhir/CodeSystem/task-code
Alias: $event-basedOn = http://hl7.org/fhir/StructureDefinition/event-basedOn

// Identifiers

Profile:        ReferralIdentifier
Parent:         CorrelationIdentifier
Id:             ReferralIdentifier
Title:          "Referral Identifier"
Description:    """
The Referral Initiator's unique identifier for the referral (360X Referral ID, HL7 v2
ORC-2 / OBR-2 placer order number). It **SHALL** be used in every later message about
the referral, by both actors (PCC TF-1 X.1.3).
"""

* type = $v2-0203#PLAC (exactly)
* system 1..1
* value 1..1
* assigner 1..1

Profile:        UniqueBookingReferenceNumber
Parent:         http://hl7.org/fhir/StructureDefinition/Identifier
Id:             UniqueBookingReferenceNumber
Title:          "Unique Booking Reference Number (UBRN)"
Description:    """
NHS e-Referral Service (eRS) referral identifier. Only present when the referral was
made through eRS. System as used by the eRS R4 `ServiceRequest` API.
"""

* system 1..1
* system = "https://fhir.nhs.uk/Id/UBRN" (exactly)
* value 1..1

// Referral Request [PCC-55]

Profile:        ReferralRequest
Parent:         http://hl7.org/fhir/StructureDefinition/ServiceRequest
Id:             ReferralRequest
Title:          "Referral Request"
Description:    """
`Referral` - the request from the Referral Initiator to the Referral Recipient
([Referral Request [PCC-55]](PCC-55.html)). Equivalent to HL7 v2 `OMG^O19` (360X) or
`REF_I12`, the eRS `ServiceRequest` and the BaRS referral `ServiceRequest`. Also used
for referrals to a [virtual ward](VirtualWards.html).
"""

* identifier 1..* MS
* identifier ^slicing.discriminator.type = #profile
* identifier ^slicing.discriminator.path = "$this"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the identifier profile"
* identifier ^slicing.ordered = false
* identifier contains
    referralId 1..1 MS
    and ubrn 0..1 MS
* identifier[referralId] only ReferralIdentifier
* identifier[referralId] ^short = "Referral ID assigned by the Referral Initiator (ORC-2 / OBR-2)"
* identifier[ubrn] only UniqueBookingReferenceNumber
* identifier[ubrn] ^short = "eRS Unique Booking Reference Number, if referred through eRS"

* basedOn MS
* basedOn ^short = "The care plan this referral carries out (Dynamic Care Planning)"
* replaces MS
* replaces ^short = "A declined or cancelled referral this one replaces (a new referral needs a new Referral ID)"

* status MS
* intent = #order (exactly)

* category 1..* MS
* category from ReferralCategory (extensible)

* priority MS
* priority ^short = "routine | urgent | asap | stat - see NHS mapping on the PCC-55 page"

* code 1..1 MS
* code from ReferralServiceType (extensible)
* code ^short = "Service referred to (eRS specialty / clinic type, or a SNOMED CT referral procedure)"

* subject 1..1 MS
* subject only Reference(Patient)
* subject.identifier only NHSIdentifier

* encounter MS
* encounter ^short = "The encounter in which the referral was made"

* occurrence[x] MS
* occurrence[x] ^short = "When the service should be provided - TQ1-8 expected service provision time; a Period for the referral's validity (TQ1-6)"

* authoredOn 1..1 MS

* requester 1..1 MS
* requester only Reference(PractitionerRole or Practitioner or Organization)
* requester ^short = "Referring clinician (ORC-12 / OBR-16) - the Referral Initiator"

* performer MS
* performer only Reference(PractitionerRole or Organization or HealthcareService)
* performer ^short = "Service or clinician referred to - the Referral Recipient"

* reasonCode MS
* reasonCode ^short = "Reason(s) for referral (OBR-31)"
* reasonReference MS
* reasonReference only Reference(Condition or Observation or DiagnosticReport or DocumentReference)

* supportingInfo MS
* supportingInfo ^short = "Clinical information: referral letter, FHIR Document, questionnaire response, results"

* note MS
* note ^short = "Referral question - the clinical question for the Referral Recipient (OBX with OBX-29 QST)"

// Referral workflow - status updates [PCC-55] to [PCC-61]

Profile:        ReferralTask
Parent:         http://hl7.org/fhir/StructureDefinition/Task
Id:             ReferralTask
Title:          "Referral Task"
Description:    """
`Referral Workflow` - the state of a referral, shared between the Referral Initiator
and the Referral Recipient. FHIR equivalent of the 360X HL7 v2 `OSU^O51` order status
updates (accept, decline, interim note, outcome, cancel) and of the `SIU` appointment
and no-show notifications. See [FHIR Resources](DataModel.html#referral-status) for
the status mapping.
"""

* identifier MS

* basedOn 1..* MS
* basedOn only Reference(ReferralRequest)
* basedOn.identifier only ReferralIdentifier
* basedOn ^short = "The referral (by Referral ID)"

* focus 1..1 MS
* focus only Reference(ReferralRequest)

* for 1..1 MS
* for only Reference(Patient)
* for.identifier only NHSIdentifier

* status MS
* businessStatus 1..1 MS
* businessStatus from ReferralWorkflowStatusVS (required)
* businessStatus ^short = "360X referral state"

* statusReason MS
* statusReason from ReferralStatusReasonVS (example)
* statusReason ^short = "Reason for decline or cancellation (ORC-16)"

* intent = #order (exactly)
* code = $task-code#fulfill
* priority MS

* authoredOn 1..1 MS
* lastModified 1..1 MS

* requester 1..1 MS
* requester only Reference(PractitionerRole or Practitioner or Organization)
* requester ^short = "Referral Initiator"

* owner MS
* owner only Reference(PractitionerRole or Organization or HealthcareService)
* owner ^short = "Referral Recipient - the service that has taken (or been asked to take) responsibility"

* restriction.period MS
* restriction.period ^short = "Period the referral is valid for (TQ1-6)"

* note MS

* output MS
* output ^short = "Appointment, interim consultation note or referral outcome"
* output.value[x] only Reference
* output.valueReference only Reference(Appointment or Composition or Bundle or DocumentReference or Encounter or CarePlan)

// Appointment Notification [PCC-60] and No-Show Notification [PCC-61]

Profile:        ReferralAppointment
Parent:         http://hl7.org/fhir/StructureDefinition/Appointment
Id:             ReferralAppointment
Title:          "Referral Appointment"
Description:    """
`Appointment` booked to carry out a referral - FHIR equivalent of the 360X Scheduling
Option HL7 v2 `SIU^S12` (new), `SIU^S13` (reschedule), `SIU^S15` (cancel) and
`SIU^S26` (no-show) messages.
"""

* identifier 1..* MS
* identifier ^short = "Appointment ID (SCH-2)"
* status MS
* status ^short = "booked (S12/S13) | cancelled (S15) | noshow (S26) | fulfilled"
* basedOn 1..* MS
* basedOn only Reference(ReferralRequest)
* basedOn.identifier only ReferralIdentifier
* basedOn ^short = "The referral (SCH-26 Referral ID)"
* serviceType MS
* reasonCode MS
* start 1..1 MS
* start ^short = "Appointment date and time (TQ1-7)"
* end MS
* participant MS
* participant.actor MS
* participant ^short = "The patient and the appointment provider (AIP-3)"

// Interim Consultation Note [PCC-59] and outpatient Referral Outcome [PCC-57]

Profile:        ConsultationNote
Parent:         http://hl7.org/fhir/StructureDefinition/Composition
Id:             ConsultationNote
Title:          "Consultation Note"
Description:    """
`Consultation Note` - the Composition of a FHIR Document sent by the Referral Recipient
as an [Interim Consultation Note [PCC-59]](PCC-59.html), or as the
[Referral Outcome [PCC-57]](PCC-57.html) of an outpatient referral (clinic letter). Equivalent to a Transfer of Care outpatient letter. Sections follow the HL7
Europe Hospital Discharge Report where they overlap.
"""

* extension contains $event-basedOn named basedOn 1..* MS
* extension[basedOn] ^short = "The referral this note responds to"
* extension[basedOn].valueReference only Reference(ReferralRequest)
* extension[basedOn].valueReference.identifier only ReferralIdentifier

* identifier 1..1 MS
* status MS
* type = $loinc#11488-4 "Consult Note"
* subject 1..1 MS
* subject only Reference(Patient)
* encounter MS
* date MS
* author 1..* MS
* title MS
* custodian MS

* section 1..* MS
* section.title 1..1
* section.code 1..1
* section ^slicing.discriminator.type = #pattern
* section ^slicing.discriminator.path = "code"
* section ^slicing.rules = #open
* section ^slicing.ordered = false
* section contains
    reasonForReferral 0..1 MS
    and historyOfPresentIllness 0..1 MS
    and assessment 0..1 MS
    and planOfCare 0..1 MS
    and problems 0..1 MS
    and results 0..1 MS
* section[reasonForReferral].code = $loinc#29299-5 "Reason for visit Narrative"
* section[historyOfPresentIllness].code = $loinc#10164-2 "History of Present illness Narrative"
* section[assessment].code = $loinc#51848-0 "Evaluation Note"
* section[planOfCare].code = $loinc#18776-5 "Plan of Care Note"
* section[problems].code = $loinc#11450-4 "Problem list - Reported"
* section[results].code = $loinc#30954-2 "Relevant diagnostic tests/laboratory data note"

// Referral Outcome [PCC-57] - discharge from a hospital or virtual ward spell

Profile:        DischargeReport
Parent:         http://hl7.eu/fhir/hdr/StructureDefinition/composition-eu-hdr
Id:             DischargeReport
Title:          "Discharge Report"
Description:    """
`Discharge Report` - the [HL7 Europe Hospital Discharge Report](https://hl7.eu/fhir/hdr/)
Composition, used as the [Referral Outcome [PCC-57]](PCC-57.html) when the referral
led to an inpatient or [virtual ward](VirtualWards.html) stay. The only addition to HDR
is that the document **SHALL** reference the referral it closes. For an outpatient
referral the outcome is a [Consultation Note](StructureDefinition-ConsultationNote.html)
(HDR only allows inpatient encounters).
"""

* extension[basedOn] 1..* MS
* extension[basedOn] ^short = "The referral this report closes"
* extension[basedOn].valueReference only Reference(ReferralRequest)
* extension[basedOn].valueReference.identifier only ReferralIdentifier
* extension[informationRecipient] MS
* extension[informationRecipient] ^short = "The Referral Initiator (and the patient's GP, if different)"

Profile:        DischargeReportDocument
Parent:         http://hl7.eu/fhir/hdr/StructureDefinition/bundle-eu-hdr
Id:             DischargeReportDocument
Title:          "Discharge Report Document"
Description:    "FHIR Document (HL7 Europe Hospital Discharge Report) whose Composition is a [Discharge Report](StructureDefinition-DischargeReport.html)."

* entry[composition].resource only DischargeReport
