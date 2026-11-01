// 360X Use Case #1 (PCP to Specialist) restated for the NHS: a GP refers a patient
// with shortness of breath to a hospital cardiology service. Patients are NW GMSA test
// patients (https://nw-gmsa.github.io/en/testing.html#test-patients); other data is fictitious.

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $nhs-number = https://fhir.nhs.uk/Id/nhs-number
Alias: $gmp-number = https://fhir.hl7.org.uk/Id/gmp-number
Alias: $gmc-number = https://fhir.hl7.org.uk/Id/gmc-number
Alias: $condition-clinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-category = http://terminology.hl7.org/CodeSystem/condition-category
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $event-basedOn = http://hl7.org/fhir/StructureDefinition/event-basedOn

// Participants

Instance: Patient-Tameside
InstanceOf: Patient
Title: "Patient - Hodor TAMESIDE NHS Number: 9737383397"
Description: "NW GMSA test patient (https://nw-gmsa.github.io/en/testing.html#test-patients), MFT MRN from the NW GMSA Testing MRN-Mapping. Referred by his GP to cardiology."
Usage: #example
* identifier[nhsNumber].system = $nhs-number
* identifier[nhsNumber].value = "9737383397"
* identifier[nhsNumber].type = $v2-0203#NH
* identifier[MedicalRecordNumber].type = $v2-0203#MR
* identifier[MedicalRecordNumber].system = "https://fhir.mft.nhs.uk/Id/mrn"
* identifier[MedicalRecordNumber].value = "B6789012"
* identifier[MedicalRecordNumber].assigner.identifier.system = $ods-code
* identifier[MedicalRecordNumber].assigner.identifier.value = "R0A"
* name.family = "TAMESIDE"
* name.given = "Hodor"
* gender = #male
* birthDate = "1960-07-27"
* address.line = "Stockport Road"
* address.city = "Tameside"
* address.postalCode = "OL7 0NS"
* generalPractitioner.identifier.system = $ods-code
* generalPractitioner.identifier.value = "P89020"
* generalPractitioner.display = "HT PRACTICE"

Instance: P89020
InstanceOf: Organization
Title: "Organization - HT PRACTICE (P89020)"
Description: "GP practice of the test patient Hodor TAMESIDE (real ODS code, as the NW GMSA test patients require) - the Referral Initiator."
Usage: #example
* identifier[odsOrganisationCode].system = $ods-code
* identifier[odsOrganisationCode].value = "P89020"
* name = "HT PRACTICE"

Instance: R0A
InstanceOf: Organization
Title: "Organization - Manchester University NHS Foundation Trust"
Description: "Hospital trust - the Referral Recipient."
Usage: #example
* identifier.system = $ods-code
* identifier.value = "R0A"
* name = "Manchester University NHS Foundation Trust"

Instance: GPAllen
InstanceOf: Practitioner
Title: "Practitioner - Dr Allen (GP)"
Description: "The referring GP."
Usage: #example
* identifier.system = $gmp-number
* identifier.value = "G1234567"
* name.family = "Allen"
* name.prefix = "Dr"

Instance: GPAllenRole
InstanceOf: PractitionerRole
Title: "PractitionerRole - Dr Allen at HT PRACTICE"
Description: "The referring GP at HT PRACTICE (P89020) - the Referral Initiator."
Usage: #example
* practitioner = Reference(GPAllen)
* organization = Reference(P89020)
* organization.identifier.system = $ods-code
* organization.identifier.value = "P89020"
* code = $sct#62247001 "General practitioner"

Instance: CardiologistBrown
InstanceOf: Practitioner
Title: "Practitioner - Dr Brown (Cardiologist)"
Description: "The consultant cardiologist."
Usage: #example
* identifier.system = $gmc-number
* identifier.value = "7654321"
* name.family = "Brown"
* name.prefix = "Dr"

Instance: CardiologistBrownRole
InstanceOf: PractitionerRole
Title: "PractitionerRole - Dr Brown, Cardiology, MFT"
Description: "The consultant cardiologist at the hospital trust."
Usage: #example
* practitioner = Reference(CardiologistBrown)
* organization = Reference(R0A)
* organization.identifier.system = $ods-code
* organization.identifier.value = "R0A"
* specialty = $sct#394579002 "Cardiology"

Instance: CardiologyService
InstanceOf: HealthcareService
Title: "HealthcareService - MFT General Cardiology Outpatients"
Description: "The service referred to. In eRS this is an eRS service with an eRS service ID."
Usage: #example
* identifier.system = "https://fhir.nhs.uk/Id/ers-service"
* identifier.value = "1234567"
* providedBy = Reference(R0A)
* name = "General Cardiology Outpatients"
* specialty = $sct#394579002 "Cardiology"

// Clinical information

Instance: ConditionDyspnoea
InstanceOf: Condition
Title: "Condition - Shortness of breath"
Description: "The reason for the cardiology referral."
Usage: #example
* clinicalStatus = $condition-clinical#active
* category = $condition-category#problem-list-item
* code = $sct#267036007 "Dyspnea"
* subject = Reference(Patient-Tameside)
* recordedDate = "2026-09-04"

// Referral Request [PCC-55]

Instance: CardiologyReferral
InstanceOf: ReferralRequest
Title: "Referral Request - GP to Cardiology"
Description: "Referral Request [PCC-55]: Dr Allen refers Mr Tameside to cardiology, to be seen within a week."
Usage: #example
* identifier[referralId].type = $v2-0203#PLAC
* identifier[referralId].system = "https://fhir.example-practice.nhs.uk/Id/referral"
* identifier[referralId].value = "REF-2026-000123"
* identifier[referralId].assigner.identifier.system = $ods-code
* identifier[referralId].assigner.identifier.value = "P89020"
* identifier[ubrn].system = "https://fhir.nhs.uk/Id/UBRN"
* identifier[ubrn].value = "000049637246"
* status = #active
* intent = #order
* category = $sct#3457005 "Patient referral"
* priority = #urgent
* code = $sct#183519002 "Referral to cardiology service"
* subject = Reference(Patient-Tameside)
* subject.identifier.system = $nhs-number
* subject.identifier.value = "9737383397"
* subject.identifier.type = $v2-0203#NH
* occurrenceDateTime = "2026-09-11"
* authoredOn = "2026-09-04T10:15:00+01:00"
* requester = Reference(GPAllenRole)
* performer = Reference(CardiologyService)
* reasonCode = $sct#267036007 "Dyspnea"
* reasonReference = Reference(ConditionDyspnoea)
* note.text = "Determine the origin of Mr Tameside's shortness of breath. BMI 30, non-smoker, no chest pain, family history of coronary artery disease."

// Referral Accept [PCC-55]

Instance: CardiologyReferralAccepted
InstanceOf: ReferralTask
Title: "Referral Task - Accepted"
Description: "Referral Accept [PCC-55]: cardiology has triaged and accepted the referral (HL7 v2 OSU^O51, ORC-1 OK, ORC-5 IP)."
Usage: #example
* basedOn = Reference(CardiologyReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000123"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* focus = Reference(CardiologyReferral)
* for = Reference(Patient-Tameside)
* status = #accepted
* businessStatus = ReferralWorkflowStatus#accepted
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-09-04T10:15:00+01:00"
* lastModified = "2026-09-05T09:30:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(CardiologyService)

// Referral Decline [PCC-56] - alternative outcome

Instance: CardiologyReferralDeclined
InstanceOf: ReferralTask
Title: "Referral Task - Declined"
Description: "Referral Decline [PCC-56]: the alternative path, where the service declines the referral (HL7 v2 OSU^O51, ORC-1 UA, ORC-5 CA, reason in ORC-16)."
Usage: #example
* basedOn = Reference(CardiologyReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000123"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* focus = Reference(CardiologyReferral)
* for = Reference(Patient-Tameside)
* status = #rejected
* businessStatus = ReferralWorkflowStatus#declined
* statusReason = ReferralStatusReason#service-not-provided
* statusReason.text = "Please refer to the rapid access chest pain clinic instead."
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-09-04T10:15:00+01:00"
* lastModified = "2026-09-05T09:30:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(CardiologyService)

// Appointment Notification [PCC-60]

Instance: CardiologyAppointment
InstanceOf: ReferralAppointment
Title: "Referral Appointment - Cardiology clinic"
Description: "Appointment Notification [PCC-60]: the appointment booked for 7 September (HL7 v2 SIU^S12)."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/appointment"
* identifier.value = "APT-998877"
* status = #booked
* basedOn = Reference(CardiologyReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000123"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* serviceType = $sct#394579002 "Cardiology"
* slot = Reference(CardiologyClinicSlot)
* start = "2026-09-07T14:00:00+01:00"
* end = "2026-09-07T14:30:00+01:00"
* participant[+].actor = Reference(Patient-Tameside)
* participant[=].status = #accepted
* participant[+].actor = Reference(CardiologistBrownRole)
* participant[=].status = #accepted

// Interim Consultation Note [PCC-59]

Instance: CardiologyInterimNote
InstanceOf: ConsultationNote
Title: "Consultation Note - Interim (cardiology clinic)"
Description: "Interim Consultation Note [PCC-59]: after the first clinic, answers the referral question and gives the date of the cardiac catheterisation."
Usage: #example
* extension[basedOn].valueReference = Reference(CardiologyReferral)
* extension[basedOn].valueReference.identifier.type = $v2-0203#PLAC
* extension[basedOn].valueReference.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* extension[basedOn].valueReference.identifier.value = "REF-2026-000123"
* extension[basedOn].valueReference.identifier.assigner.identifier.system = $ods-code
* extension[basedOn].valueReference.identifier.assigner.identifier.value = "P89020"
* identifier.system = "https://fhir.mft.nhs.uk/Id/document"
* identifier.value = "DOC-55501"
* status = #final
* type = $loinc#11488-4 "Consult Note"
* subject = Reference(Patient-Tameside)
* encounter = Reference(CardiologyOutpatientAttendance)
* date = "2026-09-07T16:00:00+01:00"
* author = Reference(CardiologistBrownRole)
* title = "Cardiology clinic letter"
* custodian = Reference(R0A)
* section[reasonForReferral].title = "Reason for referral"
* section[reasonForReferral].code = $loinc#29299-5 "Reason for visit Narrative"
* section[reasonForReferral].text.status = #generated
* section[reasonForReferral].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Shortness of breath. Determine the origin.</div>"
* section[assessment].title = "Assessment"
* section[assessment].code = $loinc#51848-0 "Evaluation Note"
* section[assessment].text.status = #generated
* section[assessment].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Findings consistent with coronary artery disease.</div>"
* section[planOfCare].title = "Plan"
* section[planOfCare].code = $loinc#18776-5 "Plan of Care Note"
* section[planOfCare].text.status = #generated
* section[planOfCare].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Cardiac catheterisation booked for 21 September 2026.</div>"

// Referral Outcome [PCC-57]

Instance: CardiologyOutcomeNote
InstanceOf: ConsultationNote
Title: "Consultation Note - Referral Outcome (final)"
Description: "Referral Outcome [PCC-57]: the final consultation note after the catheterisation, with the suggested plan of care. The patient is discharged back to the GP."
Usage: #example
* extension[basedOn].valueReference = Reference(CardiologyReferral)
* extension[basedOn].valueReference.identifier.type = $v2-0203#PLAC
* extension[basedOn].valueReference.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* extension[basedOn].valueReference.identifier.value = "REF-2026-000123"
* extension[basedOn].valueReference.identifier.assigner.identifier.system = $ods-code
* extension[basedOn].valueReference.identifier.assigner.identifier.value = "P89020"
* identifier.system = "https://fhir.mft.nhs.uk/Id/document"
* identifier.value = "DOC-55777"
* status = #final
* type = $loinc#11488-4 "Consult Note"
* subject = Reference(Patient-Tameside)
* encounter = Reference(CardiacCatheterisationSpell)
* date = "2026-09-24T11:00:00+01:00"
* author = Reference(CardiologistBrownRole)
* title = "Cardiology discharge letter"
* custodian = Reference(R0A)
* section[assessment].title = "Assessment"
* section[assessment].code = $loinc#51848-0 "Evaluation Note"
* section[assessment].text.status = #generated
* section[assessment].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Cardiac catheterisation on 21 September 2026 confirmed coronary artery disease.</div>"
* section[planOfCare].title = "Plan"
* section[planOfCare].code = $loinc#18776-5 "Plan of Care Note"
* section[planOfCare].text.status = #generated
* section[planOfCare].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Medical management. GP to review lipids and blood pressure in 3 months. Discharged from cardiology.</div>"

Instance: CardiologyReferralCompleted
InstanceOf: ReferralTask
Title: "Referral Task - Completed"
Description: "Referral Outcome [PCC-57]: the referral is complete and the loop is closed (HL7 v2 OSU^O51, ORC-1 SC, ORC-5 CM). The Task outputs are the appointment, interim note and outcome."
Usage: #example
* basedOn = Reference(CardiologyReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000123"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* focus = Reference(CardiologyReferral)
* for = Reference(Patient-Tameside)
* status = #completed
* businessStatus = ReferralWorkflowStatus#completed
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-09-04T10:15:00+01:00"
* lastModified = "2026-09-24T11:00:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(CardiologyService)
* output[+].type = ReferralTaskParameter#interim-report
* output[=].valueReference = Reference(CardiologyInterimNote)
* output[+].type = ReferralTaskParameter#outcome-report
* output[=].valueReference = Reference(CardiologyOutcomeNote)
* output[+].type = ReferralTaskParameter#appointment
* output[=].valueReference = Reference(CardiologyAppointment)
