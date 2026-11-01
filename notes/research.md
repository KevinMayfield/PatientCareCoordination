# Research Notes

Working notes for the Closed Loop Referral IG. **Not published** - this folder is
outside `input/`. Dates are when the source was checked.

## Open Questions

| # | Question | Who could answer | Status |
|---|---|---|---|
| 1 | Health Data API discharge report document type is LOINC 18842-5; HDR fixes Composition.type to 34105-7. Which goes in DocumentReference.type? | HL7 Europe / Xt-EHR | Open |
| 2 | HDR Encounter only allows inpatient classes. Is a virtual ward stay an inpatient (IMP) encounter in NHS PAS and the Virtual Wards SitRep / MDS? | NHS England virtual wards team, trust PAS teams | To confirm |
| 3 | National code set for virtual ward step-up / step-down (local CodeSystem used) | NHS Data Dictionary / SNOMED CT UK | To confirm |
| 4 | eRS R4 ServiceRequest API: UBRN system, status codes for triage outcomes (accept, return to referrer, reject), reject reason codes | NHS England eRS team | To confirm |
| 5 | BaRS gap analysis against 360X: status after first response, cancellation, outcome and its link to the referral, coded reason / question. BaRS is not used as the model (general standards take precedence) | IG authors, against the BaRS IG | Open |
| 6 | Do Transfer of Care documents or Kettering XML carry a referral reference (UBRN or referral ID)? | NHS England, EDT / Docman suppliers | To confirm |
| 7 | MESH workflow IDs for referral and status messages | NHS England MESH team | To confirm |
| 8 | FHIR MessageHeader.eventCoding codes for the 360X events (align with BaRS?) | IG authors | Open |
| 9 | HL7 v2 equivalent of "more information requested" (eRS / BaRS return to referrer) | IG authors | Open |
| 10 | LOINC 42349-1 (Reason for referral) could not be checked on tx.fhir.org ($lookup error); 29299-5 used | IG authors | To confirm |
| 11 | Where HL7 v2 MDM^T02 carries the referral ID (ORC-2 / OBR-2 in MDM, or TXA) | NW GMSA HL7 v2 authors | To confirm |
| 12 | ORC-5 to Task.status is not one-to-one (IP covers accepted and in progress) | IG authors | Open |
| 13 | NHS equivalent of the 360X newborn hearing screening use case (NHSP IT system) | NHS England screening | Open |
| 14 | Advice and Guidance (eRS) as Communication / Task conversation | IG authors | Open |
| 15 | Emergency care discharge (Transfer of Care) - HDR assumes an inpatient encounter | IG authors | Open |
| 16 | Create an NW core package for shared identifier conventions, replacing the copies in this guide | NW GMSA IG authors | Open (same as Imaging IG #16) |
| 18 | Can GP Connect Send Document metadata carry the Referral ID / UBRN? | NHS England GP Connect team | To confirm |
| 19 | GP Connect Update Record: how the community pharmacy consultation is linked to the referral (BaRS / 111) | NHS England GP Connect / BaRS teams | To confirm |
| 20 | GP Connect FHIR versions and transport per capability (STU3 via Spine Secure Proxy; messaging via MESH) | GP Connect specifications | To confirm |
| 21 | Which IM1 write capabilities (documents, coded entries, tasks) EMIS Web and SystmOne offer, and whether the Referral ID can be stored | Optum, TPP | To confirm |
| 22 | Is the EPS dispense notification returned to the prescriber's system, or only visible in the prescription tracker? | NHS England EPS team | To confirm |
| 23 | EPS FHIR API message / operation names (prescription, cancel, release, return, dispense notification) and the prescription ID element | EPS FHIR API specification | To confirm |
| 24 | How virtual wards prescribe today (EPS in secondary / community care, FP10, hospital pharmacy) | NHS England virtual wards / EPS teams | To confirm |
| 17 | Publisher / canonical: copied the NHS North West Genomics publisher and `fhir.nwgenomics.nhs.uk` canonical from the sibling IGs - confirm this is right for a general referral guide | IG authors | To confirm |

## Sources Checked (2026-11-01)

- IHE PCC 360X Rev. 1.2 Trial Implementation, 2021-04-14 (116 pages). Transactions
  PCC-55 to PCC-61; HL7 v2.5.1 OMG^O19, OSU^O51, SIU^S12/S13/S15/S26; ORC-1/ORC-5
  values per transaction taken from Vol 2 tables.
- IHE PCC DCP Rev. 3.1 Trial Implementation, 2019-09-27 (FHIR R4). Transactions
  PCC-37 to PCC-41, PCC-45 to PCC-49, PCC-63 to PCC-70.
  `profiles.ihe.net/PCC/DCP/` returns 404 - the PDF supplement is the reference.
- `hl7.fhir.eu.hdr` 1.0.0 STU 1 published 2026-10-16. Depends on eu.base 2.0.1,
  eu.extensions.r4 1.3.1, ips 2.0.1, xver-r5.r4 0.1.0, xtehr.eu.ehds.models 1.0.0,
  ihe.pharm.mpd.r4 1.0.0-comment-2. Composition has event-basedOn extension
  (ServiceRequest target) and informationRecipient.
- `hl7.fhir.eu.health-data-api` 1.0.0-ballot (2026-03-13), depends on eu.base
  2.0.0-ballot (conflicts with HDR's 2.0.1) - not taken as a dependency; linked only.
- NHS England Virtual wards operational framework PRN01289, published 2024-08-27,
  updated 2025-07-04.
- BaRS FHIR API catalogue lists versions 1.0.7, 1.4.1, 1.5.0, 1.6.0 in production.
- eRS FHIR API catalogue page is rendered by JavaScript; eRS details taken from the
  NW GMSA Genetic Referrals analysis.
- SNOMED CT UK Edition codes and LOINC codes in terminology.md checked on tx.fhir.org.
- GP Connect specifications page: Access Record HTML 0.7.4, Appointment Management
  1.2.7-beta, Access Record Structured 1.5.0-beta, Access Document 1.5.1-beta (link points
  to 1.5.0-beta), Send Document 2.0.2, Update Record 1.2.1-public-beta.
- EPS service page (last edited 2026-10-15): primary, secondary and community care; over 95%
  of prescriptions electronic; does not say dispense information returns to the prescriber.
  IHE MPD 1.0.0-comment-2 (FHIR R5): PHARM-5, PHARM-7, PHARM-8, PHARM-9.
- IM1 pairing page: foundation suppliers Optum (EMIS Web) and TPP (SystmOne); no mention of FHIR.
