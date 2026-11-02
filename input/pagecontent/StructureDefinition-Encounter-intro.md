<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Appointment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Appointment), [Admission](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Admission), [Virtual Ward Stay](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/VirtualWardStay).

Differences:

- **Name clash:** CDM [Encounter](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Encounter) is an entry on the Elective Admission List (TCI, theatre, pre-operative assessment), not an attendance or stay. The CDM equivalents of this profile are Appointment (attendance), Admission (spell) and Virtual Ward Stay.
- `basedOn` (the referral): CDM Appointment and Outpatient Activity have `referralId`; Admission and Virtual Ward Stay do not.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
