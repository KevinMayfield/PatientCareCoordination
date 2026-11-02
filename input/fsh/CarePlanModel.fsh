Logical:        CarePlanModel
Id:             CarePlanModel
Title:          "Care Plan and Execution"
Description:    """
**Proof of concept - not an authoritative source.**

A **care plan** - who is doing what, for which needs, towards which goals - and its
**execution**: the referrals, tasks, appointments and encounters that carry out each
activity, and their progress. A referral is one activity of a care plan.

This is the care plan of [IHE Dynamic Care Planning](DCP.html), FHIR `CarePlan` and
social care, and the PRSB
[Personalised Care and Support Plan](https://theprsb.org/standards/personalisedcareandsupportplan).
It is **not** a care assessment: in the NHS "care plan" is often the name for an
assessment form, which is a `QuestionnaireResponse` (see [Referral Forms](ReferralForms.html)
and the [BaRS review](BaRS.html#3-careplan-is-the-assessment-not-a-plan)).
The **Mappings** tab shows each element in FHIR.
"""
Characteristics: #can-be-target

* ^experimental = true

// The plan

* planId 1..1 Identifier "Care plan ID" "Unique identifier of the plan"
* patient 1..1 Identifier "Patient" "NHS Number and local identifiers"
* category 1..* CodeableConcept "Category" "e.g. virtual ward treatment plan, long term condition, social care support plan"
* title 0..1 string "Title" "Human readable name"
* status 1..1 code "Status" "draft, active, on-hold, completed, revoked"
* period 0..1 Period "Period" "When the plan applies"
* reviewDate 0..1 date "Review date" "When the plan is next reviewed"
* author 1..1 Identifier "Author" "Lead professional or organisation"
* agreedWithPatient 0..1 boolean "Agreed with the patient" "The patient (or representative) has agreed the plan"
* basedOn 0..* Identifier "Parent plan" "The plan this one implements, e.g. the GP or community care plan"

// Who

* careTeam 0..* BackboneElement "Care team" "The people and organisations involved"
  * member 1..1 Identifier "Member" "Practitioner, organisation, carer or the patient"
  * role 0..1 CodeableConcept "Role" "e.g. lead professional, key worker, carer"

// Why

* needs 0..* CodeableConcept "Needs and problems" "Conditions, needs or concerns the plan addresses"
* goals 0..* BackboneElement "Goals" "What the plan is trying to achieve"
  * description 1..1 string "Goal" "Described in the patient's words where possible"
  * target 0..1 string "Target" "Measure and date"
  * status 0..1 code "Achievement" "in-progress, achieved, not-achieved"

// What - and its execution

* activity 0..* BackboneElement "Activities" "The actions agreed"
  * description 1..1 string "Activity" "What will be done"
  * kind 0..1 code "Kind" "referral, task, appointment, monitoring, medication, education"
  * performer 0..* Identifier "Performer" "Who carries it out"
  * scheduled 0..1 Period "When" "Timing or frequency"
  * status 1..1 code "Status" "not-started, scheduled, in-progress, on-hold, completed, cancelled"
  * request 0..1 Reference(ServiceRequest or Task or Appointment or MedicationRequest) "Request" "The request that carries out the activity, e.g. a referral (Clinical Referral)"
  * outcome 0..* Reference(Encounter or Procedure or Observation or DiagnosticReport or DocumentReference) "Outcome" "What was done - e.g. the Discharge Report from a referral"
  * progress 0..* string "Progress" "Notes on progress"

Mapping:        CarePlanModel-FHIR
Source:         CarePlanModel
Target:         "http://hl7.org/fhir/R4"
Id:             fhir
Title:          "FHIR R4 (CarePlan, IHE DCP)"
* planId -> "CarePlan.identifier"
* patient -> "CarePlan.subject"
* category -> "CarePlan.category"
* title -> "CarePlan.title"
* status -> "CarePlan.status"
* period -> "CarePlan.period"
* reviewDate -> "CarePlan.activity (review) or extension - To confirm"
* author -> "CarePlan.author"
* agreedWithPatient -> "Consent, or CarePlan.contributor including the patient - To confirm"
* basedOn -> "CarePlan.basedOn / partOf"
* careTeam -> "CarePlan.careTeam (CareTeam)"
* careTeam.member -> "CareTeam.participant.member"
* careTeam.role -> "CareTeam.participant.role"
* needs -> "CarePlan.addresses (Condition)"
* goals -> "CarePlan.goal (Goal)"
* goals.description -> "Goal.description"
* goals.target -> "Goal.target"
* goals.status -> "Goal.achievementStatus"
* activity -> "CarePlan.activity"
* activity.description -> "CarePlan.activity.detail.description"
* activity.kind -> "CarePlan.activity.detail.kind"
* activity.performer -> "CarePlan.activity.detail.performer"
* activity.scheduled -> "CarePlan.activity.detail.scheduled[x]"
* activity.status -> "CarePlan.activity.detail.status"
* activity.request -> "CarePlan.activity.reference (ServiceRequest - the referral; ServiceRequest.basedOn the CarePlan)"
* activity.outcome -> "CarePlan.activity.outcomeReference"
* activity.progress -> "CarePlan.activity.progress"
