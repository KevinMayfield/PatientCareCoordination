// Patient administration for the GP to cardiology referral: the clinic Schedule and
// Slot, the outpatient attendance (Visit, Visit Number) and the cardiac catheterisation
// day case admission (Hospital Spell, Account / Spell Number, with a Visit inside it).
// Plus the episode of care for the exercise on referral programme. Fictitious data.

Alias: $sct = http://snomed.info/sct
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $v3-RoleCode = http://terminology.hl7.org/CodeSystem/v3-RoleCode
Alias: $v3-ParticipationType = http://terminology.hl7.org/CodeSystem/v3-ParticipationType
Alias: $location-physical-type = http://terminology.hl7.org/CodeSystem/location-physical-type
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code

// Locations

Instance: HospitalSite
InstanceOf: Location
Title: "Location - Hospital site"
Description: "A hospital site, identified by its ODS site code (example value)."
Usage: #example
* identifier[odsSiteCode].system = "https://fhir.nhs.uk/Id/ods-site-code"
* identifier[odsSiteCode].value = "R0A09"
* status = #active
* name = "Example Hospital Site"
* type = $v3-RoleCode#HOSP "Hospital"
* physicalType = $location-physical-type#si "Site"
* managingOrganization = Reference(R0A)
* managingOrganization.identifier.system = $ods-code
* managingOrganization.identifier.value = "R0A"

Instance: CardiologyClinic
InstanceOf: Location
Title: "Location - Cardiology outpatient clinic"
Usage: #example
Description: "The cardiology outpatient clinic, part of the hospital site."
* status = #active
* name = "Cardiology Outpatients"
* type = $v3-RoleCode#CARD "Ambulatory Health Care Facilities; Clinic/Center; Rehabilitation: Cardiac Facilities"
* physicalType = $location-physical-type#ro "Room"
* managingOrganization = Reference(R0A)
* partOf = Reference(HospitalSite)

Instance: CardiacDayUnit
InstanceOf: Location
Title: "Location - Cardiac day unit"
Description: "The ward where the day case catheterisation patient is admitted."
Usage: #example
* status = #active
* name = "Cardiac Day Unit"
* type = $v3-RoleCode#CARD "Ambulatory Health Care Facilities; Clinic/Center; Rehabilitation: Cardiac Facilities"
* physicalType = $location-physical-type#wa "Ward"
* managingOrganization = Reference(R0A)
* partOf = Reference(HospitalSite)

// Scheduling

Instance: CardiologyClinicSchedule
InstanceOf: Schedule
Title: "Schedule - Dr Brown's cardiology clinic"
Description: "The clinic whose slots are booked for referred patients."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/schedule"
* identifier.value = "CARD-BROWN-MON-PM"
* active = true
* serviceType.text = "General cardiology outpatients"
* specialty = $sct#394579002 "Cardiology"
* actor[+] = Reference(CardiologistBrownRole)
* actor[+] = Reference(CardiologyService)
* actor[+] = Reference(CardiologyClinic)
* planningHorizon.start = "2026-09-01"
* planningHorizon.end = "2026-12-31"

Instance: CardiologyClinicSlot
InstanceOf: Slot
Title: "Slot - 7 September 2026, 14:00"
Description: "The slot booked for Mr Tameside's appointment."
Usage: #example
* serviceType.text = "General cardiology outpatients"
* schedule = Reference(CardiologyClinicSchedule)
* status = #busy
* start = "2026-09-07T14:00:00+01:00"
* end = "2026-09-07T14:30:00+01:00"

// Outpatient attendance - Visit Number

Instance: CardiologyOutpatientAttendance
InstanceOf: Visit
Title: "Visit - Cardiology outpatient attendance"
Description: "The outpatient attendance for the appointment, identified by a Visit Number (HL7 v2 PV1-19, type VN). Not part of a hospital spell."
Usage: #example
* identifier[VisitNumber].type = $v2-0203#VN
* identifier[VisitNumber].value = "OP2026090701"
* identifier[VisitNumber].assigner.identifier.system = $ods-code
* identifier[VisitNumber].assigner.identifier.value = "R0A"
* status = #finished
* class = $v3-ActCode#AMB "ambulatory"
* serviceType.text = "General cardiology outpatients"
* subject = Reference(Patient-Tameside)
* basedOn = Reference(CardiologyReferral)
* appointment = Reference(CardiologyAppointment)
* participant[attendingDoctor].type = $v3-ParticipationType#ATND
* participant[attendingDoctor].individual = Reference(CardiologistBrownRole)
* period.start = "2026-09-07T14:05:00+01:00"
* period.end = "2026-09-07T14:35:00+01:00"
* location.location = Reference(CardiologyClinic)
* serviceProvider = Reference(R0A)

// Day case admission - Account / Spell Number, with a Visit inside it

Instance: CardiacCatheterisationSpell
InstanceOf: HospitalSpell
Title: "Hospital Spell - Day case admission for cardiac catheterisation"
Description: "The admission, identified by the Hospital Provider Spell Identifier (Account Number, HL7 v2 type AN)."
Usage: #example
* identifier[HospitalSpellIdentifier].type = $v2-0203#AN
* identifier[HospitalSpellIdentifier].value = "1001166717"
* identifier[HospitalSpellIdentifier].assigner.identifier.system = $ods-code
* identifier[HospitalSpellIdentifier].assigner.identifier.value = "R0A"
* status = #finished
* class = $v3-ActCode#IMP "inpatient encounter"
* serviceType.text = "Cardiology"
* subject = Reference(Patient-Tameside)
* basedOn = Reference(CardiologyReferral)
* participant[admittingDoctor].type = $v3-ParticipationType#ADM
* participant[admittingDoctor].individual = Reference(CardiologistBrownRole)
* period.start = "2026-09-21T08:00:00+01:00"
* period.end = "2026-09-21T17:00:00+01:00"
* serviceProvider = Reference(R0A)

Instance: CardiacCatheterisationVisit
InstanceOf: Visit
Title: "Visit - Cardiac day unit stay (part of the spell)"
Description: "The stay on the cardiac day unit, with its own Visit Number, partOf the Hospital Spell."
Usage: #example
* identifier[VisitNumber].type = $v2-0203#VN
* identifier[VisitNumber].value = "IP2026092101"
* identifier[VisitNumber].assigner.identifier.system = $ods-code
* identifier[VisitNumber].assigner.identifier.value = "R0A"
* status = #finished
* class = $v3-ActCode#IMP "inpatient encounter"
* serviceType.text = "Cardiology"
* subject = Reference(Patient-Tameside)
* participant[attendingDoctor].type = $v3-ParticipationType#ATND
* participant[attendingDoctor].individual = Reference(CardiologistBrownRole)
* period.start = "2026-09-21T08:00:00+01:00"
* period.end = "2026-09-21T17:00:00+01:00"
* location.location = Reference(CardiacDayUnit)
* serviceProvider = Reference(R0A)
* partOf = Reference(CardiacCatheterisationSpell)
* partOf.identifier.type = $v2-0203#AN
* partOf.identifier.value = "1001166717"
* partOf.identifier.assigner.identifier.system = $ods-code
* partOf.identifier.assigner.identifier.value = "R0A"

// Episode of care - exercise on referral programme

Instance: ExerciseProgrammeEpisode
InstanceOf: EpisodeOfCare
Title: "EpisodeOfCare - Exercise on referral programme"
Description: "The leisure trust's responsibility for Mr Tameside from accepting the referral to the end of the programme. Its sessions are encounters within the episode."
Usage: #example
* identifier.system = "https://fhir.example-leisure.org.uk/Id/episode"
* identifier.value = "EOR-2026-0042"
* status = #active
* type.text = "Exercise on referral programme"
* patient = Reference(Patient-Tameside)
* managingOrganization = Reference(ExampleLeisureTrust)
* period.start = "2026-10-23"
* referralRequest = Reference(ExerciseReferral)
