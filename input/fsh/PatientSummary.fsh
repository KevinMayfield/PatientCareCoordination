Logical:        PatientSummary
Id:             PatientSummary
Title:          "Patient Summary"
Description:    """
**Proof of concept - not an authoritative source.**

The patient's **background** - problems, medicines, allergies and other headline
information - for a clinician who does not hold the patient's record. Sent as referral
input (`ServiceRequest.supportingInfo`) when the Referral Recipient cannot query the
record, and expected to be available from shared care records.

Based on the [HL7 Europe Patient Summary](https://hl7.eu/fhir/eps/1.0.0-ballot/) (EPS,
1.0.0-ballot) and the [International Patient Summary](https://hl7.org/fhir/uv/ips/)
(IPS 2.0.1) sections, with the PRSB
[Core Information Standard](https://theprsb.org/standards/core-information-standard/)
v2.01 headings (mapping **To confirm**). The **Mappings** tab shows each element in
FHIR and PRSB.
"""
Characteristics: #can-be-target

* ^experimental = true

// Document

* documentId 1..1 Identifier "Document ID" "Unique identifier of this summary"
* date 1..1 dateTime "Date" "When the summary was produced"
* author 1..* Identifier "Author" "Organisation (ODS code) or clinician producing the summary"
* patient 1..1 Identifier "Patient" "NHS Number and local identifiers"

// Content - IPS / EPS sections

* problems 1..1 BackboneElement "Problems" "Current problems and diagnoses"
* allergies 1..1 BackboneElement "Allergies and intolerances" "Including no known allergies"
* medications 1..1 BackboneElement "Medication summary" "Current medicines"
* immunizations 0..1 BackboneElement "Immunisations" "Vaccination history"
* results 0..1 BackboneElement "Results" "Relevant test results"
* proceduresHistory 0..1 BackboneElement "History of procedures" "Past procedures"
* medicalDevices 0..1 BackboneElement "Medical devices" "Devices and implants"
* pastProblems 0..1 BackboneElement "Past problems" "Resolved problems"
* vitalSigns 0..1 BackboneElement "Vital signs" "Latest vital signs"
* functionalStatus 0..1 BackboneElement "Functional status" "Disabilities and ability to perform activities of daily living"
* socialHistory 0..1 BackboneElement "Social history" "Social context - see the Social Context questionnaire"
* pregnancyHistory 0..1 BackboneElement "Pregnancy" "Current pregnancy status and history"
* planOfCare 0..1 BackboneElement "Plan of care" "Current care plans"
* advanceDirectives 0..1 BackboneElement "Advance directives" "Advance decisions, ReSPECT, DNACPR"
* alerts 0..1 BackboneElement "Alerts" "Substantial alerts and warnings"
* patientStory 0..1 BackboneElement "Patient story" "What matters to the patient (PRSB About Me)"

Mapping:        PatientSummary-FHIR
Source:         PatientSummary
Target:         "https://hl7.eu/fhir/eps/"
Id:             fhir-eps
Title:          "FHIR R4 (HL7 Europe EPS / IPS)"
* documentId -> "Composition.identifier; Bundle.identifier"
* date -> "Composition.date"
* author -> "Composition.author"
* patient -> "Composition.subject"
* problems -> "section:sectionProblems (LOINC 11450-4)"
* allergies -> "section:sectionAllergies (48765-2)"
* medications -> "section:sectionMedications (10160-0)"
* immunizations -> "section:sectionImmunizations (11369-6)"
* results -> "section:sectionResults (30954-2)"
* proceduresHistory -> "section:sectionProceduresHx (47519-4)"
* medicalDevices -> "section:sectionMedicalDevices (46264-8)"
* pastProblems -> "section:sectionPastProblems (11348-0)"
* vitalSigns -> "section:sectionVitalSigns (8716-3)"
* functionalStatus -> "section:sectionFunctionalStatus (47420-5)"
* socialHistory -> "section:sectionSocialHistory (29762-2)"
* pregnancyHistory -> "section:sectionPregnancyHx (10162-6)"
* planOfCare -> "section:sectionPlanOfCare (18776-5)"
* advanceDirectives -> "section:sectionAdvanceDirectives (42348-3)"
* alerts -> "section:sectionAlerts (104605-1)"
* patientStory -> "section:sectionPatientStory (81338-6)"

Mapping:        PatientSummary-PRSB
Source:         PatientSummary
Target:         "https://theprsb.org/standards/core-information-standard/"
Id:             prsb-cis
Title:          "PRSB Core Information Standard v2.01"
* -> "Core Information Standard sections. Not in the IPS / EPS sections: Individual requirements, Legal information (other than advance decisions), Professional and personal contacts, Participation in research, Family history, Risks, Services and care, Equipment and adaptations - To confirm. Mapping indicative - To confirm"
* patient -> "Person demographics; GP practice"
* problems -> "Problem list"
* allergies -> "Allergies and adverse reactions"
* medications -> "Medications and medical devices"
* immunizations -> "Vaccinations"
* results -> "Investigation results"
* proceduresHistory -> "Procedures and therapies"
* medicalDevices -> "Medications and medical devices (medical devices); Equipment and adaptations"
* pastProblems -> "Problem list (past problems)"
* vitalSigns -> "Examination findings"
* functionalStatus -> "Assessments"
* socialHistory -> "Social context"
* pregnancyHistory -> "Pregnancy status"
* planOfCare -> "Plan and requested actions; Care and support plan"
* advanceDirectives -> "Legal information; End of life care"
* alerts -> "Alerts; Safeguarding"
* patientStory -> "About me"
