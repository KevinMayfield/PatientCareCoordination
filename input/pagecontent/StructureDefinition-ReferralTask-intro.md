<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Referral).

Differences:

- **No CDM equivalent.** The referral's workflow state is the CDM `Referral.status` (17 values) and `latestTriageOutcome` - provider-side only, with no owner, requester or status history. See [Referral Status Values](FDPCanonicalDataModel.html#referral-status-values).
- No link from a referral to its outcome report (`Task.output`): CDM [Clinic Letter](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicLetter) links only to an appointment.
- No forms to complete or completed forms (`Task.input` / `output`).
- CDM [Task](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/RttTask) is a pathway work-list item, not referral fulfilment - **To confirm**.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
