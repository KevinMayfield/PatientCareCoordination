// Virtual ward (hospital at home) step-up: a GP refers a patient with an exacerbation
// of COPD to a respiratory virtual ward instead of admitting her to hospital.
// Fictitious data.

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $nhs-number = https://fhir.nhs.uk/Id/nhs-number
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v3-RoleCode = http://terminology.hl7.org/CodeSystem/v3-RoleCode
Alias: $condition-clinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $condition-category = http://terminology.hl7.org/CodeSystem/condition-category
Alias: $obs-category = http://terminology.hl7.org/CodeSystem/observation-category
Alias: $ucum = http://unitsofmeasure.org

Instance: PatientJones
InstanceOf: Patient
Title: "Patient - Margaret Jones"
Description: "Fictitious patient with COPD, admitted to a respiratory virtual ward."
Usage: #example
* identifier[nhsNumber].system = $nhs-number
* identifier[nhsNumber].value = "9000000009"
* identifier[nhsNumber].type = $v2-0203#NH
* name.family = "Jones"
* name.given = "Margaret"
* gender = #female
* birthDate = "1948-11-02"
* address.line = "22 Example Road"
* address.city = "Manchester"
* address.postalCode = "M20 2AB"

Instance: PatientJonesHome
InstanceOf: Location
Title: "Location - Patient's home"
Description: "The patient's home - where the virtual ward stay takes place."
Usage: #example
* status = #active
* name = "Patient's home"
* mode = #kind
* type = $v3-RoleCode#PTRES "Patient's Residence"
* address.line = "22 Example Road"
* address.city = "Manchester"
* address.postalCode = "M20 2AB"

Instance: VirtualWardService
InstanceOf: HealthcareService
Title: "HealthcareService - MFT Respiratory Virtual Ward"
Description: "The virtual ward service referred to - the Referral Recipient."
Usage: #example
* providedBy = Reference(R0A)
* name = "Respiratory Virtual Ward"
* specialty = $sct#418112009 "Pulmonary medicine"

Instance: ConditionCOPDExacerbation
InstanceOf: Condition
Title: "Condition - Acute exacerbation of COPD"
Description: "The reason for the virtual ward referral."
Usage: #example
* clinicalStatus = $condition-clinical#active
* category = $condition-category#encounter-diagnosis
* code = $sct#195951007 "Acute exacerbation of chronic obstructive airways disease"
* subject = Reference(PatientJones)
* onsetDateTime = "2026-10-05"

// Step-up referral [PCC-55]

Instance: VirtualWardReferral
InstanceOf: ReferralRequest
Title: "Referral Request - GP to Respiratory Virtual Ward (step-up)"
Description: "Referral Request [PCC-55] to a virtual ward, instead of an acute admission."
Usage: #example
* identifier[referralId].type = $v2-0203#PLAC
* identifier[referralId].system = "https://fhir.example-practice.nhs.uk/Id/referral"
* identifier[referralId].value = "REF-2026-000456"
* identifier[referralId].assigner.identifier.system = $ods-code
* identifier[referralId].assigner.identifier.value = "Y00001"
* status = #completed
* intent = #order
* category = $sct#729021000000108 "Referral to virtual ward"
* priority = #urgent
* code = $sct#729021000000108 "Referral to virtual ward"
* subject = Reference(PatientJones)
* subject.identifier.system = $nhs-number
* subject.identifier.value = "9000000009"
* subject.identifier.type = $v2-0203#NH
* occurrenceDateTime = "2026-10-06"
* authoredOn = "2026-10-06T09:20:00+01:00"
* requester = Reference(GPAllenRole)
* performer = Reference(VirtualWardService)
* reasonReference = Reference(ConditionCOPDExacerbation)
* note.text = "Exacerbation of COPD, SpO2 90% on air. Suitable for hospital at home - please assess for the respiratory virtual ward."

Instance: VirtualWardReferralAccepted
InstanceOf: ReferralTask
Title: "Referral Task - Virtual ward accepted"
Description: "Referral Accept [PCC-55]: the virtual ward team accepts the patient. Output is the virtual ward stay."
Usage: #example
* basedOn = Reference(VirtualWardReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000456"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "Y00001"
* focus = Reference(VirtualWardReferral)
* for = Reference(PatientJones)
* status = #in-progress
* businessStatus = ReferralWorkflowStatus#accepted
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-10-06T09:20:00+01:00"
* lastModified = "2026-10-06T11:00:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(VirtualWardService)
* output.type.text = "Virtual ward stay"
* output.valueReference = Reference(VirtualWardStay)

// Virtual ward stay

Instance: VirtualWardStay
InstanceOf: VirtualWardEncounter
Title: "Virtual Ward Encounter - Respiratory virtual ward (step-up)"
Description: "The virtual ward stay at the patient's home, admitted as a step-up."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/spell"
* identifier.value = "VW-20261006-01"
* status = #finished
* class = $v3-ActCode#IMP
* serviceType = $sct#418112009 "Pulmonary medicine"
* subject = Reference(PatientJones)
* basedOn = Reference(VirtualWardReferral)
* period.start = "2026-10-06T11:00:00+01:00"
* period.end = "2026-10-13T10:00:00+01:00"
* hospitalization.admitSource = VirtualWardAdmissionRoute#step-up "Step-up"
* hospitalization.dischargeDisposition.text = "Discharged to GP care"
* location.location = Reference(PatientJonesHome)
* reasonReference = Reference(ConditionCOPDExacerbation)
* serviceProvider = Reference(R0A)

Instance: VirtualWardPlan
InstanceOf: VirtualWardCarePlan
Title: "Virtual Ward Care Plan - remote monitoring"
Description: "Treatment plan for the stay: twice-daily SpO2 by pulse oximeter, daily review, escalation if SpO2 below 88%."
Usage: #example
* status = #completed
* intent = #plan
* category = $sct#960751000000107 "Remote health monitoring care plan"
* title = "Respiratory virtual ward plan"
* subject = Reference(PatientJones)
* encounter = Reference(VirtualWardStay)
* period.start = "2026-10-06"
* period.end = "2026-10-13"
* author = Reference(R0A)
* addresses = Reference(ConditionCOPDExacerbation)
* activity[+].detail.status = #completed
* activity[=].detail.code = $loinc#59408-5 "Oxygen saturation in Arterial blood by Pulse oximetry"
* activity[=].detail.description = "Patient records SpO2 twice daily; escalate to the virtual ward clinician if below 88%."

Instance: VirtualWardSpO2
InstanceOf: http://hl7.org/fhir/StructureDefinition/oxygensat
Title: "Observation - SpO2 (remote monitoring)"
Description: "Oxygen saturation recorded by the patient at home and sent to the virtual ward."
Usage: #example
* status = #final
* category[VSCat] = $obs-category#vital-signs
* code.coding[OxygenSatCode] = $loinc#2708-6 "Oxygen saturation in Arterial blood"
* subject = Reference(PatientJones)
* encounter = Reference(VirtualWardStay)
* effectiveDateTime = "2026-10-07T08:00:00+01:00"
* performer = Reference(PatientJones)
* valueQuantity = 93 '%' "%"

// Referral Outcome [PCC-57] - Hospital Discharge Report

Instance: VirtualWardDischargeReport
InstanceOf: DischargeReportDocument
Title: "Discharge Report Document - Respiratory virtual ward"
Description: "Referral Outcome [PCC-57]: HL7 Europe Hospital Discharge Report sent to the GP when the patient leaves the virtual ward."
Usage: #example
* language = #en-GB
* identifier.system = "https://fhir.mft.nhs.uk/Id/document"
* identifier.value = "DOC-77801"
* type = #document
* timestamp = "2026-10-13T12:00:00+01:00"
* entry[composition].fullUrl = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0001"
* entry[composition].resource = VirtualWardDischargeComposition
* entry[patient].fullUrl = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0002"
* entry[patient].resource = PatientJonesInline
* entry[encounter].fullUrl = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0003"
* entry[encounter].resource = VirtualWardStayInline

Instance: VirtualWardDischargeComposition
InstanceOf: DischargeReport
Usage: #inline
* extension[basedOn].valueReference.identifier.type = $v2-0203#PLAC
* extension[basedOn].valueReference.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* extension[basedOn].valueReference.identifier.value = "REF-2026-000456"
* extension[basedOn].valueReference.identifier.assigner.identifier.system = $ods-code
* extension[basedOn].valueReference.identifier.assigner.identifier.value = "Y00001"
* identifier.system = "https://fhir.mft.nhs.uk/Id/document"
* identifier.value = "DOC-77801"
* status = #final
* type = $loinc#34105-7 "Hospital Discharge Summary"
* subject.reference = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0002"
* encounter.reference = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0003"
* date = "2026-10-13T12:00:00+01:00"
* author.display = "Respiratory Virtual Ward, Manchester University NHS Foundation Trust"
* title = "Virtual ward discharge report"
* section[sectionHospitalCourse].title = "Hospital course"
* section[sectionHospitalCourse].code = $loinc#8648-8
* section[sectionHospitalCourse].text.status = #generated
* section[sectionHospitalCourse].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">Seven days on the respiratory virtual ward with twice-daily SpO2 monitoring. Oral steroids and antibiotics. SpO2 improved to 95% on air. No escalation needed.</div>"
* section[sectionPlanOfCare].title = "Plan of care"
* section[sectionPlanOfCare].code = $loinc#18776-5
* section[sectionPlanOfCare].text.status = #generated
* section[sectionPlanOfCare].text.div = "<div xmlns=\"http://www.w3.org/1999/xhtml\">GP review in 2 weeks. Refer to pulmonary rehabilitation.</div>"

Instance: PatientJonesInline
InstanceOf: Patient
Usage: #inline
* identifier[nhsNumber].system = $nhs-number
* identifier[nhsNumber].value = "9000000009"
* identifier[nhsNumber].type = $v2-0203#NH
* name.family = "Jones"
* name.given = "Margaret"
* gender = #female
* birthDate = "1948-11-02"
* address.postalCode = "M20 2AB"

Instance: VirtualWardStayInline
InstanceOf: VirtualWardEncounter
Usage: #inline
* identifier.system = "https://fhir.mft.nhs.uk/Id/spell"
* identifier.value = "VW-20261006-01"
* status = #finished
* class = $v3-ActCode#IMP
* serviceType = $sct#418112009 "Pulmonary medicine"
* subject.reference = "urn:uuid:5c1b1f5e-2d0a-4c41-9a7e-2a0a7c1d0002"
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000456"
* period.start = "2026-10-06T11:00:00+01:00"
* period.end = "2026-10-13T10:00:00+01:00"
* hospitalization.admitSource = VirtualWardAdmissionRoute#step-up "Step-up"
* location.location.display = "Patient's home"
* serviceProvider.identifier.system = $ods-code
* serviceProvider.identifier.value = "R0A"

Instance: VirtualWardReferralCompleted
InstanceOf: ReferralTask
Title: "Referral Task - Virtual ward completed"
Description: "Referral Outcome [PCC-57]: the patient is discharged from the virtual ward and the discharge report sent."
Usage: #example
* basedOn = Reference(VirtualWardReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000456"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "Y00001"
* focus = Reference(VirtualWardReferral)
* for = Reference(PatientJones)
* status = #completed
* businessStatus = ReferralWorkflowStatus#completed
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-10-06T09:20:00+01:00"
* lastModified = "2026-10-13T12:00:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(VirtualWardService)
* output[+].type.text = "Virtual ward stay"
* output[=].valueReference = Reference(VirtualWardStay)
* output[+].type = $loinc#34105-7 "Hospital Discharge Summary"
* output[=].valueReference = Reference(VirtualWardDischargeReport)
