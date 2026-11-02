<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Admission](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Admission), [Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/WardStay), [Consultant Episode](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ConsultantEpisode), [Virtual Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/VirtualWardStay).

Differences:

- Good fit: CDM Admission is the Hospital Provider Spell, with admission source and method, discharge method and destination, and ward stays.
- Account / Spell Number (AN): CDM `admissionId` / `admissionExternalId` - **To confirm** which is the spell number.
- Discharge destination and method are separate in the CDM (`destinationOfDischargeCode`, `methodOfDischargeCode`), as in this profile (`dischargeDisposition`, [Discharge Method](StructureDefinition-DischargeMethod.html)).
- Virtual ward stays are a separate CDM object with no link to the referral (`basedOn`).

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
