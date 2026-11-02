Alias: $sct = http://snomed.info/sct

Profile:        PatientCarePlan
Parent:         http://hl7.eu/fhir/hdr/StructureDefinition/carePlan-eu-hdr
Id:             PatientCarePlan
Title:          "Care Plan"
Description:    """
`Care Plan` - who is doing what, for which needs, towards which goals, for any episode
of care (for example a virtual ward stay, a long term condition or a social care support
plan). Shared through IHE [Dynamic Care Planning](DCP.html); activities reference the
referrals, monitoring and tasks that carry it out. See the
[Care Plan and Execution](StructureDefinition-CarePlanModel.html) logical model. Not a
care assessment form - that is a `QuestionnaireResponse`.
"""

* basedOn MS
* basedOn ^short = "Parent care plan (e.g. the GP or community care plan)"
* status MS
* intent MS
* category 1..* MS
* category ^short = "Type of plan, e.g. SNOMED CT 960751000000107 Remote health monitoring care plan"
* subject only Reference(Patient)
* encounter MS
* encounter ^short = "The episode the plan belongs to, if any (e.g. a virtual ward stay)"
* period MS
* careTeam MS
* addresses MS
* goal MS
* activity MS
* activity.reference MS
* activity.reference ^short = "The request that carries out the activity, e.g. a Referral Request"
* activity.outcomeReference MS
