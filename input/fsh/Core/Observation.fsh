// DUPLICATION: based on the Virtually Healthcare Observation profile
// (https://fhir.virtually.healthcare/StructureDefinition/Observation, source
// ../../virtually/KM-VirtuallyHealthcare/input/fsh/profiles/Observation.fsh, 2026-11-02).
// Changes from the source: parent is the base FHIR Observation (no UK Core dependency);
// Virtually Healthcare identifier types and obligations removed.

Profile: Observation
Parent: http://hl7.org/fhir/StructureDefinition/Observation
Id: Observation
Title: "Observation"
Description: """
`Clinical Observation` - an observation about the patient, such as a vital sign or a
social context finding. The target of the `definition` of the
[Vital Signs](Questionnaire-VitalSigns.html) questionnaire items, so the answers can be
extracted as Observations. Codes follow the NHS England
[Clinical Observations](https://simplifier.net/guide/ClinicalObservations/Home) guide
where it defines them.
"""

* status MS
* category MS
* code MS
* code ^short = "What was observed - SNOMED CT (and LOINC for vital signs)"
* subject 1..1 MS
* subject only Reference(Patient)
* effective[x] 1..1 MS
* effective[x] only dateTime
* performer MS
* method MS
* method ^short = "How it was observed - e.g. the oxygen delivery route"
* value[x] MS
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity ^short = "Value with a UCUM unit"
* component MS
* component.code MS
* component.value[x] MS
