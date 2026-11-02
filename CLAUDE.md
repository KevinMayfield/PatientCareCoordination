# CLAUDE.md

Proof-of-concept FHIR Implementation Guide for closed loop referrals and care
coordination in the NHS in England, based on IHE PCC 360X. Sibling guides, whose
conventions this one follows: `../Imaging`, `../CancerPathologyReport` and the
NW GMSA IG (`../FHIRGenomics`).

## Scope

- **Proof of concept only.** Every page starts with the red "Proof of concept"
  alert box (copy it from an existing page). Never present content as
  authoritative or endorsed.
- **General pattern first.** Referral = order out, report back - the same shape
  as LTW (LAB-1/LAB-3) and SWF.b (RAD-2/RAD-128). National services (eRS, BaRS,
  Transfer of Care, MESH + Kettering XML) are mapped onto the 360X transactions,
  never used as the design.
- **General standards take precedence over NHS England standards.** Never assume a
  national standard is correct: assess it against IHE / HL7 v2 / FHIR / CDA and record
  gaps. eRS and EPS are trusted, well-engineered references within their scope (the
  author worked on them). BaRS has the 360X shape but loose definitions (see
  `input/pagecontent/BaRS.md`) - map it onto 360X, never use it as the model. Do not adopt "write access to other organisations' records" (e.g. the
  virtual wards framework); use `ORU_R01` messaging, REST APIs, or CDA / FHIR Documents.
- **HL7 v2 is the baseline; IHE XDS / XDM / XDR are optional.** Every
  interaction has an HL7 v2 equivalent (360X v2.5.1 messages).
- Reports: HL7 Europe Hospital Discharge Report (`hl7.fhir.eu.hdr` 1.0.0) for
  inpatient / virtual ward stays, the Consultation Note for outpatient outcomes
  (HDR only allows inpatient encounters). Sharing: EU Health Data API.
- Profiles are kept few. Identifier data types and Patient are copied from the
  NW GMSA IG (via `../Imaging`) - see the DUPLICATION comments. Core NHS patient
  administration profiles (`input/fsh/Core/PatientAdministration.fsh`) are copied from
  NW GMSA and follow Interweave; keep Account / Spell Number (AN) and Visit Number (VN)
  distinct.

## Layout

- Pages: `input/pagecontent/`, organised as IHE volumes - Volume 1 Analysis and
  Design, Volume 2 Interactions (one page per 360X transaction, PCC-60 also covers
  PCC-61), Volume 3 Data Models, then Appendices (`WorkflowPatterns.md` order and report pattern, and assessments of
  NHS England services: `NHSEngland.md` referral services, `NHSEnglandDiagnostics.md`
  diagnostic orders).
- FSH: `input/fsh/` - logical model `Referral.fsh` at the top level, `Profiles/`,
  `Terminology/`, `Examples/`, `Core/`, `DataTypes/`.
- A new page must be added to both `pages:` and `menu:` in `sushi-config.yaml`.
- Research notes and open questions that should not be published:
  `notes/research.md`.

## Conventions

- Markdown pages; diagrams as Mermaid; tables end with `{:.grid}`; HL7 v2
  mappings are "indicative".
- Check LOINC and SNOMED CT codes on tx.fhir.org (`CodeSystem/$lookup`, UK
  Edition `http://snomed.info/sct/83821000000107`) before using them.
- Cite sources with links. Mark anything unverified or undecided as **Open** or
  **To confirm** rather than guessing.
- Example data is fictitious.

## Build and publish

- `sushi build .` after any FSH or `sushi-config.yaml` change; expect 0 errors.
- Full build: `./_genonce.sh` (HL7 IG Publisher). Mermaid diagrams are only
  rendered by the full build.
- Any push runs `.github/workflows/igPublish.yml`. Commit or push only when asked.
