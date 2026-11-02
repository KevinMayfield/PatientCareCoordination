// Social Context questionnaire. Based on the Virtually Healthcare IG Questionnaire
// SocialContext (https://virtually-healthcare.github.io/Questionnaire-SocialContext.html,
// source ../../virtually/Virtually-Healthcare-FHIR-Implementation-Guide/input/resources/
// Social-Context.R4.json, 2026-11-01), completed from the PRSB Core Information Standard
// v2.01 "Social context" section (Core-Information-Standard-v2_01_FINAL.json, checked
// 2026-11-01). Changes from the source: the empty drug / substance use and accommodation
// groups are filled in; household composition, smoking, lifestyle choices, access,
// dependants and household environment are added; "lifetime non-drinker" uses the PRSB
// code 228274009 (the source used 783261004). Answer value sets use the SNOMED CT UK
// Edition reference sets named by PRSB.

Alias: $sct = http://snomed.info/sct

Instance: SocialContext
InstanceOf: Questionnaire
Title: "Questionnaire - Social Context"
Description: """
The social setting in which the person lives - household, accommodation, occupation,
education, lifestyle, smoking, alcohol, drug / substance use, social circumstances
(including caring responsibilities), access, dependants and household environment. Based
on the PRSB [Core Information Standard](https://theprsb.org/standards/core-information-standard/)
v2.01 Social context section. Used as referral supporting information, for example for
social prescribing, community, virtual ward and exercise referrals.
"""
Usage: #definition
* url = "https://fhir.acmeexample.org.uk/PatientCareCoordination/Questionnaire/SocialContext"
* name = "SocialContext"
* title = "Social Context"
* status = #draft
* experimental = true
* subjectType = #Patient

* item[+]
  * linkId = "HOUSEHOLD"
  * text = "Household composition"
  * type = #group
  * item[+]
    * linkId = "HOUSEHOLD/224130005"
    * code = $sct#224130005 "Household composition"
    * text = "Household composition (e.g. lives alone, lives with family, lives with partner)"
    * type = #choice
    * answerValueSet = "http://snomed.info/sct/83821000000107?fhir_vs=ecl/%5E1027891000000106"
  * item[+]
    * linkId = "HOUSEHOLD/text"
    * text = "Household composition - details"
    * type = #string

* item[+]
  * linkId = "ACCOMMODATION"
  * text = "Accommodation status"
  * type = #group
  * item[+]
    * linkId = "ACCOMMODATION/status"
    * text = "Type of accommodation where the person lives (main or permanent residence) - NHS Data Dictionary ACCOMMODATION STATUS CODE"
    * type = #string

* item[+]
  * linkId = "OCCUPATIONAL"
  * text = "Occupational history"
  * type = #group
  * item[+]
    * linkId = "OCCUPATIONAL/14679004"
    * code = $sct#14679004 "Occupation"
    * text = "Current or previous occupation"
    * type = #choice
    * repeats = true
    * answerValueSet = "http://snomed.info/sct/83821000000107?fhir_vs=ecl/%5E999001571000000109"
  * item[+]
    * linkId = "OCCUPATIONAL/text"
    * text = "Occupational history - details"
    * type = #text

* item[+]
  * linkId = "EDUCATIONAL"
  * code = $sct#105421008 "Educational achievement"
  * text = "Educational history"
  * type = #text

* item[+]
  * linkId = "LIFESTYLE"
  * text = "Lifestyle choices (e.g. physical activity level, pets, hobbies)"
  * type = #text

* item[+]
  * linkId = "SMOKING"
  * text = "Smoking status"
  * type = #group
  * item[+]
    * linkId = "SMOKING/365980008"
    * code = $sct#365980008 "Finding of tobacco use and exposure"
    * text = "Smoking status"
    * type = #choice
    * answerValueSet = "http://snomed.info/sct/83821000000107?fhir_vs=ecl/%5E999000891000000102"
  * item[+]
    * linkId = "SMOKING/details"
    * text = "Smoking status - details"
    * type = #string
  * item[+]
    * linkId = "SMOKING/160625004"
    * code = $sct#160625004 "Date ceased smoking"
    * text = "Date stopped smoking (if known)"
    * type = #date

* item[+]
  * linkId = "ALCOHOL"
  * text = "Alcohol intake"
  * type = #group
  * item[+]
    * linkId = "ALCOHOL/228273003"
    * code = $sct#228273003 "Finding relating to alcohol drinking behavior"
    * text = "Alcohol current status"
    * type = #choice
    * answerOption[+].valueCoding = $sct#219006 "Alcohol user"
    * answerOption[+].valueCoding = $sct#105542008 "Abstinent"
    * answerOption[+].valueCoding = $sct#228274009 "Lifetime abstainer from drink"
    * answerOption[+].valueCoding = $sct#1104551000000109 "Declined to provide information about alcohol use"
    * answerOption[+].valueCoding = $sct#371434005 "History of alcohol abuse"
  * item[+]
    * linkId = "ALCOHOL/228273003/219006"
    * code = $sct#219006 "Alcohol user"
    * text = "Amount of drinking"
    * type = #choice
    * enableWhen.question = "ALCOHOL/228273003"
    * enableWhen.operator = #=
    * enableWhen.answerCoding = $sct#219006
    * answerValueSet = "http://snomed.info/sct/83821000000107?fhir_vs=ecl/%3C%3C219006"
  * item[+]
    * linkId = "ALCOHOL/228273003/105542008"
    * code = $sct#105542008 "Abstinent"
    * text = "Non drinker type"
    * type = #choice
    * enableWhen.question = "ALCOHOL/228273003"
    * enableWhen.operator = #=
    * enableWhen.answerCoding = $sct#105542008
    * answerValueSet = "http://snomed.info/sct/83821000000107?fhir_vs=ecl/%3C%3C105542008"

* item[+]
  * linkId = "DRUG"
  * text = "Drug / substance use"
  * type = #group
  * item[+]
    * linkId = "DRUG/228366006"
    * code = $sct#228366006 "Drug abuse behaviour"
    * text = "Latest or current drug / substance use"
    * type = #choice
    * answerOption[+].valueCoding = $sct#361055000 "Misuses drugs"
    * answerOption[+].valueCoding = $sct#371422002 "History of substance abuse"
    * answerOption[+].valueCoding = $sct#228368007 "Has never misused drugs"
    * answerOption[+].valueCoding = $sct#783241000000102 "Declined to give substance misuse history"
  * item[+]
    * linkId = "DRUG/details"
    * text = "Drug / substance use - details"
    * type = #string

* item[+]
  * linkId = "SOCIAL"
  * text = "Social circumstances - social background, network and personal circumstances, including whether the person is a carer or has a carer"
  * type = #text

* item[+]
  * linkId = "ACCESS"
  * text = "Access - special access requirements (e.g. key safe, coded lock, which door to use, stretcher access)"
  * type = #text

* item[+]
  * linkId = "DEPENDANTS"
  * text = "Dependants - responsibility for dependants (for children, their date of birth)"
  * type = #text

* item[+]
  * linkId = "HOUSEHOLD-ENVIRONMENT"
  * text = "Household environment - factors in the household affecting health and wellbeing (e.g. smoking in the home, alcohol or substance use)"
  * type = #text
