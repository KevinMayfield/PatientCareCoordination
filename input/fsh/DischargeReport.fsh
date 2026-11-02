Logical:        DischargeReport
Id:             DischargeReport
Title:          "Discharge Report"
Description:    """
**Proof of concept - not an authoritative source.**

The **outcome** of a referral ([Referral Outcome [PCC-57]](PCC-57.html)): the report the
Referral Recipient sends back when its care ends - a discharge summary after an inpatient
or [virtual ward](VirtualWards.html) stay, or a clinic letter after outpatient care. The
same report is also an **input** to a later referral (`ServiceRequest.supportingInfo`).

Based on the [HL7 Europe Hospital Discharge Report](https://hl7.eu/fhir/hdr/) (HDR)
sections, which this guide uses as published, and the PRSB
[Transfer of Care - Acute Inpatient Discharge](https://theprsb.org/standards/edischargesummary)
and [Outpatient Letter](https://theprsb.org/standards/outpatientletterstandard) standards
(heading mapping **To confirm**). The **Mappings** tab shows each element in FHIR (HDR)
and HL7 v2.
"""
Characteristics: #can-be-target

* ^experimental = true

// Document

* documentId 1..1 Identifier "Document ID" "Unique identifier of this report"
* documentType 1..1 CodeableConcept "Document type" "Discharge summary (LOINC 34105-7) or clinic letter (LOINC 11488-4)"
* status 1..1 code "Status" "preliminary, final, amended, entered-in-error"
* date 1..1 dateTime "Date" "When the report was written"
* author 1..* Identifier "Author" "Responsible clinician (professional identifier) and organisation (ODS code)"
* custodian 0..1 Identifier "Custodian" "Organisation responsible for the report (ODS code)"
* recipient 0..* Identifier "Recipients" "The Referral Initiator, the patient's GP, others"
* patient 1..1 Identifier "Patient" "NHS Number and the identifier used in the referral"
* encounter 1..1 Identifier "Encounter" "Hospital Spell (Account Number, AN) or Visit Number (VN)"
* referral 0..1 Identifier "Referral answered" "Referral ID - carried by the workflow (Task, TXA-14), not inside the FHIR Document"

// Content - HDR sections

* alerts 0..1 BackboneElement "Alerts" "Substantial alerts and warnings"
* admissionEvaluation 0..1 BackboneElement "Admission evaluation" "Reason for admission or attendance and the patient's state on arrival"
* hospitalCourse 0..1 BackboneElement "Course of the stay" "What happened during the stay or attendance; answer to the referral question"
* diagnosticSummary 0..1 BackboneElement "Diagnoses" "Problems and diagnoses of the stay"
* significantProcedures 0..1 BackboneElement "Procedures" "Significant procedures performed"
* significantResults 0..1 BackboneElement "Results" "Significant test results"
* vitalSigns 0..1 BackboneElement "Vital signs" "During the stay and at discharge"
* functionalStatus 0..1 BackboneElement "Functional status" "Ability to perform activities of daily living"
* allergies 0..1 BackboneElement "Allergies" "Relevant allergies and intolerances, including new ones"
* pharmacotherapy 0..1 BackboneElement "Medicines during the stay" "Medicines given and stopped before discharge"
* dischargeMedications 0..1 BackboneElement "Medicines on discharge" "Medicines to continue, with changes and who actions them"
* planOfCare 0..1 BackboneElement "Plan of care" "Recommendations and actions for the recipient, including onward referrals"
* dischargeDetails 0..1 BackboneElement "Discharge details" "Discharge date, method and destination"
* synthesis 0..1 BackboneElement "Clinical synthesis" "Summary of the stay for the reader"
* attachments 0..* Attachment "Attachments" "Other documents, e.g. a PDF letter"

Mapping:        DischargeReport-FHIR
Source:         DischargeReport
Target:         "https://hl7.eu/fhir/hdr/"
Id:             fhir-hdr
Title:          "FHIR R4 (HL7 Europe HDR)"
* documentId -> "Composition.identifier; Bundle.identifier"
* documentType -> "Composition.type (HDR fixes 34105-7; outpatient letters use 11488-4 on a plain Composition)"
* status -> "Composition.status"
* date -> "Composition.date"
* author -> "Composition.author (PractitionerRole)"
* custodian -> "Composition.custodian"
* recipient -> "Composition.extension:informationRecipient"
* patient -> "Composition.subject"
* encounter -> "Composition.encounter (Hospital Spell or Visit)"
* referral -> "Task.output (Task.basedOn the ServiceRequest); DocumentReference.context.related"
* alerts -> "section:sectionAlert (LOINC 104605-1)"
* admissionEvaluation -> "section:sectionAdmissionEvaluation (67851-6)"
* hospitalCourse -> "section:sectionHospitalCourse (8648-8)"
* diagnosticSummary -> "section:sectionDiagnosticSummary (11535-2)"
* significantProcedures -> "section:sectionSignificantProcedures (10185-7)"
* significantResults -> "section:sectionSignificantResults (30954-2)"
* vitalSigns -> "section:sectionVitalSigns (8716-3)"
* functionalStatus -> "section:sectionFunctionalStatus (47420-5)"
* allergies -> "section:sectionAllergies (48765-2)"
* pharmacotherapy -> "section:sectionPharmacotherapy (87232-5)"
* dischargeMedications -> "section:sectionDischargeMedications (75311-1)"
* planOfCare -> "section:sectionPlanOfCare (18776-5)"
* dischargeDetails -> "section:sectionDischargeDetails (8650-4)"
* synthesis -> "section:sectionSynthesis (67781-5)"
* attachments -> "section:sectionAttachments (77599-9)"

Mapping:        DischargeReport-HL7v2
Source:         DischargeReport
Target:         "https://hl7-definition.caristix.com/v2/HL7v2.5.1/TriggerEvents/MDM_T02"
Id:             hl7-v2
Title:          "HL7 v2.5.1 (MDM^T02)"
* documentId -> "TXA-12 Unique Document Number"
* documentType -> "TXA-2 Document Type"
* status -> "TXA-17 Document Completion Status"
* date -> "TXA-4 Activity Date/Time"
* author -> "TXA-9 Originator Code/Name"
* patient -> "PID-3"
* encounter -> "PV1-19 (CX.5 AN or VN)"
* referral -> "TXA-14 Placer Order Number; ORC-2"
* attachments -> "OBX-5 (type ED)"
