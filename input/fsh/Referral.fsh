Logical:        Referral
Id:             Referral
Title:          "Referral"
Description:    """
**Proof of concept - not an authoritative source.**

The information exchanged during a closed loop referral, from the referral request to
the referral outcome. Based on the data items of the
[IHE 360X](https://www.ihe.net/uploadedFiles/Documents/PCC/IHE_PCC_Suppl_360X.pdf)
transactions (PCC TF-2 3.55 to 3.61), with the NHS England items carried by
[eRS](https://digital.nhs.uk/developer/api-catalogue/e-referral-service-fhir) and
[BaRS](https://digital.nhs.uk/developer/api-catalogue/booking-and-referral-fhir).
It is the same for a referral to an outpatient clinic, a community service or a
[virtual ward](VirtualWards.html).

The **Mappings** tab shows each element in HL7 v2 (360X) and FHIR.
"""
Characteristics: #can-be-target

* ^experimental = true

// Identification - PCC TF-1 X.1.3

* referralId 1..1 Identifier "Referral ID" "Unique identifier assigned by the Referral Initiator, used in every message about the referral"
* ubrn 0..1 Identifier "Unique Booking Reference Number" "eRS identifier, if the referral was made through eRS"
* patient 1..1 BackboneElement "Patient" "The patient referred"
  * nhsNumber 0..1 Identifier "NHS Number" "Traced NHS Number"
  * localIdentifier 0..* Identifier "Local patient identifier" "Referral Initiator's identifier (360X sourcePatientId), and any identifier the Referral Recipient adds"
  * demographics 1..1 BackboneElement "Demographics" "Name, date of birth, sex, address"

// Request - PCC-55

* referrer 1..1 BackboneElement "Referrer" "The Referral Initiator"
  * clinician 1..1 Identifier "Referring clinician" "Professional registration or GP code"
  * organisation 1..1 Identifier "Referring organisation" "ODS code"
* recipient 0..1 BackboneElement "Referred to" "The Referral Recipient"
  * service 0..1 Identifier "Service" "eRS service ID, Directory of Services ID or local service"
  * clinician 0..1 Identifier "Clinician" "Named clinician, if any"
  * organisation 0..1 Identifier "Organisation" "ODS code"
* serviceRequested 1..1 CodeableConcept "Service requested" "Specialty, clinic type or referral procedure"
* priority 0..1 code "Priority" "routine, urgent, urgent suspected cancer, two week wait"
* expectedBy 0..1 dateTime "Expected service provision time" "The date by which the service should be provided (urgency converted to a date)"
* validityPeriod 0..1 Period "Validity" "Period the referral is valid for"
* reasonForReferral 1..* CodeableConcept "Reason for referral" "Coded (SNOMED CT) or text"
* referralQuestion 0..1 string "Referral question" "The clinical question for the Referral Recipient"
* clinicalInformation 0..* Reference(DocumentReference or Bundle or QuestionnaireResponse) "Clinical information" "Referral letter or FHIR Document with the relevant clinical record"
* dateOfReferral 1..1 dateTime "Date of referral" "When the referral was made"

// Status - PCC-55 to PCC-58

* status 1..1 code "Referral status" "360X state - see Referral Workflow Status"
* statusReason 0..1 CodeableConcept "Reason for decline or cancellation" "Free text at least"

// Scheduling option - PCC-60, PCC-61

* appointment 0..* BackboneElement "Appointment" "Appointments booked to carry out the referral"
  * appointmentId 1..1 Identifier "Appointment ID" "Unique identifier of the appointment"
  * dateTime 1..1 dateTime "Appointment date and time" "At least the date"
  * provider 0..1 Identifier "Appointment provider" "Clinician or service seeing the patient"
  * status 1..1 code "Appointment status" "booked, rescheduled, cancelled, no-show"

// Results - PCC-59, PCC-57

* interimNote 0..* Reference(DocumentReference or Bundle) "Interim consultation note" "Results sent before the end of care"
* outcome 0..1 Reference(DocumentReference or Bundle) "Referral outcome" "Report that closes the loop - consultation note, discharge report or care plan"

Mapping:        Referral-HL7v2
Source:         Referral
Target:         "https://www.ihe.net/uploadedFiles/Documents/PCC/IHE_PCC_Suppl_360X.pdf"
Id:             hl7-v2-360x
Title:          "HL7 v2.5.1 (IHE 360X)"
* referralId -> "ORC-2 and OBR-2 (OMG^O19); ORC-2 (OSU^O51); SCH-26 (SIU)"
* ubrn -> "Not in 360X; NHS: ORC-2 or OBR-2 repetition with UBRN assigning authority (To confirm)"
* patient -> "PID"
* patient.nhsNumber -> "PID-3 (assigning authority NHS)"
* patient.localIdentifier -> "PID-3"
* patient.demographics -> "PID-5, PID-7, PID-8, PID-11"
* referrer.clinician -> "ORC-12 and OBR-16"
* referrer.organisation -> "ORC-21 / MSH-4"
* recipient -> "MSH-5 / MSH-6"
* serviceRequested -> "OBR-4 (360X default LOINC 57133-1 Referral note)"
* priority -> "TQ1-9"
* expectedBy -> "TQ1-8"
* validityPeriod -> "TQ1-6"
* reasonForReferral -> "OBR-31"
* referralQuestion -> "OBX-5 (OBX-11 O, OBX-29 QST)"
* clinicalInformation -> "CDA document in the XDM package (360X); NHS: OBX type ED or RP, or MDM^T02"
* dateOfReferral -> "ORC-9"
* status -> "ORC-1 / ORC-5"
* statusReason -> "ORC-16"
* appointment.appointmentId -> "SCH-2"
* appointment.dateTime -> "TQ1-7"
* appointment.provider -> "AIP-3"
* appointment.status -> "SIU trigger S12 / S13 / S15 / S26 (RGS-2)"
* interimNote -> "OSU^O51 (ORC-1 SC, ORC-5 A) with document"
* outcome -> "OSU^O51 (ORC-1 SC, ORC-5 CM) with document"

Mapping:        Referral-FHIR
Source:         Referral
Target:         "http://hl7.org/fhir/R4"
Id:             fhir
Title:          "FHIR R4"
* referralId -> "ServiceRequest.identifier:referralId; Task.basedOn.identifier; Appointment.basedOn.identifier"
* ubrn -> "ServiceRequest.identifier:ubrn"
* patient -> "ServiceRequest.subject (Patient)"
* patient.nhsNumber -> "Patient.identifier:nhsNumber"
* patient.localIdentifier -> "Patient.identifier:MedicalRecordNumber"
* patient.demographics -> "Patient.name, birthDate, gender, address"
* referrer.clinician -> "ServiceRequest.requester (PractitionerRole.practitioner)"
* referrer.organisation -> "ServiceRequest.requester (PractitionerRole.organization)"
* recipient -> "ServiceRequest.performer; Task.owner"
* serviceRequested -> "ServiceRequest.code"
* priority -> "ServiceRequest.priority"
* expectedBy -> "ServiceRequest.occurrenceDateTime"
* validityPeriod -> "Task.restriction.period (or ServiceRequest.occurrencePeriod)"
* reasonForReferral -> "ServiceRequest.reasonCode / reasonReference"
* referralQuestion -> "ServiceRequest.note"
* clinicalInformation -> "ServiceRequest.supportingInfo"
* dateOfReferral -> "ServiceRequest.authoredOn"
* status -> "Task.businessStatus (and Task.status, ServiceRequest.status)"
* statusReason -> "Task.statusReason"
* appointment -> "Appointment (basedOn the ServiceRequest)"
* appointment.appointmentId -> "Appointment.identifier"
* appointment.dateTime -> "Appointment.start"
* appointment.provider -> "Appointment.participant.actor"
* appointment.status -> "Appointment.status"
* interimNote -> "Task.output (Consultation Note document)"
* outcome -> "Task.output (Referral Outcome document)"
