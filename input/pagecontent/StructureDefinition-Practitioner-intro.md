<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### Master Record

There is no single national FHIR directory of practitioners.

| Element | Master record | NHS England API |
|---|---|---|
| Professional registration (GMC, NMC, HCPC) | The professional regulator | None national in FHIR (the Healthcare Worker API cannot search by GMC) |
| NHS user (Care ID / smartcard), SDS user ID | Spine Directory Service (SDS) | [Healthcare Worker FHIR API](https://digital.nhs.uk/developer/api-catalogue/healthcare-worker-fhir) `GET /Practitioner?identifier=https://fhir.nhs.uk/Id/sds-user-id|...` (beta) |
| GP practitioner code (GMP) | NHS England (ODS / prescriber data) | **To confirm** |
{:.grid}

See [Care Services Directory (mCSD)](mCSD.html#spine-directory-service-sds).

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CareProfessional).

Differences:

- Good fit: professional registration body and entry ID (e.g. GMC) match the practitioner identifier.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
