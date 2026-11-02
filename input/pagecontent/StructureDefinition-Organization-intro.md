<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### Master Record

Organisations are a **central record**: the Organisation Data Service (ODS), queried as
an mCSD Directory - see [Care Services Directory (mCSD)](mCSD.html#organisation-data-service-ods)
and [Find Matching Care Services [ITI-90]](ITI-90.html).

| Element | Master record | NHS England API |
|---|---|---|
| `identifier[odsOrganisationCode]`, `name`, `address`, `active`, `type` (ODS role) | ODS | [Organisation Data Terminology FHIR API](https://digital.nhs.uk/developer/api-catalogue/organisation-data-terminology) `GET /Organization?identifier=`; [ORD API](https://digital.nhs.uk/developer/api-catalogue/organisation-data-service-ord) |
| `partOf`, affiliations (e.g. practice to ICB) | ODS relationships | Organisation Data Terminology `GET /OrganizationAffiliation` |
| Endpoints (where to send messages) | Per transport: DoS, SDS (Spine), MESH, BaRS Endpoint Catalogue | See [mCSD - NHS England Services](mCSD.html#nhs-england-services) |
{:.grid}

Reference organisations by ODS code; a full `Organization` is only needed when it adds
something the receiver cannot look up.

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Site](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Site).

Differences:

- **No CDM Organisation object.** Organisations are ODS code strings on each object (`referringOrganisationOdsCode`, `providerOrganisationOdsCode`, `trustOdsCode`); Site has `siteOdsCode`.
- No organisation hierarchy (`partOf`) other than the ICB / sub-ICB on GP Practice Registration.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
