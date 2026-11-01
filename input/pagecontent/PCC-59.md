<div class="alert alert-danger" role="alert">
<b>Proof of concept.</b> This implementation guide is a demonstration only. It is
<b>not</b> an authoritative source, is not endorsed by NHS England, IHE or HL7, and
must not be used for implementation or clinical purposes.
</div>

**Interim Consultation Note [PCC-59]** - the Referral Recipient sends results before the
end of care, for example the clinic letter after a first appointment. It does not end
the referral, and may be sent more than once.

### References

- [IHE PCC 360X](https://www.ihe.net/uploadedFiles/Documents/PCC/IHE_PCC_Suppl_360X.pdf) PCC TF-2 3.59
- [Virtually Healthcare - Consultation Note](https://virtually-healthcare.github.io/A04.html)
- [Transfer of Care](https://digital.nhs.uk/services/transfer-of-care-initiative) - outpatient letter

### Interaction

```mermaid
sequenceDiagram
    participant RI as Referral Initiator
    participant RR as Referral Recipient
    RR -->> RR: Consultation
    RR ->> RI: Interim Consultation Note<br/>OSU^O51 SC/A + document<br/>Task businessStatus interim-report + document
    RI -->> RI: Show results; referral still open
```

| Actor | Optionality |
|---|---|
| Referral Initiator | R (receive) |
| Referral Recipient | O (send) |
{:.grid}

### Content

#### Status Update

| Data item | 360X HL7 v2 | FHIR ([Referral Task](StructureDefinition-ReferralTask.html)) |
|---|---|---|
| Order control | ORC-1 `SC` | `status` `in-progress` |
| Referral ID | ORC-2 | `basedOn.identifier`, `focus` |
| Order status | ORC-5 `A` (some, but not all, results available) | `businessStatus` `interim-report` |
| Ordering provider | ORC-12 **empty** | - |
| Document | In the package; OBX ED / RP or `MDM^T02` | `output` - added to any earlier outputs |
{:.grid}

#### Clinical Document

A [Consultation Note](StructureDefinition-ConsultationNote.html) (LOINC 11488-4 Consult
Note), referencing the referral, with sections as needed:

| Section | LOINC | Content |
|---|---|---|
| Reason for referral | 29299-5 | The referral reason and question as understood |
| History of present illness | 10164-2 | |
| Assessment | 51848-0 | Findings and answer to the referral question |
| Plan of care | 18776-5 | Planned tests, treatment, follow up, onward referrals |
| Problems | 11450-4 | Diagnoses |
| Results | 30954-2 | Relevant results |
{:.grid}

LOINC 42349-1 (Reason for referral), used by C-CDA, could not be checked on tx.fhir.org;
29299-5 (Reason for visit) is used instead - **To confirm**.

Example: [Consultation Note - Interim](Composition-CardiologyInterimNote.html).

### Example

The status update and the clinic letter. 360X sends the document with the status update;
in HL7 v2 it travels as an `MDM^T02` carrying the Referral ID in ORC-2 and TXA-14
(placer order number), so the referrer can match it to the referral.

```
MSH|^~\&|EPR|R0A|GPSYSTEM|P89020|20260907160000+0100||OSU^O51^OSU_O51|MFT-MSG-779001|P|2.5.1|||AL|NE
PID|1||9737383397^^^NHS^NH~B6789012^^^R0A^MR||TAMESIDE^Hodor||19600727|M|||Stockport Road^^Tameside^^OL7 0NS
ORC|SC|REF-2026-000123^P89020|||A||||20260907160000+0100
```

```
MSH|^~\&|EPR|R0A|GPSYSTEM|P89020|20260907160000+0100||MDM^T02^MDM_T02|MFT-MSG-779002|P|2.5.1|||AL|NE
EVN|T02|20260907160000+0100
PID|1||9737383397^^^NHS^NH~B6789012^^^R0A^MR||TAMESIDE^Hodor||19600727|M|||Stockport Road^^Tameside^^OL7 0NS
PV1|1|O|^^^R0A||||||||||||||||OP2026090701^^^R0A^VN
ORC|SC|REF-2026-000123^P89020
OBR|1|REF-2026-000123^P89020||57133-1^Referral note^LN
TXA|1|11488-4^Consult note^LN|AP|20260907160000+0100|7654321^Brown^^^^Dr^^^GMC|||||||DOC-55501^R0A||REF-2026-000123^P89020|||AU||AV
OBX|1|ED|11488-4^Consult note^LN||^application^pdf^Base64^JVBERi0xLjQK...||||||F
```

The attendance is identified by its Visit Number in PV1-19 (type `VN`) - see
[Patient Administration](PatientAdministration.html#identifiers). FHIR equivalent: a
Referral Order Status (O51) message whose Task output is the
[interim consultation note](Composition-CardiologyInterimNote.html).

### Expected Actions

- The Referral Initiator **SHALL** extract the document and present the results to the
  appropriate users. Particular attention is needed when the note reports a serious
  condition.
- Each interim note and the final outcome are separate documents. Relationships
  between them (e.g. a note replacing an earlier one) use `Composition.relatesTo`.
