Logical:        Referral
Id:             Referral
Title:          "Clinical Referral"
Description:    """
**Proof of concept - not an authoritative source.**

The information exchanged during a closed loop referral, from the referral request to
the referral outcome. Based on the data items of the
[IHE 360X](https://www.ihe.net/uploadedFiles/Documents/PCC/IHE_PCC_Suppl_360X.pdf)
transactions (PCC TF-2 3.55 to 3.61), FHIR Workflow and HL7 v2 orders, with the UBRN
from [eRS](https://digital.nhs.uk/developer/api-catalogue/e-referral-service-fhir).
It is the same for a referral to an outpatient clinic, a community service or a
[virtual ward](VirtualWards.html). National services such as BaRS are mapped onto this
model (see the [BaRS review](BaRS.html)), not the other way round. The PRSB
[Clinical Referral Information Standard](https://theprsb.org/standards/clinical-referral-information-standard/)
v1.0 gives the clinical headings.

The referral stays small: the clinical content is in separate documents referenced as
supporting information - a [Discharge Report](StructureDefinition-DischargeReport.html)
or clinic letter for the episode, a [Patient Summary](StructureDefinition-PatientSummary.html)
and referral forms. A referral may be one activity of a
[Care Plan](StructureDefinition-CarePlanModel.html).

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
* clinicalDocument 0..* Reference(DocumentReference or Bundle) "Clinical document" "The referrer's account of the episode that led to the referral - Discharge Report (HL7 Europe HDR) or clinic letter"
* patientSummary 0..1 Reference(DocumentReference or Bundle) "Patient summary" "The patient's background (HL7 Europe Patient Summary), when the recipient cannot query the record"
* forms 0..* Reference(QuestionnaireResponse) "Referral forms" "Forms completed for the referral - see Referral Forms"
* observations 0..* Reference(Observation) "Observations" "Findings needed by the recipient, e.g. vital signs"
* carePlan 0..1 Reference(CarePlan) "Care plan" "The care plan this referral carries out, if any"
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
* referrer.organisation -> "ORC-21 (required in this guide) / MSH-4"
* recipient -> "MSH-5 / MSH-6"
* serviceRequested -> "OBR-4 (360X default LOINC 57133-1 Referral note)"
* priority -> "TQ1-9"
* expectedBy -> "TQ1-8"
* validityPeriod -> "TQ1-6"
* reasonForReferral -> "OBR-31"
* referralQuestion -> "OBX-5 (OBX-11 O, OBX-29 QST)"
* clinicalDocument -> "CDA document in the XDM package (360X); NHS: OBX type ED or RP, or MDM^T02"
* patientSummary -> "CDA document in the XDM package (360X); NHS: OBX type ED or RP"
* forms -> "OBX (ask at order entry)"
* observations -> "OBX"
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
* clinicalDocument -> "ServiceRequest.supportingInfo (Bundle - HL7 Europe HDR, or DocumentReference)"
* patientSummary -> "ServiceRequest.supportingInfo (Bundle - HL7 Europe EPS, or DocumentReference)"
* forms -> "ServiceRequest.supportingInfo (QuestionnaireResponse)"
* observations -> "ServiceRequest.supportingInfo (Observation)"
* carePlan -> "ServiceRequest.basedOn (CarePlan)"
* dateOfReferral -> "ServiceRequest.authoredOn"
* status -> "Task.businessStatus (and Task.status, ServiceRequest.status)"
* statusReason -> "Task.statusReason"
* appointment -> "Appointment (basedOn the ServiceRequest)"
* appointment.appointmentId -> "Appointment.identifier"
* appointment.dateTime -> "Appointment.start"
* appointment.provider -> "Appointment.participant.actor"
* appointment.status -> "Appointment.status"
* interimNote -> "Task.output (clinical document - Composition with HL7 Europe HDR section codes)"
* outcome -> "Task.output (Discharge Report - HL7 Europe HDR, or clinic letter)"

Mapping:        Referral-PRSB
Source:         Referral
Target:         "https://theprsb.org/standards/clinical-referral-information-standard/"
Id:             prsb-cris
Title:          "PRSB Clinical Referral Information Standard v1.0"
* -> "Sections: GP Practice (M), Patient Demographics (M), Referral Details (M), Reason for referral (M), Allergies and adverse reactions (M), Person completing record (M); Individual requirements, Medications and medical devices, Safety Alerts, Person concerns, expectations and wishes, Legal Information, Information and advice given, Participation in research (R); Family History, Social Context, Examination Findings, Assessment Scales, Relevant clinical risk factors, Investigations and results, Distribution list (O). Referral Details sub-elements from the Core Information Standard v2.01. Mapping indicative - To confirm"
* patient -> "Patient Demographics; GP Practice"
* referrer -> "Referral Details: Referrer details; Person completing record"
* recipient -> "Referral Details: Referral to"
* serviceRequested -> "Referral Details: Referral to; Referral criteria"
* priority -> "Referral Details: Clinical urgency of referral"
* expectedBy -> "Referral Details: Clinical urgency of referral"
* reasonForReferral -> "Reason for referral"
* referralQuestion -> "Reason for referral"
* clinicalDocument -> "Examination Findings; Investigations and results; Relevant clinical risk factors; Information and advice given"
* patientSummary -> "Allergies and adverse reactions; Medications and medical devices; Safety Alerts; Legal Information; Individual requirements; Family History; Social Context"
* forms -> "Assessment Scales"
* observations -> "Examination Findings; Investigations and results"
* dateOfReferral -> "Referral Details: Date"
