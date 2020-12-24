Infectious and inflammatory eye disease epidemic detection and seasonality


--STEP 1: Create patient universe

		--1a. First, we want to focus on coding the inclusion criteria.
		--Pull all diagnoses (icd 9 & 10 codes)
		--Make eye level to make an indicator variable
			--1 = right 2 = left 4 = unspecified 
			--Split 3's (bilateral) into 1's and 2's
			--Unspecified eyes are not included. Commented out ICD codes pertaining to unspecified laterality.
				
		--1b. Create the 'diagnosis_date' since we don’t have a diagnosis date column in Madrid2.
		--It is standard protocol to take which ever date is earliest between documentation_date and problem_onset_date in the patient_problem_laterality 
		--table in order to create the diagnosis date since they are both related to the diagnosis that the patient has. 
	
		--1c. Filter study date range to 2015-2018
		
		--1d. Extra: Create CSME status with case statement to put patients with and without macular edema in different buckets. Also, since Dr. Lietman is interested 
		-- in studying geographic regions, we pull practice IDs as well.
		-- NOTE: This step is not needed for the purpose of patient count, but is relavent to the study. This does not affect our final patient count.
		
		
		
drop table if exists aao_grants.liet_diag_pull_new1;
create table aao_grants.liet_diag_pull_new1 as 
(select distinct patient_guid,
case when (documentation_date > problem_onset_date) and problem_onset_date is not null then problem_onset_date
when (problem_onset_date > documentation_date) and documentation_date is not null then documentation_date
when problem_onset_date is null then documentation_date
when documentation_date is null then problem_onset_date
when documentation_date=problem_onset_date then documentation_date
end as diagnosis_date,
case when diag_eye='1' then 1
when diag_eye='2' then 2
when diag_eye='3' then 1
end as eye,
practice_id,
case
				when (problem_description ilike '%without CSME%' 
				or problem_description ilike '428341000124108' 
				or problem_description ilike '%Non-Center Involved Diabetic Macular Edema%' 
				or problem_description ilike '%no evidence of clinically significant macular edema%' 
				or problem_description ilike '%Borderline CSME%' 
				or problem_description ilike '%No SRH/SRF/Lipid/CSME%' 
				or problem_description ilike '%No Clinically Significant Macular Edema%' 
				or problem_description ilike '%No CSME%' 
				or problem_description ilike '%Clinically Significant Macular Edema, Focal%' 
				or problem_description ilike '%Borderline Clinically Significant Macular Edema%' 
				or problem_description ilike '%(-) CSME%' 
				or problem_description ilike '%w/o CSME%' 
				or problem_description ilike '%CSME  (?)%'  
				or problem_description ilike '%?CSME%' 
				or problem_description ilike '%No CSME/DME%'  
				or problem_description ilike '%(--) CSME%'
				or problem_description ilike '%No NPDR (diabetic retinopathy) or CSME%'
				or problem_description ilike '%(-)CSME%' 
				or problem_description ilike '%no heme, exudate, CSME, NVD, NVE%' 
				or problem_description ilike '%no_CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%no DR or CSME noted%' 
				or problem_description ilike '%Clinically Significant Macular Edema is absent%' 
				or problem_description ilike '%neg CSME%' 
				or problem_description ilike '%=-CSME%' 
				or problem_description ilike '%no BDR/ CSME%' 
				or problem_description ilike '%diabetes WITHOUT signs of diabetic retinopathy or clinically significant macular edema%' 
				or problem_description ilike '%no macular edema%' 
				or problem_description ilike '%no diabetic retinopathy, NVE, NVD or CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%Non-Center-Involved Diabetic Macular Edema%' 
				or problem_description ilike '%No DME or CSME%' 
				or problem_description ilike '%NO   CSME%' 
				or problem_description ilike '%No CSME-DME%' 
				or problem_description ilike '%No Diabetic Retinopathy or CSME%' 
				or problem_description ilike '%no heme,exudates,or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%no diabetic retinopathy or CSME%' 
				or problem_description ilike '%no NV/CSME%' 
				or problem_description ilike '%No BDR, CSME, NVD, NVE, NVE%' 
				or problem_description ilike '%CSME -' 
				or problem_description ilike '%(-) BDR or CSME%'
				or problem_description ilike '%(-)BDR or CSME%'
				or problem_description ilike '%without Clinically Significant Macular Edema%'
				or problem_description ilike '%Diabetes without retinopathy or clinically significant macular edema%') then 0
				
				when (problem_description ilike 'CSME%' 
				or problem_description ilike 'Clinically Significant Macular Edema%' 
				or problem_description ilike '%with clinically significant macular edema%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF RIGHT EYE DETERMINED BY EXAMINATION%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF LEFT EYE DETERMINED BY EXAMINATION%'
				or problem_description ilike 'Center Involved Diabetic Macular Edema%' 
				or problem_description ilike 'CSME (Diabetes Related Mac. Edema)%' 
				or problem_description ilike 'Clinically Significant Macular Edema, Diffuse%' 
				or problem_description ilike 'CSME_clinically significant macular edema%' 
				or problem_description ilike 'EDEMA-CSME%'  
				or problem_description ilike 'Clinically significant macular edema (disorder)%' 
				or problem_description ilike 'edema CSME%' 
				or problem_description ilike 'CSME (Clinically Significant  Mac. Edema)%' 
				or problem_description ilike '%has developed CSME%' 
				or problem_description ilike '%(+) CSME%' 
				or problem_description ilike 'Diabetes - CSME (250.52) (OCT)%' 
				or problem_description ilike 'Clinically significant macular edema of right eye%' 
				or problem_description ilike 'Clinically significant macular edema of left eye%' 
				or problem_description ilike 'CSME (H35.81%)' 
				or problem_description ilike '%management of clinically significant macular edema%' 
				or problem_description ilike '%with CSME%' 
				or problem_description ilike 'Clinically significant macular edema associated with type 2 diabetes%' 
				or problem_description ilike 'Center-Involved Diabetic Macular Edema%'
				or problem_description ilike 'On examination - clinically significant macular edema of left eye%' 
				or problem_description ilike 'On examination - clinically significant macular edema of right eye%') then 1
				
				when (problem_comment ilike '%no clinically significant macular edema%' 
				or problem_comment ilike '%no CSME%' 
				or problem_comment ilike '%negative CSME%' 
				or problem_comment ilike '%No NVD, NVE, Vit Hem or CSME%' 
				or problem_comment ilike '%(-)CSME%' 
				or problem_comment ilike '%No NVD/NVE/CSME%' 
				or problem_comment ilike '%CSMEnegative%' 
				or problem_comment ilike '%No Diabetic Retinopathy, macular edema or CSME%' 
				or problem_comment ilike '%=-CSME%' 
				or problem_comment ilike '%no BDR, CSME, NVE%' 
				or problem_comment ilike '%(-) CSME%' 
				or problem_comment ilike '%no hemorrhages, exudates, pigmentary changes or macular edemano clinically significant macular edema%' 
				or problem_comment ilike '%no clinically significant macular edemanegative%' 
				or problem_comment ilike '%no hemorrhage or exudatesno clinically significant macular edema%' 
				or problem_comment ilike '%no signs of clinically significant macular edema%' 
				or problem_comment ilike '%clinically significant macular edemanegative%' 
				or problem_comment ilike '%Mild NPDR without macular edema or CSME%' 
				or problem_comment ilike '%no MAs, DBH, or CSME%' 
				or problem_comment ilike '%no signs of neovascularization or clinically significant macular edema%' 
				or problem_comment ilike '%retinopathyno clinically significant macular edema%' 
				or problem_comment ilike '%without clinically significant macular edema%' 
				or problem_comment ilike '%No diabetic retinopathy or clinically significant macular edema%' 
				or problem_comment ilike '%No NVE/CSME%' 
				or problem_comment ilike '%no MA, DBH, NV, CSME%' 
				or problem_comment ilike '%No MAs, heme or CSME%' 
				or problem_comment ilike '%=- CSME%' 
				or problem_comment ilike '%No DR or CSME%' 
				or problem_comment ilike '?CSME%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%No NPDR, PDR, or CSME%' 
				or problem_comment ilike '%without CSME%' 
				or problem_comment ilike '%w/o  CSME%' 
				or problem_comment ilike '%borderline CSME%' 
				or problem_comment ilike '%Negative CSME%' 
				or problem_comment ilike '%CSME - neg%' 
				or problem_comment ilike '%neg. CSME%' 
				or problem_comment ilike '%(-)NPDR/PDR/CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%No signs of CSME%' 
				or problem_comment ilike '%mild CSME%' 
				or problem_comment ilike '%negative BDR, CSME%' 
				or problem_comment ilike '%CSMEabsent%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%no retinopathy, CSME or neovascularization%' 
				or problem_comment ilike '%without macular edema or CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%? CSME%' 
				or problem_comment ilike '%Neg CSME%' 
				or problem_comment ilike '%CSMEno%' 
				or problem_comment ilike '%no MAs, heme or CSME%' 
				or problem_comment ilike '-CSME%'
				or problem_comment ilike '%No signs of Retinopathy or neovascularization, or CSME%') then 0
				
				when (problem_comment ilike 'clinically significant macular edema%'
				or problem_comment ilike 'CSME%' 
				or problem_comment ilike 'DM, CSME%'
				or problem_comment ilike '%Diabetic Retinopathy With CSME%' 
				or problem_comment ilike '%=+ CSME%' 
				or problem_comment ilike '%=+CSME%' 
				or problem_comment ilike '%Mild non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME diabetic retinopathy%' 
				or problem_comment ilike '%Proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME (clinically significant macular edema%)' 
				or problem_comment ilike '%Moderate non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike '%no evidence of non-proliferative diabetic retinopathy or clinically significant macular edema%') then 1
				else 99 end as csme_status
from madrid2.patient_problem_laterality 
where (
--Corneal ulcer
problem_code ILIKE '370.00%' -- Corneal ulcer, unspecified
or problem_code ILIKE '370.01%' -- Marginal corneal ulcer
or problem_code ILIKE '370.02%' -- Ring corneal ulcer
or problem_code ILIKE '370.03%' -- Central corneal ulcer
or problem_code ILIKE '370.04%' -- Hypopyon ulcer
or problem_code ILIKE '370.05%' -- Mycotic corneal ulcer
or problem_code ILIKE '370.06%' -- Perforated corneal ulcer
or problem_code ILIKE '370.07%' -- Mooren's ulcer
-- Certain types of keratoconjunctivitis
or problem_code ILIKE '370.31%' -- Phlyctenular keratoconjunctivitis
or problem_code ILIKE '370.32%' -- Limbar and corneal involvement in vernal conjunctivitis
or problem_code ILIKE '370.33%' -- Keratoconjunctivitis sicca, not specified as Sjogren's
or problem_code ILIKE '370.34%' -- Exposure keratoconjunctivitis
or problem_code ILIKE '370.35%' -- Neurotrophic keratoconjunctivitis
-- Other and unspecified keratoconjunctivitis
or problem_code ILIKE '370.40%' -- Keratoconjunctivitis, unspecified
or problem_code ILIKE '370.44%' -- Keratitis or keratoconjunctivitis in exanthema
or problem_code ILIKE '370.49%' -- Other keratoconjunctivitis
-- Interstitial and deep keratitis
or problem_code ILIKE '370.50%' -- Interstitial keratitis, unspecified
or problem_code ILIKE '370.52%' -- Diffuse interstitial keratitis
or problem_code ILIKE '370.54%' -- Sclerosing keratitis
or problem_code ILIKE '370.55%' -- Corneal abscess
or problem_code ILIKE '370.59%' -- Other interstitial and deep keratitis 
-- Corneal neovascularization
or problem_code ILIKE '370.60%' -- Corneal neovascularization, unspecified
or problem_code ILIKE '370.61%' -- Localized vascularization of cornea
or problem_code ILIKE '370.62%' -- Pannus (corneal)
or problem_code ILIKE '370.63%' -- Deep vascularization of cornea
or problem_code ILIKE '370.64%' -- Ghost vessels (corneal)
-- Other forms of keratitis 
or problem_code ILIKE '370.8%' 
-- Unspecified keratitis
or problem_code ILIKE '370.9%' 
-- Acute conjunctivitis
or problem_code ILIKE '372.00%' -- Acute conjunctivitis, unspecified
or problem_code ILIKE '372.01%' -- Serous conjunctivitis, except viral
or problem_code ILIKE '372.02%' -- Acute follicular conjunctivitis
or problem_code ILIKE '372.03%' -- Other mucopurulent conjunctivitis
or problem_code ILIKE '372.04%' -- Pseudomembranous conjunctivitis
or problem_code ILIKE '372.05%' -- Acute atopic conjunctivitis
or problem_code ILIKE '372.06%' -- Acute chemical conjunctivitis
--Chronic conjunctivitis
or problem_code ILIKE '372.10%' -- Chronic conjunctivitis, unspecified 
or problem_code ILIKE '372.11%' -- Simple chronic conjunctivitis
or problem_code ILIKE '372.12%' -- Chronic follicular conjunctivitis
or problem_code ILIKE '372.13%' -- Vernal conjunctivitis
or problem_code ILIKE '372.14%' -- Other chronic allergic conjunctivitis
or problem_code ILIKE '372.15%' -- Parasitic conjunctivitis
-- Blepharoconjunctivitis
or problem_code ILIKE '372.20%' -- Blepharoconjunctivitis, unspecified 
or problem_code ILIKE '372.21%' -- Angular blepharoconjunctivitis
or problem_code ILIKE '372.22%' -- Contact blepharoconjunctivitis
-- Other and unspecified conjunctivitis
or problem_code ILIKE '372.30%' -- Conjunctivitis, unspecified
or problem_code ILIKE '372.31%' -- Rosacea conjunctivitis
or problem_code ILIKE '372.33%' -- Conjunctivitis in mucocutaneous disease
or problem_code ILIKE '372.34%' -- Pingueculitis
or problem_code ILIKE '372.39%' -- Other conjunctivitis
-- Pterygium --should we keep this?
or problem_code ILIKE '372.40%' -- Pterygium, unspecified
or problem_code ILIKE '372.41%' -- Peripheral pterygium, stationary
or problem_code ILIKE '372.42%' -- Peripheral pterygium, progressive
or problem_code ILIKE '372.43%' -- Central pterygium
or problem_code ILIKE '372.44%' -- Double pterygium
or problem_code ILIKE '372.45%' -- Recurrent pterygium
--Conjunctival degenerations and deposits
or problem_code ILIKE '372.50%' -- Conjunctival degeneration, unspecified
or problem_code ILIKE '372.51%' -- Pinguecula
or problem_code ILIKE '372.52%' -- Pseudopterygium
or problem_code ILIKE '372.53%' -- Conjunctival xerosis
or problem_code ILIKE '372.54%' -- Conjunctival concretions
or problem_code ILIKE '372.55%' -- Conjunctival pigmentations
or problem_code ILIKE '372.56%' -- Conjunctival deposits
-- Conjunctival scars
or problem_code ILIKE '372.61%' -- Granuloma of conjunctiva
or problem_code ILIKE '372.62%' -- Localized adhesions and strands of conjunctiva
or problem_code ILIKE '372.63%' -- Symblepharon
or problem_code ILIKE '372.64%' -- Scarring of conjunctiva
-- Conjunctival vascular disorders and cysts
or problem_code ILIKE '372.71%' -- Hyperemia of conjunctiva 
or problem_code ILIKE '372.72%' -- Conjunctival hemorrhage
or problem_code ILIKE '372.73%' -- Conjunctival edema
or problem_code ILIKE '372.74%' -- Vascular abnormalities of conjunctiva 
or problem_code ILIKE '372.75%' -- Conjunctival cysts
-- Other disorders of conjunctiva (include?)
or problem_code ILIKE '372.81%' -- Conjunctivochalasis
or problem_code ILIKE '372.89%' -- Other disorders of conjunctiva
-- Unspecified disorder of conjunctiva
or problem_code ILIKE '372.9%'
-- Conjunctivitis
	-- Acute follicular conjunctivitis
or problem_code ILIKE 'H10.011%' -- right eye
or problem_code ILIKE 'H10.012%' -- left eye
or problem_code ILIKE 'H10.013%' -- bilateral
/*or problem_code ILIKE 'H10.019%' --  unspecified eye*/
	-- Other mucopurulent conjunctivitis
or problem_code ILIKE 'H10.021%' -- right eye
or problem_code ILIKE 'H10.022%' -- left eye
or problem_code ILIKE 'H10.023%' -- bilateral
/*or problem_code ILIKE 'H10.029%' --  unspecified eye*/
-- Acute atopic conjunctivitis
or problem_code ILIKE 'H10.11%' -- right eye
or problem_code ILIKE 'H10.12%' -- left eye
or problem_code ILIKE 'H10.13%' -- bilateral
/*or problem_code ILIKE 'H10.10%' --  unspecified eye*/
-- Acute toxic conjunctivitis
or problem_code ILIKE 'H10.211%' -- right eye
or problem_code ILIKE 'H10.212%' -- left eye
or problem_code ILIKE 'H10.213%' -- bilateral
/*or problem_code ILIKE 'H10.219%' --  unspecified eye*/
-- Pseudomembranous conjunctivitis
or problem_code ILIKE 'H10.221%' -- right eye
or problem_code ILIKE 'H10.222%' -- left eye
or problem_code ILIKE 'H10.223%' -- bilateral
/*or problem_code ILIKE 'H10.229%' --  unspecified eye*/
-- Serous conjunctivitis, except viral
or problem_code ILIKE 'H10.231%' -- right eye
or problem_code ILIKE 'H10.232%' -- left eye
or problem_code ILIKE 'H10.233%' -- bilateral
/*or problem_code ILIKE 'H10.239%' --  unspecified eye*/
-- Unspecified acute conjunctivitis
or problem_code ILIKE 'H10.31%' -- right eye
or problem_code ILIKE 'H10.32%' -- left eye
or problem_code ILIKE 'H10.33%' -- bilateral
/*or problem_code ILIKE 'H10.30%' --  unspecified eye*/
-- Unspecified chronic conjunctivitis
or problem_code ILIKE 'H10.401%' -- right eye
or problem_code ILIKE 'H10.402%' -- left eye
or problem_code ILIKE 'H10.403%' -- bilateral
/*or problem_code ILIKE 'H10.409%' --  unspecified eye*/
-- Chronic giant papillary conjunctivitis
or problem_code ILIKE 'H10.411%' -- right eye
or problem_code ILIKE 'H10.412%' -- left eye
or problem_code ILIKE 'H10.413%' -- bilateral
/*or problem_code ILIKE 'H10.419%' --  unspecified eye*/
-- Simple chronic conjunctivitis
or problem_code ILIKE 'H10.421%' -- right eye
or problem_code ILIKE 'H10.422%' -- left eye
or problem_code ILIKE 'H10.423%' -- bilateral
/*or problem_code ILIKE 'H10.429%' --  unspecified eye*/
--  Chronic follicular conjunctivitis
or problem_code ILIKE 'H10.431%' -- right eye
or problem_code ILIKE 'H10.432%' -- left eye
or problem_code ILIKE 'H10.433%' -- bilateral
/*or problem_code ILIKE 'H10.439%' --  unspecified eye*/
-- Vernal conjunctivitis
or problem_code ILIKE 'H10.44%'
-- Other chronic allergic conjunctivitis
or problem_code ILIKE 'H10.45%'
-- Unspecified blepharoconjunctivitis
or problem_code ILIKE 'H10.501%' -- right eye
or problem_code ILIKE 'H10.502%' -- left eye
or problem_code ILIKE 'H10.503%' -- bilateral
/*or problem_code ILIKE 'H10.509%' --  unspecified eye*/
-- Ligneous conjunctivitis
or problem_code ILIKE 'H10.511%' -- right eye
or problem_code ILIKE 'H10.512%' -- left eye
or problem_code ILIKE 'H10.513%' -- bilateral
/*or problem_code ILIKE 'H10.519%' --  unspecified eye*/
-- Angular blepharoconjunctivitis
or problem_code ILIKE 'H10.521%' -- right eye
or problem_code ILIKE 'H10.522%' -- left eye
or problem_code ILIKE 'H10.523%' -- bilateral
/*or problem_code ILIKE 'H10.529%' --  unspecified eye*/
--  Contact blepharoconjunctivitis
or problem_code ILIKE 'H10.531%' -- right eye
or problem_code ILIKE 'H10.532%' -- left eye
or problem_code ILIKE 'H10.533%' -- bilateral
/*or problem_code ILIKE 'H10.539%' --  unspecified eye*/
-- Pingueculitis
or problem_code ILIKE 'H10.811%' -- right eye
or problem_code ILIKE 'H10.812%' -- left eye
or problem_code ILIKE 'H10.813%' -- bilateral
/*or problem_code ILIKE 'H10.819%' --  unspecified eye*/
-- Rosacea conjunctivitis
or problem_code ILIKE 'H10.821%' -- right eye
or problem_code ILIKE 'H10.822%' -- left eye
or problem_code ILIKE 'H10.823%' -- bilateral
/*or problem_code ILIKE 'H10.829%' --  unspecified eye*/
-- Other conjunctivitis
or problem_code ILIKE 'H10.89%' 
-- Unspecified conjunctivitis
or problem_code ILIKE 'H10.9%' 
-- Neonatal conjunctivitis and dacryocystitis
or problem_code ILIKE 'P39.1%' 
-- Unspecified corneal ulcer
or problem_code ILIKE 'H16.001%' -- right eye
or problem_code ILIKE 'H16.002%' -- left eye
or problem_code ILIKE 'H16.003%' -- bilateral
/*or problem_code ILIKE 'H16.009%' --  unspecified eye*/
-- Central corneal ulcer
or problem_code ILIKE 'H16.011%' -- right eye
or problem_code ILIKE 'H16.012%' -- left eye
or problem_code ILIKE 'H16.013%' -- bilateral
/*or problem_code ILIKE 'H16.019%' --  unspecified eye*/
-- Ring corneal ulcer
or problem_code ILIKE 'H16.021%' -- right eye
or problem_code ILIKE 'H16.022%' -- left eye
or problem_code ILIKE 'H16.023%' -- bilateral
/*or problem_code ILIKE 'H16.029%' --  unspecified eye*/
-- Corneal ulcer with hypopyon
or problem_code ILIKE 'H16.031%' -- right eye
or problem_code ILIKE 'H16.032%' -- left eye
or problem_code ILIKE 'H16.033%' -- bilateral
/*or problem_code ILIKE 'H16.039%' --  unspecified eye*/
-- Marginal corneal ulcer
or problem_code ILIKE 'H16.041%' -- right eye
or problem_code ILIKE 'H16.042%' -- left eye
or problem_code ILIKE 'H16.043%' -- bilateral
/*or problem_code ILIKE 'H16.049%' --  unspecified eye*/
-- Mooren's corneal ulcer
or problem_code ILIKE 'H16.051%' -- right eye
or problem_code ILIKE 'H16.052%' -- left eye
or problem_code ILIKE 'H16.053%' -- bilateral
/*or problem_code ILIKE 'H16.059%' --  unspecified eye*/
-- Mycotic corneal ulcer
or problem_code ILIKE 'H16.061%' -- right eye
or problem_code ILIKE 'H16.062%' -- left eye
or problem_code ILIKE 'H16.063%' -- bilateral
/*or problem_code ILIKE 'H16.069%' --  unspecified eye*/
--  Perforated corneal ulcer
or problem_code ILIKE 'H16.071%' -- right eye
or problem_code ILIKE 'H16.072%' -- left eye
or problem_code ILIKE 'H16.073%' -- bilateral
/*or problem_code ILIKE 'H16.079%' --  unspecified eye*/
-- Other and unspecified superficial keratitis without conjunctivitis	
-- Unspecified superficial keratitis	
or problem_code ILIKE 'H16.101%' -- right eye	
or problem_code ILIKE 'H16.102%' -- left eye	
or problem_code ILIKE 'H16.103%' -- bilateral	
/*or problem_code ILIKE 'H16.109%' -- unspecified eye*/	
-- Macular keratitis	
or problem_code ILIKE 'H16.111%' -- right eye	
or problem_code ILIKE 'H16.112%' -- left eye	
or problem_code ILIKE 'H16.113%' -- bilateral	
/*or problem_code ILIKE 'H16.119%' -- unspecified eye*/	
-- Filamentary keratitis	
or problem_code ILIKE 'H16.121%' -- right eye	
or problem_code ILIKE 'H16.122%' -- left eye	
or problem_code ILIKE 'H16.123%' -- bilateral	
/*or problem_code ILIKE 'H16.129%' -- unspecified eye	*/
-- Photokeratitis	
or problem_code ILIKE 'H16.131%' -- right eye	
or problem_code ILIKE 'H16.132%' -- left eye	
or problem_code ILIKE 'H16.133%' -- bilateral	
/*or problem_code ILIKE 'H16.139%' -- unspecified eye	*/
-- Punctate keratitis	
or problem_code ILIKE 'H16.141%' -- right eye	
or problem_code ILIKE 'H16.142%' -- left eye	
or problem_code ILIKE 'H16.143%' -- bilateral	
/*or problem_code ILIKE 'H16.149%' -- unspecified eye	*/
-- Unspecified keratoconjunctivitis
or problem_code ILIKE 'H16.201%' -- right eye
or problem_code ILIKE 'H16.202%' -- left eye
or problem_code ILIKE 'H16.203%' -- bilateral
/*or problem_code ILIKE 'H16.209%' --  unspecified eye*/
-- Exposure keratoconjunctivitis
or problem_code ILIKE 'H16.211%' -- right eye
or problem_code ILIKE 'H16.212%' -- left eye
or problem_code ILIKE 'H16.213%' -- bilateral
/*or problem_code ILIKE 'H16.219%' --  unspecified eye*/
-- Keratoconjunctivitis sicca, not specified as Sjögren's
or problem_code ILIKE 'H16.221%' -- right eye
or problem_code ILIKE 'H16.222%' -- left eye
or problem_code ILIKE 'H16.223%' -- bilateral
/*or problem_code ILIKE 'H16.229%' --  unspecified eye*/
-- Neurotrophic keratoconjunctivitis
or problem_code ILIKE 'H16.231%' -- right eye
or problem_code ILIKE 'H16.232%' -- left eye
or problem_code ILIKE 'H16.233%' -- bilateral
/*or problem_code ILIKE 'H16.239%' --  unspecified eye*/
-- Ophthalmia nodosa
or problem_code ILIKE 'H16.241%' -- right eye
or problem_code ILIKE 'H16.242%' -- left eye
or problem_code ILIKE 'H16.243%' -- bilateral
/*or problem_code ILIKE 'H16.249%' --  unspecified eye*/
-- Phlyctenular keratoconjunctivitis
or problem_code ILIKE 'H16.251%' -- right eye
or problem_code ILIKE 'H16.252%' -- left eye
or problem_code ILIKE 'H16.253%' -- bilateral
/*or problem_code ILIKE 'H16.259%' --  unspecified eye*/
-- Vernal keratoconjunctivitis, with limbar and corneal involvement
or problem_code ILIKE 'H16.261%' -- right eye
or problem_code ILIKE 'H16.262%' -- left eye
or problem_code ILIKE 'H16.263%' -- bilateral
/*or problem_code ILIKE 'H16.269%' --  unspecified eye*/
-- Other keratoconjunctivitis
or problem_code ILIKE 'H16.291%' -- right eye
or problem_code ILIKE 'H16.292%' -- left eye
or problem_code ILIKE 'H16.293%' -- bilateral
/*or problem_code ILIKE 'H16.299%' --  unspecified eye*/
--  Unspecified interstitial keratitis
or problem_code ILIKE 'H16.301%' -- right eye
or problem_code ILIKE 'H16.302%' -- left eye
or problem_code ILIKE 'H16.303%' -- bilateral
/*or problem_code ILIKE 'H16.309%' --  unspecified eye*/
-- Corneal abscess
or problem_code ILIKE 'H16.311%' -- right eye
or problem_code ILIKE 'H16.312%' -- left eye
or problem_code ILIKE 'H16.313%' -- bilateral
/*or problem_code ILIKE 'H16.319%' --  unspecified eye*/
-- Diffuse interstitial keratitis
or problem_code ILIKE 'H16.321%' -- right eye
or problem_code ILIKE 'H16.322%' -- left eye
or problem_code ILIKE 'H16.323%' -- bilateral
/*or problem_code ILIKE 'H16.329%' --  unspecified eye*/
-- Sclerosing keratitis
or problem_code ILIKE 'H16.331%' -- right eye
or problem_code ILIKE 'H16.332%' -- left eye
or problem_code ILIKE 'H16.333%' -- bilateral
/*or problem_code ILIKE 'H16.339%' --  unspecified eye*/
-- Other interstitial and deep keratitis
or problem_code ILIKE 'H16.391%' -- right eye
or problem_code ILIKE 'H16.392%' -- left eye
or problem_code ILIKE 'H16.393%' -- bilateral
/*or problem_code ILIKE 'H16.399%' --  unspecified eye*/
--  Unspecified corneal neovascularization
or problem_code ILIKE 'H16.401%' -- right eye
or problem_code ILIKE 'H16.402%' -- left eye
or problem_code ILIKE 'H16.403%' -- bilateral
/*or problem_code ILIKE 'H16.409%' --  unspecified eye*/
-- Ghost vessels (corneal)
or problem_code ILIKE 'H16.411%' -- right eye
or problem_code ILIKE 'H16.412%' -- left eye
or problem_code ILIKE 'H16.413%' -- bilateral
/*or problem_code ILIKE 'H16.419%' --  unspecified eye*/
-- Pannus (corneal)
or problem_code ILIKE 'H16.421%' -- right eye
or problem_code ILIKE 'H16.422%' -- left eye
or problem_code ILIKE 'H16.423%' -- bilateral
/*or problem_code ILIKE 'H16.429%' --  unspecified eye*/
-- Localized vascularization of cornea
or problem_code ILIKE 'H16.431%' -- right eye
or problem_code ILIKE 'H16.432%' -- left eye
or problem_code ILIKE 'H16.433%' -- bilateral
/*or problem_code ILIKE 'H16.439%' --  unspecified eye*/
-- Deep vascularization of cornea
or problem_code ILIKE 'H16.441%' -- right eye
or problem_code ILIKE 'H16.442%' -- left eye
or problem_code ILIKE 'H16.443%' -- bilateral
/*or problem_code ILIKE 'H16.449%' --  unspecified eye*/
-- Other keratitis
or problem_code ILIKE 'H16.8%'
-- Unspecified keratitis
or problem_code ILIKE 'H16.9%'
-- Other disorders of cornea
	-- Unspecified corneal deposit
or problem_code ILIKE 'H18.001%' -- right eye
or problem_code ILIKE 'H18.002%' -- left eye
or problem_code ILIKE 'H18.003%' -- bilateral
/*or problem_code ILIKE 'H18.009%' --  unspecified eye*/
-- Anterior corneal pigmentations
or problem_code ILIKE 'H18.011%' -- right eye
or problem_code ILIKE 'H18.012%' -- left eye
or problem_code ILIKE 'H18.013%' -- bilateral
/*or problem_code ILIKE 'H18.019%' --  unspecified eye*/
-- Argentous corneal deposits
or problem_code ILIKE 'H18.021%' -- right eye
or problem_code ILIKE 'H18.022%' -- left eye
or problem_code ILIKE 'H18.023%' -- bilateral
/*or problem_code ILIKE 'H18.029%' --  unspecified eye*/
-- Corneal deposits in metabolic disorders
or problem_code ILIKE 'H18.031%' -- right eye
or problem_code ILIKE 'H18.032%' -- left eye
or problem_code ILIKE 'H18.033%' -- bilateral
/*or problem_code ILIKE 'H18.039%' --  unspecified eye*/
-- Kayser-Fleischer ring
or problem_code ILIKE 'H18.041%' -- right eye
or problem_code ILIKE 'H18.042%' -- left eye
or problem_code ILIKE 'H18.043%' -- bilateral
/*or problem_code ILIKE 'H18.049%' --  unspecified eye*/
-- Posterior corneal pigmentations
or problem_code ILIKE 'H18.051%' -- right eye
or problem_code ILIKE 'H18.052%' -- left eye
or problem_code ILIKE 'H18.053%' -- bilateral
/*or problem_code ILIKE 'H18.059%' --  unspecified eye*/
-- Stromal corneal pigmentations
or problem_code ILIKE 'H18.061%' -- right eye
or problem_code ILIKE 'H18.062%' -- left eye
or problem_code ILIKE 'H18.063%' -- bilateral
/*or problem_code ILIKE 'H18.069%' -- unspecified eye*/
-- Bullous keratopathy
or problem_code ILIKE 'H18.11%' -- right eye
or problem_code ILIKE 'H18.12%' -- left eye
or problem_code ILIKE 'H18.13%' -- bilateral
/*or problem_code ILIKE 'H18.10%' -- unspecified eye*/
-- Unspecified corneal edema
or problem_code ILIKE 'H18.20%'
-- Corneal edema secondary to contact lens
or problem_code ILIKE 'H18.211%' -- right eye
or problem_code ILIKE 'H18.212%' -- left eye
or problem_code ILIKE 'H18.213%' -- bilateral
/*or problem_code ILIKE 'H18.219%' -- unspecified eye*/
-- Idiopathic corneal edema
or problem_code ILIKE 'H18.221%' -- right eye
or problem_code ILIKE 'H18.222%' -- left eye
or problem_code ILIKE 'H18.223%' -- bilateral
/*or problem_code ILIKE 'H18.229%' -- unspecified eye*/
-- Secondary corneal edema
or problem_code ILIKE 'H18.221%' -- right eye
or problem_code ILIKE 'H18.222%' -- left eye
or problem_code ILIKE 'H18.223%' -- bilateral
/*or problem_code ILIKE 'H18.229%' -- unspecified eye*/
-- Unspecified corneal membrane change
or problem_code ILIKE 'H18.30%' 
-- Folds and rupture in Bowman's membrane
or problem_code ILIKE 'H18.311%' -- right eye
or problem_code ILIKE 'H18.312%' -- left eye
or problem_code ILIKE 'H18.313%' -- bilateral
/*or problem_code ILIKE 'H18.319%' -- unspecified eye*/
-- Folds in Descemet's membrane
or problem_code ILIKE 'H18.321%' -- right eye
or problem_code ILIKE 'H18.322%' -- left eye
or problem_code ILIKE 'H18.323%' -- bilateral
/*or problem_code ILIKE 'H18.329%' -- unspecified eye*/
-- Rupture in Descemet's membrane
or problem_code ILIKE 'H18.331%' -- right eye
or problem_code ILIKE 'H18.332%' -- left eye
or problem_code ILIKE 'H18.333%' -- bilateral
/*or problem_code ILIKE 'H18.339%' -- unspecified eye*/
-- Unspecified corneal degeneration
or problem_code ILIKE 'H18.40%' 
-- Arcus senilis
or problem_code ILIKE 'H18.411%' -- right eye
or problem_code ILIKE 'H18.412%' -- left eye
or problem_code ILIKE 'H18.413%' -- bilateral
/*or problem_code ILIKE 'H18.419%' -- unspecified eye*/
-- Band keratopathy
or problem_code ILIKE 'H18.421%' -- right eye
or problem_code ILIKE 'H18.422%' -- left eye
or problem_code ILIKE 'H18.423%' -- bilateral
/*or problem_code ILIKE 'H18.429%' -- unspecified eye*/
-- Other calcerous corneal degeneration
or problem_code ILIKE 'H18.43%'
-- Keratomalacia
or problem_code ILIKE 'H18.441%' -- right eye
or problem_code ILIKE 'H18.442%' -- left eye
or problem_code ILIKE 'H18.443%' -- bilateral
/*or problem_code ILIKE 'H18.449%' -- unspecified eye*/
-- Nodular corneal degeneration
or problem_code ILIKE 'H18.451%' -- right eye
or problem_code ILIKE 'H18.452%' -- left eye
or problem_code ILIKE 'H18.453%' -- bilateral
/*or problem_code ILIKE 'H18.459%' -- unspecified eye*/
-- Peripheral corneal degeneration
or problem_code ILIKE 'H18.461%' -- right eye
or problem_code ILIKE 'H18.462%' -- left eye
or problem_code ILIKE 'H18.463%' -- bilateral
/*or problem_code ILIKE 'H18.469%' -- unspecified eye*/
-- Other corneal degeneration
or problem_code ILIKE 'H18.49%'
-- Unspecified hereditary corneal dystrophies
or problem_code ILIKE 'H18.501%' -- right eye
or problem_code ILIKE 'H18.502%' -- left eye
or problem_code ILIKE 'H18.503%' -- bilateral
/*or problem_code ILIKE 'H18.509%' -- unspecified eye*/
-- Endothelial corneal dystrophy
or problem_code ILIKE 'H18.511%' -- right eye
or problem_code ILIKE 'H18.512%' -- left eye
or problem_code ILIKE 'H18.513%' -- bilateral
/*or problem_code ILIKE 'H18.519%' -- unspecified eye*/
-- Epithelial (juvenile) corneal dystrophy
or problem_code ILIKE 'H18.521%' -- right eye
or problem_code ILIKE 'H18.522%' -- left eye
or problem_code ILIKE 'H18.523%' -- bilateral
/*or problem_code ILIKE 'H18.529%' -- unspecified eye*/
-- Granular corneal dystrophy
or problem_code ILIKE 'H18.531%' -- right eye
or problem_code ILIKE 'H18.532%' -- left eye
or problem_code ILIKE 'H18.533%' -- bilateral
/*or problem_code ILIKE 'H18.539%' -- unspecified eye*/
-- Lattice corneal dystrophy
or problem_code ILIKE 'H18.541%' -- right eye
or problem_code ILIKE 'H18.542%' -- left eye
or problem_code ILIKE 'H18.543%' -- bilateral
/*or problem_code ILIKE 'H18.549%' -- unspecified eye*/
-- Macular corneal dystrophy
or problem_code ILIKE 'H18.551%' -- right eye
or problem_code ILIKE 'H18.552%' -- left eye
or problem_code ILIKE 'H18.553%' -- bilateral
/*or problem_code ILIKE 'H18.559%' -- unspecified eye*/
-- Other hereditary corneal dystrophies
or problem_code ILIKE 'H18.591%' -- right eye
or problem_code ILIKE 'H18.592%' -- left eye
or problem_code ILIKE 'H18.593%' -- bilateral
/*or problem_code ILIKE 'H18.599%' -- unspecified eye*/
-- Keratoconus, unspecified
or problem_code ILIKE 'H18.601%' -- right eye
or problem_code ILIKE 'H18.602%' -- left eye
or problem_code ILIKE 'H18.603%' -- bilateral
/*or problem_code ILIKE 'H18.609%' -- unspecified eye*/
-- Keratoconus, stable
or problem_code ILIKE 'H18.611%' -- right eye
or problem_code ILIKE 'H18.612%' -- left eye
or problem_code ILIKE 'H18.613%' -- bilateral
/*or problem_code ILIKE 'H18.619%' -- unspecified eye*/
-- Keratoconus, unstable
or problem_code ILIKE 'H18.621%' -- right eye
or problem_code ILIKE 'H18.622%' -- left eye
or problem_code ILIKE 'H18.623%' -- bilateral
/*or problem_code ILIKE 'H18.629%' -- unspecified eye*/
-- Unspecified corneal deformity
or problem_code ILIKE 'H18.70%'
-- Corneal ectasia
or problem_code ILIKE 'H18.711%' -- right eye
or problem_code ILIKE 'H18.712%' -- left eye
or problem_code ILIKE 'H18.713%' -- bilateral
/*or problem_code ILIKE 'H18.719%' -- unspecified eye*/
--  Corneal staphyloma
or problem_code ILIKE 'H18.721%' -- right eye
or problem_code ILIKE 'H18.722%' -- left eye
or problem_code ILIKE 'H18.723%' -- bilateral
/*or problem_code ILIKE 'H18.729%' -- unspecified eye*/
-- Descemetocele
or problem_code ILIKE 'H18.731%' -- right eye
or problem_code ILIKE 'H18.732%' -- left eye
or problem_code ILIKE 'H18.733%' -- bilateral
/*or problem_code ILIKE 'H18.739%' -- unspecified eye*/
-- Other corneal deformities
or problem_code ILIKE 'H18.791%' -- right eye
or problem_code ILIKE 'H18.792%' -- left eye
or problem_code ILIKE 'H18.793%' -- bilateral
/*or problem_code ILIKE 'H18.799%' -- unspecified eye*/
-- Anesthesia and hypoesthesia of cornea
or problem_code ILIKE 'H18.811%' -- right eye
or problem_code ILIKE 'H18.812%' -- left eye
or problem_code ILIKE 'H18.813%' -- bilateral
/*or problem_code ILIKE 'H18.819%' -- unspecified eye*/
-- Corneal disorder due to contact lens
or problem_code ILIKE 'H18.821%' -- right eye
or problem_code ILIKE 'H18.822%' -- left eye
or problem_code ILIKE 'H18.823%' -- bilateral
/*or problem_code ILIKE 'H18.829%' -- unspecified eye*/
-- Recurrent erosion of cornea
or problem_code ILIKE 'H18.831%' -- right eye
or problem_code ILIKE 'H18.832%' -- left eye
or problem_code ILIKE 'H18.833%' -- bilateral
/*or problem_code ILIKE 'H18.839%' -- unspecified eye*/
-- Other specified disorders of cornea
or problem_code ILIKE 'H18.891%' -- right eye
or problem_code ILIKE 'H18.892%' -- left eye
or problem_code ILIKE 'H18.893%' -- bilateral
/*or problem_code ILIKE 'H18.899%' -- unspecified eye*/
-- Unspecified disorder of cornea
or problem_code ILIKE 'H18.9%' 
-- Viral conjunctivitis
or problem_code ILIKE 'B30.%' 
-- Leprosy
or problem_code ILIKE '030.%' 
-- Diseases due to other mycobacteria
or problem_code ILIKE '031.%' 
-- Diphtheria 
or problem_code ILIKE '032.0%' -- Faucial diphtheria
or problem_code ILIKE '032.1%' -- Nasopharyngeal diphtheria
or problem_code ILIKE '032.2%' -- Anterior nasal diphtheria
or problem_code ILIKE '032.3%' -- Laryngeal diphtheria
or problem_code ILIKE '032.81%' -- Conjunctival diphtheria
or problem_code ILIKE '032.82%' -- Diphtheritic myocarditis
or problem_code ILIKE '032.83%' -- Diphtheritic peritonitis
or problem_code ILIKE '032.84%' -- Diphtheritic cystitis
or problem_code ILIKE '032.85%' -- Cutaneous diphtheria
or problem_code ILIKE '032.89%' -- Other specified diphtheria
or problem_code ILIKE '032.9%' -- Diphtheria, unspecified
-- Whooping cough
or problem_code ILIKE '033.%' 
-- Streptococcal sore throat and scarlet fever
or problem_code ILIKE '034.%' 
-- Erysipelas 
or problem_code ILIKE '035%' 
-- Meningococcal infection
or problem_code ILIKE '036.0%' -- Meningococcal meningitis
or problem_code ILIKE '036.1%' -- Meningococcal encephalitis
or problem_code ILIKE '036.2%' -- Meningococcemia
or problem_code ILIKE '036.3%' -- Waterhouse-Friderichsen syndrome, meningococcal
or problem_code ILIKE '036.40%' -- Meningococcal carditis, unspecified
or problem_code ILIKE '036.41%' -- Meningococcal pericarditis
or problem_code ILIKE '036.42%' -- Meningococcal endocarditis
or problem_code ILIKE '036.43%' -- Meningococcal myocarditis
or problem_code ILIKE '036.81%' -- Meningococcal optic neuritis
or problem_code ILIKE '036.82%' -- Meningococcal arthropathy
or problem_code ILIKE '036.89%' -- Other specified meningococcal infections
or problem_code ILIKE '036.9%' -- Meningococcal infection, unspecified
-- Tetanus 
or problem_code ILIKE '037%'
-- Streptococcal septicemia
or problem_code ILIKE '038.0%'
-- Staphylococcal septicemia
or problem_code ILIKE '038.10%' -- Staphylococcal septicemia, unspecified
or problem_code ILIKE '038.11%' -- Methicillin susceptible Staphylococcus aureus septicemia
or problem_code ILIKE '038.12%' -- Methicillin resistant Staphylococcus aureus septicemia 
or problem_code ILIKE '038.19%' -- Other staphylococcal septicemia
-- Pneumococcal septicemia [Streptococcus pneumoniae septicemia]
or problem_code ILIKE '038.2%' 
-- Septicemia due to anaerobes
or problem_code ILIKE '038.3%' 
-- Septicemia due to other gram-negative organisms
or problem_code ILIKE '038.40%' -- Septicemia due to gram-negative organism, unspecified 
or problem_code ILIKE '038.41%' -- Septicemia due to hemophilus influenzae [H. influenzae]
or problem_code ILIKE '038.42%' -- Septicemia due to escherichia coli [E. coli]
or problem_code ILIKE '038.43%' -- Septicemia due to pseudomonas
or problem_code ILIKE '038.44%' -- Septicemia due to serratia
or problem_code ILIKE '038.49%' -- Other septicemia due to gram-negative organisms
-- Other specified septicemias
or problem_code ILIKE '038.8%'
-- Unspecified septicemia
or problem_code ILIKE '038.9%'
-- Actinomycotic infections
or problem_code ILIKE '039.%'
-- Other bacterial diseases
or problem_code ILIKE '040.0%' -- Gas gangrene
or problem_code ILIKE '040.1%' -- Rhinoscleroma
or problem_code ILIKE '040.2%' -- Whipple's disease
or problem_code ILIKE '040.3%' -- Necrobacillosis
or problem_code ILIKE '040.41%' -- Infant botulism
or problem_code ILIKE '040.42%' -- Wound botulism
or problem_code ILIKE '040.81%' -- Tropical pyomyositis
or problem_code ILIKE '040.82%' -- Toxic shock syndrome
or problem_code ILIKE '040.89%' -- Other specified bacterial diseases
-- Bacterial infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.00%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, unspecified
or problem_code ILIKE '041.01%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group A
or problem_code ILIKE '041.02%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group B
or problem_code ILIKE '041.03%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group C
or problem_code ILIKE '041.04%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group D
or problem_code ILIKE '041.05%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group G
or problem_code ILIKE '041.09%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, other streptococcus
-- Staphylococcus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.10%' -- Staphylococcus infection in conditions classified elsewhere and of unspecified site, staphylococcus, unspecified
or problem_code ILIKE '041.11%' -- Methicillin susceptible Staphylococcus aureus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.12%' -- Methicillin resistant Staphylococcus aureus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.19%' -- Staphylococcus infection in conditions classified elsewhere and of unspecified site, other staphylococcus
-- Pneumococcus infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.2%'
-- Friedländer's bacillus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.3%'
-- Escherichia coli [e. coli] infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.41%' -- Shiga toxin-producing Escherichia coli [E. coli] (STEC) O157
or problem_code ILIKE '041.42%' -- Other specified Shiga toxin-producing Escherichia coli [E. coli] (STEC)
or problem_code ILIKE '041.43%' -- Shiga toxin-producing Escherichia coli [E. coli] (STEC), unspecified
or problem_code ILIKE '041.49%' -- Other and unspecified Escherichia coli [E. coli]
-- Hemophilus influenzae [H. influenzae] infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.5%' 
-- Proteus (mirabilis) (morganii) infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.6%' 
-- Pseudomonas infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.7%' 
-- Other specified bacterial infections in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.81%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, mycoplasma
or problem_code ILIKE '041.82%' -- Bacteroides fragilis
or problem_code ILIKE '041.83%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, Clostridium perfringens
or problem_code ILIKE '041.84%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other anaerobes
or problem_code ILIKE '041.85%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other gram-negative organisms
or problem_code ILIKE '041.86%' -- Helicobacter pylori [H. pylori] 
or problem_code ILIKE '041.89%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other specified bacteria
-- Bacterial infection, unspecified, in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.9%'
-- Human immunodeficiency virus [HIV] disease 
or problem_code ILIKE '042%'
-- Smallpox
or problem_code ILIKE '050.0%' -- Variola major
or problem_code ILIKE '050.1%' -- Alastrim
or problem_code ILIKE '050.2%' -- Modified smallpox
or problem_code ILIKE '050.9%' -- Smallpox, unspecified
-- Cowpox and paravaccinia 
or problem_code ILIKE '051.01%' -- Cowpox
or problem_code ILIKE '051.02%' -- Vaccinia not from vaccination 
or problem_code ILIKE '051.1%' -- Pseudocowpox
or problem_code ILIKE '051.2%' --  Contagious pustular dermatitis
or problem_code ILIKE '051.9%' -- Paravaccinia, unspecified
-- Chickenpox
or problem_code ILIKE '052.%'
-- Herpes zoster
or problem_code ILIKE '053.0%' -- Herpes zoster with meningitis
or problem_code ILIKE '053.10%' -- Herpes zoster with unspecified nervous system complication
or problem_code ILIKE '053.11%' -- Geniculate herpes zoster 
or problem_code ILIKE '053.12%' -- Postherpetic trigeminal neuralgia
or problem_code ILIKE '053.13%' -- Postherpetic polyneuropathy
or problem_code ILIKE '053.14%' -- Herpes zoster myelitis
or problem_code ILIKE '053.19%' -- Herpes zoster with other nervous system complications 
or problem_code ILIKE '053.20%' -- Herpes zoster dermatitis of eyelid
or problem_code ILIKE '053.21%' -- Herpes zoster keratoconjunctivitis
or problem_code ILIKE '053.22%' -- Herpes zoster iridocyclitis
or problem_code ILIKE '053.29%' -- Herpes zoster with other ophthalmic complications
or problem_code ILIKE '053.71%' -- Otitis externa due to herpes zoster
or problem_code ILIKE '053.79%' -- Herpes zoster with other specified complications
-- Herpes zoster with unspecified complication
or problem_code ILIKE '053.8%' 
-- Herpes zoster without mention of complication
or problem_code ILIKE '053.9%' 
-- Herpes simplex
or problem_code ILIKE '054.0%' -- Eczema herpeticum
or problem_code ILIKE '054.10%' -- Genital herpes, unspecified 
or problem_code ILIKE '054.11%' -- Herpetic vulvovaginitis
or problem_code ILIKE '054.12%' -- Herpetic ulceration of vulva
or problem_code ILIKE '054.13%' -- Herpetic infection of penis
or problem_code ILIKE '054.19%' -- Other genital herpes 
-- Herpetic gingivostomatitis
or problem_code ILIKE '054.2%'
-- Herpetic meningoencephalitis
or problem_code ILIKE '054.3%'
-- Herpes simplex with ophthalmic complications
or problem_code ILIKE '054.40%' -- Herpes simplex with unspecified ophthalmic complication
or problem_code ILIKE '054.41%' -- Herpes simplex dermatitis of eyelid
or problem_code ILIKE '054.42%' -- Dendritic keratitis
or problem_code ILIKE '054.43%' -- Herpes simplex disciform keratitis
or problem_code ILIKE '054.44%' -- Herpes simplex iridocyclitis
or problem_code ILIKE '054.49%' -- Herpes simplex with other ophthalmic complications 
-- Herpetic septicemia
or problem_code ILIKE '054.5%'
-- Herpetic whitlow
or problem_code ILIKE '054.6%'
-- Herpes simplex with other specified complications
or problem_code ILIKE '054.71%' -- Visceral herpes simplex
or problem_code ILIKE '054.72%' -- Herpes simplex meningitis 
or problem_code ILIKE '054.73%' -- Herpes simplex otitis externa 
or problem_code ILIKE '054.74%' -- Herpes simplex myelitis
or problem_code ILIKE '054.79%' -- Herpes simplex with other specified complications
-- Herpes simplex with unspecified complication
or problem_code ILIKE '054.8%' 
-- Herpes simplex without mention of complication
or problem_code ILIKE '054.9%'
-- Measles
or problem_code ILIKE '055.0%' -- Postmeasles encephalitis
or problem_code ILIKE '055.1%' -- Postmeasles pneumonia
or problem_code ILIKE '055.2%' -- Postmeasles otitis media
-- Measles with other specified complications
or problem_code ILIKE '055.71%' -- Measles keratoconjunctivitis
or problem_code ILIKE '055.79%' -- Measles with other specified complications
-- Measles with unspecified complication
or problem_code ILIKE '055.8%' 
-- Measles without mention of complication
or problem_code ILIKE '055.9%' 
-- Rubella
or problem_code ILIKE '056.00%' -- Rubella with unspecified neurological complication
or problem_code ILIKE '056.01%' -- Encephalomyelitis due to rubella
or problem_code ILIKE '056.09%' -- Rubella with other neurological complications 
-- Rubella with other specified complications
or problem_code ILIKE '056.71%' -- Arthritis due to rubella
or problem_code ILIKE '056.79%' -- Rubella with other specified complications
--  Rubella with unspecified complications
or problem_code ILIKE '056.8%'
-- Rubella without mention of complication
or problem_code ILIKE '056.9%'
-- Other viral exanthemata
or problem_code ILIKE '057.0%' -- Erythema infectiosum (fifth disease)
or problem_code ILIKE '057.8%' -- Other specified viral exanthemata
or problem_code ILIKE '057.9%' -- Viral exanthem, unspecified
-- Other human herpesvirus
or problem_code ILIKE '058.10%' -- Roseola infantum, unspecified
or problem_code ILIKE '058.11%' -- Roseola infantum due to human herpesvirus 6
or problem_code ILIKE '058.12%' -- Roseola infantum due to human herpesvirus 7
--  Other human herpesvirus encephalitis
or problem_code ILIKE '058.21%' -- Human herpesvirus 6 encephalitis
or problem_code ILIKE '058.29%' -- Other human herpesvirus encephalitis
--Other human herpesvirus infections
or problem_code ILIKE '058.81%' -- Human herpesvirus 6 infection
or problem_code ILIKE '058.82%' -- Human herpesvirus 7 infection
or problem_code ILIKE '058.89%' -- Other human herpesvirus infection
-- Other poxvirus infections
or problem_code ILIKE '059.00%' -- Orthopoxvirus infection, unspecified
or problem_code ILIKE '059.01%' -- Monkeypox
or problem_code ILIKE '059.09%' -- Other orthopoxvirus infections
or problem_code ILIKE '059.10%' -- Parapoxvirus infection, unspecified
or problem_code ILIKE '059.11%' -- Bovine stomatitis
or problem_code ILIKE '059.12%' -- Sealpox
or problem_code ILIKE '059.19%' -- Other parapoxvirus infections
or problem_code ILIKE '059.20%' -- Yatapoxvirus infection, unspecified
or problem_code ILIKE '059.21%' -- Tanapox 
or problem_code ILIKE '059.22%' -- Yaba monkey tumor virus
or problem_code ILIKE '059.8%' -- Other poxvirus infections
or problem_code ILIKE '059.9%' -- Poxvirus infections, unspecified
-- Yellow fever
or problem_code ILIKE '060.%' 
-- Dengue 
or problem_code ILIKE '061%' 
-- Mosquito-borne viral encephalitis
or problem_code ILIKE '062.%' 
-- Tick-borne viral encephalitis
or problem_code ILIKE '063.%' 
-- Viral encephalitis transmitted by other and unspecified arthropods 
or problem_code ILIKE '064%' 
-- Arthropod-borne hemorrhagic fever
or problem_code ILIKE '065.%'
-- Other arthropod-borne viral diseases
or problem_code ILIKE '066.0%' -- Phlebotomus fever
or problem_code ILIKE '066.1%' -- Tick-borne fever
or problem_code ILIKE '066.2%' -- Venezuelan equine fever
or problem_code ILIKE '066.3%' -- Other mosquito-borne fever
or problem_code ILIKE '066.40%' -- West Nile Fever, unspecified
or problem_code ILIKE '066.41%' -- West Nile Fever with encephalitis
or problem_code ILIKE '066.42%' -- West Nile Fever with other neurologic manifestation
or problem_code ILIKE '066.49%' -- West Nile Fever with other complications
-- Other specified arthropod-borne viral diseases
or problem_code ILIKE '066.8%'
-- Arthropod-borne viral disease, unspecified
-- Other specified arthropod-borne viral diseases
or problem_code ILIKE '066.9%'
-- Viral hepatitis
or problem_code ILIKE '070.0%' -- Viral hepatitis A with hepatic coma
or problem_code ILIKE '070.1%' -- Viral hepatitis A without mention of hepatic coma
-- Viral hepatitis b with hepatic coma
or problem_code ILIKE '070.20%' -- Viral hepatitis B with hepatic coma, acute or unspecified, without mention of hepatitis delta
or problem_code ILIKE '070.21%' -- Viral hepatitis B with hepatic coma, acute or unspecified, with hepatitis delta
or problem_code ILIKE '070.22%' -- Chronic viral hepatitis B with hepatic coma without hepatitis delta
or problem_code ILIKE '070.23%' -- Chronic viral hepatitis B with hepatic coma with hepatitis delta 
-- Viral hepatitis b without mention of hepatic coma
or problem_code ILIKE '070.30%' -- Viral hepatitis B without mention of hepatic coma, acute or unspecified, without mention of hepatitis delta
or problem_code ILIKE '070.31%' -- Viral hepatitis B without mention of hepatic coma, acute or unspecified, with hepatitis delta
or problem_code ILIKE '070.32%' -- Chronic viral hepatitis B without mention of hepatic coma without mention of hepatitis delta
or problem_code ILIKE '070.33%' -- Chronic viral hepatitis B without mention of hepatic coma with hepatitis delta
-- Other specified viral hepatitis with hepatic coma
or problem_code ILIKE '070.41%' -- Acute hepatitis C with hepatic coma
or problem_code ILIKE '070.42%' -- Hepatitis delta without mention of active hepatitis B disease with hepatic coma
or problem_code ILIKE '070.43%' -- Hepatitis E with hepatic coma
or problem_code ILIKE '070.44%' -- Chronic hepatitis C with hepatic coma
or problem_code ILIKE '070.49%' -- Other specified viral hepatitis with hepatic coma 
-- Other specified viral hepatitis without mention of hepatic coma
or problem_code ILIKE '070.51%' -- Acute hepatitis C without mention of hepatic coma
or problem_code ILIKE '070.52%' -- Hepatitis delta without mention of active hepatitis B disease or hepatic coma
or problem_code ILIKE '070.53%' -- Hepatitis E without mention of hepatic coma
or problem_code ILIKE '070.54%' -- Chronic hepatitis C without mention of hepatic coma
or problem_code ILIKE '070.59%' -- Other specified viral hepatitis without mention of hepatic coma
-- Unspecified viral hepatitis with hepatic coma
or problem_code ILIKE '070.6%' 
-- Unspecified viral hepatitis c
or problem_code ILIKE '070.70%' -- Unspecified viral hepatitis C without hepatic coma 
or problem_code ILIKE '070.71%' -- Unspecified viral hepatitis C with hepatic coma
-- Unspecified viral hepatitis without mention of hepatic coma
or problem_code ILIKE '070.9%'
-- Rabies 
or problem_code ILIKE '071%'
-- Mumps
or problem_code ILIKE '072.0%' -- Mumps orchitis
or problem_code ILIKE '072.1%' -- Mumps meningitis
or problem_code ILIKE '072.2%' -- Mumps encephalitis
or problem_code ILIKE '072.3%' -- Mumps pancreatitis
-- Mumps with other specified complications
or problem_code ILIKE '072.71%' -- Mumps hepatitis
or problem_code ILIKE '072.72%' -- Mumps polyneuropathy
or problem_code ILIKE '072.79%' -- Other mumps with other specified complications
-- Mumps with unspecified complication
or problem_code ILIKE '072.8%' 
-- Mumps without mention of complication
or problem_code ILIKE '072.9%' 
-- Ornithosis 
or problem_code ILIKE '073.%' 
-- Specific diseases due to coxsackie virus
or problem_code ILIKE '074.0%' -- Herpangina
or problem_code ILIKE '074.1%' -- Epidemic pleurodynia
-- Coxsackie carditis
or problem_code ILIKE '074.20%' -- Coxsackie carditis, unspecified
or problem_code ILIKE '074.21%' -- Coxsackie pericarditis
or problem_code ILIKE '074.22%' -- Coxsackie endocarditis
or problem_code ILIKE '074.23%' -- Coxsackie myocarditis
-- Hand, foot, and mouth disease
or problem_code ILIKE '074.3%' 
-- Other specified diseases due to Coxsackie virus
or problem_code ILIKE '074.8%' 
-- Infectious mononucleosis 
or problem_code ILIKE '075%' 
-- Trachoma
or problem_code ILIKE '076.%' 
-- Other diseases of conjunctiva due to viruses and chlamydiae
or problem_code ILIKE '077.0%' -- Inclusion conjunctivitis
or problem_code ILIKE '077.1%' -- Epidemic keratoconjunctivitis
or problem_code ILIKE '077.2%' -- Pharyngoconjunctival fever
or problem_code ILIKE '077.3%' -- Other adenoviral conjunctivitis
or problem_code ILIKE '077.4%' -- Epidemic hemorrhagic conjunctivitis
or problem_code ILIKE '077.8%' -- Other viral conjunctivitis
-- Unspecified diseases of conjunctiva due to viruses and chlamydiae
or problem_code ILIKE '077.98%' -- Unspecified diseases of conjunctiva due to chlamydiae
or problem_code ILIKE '077.99%' -- Unspecified diseases of conjunctiva due to viruses
-- Other diseases due to viruses and chlamydiae 
or problem_code ILIKE '078.0%' -- Molluscum contagiosum
-- Viral warts
or problem_code ILIKE '078.10%' -- Viral warts, unspecified
or problem_code ILIKE '078.11%' -- Condyloma acuminatum
or problem_code ILIKE '078.12%' -- Plantar wart
or problem_code ILIKE '078.19%' -- Other specified viral warts
-- Sweating fever 
or problem_code ILIKE '078.2%'
-- Cat-scratch disease
or problem_code ILIKE '078.3%'
-- Foot and mouth disease
or problem_code ILIKE '078.4%'
-- Cytomegaloviral disease
or problem_code ILIKE '078.5%'
-- Hemorrhagic nephrosonephritis
or problem_code ILIKE '078.6%'
-- Arenaviral hemorrhagic fever
or problem_code ILIKE '078.7%'
-- Other specified diseases due to viruses and chlamydiae
or problem_code ILIKE '078.81%' -- Epidemic vertigo
or problem_code ILIKE '078.82%' -- Epidemic vomiting syndrome
or problem_code ILIKE '078.88%' -- Other specified diseases due to chlamydiae
or problem_code ILIKE '078.89%' -- Other specified diseases due to viruses
-- Viral and chlamydial infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.0%' -- Adenovirus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.1%' -- Echo virus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.2%' -- Coxsackie virus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.3%' -- Rhinovirus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.4%' -- Human papillomavirus in conditions classified elsewhere and of unspecified site
-- Retrovirus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.50%' -- Retrovirus, unspecified
or problem_code ILIKE '079.51%' -- Human T-cell lymphotrophic virus, type I [HTLV-I]
or problem_code ILIKE '079.52%' -- Human T-cell lymphotrophic virus, type II [HTLV-II]
or problem_code ILIKE '079.53%' -- Human immunodeficiency virus, type 2 [HIV-2]
or problem_code ILIKE '079.59%' -- Other specified retrovirus
--  Respiratory syncytial virus (RSV)
or problem_code ILIKE '079.6%' 
-- Other specified viral and chlamydial infections
or problem_code ILIKE '079.81%' -- Hantavirus infection
or problem_code ILIKE '079.82%' -- SARS-associated coronavirus
or problem_code ILIKE '079.83%' -- Parvovirus B19
or problem_code ILIKE '079.88%' -- Other specified chlamydial infection
or problem_code ILIKE '079.89%' -- Other specified viral infection
-- Unspecified viral and chlamydial infections
or problem_code ILIKE '079.98%' -- Unspecified chlamydial infection
or problem_code ILIKE '079.99%' -- Unspecified viral infection
-- Congenital syphilis
or problem_code ILIKE '090.0%' -- Early congenital syphilis, symptomatic
or problem_code ILIKE '090.1%' -- Early congenital syphilis, latent
or problem_code ILIKE '090.2%' -- Early congenital syphilis, unspecified
or problem_code ILIKE '090.3%' -- Syphilitic interstitial keratitis
-- Juvenile neurosyphilis
or problem_code ILIKE '090.40%' -- Juvenile neurosyphilis, unspecified
or problem_code ILIKE '090.41%' -- Congenital syphilitic encephalitis
or problem_code ILIKE '090.42%' -- Congenital syphilitic meningitis
or problem_code ILIKE '090.49%' -- Other juvenile neurosyphilis
-- Other late congenital syphilis, symptomatic
or problem_code ILIKE '090.5%'
-- Late congenital syphilis, latent
or problem_code ILIKE '090.6%'
-- Late congenital syphilis, unspecified 
or problem_code ILIKE '090.7%'
-- Congenital syphilis, unspecified
or problem_code ILIKE '090.9%'
-- Early syphilis symptomatic
or problem_code ILIKE '091.0%' -- Genital syphilis (primary)
or problem_code ILIKE '091.1%' -- Primary anal syphilis 
or problem_code ILIKE '091.2%' -- Other primary syphilis
or problem_code ILIKE '091.3%' -- Secondary syphilis of skin or mucous membranes
or problem_code ILIKE '091.4%' -- Adenopathy due to secondary syphilis
-- Uveitis due to secondary syphilis
or problem_code ILIKE '091.50%' -- Syphilitic uveitis, unspecified
or problem_code ILIKE '091.51%' -- Syphilitic chorioretinitis (secondary)
or problem_code ILIKE '091.52%' -- Syphilitic iridocyclitis (secondary)
-- Secondary syphilis of viscera and bone
or problem_code ILIKE '091.61%' -- Secondary syphilitic periostitis
or problem_code ILIKE '091.62%' -- Secondary syphilitic hepatitis
or problem_code ILIKE '091.69%' -- Secondary syphilis of other viscera
-- Secondary syphilis, relapse
or problem_code ILIKE '091.7%'
-- Other forms of secondary syphilis
or problem_code ILIKE '091.81%' -- Acute syphilitic meningitis (secondary)
or problem_code ILIKE '091.82%' -- Syphilitic alopecia
or problem_code ILIKE '091.89%' -- Other forms of secondary syphilis
-- Unspecified secondary syphilis
or problem_code ILIKE '091.9%'
-- Early syphilis latent
or problem_code ILIKE '092.%'
-- Cardiovascular syphilis
or problem_code ILIKE '093.0%' -- Aneurysm of aorta, specified as syphilitic
or problem_code ILIKE '093.1%' -- Syphilitic aortitis
-- Syphilitic endocarditis
or problem_code ILIKE '093.20%' -- Syphilitic endocarditis of valve, unspecified 
or problem_code ILIKE '093.21%' -- Syphilitic endocarditis of mitral valve
or problem_code ILIKE '093.22%' -- Syphilitic endocarditis of aortic valve
or problem_code ILIKE '093.23%' -- Syphilitic endocarditis of tricuspid valve
or problem_code ILIKE '093.24%' -- Syphilitic endocarditis of pulmonary valve
--  Other specified cardiovascular syphilis
or problem_code ILIKE '093.81%' -- Syphilitic pericarditis
or problem_code ILIKE '093.82%' -- Syphilitic myocarditis
or problem_code ILIKE '093.89%' -- Other specified cardiovascular syphilis
-- Cardiovascular syphilis, unspecified
or problem_code ILIKE '093.9%'
-- Neurosyphilis 
or problem_code ILIKE '094.0%' -- Tabes dorsalis
or problem_code ILIKE '094.1%' -- General paresis
or problem_code ILIKE '094.2%' -- Syphilitic meningitis
or problem_code ILIKE '094.3%' -- Asymptomatic neurosyphilis
-- Other specified neurosyphilis
or problem_code ILIKE '094.81%' -- Syphilitic encephalitis
or problem_code ILIKE '094.82%' -- Syphilitic parkinsonism 
or problem_code ILIKE '094.83%' -- Syphilitic disseminated retinochoroiditis
or problem_code ILIKE '094.84%' -- Syphilitic optic atrophy
or problem_code ILIKE '094.85%' -- Syphilitic retrobulbar neuritis
or problem_code ILIKE '094.86%' -- Syphilitic acoustic neuritis
or problem_code ILIKE '094.87%' -- Syphilitic ruptured cerebral aneurysm
or problem_code ILIKE '094.89%' -- Other specified neurosyphilis
-- Neurosyphilis, unspecified
or problem_code ILIKE '094.9%'
-- Other forms of late syphilis with symptoms
or problem_code ILIKE '095.%'
-- Late syphilis, latent 
or problem_code ILIKE '096%'
-- Other and unspecified syphilis
or problem_code ILIKE '097.%'
-- Gonococcal infections
--Gonococcal infection (acute) of lower genitourinary tract
or problem_code ILIKE '098.0%' -- Gonococcal infection (acute) of lower genitourinary tract
-- Gonococcal infection (acute) of upper genitourinary tract
or problem_code ILIKE '098.10%' -- Gonococcal infection (acute) of upper genitourinary tract, site unspecified
or problem_code ILIKE '098.11%' -- Gonococcal cystitis (acute)
or problem_code ILIKE '098.12%' -- Gonococcal prostatitis (acute)
or problem_code ILIKE '098.13%' -- Gonococcal epididymo-orchitis (acute)
or problem_code ILIKE '098.14%' -- Gonococcal seminal vesiculitis (acute)
or problem_code ILIKE '098.15%' -- Gonococcal cervicitis (acute)
or problem_code ILIKE '098.16%' -- Gonococcal endometritis (acute)
or problem_code ILIKE '098.17%' -- Gonococcal salpingitis, specified as acute
or problem_code ILIKE '098.19%' -- Other gonococcal infection (acute) of upper genitourinary tract
-- Gonococcal infection, chronic, of lower genitourinary tract
or problem_code ILIKE '098.2%'
--Gonococcal infection chronic of upper genitourinary tract
or problem_code ILIKE '098.30%' -- Chronic gonococcal infection of upper genitourinary tract, site unspecified 
or problem_code ILIKE '098.31%' -- Gonococcal cystitis, chronic
or problem_code ILIKE '098.32%' -- Gonococcal prostatitis, chronic
or problem_code ILIKE '098.33%' -- Gonococcal epididymo-orchitis, chronic
or problem_code ILIKE '098.34%' -- Gonococcal seminal vesiculitis, chronic
or problem_code ILIKE '098.35%' -- Gonococcal cervicitis, chronic
or problem_code ILIKE '098.36%' -- Gonococcal endometritis, chronic
or problem_code ILIKE '098.37%' -- Gonococcal salpingitis (chronic) 
or problem_code ILIKE '098.39%' -- Other chronic gonococcal infection of upper genitourinary tract
-- Gonococcal infection of eye
or problem_code ILIKE '098.40%' -- Gonococcal conjunctivitis (neonatorum)
or problem_code ILIKE '098.41%' -- Gonococcal iridocyclitis
or problem_code ILIKE '098.42%' -- Gonococcal endophthalmia 
or problem_code ILIKE '098.43%' -- Gonococcal keratitis
or problem_code ILIKE '098.49%' -- Other gonococcal infection of eye
-- Gonococcal infection of joint
or problem_code ILIKE '098.50%' -- Gonococcal arthritis
or problem_code ILIKE '098.51%' -- Gonococcal synovitis and tenosynovitis
or problem_code ILIKE '098.52%' -- Gonococcal bursitis
or problem_code ILIKE '098.53%' -- Gonococcal spondylitis
or problem_code ILIKE '098.59%' -- Other gonococcal infection of joint 
-- Gonococcal infection of pharynx
or problem_code ILIKE '098.6%'
-- Gonococcal infection of anus and rectum
or problem_code ILIKE '098.7%'
-- Gonococcal infection of other specified sites
or problem_code ILIKE '098.81%' -- Gonococcal keratosis (blennorrhagica)
or problem_code ILIKE '098.82%' -- Gonococcal meningitis
or problem_code ILIKE '098.83%' -- Gonococcal pericarditis
or problem_code ILIKE '098.84%' -- Gonococcal endocarditis
or problem_code ILIKE '098.85%' -- Other gonococcal heart disease
or problem_code ILIKE '098.86%' -- Gonococcal peritonitis
or problem_code ILIKE '098.89%' -- Gonococcal infection of other specified sites
-- Other venereal diseases
or problem_code ILIKE '099.0%' -- Chancroid
or problem_code ILIKE '099.1%' -- Lymphogranuloma venereum
or problem_code ILIKE '099.2%' -- Granuloma inguinale
or problem_code ILIKE '099.3%' -- Reiter's disease
-- Other nongonococcal urethritis
or problem_code ILIKE '099.40%' -- Other nongonococcal urethritis, unspecified
or problem_code ILIKE '099.41%' -- Other nongonococcal urethritis, chlamydia trachomatis
or problem_code ILIKE '099.49%' -- Other nongonococcal urethritis, other specified organism
--Other venereal diseases due to chlamydia trachomatis
or problem_code ILIKE '099.50%' -- Other venereal diseases due to chlamydia trachomatis, unspecified site
or problem_code ILIKE '099.51%' -- Other venereal diseases due to chlamydia trachomatis, pharynx
or problem_code ILIKE '099.52%' -- Other venereal diseases due to chlamydia trachomatis, anus and rectum
or problem_code ILIKE '099.53%' -- Other venereal diseases due to chlamydia trachomatis, lower genitourinary sites
or problem_code ILIKE '099.54%' -- Other venereal diseases due to chlamydia trachomatis, other genitourinary sites
or problem_code ILIKE '099.55%' -- Other venereal diseases due to chlamydia trachomatis, unspecified genitourinary site
or problem_code ILIKE '099.56%' -- Other venereal diseases due to chlamydia trachomatis, peritoneum
or problem_code ILIKE '099.59%' -- Other venereal diseases due to chlamydia trachomatis, other specified site
--Other specified venereal diseases
or problem_code ILIKE '099.8%'
-- Venereal disease, unspecified 
or problem_code ILIKE '099.9%'
-- Dermatophytosis
or problem_code ILIKE '110.%'
-- Dermatomycosis other and unspecified
or problem_code ILIKE '111.%'
-- Candidiasis
or problem_code ILIKE '112.0%' -- Candidiasis of mouth
or problem_code ILIKE '112.1%' -- Candidiasis of vulva and vagina
or problem_code ILIKE '112.2%' -- Candidiasis of other urogenital sites
or problem_code ILIKE '112.3%' -- Candidiasis of skin and nails
or problem_code ILIKE '112.4%' -- Candidiasis of lung
or problem_code ILIKE '112.5%' -- Disseminated candidiasis
-- Candidiasis of other specified sites
or problem_code ILIKE '112.81%' -- Candidal endocarditis
or problem_code ILIKE '112.82%' -- Candidal otitis externa
or problem_code ILIKE '112.83%' -- Candidal meningitis
or problem_code ILIKE '112.84%' -- Candidal esophagitis
or problem_code ILIKE '112.85%' -- Candidal enteritis
or problem_code ILIKE '112.89%' -- Other candidiasis of other specified sites
-- Candidiasis of unspecified site
or problem_code ILIKE '112.9%' 
-- Coccidioidomycosis
or problem_code ILIKE '114.%' 
-- Histoplasmosis
or problem_code ILIKE '115.00%' -- Infection by Histoplasma capsulatum, without mention of manifestation
or problem_code ILIKE '115.01%' -- Infection by Histoplasma capsulatum, meningitis
or problem_code ILIKE '115.02%' -- Infection by Histoplasma capsulatum, retinitis
or problem_code ILIKE '115.03%' -- Infection by Histoplasma capsulatum, pericarditis
or problem_code ILIKE '115.04%' -- Infection by Histoplasma capsulatum, endocarditis
or problem_code ILIKE '115.05%' -- Infection by Histoplasma capsulatum, pneumonia
or problem_code ILIKE '115.09%' -- Infection by Histoplasma capsulatum, other 
-- Infection by histoplasma duboisii
or problem_code ILIKE '115.10%' -- Infection by Histoplasma duboisii, without mention of manifestation
or problem_code ILIKE '115.11%' -- Infection by Histoplasma duboisii, meningitis
or problem_code ILIKE '115.12%' -- Infection by Histoplasma duboisii, retinitis
or problem_code ILIKE '115.13%' -- Infection by Histoplasma duboisii, pericarditis
or problem_code ILIKE '115.14%' -- Infection by Histoplasma duboisii, endocarditis
or problem_code ILIKE '115.15%' -- Infection by Histoplasma duboisii, pneumonia
or problem_code ILIKE '115.19%' -- Infection by Histoplasma duboisii, other
-- Histoplasmosis unspecified
or problem_code ILIKE '115.90%' -- Histoplasmosis, unspecified, without mention of manifestation
or problem_code ILIKE '115.91%' -- Histoplasmosis, unspecified, meningitis
or problem_code ILIKE '115.92%' -- Histoplasmosis, unspecified, retinitis
or problem_code ILIKE '115.93%' -- Histoplasmosis, unspecified, pericarditis
or problem_code ILIKE '115.94%' -- Histoplasmosis, unspecified, endocarditis
or problem_code ILIKE '115.95%' -- Histoplasmosis, unspecified, pneumonia
or problem_code ILIKE '115.99%' -- Histoplasmosis, unspecified, other
-- Blastomycotic infection 
or problem_code ILIKE '116.%'
-- Other mycoses
or problem_code ILIKE '117.%'
-- Opportunistic mycoses 
or problem_code ILIKE '118%'
-- Schistosomiasis (bilharziasis) 
or problem_code ILIKE '120%'
-- Other trematode infections
or problem_code ILIKE '121.%'
-- Echinococcosis
or problem_code ILIKE '122.%'
-- Other cestode infection 
or problem_code ILIKE '123.%'
-- Trichinosis
or problem_code ILIKE '124%'
-- Filarial infection and dracontiasis
or problem_code ILIKE '125.%'
-- Ancylostomiasis and necatoriasis
or problem_code ILIKE '126.%'
-- Other intestinal helminthiases
or problem_code ILIKE '127.%'
-- Other and unspecified helminthiases
or problem_code ILIKE '128.%'
-- Intestinal parasitism, unspecified 
or problem_code ILIKE '129%'
-- Other and unspecified infectious and parasitic diseases
or problem_code ILIKE '136.0%' -- Ainhum
or problem_code ILIKE '136.1%' -- Behcet's syndrome 
-- Specific infections by free-living amebae
or problem_code ILIKE '136.21%' -- Specific infection due to acanthamoeba
or problem_code ILIKE '136.29%' -- Other specific infections by free-living amebae
-- Pneumocystosis
or problem_code ILIKE '136.3%'
-- Psorospermiasis
or problem_code ILIKE '136.4%'
-- Sarcosporidiosis
or problem_code ILIKE '136.5%'
-- Other specified infectious and parasitic diseases
or problem_code ILIKE '136.8%'
-- Unspecified infectious and parasitic diseases
or problem_code ILIKE '136.9%'
-- Corneal staphyloma
or problem_code ILIKE '371.73%'
-- Infection with drug-resistant microorganisms 
or problem_code ILIKE 'V09.0%' -- Infection with microorganisms resistant to penicillins
or problem_code ILIKE 'V09.1%' -- Infection with microorganisms resistant to cephalosporins and other B-lactam antibiotics
or problem_code ILIKE 'V09.2%' -- Infection with microorganisms resistant to macrolides
or problem_code ILIKE 'V09.3%' -- Infection with microorganisms resistant to tetracyclines 
or problem_code ILIKE 'V09.4%' -- Infection with microorganisms resistant to aminoglycosides
-- Infection with microorganisms resistant to quinolones and fluoroquinolones
or problem_code ILIKE 'V09.50%' -- Infection with microorganisms without mention of resistance to multiple quinolones and fluroquinolones
or problem_code ILIKE 'V09.51%' -- Infection with microorganisms with resistance to multiple quinolones and fluroquinolones
-- Infection with microorganisms resistant to sulfonamides
or problem_code ILIKE 'V09.6%' 
-- Infection with microorganisms resistant to other specified antimycobacterial agents
or problem_code ILIKE 'V09.70%' -- Infection with microorganisms without mention of resistance to multiple antimycobacterial agents
or problem_code ILIKE 'V09.71%' -- Infection with microorganisms with resistance to multiple antimycobacterial agents
-- Infection with microorganisms resistant to other specified drugs
or problem_code ILIKE 'V09.80%' -- Infection with microorganisms without mention of resistance to multiple drugs
or problem_code ILIKE 'V09.81%' -- Infection with microorganisms with resistance to multiple drugs
-- Infection with drug-resistant microorganisms unspecified
or problem_code ILIKE 'V09.90%' -- Infection with drug-resistant microorganisms, unspecified, without mention of multiple drug resistance
or problem_code ILIKE 'V09.91%' -- Infection with drug-resistant microorganisms, unspecified, with multiple drug resistance
and (diag_eye='1' or diag_eye='2' or  diag_eye='3')
and extract(year from diagnosis_date) BETWEEN 2015 and 2018));



drop table if exists aao_grants.liet_diag_pull_new2;
create table aao_grants.liet_diag_pull_new2 as
(select distinct patient_guid,
case when (documentation_date > problem_onset_date) and problem_onset_date is not null then problem_onset_date
when (problem_onset_date > documentation_date) and documentation_date is not null then documentation_date
when problem_onset_date is null then documentation_date
when documentation_date is null then problem_onset_date
when documentation_date=problem_onset_date then documentation_date
end as diagnosis_date,
case when diag_eye='1' then 1
when diag_eye='2' then 2
when diag_eye='3' then 1
end as eye,
practice_id,
case
				when (problem_description ilike '%without CSME%' 
				or problem_description ilike '428341000124108' 
				or problem_description ilike '%Non-Center Involved Diabetic Macular Edema%' 
				or problem_description ilike '%no evidence of clinically significant macular edema%' 
				or problem_description ilike '%Borderline CSME%' 
				or problem_description ilike '%No SRH/SRF/Lipid/CSME%' 
				or problem_description ilike '%No Clinically Significant Macular Edema%' 
				or problem_description ilike '%No CSME%' 
				or problem_description ilike '%Clinically Significant Macular Edema, Focal%' 
				or problem_description ilike '%Borderline Clinically Significant Macular Edema%' 
				or problem_description ilike '%(-) CSME%' 
				or problem_description ilike '%w/o CSME%' 
				or problem_description ilike '%CSME  (?)%'  
				or problem_description ilike '%?CSME%' 
				or problem_description ilike '%No CSME/DME%'  
				or problem_description ilike '%(--) CSME%'
				or problem_description ilike '%No NPDR (diabetic retinopathy) or CSME%'
				or problem_description ilike '%(-)CSME%' 
				or problem_description ilike '%no heme, exudate, CSME, NVD, NVE%' 
				or problem_description ilike '%no_CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%no DR or CSME noted%' 
				or problem_description ilike '%Clinically Significant Macular Edema is absent%' 
				or problem_description ilike '%neg CSME%' 
				or problem_description ilike '%=-CSME%' 
				or problem_description ilike '%no BDR/ CSME%' 
				or problem_description ilike '%diabetes WITHOUT signs of diabetic retinopathy or clinically significant macular edema%' 
				or problem_description ilike '%no macular edema%' 
				or problem_description ilike '%no diabetic retinopathy, NVE, NVD or CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%Non-Center-Involved Diabetic Macular Edema%' 
				or problem_description ilike '%No DME or CSME%' 
				or problem_description ilike '%NO   CSME%' 
				or problem_description ilike '%No CSME-DME%' 
				or problem_description ilike '%No Diabetic Retinopathy or CSME%' 
				or problem_description ilike '%no heme,exudates,or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%no diabetic retinopathy or CSME%' 
				or problem_description ilike '%no NV/CSME%' 
				or problem_description ilike '%No BDR, CSME, NVD, NVE, NVE%' 
				or problem_description ilike '%CSME -' 
				or problem_description ilike '%(-) BDR or CSME%'
				or problem_description ilike '%(-)BDR or CSME%'
				or problem_description ilike '%without Clinically Significant Macular Edema%'
				or problem_description ilike '%Diabetes without retinopathy or clinically significant macular edema%') then 0
				
				when (problem_description ilike 'CSME%' 
				or problem_description ilike 'Clinically Significant Macular Edema%' 
				or problem_description ilike '%with clinically significant macular edema%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF RIGHT EYE DETERMINED BY EXAMINATION%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF LEFT EYE DETERMINED BY EXAMINATION%'
				or problem_description ilike 'Center Involved Diabetic Macular Edema%' 
				or problem_description ilike 'CSME (Diabetes Related Mac. Edema)%' 
				or problem_description ilike 'Clinically Significant Macular Edema, Diffuse%' 
				or problem_description ilike 'CSME_clinically significant macular edema%' 
				or problem_description ilike 'EDEMA-CSME%'  
				or problem_description ilike 'Clinically significant macular edema (disorder)%' 
				or problem_description ilike 'edema CSME%' 
				or problem_description ilike 'CSME (Clinically Significant  Mac. Edema)%' 
				or problem_description ilike '%has developed CSME%' 
				or problem_description ilike '%(+) CSME%' 
				or problem_description ilike 'Diabetes - CSME (250.52) (OCT)%' 
				or problem_description ilike 'Clinically significant macular edema of right eye%' 
				or problem_description ilike 'Clinically significant macular edema of left eye%' 
				or problem_description ilike 'CSME (H35.81%)' 
				or problem_description ilike '%management of clinically significant macular edema%' 
				or problem_description ilike '%with CSME%' 
				or problem_description ilike 'Clinically significant macular edema associated with type 2 diabetes%' 
				or problem_description ilike 'Center-Involved Diabetic Macular Edema%'
				or problem_description ilike 'On examination - clinically significant macular edema of left eye%' 
				or problem_description ilike 'On examination - clinically significant macular edema of right eye%') then 1
				
				when (problem_comment ilike '%no clinically significant macular edema%' 
				or problem_comment ilike '%no CSME%' 
				or problem_comment ilike '%negative CSME%' 
				or problem_comment ilike '%No NVD, NVE, Vit Hem or CSME%' 
				or problem_comment ilike '%(-)CSME%' 
				or problem_comment ilike '%No NVD/NVE/CSME%' 
				or problem_comment ilike '%CSMEnegative%' 
				or problem_comment ilike '%No Diabetic Retinopathy, macular edema or CSME%' 
				or problem_comment ilike '%=-CSME%' 
				or problem_comment ilike '%no BDR, CSME, NVE%' 
				or problem_comment ilike '%(-) CSME%' 
				or problem_comment ilike '%no hemorrhages, exudates, pigmentary changes or macular edemano clinically significant macular edema%' 
				or problem_comment ilike '%no clinically significant macular edemanegative%' 
				or problem_comment ilike '%no hemorrhage or exudatesno clinically significant macular edema%' 
				or problem_comment ilike '%no signs of clinically significant macular edema%' 
				or problem_comment ilike '%clinically significant macular edemanegative%' 
				or problem_comment ilike '%Mild NPDR without macular edema or CSME%' 
				or problem_comment ilike '%no MAs, DBH, or CSME%' 
				or problem_comment ilike '%no signs of neovascularization or clinically significant macular edema%' 
				or problem_comment ilike '%retinopathyno clinically significant macular edema%' 
				or problem_comment ilike '%without clinically significant macular edema%' 
				or problem_comment ilike '%No diabetic retinopathy or clinically significant macular edema%' 
				or problem_comment ilike '%No NVE/CSME%' 
				or problem_comment ilike '%no MA, DBH, NV, CSME%' 
				or problem_comment ilike '%No MAs, heme or CSME%' 
				or problem_comment ilike '%=- CSME%' 
				or problem_comment ilike '%No DR or CSME%' 
				or problem_comment ilike '?CSME%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%No NPDR, PDR, or CSME%' 
				or problem_comment ilike '%without CSME%' 
				or problem_comment ilike '%w/o  CSME%' 
				or problem_comment ilike '%borderline CSME%' 
				or problem_comment ilike '%Negative CSME%' 
				or problem_comment ilike '%CSME - neg%' 
				or problem_comment ilike '%neg. CSME%' 
				or problem_comment ilike '%(-)NPDR/PDR/CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%No signs of CSME%' 
				or problem_comment ilike '%mild CSME%' 
				or problem_comment ilike '%negative BDR, CSME%' 
				or problem_comment ilike '%CSMEabsent%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%no retinopathy, CSME or neovascularization%' 
				or problem_comment ilike '%without macular edema or CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%? CSME%' 
				or problem_comment ilike '%Neg CSME%' 
				or problem_comment ilike '%CSMEno%' 
				or problem_comment ilike '%no MAs, heme or CSME%' 
				or problem_comment ilike '-CSME%'
				or problem_comment ilike '%No signs of Retinopathy or neovascularization, or CSME%') then 0
				
				when (problem_comment ilike 'clinically significant macular edema%'
				or problem_comment ilike 'CSME%' 
				or problem_comment ilike 'DM, CSME%'
				or problem_comment ilike '%Diabetic Retinopathy With CSME%' 
				or problem_comment ilike '%=+ CSME%' 
				or problem_comment ilike '%=+CSME%' 
				or problem_comment ilike '%Mild non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME diabetic retinopathy%' 
				or problem_comment ilike '%Proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME (clinically significant macular edema%)' 
				or problem_comment ilike '%Moderate non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike '%no evidence of non-proliferative diabetic retinopathy or clinically significant macular edema%') then 1
				else 99 end as csme_status
				
from madrid2.patient_problem_laterality
-- ICD-10
-- Leprosy [Hansen's disease]
WHERE (
problem_code ILIKE 'A30.%'
-- Infection due to other mycobacteria
or problem_code ILIKE 'A31.%'
-- Listeriosis
or problem_code ILIKE 'A32.0%' -- Cutaneous listeriosis
-- Listerial meningitis and meningoencephalitis
or problem_code ILIKE 'A32.11%' -- Listerial meningitis
or problem_code ILIKE 'A32.12%' -- Listerial meningoencephalitis
-- Listerial sepsis
or problem_code ILIKE 'A32.7%'
-- Other forms of listeriosis
or problem_code ILIKE 'A32.81%' -- Oculoglandular listeriosis
or problem_code ILIKE 'A32.82%' -- Listerial endocarditis
or problem_code ILIKE 'A32.89%' -- Other forms of listeriosis
-- Listeriosis, unspecified
or problem_code ILIKE 'A32.9%'
-- Tetanus neonatorum 
or problem_code ILIKE 'A33%'
-- Obstetrical tetanus 
or problem_code ILIKE 'A34%'
-- Other tetanus 
or problem_code ILIKE 'A35%'
-- Diphtheria
or problem_code ILIKE 'A36.0%' -- Pharyngeal diphtheria
or problem_code ILIKE 'A36.1%' -- Nasopharyngeal diphtheria
or problem_code ILIKE 'A36.2%' -- Laryngeal diphtheria
or problem_code ILIKE 'A36.3%' -- Cutaneous diphtheria
-- Other diphtheria
or problem_code ILIKE 'A36.81%' -- Diphtheritic cardiomyopathy
or problem_code ILIKE 'A36.82%' -- Diphtheritic radiculomyelitis
or problem_code ILIKE 'A36.83%' -- Diphtheritic polyneuritis
or problem_code ILIKE 'A36.84%' -- Diphtheritic tubulo-interstitial nephropathy
or problem_code ILIKE 'A36.85%' -- Diphtheritic cystitis
or problem_code ILIKE 'A36.86%' -- Diphtheritic conjunctivitis
or problem_code ILIKE 'A36.89%' -- Other diphtheritic complications
-- Diphtheria, unspecified
or problem_code ILIKE 'A36.9%'
-- Whooping cough
-- Whooping cough due to Bordetella pertussis
or problem_code ILIKE 'A37.00%' -- without pneumonia
or problem_code ILIKE 'A37.01%' -- with pneumonia
-- Whooping cough due to Bordetella parapertussis
or problem_code ILIKE 'A37.10%' -- without pneumonia
or problem_code ILIKE 'A37.11%' -- with pneumonia
--  Whooping cough due to other Bordetella species
or problem_code ILIKE 'A37.80%' -- without pneumonia
or problem_code ILIKE 'A37.81%' -- with pneumonia
-- Whooping cough, unspecified species
or problem_code ILIKE 'A37.90%' -- without pneumonia
or problem_code ILIKE 'A37.91%' -- with pneumonia
-- Scarlet fever 
or problem_code ILIKE 'A38.%' 
-- Meningococcal infection
or problem_code ILIKE 'A39.0%' -- Meningococcal meningitis
or problem_code ILIKE 'A39.1%' -- Waterhouse-Friderichsen syndrome
or problem_code ILIKE 'A39.2%' -- Acute meningococcemia
or problem_code ILIKE 'A39.3%' -- Chronic meningococcemia
or problem_code ILIKE 'A39.4%' -- Meningococcemia, unspecified
-- Meningococcal heart disease
or problem_code ILIKE 'A39.50%' -- Meningococcal carditis, unspecified
or problem_code ILIKE 'A39.51%' --  Meningococcal endocarditis
or problem_code ILIKE 'A39.52%' -- Meningococcal myocarditis
or problem_code ILIKE 'A39.53%' -- Meningococcal pericarditis
-- Other meningococcal infections
or problem_code ILIKE 'A39.81%' -- Meningococcal encephalitis
or problem_code ILIKE 'A39.82%' -- Meningococcal retrobulbar neuritis
or problem_code ILIKE 'A39.83%' -- Meningococcal arthritis
or problem_code ILIKE 'A39.84%' -- Postmeningococcal arthritis
or problem_code ILIKE 'A39.89%' -- Other meningococcal infections
-- Meningococcal infection, unspecified
or problem_code ILIKE 'A39.9%'
-- Streptococcal sepsis
or problem_code ILIKE 'A40.%'
-- Other sepsis 
-- Sepsis due to Staphylococcus aureus
or problem_code ILIKE 'A41.01%' -- Sepsis due to Methicillin susceptible Staphylococcus aureus
or problem_code ILIKE 'A41.02%' --  Sepsis due to Methicillin resistant Staphylococcus aureus
-- Sepsis due to other specified staphylococcus
or problem_code ILIKE 'A41.1%' 
--Sepsis due to unspecified staphylococcus
or problem_code ILIKE 'A41.2%' 
-- Sepsis due to Hemophilus influenzae
or problem_code ILIKE 'A41.3%' 
-- Sepsis due to anaerobes
or problem_code ILIKE 'A41.4%' 
-- Sepsis due to other Gram-negative organisms
or problem_code ILIKE 'A41.50%' -- Gram-negative sepsis, unspecified
or problem_code ILIKE 'A41.51%' -- Sepsis due to Escherichia coli [E. coli]
or problem_code ILIKE 'A41.52%' -- Sepsis due to Pseudomonas
or problem_code ILIKE 'A41.53%' -- Sepsis due to Serratia
or problem_code ILIKE 'A41.59%' -- Other Gram-negative sepsis
-- Other specified sepsis
or problem_code ILIKE 'A41.81%' -- Sepsis due to Enterococcus
or problem_code ILIKE 'A41.89%' -- Other specified sepsis
-- Sepsis, unspecified organism
or problem_code ILIKE 'A41.9%'
-- Actinomycosis
or problem_code ILIKE 'A42.0%' -- Pulmonary actinomycosis
or problem_code ILIKE 'A42.1%' -- Abdominal actinomycosis
or problem_code ILIKE 'A42.2%' -- Cervicofacial actinomycosis
or problem_code ILIKE 'A42.7%' -- Actinomycotic sepsis
-- Other forms of actinomycosis
or problem_code ILIKE 'A42.81%' -- Actinomycotic meningitis
or problem_code ILIKE 'A42.82%' -- Actinomycotic encephalitis
or problem_code ILIKE 'A42.89%' -- Other forms of actinomycosis
-- Actinomycosis, unspecified
or problem_code ILIKE 'A42.9%' 
-- Nocardiosis
or problem_code ILIKE 'A43.%'
-- Bartonellosis
or problem_code ILIKE 'A44.%'
-- Erysipelas 
or problem_code ILIKE 'A46%'
-- Other bacterial diseases, not elsewhere classified
or problem_code ILIKE 'A48.0%' -- Gas gangrene
or problem_code ILIKE 'A48.1%' -- Legionnaires' disease
or problem_code ILIKE 'A48.2%' -- Nonpneumonic Legionnaires' disease [Pontiac fever]
or problem_code ILIKE 'A48.3%' -- Toxic shock syndrome
or problem_code ILIKE 'A48.4%' -- Brazilian purpuric fever
--  Other specified botulism
or problem_code ILIKE 'A48.51%' -- Infant botulism
or problem_code ILIKE 'A48.52%' -- Wound botulism
-- Other specified bacterial diseases
or problem_code ILIKE 'A48.8%'
-- Bacterial infection of unspecified site
-- Staphylococcal infection, unspecified site
or problem_code ILIKE 'A49.01%' -- Methicillin susceptible Staphylococcus aureus infection, unspecified site
or problem_code ILIKE 'A49.02%' -- Methicillin resistant Staphylococcus aureus infection, unspecified site
-- Streptococcal infection, unspecified site
or problem_code ILIKE 'A49.1%' 
-- Hemophilus influenzae infection, unspecified site
or problem_code ILIKE 'A49.2%' 
-- Mycoplasma infection, unspecified site
or problem_code ILIKE 'A49.3%'
-- Other bacterial infections of unspecified site
or problem_code ILIKE 'A49.8%'
-- Bacterial infection, unspecified
or problem_code ILIKE 'A49.9%'
-- Congenital syphilis
-- Early congenital syphilis, symptomatic
or problem_code ILIKE 'A50.01%' -- Early congenital syphilitic oculopathy
or problem_code ILIKE 'A50.02%' -- Early congenital syphilitic osteochondropathy
or problem_code ILIKE 'A50.03%' --  Early congenital syphilitic pharyngitis
or problem_code ILIKE 'A50.04%' -- Early congenital syphilitic pneumonia
or problem_code ILIKE 'A50.05%' -- Early congenital syphilitic rhinitis
or problem_code ILIKE 'A50.06%' -- Early cutaneous congenital syphilis
or problem_code ILIKE 'A50.07%' -- Early mucocutaneous congenital syphilis
or problem_code ILIKE 'A50.08%' -- Early visceral congenital syphilis
or problem_code ILIKE 'A50.09%' -- Other early congenital syphilis, symptomatic
-- Early congenital syphilis, latent
or problem_code ILIKE 'A50.1%'
-- Early congenital syphilis, unspecified
or problem_code ILIKE 'A50.2%'
--  Late congenital syphilitic oculopathy
or problem_code ILIKE 'A50.30%' -- unspecified
or problem_code ILIKE 'A50.31%' -- Late congenital syphilitic interstitial keratitis
or problem_code ILIKE 'A50.32%' -- Late congenital syphilitic chorioretinitis
or problem_code ILIKE 'A50.39%' -- Other late congenital syphilitic oculopathy
-- Late congenital neurosyphilis [juvenile neurosyphilis]
or problem_code ILIKE 'A50.40%' -- Late congenital neurosyphilis, unspecified
or problem_code ILIKE 'A50.41%' -- Late congenital syphilitic meningitis
or problem_code ILIKE 'A50.42%' -- Late congenital syphilitic encephalitis
or problem_code ILIKE 'A50.43%' -- Late congenital syphilitic polyneuropathy
or problem_code ILIKE 'A50.44%' -- Late congenital syphilitic optic nerve atrophy
or problem_code ILIKE 'A50.45%' -- Juvenile general paresis
or problem_code ILIKE 'A50.49%' -- Other late congenital neurosyphilis
-- Other late congenital syphilis, symptomatic
or problem_code ILIKE 'A50.51%' -- Clutton's joints
or problem_code ILIKE 'A50.52%' -- Hutchinson's teeth
or problem_code ILIKE 'A50.53%' -- Hutchinson's triad
or problem_code ILIKE 'A50.54%' -- Late congenital cardiovascular syphilis
or problem_code ILIKE 'A50.55%' -- Late congenital syphilitic arthropathy
or problem_code ILIKE 'A50.56%' -- Late congenital syphilitic osteochondropathy
or problem_code ILIKE 'A50.57%' -- Syphilitic saddle nose
or problem_code ILIKE 'A50.59%' -- Other late congenital syphilis, symptomatic
-- Late congenital syphilis, latent
or problem_code ILIKE 'A50.6%'
-- Late congenital syphilis, unspecified
or problem_code ILIKE 'A50.7%'
-- Congenital syphilis, unspecified
or problem_code ILIKE 'A50.9%'
-- Early syphilis 
or problem_code ILIKE 'A51.0%' -- Primary genital syphilis
or problem_code ILIKE 'A51.1%' -- Primary anal syphilis
or problem_code ILIKE 'A51.2%' -- Primary syphilis of other sites
-- Secondary syphilis of skin and mucous membranes
or problem_code ILIKE 'A51.31%' -- Condyloma latum
or problem_code ILIKE 'A51.32%' -- Syphilitic alopecia
or problem_code ILIKE 'A51.39%' -- Other secondary syphilis of skin
-- Other secondary syphilis
or problem_code ILIKE 'A51.41%' -- Secondary syphilitic meningitis
or problem_code ILIKE 'A51.42%' -- Secondary syphilitic female pelvic disease
or problem_code ILIKE 'A51.43%' -- Secondary syphilitic oculopathy
or problem_code ILIKE 'A51.44%' -- Secondary syphilitic nephritis
or problem_code ILIKE 'A51.45%' -- Secondary syphilitic hepatitis
or problem_code ILIKE 'A51.46%' -- Secondary syphilitic osteopathy
or problem_code ILIKE 'A51.49%' -- Other secondary syphilitic conditions
-- Early syphilis, latent
or problem_code ILIKE 'A51.5%'
-- Early syphilis, unspecified
or problem_code ILIKE 'A51.9%'
-- Late syphilis
-- Cardiovascular and cerebrovascular syphilis
or problem_code ILIKE 'A52.00%' -- Cardiovascular syphilis, unspecified
or problem_code ILIKE 'A52.01%' -- Syphilitic aneurysm of aorta
or problem_code ILIKE 'A52.02%' -- Syphilitic aortitis
or problem_code ILIKE 'A52.03%' -- Syphilitic endocarditis
or problem_code ILIKE 'A52.04%' -- Syphilitic cerebral arteritis
or problem_code ILIKE 'A52.05%' -- Other cerebrovascular syphilis
or problem_code ILIKE 'A52.06%' -- Other syphilitic heart involvement
or problem_code ILIKE 'A52.09%' -- Other cardiovascular syphilis
--  Symptomatic neurosyphilis
or problem_code ILIKE 'A52.10%' -- unspecified
or problem_code ILIKE 'A52.11%' -- Tabes dorsalis
or problem_code ILIKE 'A52.12%' -- Other cerebrospinal syphilis
or problem_code ILIKE 'A52.13%' -- Late syphilitic meningitis
or problem_code ILIKE 'A52.14%' -- Late syphilitic encephalitis
or problem_code ILIKE 'A52.15%' -- Late syphilitic neuropathy
or problem_code ILIKE 'A52.16%' -- Charcôt's arthropathy (tabetic)
or problem_code ILIKE 'A52.17%' -- General paresis
or problem_code ILIKE 'A52.19%' -- Other symptomatic neurosyphilis
-- Asymptomatic neurosyphilis
or problem_code ILIKE 'A52.2%'
-- Neurosyphilis, unspecified
or problem_code ILIKE 'A52.3%'
-- Other symptomatic late syphilis
or problem_code ILIKE 'A52.71%' -- Late syphilitic oculopathy
or problem_code ILIKE 'A52.72%' -- Syphilis of lung and bronchus
or problem_code ILIKE 'A52.73%' -- Symptomatic late syphilis of other respiratory organs
or problem_code ILIKE 'A52.74%' -- Syphilis of liver and other viscera
or problem_code ILIKE 'A52.75%' -- Syphilis of kidney and ureter
or problem_code ILIKE 'A52.76%' -- Other genitourinary symptomatic late syphilis
or problem_code ILIKE 'A52.77%' -- Syphilis of bone and joint
or problem_code ILIKE 'A52.78%' -- Syphilis of other musculoskeletal tissue
or problem_code ILIKE 'A52.79%' -- Other symptomatic late syphilis
-- Late syphilis, latent
or problem_code ILIKE 'A52.8%' 
-- Late syphilis, unspecified
or problem_code ILIKE 'A52.9%'
-- Other and unspecified syphilis
or problem_code ILIKE 'A53.%'
-- Gonococcal infection
-- Gonococcal infection of lower genitourinary tract without periurethral or accessory gland abscess
or problem_code ILIKE 'A54.00%' -- Gonococcal infection of lower genitourinary tract, unspecified
or problem_code ILIKE 'A54.01%' -- Gonococcal cystitis and urethritis, unspecified
or problem_code ILIKE 'A54.02%' -- Gonococcal vulvovaginitis, unspecified
or problem_code ILIKE 'A54.03%' -- Gonococcal cervicitis, unspecified
or problem_code ILIKE 'A54.09%' -- Other gonococcal infection of lower genitourinary tract
-- Gonococcal infection of lower genitourinary tract with periurethral and accessory gland abscess
or problem_code ILIKE 'A54.1%'
-- Gonococcal pelviperitonitis and other gonococcal genitourinary infection
or problem_code ILIKE 'A54.21%' -- Gonococcal infection of kidney and ureter
or problem_code ILIKE 'A54.22%' -- Gonococcal prostatitis
or problem_code ILIKE 'A54.23%' -- Gonococcal infection of other male genital organs
or problem_code ILIKE 'A54.24%' -- Gonococcal female pelvic inflammatory disease
or problem_code ILIKE 'A54.29%' -- Other gonococcal genitourinary infections
-- Gonococcal infection of eye
or problem_code ILIKE 'A54.30%' -- unspecified
or problem_code ILIKE 'A54.31%' -- Gonococcal conjunctivitis
or problem_code ILIKE 'A54.32%' -- Gonococcal iridocyclitis
or problem_code ILIKE 'A54.33%' -- Gonococcal keratitis
or problem_code ILIKE 'A54.39%' -- Other gonococcal eye infection
-- Gonococcal infection of musculoskeletal system
or problem_code ILIKE 'A54.40%' -- unspecified
or problem_code ILIKE 'A54.41%' -- Gonococcal spondylopathy
or problem_code ILIKE 'A54.42%' -- Gonococcal arthritis
or problem_code ILIKE 'A54.43%' -- Gonococcal osteomyelitis
or problem_code ILIKE 'A54.49%' -- Gonococcal infection of other musculoskeletal tissue
-- Gonococcal pharyngitis
or problem_code ILIKE 'A54.5%' 
-- Gonococcal infection of anus and rectum
or problem_code ILIKE 'A54.6%' 
-- Other gonococcal infections
or problem_code ILIKE 'A54.81%' -- Gonococcal meningitis
or problem_code ILIKE 'A54.82%' -- Gonococcal brain abscess
or problem_code ILIKE 'A54.83%' -- Gonococcal heart infection
or problem_code ILIKE 'A54.84%' -- Gonococcal pneumonia
or problem_code ILIKE 'A54.85%' -- Gonococcal peritonitis
or problem_code ILIKE 'A54.86%' -- Gonococcal sepsis
or problem_code ILIKE 'A54.89%' -- Other gonococcal infections
-- Gonococcal infection, unspecified
or problem_code ILIKE 'A54.9%'
-- Chlamydial lymphogranuloma (venereum) 
or problem_code ILIKE 'A55%'
-- Other sexually transmitted chlamydial diseases
-- Chlamydial infection of lower genitourinary tract
or problem_code ILIKE 'A56.00%' -- unspecified
or problem_code ILIKE 'A56.01%' -- Chlamydial cystitis and urethritis
or problem_code ILIKE 'A56.02%' -- Chlamydial vulvovaginitis
or problem_code ILIKE 'A56.09%' -- Other chlamydial infection of lower genitourinary tract
-- Chlamydial infection of pelviperitoneum and other genitourinary organs
or problem_code ILIKE 'A56.11%' -- Chlamydial female pelvic inflammatory disease
or problem_code ILIKE 'A56.19%' -- Other chlamydial genitourinary infection
-- Chlamydial infection of genitourinary tract, unspecified
or problem_code ILIKE 'A56.2%'
-- Chlamydial infection of anus and rectum
or problem_code ILIKE 'A56.3%'
-- Chlamydial infection of pharynx
or problem_code ILIKE 'A56.4%'
-- Sexually transmitted chlamydial infection of other sites
or problem_code ILIKE 'A56.8%'
-- Chancroid 
or problem_code ILIKE 'A57%'
-- Granuloma inguinale 
or problem_code ILIKE 'A58%'
-- Trichomoniasis, unspecified 
or problem_code ILIKE 'A59%'
-- Anogenital herpesviral [herpes simplex] infections
-- Herpesviral infection of genitalia and urogenital tract
or problem_code ILIKE 'A60.00%' -- Herpesviral infection of urogenital system, unspecified
or problem_code ILIKE 'A60.01%' -- Herpesviral infection of penis
or problem_code ILIKE 'A60.02%' -- Herpesviral infection of other male genital organs
or problem_code ILIKE 'A60.03%' -- Herpesviral cervicitis
or problem_code ILIKE 'A60.04%' -- Herpesviral vulvovaginitis
or problem_code ILIKE 'A60.09%' -- Herpesviral infection of other urogenital tract
-- Herpesviral infection of perianal skin and rectum
or problem_code ILIKE 'A60.1%'
-- Anogenital herpesviral infection, unspecified
or problem_code ILIKE 'A60.9%'
-- Other predominantly sexually transmitted diseases, not elsewhere classified 
or problem_code ILIKE 'A63.%'
-- Unspecified sexually transmitted disease 
or problem_code ILIKE 'A64%'
-- Nonvenereal syphilis 
or problem_code ILIKE 'A65%'
-- Yaws 
or problem_code ILIKE 'A66.%'
-- Pinta [carate]
or problem_code ILIKE 'A67.%'
-- Relapsing fevers
or problem_code ILIKE 'A68.%'
-- Other spirochetal infections
or problem_code ILIKE 'A69.0%' -- Necrotizing ulcerative stomatitis
or problem_code ILIKE 'A69.1%' -- Other Vincent's infections
-- Lyme disease
or problem_code ILIKE 'A69.20%' -- unspecified
or problem_code ILIKE 'A69.21%' -- Meningitis due to Lyme disease
or problem_code ILIKE 'A69.22%' -- Other neurologic disorders in Lyme disease
or problem_code ILIKE 'A69.23%' -- Arthritis due to Lyme disease
or problem_code ILIKE 'A69.29%' -- Other conditions associated with Lyme disease
-- Other specified spirochetal infections
or problem_code ILIKE 'A69.8%'
-- Spirochetal infection, unspecified
or problem_code ILIKE 'A69.9%'
-- Chlamydia psittaci infections 
or problem_code ILIKE 'A70%'
-- Trachoma
or problem_code ILIKE 'A71.%'
-- Other diseases caused by chlamydiae
or problem_code ILIKE 'A74.0%' -- Chlamydial conjunctivitis
-- Other chlamydial diseases
or problem_code ILIKE 'A74.81%' -- Chlamydial peritonitis
or problem_code ILIKE 'A74.89%' -- Other chlamydial diseases
-- Chlamydial infection, unspecified
or problem_code ILIKE 'A74.9%'
-- Acute poliomyelitis
or problem_code ILIKE 'A80.0%' -- Acute paralytic poliomyelitis, vaccine-associated
or problem_code ILIKE 'A80.1%' -- Acute paralytic poliomyelitis, wild virus, imported
or problem_code ILIKE 'A80.2%' -- Acute paralytic poliomyelitis, wild virus, indigenous
-- Acute paralytic poliomyelitis, other and unspecified
or problem_code ILIKE 'A80.30%' -- Acute paralytic poliomyelitis, unspecified
or problem_code ILIKE 'A80.39%' -- Other acute paralytic poliomyelitis
-- Acute nonparalytic poliomyelitis
or problem_code ILIKE 'A80.4%'
-- Acute poliomyelitis, unspecified
or problem_code ILIKE 'A80.9%'
-- Atypical virus infections of central nervous system
-- Creutzfeldt-Jakob disease
or problem_code ILIKE 'A81.00%' -- unspecified
or problem_code ILIKE 'A81.01%' -- Variant Creutzfeldt-Jakob disease
or problem_code ILIKE 'A81.09%' -- Other Creutzfeldt-Jakob disease
-- Subacute sclerosing panencephalitis
or problem_code ILIKE 'A81.1%'
-- Progressive multifocal leukoencephalopathy
or problem_code ILIKE 'A81.2%'
-- Other atypical virus infections of central nervous system
or problem_code ILIKE 'A81.81%' -- Kuru
or problem_code ILIKE 'A81.82%' -- Gerstmann-Sträussler-Scheinker syndrome
or problem_code ILIKE 'A81.83%' -- Fatal familial insomnia
or problem_code ILIKE 'A81.89%' -- Other atypical virus infections of central nervous system
-- Atypical virus infection of central nervous system, unspecified
or problem_code ILIKE 'A81.9%'
-- Rabies
or problem_code ILIKE 'A82.%'
-- Mosquito-borne viral encephalitis
or problem_code ILIKE 'A83.%'
-- Tick-borne viral encephalitis
or problem_code ILIKE 'A84.0%' -- Far Eastern tick-borne encephalitis [Russian spring-summer encephalitis]
or problem_code ILIKE 'A84.1%' -- Central European tick-borne encephalitis
-- Other tick-borne viral encephalitis
or problem_code ILIKE 'A84.81%' -- Powassan virus disease
or problem_code ILIKE 'A84.89%' -- Other tick-borne viral encephalitis
-- Tick-borne viral encephalitis, unspecified
or problem_code ILIKE 'A84.9%' 
-- Other viral encephalitis, not elsewhere classified 
or problem_code ILIKE 'A85.%'
-- Unspecified viral encephalitis 
or problem_code ILIKE 'A86%'
-- Viral meningitis
or problem_code ILIKE 'A87.%'
-- Other viral infections of central nervous system, not elsewhere classified 
or problem_code ILIKE 'A88.%'
-- Unspecified viral infection of central nervous system 
or problem_code ILIKE 'A89%'
-- Dengue fever [classical dengue] 
or problem_code ILIKE 'A90%'
-- Dengue hemorrhagic fever 
or problem_code ILIKE 'A91%'
-- Other mosquito-borne viral fevers 
or problem_code ILIKE 'A92.0%' -- Chikungunya virus disease
or problem_code ILIKE 'A92.1%' -- O'nyong-nyong fever
or problem_code ILIKE 'A92.2%' -- Venezuelan equine fever
-- West Nile virus infection
or problem_code ILIKE 'A92.30%' -- unspecified
or problem_code ILIKE 'A92.31%' -- with encephalitis
or problem_code ILIKE 'A92.32%' -- with other neurologic manifestation
or problem_code ILIKE 'A92.39%' -- with other complications
-- Rift Valley fever
or problem_code ILIKE 'A92.4%'
-- Zika virus disease
or problem_code ILIKE 'A92.5%'
-- Other specified mosquito-borne viral fevers
or problem_code ILIKE 'A92.8%'
-- Mosquito-borne viral fever, unspecified
or problem_code ILIKE 'A92.9%'
-- Other arthropod-borne viral fevers, not elsewhere classified 
or problem_code ILIKE 'A93.%'
-- Unspecified arthropod-borne viral fever 
or problem_code ILIKE 'A94%'
-- Yellow fever
or problem_code ILIKE 'A95.%'
-- Arenaviral hemorrhagic fever
or problem_code ILIKE 'A96.%'
-- Other viral hemorrhagic fevers, not elsewhere classified
or problem_code ILIKE 'A98.%'
-- Unspecified viral hemorrhagic fever 
or problem_code ILIKE 'A99%' 
-- Herpesviral [herpes simplex] infections
or problem_code ILIKE 'B00.0%' -- Eczema herpeticum
or problem_code ILIKE 'B00.1%' -- Herpesviral vesicular dermatitis
or problem_code ILIKE 'B00.2%' -- Herpesviral gingivostomatitis and pharyngotonsillitis
or problem_code ILIKE 'B00.3%' -- Herpesviral meningitis
or problem_code ILIKE 'B00.4%' -- Herpesviral encephalitis
-- Herpesviral ocular disease
or problem_code ILIKE 'B00.50%' -- unspecified
or problem_code ILIKE 'B00.51%' -- Herpesviral iridocyclitis
or problem_code ILIKE 'B00.52%' -- Herpesviral keratitis
or problem_code ILIKE 'B00.53%' -- Herpesviral conjunctivitis
or problem_code ILIKE 'B00.59%' -- Other herpesviral disease of eye
-- Disseminated herpesviral disease
or problem_code ILIKE 'B00.7%'
-- Other forms of herpesviral infections
or problem_code ILIKE 'B00.81%' -- Herpesviral hepatitis
or problem_code ILIKE 'B00.82%' -- Herpes simplex myelitis
or problem_code ILIKE 'B00.89%' -- Other herpesviral infection
-- Herpesviral infection, unspecified
or problem_code ILIKE 'B00.9%'
-- Varicella [chickenpox] 
or problem_code ILIKE 'B01.0%' -- Varicella meningitis
--  Varicella encephalitis, myelitis and encephalomyelitis
or problem_code ILIKE 'B01.11%' -- Varicella encephalitis and encephalomyelitis
or problem_code ILIKE 'B01.12%' -- Varicella myelitis
-- Varicella pneumonia
or problem_code ILIKE 'B01.2%'
-- Varicella with other complications
or problem_code ILIKE 'B01.81%' -- Varicella keratitis
or problem_code ILIKE 'B01.89%' -- Other varicella complications
-- Varicella without complication
or problem_code ILIKE 'B01.9%'
-- Zoster [herpes zoster] 
or problem_code ILIKE 'B02.0%' -- Zoster encephalitis
or problem_code ILIKE 'B02.1%' -- Zoster meningitis
-- Zoster with other nervous system involvement
or problem_code ILIKE 'B02.21%' -- Postherpetic geniculate ganglionitis
or problem_code ILIKE 'B02.22%' -- Postherpetic trigeminal neuralgia
or problem_code ILIKE 'B02.23%' -- Postherpetic polyneuropathy
or problem_code ILIKE 'B02.24%' -- Postherpetic myelitis
or problem_code ILIKE 'B02.29%' -- Other postherpetic nervous system involvement
-- Zoster ocular disease
or problem_code ILIKE 'B02.30%' -- unspecified
or problem_code ILIKE 'B02.31%' -- Zoster conjunctivitis
or problem_code ILIKE 'B02.32%' -- Zoster iridocyclitis
or problem_code ILIKE 'B02.33%' -- Zoster keratitis
or problem_code ILIKE 'B02.34%' -- Zoster scleritis
or problem_code ILIKE 'B02.39%' -- Other herpes zoster eye disease
-- Disseminated zoster
or problem_code ILIKE 'B02.7%'
-- Zoster with other complications
or problem_code ILIKE 'B02.8%'
-- Zoster without complications
or problem_code ILIKE 'B02.9%'
-- Smallpox 
or problem_code ILIKE 'B03%'
-- Monkeypox 
or problem_code ILIKE 'B04%'
-- Measles
or problem_code ILIKE 'B05.0%' -- Measles complicated by encephalitis
or problem_code ILIKE 'B05.1%' -- Measles complicated by meningitis
or problem_code ILIKE 'B05.2%' -- Measles complicated by pneumonia
or problem_code ILIKE 'B05.3%' -- Measles complicated by otitis media
or problem_code ILIKE 'B05.4%' -- Measles with intestinal complications
-- Measles with other complications
or problem_code ILIKE 'B05.81%' -- Measles keratitis and keratoconjunctivitis
or problem_code ILIKE 'B05.89%' -- Other measles complications
-- Measles without complication
or problem_code ILIKE 'B05.9%'
-- Rubella [German measles]
or problem_code ILIKE 'B06.00%' -- Rubella with neurological complications
or problem_code ILIKE 'B06.01%' -- Rubella encephalitis
or problem_code ILIKE 'B06.02%' -- Rubella meningitis
or problem_code ILIKE 'B06.09%' -- Other neurological complications of rubella
-- Rubella with other complications
or problem_code ILIKE 'B06.81%' -- Rubella pneumonia
or problem_code ILIKE 'B06.82%' -- Rubella arthritis
or problem_code ILIKE 'B06.89%' -- Other rubella complications
-- Rubella without complication
or problem_code ILIKE 'B06.9%' 
-- Viral warts
or problem_code ILIKE 'B07.%' 
-- Other viral infections characterized by skin and mucous membrane lesions, not elsewhere classified
-- Cowpox and vaccinia not from vaccine
or problem_code ILIKE 'B08.010%' -- Cowpox
or problem_code ILIKE 'B08.011%' -- Vaccinia not from vaccine
-- Orf virus disease
or problem_code ILIKE 'B08.02%'
-- Pseudocowpox [milker's node] 
or problem_code ILIKE 'B08.03%'
-- Paravaccinia, unspecified
or problem_code ILIKE 'B08.04%'
-- Other orthopoxvirus infections
or problem_code ILIKE 'B08.09%'
-- Molluscum contagiosum
or problem_code ILIKE 'B08.1%'
-- Exanthema subitum [sixth disease]
or problem_code ILIKE 'B08.20%' -- unspecified
or problem_code ILIKE 'B08.21%' -- due to human herpesvirus 6
or problem_code ILIKE 'B08.22%' -- due to human herpesvirus 7
-- Erythema infectiosum [fifth disease]
or problem_code ILIKE 'B08.3%'
--  Enteroviral vesicular stomatitis with exanthem
or problem_code ILIKE 'B08.4%'
-- Enteroviral vesicular pharyngitis
or problem_code ILIKE 'B08.5%'
-- Parapoxvirus infections
or problem_code ILIKE 'B08.60%' -- Parapoxvirus infection, unspecified
or problem_code ILIKE 'B08.61%' -- Bovine stomatitis
or problem_code ILIKE 'B08.62%' -- Sealpox
or problem_code ILIKE 'B08.69%' -- Other parapoxvirus infections
-- Yatapoxvirus infections
or problem_code ILIKE 'B08.70%' -- Yatapoxvirus infection, unspecified
or problem_code ILIKE 'B08.71%' -- Tanapox virus disease
or problem_code ILIKE 'B08.72%' -- Yaba pox virus disease
or problem_code ILIKE 'B08.79%' -- Other yatapoxvirus infections
-- Other specified viral infections characterized by skin and mucous membrane lesions
or problem_code ILIKE 'B08.8%'
-- Unspecified viral infection characterized by skin and mucous membrane lesions
or problem_code ILIKE 'B09%'
-- Other human herpesviruses 
or problem_code ILIKE 'B10.01%' --  Human herpesvirus 6 encephalitis
or problem_code ILIKE 'B10.09%' -- Other human herpesvirus encephalitis
-- Other human herpesvirus infection
or problem_code ILIKE 'B10.81%' -- Human herpesvirus 6 infection
or problem_code ILIKE 'B10.82%' -- Human herpesvirus 7 infection
or problem_code ILIKE 'B10.89%' -- Other human herpesvirus infection
-- Acute hepatitis A 
or problem_code ILIKE 'B15.%'
-- Acute hepatitis B
or problem_code ILIKE 'B16.%'
-- Acute delta-(super) infection of hepatitis B carrier
or problem_code ILIKE 'B17.0%' -- Acute delta-(super) infection of hepatitis B carrier
--Acute hepatitis C
or problem_code ILIKE 'B17.10%' -- without hepatic coma
or problem_code ILIKE 'B17.11%' -- with hepatic coma
-- Acute hepatitis E
or problem_code ILIKE 'B17.2%'
-- Other specified acute viral hepatitis
or problem_code ILIKE 'B17.8%'
-- Acute viral hepatitis, unspecified
or problem_code ILIKE 'B17.9%'
-- Chronic viral hepatitis
or problem_code ILIKE 'B18.%'
-- Unspecified viral hepatitis
or problem_code ILIKE 'B19.0%' -- Unspecified viral hepatitis with hepatic coma
-- Unspecified viral hepatitis B
or problem_code ILIKE 'B19.10%' -- without hepatic coma
or problem_code ILIKE 'B19.11%' -- with hepatic coma
-- Unspecified viral hepatitis C
or problem_code ILIKE 'B19.20%' -- without hepatic coma
or problem_code ILIKE 'B19.21%' -- with hepatic coma
-- Unspecified viral hepatitis without hepatic coma
or problem_code ILIKE 'B19.9%'
-- Human immunodeficiency virus [HIV] disease
or problem_code ILIKE 'B20%'
-- Cytomegaloviral disease
or problem_code ILIKE 'B25.%'
-- Mumps 
or problem_code ILIKE 'B26.0%' -- Mumps orchitis
or problem_code ILIKE 'B26.1%' -- Mumps meningitis
or problem_code ILIKE 'B26.2%' -- Mumps encephalitis
or problem_code ILIKE 'B26.3%' -- Mumps pancreatitis
-- Mumps with other complications
or problem_code ILIKE 'B26.81%' -- Mumps hepatitis
or problem_code ILIKE 'B26.82%' -- Mumps myocarditis
or problem_code ILIKE 'B26.83%' -- Mumps nephritis
or problem_code ILIKE 'B26.84%' -- Mumps polyneuropathy
or problem_code ILIKE 'B26.85%' -- Mumps arthritis
or problem_code ILIKE 'B26.89%' -- Other mumps complications
-- Mumps without complication
or problem_code ILIKE 'B26.9%'
-- Infectious mononucleosis
-- Gammaherpesviral mononucleosis
or problem_code ILIKE 'B27.00%' -- without complication
or problem_code ILIKE 'B27.01%' -- with polyneuropathy
or problem_code ILIKE 'B27.02%' -- with meningitis
or problem_code ILIKE 'B27.09%' -- with other complications
-- Cytomegaloviral mononucleosis
or problem_code ILIKE 'B27.10%' -- without complications
or problem_code ILIKE 'B27.11%' -- with polyneuropathy
or problem_code ILIKE 'B27.12%' -- with meningitis
or problem_code ILIKE 'B27.19%' -- with other complication
-- Other infectious mononucleosis
or problem_code ILIKE 'B27.80%' -- without complication
or problem_code ILIKE 'B27.81%' -- with polyneuropathy
or problem_code ILIKE 'B27.82%' -- with meningitis
or problem_code ILIKE 'B27.89%' -- with other complication
-- Infectious mononucleosis, unspecified
or problem_code ILIKE 'B27.90%' -- without complication
or problem_code ILIKE 'B27.91%' -- with polyneuropathy
or problem_code ILIKE 'B27.92%' -- with meningitis
or problem_code ILIKE 'B27.99%' -- with other complication
-- Viral conjunctivitis
or problem_code ILIKE 'B30.%'
-- Other viral diseases, not elsewhere classified
or problem_code ILIKE 'B33.0%' -- Epidemic myalgia
or problem_code ILIKE 'B33.1%' -- Ross River disease
-- Viral carditis
or problem_code ILIKE 'B33.20%' -- unspecified
or problem_code ILIKE 'B33.21%' -- Viral endocarditis
or problem_code ILIKE 'B33.22%' -- Viral myocarditis
or problem_code ILIKE 'B33.23%' -- Viral pericarditis
or problem_code ILIKE 'B33.24%' -- Viral cardiomyopathy
-- Retrovirus infections, not elsewhere classified
or problem_code ILIKE 'B33.3%' 
-- Hantavirus (cardio)-pulmonary syndrome [HPS] [HCPS]
or problem_code ILIKE 'B33.4%'
-- Other specified viral diseases
or problem_code ILIKE 'B33.8%'
-- Viral infection of unspecified site 
or problem_code ILIKE 'B34.%'
-- Dermatophytosis
or problem_code ILIKE 'B35.%'
-- Other superficial mycoses 
or problem_code ILIKE 'B36.%'
-- Candidiasis
or problem_code ILIKE 'B37.0%' -- Candidal stomatitis
or problem_code ILIKE 'B37.1%' -- Pulmonary candidiasis
or problem_code ILIKE 'B37.2%' -- Candidiasis of skin and nail
or problem_code ILIKE 'B37.3%' -- Candidiasis of vulva and vagina
-- Candidiasis of other urogenital sites
or problem_code ILIKE 'B37.41%' -- Candidal cystitis and urethritis
or problem_code ILIKE 'B37.42%' --  Candidal balanitis
or problem_code ILIKE 'B37.49%' -- Other urogenital candidiasis
-- Candidal meningitis
or problem_code ILIKE 'B37.5%'
-- Candidal endocarditis
or problem_code ILIKE 'B37.6%'
-- Candidal sepsis
or problem_code ILIKE 'B37.7%'
-- Candidiasis of other sites
or problem_code ILIKE 'B37.81%' -- Candidal esophagitis
or problem_code ILIKE 'B37.82%' -- Candidal enteritis
or problem_code ILIKE 'B37.83%' -- Candidal cheilitis
or problem_code ILIKE 'B37.84%' -- Candidal otitis externa
or problem_code ILIKE 'B37.89%' -- Other sites of candidiasis
-- Candidiasis, unspecified
or problem_code ILIKE 'B37.9%'
-- Coccidioidomycosis
or problem_code ILIKE 'B38.0%' -- Acute pulmonary coccidioidomycosis
or problem_code ILIKE 'B38.1%' -- Chronic pulmonary coccidioidomycosis
or problem_code ILIKE 'B38.2%' -- Pulmonary coccidioidomycosis, unspecified
or problem_code ILIKE 'B38.3%' -- Cutaneous coccidioidomycosis
or problem_code ILIKE 'B38.4%' -- Coccidioidomycosis meningitis
or problem_code ILIKE 'B38.7%' -- Disseminated coccidioidomycosis
-- Other forms of coccidioidomycosis
or problem_code ILIKE 'B38.81%' -- Prostatic coccidioidomycosis
or problem_code ILIKE 'B38.89%' -- Other forms of coccidioidomycosis
-- Coccidioidomycosis, unspecified
or problem_code ILIKE 'B38.9%'
-- Histoplasmosis
or problem_code ILIKE 'B39.%'
-- Blastomycosis 
or problem_code ILIKE 'B40.0%' -- Acute pulmonary blastomycosis
or problem_code ILIKE 'B40.1%' -- Chronic pulmonary blastomycosis
or problem_code ILIKE 'B40.2%' -- Pulmonary blastomycosis, unspecified
or problem_code ILIKE 'B40.3%' -- Cutaneous blastomycosis
or problem_code ILIKE 'B40.7%' -- Disseminated blastomycosis
--  Other forms of blastomycosis
or problem_code ILIKE 'B40.81%' -- Blastomycotic meningoencephalitis
or problem_code ILIKE 'B40.89%' -- Other forms of blastomycosis
-- Blastomycosis, unspecified
or problem_code ILIKE 'B40.9%'
-- Paracoccidioidomycosis 
or problem_code ILIKE 'B41.%'
-- Sporotrichosis
or problem_code ILIKE 'B42.0%' -- Pulmonary sporotrichosis
or problem_code ILIKE 'B42.1%' -- Lymphocutaneous sporotrichosis
or problem_code ILIKE 'B42.7%' -- Disseminated sporotrichosis
-- Other forms of sporotrichosis
or problem_code ILIKE 'B42.81%' -- Cerebral sporotrichosis
or problem_code ILIKE 'B42.82%' -- Sporotrichosis arthritis
or problem_code ILIKE 'B42.89%' -- Other forms of sporotrichosis
-- Sporotrichosis, unspecified
or problem_code ILIKE 'B42.9%'
-- Chromomycosis and pheomycotic abscess
or problem_code ILIKE 'B43.%'
-- Aspergillosis
or problem_code ILIKE 'B44.0%' -- Invasive pulmonary aspergillosis
or problem_code ILIKE 'B44.1%' -- Other pulmonary aspergillosis
or problem_code ILIKE 'B44.2%' -- Tonsillar aspergillosis
or problem_code ILIKE 'B44.7%' -- Disseminated aspergillosis
-- Other forms of aspergillosis
or problem_code ILIKE 'B44.81%' -- Allergic bronchopulmonary aspergillosis
or problem_code ILIKE 'B44.89%' -- Other forms of aspergillosis
-- Aspergillosis, unspecified
or problem_code ILIKE 'B44.9%'
-- Cryptococcosis 
or problem_code ILIKE 'B45.%'
-- Zygomycosis
or problem_code ILIKE 'B46.%'
-- Mycetoma
or problem_code ILIKE 'B47.%'
-- Other mycoses, not elsewhere classified
or problem_code ILIKE 'B48.%'
-- Unspecified mycosis
or problem_code ILIKE 'B49%'
-- Plasmodium falciparum malaria
or problem_code ILIKE 'B50.%'
-- Plasmodium vivax malaria
or problem_code ILIKE 'B51.%'
-- Plasmodium malariae malaria
or problem_code ILIKE 'B52.%'
-- Other specified malaria
or problem_code ILIKE 'B53.%'
-- Unspecified malaria
or problem_code ILIKE 'B54%'
-- Leishmaniasis
or problem_code ILIKE 'B55.%'
-- African trypanosomiasis
or problem_code ILIKE 'B56.%'
-- Chagas' disease 
or problem_code ILIKE 'B57.0%' -- Acute Chagas' disease with heart involvement
or problem_code ILIKE 'B57.1%' -- Acute Chagas' disease without heart involvement
or problem_code ILIKE 'B57.2%' -- Chagas' disease (chronic) with heart involvement
-- Chagas' disease (chronic) with digestive system involvement
or problem_code ILIKE 'B57.30%' -- Chagas' disease with digestive system involvement, unspecified 
or problem_code ILIKE 'B57.31%' -- Megaesophagus in Chagas' disease
or problem_code ILIKE 'B57.32%' -- Megacolon in Chagas' disease
or problem_code ILIKE 'B57.39%' -- Other digestive system involvement in Chagas' disease
-- Chagas' disease (chronic) with nervous system involvement
or problem_code ILIKE 'B57.40%' -- Chagas' disease with nervous system involvement, unspecified
or problem_code ILIKE 'B57.41%' -- Meningitis in Chagas' disease
or problem_code ILIKE 'B57.42%' -- Meningoencephalitis in Chagas' disease
or problem_code ILIKE 'B57.49%' -- Other nervous system involvement in Chagas' disease
-- Chagas' disease (chronic) with other organ involvement
or problem_code ILIKE 'B57.5%'
-- Toxoplasmosis
-- Toxoplasma oculopathy
or problem_code ILIKE 'B58.00%' -- unspecified
or problem_code ILIKE 'B58.01%' -- Toxoplasma chorioretinitis
or problem_code ILIKE 'B58.09%' -- Other toxoplasma oculopathy
-- Toxoplasma hepatitis
or problem_code ILIKE 'B58.1%'
--  Toxoplasma meningoencephalitis
or problem_code ILIKE 'B58.2%'
-- Pulmonary toxoplasmosis
or problem_code ILIKE 'B58.3%'
-- Toxoplasmosis with other organ involvement
or problem_code ILIKE 'B58.81%' -- Toxoplasma myocarditis
or problem_code ILIKE 'B58.82%' -- Toxoplasma myositis
or problem_code ILIKE 'B58.83%' -- Toxoplasma tubulo-interstitial nephropathy
or problem_code ILIKE 'B58.89%' -- Toxoplasmosis with other organ involvement
-- Toxoplasmosis, unspecified
or problem_code ILIKE 'B58.9%'
-- Pneumocystosis
or problem_code ILIKE 'B59%'
-- Other protozoal diseases, not elsewhere classified
--  Babesiosis
or problem_code ILIKE 'B60.00%' -- unspecified
or problem_code ILIKE 'B60.01%' -- due to Babesia microti
or problem_code ILIKE 'B60.02%' -- due to Babesia duncani
or problem_code ILIKE 'B60.03%' -- due to Babesia divergens
or problem_code ILIKE 'B60.09%' -- Other babesiosis
-- Acanthamebiasis
or problem_code ILIKE 'B60.10%' -- unspecified
or problem_code ILIKE 'B60.11%' -- Meningoencephalitis due to Acanthamoeba (culbertsoni)
or problem_code ILIKE 'B60.12%' -- Conjunctivitis due to Acanthamoeba
or problem_code ILIKE 'B60.13%' -- Keratoconjunctivitis due to Acanthamoeba
or problem_code ILIKE 'B60.19%' -- Other acanthamebic disease
-- Naegleriasis
or problem_code ILIKE 'B60.2%'
-- Other specified protozoal diseases
or problem_code ILIKE 'B60.8%'
-- Unspecified protozoal disease
or problem_code ILIKE 'B64%'
-- Schistosomiasis [bilharziasis]
or problem_code ILIKE 'B65.%'
-- Other fluke infections
or problem_code ILIKE 'B66.%'
-- Echinococcosis
or problem_code ILIKE 'B67.0%' -- Echinococcus granulosus infection of liver
or problem_code ILIKE 'B67.1%' -- Echinococcus granulosus infection of lung
or problem_code ILIKE 'B67.2%' -- Echinococcus granulosus infection of bone
-- Echinococcus granulosus infection, other and multiple sites
or problem_code ILIKE 'B67.31%' -- Echinococcus granulosus infection, thyroid gland
or problem_code ILIKE 'B67.32%' -- Echinococcus granulosus infection, multiple sites
or problem_code ILIKE 'B67.39%' -- Echinococcus granulosus infection, other sites
-- Echinococcus granulosus infection, unspecified
or problem_code ILIKE 'B67.4%' 
-- Echinococcus multilocularis infection of liver
or problem_code ILIKE 'B67.5%'
-- Echinococcus multilocularis infection, other and multiple sites
or problem_code ILIKE 'B67.61%' -- Echinococcus multilocularis infection, multiple sites
or problem_code ILIKE 'B67.69%' -- Echinococcus multilocularis infection, other sites
-- Echinococcus multilocularis infection, unspecified
or problem_code ILIKE 'B67.7%'
-- Echinococcosis, unspecified, of liver
or problem_code ILIKE 'B67.8%'
-- Echinococcosis, other and unspecified
or problem_code ILIKE 'B67.90%' -- Echinococcosis, unspecified
or problem_code ILIKE 'B67.99%' -- Other echinococcosis
-- Taeniasis
or problem_code ILIKE 'B68.%'
-- Cysticercosis
or problem_code ILIKE 'B69.0%' -- Cysticercosis of central nervous system
or problem_code ILIKE 'B69.1%' -- Cysticercosis of eye
--  Cysticercosis of other sites
or problem_code ILIKE 'B69.81%' -- Myositis in cysticercosis
or problem_code ILIKE 'B69.89%' -- Cysticercosis of other sites
-- Cysticercosis, unspecified
or problem_code ILIKE 'B69.9%'
-- Diphyllobothriasis and sparganosis
or problem_code ILIKE 'B70.%'
-- Other cestode infections
or problem_code ILIKE 'B71.%'
-- Dracunculiasis
or problem_code ILIKE 'B72%'
-- Onchocerciasis
-- Onchocerciasis with eye disease
or problem_code ILIKE 'B73.00%' -- Onchocerciasis with eye involvement, unspecified
or problem_code ILIKE 'B73.01%' -- Onchocerciasis with endophthalmitis
or problem_code ILIKE 'B73.02%' -- Onchocerciasis with glaucoma
or problem_code ILIKE 'B73.09%' -- Onchocerciasis with other eye involvement
-- Onchocerciasis without eye disease
or problem_code ILIKE 'B73.1%'
-- Filariasis 
or problem_code ILIKE 'B74.%'
-- Trichinellosis
or problem_code ILIKE 'B75%'
-- Hookworm diseases
or problem_code ILIKE 'B76.%'
-- Ascariasis
or problem_code ILIKE 'B77.0%' -- Ascariasis with intestinal complications
-- Ascariasis with other complications
or problem_code ILIKE 'B77.81%' -- Ascariasis pneumonia
or problem_code ILIKE 'B77.89%' -- Ascariasis with other complications
-- Ascariasis, unspecified
or problem_code ILIKE 'B77.9%'
-- Strongyloidiasis
or problem_code ILIKE 'B78.%'
-- Trichuriasis
or problem_code ILIKE 'B79%'
-- Enterobiasis
or problem_code ILIKE 'B80%'
-- Other intestinal helminthiases, not elsewhere classified 
or problem_code ILIKE 'B81.%'
-- Unspecified intestinal parasitism
or problem_code ILIKE 'B82.%'
-- Other helminthiases 
or problem_code ILIKE 'B83.%'
-- Pediculosis and phthiriasis
or problem_code ILIKE 'B85.%'
-- Scabies
or problem_code ILIKE 'B86%'
-- Myiasis
or problem_code ILIKE 'B87.0%' -- Cutaneous myiasis
or problem_code ILIKE 'B87.1%' -- Wound myiasis
or problem_code ILIKE 'B87.2%' -- Ocular myiasis
or problem_code ILIKE 'B87.3%' -- Nasopharyngeal myiasis
or problem_code ILIKE 'B87.4%' -- Aural myiasis
-- Myiasis of other sites
or problem_code ILIKE 'B87.81%' -- Genitourinary myiasis
or problem_code ILIKE 'B87.82%' -- Intestinal myiasis
or problem_code ILIKE 'B87.89%' -- Myiasis of other sites
-- Myiasis, unspecified
or problem_code ILIKE 'B87.9%'
-- Other infestations
or problem_code ILIKE 'B88.%'
-- Unspecified parasitic disease
or problem_code ILIKE 'B89%'
-- Streptococcus, Staphylococcus, and Enterococcus as the cause of diseases classified elsewhere 
or problem_code ILIKE 'B95.0%' -- Streptococcus, group A, as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.1%' -- Streptococcus, group B, as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.2%' -- Enterococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.3%' -- Streptococcus pneumoniae as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.4%' -- Other streptococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.5%' -- Unspecified streptococcus as the cause of diseases classified elsewhere
-- Staphylococcus aureus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.61%' -- Methicillin susceptible Staphylococcus aureus infection as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.62%' -- Methicillin resistant Staphylococcus aureus infection as the cause of diseases classified elsewhere
-- Other staphylococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.7%' 
-- staphylococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.8%' 
-- Other bacterial agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.0%' -- Mycoplasma pneumoniae [M. pneumoniae] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.1%' -- Klebsiella pneumoniae [K. pneumoniae] as the cause of diseases classified elsewhere
--  Escherichia coli [E. coli ] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.20%' -- Unspecified Escherichia coli [E. coli] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.21%' -- Shiga toxin-producing Escherichia coli [E. coli] [STEC] O157 as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.22%' -- Other specified Shiga toxin-producing Escherichia coli [E. coli] [STEC] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.23%' -- Unspecified Shiga toxin-producing Escherichia coli [E. coli] [STEC] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.29%' -- Other Escherichia coli [E. coli] as the cause of diseases classified elsewhere
-- Hemophilus influenzae [H. influenzae] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.3%' 
-- Proteus (mirabilis) (morganii) as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.4%' 
-- Pseudomonas (aeruginosa) (mallei) (pseudomallei) as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.5%' 
-- Bacteroides fragilis [B. fragilis] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.6%' 
-- Clostridium perfringens [C. perfringens] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.7%' 
-- Other specified bacterial agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.81%'  -- Helicobacter pylori [H. pylori] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.82%'  -- Vibrio vulnificus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.89%'  -- Other specified bacterial agents as the cause of diseases classified elsewhere
-- Viral agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.0%' -- Adenovirus as the cause of diseases classified elsewhere
--  Enterovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.10%' -- Unspecified enterovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.11%' -- Coxsackievirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.12%' -- Echovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.19%' -- Other enterovirus as the cause of diseases classified elsewhere
-- Coronavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.21%' -- SARS-associated coronavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.29%' -- Other coronavirus as the cause of diseases classified elsewhere
-- Retrovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.30%' -- Unspecified retrovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.31%' -- Lentivirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.32%' -- Oncovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.33%' -- Human T-cell lymphotrophic virus, type I [HTLV-I] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.34%' -- Human T-cell lymphotrophic virus, type II [HTLV-II] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.35%' -- Human immunodeficiency virus, type 2 [HIV 2] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.39%' -- Other retrovirus as the cause of diseases classified elsewhere
--  Respiratory syncytial virus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.4%'
-- Reovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.5%'
-- Parvovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.6%'
-- Papillomavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.7%'
-- Other viral agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.81%' -- Human metapneumovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.89%' -- Other viral agents as the cause of diseases classified elsewhere
-- Other and unspecified infectious diseases
or problem_code ILIKE 'B99.%'
-- Resistance to antimicrobial drugs
-- Resistance to beta lactam antibiotics
or problem_code ILIKE 'Z16.10%' -- Resistance to unspecified beta lactam antibiotics
or problem_code ILIKE 'Z16.11%' -- Resistance to penicillins
or problem_code ILIKE 'Z16.12%' -- Extended spectrum beta lactamase (ESBL) resistance
or problem_code ILIKE 'Z16.19%' -- Resistance to other specified beta lactam antibiotics
-- Resistance to other antibiotics
or problem_code ILIKE 'Z16.20%' -- Resistance to unspecified antibiotic
or problem_code ILIKE 'Z16.21%' -- Resistance to vancomycin
or problem_code ILIKE 'Z16.22%' -- Resistance to vancomycin related antibiotics
or problem_code ILIKE 'Z16.23%' -- Resistance to quinolones and fluoroquinolones 
or problem_code ILIKE 'Z16.24%' -- Resistance to multiple antibiotics
or problem_code ILIKE 'Z16.29%' -- Resistance to other single specified antibiotic
-- Resistance to other antimicrobial drugs
or problem_code ILIKE 'Z16.30%' -- Resistance to unspecified antimicrobial drugs
or problem_code ILIKE 'Z16.31%' -- Resistance to antiparasitic drug(s)
or problem_code ILIKE 'Z16.32%' -- Resistance to antifungal drug(s)
or problem_code ILIKE 'Z16.33%' -- Resistance to antiviral drug(s)
or problem_code ILIKE 'Z16.33%' -- Resistance to antiviral drug(s)
-- Resistance to antimycobacterial drug(s)
or problem_code ILIKE 'Z16.341%' -- Resistance to single antimycobacterial drug
or problem_code ILIKE 'Z16.342%' -- Resistance to multiple antimycobacterial drugs
-- Resistance to multiple antimicrobial drugs
or problem_code ILIKE 'Z16.35%'
-- Resistance to other specified antimicrobial drug
or problem_code ILIKE 'Z16.39%'
-- Glaucoma
-- Borderline glaucoma (glaucoma suspect)
or problem_code ILIKE '365.00%' -- Preglaucoma, unspecified
or problem_code ILIKE '365.01%' -- Open angle with borderline findings, low risk
or problem_code ILIKE '365.02%' -- Anatomical narrow angle borderline glaucoma
or problem_code ILIKE '365.03%' -- Steroid responders borderline glaucoma
or problem_code ILIKE '365.04%' -- Ocular hypertension
or problem_code ILIKE '365.05%' -- Open angle with borderline findings, high risk
or problem_code ILIKE '365.06%' -- Primary angle closure without glaucoma damage
-- Open-angle glaucoma
or problem_code ILIKE '365.10%' -- Open-angle glaucoma, unspecified
or problem_code ILIKE '365.11%' -- Primary open angle glaucoma
or problem_code ILIKE '365.12%' -- Low tension open-angle glaucoma
or problem_code ILIKE '365.13%' -- Pigmentary open-angle glaucoma 
or problem_code ILIKE '365.14%' -- Glaucoma of childhood
or problem_code ILIKE '365.15%' -- Residual stage of open angle glaucoma
-- Primary angle-closure glaucoma
or problem_code ILIKE '365.20%' -- Primary angle-closure glaucoma, unspecified
or problem_code ILIKE '365.21%' -- Intermittent angle-closure glaucoma
or problem_code ILIKE '365.22%' -- Acute angle-closure glaucoma
or problem_code ILIKE '365.23%' -- Chronic angle-closure glaucoma
or problem_code ILIKE '365.24%' -- Residual stage of angle-closure glaucoma
-- Corticosteroid-induced glaucoma
or problem_code ILIKE '365.31%' -- Corticosteroid-induced glaucoma, glaucomatous stage
or problem_code ILIKE '365.32%' -- Corticosteroid-induced glaucoma, residual stage
--  Glaucoma associated with congenital anomalies dystrophies and systemic syndromes
or problem_code ILIKE '365.41%' -- Glaucoma associated with chamber angle anomalies
or problem_code ILIKE '365.42%' -- Glaucoma associated with anomalies of iris
or problem_code ILIKE '365.43%' -- Glaucoma associated with other anterior segment anomalies
or problem_code ILIKE '365.44%' -- Glaucoma associated with systemic syndromes
-- Glaucoma associated with disorders of the lens
or problem_code ILIKE '365.51%' -- Phacolytic glaucoma
or problem_code ILIKE '365.52%' -- Pseudoexfoliation glaucoma
or problem_code ILIKE '365.59%' -- Glaucoma associated with other lens disorders
-- Glaucoma associated with other ocular disorders
or problem_code ILIKE '365.60%' -- Glaucoma associated with unspecified ocular disorder
or problem_code ILIKE '365.61%' -- Glaucoma associated with pupillary block
or problem_code ILIKE '365.62%' -- Glaucoma associated with ocular inflammations
or problem_code ILIKE '365.63%' -- Glaucoma associated with vascular disorders
or problem_code ILIKE '365.64%' -- Glaucoma associated with tumors or cysts
or problem_code ILIKE '365.65%' -- Glaucoma associated with ocular trauma
-- Glaucoma stage
or problem_code ILIKE '365.70%' -- Glaucoma stage, unspecified
or problem_code ILIKE '365.71%' -- Mild stage glaucoma
or problem_code ILIKE '365.72%' -- Moderate stage glaucoma
or problem_code ILIKE '365.73%' -- Severe stage glaucoma
or problem_code ILIKE '365.74%' -- Indeterminate stage glaucoma
-- Other specified forms of glaucoma
or problem_code ILIKE '365.81%' -- Hypersecretion glaucoma
or problem_code ILIKE '365.82%' -- Glaucoma with increased episcleral venous pressure
or problem_code ILIKE '365.83%' -- Aqueous misdirection
or problem_code ILIKE '365.89%' -- Other specified glaucoma
-- Unspecified glaucoma
or problem_code ILIKE '365.9%'
-- Degeneration of macula and posterior pole of retina
or problem_code ILIKE '362.50%' -- Macular degeneration (senile), unspecified
or problem_code ILIKE '362.51%' -- Nonexudative senile macular degeneration
or problem_code ILIKE '362.52%' -- Exudative senile macular degeneration 
or problem_code ILIKE '362.53%' -- Cystoid macular degeneration 
or problem_code ILIKE '362.54%' -- Macular cyst, hole, or pseudohole
or problem_code ILIKE '362.55%' -- Toxic maculopathy
or problem_code ILIKE '362.56%' -- Macular puckering
or problem_code ILIKE '362.57%' -- Drusen (degenerative)
-- Diabetic retinopathy
or problem_code ILIKE '362.01%' -- Background diabetic retinopathy
or problem_code ILIKE '362.02%' -- Proliferative diabetic retinopathy
or problem_code ILIKE '362.03%' -- Nonproliferative diabetic retinopathy NOS
or problem_code ILIKE '362.04%' -- Mild nonproliferative diabetic retinopathy
or problem_code ILIKE '362.05%' -- Moderate nonproliferative diabetic retinopathy
or problem_code ILIKE '362.06%' -- Severe nonproliferative diabetic retinopathy
or problem_code ILIKE '362.07%' -- Diabetic macular edema
-- Senile cataract
or problem_code ILIKE '366.10%' -- Senile cataract, unspecified
or problem_code ILIKE '366.11%' -- Pseudoexfoliation of lens capsule
or problem_code ILIKE '366.12%' -- Incipient senile cataract
or problem_code ILIKE '366.13%' -- Anterior subcapsular polar senile cataract
or problem_code ILIKE '366.14%' -- Posterior subcapsular polar senile cataract
or problem_code ILIKE '366.15%' -- Cortical senile cataract
or problem_code ILIKE '366.16%' -- Senile nuclear sclerosis
or problem_code ILIKE '366.17%' -- Total or mature cataract
or problem_code ILIKE '366.18%' -- Hypermature cataract 
or problem_code ILIKE '366.19%' -- Other and combined forms of senile cataract
-- Tear film insufficiency, unspecified
or problem_code ILIKE '375.15%'
-- Dry eye syndrome
or problem_code ILIKE 'H04.121%' -- of right lacrimal gland
or problem_code ILIKE 'H04.122%' -- of left lacrimal gland
or problem_code ILIKE 'H04.123%' -- of bilateral lacrimal glands
or problem_code ILIKE 'H04.129%' -- of unspecified lacrimal gland
-- Allergic rhinitis, cause unspecified
or problem_code ILIKE '477.9%'
-- Vasomotor and allergic rhinitis
or problem_code ILIKE 'J30.0%' -- Vasomotor rhinitis
or problem_code ILIKE 'J30.1%' -- Allergic rhinitis due to pollen
or problem_code ILIKE 'J30.2%' -- Other seasonal allergic rhinitis
or problem_code ILIKE 'J30.5%' -- Allergic rhinitis due to food
--  Other allergic rhinitis
or problem_code ILIKE 'J30.81%' -- Allergic rhinitis due to animal (cat) (dog) hair and dander
or problem_code ILIKE 'J30.89%' -- Other allergic rhinitis
-- Allergic rhinitis, unspecified
or problem_code ILIKE 'J30.9%' 
-- Blepharitis
or problem_code ILIKE '373.00%' -- Blepharitis, unspecified
or problem_code ILIKE '373.01%' -- Ulcerative blepharitis
or problem_code ILIKE '373.02%' -- Squamous blepharitis
-- Blepharitis
-- Unspecified blepharitis
or problem_code ILIKE 'H01.001%' -- right upper eyelid
or problem_code ILIKE 'H01.002%' -- right lower eyelid
or problem_code ILIKE 'H01.003%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.004%' -- left upper eyelid
or problem_code ILIKE 'H01.005%' -- left lower eyelid
or problem_code ILIKE 'H01.006%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.009%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.00A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.00B%' -- left eye, upper and lower eyelids
-- Ulcerative blepharitis
or problem_code ILIKE 'H01.011%' -- right upper eyelid
or problem_code ILIKE 'H01.012%' -- right lower eyelid
or problem_code ILIKE 'H01.013%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.014%' -- left upper eyelid
or problem_code ILIKE 'H01.015%' -- left lower eyelid
or problem_code ILIKE 'H01.016%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.019%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.01A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.01B%' -- left eye, upper and lower eyelids
-- Squamous blepharitis
or problem_code ILIKE 'H01.021%' -- right upper eyelid
or problem_code ILIKE 'H01.022%' -- right lower eyelid
or problem_code ILIKE 'H01.023%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.024%' -- left upper eyelid
or problem_code ILIKE 'H01.025%' -- left lower eyelid
or problem_code ILIKE 'H01.026%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.029%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.02A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.02B%' -- left eye, upper and lower eyelids
-- Chalazion
or problem_code ILIKE '373.2%'
-- Hordeolum and other deep inflammation of eyelid
or problem_code ILIKE '373.11%' -- Hordeolum externum
or problem_code ILIKE '373.12%' -- Hordeolum internum
or problem_code ILIKE '373.13%' -- Abscess of eyelid
-- Hordeolum and chalazion
-- Hordeolum (externum) (internum) of eyelid
-- Hordeolum externum
or problem_code ILIKE 'H00.011%' -- right upper eyelid
or problem_code ILIKE 'H00.012%' -- right lower eyelid
or problem_code ILIKE 'H00.013%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.014%' -- left upper eyelid
or problem_code ILIKE 'H00.015%' -- left lower eyelid
or problem_code ILIKE 'H00.016%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.019%' -- unspecified eye, unspecified eyelid*/
-- Hordeolum internum
or problem_code ILIKE 'H00.021%' -- right upper eyelid
or problem_code ILIKE 'H00.022%' -- right lower eyelid
or problem_code ILIKE 'H00.023%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.024%' -- left upper eyelid
or problem_code ILIKE 'H00.025%' -- left lower eyelid
or problem_code ILIKE 'H00.026%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.029%' -- unspecified eye, unspecified eyelid*/
--Abscess of eyelid
or problem_code ILIKE 'H00.031%' -- right upper eyelid
or problem_code ILIKE 'H00.032%' -- right lower eyelid
or problem_code ILIKE 'H00.033%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.034%' -- left upper eyelid
or problem_code ILIKE 'H00.035%' -- left lower eyelid
or problem_code ILIKE 'H00.036%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.039%' -- unspecified eye, unspecified eyelid*/
-- Chalazion
or problem_code ILIKE 'H00.11%' -- right upper eyelid
or problem_code ILIKE 'H00.12%' -- right lower eyelid
or problem_code ILIKE 'H00.13%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.14%' -- left upper eyelid
or problem_code ILIKE 'H00.15%' -- left lower eyelid
or problem_code ILIKE 'H00.16%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.19%' -- unspecified eye, unspecified eyelid*/
-- Glaucoma
-- Preglaucoma, unspecified
or problem_code ILIKE 'H40.001%' -- right eye
or problem_code ILIKE 'H40.002%' -- left eye
or problem_code ILIKE 'H40.003%' -- bilateral
/*or problem_code ILIKE 'H40.009%' -- unspecified eye*/
-- Open angle with borderline findings, low risk
or problem_code ILIKE 'H40.011%' -- right eye
or problem_code ILIKE 'H40.012%' -- left eye
or problem_code ILIKE 'H40.013%' -- bilateral
/*or problem_code ILIKE 'H40.019%' -- unspecified eye*/
-- Open angle with borderline findings, high risk 
or problem_code ILIKE 'H40.021%' -- right eye
or problem_code ILIKE 'H40.022%' -- left eye
or problem_code ILIKE 'H40.023%' -- bilateral
/*or problem_code ILIKE 'H40.029%' -- unspecified eye*/
-- Anatomical narrow angle
or problem_code ILIKE 'H40.031%' -- right eye
or problem_code ILIKE 'H40.032%' -- left eye
or problem_code ILIKE 'H40.033%' -- bilateral
/*or problem_code ILIKE 'H40.039%' -- unspecified eye*/
--  Steroid responder
or problem_code ILIKE 'H40.041%' -- right eye
or problem_code ILIKE 'H40.042%' -- left eye
or problem_code ILIKE 'H40.043%' -- bilateral
/*or problem_code ILIKE 'H40.049%' -- unspecified eye*/
-- Ocular hypertension
or problem_code ILIKE 'H40.051%' -- right eye
or problem_code ILIKE 'H40.052%' -- left eye
or problem_code ILIKE 'H40.053%' -- bilateral
/*or problem_code ILIKE 'H40.059%' -- unspecified eye*/
--  Primary angle closure without glaucoma damage
or problem_code ILIKE 'H40.061%' -- right eye
or problem_code ILIKE 'H40.062%' -- left eye
or problem_code ILIKE 'H40.063%' -- bilateral
/*or problem_code ILIKE 'H40.069%' -- unspecified eye*/
-- Open-angle glaucoma
-- Unspecified open-angle glaucoma
or problem_code ILIKE 'H40.10X0%' -- stage unspecified
or problem_code ILIKE 'H40.10X1%' -- mild stage
or problem_code ILIKE 'H40.10X2%' -- moderate stage 
or problem_code ILIKE 'H40.10X3%' -- severe stage
or problem_code ILIKE 'H40.10X4%' -- indeterminate stage
-- Primary open-angle glaucoma
-- Primary open-angle glaucoma, right eye
or problem_code ILIKE 'H40.1110%' -- stage unspecified
or problem_code ILIKE 'H40.1111%' -- mild stage
or problem_code ILIKE 'H40.1112%' -- moderate stage 
or problem_code ILIKE 'H40.1113%' -- severe stage
or problem_code ILIKE 'H40.1114%' -- indeterminate stage
-- Primary open-angle glaucoma, left eye
or problem_code ILIKE 'H40.1120%' -- stage unspecified
or problem_code ILIKE 'H40.1121%' -- mild stage
or problem_code ILIKE 'H40.1122%' -- moderate stage 
or problem_code ILIKE 'H40.1123%' -- severe stage
or problem_code ILIKE 'H40.1124%' -- indeterminate stage
-- Primary open-angle glaucoma, bilateral
or problem_code ILIKE 'H40.1130%' -- stage unspecified
or problem_code ILIKE 'H40.1131%' -- mild stage
or problem_code ILIKE 'H40.1132%' -- moderate stage 
or problem_code ILIKE 'H40.1133%' -- severe stage
or problem_code ILIKE 'H40.1134%' -- indeterminate stage
/*-- Primary open-angle glaucoma, unspecified eye
or problem_code ILIKE 'H40.1190%' -- stage unspecified
or problem_code ILIKE 'H40.1191%' -- mild stage
or problem_code ILIKE 'H40.1192%' -- moderate stage 
or problem_code ILIKE 'H40.1193%' -- severe stage
or problem_code ILIKE 'H40.1194%' -- indeterminate stage*/
-- Low-tension glaucoma
-- Low-tension glaucoma, right eye
or problem_code ILIKE 'H40.1210%' -- stage unspecified
or problem_code ILIKE 'H40.1211%' -- mild stage
or problem_code ILIKE 'H40.1212%' -- moderate stage 
or problem_code ILIKE 'H40.1213%' -- severe stage
or problem_code ILIKE 'H40.1214%' -- indeterminate stage
-- Low-tension glaucoma, left eye
or problem_code ILIKE 'H40.1220%' -- stage unspecified
or problem_code ILIKE 'H40.1221%' -- mild stage
or problem_code ILIKE 'H40.1222%' -- moderate stage 
or problem_code ILIKE 'H40.1223%' -- severe stage
or problem_code ILIKE 'H40.1224%' -- indeterminate stage
-- Low-tension glaucoma, bilateral
or problem_code ILIKE 'H40.1230%' -- stage unspecified
or problem_code ILIKE 'H40.1231%' -- mild stage
or problem_code ILIKE 'H40.1232%' -- moderate stage 
or problem_code ILIKE 'H40.1233%' -- severe stage
or problem_code ILIKE 'H40.1234%' -- indeterminate stage
/*-- Low-tension glaucoma, unspecified eye
or problem_code ILIKE 'H40.1290%' -- stage unspecified
or problem_code ILIKE 'H40.1291%' -- mild stage
or problem_code ILIKE 'H40.1292%' -- moderate stage 
or problem_code ILIKE 'H40.1293%' -- severe stage
or problem_code ILIKE 'H40.1294%' -- indeterminate stage*/
-- Pigmentary glaucoma
-- Pigmentary glaucoma, right eye
or problem_code ILIKE 'H40.1310%' -- stage unspecified
or problem_code ILIKE 'H40.1311%' -- mild stage
or problem_code ILIKE 'H40.1312%' -- moderate stage 
or problem_code ILIKE 'H40.1313%' -- severe stage
or problem_code ILIKE 'H40.1314%' -- indeterminate stage
-- Pigmentary glaucoma, left eye
or problem_code ILIKE 'H40.1320%' -- stage unspecified
or problem_code ILIKE 'H40.1321%' -- mild stage
or problem_code ILIKE 'H40.1322%' -- moderate stage 
or problem_code ILIKE 'H40.1323%' -- severe stage
or problem_code ILIKE 'H40.1324%' -- indeterminate stage
-- Pigmentary glaucoma, bilateral
or problem_code ILIKE 'H40.1330%' -- stage unspecified
or problem_code ILIKE 'H40.1331%' -- mild stage
or problem_code ILIKE 'H40.1332%' -- moderate stage 
or problem_code ILIKE 'H40.1333%' -- severe stage
or problem_code ILIKE 'H40.1334%' -- indeterminate stage
/*-- Pigmentary glaucoma, unspecified eye
or problem_code ILIKE 'H40.1390%' -- stage unspecified
or problem_code ILIKE 'H40.1391%' -- mild stage
or problem_code ILIKE 'H40.1392%' -- moderate stage 
or problem_code ILIKE 'H40.1393%' -- severe stage
or problem_code ILIKE 'H40.1394%' -- indeterminate stage*/
-- Capsular glaucoma with pseudoexfoliation of lens
-- Capsular glaucoma with pseudoexfoliation of lens, right eye
or problem_code ILIKE 'H40.1410%' -- stage unspecified
or problem_code ILIKE 'H40.1411%' -- mild stage
or problem_code ILIKE 'H40.1412%' -- moderate stage 
or problem_code ILIKE 'H40.1413%' -- severe stage
or problem_code ILIKE 'H40.1414%' -- indeterminate stage
-- Capsular glaucoma with pseudoexfoliation of lens, left eye
or problem_code ILIKE 'H40.1420%' -- stage unspecified
or problem_code ILIKE 'H40.1421%' -- mild stage
or problem_code ILIKE 'H40.1422%' -- moderate stage 
or problem_code ILIKE 'H40.1423%' -- severe stage
or problem_code ILIKE 'H40.1424%' -- indeterminate stage
--  Capsular glaucoma with pseudoexfoliation of lens, bilateral
or problem_code ILIKE 'H40.1430%' -- stage unspecified
or problem_code ILIKE 'H40.1431%' -- mild stage
or problem_code ILIKE 'H40.1432%' -- moderate stage 
or problem_code ILIKE 'H40.1433%' -- severe stage
or problem_code ILIKE 'H40.1434%' -- indeterminate stage
/*-- Capsular glaucoma with pseudoexfoliation of lens, unspecified eye
or problem_code ILIKE 'H40.1490%' -- stage unspecified
or problem_code ILIKE 'H40.1491%' -- mild stage
or problem_code ILIKE 'H40.1492%' -- moderate stage 
or problem_code ILIKE 'H40.1493%' -- severe stage
or problem_code ILIKE 'H40.1494%' -- indeterminate stage*/
-- Residual stage of open-angle glaucoma
or problem_code ILIKE 'H40.151%' -- right eye
or problem_code ILIKE 'H40.152%' -- left eye
or problem_code ILIKE 'H40.153%' -- bilateral
/*or problem_code ILIKE 'H40.159%' -- unspecified eye */
-- Primary angle-closure glaucoma
-- Unspecified primary angle-closure glaucoma
or problem_code ILIKE 'H40.20X0%' -- stage unspecified
or problem_code ILIKE 'H40.20X1%' -- mild stage
or problem_code ILIKE 'H40.20X2%' -- moderate stage 
or problem_code ILIKE 'H40.20X3%' -- severe stage
or problem_code ILIKE 'H40.20X4%' -- indeterminate stage
-- Acute angle-closure glaucoma
or problem_code ILIKE 'H40.211%' -- right eye
or problem_code ILIKE 'H40.212%' -- left eye
or problem_code ILIKE 'H40.213%' -- bilateral
/*or problem_code ILIKE 'H40.219%' -- unspecified eye*/ 
-- Chronic angle-closure glaucoma
-- Chronic angle-closure glaucoma, right eye
or problem_code ILIKE 'H40.2210%' -- stage unspecified
or problem_code ILIKE 'H40.2211%' -- mild stage
or problem_code ILIKE 'H40.2212%' -- moderate stage 
or problem_code ILIKE 'H40.2213%' -- severe stage
or problem_code ILIKE 'H40.2214%' -- indeterminate stage
-- Chronic angle-closure glaucoma, left eye
or problem_code ILIKE 'H40.2220%' -- stage unspecified
or problem_code ILIKE 'H40.2221%' -- mild stage
or problem_code ILIKE 'H40.2222%' -- moderate stage 
or problem_code ILIKE 'H40.2223%' -- severe stage
or problem_code ILIKE 'H40.2224%' -- indeterminate stage
-- Chronic angle-closure glaucoma, bilateral
or problem_code ILIKE 'H40.2230%' -- stage unspecified
or problem_code ILIKE 'H40.2231%' -- mild stage
or problem_code ILIKE 'H40.2232%' -- moderate stage 
or problem_code ILIKE 'H40.2233%' -- severe stage
or problem_code ILIKE 'H40.2234%' -- indeterminate stage
/*-- Chronic angle-closure glaucoma, unspecified eye
or problem_code ILIKE 'H40.2290%' -- stage unspecified
or problem_code ILIKE 'H40.2291%' -- mild stage
or problem_code ILIKE 'H40.2292%' -- moderate stage 
or problem_code ILIKE 'H40.2293%' -- severe stage
or problem_code ILIKE 'H40.2294%' -- indeterminate stage*/
-- Intermittent angle-closure glaucoma
or problem_code ILIKE 'H40.231%' -- right eye
or problem_code ILIKE 'H40.232%' -- left eye
or problem_code ILIKE 'H40.233%' -- bilateral
/*or problem_code ILIKE 'H40.239%' -- unspecified eye */
--  Residual stage of angle-closure glaucoma
or problem_code ILIKE 'H40.241%' -- right eye
or problem_code ILIKE 'H40.242%' -- left eye
or problem_code ILIKE 'H40.243%' -- bilateral
/*or problem_code ILIKE 'H40.249%' -- unspecified eye */
-- Glaucoma secondary to eye trauma
/*--  Glaucoma secondary to eye trauma, unspecified eye
or problem_code ILIKE 'H40.30X0%' -- stage unspecified
or problem_code ILIKE 'H40.30X1%' -- mild stage
or problem_code ILIKE 'H40.30X2%' -- moderate stage 
or problem_code ILIKE 'H40.30X3%' -- severe stage
or problem_code ILIKE 'H40.30X4%' -- indeterminate stage*/
-- Glaucoma secondary to eye trauma, right eye
or problem_code ILIKE 'H40.31X0%' -- stage unspecified
or problem_code ILIKE 'H40.31X1%' -- mild stage
or problem_code ILIKE 'H40.31X2%' -- moderate stage 
or problem_code ILIKE 'H40.31X3%' -- severe stage
or problem_code ILIKE 'H40.31X4%' -- indeterminate stage
-- Glaucoma secondary to eye trauma, left eye
or problem_code ILIKE 'H40.32X0%' -- stage unspecified
or problem_code ILIKE 'H40.32X1%' -- mild stage
or problem_code ILIKE 'H40.32X2%' -- moderate stage 
or problem_code ILIKE 'H40.32X3%' -- severe stage
or problem_code ILIKE 'H40.32X4%' -- indeterminate stage
-- Glaucoma secondary to eye trauma, bilateral
or problem_code ILIKE 'H40.33X0%' -- stage unspecified
or problem_code ILIKE 'H40.33X1%' -- mild stage
or problem_code ILIKE 'H40.33X2%' -- moderate stage 
or problem_code ILIKE 'H40.33X3%' -- severe stage
or problem_code ILIKE 'H40.33X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation
/*-- Glaucoma secondary to eye inflammation, unspecified eye
or problem_code ILIKE 'H40.40X0%' -- stage unspecified
or problem_code ILIKE 'H40.40X1%' -- mild stage
or problem_code ILIKE 'H40.40X2%' -- moderate stage 
or problem_code ILIKE 'H40.40X3%' -- severe stage
or problem_code ILIKE 'H40.40X4%' -- indeterminate stage*/
-- Glaucoma secondary to eye inflammation, right eye
or problem_code ILIKE 'H40.41X0%' -- stage unspecified
or problem_code ILIKE 'H40.41X1%' -- mild stage
or problem_code ILIKE 'H40.41X2%' -- moderate stage 
or problem_code ILIKE 'H40.41X3%' -- severe stage
or problem_code ILIKE 'H40.41X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation, left eye
or problem_code ILIKE 'H40.42X0%' -- stage unspecified
or problem_code ILIKE 'H40.42X1%' -- mild stage
or problem_code ILIKE 'H40.42X2%' -- moderate stage 
or problem_code ILIKE 'H40.42X3%' -- severe stage
or problem_code ILIKE 'H40.42X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation, bilateral
or problem_code ILIKE 'H40.43X0%' -- stage unspecified
or problem_code ILIKE 'H40.43X1%' -- mild stage
or problem_code ILIKE 'H40.43X2%' -- moderate stage 
or problem_code ILIKE 'H40.43X3%' -- severe stage
or problem_code ILIKE 'H40.43X4%' -- indeterminate stage
-- Glaucoma secondary to other eye disorders
/*-- Glaucoma secondary to other eye disorders, unspecified eye
or problem_code ILIKE 'H40.50X0%' -- stage unspecified
or problem_code ILIKE 'H40.50X1%' -- mild stage
or problem_code ILIKE 'H40.50X2%' -- moderate stage 
or problem_code ILIKE 'H40.50X3%' -- severe stage
or problem_code ILIKE 'H40.50X4%' -- indeterminate stage*/
-- Glaucoma secondary to other eye disorders, right eye
or problem_code ILIKE 'H40.51X0%' -- stage unspecified
or problem_code ILIKE 'H40.51X1%' -- mild stage
or problem_code ILIKE 'H40.51X2%' -- moderate stage 
or problem_code ILIKE 'H40.51X3%' -- severe stage
or problem_code ILIKE 'H40.51X4%' -- indeterminate stage
--  Glaucoma secondary to other eye disorders, left eye
or problem_code ILIKE 'H40.52X0%' -- stage unspecified
or problem_code ILIKE 'H40.52X1%' -- mild stage
or problem_code ILIKE 'H40.52X2%' -- moderate stage 
or problem_code ILIKE 'H40.52X3%' -- severe stage
or problem_code ILIKE 'H40.52X4%' -- indeterminate stage
-- Glaucoma secondary to other eye disorders, bilateral
or problem_code ILIKE 'H40.53X0%' -- stage unspecified
or problem_code ILIKE 'H40.53X1%' -- mild stage
or problem_code ILIKE 'H40.53X2%' -- moderate stage 
or problem_code ILIKE 'H40.53X3%' -- severe stage
or problem_code ILIKE 'H40.53X4%' -- indeterminate stage
-- Glaucoma secondary to drugs
/*-- Glaucoma secondary to drugs, unspecified eye
or problem_code ILIKE 'H40.60X0%' -- stage unspecified
or problem_code ILIKE 'H40.60X1%' -- mild stage
or problem_code ILIKE 'H40.60X2%' -- moderate stage 
or problem_code ILIKE 'H40.60X3%' -- severe stage
or problem_code ILIKE 'H40.60X4%' -- indeterminate stage*/
-- Glaucoma secondary to drugs, right eye
or problem_code ILIKE 'H40.61X0%' -- stage unspecified
or problem_code ILIKE 'H40.61X1%' -- mild stage
or problem_code ILIKE 'H40.61X2%' -- moderate stage 
or problem_code ILIKE 'H40.61X3%' -- severe stage
or problem_code ILIKE 'H40.61X4%' -- indeterminate stage
--  Glaucoma secondary to drugs, left eye
or problem_code ILIKE 'H40.62X0%' -- stage unspecified
or problem_code ILIKE 'H40.62X1%' -- mild stage
or problem_code ILIKE 'H40.62X2%' -- moderate stage 
or problem_code ILIKE 'H40.62X3%' -- severe stage
or problem_code ILIKE 'H40.62X4%' -- indeterminate stage
-- Glaucoma secondary to drugs, bilateral
or problem_code ILIKE 'H40.63X0%' -- stage unspecified
or problem_code ILIKE 'H40.63X1%' -- mild stage
or problem_code ILIKE 'H40.63X2%' -- moderate stage 
or problem_code ILIKE 'H40.63X3%' -- severe stage
or problem_code ILIKE 'H40.63X4%' -- indeterminate stage
-- Other glaucoma
--  Glaucoma with increased episcleral venous pressure
or problem_code ILIKE 'H40.811%' --  right eye
or problem_code ILIKE 'H40.812%' -- left eye
or problem_code ILIKE 'H40.813%' -- bilateral
/*or problem_code ILIKE 'H40.819%' -- unspecified eye */
--  Hypersecretion glaucoma
or problem_code ILIKE 'H40.821%' --  right eye
or problem_code ILIKE 'H40.822%' -- left eye
or problem_code ILIKE 'H40.823%' -- bilateral
/*or problem_code ILIKE 'H40.829%' -- unspecified eye */
-- Aqueous misdirection
or problem_code ILIKE 'H40.831%' --  right eye
or problem_code ILIKE 'H40.832%' -- left eye
or problem_code ILIKE 'H40.833%' -- bilateral
/*or problem_code ILIKE 'H40.839%' -- unspecified eye */
-- Other specified glaucoma
or problem_code ILIKE 'H40.89%'
--  Unspecified glaucoma
or problem_code ILIKE 'H40.9%'
-- Type 2 diabetes mellitus with unspecified diabetic retinopathy without macular edema
or problem_code ILIKE 'E11.319%'
-- Age-related cataract 
-- Age-related incipient cataract
-- Cortical age-related cataract
or problem_code ILIKE 'H25.011%' -- right eye
or problem_code ILIKE 'H25.012%' -- left eye
or problem_code ILIKE 'H25.013%' -- bilateral
/*or problem_code ILIKE 'H25.019%' -- unspecified eye*/
-- Anterior subcapsular polar age-related cataract
or problem_code ILIKE 'H25.031%' -- right eye
or problem_code ILIKE 'H25.032%' -- left eye
or problem_code ILIKE 'H25.033%' -- bilateral
/*or problem_code ILIKE 'H25.039%' -- unspecified eye*/
-- Posterior subcapsular polar age-related cataract
or problem_code ILIKE 'H25.041%' -- right eye
or problem_code ILIKE 'H25.042%' -- left eye
or problem_code ILIKE 'H25.043%' -- bilateral
/*or problem_code ILIKE 'H25.049%' -- unspecified eye*/
--Other age-related incipient cataract
or problem_code ILIKE 'H25.091%' -- right eye
or problem_code ILIKE 'H25.092%' -- left eye
or problem_code ILIKE 'H25.093%' -- bilateral
/*or problem_code ILIKE 'H25.099%' -- unspecified eye*/
--  Age-related nuclear cataract
or problem_code ILIKE 'H25.11%' -- right eye
or problem_code ILIKE 'H25.12%' -- left eye
or problem_code ILIKE 'H25.13%' -- bilateral
/*or problem_code ILIKE 'H25.10%' -- unspecified eye*/
-- Age-related cataract, morgagnian type
or problem_code ILIKE 'H25.21%' -- right eye
or problem_code ILIKE 'H25.22%' -- left eye
or problem_code ILIKE 'H25.23%' -- bilateral
/*or problem_code ILIKE 'H25.20%' -- unspecified eye*/
-- Other age-related cataract
-- Combined forms of age-related cataract
or problem_code ILIKE 'H25.811%' -- right eye
or problem_code ILIKE 'H25.812%' -- left eye
or problem_code ILIKE 'H25.813%' -- bilateral
/*or problem_code ILIKE 'H25.819%' -- unspecified eye*/
-- Other age-related cataract
or problem_code ILIKE 'H25.89%' 
-- Unspecified age-related cataract
or problem_code ILIKE 'H25.9%' 
-- Degeneration of macula and posterior pole
-- Unspecified macular degeneration
or problem_code ILIKE 'H35.30%' 
--  Nonexudative age-related macular degeneration, right eye
or problem_code ILIKE 'H35.3110%' --  stage unspecified
or problem_code ILIKE 'H35.3111%' -- early dry stage
or problem_code ILIKE 'H35.3112%' --  intermediate dry stage
or problem_code ILIKE 'H35.3113%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3114%' --  advanced atrophic with subfoveal involvement
-- Nonexudative age-related macular degeneration, left eye
or problem_code ILIKE 'H35.3120%' --  stage unspecified
or problem_code ILIKE 'H35.3121%' -- early dry stage
or problem_code ILIKE 'H35.3122%' --  intermediate dry stage
or problem_code ILIKE 'H35.3123%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3124%' --  advanced atrophic with subfoveal involvement
-- Nonexudative age-related macular degeneration, bilateral
or problem_code ILIKE 'H35.3130%' --  stage unspecified
or problem_code ILIKE 'H35.3131%' -- early dry stage
or problem_code ILIKE 'H35.3132%' --  intermediate dry stage
or problem_code ILIKE 'H35.3133%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3134%' --  advanced atrophic with subfoveal involvement
/*-- Nonexudative age-related macular degeneration, unspecified eye
or problem_code ILIKE 'H35.3190%' --  stage unspecified
or problem_code ILIKE 'H35.3191%' -- early dry stage
or problem_code ILIKE 'H35.3192%' --  intermediate dry stage
or problem_code ILIKE 'H35.3193%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3194%' --  advanced atrophic with subfoveal involvement*/
-- Exudative age-related macular degeneration
-- Exudative age-related macular degeneration, right eye
 or problem_code ILIKE 'H35.3210%' -- stage unspecified
 or problem_code ILIKE 'H35.3211%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3212%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3213%' -- with inactive scar
--Exudative age-related macular degeneration, left eye
  or problem_code ILIKE 'H35.3220%' -- stage unspecified
  or problem_code ILIKE 'H35.3221%' -- with active choroidal neovascularization
  or problem_code ILIKE 'H35.3222%' -- with inactive choroidal neovascularization
  or problem_code ILIKE 'H35.3223%' -- with inactive scar
  -- Exudative age-related macular degeneration, bilateral
 or problem_code ILIKE 'H35.3230%' -- stage unspecified
 or problem_code ILIKE 'H35.3231%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3232%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3233%' -- with inactive scar
/* -- Exudative age-related macular degeneration, unspecified eye
 or problem_code ILIKE 'H35.3290%' -- stage unspecified
 or problem_code ILIKE 'H35.3291%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3292%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3293%' -- with inactive scar*/
 --Angioid streaks of macula
 or problem_code ILIKE 'H35.33%' 
 -- Macular cyst, hole, or pseudohole
  or problem_code ILIKE 'H35.341%' -- right eye
  or problem_code ILIKE 'H35.342%' -- left eye
  or problem_code ILIKE 'H35.343%' -- bilateral
/*  or problem_code ILIKE 'H35.349%' -- unspecified eye*/
 -- Cystoid macular degeneration
  or problem_code ILIKE 'H35.351%' -- right eye
  or problem_code ILIKE 'H35.352%' -- left eye
  or problem_code ILIKE 'H35.353%' -- bilateral
/*  or problem_code ILIKE 'H35.359%' -- unspecified eye*/
 -- Drusen (degenerative) of macula
  or problem_code ILIKE 'H35.361%' -- right eye
  or problem_code ILIKE 'H35.362%' -- left eye
  or problem_code ILIKE 'H35.363%' -- bilateral
/*  or problem_code ILIKE 'H35.369%' -- unspecified eye*/
 -- Puckering of macula
  or problem_code ILIKE 'H35.371%' -- right eye
  or problem_code ILIKE 'H35.372%' -- left eye
  or problem_code ILIKE 'H35.373%' -- bilateral
/*  or problem_code ILIKE 'H35.379' -- unspecified eye*/
 -- Toxic maculopathy
  or problem_code ILIKE 'H35.381%' -- right eye
  or problem_code ILIKE 'H35.382%' -- left eye
  or problem_code ILIKE 'H35.383%' -- bilateral
/*  or problem_code ILIKE 'H35.389%' -- unspecified eye*/
)
and (diag_eye='1' or diag_eye='2' or  diag_eye='3')
and extract(year from diagnosis_date) BETWEEN 2015 and 2018);



drop table if exists aao_grants.liet_diag_pull_new3;
create table aao_grants.liet_diag_pull_new3 as
(select distinct patient_guid,
case when (documentation_date > problem_onset_date) and problem_onset_date is not null then problem_onset_date
when (problem_onset_date > documentation_date) and documentation_date is not null then documentation_date
when problem_onset_date is null then documentation_date
when documentation_date is null then problem_onset_date
when documentation_date=problem_onset_date then documentation_date
end as diagnosis_date,
case when diag_eye='3' then 2
end as eye,
practice_id,
case
				when (problem_description ilike '%without CSME%' 
				or problem_description ilike '428341000124108' 
				or problem_description ilike '%Non-Center Involved Diabetic Macular Edema%' 
				or problem_description ilike '%no evidence of clinically significant macular edema%' 
				or problem_description ilike '%Borderline CSME%' 
				or problem_description ilike '%No SRH/SRF/Lipid/CSME%' 
				or problem_description ilike '%No Clinically Significant Macular Edema%' 
				or problem_description ilike '%No CSME%' 
				or problem_description ilike '%Clinically Significant Macular Edema, Focal%' 
				or problem_description ilike '%Borderline Clinically Significant Macular Edema%' 
				or problem_description ilike '%(-) CSME%' 
				or problem_description ilike '%w/o CSME%' 
				or problem_description ilike '%CSME  (?)%'  
				or problem_description ilike '%?CSME%' 
				or problem_description ilike '%No CSME/DME%'  
				or problem_description ilike '%(--) CSME%'
				or problem_description ilike '%No NPDR (diabetic retinopathy) or CSME%'
				or problem_description ilike '%(-)CSME%' 
				or problem_description ilike '%no heme, exudate, CSME, NVD, NVE%' 
				or problem_description ilike '%no_CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%no DR or CSME noted%' 
				or problem_description ilike '%Clinically Significant Macular Edema is absent%' 
				or problem_description ilike '%neg CSME%' 
				or problem_description ilike '%=-CSME%' 
				or problem_description ilike '%no BDR/ CSME%' 
				or problem_description ilike '%diabetes WITHOUT signs of diabetic retinopathy or clinically significant macular edema%' 
				or problem_description ilike '%no macular edema%' 
				or problem_description ilike '%no diabetic retinopathy, NVE, NVD or CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%Non-Center-Involved Diabetic Macular Edema%' 
				or problem_description ilike '%No DME or CSME%' 
				or problem_description ilike '%NO   CSME%' 
				or problem_description ilike '%No CSME-DME%' 
				or problem_description ilike '%No Diabetic Retinopathy or CSME%' 
				or problem_description ilike '%no heme,exudates,or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%no diabetic retinopathy or CSME%' 
				or problem_description ilike '%no NV/CSME%' 
				or problem_description ilike '%No BDR, CSME, NVD, NVE, NVE%' 
				or problem_description ilike '%CSME -' 
				or problem_description ilike '%(-) BDR or CSME%'
				or problem_description ilike '%(-)BDR or CSME%'
				or problem_description ilike '%without Clinically Significant Macular Edema%'
				or problem_description ilike '%Diabetes without retinopathy or clinically significant macular edema%') then 0
				
				when (problem_description ilike 'CSME%' 
				or problem_description ilike 'Clinically Significant Macular Edema%' 
				or problem_description ilike '%with clinically significant macular edema%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF RIGHT EYE DETERMINED BY EXAMINATION%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF LEFT EYE DETERMINED BY EXAMINATION%'
				or problem_description ilike 'Center Involved Diabetic Macular Edema%' 
				or problem_description ilike 'CSME (Diabetes Related Mac. Edema)%' 
				or problem_description ilike 'Clinically Significant Macular Edema, Diffuse%' 
				or problem_description ilike 'CSME_clinically significant macular edema%' 
				or problem_description ilike 'EDEMA-CSME%'  
				or problem_description ilike 'Clinically significant macular edema (disorder)%' 
				or problem_description ilike 'edema CSME%' 
				or problem_description ilike 'CSME (Clinically Significant  Mac. Edema)%' 
				or problem_description ilike '%has developed CSME%' 
				or problem_description ilike '%(+) CSME%' 
				or problem_description ilike 'Diabetes - CSME (250.52) (OCT)%' 
				or problem_description ilike 'Clinically significant macular edema of right eye%' 
				or problem_description ilike 'Clinically significant macular edema of left eye%' 
				or problem_description ilike 'CSME (H35.81%)' 
				or problem_description ilike '%management of clinically significant macular edema%' 
				or problem_description ilike '%with CSME%' 
				or problem_description ilike 'Clinically significant macular edema associated with type 2 diabetes%' 
				or problem_description ilike 'Center-Involved Diabetic Macular Edema%'
				or problem_description ilike 'On examination - clinically significant macular edema of left eye%' 
				or problem_description ilike 'On examination - clinically significant macular edema of right eye%') then 1
				
				when (problem_comment ilike '%no clinically significant macular edema%' 
				or problem_comment ilike '%no CSME%' 
				or problem_comment ilike '%negative CSME%' 
				or problem_comment ilike '%No NVD, NVE, Vit Hem or CSME%' 
				or problem_comment ilike '%(-)CSME%' 
				or problem_comment ilike '%No NVD/NVE/CSME%' 
				or problem_comment ilike '%CSMEnegative%' 
				or problem_comment ilike '%No Diabetic Retinopathy, macular edema or CSME%' 
				or problem_comment ilike '%=-CSME%' 
				or problem_comment ilike '%no BDR, CSME, NVE%' 
				or problem_comment ilike '%(-) CSME%' 
				or problem_comment ilike '%no hemorrhages, exudates, pigmentary changes or macular edemano clinically significant macular edema%' 
				or problem_comment ilike '%no clinically significant macular edemanegative%' 
				or problem_comment ilike '%no hemorrhage or exudatesno clinically significant macular edema%' 
				or problem_comment ilike '%no signs of clinically significant macular edema%' 
				or problem_comment ilike '%clinically significant macular edemanegative%' 
				or problem_comment ilike '%Mild NPDR without macular edema or CSME%' 
				or problem_comment ilike '%no MAs, DBH, or CSME%' 
				or problem_comment ilike '%no signs of neovascularization or clinically significant macular edema%' 
				or problem_comment ilike '%retinopathyno clinically significant macular edema%' 
				or problem_comment ilike '%without clinically significant macular edema%' 
				or problem_comment ilike '%No diabetic retinopathy or clinically significant macular edema%' 
				or problem_comment ilike '%No NVE/CSME%' 
				or problem_comment ilike '%no MA, DBH, NV, CSME%' 
				or problem_comment ilike '%No MAs, heme or CSME%' 
				or problem_comment ilike '%=- CSME%' 
				or problem_comment ilike '%No DR or CSME%' 
				or problem_comment ilike '?CSME%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%No NPDR, PDR, or CSME%' 
				or problem_comment ilike '%without CSME%' 
				or problem_comment ilike '%w/o  CSME%' 
				or problem_comment ilike '%borderline CSME%' 
				or problem_comment ilike '%Negative CSME%' 
				or problem_comment ilike '%CSME - neg%' 
				or problem_comment ilike '%neg. CSME%' 
				or problem_comment ilike '%(-)NPDR/PDR/CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%No signs of CSME%' 
				or problem_comment ilike '%mild CSME%' 
				or problem_comment ilike '%negative BDR, CSME%' 
				or problem_comment ilike '%CSMEabsent%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%no retinopathy, CSME or neovascularization%' 
				or problem_comment ilike '%without macular edema or CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%? CSME%' 
				or problem_comment ilike '%Neg CSME%' 
				or problem_comment ilike '%CSMEno%' 
				or problem_comment ilike '%no MAs, heme or CSME%' 
				or problem_comment ilike '-CSME%'
				or problem_comment ilike '%No signs of Retinopathy or neovascularization, or CSME%') then 0
				
				when (problem_comment ilike 'clinically significant macular edema%'
				or problem_comment ilike 'CSME%' 
				or problem_comment ilike 'DM, CSME%'
				or problem_comment ilike '%Diabetic Retinopathy With CSME%' 
				or problem_comment ilike '%=+ CSME%' 
				or problem_comment ilike '%=+CSME%' 
				or problem_comment ilike '%Mild non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME diabetic retinopathy%' 
				or problem_comment ilike '%Proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME (clinically significant macular edema%)' 
				or problem_comment ilike '%Moderate non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike '%no evidence of non-proliferative diabetic retinopathy or clinically significant macular edema%') then 1
				else 99 end as csme_status

from madrid2.patient_problem_laterality 
where (
--Corneal ulcer
problem_code ILIKE '370.00%' -- Corneal ulcer, unspecified
or problem_code ILIKE '370.01%' -- Marginal corneal ulcer
or problem_code ILIKE '370.02%' -- Ring corneal ulcer
or problem_code ILIKE '370.03%' -- Central corneal ulcer
or problem_code ILIKE '370.04%' -- Hypopyon ulcer
or problem_code ILIKE '370.05%' -- Mycotic corneal ulcer
or problem_code ILIKE '370.06%' -- Perforated corneal ulcer
or problem_code ILIKE '370.07%' -- Mooren's ulcer
-- Certain types of keratoconjunctivitis
or problem_code ILIKE '370.31%' -- Phlyctenular keratoconjunctivitis
or problem_code ILIKE '370.32%' -- Limbar and corneal involvement in vernal conjunctivitis
or problem_code ILIKE '370.33%' -- Keratoconjunctivitis sicca, not specified as Sjogren's
or problem_code ILIKE '370.34%' -- Exposure keratoconjunctivitis
or problem_code ILIKE '370.35%' -- Neurotrophic keratoconjunctivitis
-- Other and unspecified keratoconjunctivitis
or problem_code ILIKE '370.40%' -- Keratoconjunctivitis, unspecified
or problem_code ILIKE '370.44%' -- Keratitis or keratoconjunctivitis in exanthema
or problem_code ILIKE '370.49%' -- Other keratoconjunctivitis
-- Interstitial and deep keratitis
or problem_code ILIKE '370.50%' -- Interstitial keratitis, unspecified
or problem_code ILIKE '370.52%' -- Diffuse interstitial keratitis
or problem_code ILIKE '370.54%' -- Sclerosing keratitis
or problem_code ILIKE '370.55%' -- Corneal abscess
or problem_code ILIKE '370.59%' -- Other interstitial and deep keratitis 
-- Corneal neovascularization
or problem_code ILIKE '370.60%' -- Corneal neovascularization, unspecified
or problem_code ILIKE '370.61%' -- Localized vascularization of cornea
or problem_code ILIKE '370.62%' -- Pannus (corneal)
or problem_code ILIKE '370.63%' -- Deep vascularization of cornea
or problem_code ILIKE '370.64%' -- Ghost vessels (corneal)
-- Other forms of keratitis 
or problem_code ILIKE '370.8%' 
-- Unspecified keratitis
or problem_code ILIKE '370.9%' 
-- Acute conjunctivitis
or problem_code ILIKE '372.00%' -- Acute conjunctivitis, unspecified
or problem_code ILIKE '372.01%' -- Serous conjunctivitis, except viral
or problem_code ILIKE '372.02%' -- Acute follicular conjunctivitis
or problem_code ILIKE '372.03%' -- Other mucopurulent conjunctivitis
or problem_code ILIKE '372.04%' -- Pseudomembranous conjunctivitis
or problem_code ILIKE '372.05%' -- Acute atopic conjunctivitis
or problem_code ILIKE '372.06%' -- Acute chemical conjunctivitis
--Chronic conjunctivitis
or problem_code ILIKE '372.10%' -- Chronic conjunctivitis, unspecified 
or problem_code ILIKE '372.11%' -- Simple chronic conjunctivitis
or problem_code ILIKE '372.12%' -- Chronic follicular conjunctivitis
or problem_code ILIKE '372.13%' -- Vernal conjunctivitis
or problem_code ILIKE '372.14%' -- Other chronic allergic conjunctivitis
or problem_code ILIKE '372.15%' -- Parasitic conjunctivitis
-- Blepharoconjunctivitis
or problem_code ILIKE '372.20%' -- Blepharoconjunctivitis, unspecified 
or problem_code ILIKE '372.21%' -- Angular blepharoconjunctivitis
or problem_code ILIKE '372.22%' -- Contact blepharoconjunctivitis
-- Other and unspecified conjunctivitis
or problem_code ILIKE '372.30%' -- Conjunctivitis, unspecified
or problem_code ILIKE '372.31%' -- Rosacea conjunctivitis
or problem_code ILIKE '372.33%' -- Conjunctivitis in mucocutaneous disease
or problem_code ILIKE '372.34%' -- Pingueculitis
or problem_code ILIKE '372.39%' -- Other conjunctivitis
-- Pterygium --should we keep this?
or problem_code ILIKE '372.40%' -- Pterygium, unspecified
or problem_code ILIKE '372.41%' -- Peripheral pterygium, stationary
or problem_code ILIKE '372.42%' -- Peripheral pterygium, progressive
or problem_code ILIKE '372.43%' -- Central pterygium
or problem_code ILIKE '372.44%' -- Double pterygium
or problem_code ILIKE '372.45%' -- Recurrent pterygium
--Conjunctival degenerations and deposits
or problem_code ILIKE '372.50%' -- Conjunctival degeneration, unspecified
or problem_code ILIKE '372.51%' -- Pinguecula
or problem_code ILIKE '372.52%' -- Pseudopterygium
or problem_code ILIKE '372.53%' -- Conjunctival xerosis
or problem_code ILIKE '372.54%' -- Conjunctival concretions
or problem_code ILIKE '372.55%' -- Conjunctival pigmentations
or problem_code ILIKE '372.56%' -- Conjunctival deposits
-- Conjunctival scars
or problem_code ILIKE '372.61%' -- Granuloma of conjunctiva
or problem_code ILIKE '372.62%' -- Localized adhesions and strands of conjunctiva
or problem_code ILIKE '372.63%' -- Symblepharon
or problem_code ILIKE '372.64%' -- Scarring of conjunctiva
-- Conjunctival vascular disorders and cysts
or problem_code ILIKE '372.71%' -- Hyperemia of conjunctiva 
or problem_code ILIKE '372.72%' -- Conjunctival hemorrhage
or problem_code ILIKE '372.73%' -- Conjunctival edema
or problem_code ILIKE '372.74%' -- Vascular abnormalities of conjunctiva 
or problem_code ILIKE '372.75%' -- Conjunctival cysts
-- Other disorders of conjunctiva (include?)
or problem_code ILIKE '372.81%' -- Conjunctivochalasis
or problem_code ILIKE '372.89%' -- Other disorders of conjunctiva
-- Unspecified disorder of conjunctiva
or problem_code ILIKE '372.9%'
-- Conjunctivitis
	-- Acute follicular conjunctivitis
or problem_code ILIKE 'H10.011%' -- right eye
or problem_code ILIKE 'H10.012%' -- left eye
or problem_code ILIKE 'H10.013%' -- bilateral
/*or problem_code ILIKE 'H10.019%' --  unspecified eye*/
	-- Other mucopurulent conjunctivitis
or problem_code ILIKE 'H10.021%' -- right eye
or problem_code ILIKE 'H10.022%' -- left eye
or problem_code ILIKE 'H10.023%' -- bilateral
/*or problem_code ILIKE 'H10.029%' --  unspecified eye*/
-- Acute atopic conjunctivitis
or problem_code ILIKE 'H10.11%' -- right eye
or problem_code ILIKE 'H10.12%' -- left eye
or problem_code ILIKE 'H10.13%' -- bilateral
/*or problem_code ILIKE 'H10.10%' --  unspecified eye*/
-- Acute toxic conjunctivitis
or problem_code ILIKE 'H10.211%' -- right eye
or problem_code ILIKE 'H10.212%' -- left eye
or problem_code ILIKE 'H10.213%' -- bilateral
/*or problem_code ILIKE 'H10.219%' --  unspecified eye*/
-- Pseudomembranous conjunctivitis
or problem_code ILIKE 'H10.221%' -- right eye
or problem_code ILIKE 'H10.222%' -- left eye
or problem_code ILIKE 'H10.223%' -- bilateral
/*or problem_code ILIKE 'H10.229%' --  unspecified eye*/
-- Serous conjunctivitis, except viral
or problem_code ILIKE 'H10.231%' -- right eye
or problem_code ILIKE 'H10.232%' -- left eye
or problem_code ILIKE 'H10.233%' -- bilateral
/*or problem_code ILIKE 'H10.239%' --  unspecified eye*/
-- Unspecified acute conjunctivitis
or problem_code ILIKE 'H10.31%' -- right eye
or problem_code ILIKE 'H10.32%' -- left eye
or problem_code ILIKE 'H10.33%' -- bilateral
/*or problem_code ILIKE 'H10.30%' --  unspecified eye*/
-- Unspecified chronic conjunctivitis
or problem_code ILIKE 'H10.401%' -- right eye
or problem_code ILIKE 'H10.402%' -- left eye
or problem_code ILIKE 'H10.403%' -- bilateral
/*or problem_code ILIKE 'H10.409%' --  unspecified eye*/
-- Chronic giant papillary conjunctivitis
or problem_code ILIKE 'H10.411%' -- right eye
or problem_code ILIKE 'H10.412%' -- left eye
or problem_code ILIKE 'H10.413%' -- bilateral
/*or problem_code ILIKE 'H10.419%' --  unspecified eye*/
-- Simple chronic conjunctivitis
or problem_code ILIKE 'H10.421%' -- right eye
or problem_code ILIKE 'H10.422%' -- left eye
or problem_code ILIKE 'H10.423%' -- bilateral
/*or problem_code ILIKE 'H10.429%' --  unspecified eye*/
--  Chronic follicular conjunctivitis
or problem_code ILIKE 'H10.431%' -- right eye
or problem_code ILIKE 'H10.432%' -- left eye
or problem_code ILIKE 'H10.433%' -- bilateral
/*or problem_code ILIKE 'H10.439%' --  unspecified eye*/
-- Vernal conjunctivitis
or problem_code ILIKE 'H10.44%'
-- Other chronic allergic conjunctivitis
or problem_code ILIKE 'H10.45%'
-- Unspecified blepharoconjunctivitis
or problem_code ILIKE 'H10.501%' -- right eye
or problem_code ILIKE 'H10.502%' -- left eye
or problem_code ILIKE 'H10.503%' -- bilateral
/*or problem_code ILIKE 'H10.509%' --  unspecified eye*/
-- Ligneous conjunctivitis
or problem_code ILIKE 'H10.511%' -- right eye
or problem_code ILIKE 'H10.512%' -- left eye
or problem_code ILIKE 'H10.513%' -- bilateral
/*or problem_code ILIKE 'H10.519%' --  unspecified eye*/
-- Angular blepharoconjunctivitis
or problem_code ILIKE 'H10.521%' -- right eye
or problem_code ILIKE 'H10.522%' -- left eye
or problem_code ILIKE 'H10.523%' -- bilateral
/*or problem_code ILIKE 'H10.529%' --  unspecified eye*/
--  Contact blepharoconjunctivitis
or problem_code ILIKE 'H10.531%' -- right eye
or problem_code ILIKE 'H10.532%' -- left eye
or problem_code ILIKE 'H10.533%' -- bilateral
/*or problem_code ILIKE 'H10.539%' --  unspecified eye*/
-- Pingueculitis
or problem_code ILIKE 'H10.811%' -- right eye
or problem_code ILIKE 'H10.812%' -- left eye
or problem_code ILIKE 'H10.813%' -- bilateral
/*or problem_code ILIKE 'H10.819%' --  unspecified eye*/
-- Rosacea conjunctivitis
or problem_code ILIKE 'H10.821%' -- right eye
or problem_code ILIKE 'H10.822%' -- left eye
or problem_code ILIKE 'H10.823%' -- bilateral
/*or problem_code ILIKE 'H10.829%' --  unspecified eye*/
-- Other conjunctivitis
or problem_code ILIKE 'H10.89%' 
-- Unspecified conjunctivitis
or problem_code ILIKE 'H10.9%' 
-- Neonatal conjunctivitis and dacryocystitis
or problem_code ILIKE 'P39.1%' 
-- Unspecified corneal ulcer
or problem_code ILIKE 'H16.001%' -- right eye
or problem_code ILIKE 'H16.002%' -- left eye
or problem_code ILIKE 'H16.003%' -- bilateral
/*or problem_code ILIKE 'H16.009%' --  unspecified eye*/
-- Central corneal ulcer
or problem_code ILIKE 'H16.011%' -- right eye
or problem_code ILIKE 'H16.012%' -- left eye
or problem_code ILIKE 'H16.013%' -- bilateral
/*or problem_code ILIKE 'H16.019%' --  unspecified eye*/
-- Ring corneal ulcer
or problem_code ILIKE 'H16.021%' -- right eye
or problem_code ILIKE 'H16.022%' -- left eye
or problem_code ILIKE 'H16.023%' -- bilateral
/*or problem_code ILIKE 'H16.029%' --  unspecified eye*/
-- Corneal ulcer with hypopyon
or problem_code ILIKE 'H16.031%' -- right eye
or problem_code ILIKE 'H16.032%' -- left eye
or problem_code ILIKE 'H16.033%' -- bilateral
/*or problem_code ILIKE 'H16.039%' --  unspecified eye*/
-- Marginal corneal ulcer
or problem_code ILIKE 'H16.041%' -- right eye
or problem_code ILIKE 'H16.042%' -- left eye
or problem_code ILIKE 'H16.043%' -- bilateral
/*or problem_code ILIKE 'H16.049%' --  unspecified eye*/
-- Mooren's corneal ulcer
or problem_code ILIKE 'H16.051%' -- right eye
or problem_code ILIKE 'H16.052%' -- left eye
or problem_code ILIKE 'H16.053%' -- bilateral
/*or problem_code ILIKE 'H16.059%' --  unspecified eye*/
-- Mycotic corneal ulcer
or problem_code ILIKE 'H16.061%' -- right eye
or problem_code ILIKE 'H16.062%' -- left eye
or problem_code ILIKE 'H16.063%' -- bilateral
/*or problem_code ILIKE 'H16.069%' --  unspecified eye*/
--  Perforated corneal ulcer
or problem_code ILIKE 'H16.071%' -- right eye
or problem_code ILIKE 'H16.072%' -- left eye
or problem_code ILIKE 'H16.073%' -- bilateral
/*or problem_code ILIKE 'H16.079%' --  unspecified eye*/
-- Other and unspecified superficial keratitis without conjunctivitis	
-- Unspecified superficial keratitis	
or problem_code ILIKE 'H16.101%' -- right eye	
or problem_code ILIKE 'H16.102%' -- left eye	
or problem_code ILIKE 'H16.103%' -- bilateral	
/*or problem_code ILIKE 'H16.109%' -- unspecified eye*/	
-- Macular keratitis	
or problem_code ILIKE 'H16.111%' -- right eye	
or problem_code ILIKE 'H16.112%' -- left eye	
or problem_code ILIKE 'H16.113%' -- bilateral	
/*or problem_code ILIKE 'H16.119%' -- unspecified eye*/	
-- Filamentary keratitis	
or problem_code ILIKE 'H16.121%' -- right eye	
or problem_code ILIKE 'H16.122%' -- left eye	
or problem_code ILIKE 'H16.123%' -- bilateral	
/*or problem_code ILIKE 'H16.129%' -- unspecified eye	*/
-- Photokeratitis	
or problem_code ILIKE 'H16.131%' -- right eye	
or problem_code ILIKE 'H16.132%' -- left eye	
or problem_code ILIKE 'H16.133%' -- bilateral	
/*or problem_code ILIKE 'H16.139%' -- unspecified eye	*/
-- Punctate keratitis	
or problem_code ILIKE 'H16.141%' -- right eye	
or problem_code ILIKE 'H16.142%' -- left eye	
or problem_code ILIKE 'H16.143%' -- bilateral	
/*or problem_code ILIKE 'H16.149%' -- unspecified eye	*/
-- Unspecified keratoconjunctivitis
or problem_code ILIKE 'H16.201%' -- right eye
or problem_code ILIKE 'H16.202%' -- left eye
or problem_code ILIKE 'H16.203%' -- bilateral
/*or problem_code ILIKE 'H16.209%' --  unspecified eye*/
-- Exposure keratoconjunctivitis
or problem_code ILIKE 'H16.211%' -- right eye
or problem_code ILIKE 'H16.212%' -- left eye
or problem_code ILIKE 'H16.213%' -- bilateral
/*or problem_code ILIKE 'H16.219%' --  unspecified eye*/
-- Keratoconjunctivitis sicca, not specified as Sjögren's
or problem_code ILIKE 'H16.221%' -- right eye
or problem_code ILIKE 'H16.222%' -- left eye
or problem_code ILIKE 'H16.223%' -- bilateral
/*or problem_code ILIKE 'H16.229%' --  unspecified eye*/
-- Neurotrophic keratoconjunctivitis
or problem_code ILIKE 'H16.231%' -- right eye
or problem_code ILIKE 'H16.232%' -- left eye
or problem_code ILIKE 'H16.233%' -- bilateral
/*or problem_code ILIKE 'H16.239%' --  unspecified eye*/
-- Ophthalmia nodosa
or problem_code ILIKE 'H16.241%' -- right eye
or problem_code ILIKE 'H16.242%' -- left eye
or problem_code ILIKE 'H16.243%' -- bilateral
/*or problem_code ILIKE 'H16.249%' --  unspecified eye*/
-- Phlyctenular keratoconjunctivitis
or problem_code ILIKE 'H16.251%' -- right eye
or problem_code ILIKE 'H16.252%' -- left eye
or problem_code ILIKE 'H16.253%' -- bilateral
/*or problem_code ILIKE 'H16.259%' --  unspecified eye*/
-- Vernal keratoconjunctivitis, with limbar and corneal involvement
or problem_code ILIKE 'H16.261%' -- right eye
or problem_code ILIKE 'H16.262%' -- left eye
or problem_code ILIKE 'H16.263%' -- bilateral
/*or problem_code ILIKE 'H16.269%' --  unspecified eye*/
-- Other keratoconjunctivitis
or problem_code ILIKE 'H16.291%' -- right eye
or problem_code ILIKE 'H16.292%' -- left eye
or problem_code ILIKE 'H16.293%' -- bilateral
/*or problem_code ILIKE 'H16.299%' --  unspecified eye*/
--  Unspecified interstitial keratitis
or problem_code ILIKE 'H16.301%' -- right eye
or problem_code ILIKE 'H16.302%' -- left eye
or problem_code ILIKE 'H16.303%' -- bilateral
/*or problem_code ILIKE 'H16.309%' --  unspecified eye*/
-- Corneal abscess
or problem_code ILIKE 'H16.311%' -- right eye
or problem_code ILIKE 'H16.312%' -- left eye
or problem_code ILIKE 'H16.313%' -- bilateral
/*or problem_code ILIKE 'H16.319%' --  unspecified eye*/
-- Diffuse interstitial keratitis
or problem_code ILIKE 'H16.321%' -- right eye
or problem_code ILIKE 'H16.322%' -- left eye
or problem_code ILIKE 'H16.323%' -- bilateral
/*or problem_code ILIKE 'H16.329%' --  unspecified eye*/
-- Sclerosing keratitis
or problem_code ILIKE 'H16.331%' -- right eye
or problem_code ILIKE 'H16.332%' -- left eye
or problem_code ILIKE 'H16.333%' -- bilateral
/*or problem_code ILIKE 'H16.339%' --  unspecified eye*/
-- Other interstitial and deep keratitis
or problem_code ILIKE 'H16.391%' -- right eye
or problem_code ILIKE 'H16.392%' -- left eye
or problem_code ILIKE 'H16.393%' -- bilateral
/*or problem_code ILIKE 'H16.399%' --  unspecified eye*/
--  Unspecified corneal neovascularization
or problem_code ILIKE 'H16.401%' -- right eye
or problem_code ILIKE 'H16.402%' -- left eye
or problem_code ILIKE 'H16.403%' -- bilateral
/*or problem_code ILIKE 'H16.409%' --  unspecified eye*/
-- Ghost vessels (corneal)
or problem_code ILIKE 'H16.411%' -- right eye
or problem_code ILIKE 'H16.412%' -- left eye
or problem_code ILIKE 'H16.413%' -- bilateral
/*or problem_code ILIKE 'H16.419%' --  unspecified eye*/
-- Pannus (corneal)
or problem_code ILIKE 'H16.421%' -- right eye
or problem_code ILIKE 'H16.422%' -- left eye
or problem_code ILIKE 'H16.423%' -- bilateral
/*or problem_code ILIKE 'H16.429%' --  unspecified eye*/
-- Localized vascularization of cornea
or problem_code ILIKE 'H16.431%' -- right eye
or problem_code ILIKE 'H16.432%' -- left eye
or problem_code ILIKE 'H16.433%' -- bilateral
/*or problem_code ILIKE 'H16.439%' --  unspecified eye*/
-- Deep vascularization of cornea
or problem_code ILIKE 'H16.441%' -- right eye
or problem_code ILIKE 'H16.442%' -- left eye
or problem_code ILIKE 'H16.443%' -- bilateral
/*or problem_code ILIKE 'H16.449%' --  unspecified eye*/
-- Other keratitis
or problem_code ILIKE 'H16.8%'
-- Unspecified keratitis
or problem_code ILIKE 'H16.9%'
-- Other disorders of cornea
	-- Unspecified corneal deposit
or problem_code ILIKE 'H18.001%' -- right eye
or problem_code ILIKE 'H18.002%' -- left eye
or problem_code ILIKE 'H18.003%' -- bilateral
/*or problem_code ILIKE 'H18.009%' --  unspecified eye*/
-- Anterior corneal pigmentations
or problem_code ILIKE 'H18.011%' -- right eye
or problem_code ILIKE 'H18.012%' -- left eye
or problem_code ILIKE 'H18.013%' -- bilateral
/*or problem_code ILIKE 'H18.019%' --  unspecified eye*/
-- Argentous corneal deposits
or problem_code ILIKE 'H18.021%' -- right eye
or problem_code ILIKE 'H18.022%' -- left eye
or problem_code ILIKE 'H18.023%' -- bilateral
/*or problem_code ILIKE 'H18.029%' --  unspecified eye*/
-- Corneal deposits in metabolic disorders
or problem_code ILIKE 'H18.031%' -- right eye
or problem_code ILIKE 'H18.032%' -- left eye
or problem_code ILIKE 'H18.033%' -- bilateral
/*or problem_code ILIKE 'H18.039%' --  unspecified eye*/
-- Kayser-Fleischer ring
or problem_code ILIKE 'H18.041%' -- right eye
or problem_code ILIKE 'H18.042%' -- left eye
or problem_code ILIKE 'H18.043%' -- bilateral
/*or problem_code ILIKE 'H18.049%' --  unspecified eye*/
-- Posterior corneal pigmentations
or problem_code ILIKE 'H18.051%' -- right eye
or problem_code ILIKE 'H18.052%' -- left eye
or problem_code ILIKE 'H18.053%' -- bilateral
/*or problem_code ILIKE 'H18.059%' --  unspecified eye*/
-- Stromal corneal pigmentations
or problem_code ILIKE 'H18.061%' -- right eye
or problem_code ILIKE 'H18.062%' -- left eye
or problem_code ILIKE 'H18.063%' -- bilateral
/*or problem_code ILIKE 'H18.069%' -- unspecified eye*/
-- Bullous keratopathy
or problem_code ILIKE 'H18.11%' -- right eye
or problem_code ILIKE 'H18.12%' -- left eye
or problem_code ILIKE 'H18.13%' -- bilateral
/*or problem_code ILIKE 'H18.10%' -- unspecified eye*/
-- Unspecified corneal edema
or problem_code ILIKE 'H18.20%'
-- Corneal edema secondary to contact lens
or problem_code ILIKE 'H18.211%' -- right eye
or problem_code ILIKE 'H18.212%' -- left eye
or problem_code ILIKE 'H18.213%' -- bilateral
/*or problem_code ILIKE 'H18.219%' -- unspecified eye*/
-- Idiopathic corneal edema
or problem_code ILIKE 'H18.221%' -- right eye
or problem_code ILIKE 'H18.222%' -- left eye
or problem_code ILIKE 'H18.223%' -- bilateral
/*or problem_code ILIKE 'H18.229%' -- unspecified eye*/
-- Secondary corneal edema
or problem_code ILIKE 'H18.221%' -- right eye
or problem_code ILIKE 'H18.222%' -- left eye
or problem_code ILIKE 'H18.223%' -- bilateral
/*or problem_code ILIKE 'H18.229%' -- unspecified eye*/
-- Unspecified corneal membrane change
or problem_code ILIKE 'H18.30%' 
-- Folds and rupture in Bowman's membrane
or problem_code ILIKE 'H18.311%' -- right eye
or problem_code ILIKE 'H18.312%' -- left eye
or problem_code ILIKE 'H18.313%' -- bilateral
/*or problem_code ILIKE 'H18.319%' -- unspecified eye*/
-- Folds in Descemet's membrane
or problem_code ILIKE 'H18.321%' -- right eye
or problem_code ILIKE 'H18.322%' -- left eye
or problem_code ILIKE 'H18.323%' -- bilateral
/*or problem_code ILIKE 'H18.329%' -- unspecified eye*/
-- Rupture in Descemet's membrane
or problem_code ILIKE 'H18.331%' -- right eye
or problem_code ILIKE 'H18.332%' -- left eye
or problem_code ILIKE 'H18.333%' -- bilateral
/*or problem_code ILIKE 'H18.339%' -- unspecified eye*/
-- Unspecified corneal degeneration
or problem_code ILIKE 'H18.40%' 
-- Arcus senilis
or problem_code ILIKE 'H18.411%' -- right eye
or problem_code ILIKE 'H18.412%' -- left eye
or problem_code ILIKE 'H18.413%' -- bilateral
/*or problem_code ILIKE 'H18.419%' -- unspecified eye*/
-- Band keratopathy
or problem_code ILIKE 'H18.421%' -- right eye
or problem_code ILIKE 'H18.422%' -- left eye
or problem_code ILIKE 'H18.423%' -- bilateral
/*or problem_code ILIKE 'H18.429%' -- unspecified eye*/
-- Other calcerous corneal degeneration
or problem_code ILIKE 'H18.43%'
-- Keratomalacia
or problem_code ILIKE 'H18.441%' -- right eye
or problem_code ILIKE 'H18.442%' -- left eye
or problem_code ILIKE 'H18.443%' -- bilateral
/*or problem_code ILIKE 'H18.449%' -- unspecified eye*/
-- Nodular corneal degeneration
or problem_code ILIKE 'H18.451%' -- right eye
or problem_code ILIKE 'H18.452%' -- left eye
or problem_code ILIKE 'H18.453%' -- bilateral
/*or problem_code ILIKE 'H18.459%' -- unspecified eye*/
-- Peripheral corneal degeneration
or problem_code ILIKE 'H18.461%' -- right eye
or problem_code ILIKE 'H18.462%' -- left eye
or problem_code ILIKE 'H18.463%' -- bilateral
/*or problem_code ILIKE 'H18.469%' -- unspecified eye*/
-- Other corneal degeneration
or problem_code ILIKE 'H18.49%'
-- Unspecified hereditary corneal dystrophies
or problem_code ILIKE 'H18.501%' -- right eye
or problem_code ILIKE 'H18.502%' -- left eye
or problem_code ILIKE 'H18.503%' -- bilateral
/*or problem_code ILIKE 'H18.509%' -- unspecified eye*/
-- Endothelial corneal dystrophy
or problem_code ILIKE 'H18.511%' -- right eye
or problem_code ILIKE 'H18.512%' -- left eye
or problem_code ILIKE 'H18.513%' -- bilateral
/*or problem_code ILIKE 'H18.519%' -- unspecified eye*/
-- Epithelial (juvenile) corneal dystrophy
or problem_code ILIKE 'H18.521%' -- right eye
or problem_code ILIKE 'H18.522%' -- left eye
or problem_code ILIKE 'H18.523%' -- bilateral
/*or problem_code ILIKE 'H18.529%' -- unspecified eye*/
-- Granular corneal dystrophy
or problem_code ILIKE 'H18.531%' -- right eye
or problem_code ILIKE 'H18.532%' -- left eye
or problem_code ILIKE 'H18.533%' -- bilateral
/*or problem_code ILIKE 'H18.539%' -- unspecified eye*/
-- Lattice corneal dystrophy
or problem_code ILIKE 'H18.541%' -- right eye
or problem_code ILIKE 'H18.542%' -- left eye
or problem_code ILIKE 'H18.543%' -- bilateral
/*or problem_code ILIKE 'H18.549%' -- unspecified eye*/
-- Macular corneal dystrophy
or problem_code ILIKE 'H18.551%' -- right eye
or problem_code ILIKE 'H18.552%' -- left eye
or problem_code ILIKE 'H18.553%' -- bilateral
/*or problem_code ILIKE 'H18.559%' -- unspecified eye*/
-- Other hereditary corneal dystrophies
or problem_code ILIKE 'H18.591%' -- right eye
or problem_code ILIKE 'H18.592%' -- left eye
or problem_code ILIKE 'H18.593%' -- bilateral
/*or problem_code ILIKE 'H18.599%' -- unspecified eye*/
-- Keratoconus, unspecified
or problem_code ILIKE 'H18.601%' -- right eye
or problem_code ILIKE 'H18.602%' -- left eye
or problem_code ILIKE 'H18.603%' -- bilateral
/*or problem_code ILIKE 'H18.609%' -- unspecified eye*/
-- Keratoconus, stable
or problem_code ILIKE 'H18.611%' -- right eye
or problem_code ILIKE 'H18.612%' -- left eye
or problem_code ILIKE 'H18.613%' -- bilateral
/*or problem_code ILIKE 'H18.619%' -- unspecified eye*/
-- Keratoconus, unstable
or problem_code ILIKE 'H18.621%' -- right eye
or problem_code ILIKE 'H18.622%' -- left eye
or problem_code ILIKE 'H18.623%' -- bilateral
/*or problem_code ILIKE 'H18.629%' -- unspecified eye*/
-- Unspecified corneal deformity
or problem_code ILIKE 'H18.70%'
-- Corneal ectasia
or problem_code ILIKE 'H18.711%' -- right eye
or problem_code ILIKE 'H18.712%' -- left eye
or problem_code ILIKE 'H18.713%' -- bilateral
/*or problem_code ILIKE 'H18.719%' -- unspecified eye*/
--  Corneal staphyloma
or problem_code ILIKE 'H18.721%' -- right eye
or problem_code ILIKE 'H18.722%' -- left eye
or problem_code ILIKE 'H18.723%' -- bilateral
/*or problem_code ILIKE 'H18.729%' -- unspecified eye*/
-- Descemetocele
or problem_code ILIKE 'H18.731%' -- right eye
or problem_code ILIKE 'H18.732%' -- left eye
or problem_code ILIKE 'H18.733%' -- bilateral
/*or problem_code ILIKE 'H18.739%' -- unspecified eye*/
-- Other corneal deformities
or problem_code ILIKE 'H18.791%' -- right eye
or problem_code ILIKE 'H18.792%' -- left eye
or problem_code ILIKE 'H18.793%' -- bilateral
/*or problem_code ILIKE 'H18.799%' -- unspecified eye*/
-- Anesthesia and hypoesthesia of cornea
or problem_code ILIKE 'H18.811%' -- right eye
or problem_code ILIKE 'H18.812%' -- left eye
or problem_code ILIKE 'H18.813%' -- bilateral
/*or problem_code ILIKE 'H18.819%' -- unspecified eye*/
-- Corneal disorder due to contact lens
or problem_code ILIKE 'H18.821%' -- right eye
or problem_code ILIKE 'H18.822%' -- left eye
or problem_code ILIKE 'H18.823%' -- bilateral
/*or problem_code ILIKE 'H18.829%' -- unspecified eye*/
-- Recurrent erosion of cornea
or problem_code ILIKE 'H18.831%' -- right eye
or problem_code ILIKE 'H18.832%' -- left eye
or problem_code ILIKE 'H18.833%' -- bilateral
/*or problem_code ILIKE 'H18.839%' -- unspecified eye*/
-- Other specified disorders of cornea
or problem_code ILIKE 'H18.891%' -- right eye
or problem_code ILIKE 'H18.892%' -- left eye
or problem_code ILIKE 'H18.893%' -- bilateral
/*or problem_code ILIKE 'H18.899%' -- unspecified eye*/
-- Unspecified disorder of cornea
or problem_code ILIKE 'H18.9%' 
-- Viral conjunctivitis
or problem_code ILIKE 'B30.%' 
-- Leprosy
or problem_code ILIKE '030.%' 
-- Diseases due to other mycobacteria
or problem_code ILIKE '031.%' 
-- Diphtheria 
or problem_code ILIKE '032.0%' -- Faucial diphtheria
or problem_code ILIKE '032.1%' -- Nasopharyngeal diphtheria
or problem_code ILIKE '032.2%' -- Anterior nasal diphtheria
or problem_code ILIKE '032.3%' -- Laryngeal diphtheria
or problem_code ILIKE '032.81%' -- Conjunctival diphtheria
or problem_code ILIKE '032.82%' -- Diphtheritic myocarditis
or problem_code ILIKE '032.83%' -- Diphtheritic peritonitis
or problem_code ILIKE '032.84%' -- Diphtheritic cystitis
or problem_code ILIKE '032.85%' -- Cutaneous diphtheria
or problem_code ILIKE '032.89%' -- Other specified diphtheria
or problem_code ILIKE '032.9%' -- Diphtheria, unspecified
-- Whooping cough
or problem_code ILIKE '033.%' 
-- Streptococcal sore throat and scarlet fever
or problem_code ILIKE '034.%' 
-- Erysipelas 
or problem_code ILIKE '035%' 
-- Meningococcal infection
or problem_code ILIKE '036.0%' -- Meningococcal meningitis
or problem_code ILIKE '036.1%' -- Meningococcal encephalitis
or problem_code ILIKE '036.2%' -- Meningococcemia
or problem_code ILIKE '036.3%' -- Waterhouse-Friderichsen syndrome, meningococcal
or problem_code ILIKE '036.40%' -- Meningococcal carditis, unspecified
or problem_code ILIKE '036.41%' -- Meningococcal pericarditis
or problem_code ILIKE '036.42%' -- Meningococcal endocarditis
or problem_code ILIKE '036.43%' -- Meningococcal myocarditis
or problem_code ILIKE '036.81%' -- Meningococcal optic neuritis
or problem_code ILIKE '036.82%' -- Meningococcal arthropathy
or problem_code ILIKE '036.89%' -- Other specified meningococcal infections
or problem_code ILIKE '036.9%' -- Meningococcal infection, unspecified
-- Tetanus 
or problem_code ILIKE '037%'
-- Streptococcal septicemia
or problem_code ILIKE '038.0%'
-- Staphylococcal septicemia
or problem_code ILIKE '038.10%' -- Staphylococcal septicemia, unspecified
or problem_code ILIKE '038.11%' -- Methicillin susceptible Staphylococcus aureus septicemia
or problem_code ILIKE '038.12%' -- Methicillin resistant Staphylococcus aureus septicemia 
or problem_code ILIKE '038.19%' -- Other staphylococcal septicemia
-- Pneumococcal septicemia [Streptococcus pneumoniae septicemia]
or problem_code ILIKE '038.2%' 
-- Septicemia due to anaerobes
or problem_code ILIKE '038.3%' 
-- Septicemia due to other gram-negative organisms
or problem_code ILIKE '038.40%' -- Septicemia due to gram-negative organism, unspecified 
or problem_code ILIKE '038.41%' -- Septicemia due to hemophilus influenzae [H. influenzae]
or problem_code ILIKE '038.42%' -- Septicemia due to escherichia coli [E. coli]
or problem_code ILIKE '038.43%' -- Septicemia due to pseudomonas
or problem_code ILIKE '038.44%' -- Septicemia due to serratia
or problem_code ILIKE '038.49%' -- Other septicemia due to gram-negative organisms
-- Other specified septicemias
or problem_code ILIKE '038.8%'
-- Unspecified septicemia
or problem_code ILIKE '038.9%'
-- Actinomycotic infections
or problem_code ILIKE '039.%'
-- Other bacterial diseases
or problem_code ILIKE '040.0%' -- Gas gangrene
or problem_code ILIKE '040.1%' -- Rhinoscleroma
or problem_code ILIKE '040.2%' -- Whipple's disease
or problem_code ILIKE '040.3%' -- Necrobacillosis
or problem_code ILIKE '040.41%' -- Infant botulism
or problem_code ILIKE '040.42%' -- Wound botulism
or problem_code ILIKE '040.81%' -- Tropical pyomyositis
or problem_code ILIKE '040.82%' -- Toxic shock syndrome
or problem_code ILIKE '040.89%' -- Other specified bacterial diseases
-- Bacterial infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.00%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, unspecified
or problem_code ILIKE '041.01%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group A
or problem_code ILIKE '041.02%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group B
or problem_code ILIKE '041.03%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group C
or problem_code ILIKE '041.04%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group D
or problem_code ILIKE '041.05%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, streptococcus, group G
or problem_code ILIKE '041.09%' -- Streptococcus infection in conditions classified elsewhere and of unspecified site, other streptococcus
-- Staphylococcus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.10%' -- Staphylococcus infection in conditions classified elsewhere and of unspecified site, staphylococcus, unspecified
or problem_code ILIKE '041.11%' -- Methicillin susceptible Staphylococcus aureus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.12%' -- Methicillin resistant Staphylococcus aureus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.19%' -- Staphylococcus infection in conditions classified elsewhere and of unspecified site, other staphylococcus
-- Pneumococcus infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.2%'
-- Friedländer's bacillus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.3%'
-- Escherichia coli [e. coli] infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.41%' -- Shiga toxin-producing Escherichia coli [E. coli] (STEC) O157
or problem_code ILIKE '041.42%' -- Other specified Shiga toxin-producing Escherichia coli [E. coli] (STEC)
or problem_code ILIKE '041.43%' -- Shiga toxin-producing Escherichia coli [E. coli] (STEC), unspecified
or problem_code ILIKE '041.49%' -- Other and unspecified Escherichia coli [E. coli]
-- Hemophilus influenzae [H. influenzae] infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.5%' 
-- Proteus (mirabilis) (morganii) infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.6%' 
-- Pseudomonas infection in conditions classified elsewhere and of unspecified site 
or problem_code ILIKE '041.7%' 
-- Other specified bacterial infections in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.81%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, mycoplasma
or problem_code ILIKE '041.82%' -- Bacteroides fragilis
or problem_code ILIKE '041.83%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, Clostridium perfringens
or problem_code ILIKE '041.84%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other anaerobes
or problem_code ILIKE '041.85%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other gram-negative organisms
or problem_code ILIKE '041.86%' -- Helicobacter pylori [H. pylori] 
or problem_code ILIKE '041.89%' -- Other specified bacterial infections in conditions classified elsewhere and of unspecified site, other specified bacteria
-- Bacterial infection, unspecified, in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '041.9%'
-- Human immunodeficiency virus [HIV] disease 
or problem_code ILIKE '042%'
-- Smallpox
or problem_code ILIKE '050.0%' -- Variola major
or problem_code ILIKE '050.1%' -- Alastrim
or problem_code ILIKE '050.2%' -- Modified smallpox
or problem_code ILIKE '050.9%' -- Smallpox, unspecified
-- Cowpox and paravaccinia 
or problem_code ILIKE '051.01%' -- Cowpox
or problem_code ILIKE '051.02%' -- Vaccinia not from vaccination 
or problem_code ILIKE '051.1%' -- Pseudocowpox
or problem_code ILIKE '051.2%' --  Contagious pustular dermatitis
or problem_code ILIKE '051.9%' -- Paravaccinia, unspecified
-- Chickenpox
or problem_code ILIKE '052.%'
-- Herpes zoster
or problem_code ILIKE '053.0%' -- Herpes zoster with meningitis
or problem_code ILIKE '053.10%' -- Herpes zoster with unspecified nervous system complication
or problem_code ILIKE '053.11%' -- Geniculate herpes zoster 
or problem_code ILIKE '053.12%' -- Postherpetic trigeminal neuralgia
or problem_code ILIKE '053.13%' -- Postherpetic polyneuropathy
or problem_code ILIKE '053.14%' -- Herpes zoster myelitis
or problem_code ILIKE '053.19%' -- Herpes zoster with other nervous system complications 
or problem_code ILIKE '053.20%' -- Herpes zoster dermatitis of eyelid
or problem_code ILIKE '053.21%' -- Herpes zoster keratoconjunctivitis
or problem_code ILIKE '053.22%' -- Herpes zoster iridocyclitis
or problem_code ILIKE '053.29%' -- Herpes zoster with other ophthalmic complications
or problem_code ILIKE '053.71%' -- Otitis externa due to herpes zoster
or problem_code ILIKE '053.79%' -- Herpes zoster with other specified complications
-- Herpes zoster with unspecified complication
or problem_code ILIKE '053.8%' 
-- Herpes zoster without mention of complication
or problem_code ILIKE '053.9%' 
-- Herpes simplex
or problem_code ILIKE '054.0%' -- Eczema herpeticum
or problem_code ILIKE '054.10%' -- Genital herpes, unspecified 
or problem_code ILIKE '054.11%' -- Herpetic vulvovaginitis
or problem_code ILIKE '054.12%' -- Herpetic ulceration of vulva
or problem_code ILIKE '054.13%' -- Herpetic infection of penis
or problem_code ILIKE '054.19%' -- Other genital herpes 
-- Herpetic gingivostomatitis
or problem_code ILIKE '054.2%'
-- Herpetic meningoencephalitis
or problem_code ILIKE '054.3%'
-- Herpes simplex with ophthalmic complications
or problem_code ILIKE '054.40%' -- Herpes simplex with unspecified ophthalmic complication
or problem_code ILIKE '054.41%' -- Herpes simplex dermatitis of eyelid
or problem_code ILIKE '054.42%' -- Dendritic keratitis
or problem_code ILIKE '054.43%' -- Herpes simplex disciform keratitis
or problem_code ILIKE '054.44%' -- Herpes simplex iridocyclitis
or problem_code ILIKE '054.49%' -- Herpes simplex with other ophthalmic complications 
-- Herpetic septicemia
or problem_code ILIKE '054.5%'
-- Herpetic whitlow
or problem_code ILIKE '054.6%'
-- Herpes simplex with other specified complications
or problem_code ILIKE '054.71%' -- Visceral herpes simplex
or problem_code ILIKE '054.72%' -- Herpes simplex meningitis 
or problem_code ILIKE '054.73%' -- Herpes simplex otitis externa 
or problem_code ILIKE '054.74%' -- Herpes simplex myelitis
or problem_code ILIKE '054.79%' -- Herpes simplex with other specified complications
-- Herpes simplex with unspecified complication
or problem_code ILIKE '054.8%' 
-- Herpes simplex without mention of complication
or problem_code ILIKE '054.9%'
-- Measles
or problem_code ILIKE '055.0%' -- Postmeasles encephalitis
or problem_code ILIKE '055.1%' -- Postmeasles pneumonia
or problem_code ILIKE '055.2%' -- Postmeasles otitis media
-- Measles with other specified complications
or problem_code ILIKE '055.71%' -- Measles keratoconjunctivitis
or problem_code ILIKE '055.79%' -- Measles with other specified complications
-- Measles with unspecified complication
or problem_code ILIKE '055.8%' 
-- Measles without mention of complication
or problem_code ILIKE '055.9%' 
-- Rubella
or problem_code ILIKE '056.00%' -- Rubella with unspecified neurological complication
or problem_code ILIKE '056.01%' -- Encephalomyelitis due to rubella
or problem_code ILIKE '056.09%' -- Rubella with other neurological complications 
-- Rubella with other specified complications
or problem_code ILIKE '056.71%' -- Arthritis due to rubella
or problem_code ILIKE '056.79%' -- Rubella with other specified complications
--  Rubella with unspecified complications
or problem_code ILIKE '056.8%'
-- Rubella without mention of complication
or problem_code ILIKE '056.9%'
-- Other viral exanthemata
or problem_code ILIKE '057.0%' -- Erythema infectiosum (fifth disease)
or problem_code ILIKE '057.8%' -- Other specified viral exanthemata
or problem_code ILIKE '057.9%' -- Viral exanthem, unspecified
-- Other human herpesvirus
or problem_code ILIKE '058.10%' -- Roseola infantum, unspecified
or problem_code ILIKE '058.11%' -- Roseola infantum due to human herpesvirus 6
or problem_code ILIKE '058.12%' -- Roseola infantum due to human herpesvirus 7
--  Other human herpesvirus encephalitis
or problem_code ILIKE '058.21%' -- Human herpesvirus 6 encephalitis
or problem_code ILIKE '058.29%' -- Other human herpesvirus encephalitis
--Other human herpesvirus infections
or problem_code ILIKE '058.81%' -- Human herpesvirus 6 infection
or problem_code ILIKE '058.82%' -- Human herpesvirus 7 infection
or problem_code ILIKE '058.89%' -- Other human herpesvirus infection
-- Other poxvirus infections
or problem_code ILIKE '059.00%' -- Orthopoxvirus infection, unspecified
or problem_code ILIKE '059.01%' -- Monkeypox
or problem_code ILIKE '059.09%' -- Other orthopoxvirus infections
or problem_code ILIKE '059.10%' -- Parapoxvirus infection, unspecified
or problem_code ILIKE '059.11%' -- Bovine stomatitis
or problem_code ILIKE '059.12%' -- Sealpox
or problem_code ILIKE '059.19%' -- Other parapoxvirus infections
or problem_code ILIKE '059.20%' -- Yatapoxvirus infection, unspecified
or problem_code ILIKE '059.21%' -- Tanapox 
or problem_code ILIKE '059.22%' -- Yaba monkey tumor virus
or problem_code ILIKE '059.8%' -- Other poxvirus infections
or problem_code ILIKE '059.9%' -- Poxvirus infections, unspecified
-- Yellow fever
or problem_code ILIKE '060.%' 
-- Dengue 
or problem_code ILIKE '061%' 
-- Mosquito-borne viral encephalitis
or problem_code ILIKE '062.%' 
-- Tick-borne viral encephalitis
or problem_code ILIKE '063.%' 
-- Viral encephalitis transmitted by other and unspecified arthropods 
or problem_code ILIKE '064%' 
-- Arthropod-borne hemorrhagic fever
or problem_code ILIKE '065.%'
-- Other arthropod-borne viral diseases
or problem_code ILIKE '066.0%' -- Phlebotomus fever
or problem_code ILIKE '066.1%' -- Tick-borne fever
or problem_code ILIKE '066.2%' -- Venezuelan equine fever
or problem_code ILIKE '066.3%' -- Other mosquito-borne fever
or problem_code ILIKE '066.40%' -- West Nile Fever, unspecified
or problem_code ILIKE '066.41%' -- West Nile Fever with encephalitis
or problem_code ILIKE '066.42%' -- West Nile Fever with other neurologic manifestation
or problem_code ILIKE '066.49%' -- West Nile Fever with other complications
-- Other specified arthropod-borne viral diseases
or problem_code ILIKE '066.8%'
-- Arthropod-borne viral disease, unspecified
-- Other specified arthropod-borne viral diseases
or problem_code ILIKE '066.9%'
-- Viral hepatitis
or problem_code ILIKE '070.0%' -- Viral hepatitis A with hepatic coma
or problem_code ILIKE '070.1%' -- Viral hepatitis A without mention of hepatic coma
-- Viral hepatitis b with hepatic coma
or problem_code ILIKE '070.20%' -- Viral hepatitis B with hepatic coma, acute or unspecified, without mention of hepatitis delta
or problem_code ILIKE '070.21%' -- Viral hepatitis B with hepatic coma, acute or unspecified, with hepatitis delta
or problem_code ILIKE '070.22%' -- Chronic viral hepatitis B with hepatic coma without hepatitis delta
or problem_code ILIKE '070.23%' -- Chronic viral hepatitis B with hepatic coma with hepatitis delta 
-- Viral hepatitis b without mention of hepatic coma
or problem_code ILIKE '070.30%' -- Viral hepatitis B without mention of hepatic coma, acute or unspecified, without mention of hepatitis delta
or problem_code ILIKE '070.31%' -- Viral hepatitis B without mention of hepatic coma, acute or unspecified, with hepatitis delta
or problem_code ILIKE '070.32%' -- Chronic viral hepatitis B without mention of hepatic coma without mention of hepatitis delta
or problem_code ILIKE '070.33%' -- Chronic viral hepatitis B without mention of hepatic coma with hepatitis delta
-- Other specified viral hepatitis with hepatic coma
or problem_code ILIKE '070.41%' -- Acute hepatitis C with hepatic coma
or problem_code ILIKE '070.42%' -- Hepatitis delta without mention of active hepatitis B disease with hepatic coma
or problem_code ILIKE '070.43%' -- Hepatitis E with hepatic coma
or problem_code ILIKE '070.44%' -- Chronic hepatitis C with hepatic coma
or problem_code ILIKE '070.49%' -- Other specified viral hepatitis with hepatic coma 
-- Other specified viral hepatitis without mention of hepatic coma
or problem_code ILIKE '070.51%' -- Acute hepatitis C without mention of hepatic coma
or problem_code ILIKE '070.52%' -- Hepatitis delta without mention of active hepatitis B disease or hepatic coma
or problem_code ILIKE '070.53%' -- Hepatitis E without mention of hepatic coma
or problem_code ILIKE '070.54%' -- Chronic hepatitis C without mention of hepatic coma
or problem_code ILIKE '070.59%' -- Other specified viral hepatitis without mention of hepatic coma
-- Unspecified viral hepatitis with hepatic coma
or problem_code ILIKE '070.6%' 
-- Unspecified viral hepatitis c
or problem_code ILIKE '070.70%' -- Unspecified viral hepatitis C without hepatic coma 
or problem_code ILIKE '070.71%' -- Unspecified viral hepatitis C with hepatic coma
-- Unspecified viral hepatitis without mention of hepatic coma
or problem_code ILIKE '070.9%'
-- Rabies 
or problem_code ILIKE '071%'
-- Mumps
or problem_code ILIKE '072.0%' -- Mumps orchitis
or problem_code ILIKE '072.1%' -- Mumps meningitis
or problem_code ILIKE '072.2%' -- Mumps encephalitis
or problem_code ILIKE '072.3%' -- Mumps pancreatitis
-- Mumps with other specified complications
or problem_code ILIKE '072.71%' -- Mumps hepatitis
or problem_code ILIKE '072.72%' -- Mumps polyneuropathy
or problem_code ILIKE '072.79%' -- Other mumps with other specified complications
-- Mumps with unspecified complication
or problem_code ILIKE '072.8%' 
-- Mumps without mention of complication
or problem_code ILIKE '072.9%' 
-- Ornithosis 
or problem_code ILIKE '073.%' 
-- Specific diseases due to coxsackie virus
or problem_code ILIKE '074.0%' -- Herpangina
or problem_code ILIKE '074.1%' -- Epidemic pleurodynia
-- Coxsackie carditis
or problem_code ILIKE '074.20%' -- Coxsackie carditis, unspecified
or problem_code ILIKE '074.21%' -- Coxsackie pericarditis
or problem_code ILIKE '074.22%' -- Coxsackie endocarditis
or problem_code ILIKE '074.23%' -- Coxsackie myocarditis
-- Hand, foot, and mouth disease
or problem_code ILIKE '074.3%' 
-- Other specified diseases due to Coxsackie virus
or problem_code ILIKE '074.8%' 
-- Infectious mononucleosis 
or problem_code ILIKE '075%' 
-- Trachoma
or problem_code ILIKE '076.%' 
-- Other diseases of conjunctiva due to viruses and chlamydiae
or problem_code ILIKE '077.0%' -- Inclusion conjunctivitis
or problem_code ILIKE '077.1%' -- Epidemic keratoconjunctivitis
or problem_code ILIKE '077.2%' -- Pharyngoconjunctival fever
or problem_code ILIKE '077.3%' -- Other adenoviral conjunctivitis
or problem_code ILIKE '077.4%' -- Epidemic hemorrhagic conjunctivitis
or problem_code ILIKE '077.8%' -- Other viral conjunctivitis
-- Unspecified diseases of conjunctiva due to viruses and chlamydiae
or problem_code ILIKE '077.98%' -- Unspecified diseases of conjunctiva due to chlamydiae
or problem_code ILIKE '077.99%' -- Unspecified diseases of conjunctiva due to viruses
-- Other diseases due to viruses and chlamydiae 
or problem_code ILIKE '078.0%' -- Molluscum contagiosum
-- Viral warts
or problem_code ILIKE '078.10%' -- Viral warts, unspecified
or problem_code ILIKE '078.11%' -- Condyloma acuminatum
or problem_code ILIKE '078.12%' -- Plantar wart
or problem_code ILIKE '078.19%' -- Other specified viral warts
-- Sweating fever 
or problem_code ILIKE '078.2%'
-- Cat-scratch disease
or problem_code ILIKE '078.3%'
-- Foot and mouth disease
or problem_code ILIKE '078.4%'
-- Cytomegaloviral disease
or problem_code ILIKE '078.5%'
-- Hemorrhagic nephrosonephritis
or problem_code ILIKE '078.6%'
-- Arenaviral hemorrhagic fever
or problem_code ILIKE '078.7%'
-- Other specified diseases due to viruses and chlamydiae
or problem_code ILIKE '078.81%' -- Epidemic vertigo
or problem_code ILIKE '078.82%' -- Epidemic vomiting syndrome
or problem_code ILIKE '078.88%' -- Other specified diseases due to chlamydiae
or problem_code ILIKE '078.89%' -- Other specified diseases due to viruses
-- Viral and chlamydial infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.0%' -- Adenovirus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.1%' -- Echo virus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.2%' -- Coxsackie virus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.3%' -- Rhinovirus infection in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.4%' -- Human papillomavirus in conditions classified elsewhere and of unspecified site
-- Retrovirus in conditions classified elsewhere and of unspecified site
or problem_code ILIKE '079.50%' -- Retrovirus, unspecified
or problem_code ILIKE '079.51%' -- Human T-cell lymphotrophic virus, type I [HTLV-I]
or problem_code ILIKE '079.52%' -- Human T-cell lymphotrophic virus, type II [HTLV-II]
or problem_code ILIKE '079.53%' -- Human immunodeficiency virus, type 2 [HIV-2]
or problem_code ILIKE '079.59%' -- Other specified retrovirus
--  Respiratory syncytial virus (RSV)
or problem_code ILIKE '079.6%' 
-- Other specified viral and chlamydial infections
or problem_code ILIKE '079.81%' -- Hantavirus infection
or problem_code ILIKE '079.82%' -- SARS-associated coronavirus
or problem_code ILIKE '079.83%' -- Parvovirus B19
or problem_code ILIKE '079.88%' -- Other specified chlamydial infection
or problem_code ILIKE '079.89%' -- Other specified viral infection
-- Unspecified viral and chlamydial infections
or problem_code ILIKE '079.98%' -- Unspecified chlamydial infection
or problem_code ILIKE '079.99%' -- Unspecified viral infection
-- Congenital syphilis
or problem_code ILIKE '090.0%' -- Early congenital syphilis, symptomatic
or problem_code ILIKE '090.1%' -- Early congenital syphilis, latent
or problem_code ILIKE '090.2%' -- Early congenital syphilis, unspecified
or problem_code ILIKE '090.3%' -- Syphilitic interstitial keratitis
-- Juvenile neurosyphilis
or problem_code ILIKE '090.40%' -- Juvenile neurosyphilis, unspecified
or problem_code ILIKE '090.41%' -- Congenital syphilitic encephalitis
or problem_code ILIKE '090.42%' -- Congenital syphilitic meningitis
or problem_code ILIKE '090.49%' -- Other juvenile neurosyphilis
-- Other late congenital syphilis, symptomatic
or problem_code ILIKE '090.5%'
-- Late congenital syphilis, latent
or problem_code ILIKE '090.6%'
-- Late congenital syphilis, unspecified 
or problem_code ILIKE '090.7%'
-- Congenital syphilis, unspecified
or problem_code ILIKE '090.9%'
-- Early syphilis symptomatic
or problem_code ILIKE '091.0%' -- Genital syphilis (primary)
or problem_code ILIKE '091.1%' -- Primary anal syphilis 
or problem_code ILIKE '091.2%' -- Other primary syphilis
or problem_code ILIKE '091.3%' -- Secondary syphilis of skin or mucous membranes
or problem_code ILIKE '091.4%' -- Adenopathy due to secondary syphilis
-- Uveitis due to secondary syphilis
or problem_code ILIKE '091.50%' -- Syphilitic uveitis, unspecified
or problem_code ILIKE '091.51%' -- Syphilitic chorioretinitis (secondary)
or problem_code ILIKE '091.52%' -- Syphilitic iridocyclitis (secondary)
-- Secondary syphilis of viscera and bone
or problem_code ILIKE '091.61%' -- Secondary syphilitic periostitis
or problem_code ILIKE '091.62%' -- Secondary syphilitic hepatitis
or problem_code ILIKE '091.69%' -- Secondary syphilis of other viscera
-- Secondary syphilis, relapse
or problem_code ILIKE '091.7%'
-- Other forms of secondary syphilis
or problem_code ILIKE '091.81%' -- Acute syphilitic meningitis (secondary)
or problem_code ILIKE '091.82%' -- Syphilitic alopecia
or problem_code ILIKE '091.89%' -- Other forms of secondary syphilis
-- Unspecified secondary syphilis
or problem_code ILIKE '091.9%'
-- Early syphilis latent
or problem_code ILIKE '092.%'
-- Cardiovascular syphilis
or problem_code ILIKE '093.0%' -- Aneurysm of aorta, specified as syphilitic
or problem_code ILIKE '093.1%' -- Syphilitic aortitis
-- Syphilitic endocarditis
or problem_code ILIKE '093.20%' -- Syphilitic endocarditis of valve, unspecified 
or problem_code ILIKE '093.21%' -- Syphilitic endocarditis of mitral valve
or problem_code ILIKE '093.22%' -- Syphilitic endocarditis of aortic valve
or problem_code ILIKE '093.23%' -- Syphilitic endocarditis of tricuspid valve
or problem_code ILIKE '093.24%' -- Syphilitic endocarditis of pulmonary valve
--  Other specified cardiovascular syphilis
or problem_code ILIKE '093.81%' -- Syphilitic pericarditis
or problem_code ILIKE '093.82%' -- Syphilitic myocarditis
or problem_code ILIKE '093.89%' -- Other specified cardiovascular syphilis
-- Cardiovascular syphilis, unspecified
or problem_code ILIKE '093.9%'
-- Neurosyphilis 
or problem_code ILIKE '094.0%' -- Tabes dorsalis
or problem_code ILIKE '094.1%' -- General paresis
or problem_code ILIKE '094.2%' -- Syphilitic meningitis
or problem_code ILIKE '094.3%' -- Asymptomatic neurosyphilis
-- Other specified neurosyphilis
or problem_code ILIKE '094.81%' -- Syphilitic encephalitis
or problem_code ILIKE '094.82%' -- Syphilitic parkinsonism 
or problem_code ILIKE '094.83%' -- Syphilitic disseminated retinochoroiditis
or problem_code ILIKE '094.84%' -- Syphilitic optic atrophy
or problem_code ILIKE '094.85%' -- Syphilitic retrobulbar neuritis
or problem_code ILIKE '094.86%' -- Syphilitic acoustic neuritis
or problem_code ILIKE '094.87%' -- Syphilitic ruptured cerebral aneurysm
or problem_code ILIKE '094.89%' -- Other specified neurosyphilis
-- Neurosyphilis, unspecified
or problem_code ILIKE '094.9%'
-- Other forms of late syphilis with symptoms
or problem_code ILIKE '095.%'
-- Late syphilis, latent 
or problem_code ILIKE '096%'
-- Other and unspecified syphilis
or problem_code ILIKE '097.%'
-- Gonococcal infections
--Gonococcal infection (acute) of lower genitourinary tract
or problem_code ILIKE '098.0%' -- Gonococcal infection (acute) of lower genitourinary tract
-- Gonococcal infection (acute) of upper genitourinary tract
or problem_code ILIKE '098.10%' -- Gonococcal infection (acute) of upper genitourinary tract, site unspecified
or problem_code ILIKE '098.11%' -- Gonococcal cystitis (acute)
or problem_code ILIKE '098.12%' -- Gonococcal prostatitis (acute)
or problem_code ILIKE '098.13%' -- Gonococcal epididymo-orchitis (acute)
or problem_code ILIKE '098.14%' -- Gonococcal seminal vesiculitis (acute)
or problem_code ILIKE '098.15%' -- Gonococcal cervicitis (acute)
or problem_code ILIKE '098.16%' -- Gonococcal endometritis (acute)
or problem_code ILIKE '098.17%' -- Gonococcal salpingitis, specified as acute
or problem_code ILIKE '098.19%' -- Other gonococcal infection (acute) of upper genitourinary tract
-- Gonococcal infection, chronic, of lower genitourinary tract
or problem_code ILIKE '098.2%'
--Gonococcal infection chronic of upper genitourinary tract
or problem_code ILIKE '098.30%' -- Chronic gonococcal infection of upper genitourinary tract, site unspecified 
or problem_code ILIKE '098.31%' -- Gonococcal cystitis, chronic
or problem_code ILIKE '098.32%' -- Gonococcal prostatitis, chronic
or problem_code ILIKE '098.33%' -- Gonococcal epididymo-orchitis, chronic
or problem_code ILIKE '098.34%' -- Gonococcal seminal vesiculitis, chronic
or problem_code ILIKE '098.35%' -- Gonococcal cervicitis, chronic
or problem_code ILIKE '098.36%' -- Gonococcal endometritis, chronic
or problem_code ILIKE '098.37%' -- Gonococcal salpingitis (chronic) 
or problem_code ILIKE '098.39%' -- Other chronic gonococcal infection of upper genitourinary tract
-- Gonococcal infection of eye
or problem_code ILIKE '098.40%' -- Gonococcal conjunctivitis (neonatorum)
or problem_code ILIKE '098.41%' -- Gonococcal iridocyclitis
or problem_code ILIKE '098.42%' -- Gonococcal endophthalmia 
or problem_code ILIKE '098.43%' -- Gonococcal keratitis
or problem_code ILIKE '098.49%' -- Other gonococcal infection of eye
-- Gonococcal infection of joint
or problem_code ILIKE '098.50%' -- Gonococcal arthritis
or problem_code ILIKE '098.51%' -- Gonococcal synovitis and tenosynovitis
or problem_code ILIKE '098.52%' -- Gonococcal bursitis
or problem_code ILIKE '098.53%' -- Gonococcal spondylitis
or problem_code ILIKE '098.59%' -- Other gonococcal infection of joint 
-- Gonococcal infection of pharynx
or problem_code ILIKE '098.6%'
-- Gonococcal infection of anus and rectum
or problem_code ILIKE '098.7%'
-- Gonococcal infection of other specified sites
or problem_code ILIKE '098.81%' -- Gonococcal keratosis (blennorrhagica)
or problem_code ILIKE '098.82%' -- Gonococcal meningitis
or problem_code ILIKE '098.83%' -- Gonococcal pericarditis
or problem_code ILIKE '098.84%' -- Gonococcal endocarditis
or problem_code ILIKE '098.85%' -- Other gonococcal heart disease
or problem_code ILIKE '098.86%' -- Gonococcal peritonitis
or problem_code ILIKE '098.89%' -- Gonococcal infection of other specified sites
-- Other venereal diseases
or problem_code ILIKE '099.0%' -- Chancroid
or problem_code ILIKE '099.1%' -- Lymphogranuloma venereum
or problem_code ILIKE '099.2%' -- Granuloma inguinale
or problem_code ILIKE '099.3%' -- Reiter's disease
-- Other nongonococcal urethritis
or problem_code ILIKE '099.40%' -- Other nongonococcal urethritis, unspecified
or problem_code ILIKE '099.41%' -- Other nongonococcal urethritis, chlamydia trachomatis
or problem_code ILIKE '099.49%' -- Other nongonococcal urethritis, other specified organism
--Other venereal diseases due to chlamydia trachomatis
or problem_code ILIKE '099.50%' -- Other venereal diseases due to chlamydia trachomatis, unspecified site
or problem_code ILIKE '099.51%' -- Other venereal diseases due to chlamydia trachomatis, pharynx
or problem_code ILIKE '099.52%' -- Other venereal diseases due to chlamydia trachomatis, anus and rectum
or problem_code ILIKE '099.53%' -- Other venereal diseases due to chlamydia trachomatis, lower genitourinary sites
or problem_code ILIKE '099.54%' -- Other venereal diseases due to chlamydia trachomatis, other genitourinary sites
or problem_code ILIKE '099.55%' -- Other venereal diseases due to chlamydia trachomatis, unspecified genitourinary site
or problem_code ILIKE '099.56%' -- Other venereal diseases due to chlamydia trachomatis, peritoneum
or problem_code ILIKE '099.59%' -- Other venereal diseases due to chlamydia trachomatis, other specified site
--Other specified venereal diseases
or problem_code ILIKE '099.8%'
-- Venereal disease, unspecified 
or problem_code ILIKE '099.9%'
-- Dermatophytosis
or problem_code ILIKE '110.%'
-- Dermatomycosis other and unspecified
or problem_code ILIKE '111.%'
-- Candidiasis
or problem_code ILIKE '112.0%' -- Candidiasis of mouth
or problem_code ILIKE '112.1%' -- Candidiasis of vulva and vagina
or problem_code ILIKE '112.2%' -- Candidiasis of other urogenital sites
or problem_code ILIKE '112.3%' -- Candidiasis of skin and nails
or problem_code ILIKE '112.4%' -- Candidiasis of lung
or problem_code ILIKE '112.5%' -- Disseminated candidiasis
-- Candidiasis of other specified sites
or problem_code ILIKE '112.81%' -- Candidal endocarditis
or problem_code ILIKE '112.82%' -- Candidal otitis externa
or problem_code ILIKE '112.83%' -- Candidal meningitis
or problem_code ILIKE '112.84%' -- Candidal esophagitis
or problem_code ILIKE '112.85%' -- Candidal enteritis
or problem_code ILIKE '112.89%' -- Other candidiasis of other specified sites
-- Candidiasis of unspecified site
or problem_code ILIKE '112.9%' 
-- Coccidioidomycosis
or problem_code ILIKE '114.%' 
-- Histoplasmosis
or problem_code ILIKE '115.00%' -- Infection by Histoplasma capsulatum, without mention of manifestation
or problem_code ILIKE '115.01%' -- Infection by Histoplasma capsulatum, meningitis
or problem_code ILIKE '115.02%' -- Infection by Histoplasma capsulatum, retinitis
or problem_code ILIKE '115.03%' -- Infection by Histoplasma capsulatum, pericarditis
or problem_code ILIKE '115.04%' -- Infection by Histoplasma capsulatum, endocarditis
or problem_code ILIKE '115.05%' -- Infection by Histoplasma capsulatum, pneumonia
or problem_code ILIKE '115.09%' -- Infection by Histoplasma capsulatum, other 
-- Infection by histoplasma duboisii
or problem_code ILIKE '115.10%' -- Infection by Histoplasma duboisii, without mention of manifestation
or problem_code ILIKE '115.11%' -- Infection by Histoplasma duboisii, meningitis
or problem_code ILIKE '115.12%' -- Infection by Histoplasma duboisii, retinitis
or problem_code ILIKE '115.13%' -- Infection by Histoplasma duboisii, pericarditis
or problem_code ILIKE '115.14%' -- Infection by Histoplasma duboisii, endocarditis
or problem_code ILIKE '115.15%' -- Infection by Histoplasma duboisii, pneumonia
or problem_code ILIKE '115.19%' -- Infection by Histoplasma duboisii, other
-- Histoplasmosis unspecified
or problem_code ILIKE '115.90%' -- Histoplasmosis, unspecified, without mention of manifestation
or problem_code ILIKE '115.91%' -- Histoplasmosis, unspecified, meningitis
or problem_code ILIKE '115.92%' -- Histoplasmosis, unspecified, retinitis
or problem_code ILIKE '115.93%' -- Histoplasmosis, unspecified, pericarditis
or problem_code ILIKE '115.94%' -- Histoplasmosis, unspecified, endocarditis
or problem_code ILIKE '115.95%' -- Histoplasmosis, unspecified, pneumonia
or problem_code ILIKE '115.99%' -- Histoplasmosis, unspecified, other
-- Blastomycotic infection 
or problem_code ILIKE '116.%'
-- Other mycoses
or problem_code ILIKE '117.%'
-- Opportunistic mycoses 
or problem_code ILIKE '118%'
-- Schistosomiasis (bilharziasis) 
or problem_code ILIKE '120%'
-- Other trematode infections
or problem_code ILIKE '121.%'
-- Echinococcosis
or problem_code ILIKE '122.%'
-- Other cestode infection 
or problem_code ILIKE '123.%'
-- Trichinosis
or problem_code ILIKE '124%'
-- Filarial infection and dracontiasis
or problem_code ILIKE '125.%'
-- Ancylostomiasis and necatoriasis
or problem_code ILIKE '126.%'
-- Other intestinal helminthiases
or problem_code ILIKE '127.%'
-- Other and unspecified helminthiases
or problem_code ILIKE '128.%'
-- Intestinal parasitism, unspecified 
or problem_code ILIKE '129%'
-- Other and unspecified infectious and parasitic diseases
or problem_code ILIKE '136.0%' -- Ainhum
or problem_code ILIKE '136.1%' -- Behcet's syndrome 
-- Specific infections by free-living amebae
or problem_code ILIKE '136.21%' -- Specific infection due to acanthamoeba
or problem_code ILIKE '136.29%' -- Other specific infections by free-living amebae
-- Pneumocystosis
or problem_code ILIKE '136.3%'
-- Psorospermiasis
or problem_code ILIKE '136.4%'
-- Sarcosporidiosis
or problem_code ILIKE '136.5%'
-- Other specified infectious and parasitic diseases
or problem_code ILIKE '136.8%'
-- Unspecified infectious and parasitic diseases
or problem_code ILIKE '136.9%'
-- Corneal staphyloma
or problem_code ILIKE '371.73%'
-- Infection with drug-resistant microorganisms 
or problem_code ILIKE 'V09.0%' -- Infection with microorganisms resistant to penicillins
or problem_code ILIKE 'V09.1%' -- Infection with microorganisms resistant to cephalosporins and other B-lactam antibiotics
or problem_code ILIKE 'V09.2%' -- Infection with microorganisms resistant to macrolides
or problem_code ILIKE 'V09.3%' -- Infection with microorganisms resistant to tetracyclines 
or problem_code ILIKE 'V09.4%' -- Infection with microorganisms resistant to aminoglycosides
-- Infection with microorganisms resistant to quinolones and fluoroquinolones
or problem_code ILIKE 'V09.50%' -- Infection with microorganisms without mention of resistance to multiple quinolones and fluroquinolones
or problem_code ILIKE 'V09.51%' -- Infection with microorganisms with resistance to multiple quinolones and fluroquinolones
-- Infection with microorganisms resistant to sulfonamides
or problem_code ILIKE 'V09.6%' 
-- Infection with microorganisms resistant to other specified antimycobacterial agents
or problem_code ILIKE 'V09.70%' -- Infection with microorganisms without mention of resistance to multiple antimycobacterial agents
or problem_code ILIKE 'V09.71%' -- Infection with microorganisms with resistance to multiple antimycobacterial agents
-- Infection with microorganisms resistant to other specified drugs
or problem_code ILIKE 'V09.80%' -- Infection with microorganisms without mention of resistance to multiple drugs
or problem_code ILIKE 'V09.81%' -- Infection with microorganisms with resistance to multiple drugs
-- Infection with drug-resistant microorganisms unspecified
or problem_code ILIKE 'V09.90%' -- Infection with drug-resistant microorganisms, unspecified, without mention of multiple drug resistance
or problem_code ILIKE 'V09.91%' -- Infection with drug-resistant microorganisms, unspecified, with multiple drug resistance
and extract(year from diagnosis_date) BETWEEN 2015 and 2018
and diag_eye='3'));


drop table if exists aao_grants.liet_diag_pull_new4;
create table aao_grants.liet_diag_pull_new4 as
(select distinct patient_guid,
case when (documentation_date > problem_onset_date) and problem_onset_date is not null then problem_onset_date
when (problem_onset_date > documentation_date) and documentation_date is not null then documentation_date
when problem_onset_date is null then documentation_date
when documentation_date is null then problem_onset_date
when documentation_date=problem_onset_date then documentation_date
end as diagnosis_date,
case when diag_eye='3' then 2
end as eye,
practice_id,
case
				when (problem_description ilike '%without CSME%' 
				or problem_description ilike '428341000124108' 
				or problem_description ilike '%Non-Center Involved Diabetic Macular Edema%' 
				or problem_description ilike '%no evidence of clinically significant macular edema%' 
				or problem_description ilike '%Borderline CSME%' 
				or problem_description ilike '%No SRH/SRF/Lipid/CSME%' 
				or problem_description ilike '%No Clinically Significant Macular Edema%' 
				or problem_description ilike '%No CSME%' 
				or problem_description ilike '%Clinically Significant Macular Edema, Focal%' 
				or problem_description ilike '%Borderline Clinically Significant Macular Edema%' 
				or problem_description ilike '%(-) CSME%' 
				or problem_description ilike '%w/o CSME%' 
				or problem_description ilike '%CSME  (?)%'  
				or problem_description ilike '%?CSME%' 
				or problem_description ilike '%No CSME/DME%'  
				or problem_description ilike '%(--) CSME%'
				or problem_description ilike '%No NPDR (diabetic retinopathy) or CSME%'
				or problem_description ilike '%(-)CSME%' 
				or problem_description ilike '%no heme, exudate, CSME, NVD, NVE%' 
				or problem_description ilike '%no_CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%no DR or CSME noted%' 
				or problem_description ilike '%Clinically Significant Macular Edema is absent%' 
				or problem_description ilike '%neg CSME%' 
				or problem_description ilike '%=-CSME%' 
				or problem_description ilike '%no BDR/ CSME%' 
				or problem_description ilike '%diabetes WITHOUT signs of diabetic retinopathy or clinically significant macular edema%' 
				or problem_description ilike '%no macular edema%' 
				or problem_description ilike '%no diabetic retinopathy, NVE, NVD or CSME%' 
				or problem_description ilike '%no background diabetic retinopathy or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%Non-Center-Involved Diabetic Macular Edema%' 
				or problem_description ilike '%No DME or CSME%' 
				or problem_description ilike '%NO   CSME%' 
				or problem_description ilike '%No CSME-DME%' 
				or problem_description ilike '%No Diabetic Retinopathy or CSME%' 
				or problem_description ilike '%no heme,exudates,or CSME%' 
				or problem_description ilike '%(-)BDR/CSME%' 
				or problem_description ilike '%no diabetic retinopathy or CSME%' 
				or problem_description ilike '%no NV/CSME%' 
				or problem_description ilike '%No BDR, CSME, NVD, NVE, NVE%' 
				or problem_description ilike '%CSME -' 
				or problem_description ilike '%(-) BDR or CSME%'
				or problem_description ilike '%(-)BDR or CSME%'
				or problem_description ilike '%without Clinically Significant Macular Edema%'
				or problem_description ilike '%Diabetes without retinopathy or clinically significant macular edema%') then 0
				
				when (problem_description ilike 'CSME%' 
				or problem_description ilike 'Clinically Significant Macular Edema%' 
				or problem_description ilike '%with clinically significant macular edema%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF RIGHT EYE DETERMINED BY EXAMINATION%' 
				or problem_description ilike 'CLINICALLY SIGNIFICANT MACULAR EDEMA OF LEFT EYE DETERMINED BY EXAMINATION%'
				or problem_description ilike 'Center Involved Diabetic Macular Edema%' 
				or problem_description ilike 'CSME (Diabetes Related Mac. Edema)%' 
				or problem_description ilike 'Clinically Significant Macular Edema, Diffuse%' 
				or problem_description ilike 'CSME_clinically significant macular edema%' 
				or problem_description ilike 'EDEMA-CSME%'  
				or problem_description ilike 'Clinically significant macular edema (disorder)%' 
				or problem_description ilike 'edema CSME%' 
				or problem_description ilike 'CSME (Clinically Significant  Mac. Edema)%' 
				or problem_description ilike '%has developed CSME%' 
				or problem_description ilike '%(+) CSME%' 
				or problem_description ilike 'Diabetes - CSME (250.52) (OCT)%' 
				or problem_description ilike 'Clinically significant macular edema of right eye%' 
				or problem_description ilike 'Clinically significant macular edema of left eye%' 
				or problem_description ilike 'CSME (H35.81%)' 
				or problem_description ilike '%management of clinically significant macular edema%' 
				or problem_description ilike '%with CSME%' 
				or problem_description ilike 'Clinically significant macular edema associated with type 2 diabetes%' 
				or problem_description ilike 'Center-Involved Diabetic Macular Edema%'
				or problem_description ilike 'On examination - clinically significant macular edema of left eye%' 
				or problem_description ilike 'On examination - clinically significant macular edema of right eye%') then 1
				
				when (problem_comment ilike '%no clinically significant macular edema%' 
				or problem_comment ilike '%no CSME%' 
				or problem_comment ilike '%negative CSME%' 
				or problem_comment ilike '%No NVD, NVE, Vit Hem or CSME%' 
				or problem_comment ilike '%(-)CSME%' 
				or problem_comment ilike '%No NVD/NVE/CSME%' 
				or problem_comment ilike '%CSMEnegative%' 
				or problem_comment ilike '%No Diabetic Retinopathy, macular edema or CSME%' 
				or problem_comment ilike '%=-CSME%' 
				or problem_comment ilike '%no BDR, CSME, NVE%' 
				or problem_comment ilike '%(-) CSME%' 
				or problem_comment ilike '%no hemorrhages, exudates, pigmentary changes or macular edemano clinically significant macular edema%' 
				or problem_comment ilike '%no clinically significant macular edemanegative%' 
				or problem_comment ilike '%no hemorrhage or exudatesno clinically significant macular edema%' 
				or problem_comment ilike '%no signs of clinically significant macular edema%' 
				or problem_comment ilike '%clinically significant macular edemanegative%' 
				or problem_comment ilike '%Mild NPDR without macular edema or CSME%' 
				or problem_comment ilike '%no MAs, DBH, or CSME%' 
				or problem_comment ilike '%no signs of neovascularization or clinically significant macular edema%' 
				or problem_comment ilike '%retinopathyno clinically significant macular edema%' 
				or problem_comment ilike '%without clinically significant macular edema%' 
				or problem_comment ilike '%No diabetic retinopathy or clinically significant macular edema%' 
				or problem_comment ilike '%No NVE/CSME%' 
				or problem_comment ilike '%no MA, DBH, NV, CSME%' 
				or problem_comment ilike '%No MAs, heme or CSME%' 
				or problem_comment ilike '%=- CSME%' 
				or problem_comment ilike '%No DR or CSME%' 
				or problem_comment ilike '?CSME%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%No NPDR, PDR, or CSME%' 
				or problem_comment ilike '%without CSME%' 
				or problem_comment ilike '%w/o  CSME%' 
				or problem_comment ilike '%borderline CSME%' 
				or problem_comment ilike '%Negative CSME%' 
				or problem_comment ilike '%CSME - neg%' 
				or problem_comment ilike '%neg. CSME%' 
				or problem_comment ilike '%(-)NPDR/PDR/CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%No signs of CSME%' 
				or problem_comment ilike '%mild CSME%' 
				or problem_comment ilike '%negative BDR, CSME%' 
				or problem_comment ilike '%CSMEabsent%' 
				or problem_comment ilike '%(-) clinically significant macular edema%' 
				or problem_comment ilike '%no retinopathy, CSME or neovascularization%' 
				or problem_comment ilike '%without macular edema or CSME%' 
				or problem_comment ilike '%not CSME%' 
				or problem_comment ilike '%? CSME%' 
				or problem_comment ilike '%Neg CSME%' 
				or problem_comment ilike '%CSMEno%' 
				or problem_comment ilike '%no MAs, heme or CSME%' 
				or problem_comment ilike '-CSME%'
				or problem_comment ilike '%No signs of Retinopathy or neovascularization, or CSME%') then 0
				
				when (problem_comment ilike 'clinically significant macular edema%'
				or problem_comment ilike 'CSME%' 
				or problem_comment ilike 'DM, CSME%'
				or problem_comment ilike '%Diabetic Retinopathy With CSME%' 
				or problem_comment ilike '%=+ CSME%' 
				or problem_comment ilike '%=+CSME%' 
				or problem_comment ilike '%Mild non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME diabetic retinopathy%' 
				or problem_comment ilike '%Proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike 'CSME (clinically significant macular edema%)' 
				or problem_comment ilike '%Moderate non-proliferative diabetic retinopathyclinically significant macular edema%' 
				or problem_comment ilike '%no evidence of non-proliferative diabetic retinopathy or clinically significant macular edema%') then 1
				else 99 end as csme_status
from madrid2.patient_problem_laterality 
WHERE (
-- ICD-10
-- Leprosy [Hansen's disease]
 problem_code ILIKE 'A30.%'
-- Infection due to other mycobacteria
or problem_code ILIKE 'A31.%'
-- Listeriosis
or problem_code ILIKE 'A32.0%' -- Cutaneous listeriosis
-- Listerial meningitis and meningoencephalitis
or problem_code ILIKE 'A32.11%' -- Listerial meningitis
or problem_code ILIKE 'A32.12%' -- Listerial meningoencephalitis
-- Listerial sepsis
or problem_code ILIKE 'A32.7%'
-- Other forms of listeriosis
or problem_code ILIKE 'A32.81%' -- Oculoglandular listeriosis
or problem_code ILIKE 'A32.82%' -- Listerial endocarditis
or problem_code ILIKE 'A32.89%' -- Other forms of listeriosis
-- Listeriosis, unspecified
or problem_code ILIKE 'A32.9%'
-- Tetanus neonatorum 
or problem_code ILIKE 'A33%'
-- Obstetrical tetanus 
or problem_code ILIKE 'A34%'
-- Other tetanus 
or problem_code ILIKE 'A35%'
-- Diphtheria
or problem_code ILIKE 'A36.0%' -- Pharyngeal diphtheria
or problem_code ILIKE 'A36.1%' -- Nasopharyngeal diphtheria
or problem_code ILIKE 'A36.2%' -- Laryngeal diphtheria
or problem_code ILIKE 'A36.3%' -- Cutaneous diphtheria
-- Other diphtheria
or problem_code ILIKE 'A36.81%' -- Diphtheritic cardiomyopathy
or problem_code ILIKE 'A36.82%' -- Diphtheritic radiculomyelitis
or problem_code ILIKE 'A36.83%' -- Diphtheritic polyneuritis
or problem_code ILIKE 'A36.84%' -- Diphtheritic tubulo-interstitial nephropathy
or problem_code ILIKE 'A36.85%' -- Diphtheritic cystitis
or problem_code ILIKE 'A36.86%' -- Diphtheritic conjunctivitis
or problem_code ILIKE 'A36.89%' -- Other diphtheritic complications
-- Diphtheria, unspecified
or problem_code ILIKE 'A36.9%'
-- Whooping cough
-- Whooping cough due to Bordetella pertussis
or problem_code ILIKE 'A37.00%' -- without pneumonia
or problem_code ILIKE 'A37.01%' -- with pneumonia
-- Whooping cough due to Bordetella parapertussis
or problem_code ILIKE 'A37.10%' -- without pneumonia
or problem_code ILIKE 'A37.11%' -- with pneumonia
--  Whooping cough due to other Bordetella species
or problem_code ILIKE 'A37.80%' -- without pneumonia
or problem_code ILIKE 'A37.81%' -- with pneumonia
-- Whooping cough, unspecified species
or problem_code ILIKE 'A37.90%' -- without pneumonia
or problem_code ILIKE 'A37.91%' -- with pneumonia
-- Scarlet fever 
or problem_code ILIKE 'A38.%' 
-- Meningococcal infection
or problem_code ILIKE 'A39.0%' -- Meningococcal meningitis
or problem_code ILIKE 'A39.1%' -- Waterhouse-Friderichsen syndrome
or problem_code ILIKE 'A39.2%' -- Acute meningococcemia
or problem_code ILIKE 'A39.3%' -- Chronic meningococcemia
or problem_code ILIKE 'A39.4%' -- Meningococcemia, unspecified
-- Meningococcal heart disease
or problem_code ILIKE 'A39.50%' -- Meningococcal carditis, unspecified
or problem_code ILIKE 'A39.51%' --  Meningococcal endocarditis
or problem_code ILIKE 'A39.52%' -- Meningococcal myocarditis
or problem_code ILIKE 'A39.53%' -- Meningococcal pericarditis
-- Other meningococcal infections
or problem_code ILIKE 'A39.81%' -- Meningococcal encephalitis
or problem_code ILIKE 'A39.82%' -- Meningococcal retrobulbar neuritis
or problem_code ILIKE 'A39.83%' -- Meningococcal arthritis
or problem_code ILIKE 'A39.84%' -- Postmeningococcal arthritis
or problem_code ILIKE 'A39.89%' -- Other meningococcal infections
-- Meningococcal infection, unspecified
or problem_code ILIKE 'A39.9%'
-- Streptococcal sepsis
or problem_code ILIKE 'A40.%'
-- Other sepsis 
-- Sepsis due to Staphylococcus aureus
or problem_code ILIKE 'A41.01%' -- Sepsis due to Methicillin susceptible Staphylococcus aureus
or problem_code ILIKE 'A41.02%' --  Sepsis due to Methicillin resistant Staphylococcus aureus
-- Sepsis due to other specified staphylococcus
or problem_code ILIKE 'A41.1%' 
--Sepsis due to unspecified staphylococcus
or problem_code ILIKE 'A41.2%' 
-- Sepsis due to Hemophilus influenzae
or problem_code ILIKE 'A41.3%' 
-- Sepsis due to anaerobes
or problem_code ILIKE 'A41.4%' 
-- Sepsis due to other Gram-negative organisms
or problem_code ILIKE 'A41.50%' -- Gram-negative sepsis, unspecified
or problem_code ILIKE 'A41.51%' -- Sepsis due to Escherichia coli [E. coli]
or problem_code ILIKE 'A41.52%' -- Sepsis due to Pseudomonas
or problem_code ILIKE 'A41.53%' -- Sepsis due to Serratia
or problem_code ILIKE 'A41.59%' -- Other Gram-negative sepsis
-- Other specified sepsis
or problem_code ILIKE 'A41.81%' -- Sepsis due to Enterococcus
or problem_code ILIKE 'A41.89%' -- Other specified sepsis
-- Sepsis, unspecified organism
or problem_code ILIKE 'A41.9%'
-- Actinomycosis
or problem_code ILIKE 'A42.0%' -- Pulmonary actinomycosis
or problem_code ILIKE 'A42.1%' -- Abdominal actinomycosis
or problem_code ILIKE 'A42.2%' -- Cervicofacial actinomycosis
or problem_code ILIKE 'A42.7%' -- Actinomycotic sepsis
-- Other forms of actinomycosis
or problem_code ILIKE 'A42.81%' -- Actinomycotic meningitis
or problem_code ILIKE 'A42.82%' -- Actinomycotic encephalitis
or problem_code ILIKE 'A42.89%' -- Other forms of actinomycosis
-- Actinomycosis, unspecified
or problem_code ILIKE 'A42.9%' 
-- Nocardiosis
or problem_code ILIKE 'A43.%'
-- Bartonellosis
or problem_code ILIKE 'A44.%'
-- Erysipelas 
or problem_code ILIKE 'A46%'
-- Other bacterial diseases, not elsewhere classified
or problem_code ILIKE 'A48.0%' -- Gas gangrene
or problem_code ILIKE 'A48.1%' -- Legionnaires' disease
or problem_code ILIKE 'A48.2%' -- Nonpneumonic Legionnaires' disease [Pontiac fever]
or problem_code ILIKE 'A48.3%' -- Toxic shock syndrome
or problem_code ILIKE 'A48.4%' -- Brazilian purpuric fever
--  Other specified botulism
or problem_code ILIKE 'A48.51%' -- Infant botulism
or problem_code ILIKE 'A48.52%' -- Wound botulism
-- Other specified bacterial diseases
or problem_code ILIKE 'A48.8%'
-- Bacterial infection of unspecified site
-- Staphylococcal infection, unspecified site
or problem_code ILIKE 'A49.01%' -- Methicillin susceptible Staphylococcus aureus infection, unspecified site
or problem_code ILIKE 'A49.02%' -- Methicillin resistant Staphylococcus aureus infection, unspecified site
-- Streptococcal infection, unspecified site
or problem_code ILIKE 'A49.1%' 
-- Hemophilus influenzae infection, unspecified site
or problem_code ILIKE 'A49.2%' 
-- Mycoplasma infection, unspecified site
or problem_code ILIKE 'A49.3%'
-- Other bacterial infections of unspecified site
or problem_code ILIKE 'A49.8%'
-- Bacterial infection, unspecified
or problem_code ILIKE 'A49.9%'
-- Congenital syphilis
-- Early congenital syphilis, symptomatic
or problem_code ILIKE 'A50.01%' -- Early congenital syphilitic oculopathy
or problem_code ILIKE 'A50.02%' -- Early congenital syphilitic osteochondropathy
or problem_code ILIKE 'A50.03%' --  Early congenital syphilitic pharyngitis
or problem_code ILIKE 'A50.04%' -- Early congenital syphilitic pneumonia
or problem_code ILIKE 'A50.05%' -- Early congenital syphilitic rhinitis
or problem_code ILIKE 'A50.06%' -- Early cutaneous congenital syphilis
or problem_code ILIKE 'A50.07%' -- Early mucocutaneous congenital syphilis
or problem_code ILIKE 'A50.08%' -- Early visceral congenital syphilis
or problem_code ILIKE 'A50.09%' -- Other early congenital syphilis, symptomatic
-- Early congenital syphilis, latent
or problem_code ILIKE 'A50.1%'
-- Early congenital syphilis, unspecified
or problem_code ILIKE 'A50.2%'
--  Late congenital syphilitic oculopathy
or problem_code ILIKE 'A50.30%' -- unspecified
or problem_code ILIKE 'A50.31%' -- Late congenital syphilitic interstitial keratitis
or problem_code ILIKE 'A50.32%' -- Late congenital syphilitic chorioretinitis
or problem_code ILIKE 'A50.39%' -- Other late congenital syphilitic oculopathy
-- Late congenital neurosyphilis [juvenile neurosyphilis]
or problem_code ILIKE 'A50.40%' -- Late congenital neurosyphilis, unspecified
or problem_code ILIKE 'A50.41%' -- Late congenital syphilitic meningitis
or problem_code ILIKE 'A50.42%' -- Late congenital syphilitic encephalitis
or problem_code ILIKE 'A50.43%' -- Late congenital syphilitic polyneuropathy
or problem_code ILIKE 'A50.44%' -- Late congenital syphilitic optic nerve atrophy
or problem_code ILIKE 'A50.45%' -- Juvenile general paresis
or problem_code ILIKE 'A50.49%' -- Other late congenital neurosyphilis
-- Other late congenital syphilis, symptomatic
or problem_code ILIKE 'A50.51%' -- Clutton's joints
or problem_code ILIKE 'A50.52%' -- Hutchinson's teeth
or problem_code ILIKE 'A50.53%' -- Hutchinson's triad
or problem_code ILIKE 'A50.54%' -- Late congenital cardiovascular syphilis
or problem_code ILIKE 'A50.55%' -- Late congenital syphilitic arthropathy
or problem_code ILIKE 'A50.56%' -- Late congenital syphilitic osteochondropathy
or problem_code ILIKE 'A50.57%' -- Syphilitic saddle nose
or problem_code ILIKE 'A50.59%' -- Other late congenital syphilis, symptomatic
-- Late congenital syphilis, latent
or problem_code ILIKE 'A50.6%'
-- Late congenital syphilis, unspecified
or problem_code ILIKE 'A50.7%'
-- Congenital syphilis, unspecified
or problem_code ILIKE 'A50.9%'
-- Early syphilis 
or problem_code ILIKE 'A51.0%' -- Primary genital syphilis
or problem_code ILIKE 'A51.1%' -- Primary anal syphilis
or problem_code ILIKE 'A51.2%' -- Primary syphilis of other sites
-- Secondary syphilis of skin and mucous membranes
or problem_code ILIKE 'A51.31%' -- Condyloma latum
or problem_code ILIKE 'A51.32%' -- Syphilitic alopecia
or problem_code ILIKE 'A51.39%' -- Other secondary syphilis of skin
-- Other secondary syphilis
or problem_code ILIKE 'A51.41%' -- Secondary syphilitic meningitis
or problem_code ILIKE 'A51.42%' -- Secondary syphilitic female pelvic disease
or problem_code ILIKE 'A51.43%' -- Secondary syphilitic oculopathy
or problem_code ILIKE 'A51.44%' -- Secondary syphilitic nephritis
or problem_code ILIKE 'A51.45%' -- Secondary syphilitic hepatitis
or problem_code ILIKE 'A51.46%' -- Secondary syphilitic osteopathy
or problem_code ILIKE 'A51.49%' -- Other secondary syphilitic conditions
-- Early syphilis, latent
or problem_code ILIKE 'A51.5%'
-- Early syphilis, unspecified
or problem_code ILIKE 'A51.9%'
-- Late syphilis
-- Cardiovascular and cerebrovascular syphilis
or problem_code ILIKE 'A52.00%' -- Cardiovascular syphilis, unspecified
or problem_code ILIKE 'A52.01%' -- Syphilitic aneurysm of aorta
or problem_code ILIKE 'A52.02%' -- Syphilitic aortitis
or problem_code ILIKE 'A52.03%' -- Syphilitic endocarditis
or problem_code ILIKE 'A52.04%' -- Syphilitic cerebral arteritis
or problem_code ILIKE 'A52.05%' -- Other cerebrovascular syphilis
or problem_code ILIKE 'A52.06%' -- Other syphilitic heart involvement
or problem_code ILIKE 'A52.09%' -- Other cardiovascular syphilis
--  Symptomatic neurosyphilis
or problem_code ILIKE 'A52.10%' -- unspecified
or problem_code ILIKE 'A52.11%' -- Tabes dorsalis
or problem_code ILIKE 'A52.12%' -- Other cerebrospinal syphilis
or problem_code ILIKE 'A52.13%' -- Late syphilitic meningitis
or problem_code ILIKE 'A52.14%' -- Late syphilitic encephalitis
or problem_code ILIKE 'A52.15%' -- Late syphilitic neuropathy
or problem_code ILIKE 'A52.16%' -- Charcôt's arthropathy (tabetic)
or problem_code ILIKE 'A52.17%' -- General paresis
or problem_code ILIKE 'A52.19%' -- Other symptomatic neurosyphilis
-- Asymptomatic neurosyphilis
or problem_code ILIKE 'A52.2%'
-- Neurosyphilis, unspecified
or problem_code ILIKE 'A52.3%'
-- Other symptomatic late syphilis
or problem_code ILIKE 'A52.71%' -- Late syphilitic oculopathy
or problem_code ILIKE 'A52.72%' -- Syphilis of lung and bronchus
or problem_code ILIKE 'A52.73%' -- Symptomatic late syphilis of other respiratory organs
or problem_code ILIKE 'A52.74%' -- Syphilis of liver and other viscera
or problem_code ILIKE 'A52.75%' -- Syphilis of kidney and ureter
or problem_code ILIKE 'A52.76%' -- Other genitourinary symptomatic late syphilis
or problem_code ILIKE 'A52.77%' -- Syphilis of bone and joint
or problem_code ILIKE 'A52.78%' -- Syphilis of other musculoskeletal tissue
or problem_code ILIKE 'A52.79%' -- Other symptomatic late syphilis
-- Late syphilis, latent
or problem_code ILIKE 'A52.8%' 
-- Late syphilis, unspecified
or problem_code ILIKE 'A52.9%'
-- Other and unspecified syphilis
or problem_code ILIKE 'A53.%'
-- Gonococcal infection
-- Gonococcal infection of lower genitourinary tract without periurethral or accessory gland abscess
or problem_code ILIKE 'A54.00%' -- Gonococcal infection of lower genitourinary tract, unspecified
or problem_code ILIKE 'A54.01%' -- Gonococcal cystitis and urethritis, unspecified
or problem_code ILIKE 'A54.02%' -- Gonococcal vulvovaginitis, unspecified
or problem_code ILIKE 'A54.03%' -- Gonococcal cervicitis, unspecified
or problem_code ILIKE 'A54.09%' -- Other gonococcal infection of lower genitourinary tract
-- Gonococcal infection of lower genitourinary tract with periurethral and accessory gland abscess
or problem_code ILIKE 'A54.1%'
-- Gonococcal pelviperitonitis and other gonococcal genitourinary infection
or problem_code ILIKE 'A54.21%' -- Gonococcal infection of kidney and ureter
or problem_code ILIKE 'A54.22%' -- Gonococcal prostatitis
or problem_code ILIKE 'A54.23%' -- Gonococcal infection of other male genital organs
or problem_code ILIKE 'A54.24%' -- Gonococcal female pelvic inflammatory disease
or problem_code ILIKE 'A54.29%' -- Other gonococcal genitourinary infections
-- Gonococcal infection of eye
or problem_code ILIKE 'A54.30%' -- unspecified
or problem_code ILIKE 'A54.31%' -- Gonococcal conjunctivitis
or problem_code ILIKE 'A54.32%' -- Gonococcal iridocyclitis
or problem_code ILIKE 'A54.33%' -- Gonococcal keratitis
or problem_code ILIKE 'A54.39%' -- Other gonococcal eye infection
-- Gonococcal infection of musculoskeletal system
or problem_code ILIKE 'A54.40%' -- unspecified
or problem_code ILIKE 'A54.41%' -- Gonococcal spondylopathy
or problem_code ILIKE 'A54.42%' -- Gonococcal arthritis
or problem_code ILIKE 'A54.43%' -- Gonococcal osteomyelitis
or problem_code ILIKE 'A54.49%' -- Gonococcal infection of other musculoskeletal tissue
-- Gonococcal pharyngitis
or problem_code ILIKE 'A54.5%' 
-- Gonococcal infection of anus and rectum
or problem_code ILIKE 'A54.6%' 
-- Other gonococcal infections
or problem_code ILIKE 'A54.81%' -- Gonococcal meningitis
or problem_code ILIKE 'A54.82%' -- Gonococcal brain abscess
or problem_code ILIKE 'A54.83%' -- Gonococcal heart infection
or problem_code ILIKE 'A54.84%' -- Gonococcal pneumonia
or problem_code ILIKE 'A54.85%' -- Gonococcal peritonitis
or problem_code ILIKE 'A54.86%' -- Gonococcal sepsis
or problem_code ILIKE 'A54.89%' -- Other gonococcal infections
-- Gonococcal infection, unspecified
or problem_code ILIKE 'A54.9%'
-- Chlamydial lymphogranuloma (venereum) 
or problem_code ILIKE 'A55%'
-- Other sexually transmitted chlamydial diseases
-- Chlamydial infection of lower genitourinary tract
or problem_code ILIKE 'A56.00%' -- unspecified
or problem_code ILIKE 'A56.01%' -- Chlamydial cystitis and urethritis
or problem_code ILIKE 'A56.02%' -- Chlamydial vulvovaginitis
or problem_code ILIKE 'A56.09%' -- Other chlamydial infection of lower genitourinary tract
-- Chlamydial infection of pelviperitoneum and other genitourinary organs
or problem_code ILIKE 'A56.11%' -- Chlamydial female pelvic inflammatory disease
or problem_code ILIKE 'A56.19%' -- Other chlamydial genitourinary infection
-- Chlamydial infection of genitourinary tract, unspecified
or problem_code ILIKE 'A56.2%'
-- Chlamydial infection of anus and rectum
or problem_code ILIKE 'A56.3%'
-- Chlamydial infection of pharynx
or problem_code ILIKE 'A56.4%'
-- Sexually transmitted chlamydial infection of other sites
or problem_code ILIKE 'A56.8%'
-- Chancroid 
or problem_code ILIKE 'A57%'
-- Granuloma inguinale 
or problem_code ILIKE 'A58%'
-- Trichomoniasis, unspecified 
or problem_code ILIKE 'A59%'
-- Anogenital herpesviral [herpes simplex] infections
-- Herpesviral infection of genitalia and urogenital tract
or problem_code ILIKE 'A60.00%' -- Herpesviral infection of urogenital system, unspecified
or problem_code ILIKE 'A60.01%' -- Herpesviral infection of penis
or problem_code ILIKE 'A60.02%' -- Herpesviral infection of other male genital organs
or problem_code ILIKE 'A60.03%' -- Herpesviral cervicitis
or problem_code ILIKE 'A60.04%' -- Herpesviral vulvovaginitis
or problem_code ILIKE 'A60.09%' -- Herpesviral infection of other urogenital tract
-- Herpesviral infection of perianal skin and rectum
or problem_code ILIKE 'A60.1%'
-- Anogenital herpesviral infection, unspecified
or problem_code ILIKE 'A60.9%'
-- Other predominantly sexually transmitted diseases, not elsewhere classified 
or problem_code ILIKE 'A63.%'
-- Unspecified sexually transmitted disease 
or problem_code ILIKE 'A64%'
-- Nonvenereal syphilis 
or problem_code ILIKE 'A65%'
-- Yaws 
or problem_code ILIKE 'A66.%'
-- Pinta [carate]
or problem_code ILIKE 'A67.%'
-- Relapsing fevers
or problem_code ILIKE 'A68.%'
-- Other spirochetal infections
or problem_code ILIKE 'A69.0%' -- Necrotizing ulcerative stomatitis
or problem_code ILIKE 'A69.1%' -- Other Vincent's infections
-- Lyme disease
or problem_code ILIKE 'A69.20%' -- unspecified
or problem_code ILIKE 'A69.21%' -- Meningitis due to Lyme disease
or problem_code ILIKE 'A69.22%' -- Other neurologic disorders in Lyme disease
or problem_code ILIKE 'A69.23%' -- Arthritis due to Lyme disease
or problem_code ILIKE 'A69.29%' -- Other conditions associated with Lyme disease
-- Other specified spirochetal infections
or problem_code ILIKE 'A69.8%'
-- Spirochetal infection, unspecified
or problem_code ILIKE 'A69.9%'
-- Chlamydia psittaci infections 
or problem_code ILIKE 'A70%'
-- Trachoma
or problem_code ILIKE 'A71.%'
-- Other diseases caused by chlamydiae
or problem_code ILIKE 'A74.0%' -- Chlamydial conjunctivitis
-- Other chlamydial diseases
or problem_code ILIKE 'A74.81%' -- Chlamydial peritonitis
or problem_code ILIKE 'A74.89%' -- Other chlamydial diseases
-- Chlamydial infection, unspecified
or problem_code ILIKE 'A74.9%'
-- Acute poliomyelitis
or problem_code ILIKE 'A80.0%' -- Acute paralytic poliomyelitis, vaccine-associated
or problem_code ILIKE 'A80.1%' -- Acute paralytic poliomyelitis, wild virus, imported
or problem_code ILIKE 'A80.2%' -- Acute paralytic poliomyelitis, wild virus, indigenous
-- Acute paralytic poliomyelitis, other and unspecified
or problem_code ILIKE 'A80.30%' -- Acute paralytic poliomyelitis, unspecified
or problem_code ILIKE 'A80.39%' -- Other acute paralytic poliomyelitis
-- Acute nonparalytic poliomyelitis
or problem_code ILIKE 'A80.4%'
-- Acute poliomyelitis, unspecified
or problem_code ILIKE 'A80.9%'
-- Atypical virus infections of central nervous system
-- Creutzfeldt-Jakob disease
or problem_code ILIKE 'A81.00%' -- unspecified
or problem_code ILIKE 'A81.01%' -- Variant Creutzfeldt-Jakob disease
or problem_code ILIKE 'A81.09%' -- Other Creutzfeldt-Jakob disease
-- Subacute sclerosing panencephalitis
or problem_code ILIKE 'A81.1%'
-- Progressive multifocal leukoencephalopathy
or problem_code ILIKE 'A81.2%'
-- Other atypical virus infections of central nervous system
or problem_code ILIKE 'A81.81%' -- Kuru
or problem_code ILIKE 'A81.82%' -- Gerstmann-Sträussler-Scheinker syndrome
or problem_code ILIKE 'A81.83%' -- Fatal familial insomnia
or problem_code ILIKE 'A81.89%' -- Other atypical virus infections of central nervous system
-- Atypical virus infection of central nervous system, unspecified
or problem_code ILIKE 'A81.9%'
-- Rabies
or problem_code ILIKE 'A82.%'
-- Mosquito-borne viral encephalitis
or problem_code ILIKE 'A83.%'
-- Tick-borne viral encephalitis
or problem_code ILIKE 'A84.0%' -- Far Eastern tick-borne encephalitis [Russian spring-summer encephalitis]
or problem_code ILIKE 'A84.1%' -- Central European tick-borne encephalitis
-- Other tick-borne viral encephalitis
or problem_code ILIKE 'A84.81%' -- Powassan virus disease
or problem_code ILIKE 'A84.89%' -- Other tick-borne viral encephalitis
-- Tick-borne viral encephalitis, unspecified
or problem_code ILIKE 'A84.9%' 
-- Other viral encephalitis, not elsewhere classified 
or problem_code ILIKE 'A85.%'
-- Unspecified viral encephalitis 
or problem_code ILIKE 'A86%'
-- Viral meningitis
or problem_code ILIKE 'A87.%'
-- Other viral infections of central nervous system, not elsewhere classified 
or problem_code ILIKE 'A88.%'
-- Unspecified viral infection of central nervous system 
or problem_code ILIKE 'A89%'
-- Dengue fever [classical dengue] 
or problem_code ILIKE 'A90%'
-- Dengue hemorrhagic fever 
or problem_code ILIKE 'A91%'
-- Other mosquito-borne viral fevers 
or problem_code ILIKE 'A92.0%' -- Chikungunya virus disease
or problem_code ILIKE 'A92.1%' -- O'nyong-nyong fever
or problem_code ILIKE 'A92.2%' -- Venezuelan equine fever
-- West Nile virus infection
or problem_code ILIKE 'A92.30%' -- unspecified
or problem_code ILIKE 'A92.31%' -- with encephalitis
or problem_code ILIKE 'A92.32%' -- with other neurologic manifestation
or problem_code ILIKE 'A92.39%' -- with other complications
-- Rift Valley fever
or problem_code ILIKE 'A92.4%'
-- Zika virus disease
or problem_code ILIKE 'A92.5%'
-- Other specified mosquito-borne viral fevers
or problem_code ILIKE 'A92.8%'
-- Mosquito-borne viral fever, unspecified
or problem_code ILIKE 'A92.9%'
-- Other arthropod-borne viral fevers, not elsewhere classified 
or problem_code ILIKE 'A93.%'
-- Unspecified arthropod-borne viral fever 
or problem_code ILIKE 'A94%'
-- Yellow fever
or problem_code ILIKE 'A95.%'
-- Arenaviral hemorrhagic fever
or problem_code ILIKE 'A96.%'
-- Other viral hemorrhagic fevers, not elsewhere classified
or problem_code ILIKE 'A98.%'
-- Unspecified viral hemorrhagic fever 
or problem_code ILIKE 'A99%' 
-- Herpesviral [herpes simplex] infections
or problem_code ILIKE 'B00.0%' -- Eczema herpeticum
or problem_code ILIKE 'B00.1%' -- Herpesviral vesicular dermatitis
or problem_code ILIKE 'B00.2%' -- Herpesviral gingivostomatitis and pharyngotonsillitis
or problem_code ILIKE 'B00.3%' -- Herpesviral meningitis
or problem_code ILIKE 'B00.4%' -- Herpesviral encephalitis
-- Herpesviral ocular disease
or problem_code ILIKE 'B00.50%' -- unspecified
or problem_code ILIKE 'B00.51%' -- Herpesviral iridocyclitis
or problem_code ILIKE 'B00.52%' -- Herpesviral keratitis
or problem_code ILIKE 'B00.53%' -- Herpesviral conjunctivitis
or problem_code ILIKE 'B00.59%' -- Other herpesviral disease of eye
-- Disseminated herpesviral disease
or problem_code ILIKE 'B00.7%'
-- Other forms of herpesviral infections
or problem_code ILIKE 'B00.81%' -- Herpesviral hepatitis
or problem_code ILIKE 'B00.82%' -- Herpes simplex myelitis
or problem_code ILIKE 'B00.89%' -- Other herpesviral infection
-- Herpesviral infection, unspecified
or problem_code ILIKE 'B00.9%'
-- Varicella [chickenpox] 
or problem_code ILIKE 'B01.0%' -- Varicella meningitis
--  Varicella encephalitis, myelitis and encephalomyelitis
or problem_code ILIKE 'B01.11%' -- Varicella encephalitis and encephalomyelitis
or problem_code ILIKE 'B01.12%' -- Varicella myelitis
-- Varicella pneumonia
or problem_code ILIKE 'B01.2%'
-- Varicella with other complications
or problem_code ILIKE 'B01.81%' -- Varicella keratitis
or problem_code ILIKE 'B01.89%' -- Other varicella complications
-- Varicella without complication
or problem_code ILIKE 'B01.9%'
-- Zoster [herpes zoster] 
or problem_code ILIKE 'B02.0%' -- Zoster encephalitis
or problem_code ILIKE 'B02.1%' -- Zoster meningitis
-- Zoster with other nervous system involvement
or problem_code ILIKE 'B02.21%' -- Postherpetic geniculate ganglionitis
or problem_code ILIKE 'B02.22%' -- Postherpetic trigeminal neuralgia
or problem_code ILIKE 'B02.23%' -- Postherpetic polyneuropathy
or problem_code ILIKE 'B02.24%' -- Postherpetic myelitis
or problem_code ILIKE 'B02.29%' -- Other postherpetic nervous system involvement
-- Zoster ocular disease
or problem_code ILIKE 'B02.30%' -- unspecified
or problem_code ILIKE 'B02.31%' -- Zoster conjunctivitis
or problem_code ILIKE 'B02.32%' -- Zoster iridocyclitis
or problem_code ILIKE 'B02.33%' -- Zoster keratitis
or problem_code ILIKE 'B02.34%' -- Zoster scleritis
or problem_code ILIKE 'B02.39%' -- Other herpes zoster eye disease
-- Disseminated zoster
or problem_code ILIKE 'B02.7%'
-- Zoster with other complications
or problem_code ILIKE 'B02.8%'
-- Zoster without complications
or problem_code ILIKE 'B02.9%'
-- Smallpox 
or problem_code ILIKE 'B03%'
-- Monkeypox 
or problem_code ILIKE 'B04%'
-- Measles
or problem_code ILIKE 'B05.0%' -- Measles complicated by encephalitis
or problem_code ILIKE 'B05.1%' -- Measles complicated by meningitis
or problem_code ILIKE 'B05.2%' -- Measles complicated by pneumonia
or problem_code ILIKE 'B05.3%' -- Measles complicated by otitis media
or problem_code ILIKE 'B05.4%' -- Measles with intestinal complications
-- Measles with other complications
or problem_code ILIKE 'B05.81%' -- Measles keratitis and keratoconjunctivitis
or problem_code ILIKE 'B05.89%' -- Other measles complications
-- Measles without complication
or problem_code ILIKE 'B05.9%'
-- Rubella [German measles]
or problem_code ILIKE 'B06.00%' -- Rubella with neurological complications
or problem_code ILIKE 'B06.01%' -- Rubella encephalitis
or problem_code ILIKE 'B06.02%' -- Rubella meningitis
or problem_code ILIKE 'B06.09%' -- Other neurological complications of rubella
-- Rubella with other complications
or problem_code ILIKE 'B06.81%' -- Rubella pneumonia
or problem_code ILIKE 'B06.82%' -- Rubella arthritis
or problem_code ILIKE 'B06.89%' -- Other rubella complications
-- Rubella without complication
or problem_code ILIKE 'B06.9%' 
-- Viral warts
or problem_code ILIKE 'B07.%' 
-- Other viral infections characterized by skin and mucous membrane lesions, not elsewhere classified
-- Cowpox and vaccinia not from vaccine
or problem_code ILIKE 'B08.010%' -- Cowpox
or problem_code ILIKE 'B08.011%' -- Vaccinia not from vaccine
-- Orf virus disease
or problem_code ILIKE 'B08.02%'
-- Pseudocowpox [milker's node] 
or problem_code ILIKE 'B08.03%'
-- Paravaccinia, unspecified
or problem_code ILIKE 'B08.04%'
-- Other orthopoxvirus infections
or problem_code ILIKE 'B08.09%'
-- Molluscum contagiosum
or problem_code ILIKE 'B08.1%'
-- Exanthema subitum [sixth disease]
or problem_code ILIKE 'B08.20%' -- unspecified
or problem_code ILIKE 'B08.21%' -- due to human herpesvirus 6
or problem_code ILIKE 'B08.22%' -- due to human herpesvirus 7
-- Erythema infectiosum [fifth disease]
or problem_code ILIKE 'B08.3%'
--  Enteroviral vesicular stomatitis with exanthem
or problem_code ILIKE 'B08.4%'
-- Enteroviral vesicular pharyngitis
or problem_code ILIKE 'B08.5%'
-- Parapoxvirus infections
or problem_code ILIKE 'B08.60%' -- Parapoxvirus infection, unspecified
or problem_code ILIKE 'B08.61%' -- Bovine stomatitis
or problem_code ILIKE 'B08.62%' -- Sealpox
or problem_code ILIKE 'B08.69%' -- Other parapoxvirus infections
-- Yatapoxvirus infections
or problem_code ILIKE 'B08.70%' -- Yatapoxvirus infection, unspecified
or problem_code ILIKE 'B08.71%' -- Tanapox virus disease
or problem_code ILIKE 'B08.72%' -- Yaba pox virus disease
or problem_code ILIKE 'B08.79%' -- Other yatapoxvirus infections
-- Other specified viral infections characterized by skin and mucous membrane lesions
or problem_code ILIKE 'B08.8%'
-- Unspecified viral infection characterized by skin and mucous membrane lesions
or problem_code ILIKE 'B09%'
-- Other human herpesviruses 
or problem_code ILIKE 'B10.01%' --  Human herpesvirus 6 encephalitis
or problem_code ILIKE 'B10.09%' -- Other human herpesvirus encephalitis
-- Other human herpesvirus infection
or problem_code ILIKE 'B10.81%' -- Human herpesvirus 6 infection
or problem_code ILIKE 'B10.82%' -- Human herpesvirus 7 infection
or problem_code ILIKE 'B10.89%' -- Other human herpesvirus infection
-- Acute hepatitis A 
or problem_code ILIKE 'B15.%'
-- Acute hepatitis B
or problem_code ILIKE 'B16.%'
-- Acute delta-(super) infection of hepatitis B carrier
or problem_code ILIKE 'B17.0%' -- Acute delta-(super) infection of hepatitis B carrier
--Acute hepatitis C
or problem_code ILIKE 'B17.10%' -- without hepatic coma
or problem_code ILIKE 'B17.11%' -- with hepatic coma
-- Acute hepatitis E
or problem_code ILIKE 'B17.2%'
-- Other specified acute viral hepatitis
or problem_code ILIKE 'B17.8%'
-- Acute viral hepatitis, unspecified
or problem_code ILIKE 'B17.9%'
-- Chronic viral hepatitis
or problem_code ILIKE 'B18.%'
-- Unspecified viral hepatitis
or problem_code ILIKE 'B19.0%' -- Unspecified viral hepatitis with hepatic coma
-- Unspecified viral hepatitis B
or problem_code ILIKE 'B19.10%' -- without hepatic coma
or problem_code ILIKE 'B19.11%' -- with hepatic coma
-- Unspecified viral hepatitis C
or problem_code ILIKE 'B19.20%' -- without hepatic coma
or problem_code ILIKE 'B19.21%' -- with hepatic coma
-- Unspecified viral hepatitis without hepatic coma
or problem_code ILIKE 'B19.9%'
-- Human immunodeficiency virus [HIV] disease
or problem_code ILIKE 'B20%'
-- Cytomegaloviral disease
or problem_code ILIKE 'B25.%'
-- Mumps 
or problem_code ILIKE 'B26.0%' -- Mumps orchitis
or problem_code ILIKE 'B26.1%' -- Mumps meningitis
or problem_code ILIKE 'B26.2%' -- Mumps encephalitis
or problem_code ILIKE 'B26.3%' -- Mumps pancreatitis
-- Mumps with other complications
or problem_code ILIKE 'B26.81%' -- Mumps hepatitis
or problem_code ILIKE 'B26.82%' -- Mumps myocarditis
or problem_code ILIKE 'B26.83%' -- Mumps nephritis
or problem_code ILIKE 'B26.84%' -- Mumps polyneuropathy
or problem_code ILIKE 'B26.85%' -- Mumps arthritis
or problem_code ILIKE 'B26.89%' -- Other mumps complications
-- Mumps without complication
or problem_code ILIKE 'B26.9%'
-- Infectious mononucleosis
-- Gammaherpesviral mononucleosis
or problem_code ILIKE 'B27.00%' -- without complication
or problem_code ILIKE 'B27.01%' -- with polyneuropathy
or problem_code ILIKE 'B27.02%' -- with meningitis
or problem_code ILIKE 'B27.09%' -- with other complications
-- Cytomegaloviral mononucleosis
or problem_code ILIKE 'B27.10%' -- without complications
or problem_code ILIKE 'B27.11%' -- with polyneuropathy
or problem_code ILIKE 'B27.12%' -- with meningitis
or problem_code ILIKE 'B27.19%' -- with other complication
-- Other infectious mononucleosis
or problem_code ILIKE 'B27.80%' -- without complication
or problem_code ILIKE 'B27.81%' -- with polyneuropathy
or problem_code ILIKE 'B27.82%' -- with meningitis
or problem_code ILIKE 'B27.89%' -- with other complication
-- Infectious mononucleosis, unspecified
or problem_code ILIKE 'B27.90%' -- without complication
or problem_code ILIKE 'B27.91%' -- with polyneuropathy
or problem_code ILIKE 'B27.92%' -- with meningitis
or problem_code ILIKE 'B27.99%' -- with other complication
-- Viral conjunctivitis
or problem_code ILIKE 'B30.%'
-- Other viral diseases, not elsewhere classified
or problem_code ILIKE 'B33.0%' -- Epidemic myalgia
or problem_code ILIKE 'B33.1%' -- Ross River disease
-- Viral carditis
or problem_code ILIKE 'B33.20%' -- unspecified
or problem_code ILIKE 'B33.21%' -- Viral endocarditis
or problem_code ILIKE 'B33.22%' -- Viral myocarditis
or problem_code ILIKE 'B33.23%' -- Viral pericarditis
or problem_code ILIKE 'B33.24%' -- Viral cardiomyopathy
-- Retrovirus infections, not elsewhere classified
or problem_code ILIKE 'B33.3%' 
-- Hantavirus (cardio)-pulmonary syndrome [HPS] [HCPS]
or problem_code ILIKE 'B33.4%'
-- Other specified viral diseases
or problem_code ILIKE 'B33.8%'
-- Viral infection of unspecified site 
or problem_code ILIKE 'B34.%'
-- Dermatophytosis
or problem_code ILIKE 'B35.%'
-- Other superficial mycoses 
or problem_code ILIKE 'B36.%'
-- Candidiasis
or problem_code ILIKE 'B37.0%' -- Candidal stomatitis
or problem_code ILIKE 'B37.1%' -- Pulmonary candidiasis
or problem_code ILIKE 'B37.2%' -- Candidiasis of skin and nail
or problem_code ILIKE 'B37.3%' -- Candidiasis of vulva and vagina
-- Candidiasis of other urogenital sites
or problem_code ILIKE 'B37.41%' -- Candidal cystitis and urethritis
or problem_code ILIKE 'B37.42%' --  Candidal balanitis
or problem_code ILIKE 'B37.49%' -- Other urogenital candidiasis
-- Candidal meningitis
or problem_code ILIKE 'B37.5%'
-- Candidal endocarditis
or problem_code ILIKE 'B37.6%'
-- Candidal sepsis
or problem_code ILIKE 'B37.7%'
-- Candidiasis of other sites
or problem_code ILIKE 'B37.81%' -- Candidal esophagitis
or problem_code ILIKE 'B37.82%' -- Candidal enteritis
or problem_code ILIKE 'B37.83%' -- Candidal cheilitis
or problem_code ILIKE 'B37.84%' -- Candidal otitis externa
or problem_code ILIKE 'B37.89%' -- Other sites of candidiasis
-- Candidiasis, unspecified
or problem_code ILIKE 'B37.9%'
-- Coccidioidomycosis
or problem_code ILIKE 'B38.0%' -- Acute pulmonary coccidioidomycosis
or problem_code ILIKE 'B38.1%' -- Chronic pulmonary coccidioidomycosis
or problem_code ILIKE 'B38.2%' -- Pulmonary coccidioidomycosis, unspecified
or problem_code ILIKE 'B38.3%' -- Cutaneous coccidioidomycosis
or problem_code ILIKE 'B38.4%' -- Coccidioidomycosis meningitis
or problem_code ILIKE 'B38.7%' -- Disseminated coccidioidomycosis
-- Other forms of coccidioidomycosis
or problem_code ILIKE 'B38.81%' -- Prostatic coccidioidomycosis
or problem_code ILIKE 'B38.89%' -- Other forms of coccidioidomycosis
-- Coccidioidomycosis, unspecified
or problem_code ILIKE 'B38.9%'
-- Histoplasmosis
or problem_code ILIKE 'B39.%'
-- Blastomycosis 
or problem_code ILIKE 'B40.0%' -- Acute pulmonary blastomycosis
or problem_code ILIKE 'B40.1%' -- Chronic pulmonary blastomycosis
or problem_code ILIKE 'B40.2%' -- Pulmonary blastomycosis, unspecified
or problem_code ILIKE 'B40.3%' -- Cutaneous blastomycosis
or problem_code ILIKE 'B40.7%' -- Disseminated blastomycosis
--  Other forms of blastomycosis
or problem_code ILIKE 'B40.81%' -- Blastomycotic meningoencephalitis
or problem_code ILIKE 'B40.89%' -- Other forms of blastomycosis
-- Blastomycosis, unspecified
or problem_code ILIKE 'B40.9%'
-- Paracoccidioidomycosis 
or problem_code ILIKE 'B41.%'
-- Sporotrichosis
or problem_code ILIKE 'B42.0%' -- Pulmonary sporotrichosis
or problem_code ILIKE 'B42.1%' -- Lymphocutaneous sporotrichosis
or problem_code ILIKE 'B42.7%' -- Disseminated sporotrichosis
-- Other forms of sporotrichosis
or problem_code ILIKE 'B42.81%' -- Cerebral sporotrichosis
or problem_code ILIKE 'B42.82%' -- Sporotrichosis arthritis
or problem_code ILIKE 'B42.89%' -- Other forms of sporotrichosis
-- Sporotrichosis, unspecified
or problem_code ILIKE 'B42.9%'
-- Chromomycosis and pheomycotic abscess
or problem_code ILIKE 'B43.%'
-- Aspergillosis
or problem_code ILIKE 'B44.0%' -- Invasive pulmonary aspergillosis
or problem_code ILIKE 'B44.1%' -- Other pulmonary aspergillosis
or problem_code ILIKE 'B44.2%' -- Tonsillar aspergillosis
or problem_code ILIKE 'B44.7%' -- Disseminated aspergillosis
-- Other forms of aspergillosis
or problem_code ILIKE 'B44.81%' -- Allergic bronchopulmonary aspergillosis
or problem_code ILIKE 'B44.89%' -- Other forms of aspergillosis
-- Aspergillosis, unspecified
or problem_code ILIKE 'B44.9%'
-- Cryptococcosis 
or problem_code ILIKE 'B45.%'
-- Zygomycosis
or problem_code ILIKE 'B46.%'
-- Mycetoma
or problem_code ILIKE 'B47.%'
-- Other mycoses, not elsewhere classified
or problem_code ILIKE 'B48.%'
-- Unspecified mycosis
or problem_code ILIKE 'B49%'
-- Plasmodium falciparum malaria
or problem_code ILIKE 'B50.%'
-- Plasmodium vivax malaria
or problem_code ILIKE 'B51.%'
-- Plasmodium malariae malaria
or problem_code ILIKE 'B52.%'
-- Other specified malaria
or problem_code ILIKE 'B53.%'
-- Unspecified malaria
or problem_code ILIKE 'B54%'
-- Leishmaniasis
or problem_code ILIKE 'B55.%'
-- African trypanosomiasis
or problem_code ILIKE 'B56.%'
-- Chagas' disease 
or problem_code ILIKE 'B57.0%' -- Acute Chagas' disease with heart involvement
or problem_code ILIKE 'B57.1%' -- Acute Chagas' disease without heart involvement
or problem_code ILIKE 'B57.2%' -- Chagas' disease (chronic) with heart involvement
-- Chagas' disease (chronic) with digestive system involvement
or problem_code ILIKE 'B57.30%' -- Chagas' disease with digestive system involvement, unspecified 
or problem_code ILIKE 'B57.31%' -- Megaesophagus in Chagas' disease
or problem_code ILIKE 'B57.32%' -- Megacolon in Chagas' disease
or problem_code ILIKE 'B57.39%' -- Other digestive system involvement in Chagas' disease
-- Chagas' disease (chronic) with nervous system involvement
or problem_code ILIKE 'B57.40%' -- Chagas' disease with nervous system involvement, unspecified
or problem_code ILIKE 'B57.41%' -- Meningitis in Chagas' disease
or problem_code ILIKE 'B57.42%' -- Meningoencephalitis in Chagas' disease
or problem_code ILIKE 'B57.49%' -- Other nervous system involvement in Chagas' disease
-- Chagas' disease (chronic) with other organ involvement
or problem_code ILIKE 'B57.5%'
-- Toxoplasmosis
-- Toxoplasma oculopathy
or problem_code ILIKE 'B58.00%' -- unspecified
or problem_code ILIKE 'B58.01%' -- Toxoplasma chorioretinitis
or problem_code ILIKE 'B58.09%' -- Other toxoplasma oculopathy
-- Toxoplasma hepatitis
or problem_code ILIKE 'B58.1%'
--  Toxoplasma meningoencephalitis
or problem_code ILIKE 'B58.2%'
-- Pulmonary toxoplasmosis
or problem_code ILIKE 'B58.3%'
-- Toxoplasmosis with other organ involvement
or problem_code ILIKE 'B58.81%' -- Toxoplasma myocarditis
or problem_code ILIKE 'B58.82%' -- Toxoplasma myositis
or problem_code ILIKE 'B58.83%' -- Toxoplasma tubulo-interstitial nephropathy
or problem_code ILIKE 'B58.89%' -- Toxoplasmosis with other organ involvement
-- Toxoplasmosis, unspecified
or problem_code ILIKE 'B58.9%'
-- Pneumocystosis
or problem_code ILIKE 'B59%'
-- Other protozoal diseases, not elsewhere classified
--  Babesiosis
or problem_code ILIKE 'B60.00%' -- unspecified
or problem_code ILIKE 'B60.01%' -- due to Babesia microti
or problem_code ILIKE 'B60.02%' -- due to Babesia duncani
or problem_code ILIKE 'B60.03%' -- due to Babesia divergens
or problem_code ILIKE 'B60.09%' -- Other babesiosis
-- Acanthamebiasis
or problem_code ILIKE 'B60.10%' -- unspecified
or problem_code ILIKE 'B60.11%' -- Meningoencephalitis due to Acanthamoeba (culbertsoni)
or problem_code ILIKE 'B60.12%' -- Conjunctivitis due to Acanthamoeba
or problem_code ILIKE 'B60.13%' -- Keratoconjunctivitis due to Acanthamoeba
or problem_code ILIKE 'B60.19%' -- Other acanthamebic disease
-- Naegleriasis
or problem_code ILIKE 'B60.2%'
-- Other specified protozoal diseases
or problem_code ILIKE 'B60.8%'
-- Unspecified protozoal disease
or problem_code ILIKE 'B64%'
-- Schistosomiasis [bilharziasis]
or problem_code ILIKE 'B65.%'
-- Other fluke infections
or problem_code ILIKE 'B66.%'
-- Echinococcosis
or problem_code ILIKE 'B67.0%' -- Echinococcus granulosus infection of liver
or problem_code ILIKE 'B67.1%' -- Echinococcus granulosus infection of lung
or problem_code ILIKE 'B67.2%' -- Echinococcus granulosus infection of bone
-- Echinococcus granulosus infection, other and multiple sites
or problem_code ILIKE 'B67.31%' -- Echinococcus granulosus infection, thyroid gland
or problem_code ILIKE 'B67.32%' -- Echinococcus granulosus infection, multiple sites
or problem_code ILIKE 'B67.39%' -- Echinococcus granulosus infection, other sites
-- Echinococcus granulosus infection, unspecified
or problem_code ILIKE 'B67.4%' 
-- Echinococcus multilocularis infection of liver
or problem_code ILIKE 'B67.5%'
-- Echinococcus multilocularis infection, other and multiple sites
or problem_code ILIKE 'B67.61%' -- Echinococcus multilocularis infection, multiple sites
or problem_code ILIKE 'B67.69%' -- Echinococcus multilocularis infection, other sites
-- Echinococcus multilocularis infection, unspecified
or problem_code ILIKE 'B67.7%'
-- Echinococcosis, unspecified, of liver
or problem_code ILIKE 'B67.8%'
-- Echinococcosis, other and unspecified
or problem_code ILIKE 'B67.90%' -- Echinococcosis, unspecified
or problem_code ILIKE 'B67.99%' -- Other echinococcosis
-- Taeniasis
or problem_code ILIKE 'B68.%'
-- Cysticercosis
or problem_code ILIKE 'B69.0%' -- Cysticercosis of central nervous system
or problem_code ILIKE 'B69.1%' -- Cysticercosis of eye
--  Cysticercosis of other sites
or problem_code ILIKE 'B69.81%' -- Myositis in cysticercosis
or problem_code ILIKE 'B69.89%' -- Cysticercosis of other sites
-- Cysticercosis, unspecified
or problem_code ILIKE 'B69.9%'
-- Diphyllobothriasis and sparganosis
or problem_code ILIKE 'B70.%'
-- Other cestode infections
or problem_code ILIKE 'B71.%'
-- Dracunculiasis
or problem_code ILIKE 'B72%'
-- Onchocerciasis
-- Onchocerciasis with eye disease
or problem_code ILIKE 'B73.00%' -- Onchocerciasis with eye involvement, unspecified
or problem_code ILIKE 'B73.01%' -- Onchocerciasis with endophthalmitis
or problem_code ILIKE 'B73.02%' -- Onchocerciasis with glaucoma
or problem_code ILIKE 'B73.09%' -- Onchocerciasis with other eye involvement
-- Onchocerciasis without eye disease
or problem_code ILIKE 'B73.1%'
-- Filariasis 
or problem_code ILIKE 'B74.%'
-- Trichinellosis
or problem_code ILIKE 'B75%'
-- Hookworm diseases
or problem_code ILIKE 'B76.%'
-- Ascariasis
or problem_code ILIKE 'B77.0%' -- Ascariasis with intestinal complications
-- Ascariasis with other complications
or problem_code ILIKE 'B77.81%' -- Ascariasis pneumonia
or problem_code ILIKE 'B77.89%' -- Ascariasis with other complications
-- Ascariasis, unspecified
or problem_code ILIKE 'B77.9%'
-- Strongyloidiasis
or problem_code ILIKE 'B78.%'
-- Trichuriasis
or problem_code ILIKE 'B79%'
-- Enterobiasis
or problem_code ILIKE 'B80%'
-- Other intestinal helminthiases, not elsewhere classified 
or problem_code ILIKE 'B81.%'
-- Unspecified intestinal parasitism
or problem_code ILIKE 'B82.%'
-- Other helminthiases 
or problem_code ILIKE 'B83.%'
-- Pediculosis and phthiriasis
or problem_code ILIKE 'B85.%'
-- Scabies
or problem_code ILIKE 'B86%'
-- Myiasis
or problem_code ILIKE 'B87.0%' -- Cutaneous myiasis
or problem_code ILIKE 'B87.1%' -- Wound myiasis
or problem_code ILIKE 'B87.2%' -- Ocular myiasis
or problem_code ILIKE 'B87.3%' -- Nasopharyngeal myiasis
or problem_code ILIKE 'B87.4%' -- Aural myiasis
-- Myiasis of other sites
or problem_code ILIKE 'B87.81%' -- Genitourinary myiasis
or problem_code ILIKE 'B87.82%' -- Intestinal myiasis
or problem_code ILIKE 'B87.89%' -- Myiasis of other sites
-- Myiasis, unspecified
or problem_code ILIKE 'B87.9%'
-- Other infestations
or problem_code ILIKE 'B88.%'
-- Unspecified parasitic disease
or problem_code ILIKE 'B89%'
-- Streptococcus, Staphylococcus, and Enterococcus as the cause of diseases classified elsewhere 
or problem_code ILIKE 'B95.0%' -- Streptococcus, group A, as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.1%' -- Streptococcus, group B, as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.2%' -- Enterococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.3%' -- Streptococcus pneumoniae as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.4%' -- Other streptococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.5%' -- Unspecified streptococcus as the cause of diseases classified elsewhere
-- Staphylococcus aureus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.61%' -- Methicillin susceptible Staphylococcus aureus infection as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.62%' -- Methicillin resistant Staphylococcus aureus infection as the cause of diseases classified elsewhere
-- Other staphylococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.7%' 
-- staphylococcus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B95.8%' 
-- Other bacterial agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.0%' -- Mycoplasma pneumoniae [M. pneumoniae] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.1%' -- Klebsiella pneumoniae [K. pneumoniae] as the cause of diseases classified elsewhere
--  Escherichia coli [E. coli ] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.20%' -- Unspecified Escherichia coli [E. coli] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.21%' -- Shiga toxin-producing Escherichia coli [E. coli] [STEC] O157 as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.22%' -- Other specified Shiga toxin-producing Escherichia coli [E. coli] [STEC] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.23%' -- Unspecified Shiga toxin-producing Escherichia coli [E. coli] [STEC] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.29%' -- Other Escherichia coli [E. coli] as the cause of diseases classified elsewhere
-- Hemophilus influenzae [H. influenzae] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.3%' 
-- Proteus (mirabilis) (morganii) as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.4%' 
-- Pseudomonas (aeruginosa) (mallei) (pseudomallei) as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.5%' 
-- Bacteroides fragilis [B. fragilis] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.6%' 
-- Clostridium perfringens [C. perfringens] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.7%' 
-- Other specified bacterial agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.81%'  -- Helicobacter pylori [H. pylori] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.82%'  -- Vibrio vulnificus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B96.89%'  -- Other specified bacterial agents as the cause of diseases classified elsewhere
-- Viral agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.0%' -- Adenovirus as the cause of diseases classified elsewhere
--  Enterovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.10%' -- Unspecified enterovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.11%' -- Coxsackievirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.12%' -- Echovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.19%' -- Other enterovirus as the cause of diseases classified elsewhere
-- Coronavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.21%' -- SARS-associated coronavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.29%' -- Other coronavirus as the cause of diseases classified elsewhere
-- Retrovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.30%' -- Unspecified retrovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.31%' -- Lentivirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.32%' -- Oncovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.33%' -- Human T-cell lymphotrophic virus, type I [HTLV-I] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.34%' -- Human T-cell lymphotrophic virus, type II [HTLV-II] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.35%' -- Human immunodeficiency virus, type 2 [HIV 2] as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.39%' -- Other retrovirus as the cause of diseases classified elsewhere
--  Respiratory syncytial virus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.4%'
-- Reovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.5%'
-- Parvovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.6%'
-- Papillomavirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.7%'
-- Other viral agents as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.81%' -- Human metapneumovirus as the cause of diseases classified elsewhere
or problem_code ILIKE 'B97.89%' -- Other viral agents as the cause of diseases classified elsewhere
-- Other and unspecified infectious diseases
or problem_code ILIKE 'B99.%'
-- Resistance to antimicrobial drugs
-- Resistance to beta lactam antibiotics
or problem_code ILIKE 'Z16.10%' -- Resistance to unspecified beta lactam antibiotics
or problem_code ILIKE 'Z16.11%' -- Resistance to penicillins
or problem_code ILIKE 'Z16.12%' -- Extended spectrum beta lactamase (ESBL) resistance
or problem_code ILIKE 'Z16.19%' -- Resistance to other specified beta lactam antibiotics
-- Resistance to other antibiotics
or problem_code ILIKE 'Z16.20%' -- Resistance to unspecified antibiotic
or problem_code ILIKE 'Z16.21%' -- Resistance to vancomycin
or problem_code ILIKE 'Z16.22%' -- Resistance to vancomycin related antibiotics
or problem_code ILIKE 'Z16.23%' -- Resistance to quinolones and fluoroquinolones 
or problem_code ILIKE 'Z16.24%' -- Resistance to multiple antibiotics
or problem_code ILIKE 'Z16.29%' -- Resistance to other single specified antibiotic
-- Resistance to other antimicrobial drugs
or problem_code ILIKE 'Z16.30%' -- Resistance to unspecified antimicrobial drugs
or problem_code ILIKE 'Z16.31%' -- Resistance to antiparasitic drug(s)
or problem_code ILIKE 'Z16.32%' -- Resistance to antifungal drug(s)
or problem_code ILIKE 'Z16.33%' -- Resistance to antiviral drug(s)
or problem_code ILIKE 'Z16.33%' -- Resistance to antiviral drug(s)
-- Resistance to antimycobacterial drug(s)
or problem_code ILIKE 'Z16.341%' -- Resistance to single antimycobacterial drug
or problem_code ILIKE 'Z16.342%' -- Resistance to multiple antimycobacterial drugs
-- Resistance to multiple antimicrobial drugs
or problem_code ILIKE 'Z16.35%'
-- Resistance to other specified antimicrobial drug
or problem_code ILIKE 'Z16.39%'
-- Glaucoma
-- Borderline glaucoma (glaucoma suspect)
or problem_code ILIKE '365.00%' -- Preglaucoma, unspecified
or problem_code ILIKE '365.01%' -- Open angle with borderline findings, low risk
or problem_code ILIKE '365.02%' -- Anatomical narrow angle borderline glaucoma
or problem_code ILIKE '365.03%' -- Steroid responders borderline glaucoma
or problem_code ILIKE '365.04%' -- Ocular hypertension
or problem_code ILIKE '365.05%' -- Open angle with borderline findings, high risk
or problem_code ILIKE '365.06%' -- Primary angle closure without glaucoma damage
-- Open-angle glaucoma
or problem_code ILIKE '365.10%' -- Open-angle glaucoma, unspecified
or problem_code ILIKE '365.11%' -- Primary open angle glaucoma
or problem_code ILIKE '365.12%' -- Low tension open-angle glaucoma
or problem_code ILIKE '365.13%' -- Pigmentary open-angle glaucoma 
or problem_code ILIKE '365.14%' -- Glaucoma of childhood
or problem_code ILIKE '365.15%' -- Residual stage of open angle glaucoma
-- Primary angle-closure glaucoma
or problem_code ILIKE '365.20%' -- Primary angle-closure glaucoma, unspecified
or problem_code ILIKE '365.21%' -- Intermittent angle-closure glaucoma
or problem_code ILIKE '365.22%' -- Acute angle-closure glaucoma
or problem_code ILIKE '365.23%' -- Chronic angle-closure glaucoma
or problem_code ILIKE '365.24%' -- Residual stage of angle-closure glaucoma
-- Corticosteroid-induced glaucoma
or problem_code ILIKE '365.31%' -- Corticosteroid-induced glaucoma, glaucomatous stage
or problem_code ILIKE '365.32%' -- Corticosteroid-induced glaucoma, residual stage
--  Glaucoma associated with congenital anomalies dystrophies and systemic syndromes
or problem_code ILIKE '365.41%' -- Glaucoma associated with chamber angle anomalies
or problem_code ILIKE '365.42%' -- Glaucoma associated with anomalies of iris
or problem_code ILIKE '365.43%' -- Glaucoma associated with other anterior segment anomalies
or problem_code ILIKE '365.44%' -- Glaucoma associated with systemic syndromes
-- Glaucoma associated with disorders of the lens
or problem_code ILIKE '365.51%' -- Phacolytic glaucoma
or problem_code ILIKE '365.52%' -- Pseudoexfoliation glaucoma
or problem_code ILIKE '365.59%' -- Glaucoma associated with other lens disorders
-- Glaucoma associated with other ocular disorders
or problem_code ILIKE '365.60%' -- Glaucoma associated with unspecified ocular disorder
or problem_code ILIKE '365.61%' -- Glaucoma associated with pupillary block
or problem_code ILIKE '365.62%' -- Glaucoma associated with ocular inflammations
or problem_code ILIKE '365.63%' -- Glaucoma associated with vascular disorders
or problem_code ILIKE '365.64%' -- Glaucoma associated with tumors or cysts
or problem_code ILIKE '365.65%' -- Glaucoma associated with ocular trauma
-- Glaucoma stage
or problem_code ILIKE '365.70%' -- Glaucoma stage, unspecified
or problem_code ILIKE '365.71%' -- Mild stage glaucoma
or problem_code ILIKE '365.72%' -- Moderate stage glaucoma
or problem_code ILIKE '365.73%' -- Severe stage glaucoma
or problem_code ILIKE '365.74%' -- Indeterminate stage glaucoma
-- Other specified forms of glaucoma
or problem_code ILIKE '365.81%' -- Hypersecretion glaucoma
or problem_code ILIKE '365.82%' -- Glaucoma with increased episcleral venous pressure
or problem_code ILIKE '365.83%' -- Aqueous misdirection
or problem_code ILIKE '365.89%' -- Other specified glaucoma
-- Unspecified glaucoma
or problem_code ILIKE '365.9%'
-- Degeneration of macula and posterior pole of retina
or problem_code ILIKE '362.50%' -- Macular degeneration (senile), unspecified
or problem_code ILIKE '362.51%' -- Nonexudative senile macular degeneration
or problem_code ILIKE '362.52%' -- Exudative senile macular degeneration 
or problem_code ILIKE '362.53%' -- Cystoid macular degeneration 
or problem_code ILIKE '362.54%' -- Macular cyst, hole, or pseudohole
or problem_code ILIKE '362.55%' -- Toxic maculopathy
or problem_code ILIKE '362.56%' -- Macular puckering
or problem_code ILIKE '362.57%' -- Drusen (degenerative)
-- Diabetic retinopathy
or problem_code ILIKE '362.01%' -- Background diabetic retinopathy
or problem_code ILIKE '362.02%' -- Proliferative diabetic retinopathy
or problem_code ILIKE '362.03%' -- Nonproliferative diabetic retinopathy NOS
or problem_code ILIKE '362.04%' -- Mild nonproliferative diabetic retinopathy
or problem_code ILIKE '362.05%' -- Moderate nonproliferative diabetic retinopathy
or problem_code ILIKE '362.06%' -- Severe nonproliferative diabetic retinopathy
or problem_code ILIKE '362.07%' -- Diabetic macular edema
-- Senile cataract
or problem_code ILIKE '366.10%' -- Senile cataract, unspecified
or problem_code ILIKE '366.11%' -- Pseudoexfoliation of lens capsule
or problem_code ILIKE '366.12%' -- Incipient senile cataract
or problem_code ILIKE '366.13%' -- Anterior subcapsular polar senile cataract
or problem_code ILIKE '366.14%' -- Posterior subcapsular polar senile cataract
or problem_code ILIKE '366.15%' -- Cortical senile cataract
or problem_code ILIKE '366.16%' -- Senile nuclear sclerosis
or problem_code ILIKE '366.17%' -- Total or mature cataract
or problem_code ILIKE '366.18%' -- Hypermature cataract 
or problem_code ILIKE '366.19%' -- Other and combined forms of senile cataract
-- Tear film insufficiency, unspecified
or problem_code ILIKE '375.15%'
-- Dry eye syndrome
or problem_code ILIKE 'H04.121%' -- of right lacrimal gland
or problem_code ILIKE 'H04.122%' -- of left lacrimal gland
or problem_code ILIKE 'H04.123%' -- of bilateral lacrimal glands
or problem_code ILIKE 'H04.129%' -- of unspecified lacrimal gland
-- Allergic rhinitis, cause unspecified
or problem_code ILIKE '477.9%'
-- Vasomotor and allergic rhinitis
or problem_code ILIKE 'J30.0%' -- Vasomotor rhinitis
or problem_code ILIKE 'J30.1%' -- Allergic rhinitis due to pollen
or problem_code ILIKE 'J30.2%' -- Other seasonal allergic rhinitis
or problem_code ILIKE 'J30.5%' -- Allergic rhinitis due to food
--  Other allergic rhinitis
or problem_code ILIKE 'J30.81%' -- Allergic rhinitis due to animal (cat) (dog) hair and dander
or problem_code ILIKE 'J30.89%' -- Other allergic rhinitis
-- Allergic rhinitis, unspecified
or problem_code ILIKE 'J30.9%' 
-- Blepharitis
or problem_code ILIKE '373.00%' -- Blepharitis, unspecified
or problem_code ILIKE '373.01%' -- Ulcerative blepharitis
or problem_code ILIKE '373.02%' -- Squamous blepharitis
-- Blepharitis
-- Unspecified blepharitis
or problem_code ILIKE 'H01.001%' -- right upper eyelid
or problem_code ILIKE 'H01.002%' -- right lower eyelid
or problem_code ILIKE 'H01.003%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.004%' -- left upper eyelid
or problem_code ILIKE 'H01.005%' -- left lower eyelid
or problem_code ILIKE 'H01.006%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.009%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.00A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.00B%' -- left eye, upper and lower eyelids
-- Ulcerative blepharitis
or problem_code ILIKE 'H01.011%' -- right upper eyelid
or problem_code ILIKE 'H01.012%' -- right lower eyelid
or problem_code ILIKE 'H01.013%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.014%' -- left upper eyelid
or problem_code ILIKE 'H01.015%' -- left lower eyelid
or problem_code ILIKE 'H01.016%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.019%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.01A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.01B%' -- left eye, upper and lower eyelids
-- Squamous blepharitis
or problem_code ILIKE 'H01.021%' -- right upper eyelid
or problem_code ILIKE 'H01.022%' -- right lower eyelid
or problem_code ILIKE 'H01.023%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H01.024%' -- left upper eyelid
or problem_code ILIKE 'H01.025%' -- left lower eyelid
or problem_code ILIKE 'H01.026%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H01.029%' -- unspecified eye, unspecified eyelid*/
or problem_code ILIKE 'H01.02A%' -- right eye, upper and lower eyelids
or problem_code ILIKE 'H01.02B%' -- left eye, upper and lower eyelids
-- Chalazion
or problem_code ILIKE '373.2%'
-- Hordeolum and other deep inflammation of eyelid
or problem_code ILIKE '373.11%' -- Hordeolum externum
or problem_code ILIKE '373.12%' -- Hordeolum internum
or problem_code ILIKE '373.13%' -- Abscess of eyelid
-- Hordeolum and chalazion
-- Hordeolum (externum) (internum) of eyelid
-- Hordeolum externum
or problem_code ILIKE 'H00.011%' -- right upper eyelid
or problem_code ILIKE 'H00.012%' -- right lower eyelid
or problem_code ILIKE 'H00.013%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.014%' -- left upper eyelid
or problem_code ILIKE 'H00.015%' -- left lower eyelid
or problem_code ILIKE 'H00.016%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.019%' -- unspecified eye, unspecified eyelid*/
-- Hordeolum internum
or problem_code ILIKE 'H00.021%' -- right upper eyelid
or problem_code ILIKE 'H00.022%' -- right lower eyelid
or problem_code ILIKE 'H00.023%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.024%' -- left upper eyelid
or problem_code ILIKE 'H00.025%' -- left lower eyelid
or problem_code ILIKE 'H00.026%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.029%' -- unspecified eye, unspecified eyelid*/
--Abscess of eyelid
or problem_code ILIKE 'H00.031%' -- right upper eyelid
or problem_code ILIKE 'H00.032%' -- right lower eyelid
or problem_code ILIKE 'H00.033%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.034%' -- left upper eyelid
or problem_code ILIKE 'H00.035%' -- left lower eyelid
or problem_code ILIKE 'H00.036%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.039%' -- unspecified eye, unspecified eyelid*/
-- Chalazion
or problem_code ILIKE 'H00.11%' -- right upper eyelid
or problem_code ILIKE 'H00.12%' -- right lower eyelid
or problem_code ILIKE 'H00.13%' -- right eye, unspecified eyelid
or problem_code ILIKE 'H00.14%' -- left upper eyelid
or problem_code ILIKE 'H00.15%' -- left lower eyelid
or problem_code ILIKE 'H00.16%' -- left eye, unspecified eyelid
/*or problem_code ILIKE 'H00.19%' -- unspecified eye, unspecified eyelid*/
-- Glaucoma
-- Preglaucoma, unspecified
or problem_code ILIKE 'H40.001%' -- right eye
or problem_code ILIKE 'H40.002%' -- left eye
or problem_code ILIKE 'H40.003%' -- bilateral
/*or problem_code ILIKE 'H40.009%' -- unspecified eye*/
-- Open angle with borderline findings, low risk
or problem_code ILIKE 'H40.011%' -- right eye
or problem_code ILIKE 'H40.012%' -- left eye
or problem_code ILIKE 'H40.013%' -- bilateral
/*or problem_code ILIKE 'H40.019%' -- unspecified eye*/
-- Open angle with borderline findings, high risk 
or problem_code ILIKE 'H40.021%' -- right eye
or problem_code ILIKE 'H40.022%' -- left eye
or problem_code ILIKE 'H40.023%' -- bilateral
/*or problem_code ILIKE 'H40.029%' -- unspecified eye*/
-- Anatomical narrow angle
or problem_code ILIKE 'H40.031%' -- right eye
or problem_code ILIKE 'H40.032%' -- left eye
or problem_code ILIKE 'H40.033%' -- bilateral
/*or problem_code ILIKE 'H40.039%' -- unspecified eye*/
--  Steroid responder
or problem_code ILIKE 'H40.041%' -- right eye
or problem_code ILIKE 'H40.042%' -- left eye
or problem_code ILIKE 'H40.043%' -- bilateral
/*or problem_code ILIKE 'H40.049%' -- unspecified eye*/
-- Ocular hypertension
or problem_code ILIKE 'H40.051%' -- right eye
or problem_code ILIKE 'H40.052%' -- left eye
or problem_code ILIKE 'H40.053%' -- bilateral
/*or problem_code ILIKE 'H40.059%' -- unspecified eye*/
--  Primary angle closure without glaucoma damage
or problem_code ILIKE 'H40.061%' -- right eye
or problem_code ILIKE 'H40.062%' -- left eye
or problem_code ILIKE 'H40.063%' -- bilateral
/*or problem_code ILIKE 'H40.069%' -- unspecified eye*/
-- Open-angle glaucoma
-- Unspecified open-angle glaucoma
or problem_code ILIKE 'H40.10X0%' -- stage unspecified
or problem_code ILIKE 'H40.10X1%' -- mild stage
or problem_code ILIKE 'H40.10X2%' -- moderate stage 
or problem_code ILIKE 'H40.10X3%' -- severe stage
or problem_code ILIKE 'H40.10X4%' -- indeterminate stage
-- Primary open-angle glaucoma
-- Primary open-angle glaucoma, right eye
or problem_code ILIKE 'H40.1110%' -- stage unspecified
or problem_code ILIKE 'H40.1111%' -- mild stage
or problem_code ILIKE 'H40.1112%' -- moderate stage 
or problem_code ILIKE 'H40.1113%' -- severe stage
or problem_code ILIKE 'H40.1114%' -- indeterminate stage
-- Primary open-angle glaucoma, left eye
or problem_code ILIKE 'H40.1120%' -- stage unspecified
or problem_code ILIKE 'H40.1121%' -- mild stage
or problem_code ILIKE 'H40.1122%' -- moderate stage 
or problem_code ILIKE 'H40.1123%' -- severe stage
or problem_code ILIKE 'H40.1124%' -- indeterminate stage
-- Primary open-angle glaucoma, bilateral
or problem_code ILIKE 'H40.1130%' -- stage unspecified
or problem_code ILIKE 'H40.1131%' -- mild stage
or problem_code ILIKE 'H40.1132%' -- moderate stage 
or problem_code ILIKE 'H40.1133%' -- severe stage
or problem_code ILIKE 'H40.1134%' -- indeterminate stage
/*-- Primary open-angle glaucoma, unspecified eye
or problem_code ILIKE 'H40.1190%' -- stage unspecified
or problem_code ILIKE 'H40.1191%' -- mild stage
or problem_code ILIKE 'H40.1192%' -- moderate stage 
or problem_code ILIKE 'H40.1193%' -- severe stage
or problem_code ILIKE 'H40.1194%' -- indeterminate stage*/
-- Low-tension glaucoma
-- Low-tension glaucoma, right eye
or problem_code ILIKE 'H40.1210%' -- stage unspecified
or problem_code ILIKE 'H40.1211%' -- mild stage
or problem_code ILIKE 'H40.1212%' -- moderate stage 
or problem_code ILIKE 'H40.1213%' -- severe stage
or problem_code ILIKE 'H40.1214%' -- indeterminate stage
-- Low-tension glaucoma, left eye
or problem_code ILIKE 'H40.1220%' -- stage unspecified
or problem_code ILIKE 'H40.1221%' -- mild stage
or problem_code ILIKE 'H40.1222%' -- moderate stage 
or problem_code ILIKE 'H40.1223%' -- severe stage
or problem_code ILIKE 'H40.1224%' -- indeterminate stage
-- Low-tension glaucoma, bilateral
or problem_code ILIKE 'H40.1230%' -- stage unspecified
or problem_code ILIKE 'H40.1231%' -- mild stage
or problem_code ILIKE 'H40.1232%' -- moderate stage 
or problem_code ILIKE 'H40.1233%' -- severe stage
or problem_code ILIKE 'H40.1234%' -- indeterminate stage
/*-- Low-tension glaucoma, unspecified eye
or problem_code ILIKE 'H40.1290%' -- stage unspecified
or problem_code ILIKE 'H40.1291%' -- mild stage
or problem_code ILIKE 'H40.1292%' -- moderate stage 
or problem_code ILIKE 'H40.1293%' -- severe stage
or problem_code ILIKE 'H40.1294%' -- indeterminate stage*/
-- Pigmentary glaucoma
-- Pigmentary glaucoma, right eye
or problem_code ILIKE 'H40.1310%' -- stage unspecified
or problem_code ILIKE 'H40.1311%' -- mild stage
or problem_code ILIKE 'H40.1312%' -- moderate stage 
or problem_code ILIKE 'H40.1313%' -- severe stage
or problem_code ILIKE 'H40.1314%' -- indeterminate stage
-- Pigmentary glaucoma, left eye
or problem_code ILIKE 'H40.1320%' -- stage unspecified
or problem_code ILIKE 'H40.1321%' -- mild stage
or problem_code ILIKE 'H40.1322%' -- moderate stage 
or problem_code ILIKE 'H40.1323%' -- severe stage
or problem_code ILIKE 'H40.1324%' -- indeterminate stage
-- Pigmentary glaucoma, bilateral
or problem_code ILIKE 'H40.1330%' -- stage unspecified
or problem_code ILIKE 'H40.1331%' -- mild stage
or problem_code ILIKE 'H40.1332%' -- moderate stage 
or problem_code ILIKE 'H40.1333%' -- severe stage
or problem_code ILIKE 'H40.1334%' -- indeterminate stage
/*-- Pigmentary glaucoma, unspecified eye
or problem_code ILIKE 'H40.1390%' -- stage unspecified
or problem_code ILIKE 'H40.1391%' -- mild stage
or problem_code ILIKE 'H40.1392%' -- moderate stage 
or problem_code ILIKE 'H40.1393%' -- severe stage
or problem_code ILIKE 'H40.1394%' -- indeterminate stage*/
-- Capsular glaucoma with pseudoexfoliation of lens
-- Capsular glaucoma with pseudoexfoliation of lens, right eye
or problem_code ILIKE 'H40.1410%' -- stage unspecified
or problem_code ILIKE 'H40.1411%' -- mild stage
or problem_code ILIKE 'H40.1412%' -- moderate stage 
or problem_code ILIKE 'H40.1413%' -- severe stage
or problem_code ILIKE 'H40.1414%' -- indeterminate stage
-- Capsular glaucoma with pseudoexfoliation of lens, left eye
or problem_code ILIKE 'H40.1420%' -- stage unspecified
or problem_code ILIKE 'H40.1421%' -- mild stage
or problem_code ILIKE 'H40.1422%' -- moderate stage 
or problem_code ILIKE 'H40.1423%' -- severe stage
or problem_code ILIKE 'H40.1424%' -- indeterminate stage
--  Capsular glaucoma with pseudoexfoliation of lens, bilateral
or problem_code ILIKE 'H40.1430%' -- stage unspecified
or problem_code ILIKE 'H40.1431%' -- mild stage
or problem_code ILIKE 'H40.1432%' -- moderate stage 
or problem_code ILIKE 'H40.1433%' -- severe stage
or problem_code ILIKE 'H40.1434%' -- indeterminate stage
/*-- Capsular glaucoma with pseudoexfoliation of lens, unspecified eye
or problem_code ILIKE 'H40.1490%' -- stage unspecified
or problem_code ILIKE 'H40.1491%' -- mild stage
or problem_code ILIKE 'H40.1492%' -- moderate stage 
or problem_code ILIKE 'H40.1493%' -- severe stage
or problem_code ILIKE 'H40.1494%' -- indeterminate stage*/
-- Residual stage of open-angle glaucoma
or problem_code ILIKE 'H40.151%' -- right eye
or problem_code ILIKE 'H40.152%' -- left eye
or problem_code ILIKE 'H40.153%' -- bilateral
/*or problem_code ILIKE 'H40.159%' -- unspecified eye */
-- Primary angle-closure glaucoma
-- Unspecified primary angle-closure glaucoma
or problem_code ILIKE 'H40.20X0%' -- stage unspecified
or problem_code ILIKE 'H40.20X1%' -- mild stage
or problem_code ILIKE 'H40.20X2%' -- moderate stage 
or problem_code ILIKE 'H40.20X3%' -- severe stage
or problem_code ILIKE 'H40.20X4%' -- indeterminate stage
-- Acute angle-closure glaucoma
or problem_code ILIKE 'H40.211%' -- right eye
or problem_code ILIKE 'H40.212%' -- left eye
or problem_code ILIKE 'H40.213%' -- bilateral
/*or problem_code ILIKE 'H40.219%' -- unspecified eye*/ 
-- Chronic angle-closure glaucoma
-- Chronic angle-closure glaucoma, right eye
or problem_code ILIKE 'H40.2210%' -- stage unspecified
or problem_code ILIKE 'H40.2211%' -- mild stage
or problem_code ILIKE 'H40.2212%' -- moderate stage 
or problem_code ILIKE 'H40.2213%' -- severe stage
or problem_code ILIKE 'H40.2214%' -- indeterminate stage
-- Chronic angle-closure glaucoma, left eye
or problem_code ILIKE 'H40.2220%' -- stage unspecified
or problem_code ILIKE 'H40.2221%' -- mild stage
or problem_code ILIKE 'H40.2222%' -- moderate stage 
or problem_code ILIKE 'H40.2223%' -- severe stage
or problem_code ILIKE 'H40.2224%' -- indeterminate stage
-- Chronic angle-closure glaucoma, bilateral
or problem_code ILIKE 'H40.2230%' -- stage unspecified
or problem_code ILIKE 'H40.2231%' -- mild stage
or problem_code ILIKE 'H40.2232%' -- moderate stage 
or problem_code ILIKE 'H40.2233%' -- severe stage
or problem_code ILIKE 'H40.2234%' -- indeterminate stage
/*-- Chronic angle-closure glaucoma, unspecified eye
or problem_code ILIKE 'H40.2290%' -- stage unspecified
or problem_code ILIKE 'H40.2291%' -- mild stage
or problem_code ILIKE 'H40.2292%' -- moderate stage 
or problem_code ILIKE 'H40.2293%' -- severe stage
or problem_code ILIKE 'H40.2294%' -- indeterminate stage*/
-- Intermittent angle-closure glaucoma
or problem_code ILIKE 'H40.231%' -- right eye
or problem_code ILIKE 'H40.232%' -- left eye
or problem_code ILIKE 'H40.233%' -- bilateral
/*or problem_code ILIKE 'H40.239%' -- unspecified eye */
--  Residual stage of angle-closure glaucoma
or problem_code ILIKE 'H40.241%' -- right eye
or problem_code ILIKE 'H40.242%' -- left eye
or problem_code ILIKE 'H40.243%' -- bilateral
/*or problem_code ILIKE 'H40.249%' -- unspecified eye */
-- Glaucoma secondary to eye trauma
/*--  Glaucoma secondary to eye trauma, unspecified eye
or problem_code ILIKE 'H40.30X0%' -- stage unspecified
or problem_code ILIKE 'H40.30X1%' -- mild stage
or problem_code ILIKE 'H40.30X2%' -- moderate stage 
or problem_code ILIKE 'H40.30X3%' -- severe stage
or problem_code ILIKE 'H40.30X4%' -- indeterminate stage*/
-- Glaucoma secondary to eye trauma, right eye
or problem_code ILIKE 'H40.31X0%' -- stage unspecified
or problem_code ILIKE 'H40.31X1%' -- mild stage
or problem_code ILIKE 'H40.31X2%' -- moderate stage 
or problem_code ILIKE 'H40.31X3%' -- severe stage
or problem_code ILIKE 'H40.31X4%' -- indeterminate stage
-- Glaucoma secondary to eye trauma, left eye
or problem_code ILIKE 'H40.32X0%' -- stage unspecified
or problem_code ILIKE 'H40.32X1%' -- mild stage
or problem_code ILIKE 'H40.32X2%' -- moderate stage 
or problem_code ILIKE 'H40.32X3%' -- severe stage
or problem_code ILIKE 'H40.32X4%' -- indeterminate stage
-- Glaucoma secondary to eye trauma, bilateral
or problem_code ILIKE 'H40.33X0%' -- stage unspecified
or problem_code ILIKE 'H40.33X1%' -- mild stage
or problem_code ILIKE 'H40.33X2%' -- moderate stage 
or problem_code ILIKE 'H40.33X3%' -- severe stage
or problem_code ILIKE 'H40.33X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation
/*-- Glaucoma secondary to eye inflammation, unspecified eye
or problem_code ILIKE 'H40.40X0%' -- stage unspecified
or problem_code ILIKE 'H40.40X1%' -- mild stage
or problem_code ILIKE 'H40.40X2%' -- moderate stage 
or problem_code ILIKE 'H40.40X3%' -- severe stage
or problem_code ILIKE 'H40.40X4%' -- indeterminate stage*/
-- Glaucoma secondary to eye inflammation, right eye
or problem_code ILIKE 'H40.41X0%' -- stage unspecified
or problem_code ILIKE 'H40.41X1%' -- mild stage
or problem_code ILIKE 'H40.41X2%' -- moderate stage 
or problem_code ILIKE 'H40.41X3%' -- severe stage
or problem_code ILIKE 'H40.41X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation, left eye
or problem_code ILIKE 'H40.42X0%' -- stage unspecified
or problem_code ILIKE 'H40.42X1%' -- mild stage
or problem_code ILIKE 'H40.42X2%' -- moderate stage 
or problem_code ILIKE 'H40.42X3%' -- severe stage
or problem_code ILIKE 'H40.42X4%' -- indeterminate stage
-- Glaucoma secondary to eye inflammation, bilateral
or problem_code ILIKE 'H40.43X0%' -- stage unspecified
or problem_code ILIKE 'H40.43X1%' -- mild stage
or problem_code ILIKE 'H40.43X2%' -- moderate stage 
or problem_code ILIKE 'H40.43X3%' -- severe stage
or problem_code ILIKE 'H40.43X4%' -- indeterminate stage
-- Glaucoma secondary to other eye disorders
/*-- Glaucoma secondary to other eye disorders, unspecified eye
or problem_code ILIKE 'H40.50X0%' -- stage unspecified
or problem_code ILIKE 'H40.50X1%' -- mild stage
or problem_code ILIKE 'H40.50X2%' -- moderate stage 
or problem_code ILIKE 'H40.50X3%' -- severe stage
or problem_code ILIKE 'H40.50X4%' -- indeterminate stage*/
-- Glaucoma secondary to other eye disorders, right eye
or problem_code ILIKE 'H40.51X0%' -- stage unspecified
or problem_code ILIKE 'H40.51X1%' -- mild stage
or problem_code ILIKE 'H40.51X2%' -- moderate stage 
or problem_code ILIKE 'H40.51X3%' -- severe stage
or problem_code ILIKE 'H40.51X4%' -- indeterminate stage
--  Glaucoma secondary to other eye disorders, left eye
or problem_code ILIKE 'H40.52X0%' -- stage unspecified
or problem_code ILIKE 'H40.52X1%' -- mild stage
or problem_code ILIKE 'H40.52X2%' -- moderate stage 
or problem_code ILIKE 'H40.52X3%' -- severe stage
or problem_code ILIKE 'H40.52X4%' -- indeterminate stage
-- Glaucoma secondary to other eye disorders, bilateral
or problem_code ILIKE 'H40.53X0%' -- stage unspecified
or problem_code ILIKE 'H40.53X1%' -- mild stage
or problem_code ILIKE 'H40.53X2%' -- moderate stage 
or problem_code ILIKE 'H40.53X3%' -- severe stage
or problem_code ILIKE 'H40.53X4%' -- indeterminate stage
-- Glaucoma secondary to drugs
/*-- Glaucoma secondary to drugs, unspecified eye
or problem_code ILIKE 'H40.60X0%' -- stage unspecified
or problem_code ILIKE 'H40.60X1%' -- mild stage
or problem_code ILIKE 'H40.60X2%' -- moderate stage 
or problem_code ILIKE 'H40.60X3%' -- severe stage
or problem_code ILIKE 'H40.60X4%' -- indeterminate stage*/
-- Glaucoma secondary to drugs, right eye
or problem_code ILIKE 'H40.61X0%' -- stage unspecified
or problem_code ILIKE 'H40.61X1%' -- mild stage
or problem_code ILIKE 'H40.61X2%' -- moderate stage 
or problem_code ILIKE 'H40.61X3%' -- severe stage
or problem_code ILIKE 'H40.61X4%' -- indeterminate stage
--  Glaucoma secondary to drugs, left eye
or problem_code ILIKE 'H40.62X0%' -- stage unspecified
or problem_code ILIKE 'H40.62X1%' -- mild stage
or problem_code ILIKE 'H40.62X2%' -- moderate stage 
or problem_code ILIKE 'H40.62X3%' -- severe stage
or problem_code ILIKE 'H40.62X4%' -- indeterminate stage
-- Glaucoma secondary to drugs, bilateral
or problem_code ILIKE 'H40.63X0%' -- stage unspecified
or problem_code ILIKE 'H40.63X1%' -- mild stage
or problem_code ILIKE 'H40.63X2%' -- moderate stage 
or problem_code ILIKE 'H40.63X3%' -- severe stage
or problem_code ILIKE 'H40.63X4%' -- indeterminate stage
-- Other glaucoma
--  Glaucoma with increased episcleral venous pressure
or problem_code ILIKE 'H40.811%' --  right eye
or problem_code ILIKE 'H40.812%' -- left eye
or problem_code ILIKE 'H40.813%' -- bilateral
/*or problem_code ILIKE 'H40.819%' -- unspecified eye */
--  Hypersecretion glaucoma
or problem_code ILIKE 'H40.821%' --  right eye
or problem_code ILIKE 'H40.822%' -- left eye
or problem_code ILIKE 'H40.823%' -- bilateral
/*or problem_code ILIKE 'H40.829%' -- unspecified eye */
-- Aqueous misdirection
or problem_code ILIKE 'H40.831%' --  right eye
or problem_code ILIKE 'H40.832%' -- left eye
or problem_code ILIKE 'H40.833%' -- bilateral
/*or problem_code ILIKE 'H40.839%' -- unspecified eye */
-- Other specified glaucoma
or problem_code ILIKE 'H40.89%'
--  Unspecified glaucoma
or problem_code ILIKE 'H40.9%'
-- Type 2 diabetes mellitus with unspecified diabetic retinopathy without macular edema
or problem_code ILIKE 'E11.319%'
-- Age-related cataract 
-- Age-related incipient cataract
-- Cortical age-related cataract
or problem_code ILIKE 'H25.011%' -- right eye
or problem_code ILIKE 'H25.012%' -- left eye
or problem_code ILIKE 'H25.013%' -- bilateral
/*or problem_code ILIKE 'H25.019%' -- unspecified eye*/
-- Anterior subcapsular polar age-related cataract
or problem_code ILIKE 'H25.031%' -- right eye
or problem_code ILIKE 'H25.032%' -- left eye
or problem_code ILIKE 'H25.033%' -- bilateral
/*or problem_code ILIKE 'H25.039%' -- unspecified eye*/
-- Posterior subcapsular polar age-related cataract
or problem_code ILIKE 'H25.041%' -- right eye
or problem_code ILIKE 'H25.042%' -- left eye
or problem_code ILIKE 'H25.043%' -- bilateral
/*or problem_code ILIKE 'H25.049%' -- unspecified eye*/
--Other age-related incipient cataract
or problem_code ILIKE 'H25.091%' -- right eye
or problem_code ILIKE 'H25.092%' -- left eye
or problem_code ILIKE 'H25.093%' -- bilateral
/*or problem_code ILIKE 'H25.099%' -- unspecified eye*/
--  Age-related nuclear cataract
or problem_code ILIKE 'H25.11%' -- right eye
or problem_code ILIKE 'H25.12%' -- left eye
or problem_code ILIKE 'H25.13%' -- bilateral
/*or problem_code ILIKE 'H25.10%' -- unspecified eye*/
-- Age-related cataract, morgagnian type
or problem_code ILIKE 'H25.21%' -- right eye
or problem_code ILIKE 'H25.22%' -- left eye
or problem_code ILIKE 'H25.23%' -- bilateral
/*or problem_code ILIKE 'H25.20%' -- unspecified eye*/
-- Other age-related cataract
-- Combined forms of age-related cataract
or problem_code ILIKE 'H25.811%' -- right eye
or problem_code ILIKE 'H25.812%' -- left eye
or problem_code ILIKE 'H25.813%' -- bilateral
/*or problem_code ILIKE 'H25.819%' -- unspecified eye*/
-- Other age-related cataract
or problem_code ILIKE 'H25.89%' 
-- Unspecified age-related cataract
or problem_code ILIKE 'H25.9%' 
-- Degeneration of macula and posterior pole
-- Unspecified macular degeneration
or problem_code ILIKE 'H35.30%' 
--  Nonexudative age-related macular degeneration, right eye
or problem_code ILIKE 'H35.3110%' --  stage unspecified
or problem_code ILIKE 'H35.3111%' -- early dry stage
or problem_code ILIKE 'H35.3112%' --  intermediate dry stage
or problem_code ILIKE 'H35.3113%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3114%' --  advanced atrophic with subfoveal involvement
-- Nonexudative age-related macular degeneration, left eye
or problem_code ILIKE 'H35.3120%' --  stage unspecified
or problem_code ILIKE 'H35.3121%' -- early dry stage
or problem_code ILIKE 'H35.3122%' --  intermediate dry stage
or problem_code ILIKE 'H35.3123%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3124%' --  advanced atrophic with subfoveal involvement
-- Nonexudative age-related macular degeneration, bilateral
or problem_code ILIKE 'H35.3130%' --  stage unspecified
or problem_code ILIKE 'H35.3131%' -- early dry stage
or problem_code ILIKE 'H35.3132%' --  intermediate dry stage
or problem_code ILIKE 'H35.3133%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3134%' --  advanced atrophic with subfoveal involvement
/*-- Nonexudative age-related macular degeneration, unspecified eye
or problem_code ILIKE 'H35.3190%' --  stage unspecified
or problem_code ILIKE 'H35.3191%' -- early dry stage
or problem_code ILIKE 'H35.3192%' --  intermediate dry stage
or problem_code ILIKE 'H35.3193%' -- advanced atrophic without subfoveal involvement
or problem_code ILIKE 'H35.3194%' --  advanced atrophic with subfoveal involvement*/
-- Exudative age-related macular degeneration
-- Exudative age-related macular degeneration, right eye
 or problem_code ILIKE 'H35.3210%' -- stage unspecified
 or problem_code ILIKE 'H35.3211%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3212%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3213%' -- with inactive scar
--Exudative age-related macular degeneration, left eye
  or problem_code ILIKE 'H35.3220%' -- stage unspecified
  or problem_code ILIKE 'H35.3221%' -- with active choroidal neovascularization
  or problem_code ILIKE 'H35.3222%' -- with inactive choroidal neovascularization
  or problem_code ILIKE 'H35.3223%' -- with inactive scar
  -- Exudative age-related macular degeneration, bilateral
 or problem_code ILIKE 'H35.3230%' -- stage unspecified
 or problem_code ILIKE 'H35.3231%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3232%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3233%' -- with inactive scar
/* -- Exudative age-related macular degeneration, unspecified eye
 or problem_code ILIKE 'H35.3290%' -- stage unspecified
 or problem_code ILIKE 'H35.3291%' -- with active choroidal neovascularization
 or problem_code ILIKE 'H35.3292%' -- with inactive choroidal neovascularization
 or problem_code ILIKE 'H35.3293%' -- with inactive scar*/
 --Angioid streaks of macula
 or problem_code ILIKE 'H35.33%' 
 -- Macular cyst, hole, or pseudohole
  or problem_code ILIKE 'H35.341%' -- right eye
  or problem_code ILIKE 'H35.342%' -- left eye
  or problem_code ILIKE 'H35.343%' -- bilateral
/*  or problem_code ILIKE 'H35.349%' -- unspecified eye*/
 -- Cystoid macular degeneration
  or problem_code ILIKE 'H35.351%' -- right eye
  or problem_code ILIKE 'H35.352%' -- left eye
  or problem_code ILIKE 'H35.353%' -- bilateral
/*  or problem_code ILIKE 'H35.359%' -- unspecified eye*/
 -- Drusen (degenerative) of macula
  or problem_code ILIKE 'H35.361%' -- right eye
  or problem_code ILIKE 'H35.362%' -- left eye
  or problem_code ILIKE 'H35.363%' -- bilateral
/*  or problem_code ILIKE 'H35.369%' -- unspecified eye*/
 -- Puckering of macula
  or problem_code ILIKE 'H35.371%' -- right eye
  or problem_code ILIKE 'H35.372%' -- left eye
  or problem_code ILIKE 'H35.373%' -- bilateral
/*  or problem_code ILIKE 'H35.379' -- unspecified eye*/
 -- Toxic maculopathy
  or problem_code ILIKE 'H35.381%' -- right eye
  or problem_code ILIKE 'H35.382%' -- left eye
  or problem_code ILIKE 'H35.383%' -- bilateral
/*  or problem_code ILIKE 'H35.389%' -- unspecified eye*/
)
and (diag_eye='3')
and extract(year from diagnosis_date) BETWEEN 2015 and 2018);




-- Step 2: We need to join data sets to combine all patient_guid, diagnosis_dates, and eyes into one table.
-- We do this to be able to count the total unique count of patients in our cohort in the next step.
--NOTE: Broke up aao_grants.liet_diag_pull_new into 4 tables this run because time to run queries took too long when it was just two tables. 

DROP TABLE IF EXISTS aao_grants.liet_diag_join_new;

CREATE TABLE aao_grants.liet_diag_join_new AS
SELECT
	patient_guid,
	diagnosis_date,
	eye,
	practice_id,
	csme_status
FROM
	aao_grants.liet_diag_pull_new1
UNION
SELECT
	patient_guid,
	diagnosis_date,
	eye,
	practice_id,
	csme_status
FROM
	aao_grants.liet_diag_pull_new2
	UNION
SELECT
	patient_guid,
	diagnosis_date,
	eye,
	practice_id,
	csme_status
FROM
	aao_grants.liet_diag_pull_new3
	UNION
SELECT
	patient_guid,
	diagnosis_date,
	eye,
	practice_id,
	csme_status
FROM
	aao_grants.liet_diag_pull_new4;       


-- Step 3: Get total cohort patient counts 

--3a. Number of patients in cohort
SELECT count(DISTINCT patient_guid) from aao_grants.liet_diag_join_new; --21,748,335

--The prior count with unspecified eyes included was 32,460,201. 

