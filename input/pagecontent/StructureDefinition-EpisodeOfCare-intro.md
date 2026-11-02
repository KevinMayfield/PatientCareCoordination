<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Patient Pathway](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientPathway), [Outpatient Activity](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/OutpatientActivity), [Consultant Episode](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ConsultantEpisode).

Differences:

- Partial: CDM Patient Pathway is the referral to treatment (RTT) pathway and Consultant Episode is a consultant's period within a spell - neither is a care episode managed by an organisation - **To confirm**.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
