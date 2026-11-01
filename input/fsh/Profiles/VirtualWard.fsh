Alias: $sct = http://snomed.info/sct
Alias: $v3-ActCode = http://terminology.hl7.org/CodeSystem/v3-ActCode
Alias: $event-basedOn = http://hl7.org/fhir/StructureDefinition/event-basedOn

Profile:        VirtualWardEncounter
Parent:         http://hl7.eu/fhir/hdr/StructureDefinition/encounter-eu-hdr
Id:             VirtualWardEncounter
Title:          "Virtual Ward Encounter"
Description:    """
`Virtual Ward Stay` - an admission to a [virtual ward (hospital at home)](VirtualWards.html),
based on the HL7 Europe Hospital Discharge Report Encounter so that the stay can end
with a Hospital Discharge Report. HDR only allows inpatient classes; a virtual ward
stay is treated as an inpatient (`IMP`) stay at the patient's home - **To confirm**
against NHS England virtual ward data collection rules.
"""

* identifier 1..* MS
* identifier ^short = "Hospital provider spell number / visit number"
* status MS
* class = $v3-ActCode#IMP
* serviceType 1..1 MS
* serviceType ^short = "Virtual ward specialty (e.g. respiratory, frailty, heart failure)"
* subject only Reference(Patient)
* basedOn 1..* MS
* basedOn only Reference(ReferralRequest)
* basedOn ^short = "Referral to the virtual ward"
* hospitalization 1..1 MS
* hospitalization.admitSource MS
* hospitalization.admitSource from VirtualWardAdmissionRouteVS (extensible)
* hospitalization.admitSource ^short = "step-up or step-down"
* partOf MS
* partOf ^short = "The acute stay a step-down admission continues from (if the trust records it as one spell)"
* location 1..* MS
* location ^short = "The patient's home (Location.type PTRES)"
* serviceProvider 1..1 MS

Profile:        VirtualWardCarePlan
Parent:         http://hl7.eu/fhir/hdr/StructureDefinition/carePlan-eu-hdr
Id:             VirtualWardCarePlan
Title:          "Virtual Ward Care Plan"
Description:    """
`Treatment Plan` for a virtual ward stay: the monitoring, visits and escalation agreed
for the patient. Shared through IHE [Dynamic Care Planning](DCP.html); activities
reference the referrals, monitoring and tasks that carry it out.
"""

* basedOn MS
* basedOn ^short = "Parent care plan (e.g. the GP or community care plan)"
* status MS
* intent MS
* category 1..* MS
* category = $sct#960751000000107 "Remote health monitoring care plan"
* subject only Reference(Patient)
* encounter 1..1 MS
* encounter only Reference(VirtualWardEncounter)
* period MS
* careTeam MS
* addresses MS
* goal MS
* activity MS
* activity.reference MS
* activity.reference ^short = "ServiceRequest (referral, monitoring), Task or Appointment carrying out this activity"
