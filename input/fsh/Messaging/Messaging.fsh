// FHIR Messaging profiles (MessageHeader, BundleMessage).
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
