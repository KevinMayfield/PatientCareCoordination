// Care Assessment questionnaire. Built from the PRSB "Hospital referral for assessment
// for community care and support" standard v1.1 (Excel, checked 2026-11-02) - sections
// About me, Individual requirements, Care needs summary, Assessed level of care, Primary
// support reason, Risks and Person and carer concerns, expectations and wishes. Social
// context is a separate questionnaire (SocialContext.fsh). Who completed the assessment,
// when and where (PRSB "Person completing record", "Performing professional",
// "Location") are QuestionnaireResponse.author / authored / extensions, not items.

Alias: $sct = http://snomed.info/sct

Instance: CareAssessment
InstanceOf: Questionnaire
Title: "Questionnaire - Care Assessment"
Description: """
A **care assessment** - the person's needs, risks and what matters to them - completed
before a care and support plan is agreed. In the NHS this form is often called a
"care plan"; it is not one. The completed form (`QuestionnaireResponse`) is the input to
a [Care Plan](StructureDefinition-PatientCarePlan.html), which records who does what.
See [Templates and Forms](Templates.html#care-assessment-and-care-plan).

Based on the PRSB [Hospital Referral for Assessment for Community Care and Support](https://theprsb.org/standards/hospitalrefferalforassessmenforcommunitycare)
standard v1.1. Social context is captured with the
[Social Context](Questionnaire-SocialContext.html) questionnaire.
"""
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/CareAssessment"
* name = "CareAssessment"
* title = "Care Assessment"
* status = #draft
* experimental = true
* subjectType = #Patient

* item[+]
  * linkId = "ABOUT-ME"
  * text = "About me - what the person wants professionals to know (PRSB About Me)"
  * type = #group
  * item[+]
    * linkId = "ABOUT-ME/important"
    * text = "What is most important to me"
    * type = #text
  * item[+]
    * linkId = "ABOUT-ME/people"
    * text = "People who are important to me"
    * type = #text
  * item[+]
    * linkId = "ABOUT-ME/communication"
    * text = "How I communicate and how to communicate with me"
    * type = #text
  * item[+]
    * linkId = "ABOUT-ME/do-dont"
    * text = "Please do and please don't"
    * type = #text
  * item[+]
    * linkId = "ABOUT-ME/support"
    * text = "How and when to support me"
    * type = #text

* item[+]
  * linkId = "INDIVIDUAL-REQUIREMENTS"
  * text = "Individual requirements"
  * type = #group
  * item[+]
    * linkId = "INDIVIDUAL-REQUIREMENTS/reasonable-adjustment"
    * text = "Reasonable adjustments required (Equality Act 2010), e.g. specific contact method, communication professional"
    * type = #string
    * repeats = true
  * item[+]
    * linkId = "INDIVIDUAL-REQUIREMENTS/impairment"
    * text = "Impairments relating to reasonable adjustments"
    * type = #string
    * repeats = true
  * item[+]
    * linkId = "INDIVIDUAL-REQUIREMENTS/mobility"
    * text = "Mobility needs"
    * type = #text
  * item[+]
    * linkId = "INDIVIDUAL-REQUIREMENTS/other"
    * text = "Other individual requirements"
    * type = #text

* item[+]
  * linkId = "CARE-NEEDS"
  * text = "Care needs summary - nursing and care needs, e.g. continence, catheter or stoma care, skin care (wounds, ulcers), tracheostomy, nutrition and fluids, behavioural care and support"
  * type = #text
  * required = true

* item[+]
  * linkId = "LEVEL-OF-CARE"
  * text = "Level of enhanced care observation needed during the admission and before discharge"
  * type = #choice
  * answerOption[+].valueString = "A - General: usual inpatient observation"
  * answerOption[+].valueString = "B - Intermittent observation (every 30 to 60 minutes)"
  * answerOption[+].valueString = "C - Continuous observation within eyesight (e.g. cohort bay)"
  * answerOption[+].valueString = "D - High level multi-professional continuous observation"

* item[+]
  * linkId = "PRIMARY-SUPPORT-REASON"
  * text = "Primary support reason for social care"
  * type = #group
  * item[+]
    * linkId = "PRIMARY-SUPPORT-REASON/reason"
    * text = "Primary support reason (as used for social care national reporting)"
    * type = #string
  * item[+]
    * linkId = "PRIMARY-SUPPORT-REASON/active"
    * text = "Currently active"
    * type = #boolean

* item[+]
  * linkId = "RISKS"
  * text = "Risks"
  * type = #group
  * item[+]
    * linkId = "RISKS/self"
    * text = "Risk to self (e.g. self-harm, self-neglect)"
    * type = #text
  * item[+]
    * linkId = "RISKS/others"
    * text = "Risk to others"
    * type = #text
  * item[+]
    * linkId = "RISKS/from-others"
    * text = "Risk from others"
    * type = #text
  * item[+]
    * linkId = "RISKS/accidents"
    * text = "Risk of accidents (e.g. falls)"
    * type = #text
  * item[+]
    * linkId = "RISKS/infection"
    * text = "Infection risk needing special handling"
    * type = #text
  * item[+]
    * linkId = "RISKS/other"
    * text = "Other risks"
    * type = #text

* item[+]
  * linkId = "CONCERNS"
  * text = "Person and carer concerns, expectations and wishes"
  * type = #text

// Example: the completed assessment, and the care plan formed from it

Instance: CareAssessmentResponse
InstanceOf: QuestionnaireResponse
Title: "Care Assessment - completed before virtual ward discharge"
Description: "Care assessment completed for Sansa MANCHESTER before discharge from the respiratory virtual ward. It is the input to the community support care plan."
Usage: #example
* questionnaire = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/Questionnaire/CareAssessment"
* status = #completed
* subject = Reference(Patient-Manchester)
* authored = "2026-10-12T15:00:00+01:00"
* author = Reference(R0A)
* item[+].linkId = "ABOUT-ME"
* item[=].item[+].linkId = "ABOUT-ME/important"
* item[=].item[=].answer.valueString = "Staying in my own flat and getting to the shops on my own again."
* item[=].item[+].linkId = "ABOUT-ME/support"
* item[=].item[=].answer.valueString = "Mornings are hardest when I am breathless - help with washing and dressing."
* item[+].linkId = "INDIVIDUAL-REQUIREMENTS"
* item[=].item[+].linkId = "INDIVIDUAL-REQUIREMENTS/mobility"
* item[=].item[=].answer.valueString = "Walks with a stick; short of breath on stairs."
* item[+].linkId = "CARE-NEEDS"
* item[=].answer.valueString = "Help with personal care each morning while recovering. Inhaler technique review. Pulmonary rehabilitation."
* item[+].linkId = "RISKS"
* item[=].item[+].linkId = "RISKS/accidents"
* item[=].item[=].answer.valueString = "Falls risk when breathless on the stairs."
* item[+].linkId = "CONCERNS"
* item[=].answer.valueString = "Worried about managing alone at night."

Instance: CommunitySupportPlan
InstanceOf: PatientCarePlan
Title: "Care Plan - community care and support (from the care assessment)"
Description: "The care and support plan agreed after the care assessment: who does what. The assessment is supporting information; each activity is carried out by a referral or a visit."
Usage: #example
* status = #active
* intent = #plan
* category.text = "Community care and support plan"
* title = "Care and support after the virtual ward"
* subject = Reference(Patient-Manchester)
* period.start = "2026-10-13"
* author = Reference(R0A)
* addresses = Reference(ConditionCOPDExacerbation)
* supportingInfo = Reference(CareAssessmentResponse)
* activity[+].detail.status = #scheduled
* activity[=].detail.description = "Home care: help with washing and dressing each morning for 2 weeks (local authority reablement)."
* activity[+].detail.status = #not-started
* activity[=].detail.description = "Referral to pulmonary rehabilitation."
* activity[+].detail.status = #scheduled
* activity[=].detail.description = "GP review in 2 weeks, including inhaler technique."
