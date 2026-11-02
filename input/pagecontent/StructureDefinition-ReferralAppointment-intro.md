<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

### FDP Canonical Data Model

Equivalent [FDP Canonical Data Model](https://cdm.solutionexchange.federateddataplatform.nhs.uk/)
(CDM) v1.0.0 objects: [Appointment](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/Appointment), [Clinic Slot](https://cdm.solutionexchange.federateddataplatform.nhs.uk/1.0.0/object/ClinicSlot).

Differences:

- Good fit: CDM Appointment links to the referral (`referralId`) and the slot, with booking and attendance status and `outcomeOfAttendanceCode`.
- The CDM records consultation mechanism (face to face, telephone, video) - candidate for `serviceType` / appointment type.
- Attendance outcome (discharged, another appointment) is how the CDM records the end of care; this guide closes the loop with the outcome report [PCC-57].

The CDM is a downstream persistence model, used here as evidence of what NHS
operations record, not as a design source. Mapping by property name - **To confirm**.
See [FDP Canonical Data Model Mapping](FDPCanonicalDataModel.html) for the full mapping.
