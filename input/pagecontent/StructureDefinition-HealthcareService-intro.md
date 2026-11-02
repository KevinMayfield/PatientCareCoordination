<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

The service a patient is referred to - the Referral Recipient in
`ServiceRequest.performer` and `Task.owner`. Follows the
[IHE mCSD](https://profiles.ihe.net/ITI/mCSD/) HealthcareService; found with
[Find Matching Care Services [ITI-90]](ITI-90.html).

### Master Record

Services are a **central record** held in a directory. In England there are several,
each for a part of the NHS - see [Care Services Directory (mCSD)](mCSD.html#nhs-england-services).

| Element | Master record | NHS England API |
|---|---|---|
| `identifier`, `name`, `type`, `specialty`, `location`, `telecom`, `referralMethod`, `endpoint` | Directory of Services (DoS) | [DoS Search API](https://digital.nhs.uk/developer/api-catalogue/directory-of-services-search-api) (FHIR R4) `GET /HealthcareService` - published, not yet available; UEC DoS SOAP / REST APIs (**UEC / NHS 111**) |
| eRS service ID and service details | eRS service catalogue | [eRS FHIR API](https://digital.nhs.uk/developer/api-catalogue/e-referral-service-fhir) A033 / A035 `GET /R4/HealthcareService`, A010 service search (**eRS only**); identifier system `http://fhir.nhs.net/Id/ers-service` in the API examples |
| `providedBy` (ODS code) | ODS | See [Organization](StructureDefinition-Organization.html) |
| `endpoint` | DoS `Endpoint`; BaRS Endpoint Catalogue (**BaRS only**) | DoS Search API `_include` / `_revinclude` Endpoint |
| Data Source (providers maintaining their services) | DoS | [DoS Ingest API](https://digital.nhs.uk/developer/api-catalogue/directory-of-services-ingest-api) - mCSD Care Services Feed [ITI-130] |
{:.grid}

The DoS Search API's `HealthcareService` uses NHS England code systems for `type`,
`category` and `characteristic` (e.g. `https://fhir.nhs.uk/England/CodeSystem/England-HealthcareServiceType`)
and identifies services by resource id; eRS uses its own. This profile does not fix
either - **To confirm** whether the DoS and eRS service identifiers should be sliced.

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [eRS Service](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ErsService)
(properties not checked - **To confirm**). The CDM has no general service object; the
referral carries `serviceId` (eRS) and `specialtyId`.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
