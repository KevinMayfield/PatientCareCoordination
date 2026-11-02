    Alias: $sct = http://snomed.info/sct
Alias: $loinc = http://loinc.org

// Referral workflow status - the 360X state transitions (PCC TF-1 X.4.1)

CodeSystem: ReferralWorkflowStatus
Id: referral-workflow-status
Title: "Referral Workflow Status"
Description: """
Business status of a referral, from the IHE 360X state transitions (PCC TF-1 X.4.1).
Carried in `Task.businessStatus`; the matching `Task.status` and HL7 v2 ORC-1 / ORC-5
values are on the [Overview Model](DataModel.html#referral-status) page.
`information-requested` is not in 360X - it covers the eRS "return to referrer" step.
"""
* ^experimental = true
* ^caseSensitive = true
* #requested "Referral requested" "The Referral Initiator has sent the referral request [PCC-55]."
* #information-requested "More information requested" "The Referral Recipient has asked for more information or a completed form (Task.input) before deciding or starting (eRS return to referrer, HL7 Physical Activity IG; not in 360X)."
* #accepted "Referral accepted" "The Referral Recipient has accepted the referral [PCC-55] (ORC-1 OK, ORC-5 IP)."
* #declined "Referral declined" "The Referral Recipient has declined the referral, initially [PCC-55] or after acceptance [PCC-56] (ORC-1 UA, ORC-5 CA)."
* #appointment-booked "Appointment booked" "An appointment has been booked [PCC-60] (SIU^S12)."
* #appointment-rescheduled "Appointment rescheduled" "An appointment has been rescheduled [PCC-60] (SIU^S13)."
* #appointment-cancelled "Appointment cancelled" "An appointment has been cancelled [PCC-60] (SIU^S15)."
* #no-show "Patient did not attend" "The patient did not attend an appointment [PCC-61] (SIU^S26)."
* #interim-report "Interim consultation note sent" "The Referral Recipient has sent an interim consultation note [PCC-59] (ORC-1 SC, ORC-5 A)."
* #cancel-requested "Cancellation requested" "The Referral Initiator has asked for the referral to be cancelled [PCC-58] (ORC-1 CA, ORC-5 CA)."
* #cancelled "Referral cancelled" "The Referral Recipient has confirmed the cancellation [PCC-58] (ORC-1 CR, ORC-5 CA). Ends the referral."
* #completed "Referral completed" "The Referral Recipient has sent the referral outcome [PCC-57] (ORC-1 SC, ORC-5 CM). Ends the referral."

ValueSet: ReferralWorkflowStatusVS
Id: referral-workflow-status-vs
Title: "Referral Workflow Status Value Set"
Description: "Business status of a referral, from the IHE 360X state transitions."
* ^experimental = true
* include codes from system ReferralWorkflowStatus

// Reason a referral is declined or cancelled (ORC-16)

CodeSystem: ReferralStatusReason
Id: referral-status-reason
Title: "Referral Status Reason"
Description: """
**Example only.** Reasons a referral is declined [PCC-55, PCC-56] or cancelled [PCC-58]
(HL7 v2 ORC-16). 360X only requires free text (ORC-16.2). NHS England eRS and BaRS
have their own reject / return reasons - **To confirm** whether one of those should
replace this list.
"""
* ^experimental = true
* ^caseSensitive = true
* #service-not-provided "Service not provided" "The requested service is not provided by the Referral Recipient."
* #not-eligible "Patient not eligible" "The patient does not meet the service's referral criteria."
* #insufficient-information "Insufficient information" "The referral does not contain enough information to triage."
* #no-capacity "No capacity" "The service cannot see the patient within the required time."
* #patient-declined "Patient declined" "The patient has declined the referral or the care offered."
* #no-show "Patient did not attend" "The patient did not attend, and the service has discharged them back to the referrer."
* #no-longer-required "No longer required" "The referral is no longer needed (cancellation)."
* #duplicate "Duplicate referral" "The referral duplicates another referral."
* #other "Other" "Another reason, given as text."

ValueSet: ReferralStatusReasonVS
Id: referral-status-reason-vs
Title: "Referral Status Reason Value Set"
Description: "**Example only.** Reasons a referral is declined or cancelled."
* ^experimental = true
* include codes from system ReferralStatusReason

// Category of referral

ValueSet: ReferralCategory
Id: referral-category
Title: "Referral Category"
Description: "`ServiceRequest.category` for a referral, including referrals to a virtual ward (hospital at home). SNOMED CT UK Edition."
* ^experimental = true
* $sct#3457005 "Patient referral"
* $sct#729021000000108 "Referral to virtual ward"
* $sct#112951000000109 "Referral to intermediate care - hospital at home"

// Service referred to

ValueSet: ReferralServiceType
Id: referral-service-type
Title: "Referral Service Type"
Description: "`ServiceRequest.code` - the service the patient is referred to. Any SNOMED CT referral procedure (descendants of 3457005 |Patient referral|)."
* ^experimental = true
* include codes from system $sct where concept is-a #3457005

// Type of referral document

ValueSet: ReferralDocumentType
Id: referral-document-type
Title: "Referral Document Type"
Description: """
Types of document exchanged in a closed loop referral: the referral letter [PCC-55],
consultation note [PCC-59] and outcome / discharge report [PCC-57]. LOINC codes are those
used by 360X and HL7 Europe; SNOMED CT codes are the NHS England record types used by
Transfer of Care and NRL.
"""
* ^experimental = true
* $loinc#57133-1 "Referral Note"
* $loinc#11488-4 "Consult Note"
* $loinc#34105-7 "Hospital Discharge Summary"
* $loinc#18776-5 "Plan of Care Note"
* $sct#25611000000107 "Referral letter"
* $sct#823681000000100 "Outpatient letter"
* $sct#823701000000103 "Discharge letter"
* $sct#371530004 "Clinical consultation report"
* $sct#960751000000107 "Remote health monitoring care plan"

// Virtual ward admission source

CodeSystem: VirtualWardAdmissionRoute
Id: virtual-ward-admission-route
Title: "Virtual Ward Admission Route"
Description: """
How a patient is admitted to a virtual ward, as described by NHS England: **step-up**
(instead of admission, from the community, GP, urgent care or ambulance) or
**step-down** (early supported discharge from an acute ward). **To confirm** whether
an NHS Data Dictionary or SNOMED CT code set exists for this.
"""
* ^experimental = true
* ^caseSensitive = true
* #step-up "Step-up" "Admitted to the virtual ward instead of an acute hospital admission (from home, GP, community, urgent care or ambulance service)."
* #step-down "Step-down" "Admitted to the virtual ward on early discharge from an acute hospital ward."

ValueSet: VirtualWardAdmissionRouteVS
Id: virtual-ward-admission-route-vs
Title: "Virtual Ward Admission Route Value Set"
Description: "Step-up or step-down admission to a virtual ward."
* ^experimental = true
* include codes from system VirtualWardAdmissionRoute

// Task.input / Task.output types

CodeSystem: ReferralTaskParameter
Id: referral-task-parameter
Title: "Referral Task Parameter"
Description: """
Types of `Task.input` and `Task.output` on a [Referral Task](StructureDefinition-ReferralTask.html).
**To confirm** alignment with the HL7 SDC form-request pattern and the HL7 Physical Activity IG.
"""
* ^experimental = true
* ^caseSensitive = true
* #questionnaire "Form to complete" "A Questionnaire the Referral Recipient asks the patient or referrer to complete."
* #questionnaire-response "Completed form" "The completed QuestionnaireResponse."
* #appointment "Appointment" "An appointment booked to carry out the referral."
* #observation "Progress observation" "An observation recorded while carrying out the referral, e.g. physical activity or vital signs."
* #interim-report "Interim consultation note" "A document sent before the end of care [PCC-59]."
* #outcome-report "Referral outcome" "The document that closes the referral [PCC-57]."
* #encounter "Encounter" "The stay or encounter carrying out the referral (e.g. a virtual ward stay)."

ValueSet: ReferralTaskParameterVS
Id: referral-task-parameter-vs
Title: "Referral Task Parameter Value Set"
Description: "Types of Task.input and Task.output on a Referral Task."
* ^experimental = true
* include codes from system ReferralTaskParameter
