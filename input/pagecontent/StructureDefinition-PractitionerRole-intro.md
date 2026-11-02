<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### Master Record

| Element | Master record | NHS England API |
|---|---|---|
| Practitioner's role in an organisation (role profile, national RBAC role, ODS code) | Spine Directory Service (SDS) | [Healthcare Worker FHIR API](https://digital.nhs.uk/developer/api-catalogue/healthcare-worker-fhir) `_revinclude=PractitionerRole` (identifier `https://fhir.nhs.uk/Id/sds-role-profile-id`); CIS2 user info for the signed-in user |
| eRS user business functions | eRS | [eRS FHIR API](https://digital.nhs.uk/developer/api-catalogue/e-referral-service-fhir) A030 `GET /R4/PractitionerRole` (**eRS only**) |
| `organization` (ODS code) | ODS | See [Organization](StructureDefinition-Organization.html) |
{:.grid}

SDS role profiles describe access rights rather than clinical roles; `code` and
`specialty` in referrals are clinical. See
[Care Services Directory (mCSD)](mCSD.html#spine-directory-service-sds).

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CareProfessional), [Assigned Care Professional](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/AssignedCareProfessional).

Differences:

- **No practitioner-in-organisation.** CDM Care Professional has role and main specialty but no organisation; requester, owner and author in this guide are a person acting for an organisation (ODS).
- Assigned Care Professional links a professional to an appointment, consultant episode or UEC attendance.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
