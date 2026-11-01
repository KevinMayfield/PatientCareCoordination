// FHIR Messaging for the HL7 v2 patient referral (REF_I12) and its response (RRI_I12).
//
// DUPLICATION: MessageHeader and BundleMessage are copied from the NW GMSA FHIR IG
// (https://nw-gmsa.github.io/en/, source ../FHIRGenomics/input/fsh/MessageHeader.fsh and
// BundleMessage.fsh, 2026-11-01). Changes from the source: the v2-0003 binding is not
// pinned to version 3.0.0, and the Bundle identifier short text is generalised. Keep in
// step with the source - see notes/research.md.

Alias: $v2-0003 = http://terminology.hl7.org/CodeSystem/v2-0003
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code

Profile:        MessageHeader
Parent:         http://hl7.org/fhir/StructureDefinition/MessageHeader
Id:             MessageHeader
Title:          "Document Message (MessageHeader)"
Description:    "`Messaging` [Document Message](https://www.enterpriseintegrationpatterns.com/patterns/messaging/DocumentMessage.html). The event is the HL7 v2 trigger event. Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* meta.lastUpdated 1..1 MS
* eventCoding 1..1 MS
* eventCoding from http://terminology.hl7.org/ValueSet/v2-0003 (extensible)
* destination.receiver.identifier 1..1 MS
* destination.receiver.identifier only OrganisationCode
* sender.identifier 1..1 MS
* sender.identifier only OrganisationCode
* response 0..1 MS
* response ^short = "Mandatory for responses and acknowledgements."
* response.identifier 1..1 MS
* response.code 1..1 MS

Profile:        BundleMessage
Parent:         Bundle
Id:             BundleMessage
Title:          "Bundle - FHIR Messaging"
Description:    "[FHIR Messaging](https://hl7.org/fhir/R4/messaging.html). Copied from the [NW GMSA FHIR IG](https://nw-gmsa.github.io/en/)."

* identifier 1..
* identifier ^short = "Business identifier for this message"
* type = #message
* timestamp 1..
* entry ^slicing.discriminator[0].type = #type
* entry ^slicing.discriminator[0].path = "resource"
* entry ^slicing.ordered = false
* entry ^slicing.rules = #open
* entry contains message 1..1
* entry[message].resource only MessageHeader

// Message definitions

Instance: patient-referral
InstanceOf: MessageDefinition
Title: "Message Definition - Patient Referral (I12)"
Description: "FHIR Message equivalent of HL7 v2.5.1 `REF_I12` Patient Referral. The focus is the Referral Request; the message carries the patient, referrer, referred-to service and supporting information."
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/Referral360/MessageDefinition/patient-referral"
* name = "PatientReferral"
* title = "Patient Referral (I12)"
* status = #draft
* experimental = true
* date = "2026-11-01"
* eventCoding = $v2-0003#I12 "REF/RRI - Patient referral"
* category = #consequence
* description = """
FHIR Message equivalent of HL7 v2.5.1 [REF_I12 - Patient referral](https://hl7-definition.caristix.com/v2/HL7v2.5.1/TriggerEvents/REF_I12),
used for [Referral Request [PCC-55]](PCC-55.html). See [Patient Referral [I12]](I12.html).
"""
* focus[+]
  * code = #ServiceRequest
  * profile = "https://fhir.nwgenomics.nhs.uk/Referral360/StructureDefinition/ReferralRequest"
  * min = 1
  * max = "1"
* responseRequired = #always
* allowedResponse[+]
  * message = "https://fhir.nwgenomics.nhs.uk/Referral360/MessageDefinition/patient-referral-response"
  * situation = "The Referral Recipient accepts or declines the referral (RRI_I12)."

Instance: patient-referral-response
InstanceOf: MessageDefinition
Title: "Message Definition - Patient Referral Response (RRI I12)"
Description: "FHIR Message equivalent of HL7 v2.5.1 `RRI_I12` Return Patient Referral - the Referral Recipient's accept or decline. The focus is the Referral Task."
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/Referral360/MessageDefinition/patient-referral-response"
* name = "PatientReferralResponse"
* title = "Patient Referral Response (RRI I12)"
* status = #draft
* experimental = true
* date = "2026-11-01"
* eventCoding = $v2-0003#I12 "REF/RRI - Patient referral"
* category = #consequence
* description = """
FHIR Message equivalent of HL7 v2.5.1 [RRI_I12 - Return patient referral](https://hl7-definition.caristix.com/v2/HL7v2.5.1/TriggerEvents/RRI_I12),
used for the accept or decline in [Referral Request [PCC-55]](PCC-55.html). `MessageHeader.response`
identifies the referral message being answered. See [Patient Referral [I12]](I12.html).
"""
* focus[+]
  * code = #Task
  * profile = "https://fhir.nwgenomics.nhs.uk/Referral360/StructureDefinition/ReferralTask"
  * min = 1
  * max = "1"
* responseRequired = #never

// Example: the GP to cardiology referral as a FHIR Message

Instance: PatientReferralMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Patient Referral (I12), GP to cardiology"
Description: "FHIR Message equivalent of the example HL7 v2 REF_I12 on the Patient Referral [I12] page: Dr Allen at HT PRACTICE refers Hodor TAMESIDE to cardiology."
Usage: #example
* identifier.system = "https://fhir.example-practice.nhs.uk/Id/message"
* identifier.value = "MSG000123"
* type = #message
* timestamp = "2026-09-04T10:15:00+01:00"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/PatientReferralMessageHeader"
* entry[message].resource = PatientReferralMessageHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/ServiceRequest/CardiologyReferral"
* entry[1].resource = CardiologyReferral
* entry[2].fullUrl = "https://fhir.example.nhs.uk/R4/Patient/Patient-Tameside"
* entry[2].resource = Patient-Tameside
* entry[3].fullUrl = "https://fhir.example.nhs.uk/R4/PractitionerRole/GPAllenRole"
* entry[3].resource = GPAllenRole
* entry[4].fullUrl = "https://fhir.example.nhs.uk/R4/Practitioner/GPAllen"
* entry[4].resource = GPAllen
* entry[5].fullUrl = "https://fhir.example.nhs.uk/R4/Organization/P89020"
* entry[5].resource = P89020
* entry[6].fullUrl = "https://fhir.example.nhs.uk/R4/HealthcareService/CardiologyService"
* entry[6].resource = CardiologyService
* entry[7].fullUrl = "https://fhir.example.nhs.uk/R4/Condition/ConditionDyspnoea"
* entry[7].resource = ConditionDyspnoea

Instance: PatientReferralMessageHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "PatientReferralMessageHeader"
* meta.lastUpdated = "2026-09-04T10:15:00+01:00"
* eventCoding = $v2-0003#I12 "REF/RRI - Patient referral"
* destination.endpoint = "https://fhir.mft.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "R0A"
* sender.identifier.system = $ods-code
* sender.identifier.value = "P89020"
* source.endpoint = "https://fhir.example-practice.nhs.uk/R4"
* focus = Reference(ServiceRequest/CardiologyReferral)
* definition = "https://fhir.nwgenomics.nhs.uk/Referral360/MessageDefinition/patient-referral"

// Example: the acceptance as a FHIR Message

Instance: PatientReferralResponseMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Patient Referral Response (RRI I12), accepted"
Description: "FHIR Message equivalent of the example HL7 v2 RRI_I12: cardiology accepts the referral. MessageHeader.response.identifier is the MessageHeader.id of the referral message."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/message"
* identifier.value = "MFT-MSG-778899"
* type = #message
* timestamp = "2026-09-05T09:30:00+01:00"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/PatientReferralResponseMessageHeader"
* entry[message].resource = PatientReferralResponseMessageHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/Task/CardiologyReferralAccepted"
* entry[1].resource = CardiologyReferralAccepted

Instance: PatientReferralResponseMessageHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "PatientReferralResponseMessageHeader"
* meta.lastUpdated = "2026-09-05T09:30:00+01:00"
* eventCoding = $v2-0003#I12 "REF/RRI - Patient referral"
* destination.endpoint = "https://fhir.example-practice.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "P89020"
* sender.identifier.system = $ods-code
* sender.identifier.value = "R0A"
* source.endpoint = "https://fhir.mft.nhs.uk/R4"
* response.identifier = "PatientReferralMessageHeader"
* response.code = #ok
* focus = Reference(Task/CardiologyReferralAccepted)
* definition = "https://fhir.nwgenomics.nhs.uk/Referral360/MessageDefinition/patient-referral-response"
