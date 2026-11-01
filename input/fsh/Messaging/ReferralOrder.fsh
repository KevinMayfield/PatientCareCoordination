// FHIR Messaging for the IHE 360X HL7 v2 referral order (OMG^O19) and order status
// updates (OSU^O51) - the main HL7 v2 route in this guide. See Referral Request [PCC-55]
// and the status pages PCC-56 to PCC-59.

Alias: $v2-0003 = http://terminology.hl7.org/CodeSystem/v2-0003
Alias: $ods-code = https://fhir.nhs.uk/Id/ods-organization-code

// Message definitions

Instance: referral-order
InstanceOf: MessageDefinition
Title: "Message Definition - Referral Order (O19)"
Description: "FHIR Message equivalent of the IHE 360X HL7 v2.5.1 `OMG^O19^OMG_O19` referral order - Referral Request [PCC-55]. The focus is the Referral Request."
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order"
* name = "ReferralOrder"
* title = "Referral Order (O19)"
* status = #draft
* experimental = true
* date = "2026-11-01"
* eventCoding = $v2-0003#O19
* category = #consequence
* description = """
FHIR Message equivalent of the IHE 360X HL7 v2.5.1 `OMG^O19^OMG_O19` referral order
(ORC-1 `NW`), used for [Referral Request [PCC-55]](PCC-55.html). The Referral Recipient
replies with a [Referral Order Status (O51)](MessageDefinition-referral-order-status.html)
message (accept or decline).
"""
* focus[+]
  * code = #ServiceRequest
  * profile = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/ReferralRequest"
  * min = 1
  * max = "1"
* responseRequired = #always
* allowedResponse[+]
  * message = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order-status"
  * situation = "Accept (ORC-1 OK, ORC-5 IP) or decline (ORC-1 UA, ORC-5 CA) [PCC-55]."

Instance: referral-order-status
InstanceOf: MessageDefinition
Title: "Message Definition - Referral Order Status (O51)"
Description: "FHIR Message equivalent of the IHE 360X HL7 v2.5.1 `OSU^O51^OSU_O51` order status update - accept, decline, interim note, outcome, cancel request and cancel confirmation [PCC-55] to [PCC-59]. The focus is the Referral Task."
Usage: #definition
* url = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order-status"
* name = "ReferralOrderStatus"
* title = "Referral Order Status (O51)"
* status = #draft
* experimental = true
* date = "2026-11-01"
* eventCoding = $v2-0003#O51
* category = #notification
* description = """
FHIR Message equivalent of the IHE 360X HL7 v2.5.1 `OSU^O51^OSU_O51` order status update.
The [Referral Task](StructureDefinition-ReferralTask.html) carries the status
(`status`, `businessStatus`, `statusReason`); for an interim note [PCC-59] or outcome
[PCC-57] the message also carries the clinical document referenced from `Task.output`.

| 360X | ORC-1 / ORC-5 | Task.businessStatus |
|---|---|---|
| Accept [PCC-55] | OK / IP | accepted |
| Decline [PCC-55, PCC-56] | UA / CA | declined |
| Interim Consultation Note [PCC-59] | SC / A | interim-report |
| Referral Outcome [PCC-57] | SC / CM | completed |
| Cancel Request [PCC-58] | CA / CA | cancel-requested |
| Cancel Confirmation [PCC-58] | CR / CA | cancelled |
"""
* focus[+]
  * code = #Task
  * profile = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/StructureDefinition/ReferralTask"
  * min = 1
  * max = "1"
* responseRequired = #never

// Example: the referral order

Instance: ReferralOrderMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Referral Order (O19), GP to cardiology"
Description: "FHIR Message equivalent of the example HL7 v2 OMG^O19 on Referral Request [PCC-55]: Dr Allen at HT PRACTICE refers Hodor TAMESIDE to cardiology."
Usage: #example
* identifier.system = "https://fhir.example-practice.nhs.uk/Id/message"
* identifier.value = "MSG000124"
* type = #message
* timestamp = "2026-09-04T10:15:00+01:00"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/ReferralOrderMessageHeader"
* entry[message].resource = ReferralOrderMessageHeader
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

Instance: ReferralOrderMessageHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "ReferralOrderMessageHeader"
* meta.lastUpdated = "2026-09-04T10:15:00+01:00"
* eventCoding = $v2-0003#O19
* destination.endpoint = "https://fhir.mft.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "R0A"
* sender.identifier.system = $ods-code
* sender.identifier.value = "P89020"
* source.endpoint = "https://fhir.example-practice.nhs.uk/R4"
* focus = Reference(ServiceRequest/CardiologyReferral)
* definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order"

// Example: accept

Instance: ReferralOrderStatusAcceptMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Referral Order Status (O51), accepted"
Description: "FHIR Message equivalent of the example HL7 v2 OSU^O51 accept (ORC-1 OK, ORC-5 IP) on Referral Request [PCC-55]."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/message"
* identifier.value = "MFT-MSG-778900"
* type = #message
* timestamp = "2026-09-05T09:30:00+01:00"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/ReferralOrderStatusAcceptHeader"
* entry[message].resource = ReferralOrderStatusAcceptHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/Task/CardiologyReferralAccepted"
* entry[1].resource = CardiologyReferralAccepted

Instance: ReferralOrderStatusAcceptHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "ReferralOrderStatusAcceptHeader"
* meta.lastUpdated = "2026-09-05T09:30:00+01:00"
* eventCoding = $v2-0003#O51
* destination.endpoint = "https://fhir.example-practice.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "P89020"
* sender.identifier.system = $ods-code
* sender.identifier.value = "R0A"
* source.endpoint = "https://fhir.mft.nhs.uk/R4"
* focus = Reference(Task/CardiologyReferralAccepted)
* definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order-status"

// Example: outcome

Instance: ReferralOrderStatusOutcomeMessage
InstanceOf: BundleMessage
Title: "Bundle Message - Referral Order Status (O51), referral outcome"
Description: "FHIR Message equivalent of the example HL7 v2 OSU^O51 outcome (ORC-1 SC, ORC-5 CM) and MDM^T02 on Referral Outcome [PCC-57]: the completed Task and the outcome consultation note."
Usage: #example
* identifier.system = "https://fhir.mft.nhs.uk/Id/message"
* identifier.value = "MFT-MSG-779950"
* type = #message
* timestamp = "2026-09-24T11:00:00+01:00"
* entry[message].fullUrl = "https://fhir.example.nhs.uk/R4/MessageHeader/ReferralOrderStatusOutcomeHeader"
* entry[message].resource = ReferralOrderStatusOutcomeHeader
* entry[1].fullUrl = "https://fhir.example.nhs.uk/R4/Task/CardiologyReferralCompleted"
* entry[1].resource = CardiologyReferralCompleted
* entry[2].fullUrl = "https://fhir.example.nhs.uk/R4/Composition/CardiologyOutcomeNote"
* entry[2].resource = CardiologyOutcomeNote

Instance: ReferralOrderStatusOutcomeHeader
InstanceOf: MessageHeader
Usage: #inline
* id = "ReferralOrderStatusOutcomeHeader"
* meta.lastUpdated = "2026-09-24T11:00:00+01:00"
* eventCoding = $v2-0003#O51
* destination.endpoint = "https://fhir.example-practice.nhs.uk/R4/$process-message"
* destination.receiver.identifier.system = $ods-code
* destination.receiver.identifier.value = "P89020"
* sender.identifier.system = $ods-code
* sender.identifier.value = "R0A"
* source.endpoint = "https://fhir.mft.nhs.uk/R4"
* focus = Reference(Task/CardiologyReferralCompleted)
* definition = "https://fhir.nwgenomics.nhs.uk/PatientCareCoordination/MessageDefinition/referral-order-status"
