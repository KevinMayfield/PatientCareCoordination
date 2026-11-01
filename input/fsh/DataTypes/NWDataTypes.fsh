// DUPLICATION: copied from the NW GMSA FHIR IG (https://nw-gmsa.github.io/en/,
// source ../FHIRGenomics/input/fsh/DataTypes and Termininology, via the copy in ../Imaging, 2026-11-01) so this
// guide follows the same identifier and attachment conventions without depending on that IG.
// Changes from the source: the UK Core NHSNumberVerificationStatus extension is
// removed from NHSIdentifier (no UK Core dependency) and the NW GMSA ZCID code is
// removed from NWIdentifierType, and the NationalHealthIdentifiers CodeSystem is
// retitled (its title duplicated the value set's, an IG Publisher error). Keep in step with the source - see notes/research.md.

Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $bcp13 = urn:ietf:bcp:13

// Identifier data types

Profile:        CorrelationIdentifier
Parent:         http://hl7.org/fhir/StructureDefinition/Identifier
Id:             CorrelationIdentifier
Title:          "Correlation Identifier"
Description:     """
Core Data Contract for FHIR Identifier, v2 CX and EI. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* type 0..1 MS
* type from NWIdentifierType
* system 0..1 MS
* system ^short = "Recommended. This may be defined by a EPR/LIMS system."
* value 1..1 MS
* value ^short = "The value MUST be unique to the organisation"

* assigner 0..1 MS
* assigner.identifier 1..1 MS
* assigner.identifier.value 1..1 MS
* assigner.identifier.system 1..1 MS
* assigner.identifier.system = $ods-code
* assigner.identifier.value ^example.valueString = "R0A"
* assigner.identifier.value ^example.label = "Manchester University NHS Foundation Trust"

Profile:        NHSIdentifier
Parent:         CorrelationIdentifier
Id:             NHSIdentifier
Title:          "NHS Identifier"
Description:     """
Only traced NHS Number **SHOULD** be used, un-traced NHS Numbers **MUST** be clearly indicated. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* system 1..1
* system from UKNationalHealthIdentifiers
* value 1..1
* type = $v2-0203#NH (exactly)

Profile:        MedicalRecordNumber
Parent:         CorrelationIdentifier
Id:             MedicalRecordNumber
Title:          "Medical Record Number"
Description:    "Patient identifier assigned by an NHS trust. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* type = $v2-0203#MR (exactly)
* system ^short = "Generic system to represent MRN in NHS Trusts. Can be replaced with a system specified by NHS Trust. For trusts with a PAS/EPR with a FHIR API (e.g. EPIC, Meditech, Cerner, etc), this value will be defined in that API."

* assigner 1..1
* assigner ^short = "Assigning Facility"
* assigner.identifier.system = $ods-code
* assigner.identifier.value ^example.valueString = "R0A"
* assigner.identifier.value ^example.label = "Manchester University NHS Foundation Trust"

Profile:        PatientIdentifier
Parent:         CorrelationIdentifier
Id:             PatientIdentifier
Title:          "Patient Identifier"
Description:     """
Not applicable per the NHS England Canonical Data Model - use [Medical Record Number](StructureDefinition-MedicalRecordNumber.html) instead. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* type = $v2-0203#PI (exactly)

Profile:        OrganisationCode
Parent:         CorrelationIdentifier
Id:             OrganisationCode
Title:          "Organisation Code"
Description:    "ODS organisation code. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* system 1..1
* system = $ods-code (exactly)
* value 1..1

Profile:        OrganisationSiteIdentifier
Parent:         http://hl7.org/fhir/StructureDefinition/Identifier
Id:             OrganisationSiteIdentifier
Title:          "Organisation Site Identifier"
Description:    "ODS site code. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* system 1..1
* system = "https://fhir.nhs.uk/Id/ods-site-code" (exactly)
* value 1..1

Profile:        PractitionerIdentifier
Parent:         http://hl7.org/fhir/StructureDefinition/Identifier
Id:             PractitionerIdentifier
Title:          "Practitioner Identifier"
Description:    "Professional registration number (GMC, NMC, HCPC, GPhC) or GP code. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* system 1..1
* system from PractitionerIdentifiers (extensible)
* value 1..1

Profile:        ReportIdentifier
Parent:         CorrelationIdentifier
Id:             ReportIdentifier
Title:          "Report Identifier"
Description:    "Identifier of a report, assigned by the filler (reporting) organisation. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* system 1..1
* type = $v2-0203#FILL
* value 1..1
* assigner 1..1

Profile:        OrderIdentifier
Parent:         CorrelationIdentifier
Id:             OrderIdentifier
Title:          "Order Identifier"
Description:    "Placer or filler order number. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* type 1..1
* value 1..1
* assigner 1..1

Profile:        VisitNumber
Parent:         CorrelationIdentifier
Id:             VisitNumber
Title:          "Visit Number"
Description:    "Encounter or visit number. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* type = $v2-0203#VN (exactly)
* assigner 1..1 MS

// Attachment

Profile:        NWAttachment
Parent:         http://hl7.org/fhir/StructureDefinition/Attachment
Id:             NWAttachment
Title:          "Attachment"
Description:     """
DRAFT: Additional conformance on FHIR Attachment data type. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* url ^short = "Uri where the data can be found. Mandatory for PDF or FHIR Documents"
* data ^short = "Avoid using for wider compatability reasons."
* contentType from DocumentEntryMimeType

// Terminology used by the data types

ValueSet: NWIdentifierType
Id: NWIdentifierType
Title: "NW IdentifierType"
Description: """IdentifierType work around to bypass lack of NH in based definition. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""
* ^experimental  = false
* include codes from system http://terminology.hl7.org/CodeSystem/v2-0203|5.0.0
* include codes from valueset http://hl7.org/fhir/ValueSet/organization-type

CodeSystem: NationalHealthIdentifiers
Id: NationalHealthIdentifiers
Title: "UK National Health Identifier Systems"
Description: """
England/Wales NHS Number, Scotland CHI Number and Northern Ireland Health and Care Number. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* ^name = "NationalHealthIdentifiers"
* ^content = #complete
* ^caseSensitive = true
* ^experimental = false
* ^status = #draft
* ^version = "0.0.1"
* ^date = "2025-12-13"

* #https://fhir.nhs.uk/Id/nhs-number "NHS Number"
* #urn:oid:2.16.840.1.113883.2.1.3.2.4.16.53 "CHI Number"
* #https://fhir.nhs.uk/Id/hsc-number "Health and Care Number"

ValueSet: UKNationalHealthIdentifiers
Id: UKNationalHealthIdentifiers
Title: "UK National Health Identifiers"
Description: """
NHS Number, CHI Number and Health and Care Number. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* ^experimental  = false

* include codes from system NationalHealthIdentifiers

CodeSystem:  ProfessionalLicense
Id: ProfessionalLicense
Title: "UK Professional License"
Description:  "UK Professional License. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* ^experimental  = false
* ^caseSensitive  = true

* #https://fhir.hl7.org.uk/Id/gmp-number "General Medical Practitioner"
    "General Medical Practitioner Code GENERAL MEDICAL PRACTITIONER PPD CODE. Formerly called GP General National Code (GNC)."
* #https://fhir.hl7.org.uk/Id/gmc-number "General Medical Council Code"
* #https://fhir.hl7.org.uk/Id/nmc-number "Nursing and Midwifery Council Code"
* #https://fhir.hl7.org.uk/Id/gphc-number "General Pharmaceutical Council Code"
* #https://fhir.hl7.org.uk/Id/hcpc-number "Health and Care Professional Council Code"
* #https://fhir.hl7.org.uk/Id/professional-code "Do not use"

ValueSet: PractitionerIdentifiers
Id: PractitionerIdentifiers
Title: "Practitioner Identifiers"
Description: """PractitionerIdentifiers. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""
* ^experimental  = false
* include codes from system ProfessionalLicense

ValueSet: DocumentEntryMimeType
Id: document-entry-mimetype
Title: "DocumentEntry mimeType"
Description: """
- [Switzerland DocumentEntry.mimeType](https://fhir.ch/ig/ch-term/3.1.0/ValueSet-DocumentEntry.mimeType.html)

Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""
* ^experimental  = false

* $bcp13#application/pdf
* $bcp13#application/dicom
* $bcp13#application/fhir+json
* $bcp13#application/fhir+xml
* $bcp13#image/jpeg
* $bcp13#image/png
