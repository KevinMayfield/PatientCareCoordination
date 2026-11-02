// Core NHS patient administration resources (FHIR Administration module).
//
// DUPLICATION: Organization, Practitioner, PractitionerRole, RelatedPerson, Encounter,
// HospitalSpell, Visit and HospitalProviderSpellIdentifier are copied from the NW GMSA
// FHIR IG (https://nw-gmsa.github.io/en/artifacts.html, source ../FHIRGenomics/input/fsh,
// 2026-11-01). Changes from the source: Obligation markers and the GS1 SRIN encounter
// identifier slice are removed; the Organization identifier slice is discriminated on
// system and the Practitioner identifier is not sliced (the source slices on type,
// which these identifier profiles do not fix); AdmissionSource, DischargeDestination
// and Specialty bindings are extensible, and AdmissionSource / DischargeDestination /
// DischargeMethod include the UK Core England code systems directly (UK Core is not a
// dependency). HospitalSpell.hospitalization.dischargeDisposition is bound to discharge
// DESTINATION, not discharge method as in the source, following UK Core Encounter
// (UKCore-DischargeDestination); discharge method is in the DischargeMethod extension,
// which mirrors Extension-UKCore-DischargeMethod.
// Location, EpisodeOfCare, Schedule and Slot are new, following the Interweave (YHCR)
// profiles (https://fhir.interweavedigital.com/R4/artifacts.html). Keep in step with
// the sources - see notes/research.md.

Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $v3-ParticipationType = http://terminology.hl7.org/CodeSystem/v3-ParticipationType

// Identifiers

Profile:        HospitalProviderSpellIdentifier
Parent:         CorrelationIdentifier
Id:             HospitalProviderSpellIdentifier
Title:          "Hospital Provider Spell Identifier"
Description:    """
`Account Number` / `Spell Number` - identifies a whole hospital provider spell (admission
to discharge) under one trust, assigned by the PAS / EPR. NHS Data Dictionary
[HOSPITAL PROVIDER SPELL IDENTIFIER](https://www.datadictionary.nhs.uk/data_elements/hospital_provider_spell_identifier.html).
Not the same as a [Visit Number](StructureDefinition-VisitNumber.html) - see
[Patient Administration](PatientAdministration.html#identifiers). Copied from the
[NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* type = $v2-0203#AN (exactly)
* assigner 1..1

// Individuals and entities

Profile:        Organization
Parent:         http://hl7.eu/fhir/base/StructureDefinition/organization-eu-core
Id:             Organization
Title:          "Organization"
Description:    "`Care Directory` [HL7 Europe Core - Organization](http://hl7.eu/fhir/base/StructureDefinition/organization-eu-core), identified by ODS code. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* identifier 1..* MS
* identifier only CorrelationIdentifier
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the system"
* identifier ^slicing.ordered = false
* identifier contains odsOrganisationCode 0..1 MS
* identifier[odsOrganisationCode] only OrganisationCode
* partOf.identifier only OrganisationCode

Profile:        Practitioner
Parent:         http://hl7.eu/fhir/base/StructureDefinition/practitioner-eu-core
Id:             Practitioner
Title:          "Practitioner"
Description:    "`Care Directory` [HL7 Europe Core - Practitioner](http://hl7.eu/fhir/base/StructureDefinition/practitioner-eu-core), identified by professional registration number or GP code. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* identifier 1..* MS
* identifier only PractitionerIdentifier
* name MS

Profile:        PractitionerRole
Parent:         http://hl7.eu/fhir/base/StructureDefinition/practitionerRole-eu-core
Id:             PractitionerRole
Title:          "PractitionerRole"
Description:    "`Care Directory` [HL7 Europe Core - PractitionerRole](http://hl7.eu/fhir/base/StructureDefinition/practitionerRole-eu-core) - a practitioner working for an organisation. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* practitioner 0..1 MS
* practitioner.identifier only PractitionerIdentifier
* practitioner.identifier.value MS
* practitioner.display MS
* organization 1..1 MS
* organization.identifier 1..1
* organization.identifier only OrganisationCode
* organization.identifier.value MS
* organization.display MS
* specialty from Specialty (extensible)
* telecom.value MS

Profile:        RelatedPerson
Parent:         http://hl7.org/fhir/StructureDefinition/RelatedPerson
Id:             RelatedPerson
Title:          "RelatedPerson"
Description:    "`Patient Administration` - a carer, relative or other person involved in the patient's care. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false
* identifier contains
    MedicalRecordNumber 0..* MS
    and nhsNumber 0..* MS
* identifier[nhsNumber] only NHSIdentifier
* identifier[nhsNumber] ^short = "UK National Health Identifiers: NHS NUMBER (England and Wales)"
* identifier[MedicalRecordNumber] only MedicalRecordNumber
* patient only Reference(Patient)
* relationship MS
* name MS
* telecom MS

Profile:        Location
Parent:         http://hl7.org/fhir/StructureDefinition/Location
Id:             Location
Title:          "Location"
Description:    """
`Care Directory` - a site, ward, clinic or the patient's home. Sites are identified by ODS
site code; wards and clinics are `partOf` the site. Follows the
[Interweave Location](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-Location.html)
(hospital locations down to ward level).
"""

* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the system"
* identifier ^slicing.ordered = false
* identifier contains odsSiteCode 0..1 MS
* identifier[odsSiteCode] only OrganisationSiteIdentifier
* identifier[odsSiteCode] ^short = "ODS site code (sites)"
* status MS
* name MS
* type MS
* type ^short = "e.g. hospital, ward, clinic, patient's residence (v3-RoleCode)"
* physicalType MS
* physicalType ^short = "site | building | ward | room | house"
* managingOrganization MS
* managingOrganization only Reference(Organization)
* managingOrganization.identifier only OrganisationCode
* partOf MS
* partOf only Reference(Location)

// Clinical registration

Profile:        Encounter
Parent:         http://hl7.org/fhir/StructureDefinition/Encounter
Id:             Encounter
Title:          "Encounter"
Description:    """
`Patient Administration` `Base`. For implementation use:
- [Hospital Spell](StructureDefinition-HospitalSpell.html) - `Account Number` - an admission, admission to discharge
- [Visit](StructureDefinition-Visit.html) - `Visit Number` - an A&E attendance, an outpatient attendance (appointment), a community contact, etc.

Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* identifier 1..* MS
* identifier only CorrelationIdentifier
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "type"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Slice based on the type"
* identifier ^slicing.ordered = false
* identifier.value MS
* status MS
* class 1..1
* type 0..1
* serviceType 0..1 MS
* subject 1..1 MS
* subject only Reference(Patient)
* subject.identifier only NHSIdentifier
* basedOn MS
* basedOn ^short = "The referral this encounter carries out"
* episodeOfCare MS
* appointment MS
* participant MS
* period MS
* period.start MS
* location.location only Reference(Location)
* serviceProvider 0..1
* serviceProvider.identifier only OrganisationCode

Profile:        HospitalSpell
Parent:         Encounter
Id:             HospitalSpell
Title:          "Hospital Spell"
Description:    """
`Patient Administration` - a hospital provider spell, identified by the
[Hospital Provider Spell Identifier](StructureDefinition-HospitalProviderSpellIdentifier.html)
(`Account Number`). Groups the [Visits](StructureDefinition-Visit.html) within it.
Related to the [Interweave EncounterGrouping](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-EncounterGrouping.html).
Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* identifier contains HospitalSpellIdentifier 0..1 MS
* identifier[HospitalSpellIdentifier] only HospitalProviderSpellIdentifier
* identifier[HospitalSpellIdentifier] ^short = "Account Number / Spell Number (HL7 v2 type AN)"
* participant.type 1..1
* participant.type.coding 1..*
* participant.type.coding.code 1..1
* participant ^slicing.discriminator.type = #value
* participant ^slicing.discriminator.path = "type.coding"
* participant ^slicing.rules = #open
* participant contains
    referringDoctor 0..1
    and admittingDoctor 0..1
* participant[referringDoctor].type.coding = $v3-ParticipationType#REF
* participant[referringDoctor].individual.identifier only PractitionerIdentifier
* participant[admittingDoctor].type.coding = $v3-ParticipationType#ADM
* participant[admittingDoctor].individual.identifier only PractitionerIdentifier
* partOf 0..0
* hospitalization MS
* hospitalization.admitSource from AdmissionSource (extensible)
* hospitalization.dischargeDisposition from DischargeDestination (extensible)
* hospitalization.dischargeDisposition ^short = "Discharge destination - where the patient went (PV1-37)"
* extension contains DischargeMethod named dischargeMethod 0..1 MS

Profile:        Visit
Parent:         Encounter
Id:             Visit
Title:          "Visit"
Description:    """
`Patient Administration` - an attendance or contact, identified by the
[Visit Number](StructureDefinition-VisitNumber.html): an A&E attendance, an outpatient
attendance, a community contact, or a stay within a spell. `partOf` the
[Hospital Spell](StructureDefinition-HospitalSpell.html) when it is part of an admission.
Equivalent to the [Interweave Encounter](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-Encounter.html).
Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""

* identifier contains VisitNumber 0..1 MS
* identifier[VisitNumber] only VisitNumber
* identifier[VisitNumber] ^short = "Visit Number (HL7 v2 type VN)"
* participant.type 1..1
* participant.type.coding 1..*
* participant.type.coding.code 1..1
* participant ^slicing.discriminator.type = #value
* participant ^slicing.discriminator.path = "type.coding"
* participant ^slicing.rules = #open
* participant contains
    consultingDoctor 0..*
    and attendingDoctor 0..1
* participant[consultingDoctor].type.coding = $v3-ParticipationType#CON
* participant[consultingDoctor].individual.identifier only PractitionerIdentifier
* participant[attendingDoctor].type.coding = $v3-ParticipationType#ATND
* participant[attendingDoctor].individual.identifier only PractitionerIdentifier
* partOf only Reference(HospitalSpell)
* partOf.identifier only HospitalProviderSpellIdentifier

Profile:        EpisodeOfCare
Parent:         http://hl7.org/fhir/StructureDefinition/EpisodeOfCare
Id:             EpisodeOfCare
Title:          "Episode Of Care"
Description:    """
`Patient Administration` - the period an organisation is responsible for a patient's
care, from accepting a referral to discharge, during which encounters occur (e.g. a
community service, an exercise or rehabilitation programme, a mental health team).
Follows the [Interweave EpisodeOfCare](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-EpisodeOfCare.html).
**Not** an NHS consultant episode - see [Patient Administration](PatientAdministration.html#identifiers).
"""

* identifier 1..* MS
* identifier ^short = "Local identifier, quotable if contacting the service"
* status MS
* statusHistory MS
* type MS
* diagnosis MS
* patient only Reference(Patient)
* patient.identifier only NHSIdentifier
* managingOrganization 1..1 MS
* managingOrganization only Reference(Organization)
* period MS
* referralRequest MS
* referralRequest only Reference(ReferralRequest)
* referralRequest ^short = "The referral that started this episode"
* careManager MS
* careManager only Reference(Practitioner or PractitionerRole)
* team MS

// Scheduling

Profile:        Schedule
Parent:         http://hl7.org/fhir/StructureDefinition/Schedule
Id:             Schedule
Title:          "Schedule"
Description:    "`Scheduling` - the availability of a service, clinician or location (a clinic), whose Slots can be booked. Follows the [Interweave Schedule](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-Schedule.html)."

* identifier MS
* active MS
* serviceType MS
* specialty MS
* specialty from Specialty (extensible)
* actor MS
* actor only Reference(HealthcareService or PractitionerRole or Practitioner or Location)
* planningHorizon MS

Profile:        Slot
Parent:         http://hl7.org/fhir/StructureDefinition/Slot
Id:             Slot
Title:          "Slot"
Description:    "`Scheduling` - a bookable period on a Schedule. Follows the [Interweave Slot](https://fhir.interweavedigital.com/R4/StructureDefinition-Interweave-Slot.html)."

* serviceType MS
* appointmentType MS
* schedule MS
* schedule only Reference(Schedule)
* status MS
* start MS
* end MS

// Terminology used by the profiles

ValueSet: AdmissionSource
Id: admission-source
Title: "Admission Source"
Description: """
`NHS Data Model and Dictionary` [ADMISSION SOURCE](https://www.datadictionary.nhs.uk/attributes/admission_source.html)
- [UKCoreSourceOfAdmission](https://simplifier.net/hl7fhirukcorer4/valueset-ukcore-sourceofadmission)

Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""
* ^experimental = false
* include codes from system https://fhir.hl7.org.uk/CodeSystem/UKCore-SourceOfAdmissionEngland

ValueSet: DischargeDestination
Id: discharge-destination
Title: "Discharge Destination"
Description: """
`NHS Data Model and Dictionary` [DISCHARGE DESTINATION](https://www.datadictionary.nhs.uk/attributes/discharge_destination.html)
- [UKCoreDischargeDestination](https://simplifier.net/hl7fhirukcorer4/valueset-ukcore-dischargedestination)

Bound to `Encounter.hospitalization.dischargeDisposition` ("category or kind of location
after discharge"), as in UK Core Encounter.
"""
* ^experimental = false
* include codes from system https://fhir.hl7.org.uk/CodeSystem/UKCore-DischargeDestinationEngland

ValueSet: DischargeMethodVS
Id: discharge-method
Title: "Discharge Method"
Description: """
`NHS Data Model and Dictionary` [DISCHARGE METHOD CODE](https://www.datadictionary.nhs.uk/data_elements/discharge_method_code__hospital_provider_spell_.html)
- [UKCoreDischargeMethod](https://simplifier.net/hl7fhirukcorer4/valueset-ukcore-dischargemethod)

Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/) (where it was bound to
`dischargeDisposition`); here used by the [Discharge Method](StructureDefinition-DischargeMethod.html) extension.
"""
* ^experimental = false
* include codes from system https://fhir.hl7.org.uk/CodeSystem/UKCore-DischargeMethodEngland

Extension: DischargeMethod
Id: DischargeMethod
Title: "Discharge Method"
Description: """
How the patient was discharged from a Hospital Spell (e.g. on clinical advice, self
discharge, died) - HL7 v2 PV1-36. The destination is `hospitalization.dischargeDisposition`.

DUPLICATION: mirrors [Extension-UKCore-DischargeMethod](https://simplifier.net/hl7fhirukcorer4/extension-ukcore-dischargemethod)
(UK Core is not a dependency of this guide) - **To confirm** whether to use the UK Core
extension directly.
"""
Context: Encounter
* ^experimental = true
* value[x] only CodeableConcept
* valueCodeableConcept from DischargeMethodVS (extensible)

ValueSet: Specialty
Id: specialty
Title: "Specialty"
Description: """
`NHS Data Model and Dictionary` [MAIN SPECIALTY CODE](https://www.datadictionary.nhs.uk/attributes/main_specialty_code.html)
- [UKCorePracticeSettingCode](https://simplifier.net/hl7fhirukcorer4/valueset-ukcore-practicesettingcode)
- [HL7 Practice Setting Code Value Set](https://hl7.org/fhir/R4/valueset-c80-practice-codes.html)

Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/).
"""
* ^experimental = false
* include codes from system https://fhir.hl7.org.uk/CodeSystem/UKCore-PracticeSettingCode
* include codes from valueset http://hl7.org/fhir/ValueSet/c80-practice-codes
