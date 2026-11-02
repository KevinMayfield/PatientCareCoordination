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
`REF_I12` and the eRS `ServiceRequest`; BaRS referrals are mapped onto it (see
[BaRS](BaRS.html)). Also used
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
* supportingInfo ^short = "Clinical information: referral form (QuestionnaireResponse), observations, referral letter, FHIR Document, results"
* supportingInfo ^comment = "Forms completed at referral (ask at order entry), such as exercise pre-participation screening, are QuestionnaireResponses; the answers needed as data SHOULD also be sent as Observations. Attached forms (PDF) are DocumentReferences. See Referral Forms."

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
and no-show notifications. See [Overview Model](DataModel.html#referral-status) for
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

* input MS
* input ^short = "Form the Referral Recipient asks to be completed (Questionnaire), by the patient or the referrer"
* input.type from ReferralTaskParameterVS (extensible)
* input.value[x] only canonical or Reference
* input.valueCanonical only Canonical(Questionnaire)
* input.valueReference only Reference(Questionnaire or DocumentReference)

* output MS
* output ^short = "Completed form, appointment, interim consultation note, progress observations or referral outcome"
* output.type from ReferralTaskParameterVS (extensible)
* output.value[x] only Reference
* output.valueReference only Reference(QuestionnaireResponse or Observation or Appointment or Composition or Bundle or DocumentReference or DiagnosticReport or Encounter or CarePlan)

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
* slot MS
* slot only Reference(Slot)
* slot ^short = "The Slot booked (eRS, GP Connect Appointment Management and local booking all book Slots)"
* start 1..1 MS
* start ^short = "Appointment date and time (TQ1-7)"
* end MS
* participant MS
* participant.actor MS
* participant ^short = "The patient and the appointment provider (AIP-3)"

// Clinical documents (Interim Consultation Note [PCC-59], Referral Outcome [PCC-57]) use
// the HL7 Europe Hospital Discharge Report profiles directly - no local profiles.
