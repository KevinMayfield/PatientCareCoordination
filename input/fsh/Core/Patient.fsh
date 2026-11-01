// DUPLICATION: copied from the NW GMSA FHIR IG (https://nw-gmsa.github.io/en/,
// source ../FHIRGenomics/input/fsh/Patient.fsh, via the copy in ../Imaging, 2026-11-01) - the NW core Patient.
// Changes from the source: the UK Core EthnicCategory extension is removed (no UK
// Core dependency). Keep in step with the source - see notes/research.md.

Profile: Patient
Parent: http://hl7.eu/fhir/base/StructureDefinition/patient-eu-core
Id: Patient
Description: """
`Patient Administration` [HL7 Europe Core - Patient](http://hl7.eu/fhir/base/StructureDefinition/patient-eu-core). Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* extension[sex-for-clinical-use]

* identifier 1..*
* identifier only CorrelationIdentifier
* identifier.assigner ^short = "Assigning Facility"
* identifier.assigner 0..1 MS
* identifier.assigner.identifier 1..1 MS
* identifier.assigner.identifier.value 1..1 MS
* identifier.assigner.identifier.system = $ods-code

* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false

* identifier contains
  MedicalRecordNumber 0..* MS
  and nhsNumber 0..* MS
  and PatientIdentifier 0..*

* identifier[nhsNumber] only NHSIdentifier
* identifier[nhsNumber] ^short = "UK National Health Identifiers: NHS NUMBER (England and Wales)"
* identifier[MedicalRecordNumber] only MedicalRecordNumber
* identifier[MedicalRecordNumber] ^short = "Medical Record Number"
* identifier[PatientIdentifier] only PatientIdentifier
* identifier[PatientIdentifier] ^short = "Patient Identifier"

* address.postalCode 1..1

* name 1..* MS
* gender 0..1 MS
* birthDate MS

* name.family
* name.given
* deceasedDateTime
