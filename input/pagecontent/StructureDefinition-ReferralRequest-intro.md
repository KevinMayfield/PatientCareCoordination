<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Referral), [UEC Referral](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/UecReferral), [eRS Service](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ErsService).

Differences:

- Identifiers: CDM `referralId`, `sourceUniqueId` and `ubrn` carry no identifier type or assigning organisation, so the Referral Initiator's (placer) Referral ID is not distinguished - this profile slices `identifier` into the [Referral ID](StructureDefinition-ReferralIdentifier.html) (PLAC, assigner ODS) and [UBRN](StructureDefinition-UniqueBookingReferenceNumber.html).
- Supporting information: the CDM holds the referral letter (`referralLetterContent`, `referralLetterRid`) and notes; this profile references structured information and forms (`supportingInfo`, `reasonReference`).
- Onward and replacement referrals: no CDM `basedOn` / `replaces`; redirection is triage outcome text.
- Workflow state: the CDM keeps it on the referral (`status`); this guide keeps it on the [Referral Task](StructureDefinition-ReferralTask.html).
- Represented well: reason (`presentingComplaintSnomedCtCode`, `primaryReferralReasonCode`), priority, referrer and provider ODS codes, treatment function, booking dates.

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
