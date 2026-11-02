<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Patient](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Patient), [Patient Identifier History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientIdentifierHistory), [Patient Name History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientNameHistory), [Patient Address History](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/PatientAddressHistory), [GP Practice Registration](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/GpPracticeRegistration).

Differences:

- Good fit. NHS Number (`nhsNumber`, verification status), MRN and local identifiers (with assigning authority in Patient Identifier History) match this profile's identifier slices.
- `generalPractitioner`: CDM GP Practice Registration has the practice ODS code and the named GP.
- The CDM holds much more social and demographic data on the patient (accommodation, interpreter, ethnicity, employment); in this guide these are Observations or the [Social Context](Questionnaire-SocialContext.html) form.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
