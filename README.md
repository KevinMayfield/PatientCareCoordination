# Closed Loop Referral and Care Coordination (Proof of Concept)

> **Proof of concept.** This FHIR Implementation Guide is a demonstration only. It is **not** an authoritative source, is not endorsed by NHS England, IHE or HL7, and must not be used for implementation or clinical purposes.

General order (referral) and report (outcome) workflow patterns for NHS England,
based on [IHE 360X Closed Loop Referral](https://www.ihe.net/uploadedFiles/Documents/PCC/IHE_PCC_Suppl_360X.pdf).
Maps eRS, BaRS, Transfer of Care, MESH / Kettering XML, GP Connect, IM1 and EPS onto one closed loop,
with HL7 v2 as the baseline, HL7 Europe Hospital Discharge Report for outcomes and
the EU Health Data API for sharing, extended to virtual wards (hospital at home) and
IHE Dynamic Care Planning.

Related: [NW GMSA](https://nw-gmsa.github.io/en/),
[Cancer Pathology Report](https://kevinmayfield.github.io/CancerPathologyReport/),
[Enterprise Imaging](https://kevinmayfield.github.io/Imaging/),
[Virtually Healthcare](https://virtually-healthcare.github.io/).

- Pages: `input/pagecontent/`
- Build: `sushi build .`, then the HL7 FHIR IG Publisher (`./_genonce.sh`)
