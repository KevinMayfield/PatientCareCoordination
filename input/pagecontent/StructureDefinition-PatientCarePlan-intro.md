<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Community Care Plan](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CommunityCarePlan), [Team](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/CdmTeam).

Differences:

- **CDM Community Care Plan has no content:** type, agreed by / when and implementation date only.
- Missing: activities (onward referrals, visits, tasks), goals, conditions addressed, care team, period and status, and the assessment it is based on (`supportingInfo`).
- CDM Team is not linked to a care plan.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
