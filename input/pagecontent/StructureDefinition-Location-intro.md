<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### Master Record

Sites are a **central record** in the Organisation Data Service (ODS site codes); wards,
clinics and rooms are local (trust PAS). See
[Care Services Directory (mCSD)](mCSD.html#organisation-data-service-ods).

| Element | Master record | NHS England API |
|---|---|---|
| `identifier[odsSiteCode]`, `name`, `address`, `managingOrganization` (sites) | ODS | [Organisation Data Terminology FHIR API](https://digital.nhs.uk/developer/api-catalogue/organisation-data-terminology) |
| Wards, clinics (`partOf` a site) | Trust PAS | Local mCSD Directory or HL7 v2 `MFN^M05` |
| Service locations (where a service is delivered) | Directory of Services | [DoS Search API](https://digital.nhs.uk/developer/api-catalogue/directory-of-services-search-api) (`Location` with `HealthcareService`) |
{:.grid}

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Location](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Location), [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site).

Differences:

- Partial: CDM Location is id, name and site only - no type, physical type or managing organisation; Site has `siteType` and `siteOdsCode`.
- A patient's home (virtual ward) is not a CDM Location; Virtual Ward Stay has `activityLocationTypeCode`.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
