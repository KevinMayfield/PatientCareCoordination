<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Location](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Location), [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site).

Differences:

- Partial: CDM Location is id, name and site only - no type, physical type or managing organisation; Site has `siteType` and `siteOdsCode`.
- A patient's home (virtual ward) is not a CDM Location; Virtual Ward Stay has `activityLocationTypeCode`.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
