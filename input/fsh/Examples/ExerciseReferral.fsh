// Referral with forms: after the cardiology outcome, the GP refers Mr Tameside to an
// exercise on referral programme. The GP completes the service's referral form (ask at
// order entry); the service then asks the patient to complete a pre-participation
// screening form before the first session. The patient is an NW GMSA test patient;
// other data is fictitious. The screening form follows the structure of the PAR-Q+ but
// is not the PAR-Q+, which needs written permission to reproduce or put into electronic
// forms (https://eparmedx.com/about/terms-and-conditions/).

Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org
Alias: $ucum = http://unitsofmeasure.org
Alias: $v2-0203 = http://terminology.hl7.org/CodeSystem/v2-0203
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code
Alias: $nhs-number = https://fhir.nhs.uk/Id/nhs-number
Alias: $obs-category = http://terminology.hl7.org/CodeSystem/observation-category

Instance: ExampleLeisureTrust
InstanceOf: Organization
Title: "Organization - Example Leisure Trust"
Description: "Fictitious leisure trust running the exercise on referral programme - the Referral Recipient."
Usage: #example
* identifier.system = $ods-code
* identifier.value = "Y00002"
* name = "Example Leisure Trust"

Instance: ExerciseReferralService
InstanceOf: HealthcareService
Title: "HealthcareService - Exercise on Referral Programme"
Description: "The exercise on referral programme. Its referral form is published as a Questionnaire."
Usage: #example
* providedBy = Reference(ExampleLeisureTrust)
* name = "Exercise on Referral Programme"
* type = $sct#526151000000109 "Referral to exercise on referral programme"

// Forms published by the Referral Recipient

Instance: ExerciseReferralForm
InstanceOf: Questionnaire
Title: "Questionnaire - Exercise on referral: referrer's form"
Description: "Illustrative referral form completed by the referring clinician when the referral is made (ask at order entry). Items with a LOINC code are also sent as Observations."
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExerciseReferralForm"
* name = "ExerciseReferralForm"
* title = "Exercise on referral - referrer's form"
* status = #draft
* experimental = true
* subjectType = #Patient
* item[+]
  * linkId = "reason"
  * text = "Reason for referral"
  * type = #string
  * required = true
* item[+]
  * linkId = "systolic"
  * code = $loinc#8480-6 "Systolic blood pressure"
  * text = "Resting systolic blood pressure (mmHg)"
  * type = #integer
  * required = true
* item[+]
  * linkId = "diastolic"
  * code = $loinc#8462-4 "Diastolic blood pressure"
  * text = "Resting diastolic blood pressure (mmHg)"
  * type = #integer
  * required = true
* item[+]
  * linkId = "heart-rate"
  * code = $loinc#8867-4 "Heart rate"
  * text = "Resting heart rate (beats per minute)"
  * type = #integer
* item[+]
  * linkId = "bmi"
  * code = $loinc#39156-5 "Body mass index (BMI) [Ratio]"
  * text = "Body mass index"
  * type = #decimal
* item[+]
  * linkId = "conditions"
  * text = "Relevant conditions"
  * type = #string
  * repeats = true
* item[+]
  * linkId = "suitable"
  * text = "Is the patient medically suitable for supervised exercise?"
  * type = #boolean
  * required = true
* item[+]
  * linkId = "precautions"
  * text = "Precautions or exercise restrictions"
  * type = #text

Instance: ExercisePreParticipationForm
InstanceOf: Questionnaire
Title: "Questionnaire - Physical activity readiness (PAR-Q+ structure, illustrative)"
Description: """
Pre-participation screening completed by the patient before the first session, following the
**structure** of the PAR-Q+ for individuals (2025): seven general health questions; follow-up
questions about medical conditions, shown only if any answer is yes (one of the ten condition
sections, cardiovascular, is shown); and the participant declaration. Item text is short
descriptive labels, **not** the official PAR-Q+ wording.
"""
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExercisePreParticipationForm"
* name = "ExercisePreParticipationForm"
* title = "Physical activity readiness (PAR-Q+ structure, illustrative)"
* status = #draft
* experimental = true
* subjectType = #Patient
* copyright = "Structure based on the PAR-Q+ (Copyright PAR-Q+ Collaboration). This is not the PAR-Q+: item text is descriptive only. Reproducing the PAR-Q+, or incorporating it into electronic forms, needs prior written authorisation from the PAR-Q+ Collaboration (https://eparmedx.com/about/terms-and-conditions/)."
* item[+]
  * linkId = "general"
  * text = "General health questions"
  * type = #group
  * item[+]
    * linkId = "q1"
    * prefix = "1"
    * text = "Heart condition or high blood pressure diagnosed by a doctor"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q2"
    * prefix = "2"
    * text = "Chest pain (at rest, daily activities or physical activity)"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q3"
    * prefix = "3"
    * text = "Dizziness causing loss of balance, or loss of consciousness, in the last 12 months"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q4"
    * prefix = "4"
    * text = "Other chronic medical condition diagnosed"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q4-conditions"
    * text = "Conditions"
    * type = #string
    * repeats = true
    * enableWhen.question = "q4"
    * enableWhen.operator = #=
    * enableWhen.answerBoolean = true
  * item[+]
    * linkId = "q5"
    * prefix = "5"
    * text = "Currently taking prescribed medication for a chronic condition"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q5-medications"
    * text = "Conditions and medications"
    * type = #string
    * repeats = true
    * enableWhen.question = "q5"
    * enableWhen.operator = #=
    * enableWhen.answerBoolean = true
  * item[+]
    * linkId = "q6"
    * prefix = "6"
    * text = "Bone, joint or soft tissue problem that activity could make worse (last 12 months)"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "q6-conditions"
    * text = "Conditions"
    * type = #string
    * repeats = true
    * enableWhen.question = "q6"
    * enableWhen.operator = #=
    * enableWhen.answerBoolean = true
  * item[+]
    * linkId = "q7"
    * prefix = "7"
    * text = "Advised by a doctor to do only medically supervised physical activity"
    * type = #boolean
    * required = true
* item[+]
  * linkId = "follow-up"
  * text = "Follow-up questions about medical conditions (completed if any general health answer is yes)"
  * type = #group
  * enableBehavior = #any
  * enableWhen[+].question = "q1"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q2"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q3"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q4"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q5"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q6"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * enableWhen[+].question = "q7"
  * enableWhen[=].operator = #=
  * enableWhen[=].answerBoolean = true
  * item[+]
    * linkId = "fu-cardiovascular"
    * prefix = "3"
    * text = "Heart or cardiovascular condition (one of ten condition sections; the others are not shown)"
    * type = #group
    * item[+]
      * linkId = "fu3"
      * text = "Has a heart or cardiovascular condition"
      * type = #boolean
      * required = true
    * item[+]
      * linkId = "fu3a"
      * prefix = "3a"
      * text = "Condition hard to control with current treatment"
      * type = #boolean
      * enableWhen.question = "fu3"
      * enableWhen.operator = #=
      * enableWhen.answerBoolean = true
    * item[+]
      * linkId = "fu3b"
      * prefix = "3b"
      * text = "Irregular heartbeat needing medical management"
      * type = #boolean
      * enableWhen.question = "fu3"
      * enableWhen.operator = #=
      * enableWhen.answerBoolean = true
    * item[+]
      * linkId = "fu3c"
      * prefix = "3c"
      * text = "Chronic heart failure"
      * type = #boolean
      * enableWhen.question = "fu3"
      * enableWhen.operator = #=
      * enableWhen.answerBoolean = true
    * item[+]
      * linkId = "fu3d"
      * prefix = "3d"
      * text = "Coronary artery disease and not regularly active in the last 2 months"
      * type = #boolean
      * enableWhen.question = "fu3"
      * enableWhen.operator = #=
      * enableWhen.answerBoolean = true
* item[+]
  * linkId = "declaration"
  * text = "Participant declaration"
  * type = #group
  * item[+]
    * linkId = "declaration-agreed"
    * text = "I have read and completed this questionnaire; clearance is valid for up to 12 months and ends if my health changes"
    * type = #boolean
    * required = true
  * item[+]
    * linkId = "declaration-name"
    * text = "Name"
    * type = #string
    * required = true
  * item[+]
    * linkId = "declaration-date"
    * text = "Date"
    * type = #date
    * required = true

// Referral Request [PCC-55] with the referrer's form

Instance: ExerciseReferral
InstanceOf: ReferralRequest
Title: "Referral Request - GP to Exercise on Referral Programme"
Description: "Referral Request [PCC-55] with the service's referral form completed by the GP (QuestionnaireResponse) and the answers also sent as Observations."
Usage: #example
* identifier[referralId].type = $v2-0203#PLAC
* identifier[referralId].system = "https://fhir.example-practice.nhs.uk/Id/referral"
* identifier[referralId].value = "REF-2026-000789"
* identifier[referralId].assigner.identifier.system = $ods-code
* identifier[referralId].assigner.identifier.value = "P89020"
* status = #active
* intent = #order
* category = $sct#3457005 "Patient referral"
* priority = #routine
* code = $sct#526151000000109 "Referral to exercise on referral programme"
* subject = Reference(Patient-Tameside)
* subject.identifier.system = $nhs-number
* subject.identifier.value = "9737383397"
* subject.identifier.type = $v2-0203#NH
* authoredOn = "2026-10-20T10:00:00+01:00"
* requester = Reference(GPAllenRole)
* performer = Reference(ExerciseReferralService)
* reasonCode = $sct#53741008 "Coronary arteriosclerosis"
* supportingInfo[+] = Reference(ExerciseReferralFormResponse)
* supportingInfo[+] = Reference(ExerciseReferralBloodPressure)
* supportingInfo[+] = Reference(CardiologyOutcomeNote)
* note.text = "Coronary artery disease, medically managed after cardiac catheterisation. Supervised exercise to improve fitness and reduce cardiovascular risk."

Instance: ExerciseReferralFormResponse
InstanceOf: QuestionnaireResponse
Title: "QuestionnaireResponse - Referrer's form (completed by the GP)"
Description: "The exercise referral form completed by the GP when making the referral."
Usage: #example
* questionnaire = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExerciseReferralForm"
* status = #completed
* subject = Reference(Patient-Tameside)
* authored = "2026-10-20T10:00:00+01:00"
* author = Reference(GPAllenRole)
* item[+]
  * linkId = "reason"
  * answer.valueString = "Coronary artery disease - improve fitness and reduce cardiovascular risk"
* item[+]
  * linkId = "systolic"
  * answer.valueInteger = 132
* item[+]
  * linkId = "diastolic"
  * answer.valueInteger = 84
* item[+]
  * linkId = "heart-rate"
  * answer.valueInteger = 68
* item[+]
  * linkId = "bmi"
  * answer.valueDecimal = 30.1
* item[+]
  * linkId = "conditions"
  * answer.valueString = "Coronary artery disease"
* item[+]
  * linkId = "suitable"
  * answer.valueBoolean = true
* item[+]
  * linkId = "precautions"
  * answer.valueString = "Moderate intensity only for the first 6 weeks. Stop if chest pain."

Instance: ExerciseReferralBloodPressure
InstanceOf: http://hl7.org/fhir/StructureDefinition/bp
Title: "Observation - Blood pressure (from the referral form)"
Description: "Blood pressure from the referrer's form, sent as an Observation so it can be used as data."
Usage: #example
* status = #final
* category[VSCat] = $obs-category#vital-signs
* code = $loinc#85354-9 "Blood pressure panel with all children optional"
* subject = Reference(Patient-Tameside)
* effectiveDateTime = "2026-10-20T09:50:00+01:00"
* performer = Reference(GPAllenRole)
* derivedFrom = Reference(ExerciseReferralFormResponse)
* component[SystolicBP].code = $loinc#8480-6 "Systolic blood pressure"
* component[SystolicBP].valueQuantity = 132 'mm[Hg]' "mmHg"
* component[DiastolicBP].code = $loinc#8462-4 "Diastolic blood pressure"
* component[DiastolicBP].valueQuantity = 84 'mm[Hg]' "mmHg"

// Accept, then ask the patient to complete the screening form

Instance: ExerciseReferralFormRequested
InstanceOf: ReferralTask
Title: "Referral Task - Accepted, patient form requested"
Description: "The service accepts the referral and asks the patient to complete the pre-participation screening (Task.input) before booking the first session."
Usage: #example
* basedOn = Reference(ExerciseReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000789"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* focus = Reference(ExerciseReferral)
* for = Reference(Patient-Tameside)
* status = #on-hold
* businessStatus = ReferralWorkflowStatus#information-requested
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-10-20T10:00:00+01:00"
* lastModified = "2026-10-21T09:00:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(ExerciseReferralService)
* note.text = "Referral accepted. Please complete the pre-participation screening before we book your first session."
* input.type = ReferralTaskParameter#questionnaire
* input.valueCanonical = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExercisePreParticipationForm"

Instance: ExercisePreParticipationResponse
InstanceOf: QuestionnaireResponse
Title: "QuestionnaireResponse - Physical activity readiness (completed by the patient)"
Description: "Hodor TAMESIDE's answers. He answers yes to a diagnosed heart condition and to prescribed medication, so completes the follow-up questions; coronary artery disease without regular activity in the last 2 months means he should get advice from a qualified exercise professional before becoming more active - which the programme provides."
Usage: #example
* questionnaire = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExercisePreParticipationForm"
* status = #completed
* subject = Reference(Patient-Tameside)
* authored = "2026-10-22T19:30:00+01:00"
* author = Reference(Patient-Tameside)
* source = Reference(Patient-Tameside)
* item[+]
  * linkId = "general"
  * item[+]
    * linkId = "q1"
    * answer.valueBoolean = true
  * item[+]
    * linkId = "q2"
    * answer.valueBoolean = false
  * item[+]
    * linkId = "q3"
    * answer.valueBoolean = false
  * item[+]
    * linkId = "q4"
    * answer.valueBoolean = false
  * item[+]
    * linkId = "q5"
    * answer.valueBoolean = true
  * item[+]
    * linkId = "q5-medications"
    * answer[+].valueString = "Coronary artery disease: aspirin, atorvastatin, bisoprolol"
  * item[+]
    * linkId = "q6"
    * answer.valueBoolean = false
  * item[+]
    * linkId = "q7"
    * answer.valueBoolean = false
* item[+]
  * linkId = "follow-up"
  * item[+]
    * linkId = "fu-cardiovascular"
    * item[+]
      * linkId = "fu3"
      * answer.valueBoolean = true
    * item[+]
      * linkId = "fu3a"
      * answer.valueBoolean = false
    * item[+]
      * linkId = "fu3b"
      * answer.valueBoolean = false
    * item[+]
      * linkId = "fu3c"
      * answer.valueBoolean = false
    * item[+]
      * linkId = "fu3d"
      * answer.valueBoolean = true
* item[+]
  * linkId = "declaration"
  * item[+]
    * linkId = "declaration-agreed"
    * answer.valueBoolean = true
  * item[+]
    * linkId = "declaration-name"
    * answer.valueString = "Hodor TAMESIDE"
  * item[+]
    * linkId = "declaration-date"
    * answer.valueDate = "2026-10-22"

Instance: ExerciseVitalSignBaseline
InstanceOf: Observation
Title: "Observation - Exercise Vital Sign (baseline)"
Description: "Minutes of moderate or vigorous physical activity a week, recorded at the first session. Repeated during the programme as a progress observation."
Usage: #example
* status = #final
* category = $obs-category#activity
* code = $loinc#89574-8 "Exercise Vital Sign (EVS)"
* subject = Reference(Patient-Tameside)
* effectiveDateTime = "2026-10-22"
* performer = Reference(Patient-Tameside)
* valueQuantity = 30 'min/wk' "min/wk"

Instance: ExerciseReferralInProgress
InstanceOf: ReferralTask
Title: "Referral Task - Form completed, in progress"
Description: "The patient has completed the form (Task.output); the first session is booked and the programme is under way."
Usage: #example
* basedOn = Reference(ExerciseReferral)
* basedOn.identifier.type = $v2-0203#PLAC
* basedOn.identifier.system = "https://fhir.example-practice.nhs.uk/Id/referral"
* basedOn.identifier.value = "REF-2026-000789"
* basedOn.identifier.assigner.identifier.system = $ods-code
* basedOn.identifier.assigner.identifier.value = "P89020"
* focus = Reference(ExerciseReferral)
* for = Reference(Patient-Tameside)
* status = #in-progress
* businessStatus = ReferralWorkflowStatus#accepted
* intent = #order
* code = http://hl7.org/fhir/CodeSystem/task-code#fulfill
* authoredOn = "2026-10-20T10:00:00+01:00"
* lastModified = "2026-10-23T10:00:00+01:00"
* requester = Reference(GPAllenRole)
* owner = Reference(ExerciseReferralService)
* input.type = ReferralTaskParameter#questionnaire
* input.valueCanonical = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/ExercisePreParticipationForm"
* output[+].type = ReferralTaskParameter#questionnaire-response
* output[=].valueReference = Reference(ExercisePreParticipationResponse)
* output[+].type = ReferralTaskParameter#observation
* output[=].valueReference = Reference(ExerciseVitalSignBaseline)
