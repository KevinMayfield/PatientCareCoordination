// Vital Signs questionnaire. Originally copied from the Virtually Healthcare IG
// (https://virtually-healthcare.github.io/Questionnaire-VitalSigns.html). Changes:
// item definitions point to this guide's Observation profile; codes, units and answer
// lists follow the NHS England Clinical Observations guide (2.0.0-Alpha, checked
// 2026-11-02 - https://simplifier.net/guide/ClinicalObservations/Home); answers are
// answerOption, not value sets; the duplicate arterial oxygen saturation item
// (442476006) is replaced by the Clinical Observations oxygen saturation (103228002);
// oxygen, delivery route and level of consciousness (ACVPU) items added (Clinical
// Observations records the delivery route as a Procedure; here it is the method of the
// oxygen Observation. Its headbox and high flow codes, 9999017 and 9999016, are not
// SNOMED CT identifiers and are left out - To confirm); units are in
// the item text and the questionnaire-unit extension. SNOMED CT codes checked on
// tx.fhir.org (UK Edition) 2026-11-02.

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $ucum = http://unitsofmeasure.org

Instance: VitalSigns
InstanceOf: Questionnaire
Title: "Questionnaire - Vital Signs"
Description: """
Vital signs captured with a referral (for example baseline observations for a virtual
ward or exercise referral) or during monitoring. Each item has SNOMED CT (and LOINC)
codes, a UCUM unit and a `definition` pointing to this guide's
[Observation](StructureDefinition-Observation.html) profile, so answers can be extracted
as vital signs Observations. Codes and answer lists follow the NHS England
[Clinical Observations](https://simplifier.net/guide/ClinicalObservations/Home) guide
(2.0.0-Alpha, draft).
"""
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/VitalSigns"
* name = "VitalSigns"
* title = "Vital Signs"
* status = #draft
* experimental = true
* subjectType = #Patient
* code = $loinc#85353-1 "Vital signs, weight, height, head circumference, oxygen saturation and BMI panel"

* item[+]
  * linkId = "SCT/86290005"
  * text = "Respiratory rate (breaths per minute)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#86290005 "Respiratory rate"
  * code[+] = $loinc#9279-1 "Respiratory rate"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#{Breaths}/min "{Breaths}/min"

* item[+]
  * linkId = "SCT/103228002"
  * text = "Oxygen saturation (%)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#103228002 "Hemoglobin saturation with oxygen"
  * code[+] = $loinc#2708-6 "Oxygen saturation in Arterial blood"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#% "percent"

* item[+]
  * linkId = "SCT/852641000000103"
  * text = "Target oxygen saturation (%)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#852641000000103 "Target peripheral oxygen saturation"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#% "percent"

* item[+]
  * linkId = "SCT/722742002"
  * text = "Breathing room air or on supplemental oxygen"
  * type = #choice
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.code"
  * answerOption[+].valueCoding = $sct#722742002 "Breathing room air"
  * answerOption[+].valueCoding = $sct#371825009 "Patient on oxygen"

* item[+]
  * linkId = "SCT/371825009"
  * text = "Inspired oxygen flow rate (litres per minute)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#371825009 "Patient on oxygen"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#L/min "liter per minute"
  * enableWhen.question = "SCT/722742002"
  * enableWhen.operator = #=
  * enableWhen.answerCoding = $sct#371825009

* item[+]
  * linkId = "OXYGEN-DELIVERY"
  * text = "Oxygen delivery route"
  * type = #choice
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.method"
  * enableWhen.question = "SCT/722742002"
  * enableWhen.operator = #=
  * enableWhen.answerCoding = $sct#371825009
  * answerOption[+].valueCoding = $sct#371907003 "Oxygen administration by nasal cannula"
  * answerOption[+].valueCoding = $sct#371908008 "Oxygen administration by mask"

* item[+]
  * linkId = "SCT/75367002"
  * text = "Blood pressure"
  * type = #group
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.component"
  * code[+] = $sct#75367002 "Blood pressure"
  * code[+] = $loinc#85354-9 "Blood pressure panel with all children optional"
  * item[+]
    * linkId = "SCT/72313002"
    * text = "Systolic blood pressure (mmHg)"
    * type = #decimal
    * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.component.value[x]"
    * code[+] = $sct#72313002 "Systolic arterial pressure"
    * code[+] = $loinc#8480-6 "Systolic blood pressure"
    * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
    * extension[=].valueCoding = $ucum#mm[Hg] "millimeter of mercury"
  * item[+]
    * linkId = "SCT/1091811000000102"
    * text = "Diastolic blood pressure (mmHg)"
    * type = #decimal
    * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.component.value[x]"
    * code[+] = $sct#1091811000000102 "Diastolic arterial pressure"
    * code[+] = $loinc#8462-4 "Diastolic blood pressure"
    * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
    * extension[=].valueCoding = $ucum#mm[Hg] "millimeter of mercury"

* item[+]
  * linkId = "SCT/364075005"
  * text = "Heart rate (beats per minute)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#364075005 "Heart rate"
  * code[+] = $loinc#8867-4 "Heart rate"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#{beats}/min "{beats}/min"

* item[+]
  * linkId = "SCT/1104441000000107"
  * text = "Level of consciousness (ACVPU)"
  * type = #choice
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.code"
  * code[+] = $sct#1104441000000107 "Alert Confusion Voice Pain Unresponsive scale score"
  * answerOption[+].valueCoding = $sct#248234008 "Mentally alert"
  * answerOption[+].valueCoding = $sct#130987000 "Acute confusion"
  * answerOption[+].valueCoding = $sct#300202002 "Responds to voice"
  * answerOption[+].valueCoding = $sct#450847001 "Responds to pain"
  * answerOption[+].valueCoding = $sct#422768004 "Unresponsive"

* item[+]
  * linkId = "SCT/276885007"
  * text = "Temperature (°C)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#276885007 "Core body temperature"
  * code[+] = $loinc#8310-5 "Body temperature"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#Cel "degree Celsius"

* item[+]
  * linkId = "SCT/27113001"
  * text = "Body weight (kg)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#27113001 "Body weight"
  * code[+] = $loinc#29463-7 "Body weight"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#kg "kilogram"

* item[+]
  * linkId = "SCT/50373000"
  * text = "Height (cm)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#50373000 "Body height measure"
  * code[+] = $loinc#8302-2 "Body height"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#cm "centimeter"

* item[+]
  * linkId = "SCT/60621009"
  * text = "Body mass index (kg/m2)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#60621009 "Body mass index"
  * code[+] = $loinc#39156-5 "Body mass index (BMI) [Ratio]"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#kg/m2 "kilogram / (meter ^ 2)"

* item[+]
  * linkId = "SCT/363811000"
  * text = "Head circumference (cm)"
  * type = #decimal
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#363811000 "Head circumference measure"
  * code[+] = $loinc#9843-4 "Head Occipital-frontal circumference"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#cm "centimeter"

* item[+]
  * linkId = "SCT/225908003"
  * text = "Pain score (0 to 10)"
  * type = #integer
  * definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/Observation#Observation.value[x]"
  * code[+] = $sct#225908003 "Pain score"
  * extension[+].url = "http://hl7.org/fhir/StructureDefinition/questionnaire-unit"
  * extension[=].valueCoding = $ucum#{score} "{score}"
