<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site).

Differences:

- **No CDM Organisation object.** Organisations are ODS code strings on each object (`referringOrganisationOdsCode`, `providerOrganisationOdsCode`, `trustOdsCode`); Site has `siteOdsCode`.
- No organisation hierarchy (`partOf`) other than the ICB / sub-ICB on GP Practice Registration.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
