FUNCTION ROGForage, iHour, Length, Temp, Light, ROGpbio, ROGcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, ts, nROG, DOa, DOacclC, DOcritC, ROG;, Grid2D
; This function calculates total consumption (g) by yellow perch

;On_Error,1
;;***********TEST ONLY****************************************************************************************
;PRO ROGForage, iHour, Length, Temp, Light, ROGpbio, ROGcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
;StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, ts, nROG, DOa, DOacclC, DOcritC, ROG, Grid2D
;; Parameter values needed to test the function
;;***TURN OFF when running with the full model****************************************************************
;;***ADJUST nEMS and other parameters IN "EMSinitial", "newfinpufiles", "EMScmax", "YEPstcap"**********************
;ts = 6L;*10*24; in min, time step of the model
;ihour = 15L
;nROG = 300L; the numbner of yellow perch superindividuals
;nYP = 2000L;
;;nROG = 2000L;
;;nROG = 2000L;
;
;Grid3D = GridCells3D()
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell) 
;BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;Grid2D = GridCells2D()
;NewInput = EcoForeInputfiles()
;NewInput = NewInput[*, 77500L * ihour : 77500L * ihour + 77499L]
;TotBenBio = TotBenBio + NewInput[8, *]
;
;NpopROG = 50000000
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput)
;
;ZooplBio = (ROG[15,*]+ROG[16,*]+ROG[17,*]);*4000000000; g per cell of 2km x 2km
;;2 km3 = 2000 000 000 000L
;;2 km3 = 2000 000 000 m3 = 2000 000 000 000L
;;4000 000 m3 =  4000 000 000L
;
;Nindividuals = ROG[0, *]
;Length = ROG[1, *]; in mm
;Weight = ROG[2, *]; in g
;Light = ROG[21, *]; in lux
;
;TacclR = ROG[27, *]
;TacclC = ROG[26, *]
;Tamb = ROG[19, *]
;DOa = ROG[20, *]
;DOacclR = ROG[29, *]
;DOacclC = ROG[28, *]
;DOacclim = ROGacclDO(DOacclR, DOacclC, DOa, TacclR, TacclC, Tamb, ts, length, weight, nROG)
;DOcritC = DOacclim[5, *]
;Temp = ROG[26, *]; acclimated temperature
;
;ROGcmx = ROGcmax(weight, length, nROG); [0.5, 0.5] ; Cmax in g 
;TotCday = ROG[9, *]; total consumption in last 24 hours -> the previous time step?
;PreStom = ROG[7, *] ; stomcah weight from the previous time step 
;TotC0 = ROG[48, *]; total amount of microzooplankton consumed over the last 24 hours in g
;TotC1 = ROG[49, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
;TotC2 = ROG[50, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
;TotC3 = ROG[51, *]; total amount of chironomids consumed over the last 24 hours in g
;TotC4 = ROG[52, *]; total amount of invasive species consumed over the last 24 hours in g
;TotC5 = ROG[53, *]; total amount of yellow perch consumed over the last 24 hours in g
;;TotC6 = ROG[54, *]; total amount of emerald shiner consumed over the last 24 hours in g
;;TotC7 = ROG[55, *]; total amount of rainbow smelt consumed over the last 24 hours in g
;;TotC8 = ROG[56, *]; total amount of round goby consumed over the last 24 hours in g
;
;Stcap = ROGstcap(weight, nROG); [0.24, 0.24]; maximum stocmach capacity
;CAftDig0 = ROG[30, *];[0.0001, 0.0000001]
;CAftDig1 = ROG[31, *];[0.0001, 0.00000001]
;CAftDig2 = ROG[32, *];[0.0001, 0.00000001]
;CAftDig3 = ROG[33, *];[0.00001, 0.0000001]
;CAftDig4 = ROG[34, *];[0.00001, 0.0000001]
;CAftDig5 = ROG[35, *];[0.00001, 0.0000001]
;;CAftDig6 = ROG[45, *];[0.00001, 0.0000001]
;;CAftDig7 = ROG[46, *];[0.00001, 0.0000001]
;;CAftDig8 = ROG[47, *];[0.00001, 0.0000001]
;
;;prey density in L or m2, 1L = 1000000mm^3 or 0.001m3, 1m2 = 1000000mm2
;; Use "/ROG[0, *]" for food availability per individual within superindividuals to incorporate density-dependence
;; -> See YEPintial
;;********************************************************
;; Creat a fish prey array for potential predators 
;;nGridcell = 77500L
;;YEPFISHPREY = FLTARR(5L, nGridcell)
;;ROGFISHPREY = FLTARR(5L, nGridcell)
;;ROGFISHPREY = FLTARR(5L, nGridcell)
;;ROGFISHPREY = FLTARR(5L, nGridcell)
;; yellow perch as prey
;;YEPFISHPREY[0, YP[14, *]] = YP[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;;YEPFISHPREY[1, YP[14, *]] = YP[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;;YEPFISHPREY[2, YP[14, *]] = YP[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;;YEPFISHPREY[3, YP[14, *]] = YP[2, *] * YP[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;;; emrald shiner as prey
;;ROGFISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;;ROGFISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;;ROGFISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;;ROGFISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;;; rainbow smelt as prey
;;ROGFISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;;ROGFISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;;ROGFISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;;ROGFISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;;; round goby as prey
;;ROGFISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;;ROGFISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;;ROGFISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;;ROGFISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;;PRINT, 'YEPFISHPREY'
;;PRINT, TRANSPOSE(YEPFISHPREY[0, ROG[14, *]]) 
;;PRINT, 'ROGFISHPREY'
;;PRINT, TRANSPOSE(ROGFISHPREY[0, ROG[14, *]])
;;PRINT, 'ROGFISHPREY' 
;;PRINT, TRANSPOSE(ROGFISHPREY[0, ROG[14, *]])
;;PRINT, 'ROGFISHPREY'
;;PRINT, TRANSPOSE(ROGFISHPREY[0, ROG[14, *]])
;
;;FISHPREY =FLTARR(5,nGridcell)
;;FISHPREY[0,*]= YEPFISHPREY[0, *]
;;FISHPREY[1,*]= ROGFISHPREY[0, *]
;;FISHPREY[2,*]= ROGFISHPREY[0, *]
;;FISHPREY[3,*]= ROGFISHPREY[0, *]
;;PRINT, 'FISHPREY', FISHPREY
;;********************************************************
;;YEPFISHPREY2 = FLTARR(5L, nGridcell)
;;ROGFISHPREY2 = FLTARR(5L, nGridcell)
;;ROGFISHPREY2 = FLTARR(5L, nGridcell)
;;ROGFISHPREY2 = FLTARR(5L, nGridcell)
;;YEPFISHPREY2 = YEPFISHPREY
;;ROGFISHPREY2 = ROGFISHPREY
;;ROGFISHPREY2 = ROGFISHPREY
;;ROGFISHPREY2 = ROGFISHPREY
;
;GridcellSize = 4000000000D*Grid2D[3, ROG[13, *]]/20L; grid cell size (L)
;;PRINT, 'GridcellSize'
;;PRINT, GridcellSize
;ROGpbio = FLTARR(21, nROG);  g/L or g/m2
;; density dependence is already incorporated for invertebrate prey
;ROGpbio[0,*] = ROG[15, *]*1L/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[1,*] = ROG[16, *]*1L/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[2,*] = ROG[17, *]*1L/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[3,*] = ROG[18, *]*1L/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[4,*] = 0.0/ (ROG[0, *] * ROG[2, *]/ GridcellSize); for invasive species 
;
;;ROGpbio[5, *] = YEPFISHPREY[0, ROG[14, *]]/ GridcellSize; yellow perch abundance
;;ROGpbio[6, *] = YEPFISHPREY[1, ROG[14, *]]; length
;;ROGpbio[7, *] = YEPFISHPREY[2, ROG[14, *]]; weight
;;ROGpbio[8, *] = YEPFISHPREY[3, ROG[14, *]]/ (ROG[0, *] * ROG[2, *]); biomass 
;;      
;;ROGpbio[9, *] = ROGFISHPREY[0, ROG[14, *]]/ GridcellSize; emerald shiner abundance
;;ROGpbio[10, *] = ROGFISHPREY[1, ROG[14, *]] 
;;ROGpbio[11, *] = ROGFISHPREY[2, ROG[14, *]]
;;ROGpbio[12, *] = ROGFISHPREY[3, ROG[14, *]]/(ROG[0, *] * ROG[2, *]) 
;;
;;ROGpbio[13, *] = ROGFISHPREY[0, ROG[14, *]]/ GridcellSize; rainbow smelt abundance
;;ROGpbio[14, *] = ROGFISHPREY[1, ROG[14, *]] 
;;ROGpbio[15, *] = ROGFISHPREY[2, ROG[14, *]]
;;ROGpbio[16, *] = ROGFISHPREY[3, ROG[14, *]]/(ROG[0, *] * ROG[2, *])
;;
;;ROGpbio[17, *] = ROGFISHPREY[0, ROG[14, *]]/ GridcellSize; round goby abundance
;;ROGpbio[18, *] = ROGFISHPREY[1, ROG[14, *]] 
;;ROGpbio[19, *] = ROGFISHPREY[2, ROG[14, *]]
;;ROGpbio[20, *] = ROGFISHPREY[3, ROG[14, *]]/(ROG[0, *] * ROG[2, *])
;PRINT, 'ROGpbio'
;PRINT, ROGpbio
;;********************************************************************************************

PRINT, 'YEPForage Begins Here'
tstart = SYSTIME(/seconds)

; WHEN THEY ARE SMALL (<5g OR 70mm), THEY EAT ZOOPLANKTON AND BENTHIC INVERTEBRATES.****************
tss = ts*60.; time step in secound
m = 6; the number of prey tROGes 
NewStom = FLTARR(nROG); the amount of food in stomach
TotC = FLTARR(m, nROG); daily cumulative consumption of each prey item 
TotCts = FLTARR(nROG)
DigestedFood = FLTARR(m, nROG); the total amount of digested prey used for growth
PotStAftDig = FLTARR(nROG); potential stomach content after digestion 
C = FLTARR(m, nROG); the amount of each prey item consumed per time step
CAftDig = FLTARR(m ,nROG); the amoung of each prey item digested
CAftDig[0,*] = CAftDig0[*]
CAftDig[1,*] = CAftDig1[*]
CAftDig[2,*] = CAftDig2[*]
CAftDig[3,*] = CAftDig3[*]
CAftDig[4,*] = CAftDig4[*]
CAftDig[5,*] = CAftDig5[*]
;CAftDig[6,*] = CAftDig6[*]
;CAftDig[7,*] = CAftDig7[*]
;CAftDig[8,*] = CAftDig8[*]
;PRINT, 'CAftDig'
;PRINT, CAftDig[0:8,*]
;
;PRINT, 'TotCday'
;PRINT, TRANSPOSE(TotCday)
;PRINT, 'ROGcmx'
;PRINT, (ROGcmx)
;PRINT, 'Previous stomach content (PreStom)'
;PRINT, TRANSPOSE(PreStom)
;PRINT, 'Stomach Capacity (StCap)'
;PRINT, TRANSPOSE(StCap)


; Determine prey characteristics for each prey tROGe (m)
; Prey length (mm)
PL = FLTARR(m+4, nROG)
PL[0, *] = RANDOMU(seed, nROG)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nROG)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nROG)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nROG)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nROG)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm

PL[5, *] = ROGpbio[6, *]; length for yellow perch in mm 
PL[6, *] = ROGpbio[10, *]; length for emerald shiner in mm 
PL[7, *] = ROGpbio[14, *]; length for rainbow smelt in mm 
PL[8, *] = ROGpbio[18, *]; length for round goby in mm 
PL[9, *] = ROGpbio[22, *]; walleye
;  PRINT, 'Prey length (PL, mm)'
;  PRINT, PL

; Prey individual weight (g, wet)
;**********NEED TO LENGTH-WEIGHT REALTIONSHIPS FOR PREY**********
PW = FLTARR(m+4, nROG); weight of each prey tROGe
; assign weights to each prey tROGe in g
PW[0, *] = 0.182 / 1000000.0; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.0; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.0; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.0; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet

PW[5, *] = ROGpbio[7, *];
PW[6, *] = ROGpbio[11, *];
PW[7, *] = ROGpbio[15, *];
PW[8, *] = ROGpbio[19, *];
PW[9, *] = ROGpbio[23, *];
;  PRINT, 'Prey weight (PW, g wet)'
;  PRINT, PW

; Convert prey biomass (g/L or m^2) into numbers/L or /m^2
dens = FLTARR(m+4, nROG)
dens[0,*] = ROGpbio[0,*] / Pw[0,*]; for microzooplankton 
dens[1,*] = ROGpbio[1,*] / Pw[1,*]; for small mesozooplankton
dens[2,*] = ROGpbio[2,*] / Pw[2,*]; for large mesozooplankton
pbio3 = WHERE(ROGpbio[3,*] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
IF pbio3count GT 0.0 THEN dens[3, pbio3] = ROGpbio[3, pbio3] / Pw[3,pbio3] ELSE dens[3, pbio3c] = 0.0; for chironmoid
pbio4 = WHERE(ROGpbio[4,*] GT 0.0, pbio4count, complement = pbio4c, ncomplement = pbio4ccount)
IF pbio4count GT 0.0 THEN dens[4, pbio4] = ROGpbio[4, pbio4] / Pw[4,pbio4] ELSE dens[4, pbio4c] = 0.0; for invasive species 

pbio5 = WHERE(ROGpbio[8,*] GT 0.0 AND PW[5, *] GT 0.0, pbio5count, complement = pbio5c, ncomplement = pbio5ccount)
IF pbio5count GT 0.0 THEN dens[5, pbio5] = ROGpbio[8, pbio5] / Pw[5,pbio5] ELSE dens[5, pbio5c] = 0.0; for yellow perch
pbio6 = WHERE(ROGpbio[12,*] GT 0.0 AND PW[6, *] GT 0.0, pbio6count, complement = pbio6c, ncomplement = pbio6ccount)
IF pbio6count GT 0.0 THEN dens[6, pbio6] = ROGpbio[12, pbio6] / Pw[6,pbio6] ELSE dens[6, pbio6c] = 0.0; for emerald shiner
pbio7 = WHERE(ROGpbio[16,*] GT 0.0 AND PW[7, *] GT 0.0, pbio7count, complement = pbio7c, ncomplement = pbio7ccount)
IF pbio7count GT 0.0 THEN dens[7, pbio7] = ROGpbio[16, pbio7] / Pw[7,pbio7] ELSE dens[7, pbio7c] = 0.0; for rainbow smlet
pbio8 = WHERE(ROGpbio[20,*] GT 0.0 AND PW[8, *] GT 0.0, pbio8count, complement = pbio8c, ncomplement = pbio8ccount)
IF pbio8count GT 0.0 THEN dens[8, pbio8] = ROGpbio[20, pbio8] / Pw[8,pbio8] ELSE dens[8, pbio8c] = 0.0; for round goby
pbio9 = WHERE(ROGpbio[24,*] GT 0.0 AND PW[9, *] GT 0.0, pbio9count, complement = pbio9c, ncomplement = pbio9ccount)
IF pbio9count GT 0.0 THEN dens[9, pbio9] = ROGpbio[24, pbio9] / Pw[9,pbio9] ELSE dens[9, pbio9c] = 0.0; for round goby
;  PRINT, 'Prey density (dens)'
;  PRINT, dens

  ;---DO function---------------------------------------------------------------------------------------
  ; DO function parametner values from Niklitschek and Secor 2009
  ;cfc = 1.0;  DO response shape parameter
  ;dfc = 2.5; +- 0.46 constant for reaction rate at lowest DOsat
  ;gfc = 0.73; +-0.072 constant for DOCfc
  ;DO1 = 25.0; in %  lowest tested DOsat

  ;fDOrm = 0.9; from respiration function -> test only
  ;DoacclSAT = 50.0; in %

; DO function from Atalntic Sturgeon by Niklitschek and Secor 2009
  ;DOCfc = 100.0 * (1.0 - gfc * exp(-fTfc * fDOrm))
  ;KO1fc = 1.0 - dfc * exp(fTfc * fDOrm - 1.0)
  ;SLfc = (KO1fc - 1.0) / (0.01 * (DOCfc - DO1))^cfc

  ;tempc = where(DOacclSAT lt DOCfc, tempcount, complement = cc, ncomplement = tempcccount)
  ;IF (tempcount GT 0.0) THEN fDOfc = 1.0 - SLfc * (DOCfc - DOacclSAT)^cfc ELSE fDOfc = 1.0
  ;IF (DOacclSAT lt DOCfc) THEN fDOfc = 1.0 - SLfc * (DOCfc - DOacclSAT)^cfc ELSE fDOfc = 1.0

  fDOfc2 = FLTARR(nROG)
;  PRINT, 'DOa'
;  PRINT, TRANSPOSE(DOa)
;  PRINT, 'DOacclC'
;  PRINT, TRANSPOSE(DOacclC)
;  PRINT, 'DOcritC'
;  PRINT, TRANSPOSE(DOcritC)
  ; Determine if 
  DOc = WHERE(2*DOcritC GE DOacclC, DOccount, complement = DOcc, ncomplement = DOcccount)
  IF (DOccount GT 0.0) THEN fDOfc2[DOc] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclC[DOc] + (4. - 2*DOcritC[DOc])) + 6.5916))
  IF (DOcccount GT 0.0) THEN fDOfc2[DOcc] = 1.0
  ;PRINT, 'DOCfc =', DOCfc, 'KO1fc =', KO1fc, 'SLfc =', SLfc, 'fDOfc =', fDOfc, 'DOacclC =', DOacclC, 'fDOfc2 =', fDOfc2
  PRINT, 'Number of fish in hypoxic cells (DOccount) =', DOccount
  ;PRINT,'fDOfc2 =', fDOfc2
;---------------------------------------------------------------------------------------------------

; Determine if food consumption has reached daily Cmax or full stomach in the previous time step
tds = WHERE((TotCday LT ROGcmx) AND (PreStom LT Stcap), tdscount, complement = d, ncomplement = dcount)
PRINT, 'Number of fish with less than full stomach =', tdscount
;IF ((iHour GE 4L) AND (iHour LE 20L)) THEN BEGIN; restricting foraging within only daylight hours 5am to 9pm
IF (tdscount GT 0.0) THEN BEGIN; if fish hasn't consumed more than cmax in the previous time step

; Fish swimming speed calculation, S, in body lengths/sec
;***NEED TO CORRECT FUNCTIONS AND INCLUDE SS FOR ROUND GOBY***
  SS = FLTARR(nROG)
  S = FLTARR(nROG)
  L = WHERE(Length LT 20., Lcount, complement = LL, ncomplement = LLcount)
  IF (Lcount GT 0.) THEN S[L] = 3.3354 * ALOG(length[L]) - 4.8758;(-0.0797 * (length[l] * length[l]) + 1.9294 * length[l] - 8.1761)
   ;SS equation based on data from Houde 1969 in body lengths/sec
  IF (LLcount GT 0.0) THEN S[LL] = (0.28 * Temp[LL] + 7.89) / (0.1 * Length[LL])
   ;in body lengths/sec; from Breck 1997 and Hergenrader and Hasler 1967 
  ; Converts SS into mm/s
  SS = (S * length)
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS

; Calculate predator size-based prey selectivity (Chesson's alpha) for each prey tROGe
;************NEED TO ADJUST FOR LARGE PISCIVOROUS FISH (HIGHER SPECIES SPECIFIC SELECTIVITY)***********************
  Calpha = FLTARR(m, nROG); from Letcher et al. for zooplankton
  Calpha[0, *] = 193499 * Length^(-7.64); for microzooplankton - rotifers
  Calpha[1, *] = 0.272 * ALOG(Length) - 0.3834; for mesozooplankton1 - calanoids
  Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
  PL3 = WHERE((PL[3, *] / Length) LE 0.2, PL3count, complement = PL3c, ncomplement = pl3ccount)
  IF (PL3count GT 0.0) THEN Calpha[3, PL3] = ABS(0.50 - 1.75 * (PL[3, PL3] / Length[PL3])) 
  IF (PL3ccount GT 0.0) THEN Calpha[3, PL3c] = 0. ;for benthic prey for flounder by Rose et al. 1996 
  
  Length60 = WHERE(Length GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)
  IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
  IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.
  
  Length80 = WHERE((Length GT 80.0), Length80count, complement = Length80c, ncomplement = Length80ccount)
 
  PL5 = WHERE(((PL[5, *] / Length) LT 0.2), PL5count, complement = PL5c, ncomplement = PL5ccount)
  PL5a = WHERE(((PL[5, *] / Length) GT 0.2), PL5acount, complement = PL5ac, ncomplement = PL5account)
  IF (Length80count GT 0.0) AND (PL5count GT 0.0) THEN Calpha[5, Length80] = 0.5
  IF (Length80ccount GT 0.0) AND (PL5count GT 0.0) THEN Calpha[5, PL5] = 0.25
  IF (Length80ccount GT 0.0) AND (PL5acount GT 0.0) THEN Calpha[5, PL5a] = 0.00 ; for fish
  
;  PL6 = WHERE(((PL[6, *] / length) LT 0.2) AND (Length LE 80.0), PL6count, complement = PL6c, ncomplement = PL6ccount)
;  PL6a = WHERE(((PL[6, *] / Length) GT 0.2) AND (Length LE 80.0), PL6acount, complement = PL6ac, ncomplement = PL6account)
;  IF (Length80count GT 0.0) THEN Calpha[6, Length80] = 0.5 ELSE $
;  IF (PL6count GT 0.0) THEN Calpha[6, PL6] = 0.25 ELSE $ 
;  IF (PL6acount GT 0.0) THEN Calpha[6, PL6a] = 0.00 ; for fish
;  
;  PL7 = WHERE(((PL[7, *] / length) LT 0.2) AND (Length LE 80.0), PL7count, complement = PL7c, ncomplement = PL7ccount)
;  PL7a = WHERE(((PL[7, *] / Length) GT 0.2) AND (Length LE 80.0), PL7acount, complement = PL7ac, ncomplement = PL7account)
;  IF (Length80count GT 0.0) THEN Calpha[7, Length80] = 0.5 ELSE $
;  IF (PL7count GT 0.0) THEN Calpha[7, PL7] = 0.25 ELSE $ 
;  IF (PL7acount GT 0.0) THEN Calpha[7, PL7a] = 0.00 ; for fish
;  
;  PL8 = WHERE(((PL[8, *] / length) LT 0.2) AND (Length LE 80.0), PL8count, complement = PL8c, ncomplement = PL8ccount)
;  PL8a = WHERE(((PL[8, *] / Length) GT 0.2) AND (Length LE 80.0), PL8acount, complement = PL8ac, ncomplement = PL8account)
;  IF (Length80count GT 0.0) THEN Calpha[8, Length80] = 0.5 ELSE $
;  IF (PL8count GT 0.0) THEN Calpha[8, PL8] = 0.25 ELSE $ 
;  IF (PL8acount GT 0.0) THEN Calpha[8, PL8a] = 0.00 ; for fish
;  PRINT, 'Chessons alpha'
;  PRINT, Calpha
  
  ; Determine light effect
  ; LId (z,t) = LI(0,t)*exp(-z*k), light intensity at depth z time t with light extinction coefficient, k 
  
  ;IF ((iHour LE 4L) OR (iHour GT 20L)) THEN light[*] = .5; 
  
  litfac = FLTARR(nROG); a multiplication factor to include the effect of light intensity on RD
  litfac[*] = (126.31 + (-113.6 * EXP(-1.0 * light[*]))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.
  ;or R = 4.3 I*(0.1+I)^(-1) from Richmond et al., 2003
;  PRINT, 'Light intensity (lux)'
;  PRINT, TRANSPOSE(light)
;  PRINT, 'Light multiplication factor'
;  PRINT, litfac
  
  ; Determine foraging for each prey tROGe present
  ; Calculate reactive distance in mm (from cm), Breck and Gitter. 1983.
  ;****Reactive distance may be used for the movement decision***********************
  ; Calculate alpha = fish length function in reactive distance, RD
  alphaDig = FLTARR(nROG)
  ;alpha = (0.0167 * exp(9.14 - 2.4 * alog(length) + 0.229 * (alog(length))^2));*!pi/180*(1/60)
  ; from Breck and Gitter, 1983
  ;ln(alpha) = 9.14 - 2.4*alog(length) + 0.229*(alog(length))^2
  alphaDig = EXP(9.14 - 2.4 * ALOG(length) + 0.229*(ALOG(length))^2.0) / 60.0
  ;alphaRad = alphaDig*2*!PI/360
;  PRINT, 'alphaDig'
;  PRINT, TRANSPOSE(alphaDig)
  
  RD = FLTARR(m+4, nROG); RD = 0.5*PL/tan(2.0*!PI*(1.0/360.0)*alphaDig/2.0)
  RD[0, *] = 0.5 * PL[0, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac  
  RD[1, *] = 0.5 * PL[1, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[2, *] = 0.5 * PL[2, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[3, *] = 0.5 * PL[3, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac * 0.36; for benthic prey from Breck 1993
  RD[4, *] = 0.5 * PL[4, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac
  RD[5, *] = 0.5 * PL[5, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[6, *] = 0.5 * PL[6, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[7, *] = 0.5 * PL[7, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[8, *] = 0.5 * PL[8, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
  RD[9, *] = 0.5 * PL[9, *] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig / 2.0) * litfac 
;  PRINT, 'Reactive distance (RD, mm)'
;  PRINT, RD  
   
  ; calculate reactive area in mm^2 for zoolplankton diet
  ; Include tubididty from Rose et al. 1996 for founder
  ;IF RD LT 15 THEN Frd = 0.8 - 0.025 * RD
  ;IF RD GE 15 THEN Frd = 0.4  
  
  ; For larval fish (less than 20mm) that can perceive one half of the circle defined by reactive distance
  prop = FLTARR(nROG)
  Larva = WHERE(length LE 20.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
  IF (Larvacount GT 0.0) THEN prop[Larva] = 0.50 
  IF (JuvAducount GT 0.0) THEN prop[JuvAdu] = 1.0 
;  PRINT, 'Proporton of reactive distance'
;  PRINT, prop
  
  ; Reactive area (mm2)
  RA = FLTARR(m+4, nROG)
  RA[0, *] = ((RD[0, *])^2.0 * !PI * prop)
  RA[1, *] = ((RD[1, *])^2.0 * !PI * prop)
  RA[2, *] = ((RD[2, *])^2.0 * !PI * prop)
  RA[3, *] = ((RD[3, *])^2.0 * !PI * prop)
  RA[4, *] = ((RD[4, *])^2.0 * !PI * prop)
  RA[5, *] = ((RD[5, *])^2.0 * !PI * prop)
  RA[6, *] = ((RD[6, *])^2.0 * !PI * prop)
  RA[7, *] = ((RD[7, *])^2.0 * !PI * prop)
  RA[8, *] = ((RD[8, *])^2.0 * !PI * prop)
  RA[9, *] = ((RD[9, *])^2.0 * !PI * prop)
  ; RA = (RD * Frd)^2 * !PI * prop with turbidity
;  PRINT, 'Reactive area (RA, mm2)'
;  PRINT, RA

; Volume (zooplankton) or area (benthos) searched in L or m^2 PER SECOUND-> ***CHANGE IN UNIT BECAUSE OF UNIT FOR DENSITY INPUTS
  VS = FLTARR(m+4, nROG); MULTIPLY BY 10.00^(-6.00) from mm3 to L OR mm2 to m2 or mm3 to m3
  VS[0,*] = DOUBLE(SS * RA[0,*] * 10.0^(-6.0))
  VS[1,*] = DOUBLE(SS * RA[1,*] * 10.0^(-6.0))
  VS[2,*] = DOUBLE(SS * RA[2,*] * 10.0^(-6.0))
  VS[3,*] = DOUBLE(SS * 2.0 * RD[3, *] * SIN(!PI/3.0) * 10.00^(-6.0)); Area for benthos from Breck 1993; VS[3,*] = SS * 2.0 * Frd * RD[3,*] with turbidity
  VS[4,*] = DOUBLE(SS * RA[4,*] * 10.0^(-6.0))
  
  VS[5,*] = DOUBLE(SS * RA[5,*] * 10.0^(-9.0))
  VS[6,*] = DOUBLE(SS * RA[6,*] * 10.0^(-9.0))
  VS[7,*] = DOUBLE(SS * RA[7,*] * 10.0^(-9.0))
  VS[8,*] = DOUBLE(SS * RA[8,*] * 10.0^(-9.0))
  VS[9,*] = DOUBLE(SS * RA[9,*] * 10.0^(-9.0))
;  PRINT, 'Volume searched (VS, L or m2 /s)'
;  PRINT, VS
  
; Calculate potential encounter rate # per time step (ts)
;*****NEED to incorporate size-based inter-/intra-specific interactions and density dependence****
  ER = FLTARR(m, nROG)
  ;********"ROUND" or "CEIL"?***************
  ER[0, *] = CEIL(VS[0, *] * dens[0, *]); * 60.0 * ts)
  ER[1, *] = CEIL(VS[1, *] * dens[1, *]); * 60.0 * ts)
  ER[2, *] = CEIL(VS[2, *] * dens[2, *]); * 60.0 * ts)
  ER[3, *] = CEIL(VS[3, *] * dens[3, *]); * 60.0 * ts)
  ER[4, *] = CEIL(VS[4, *] * dens[4, *]); * 60.0 * ts)
  ER[5, *] = CEIL(VS[5, *] * dens[5, *]); * 60.0 * ts)
;  ER[6, *] = (VS[6, *] * dens[6, *] * 60.0 * ts)
;  ER[7, *] = (VS[7, *] * dens[7, *] * 60.0 * ts)
;  ER[8, *] = (VS[8, *] * dens[8, *] * 60.0 * ts)
;  PRINT, 'Encounter rate (ER, #/ts)'
;  PRINT, ER
  
  ERP = FLTARR(5, nROG); ENCOUNTER RATE FOR COMPETITORS
  ; ALL
  ERP[0, *] = CEIL(VS[5, *] * ROGpbio[25, *]); yellow perch
  ERP[1, *] = CEIL(VS[6, *] * ROGpbio[26, *]); emerald shiner
  ERP[2, *] = CEIL(VS[7, *] * ROGpbio[27, *]); rainbow smelt
  ERP[3, *] = CEIL(VS[8, *] * ROGpbio[28, *]); round goby
  ERP[4, *] = CEIL(VS[9, *] * ROGpbio[29, *]); walleye
  
  ERPintra = ERP[3, *]
  ERPinter = ERP[1, *] + ERP[2, *] + ERP[0, *] + ERP[4, *]
;  PRINT, 'Competitor encounter rate (ERP, #/s)'
;  PRINT, ERP
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  PRINT, TRANSPOSE(ERPintra)
;  PRINT, 'Interspecific competitor encounter rate (ERPinter, #/s)'
;  PRINT, TRANSPOSE(ERPinter)
  
  
; Calculate handling time in s
;*****HandLing time should not exceed 6 minutes or 360s*******-->CHECK HOW HANDLING TIME IS TREATED IN BOOKS AND PAPPERS*********** 
  ;**********Handling time parameters are calibrated for LARVAL YELLOW PERCH******
  ;**********NEED TO FIND PARAMTERS FOR LARGE FISH AND OTEHR SPECIES**********
  L = TRANSPOSE(length)
  HT = FLTARR(m, nROG)
  SumHT = FLTARR(nROG) 
  HTint = 0.264; for LARVAL YELLOW PERCH
  HTsl = 7.0151; for LARVAL YELLOW PERCH
  HT[0, *] = EXP(HTint * 10.0^(HTsl * (PL[0, *]/L)))
  HT[1, *] = EXP(HTint * 10.0^(HTsl * (PL[1, *]/L))) 
  HT[2, *] = EXP(HTint * 10.0^(HTsl * (PL[2, *]/L))) 
  HT[3, *] = EXP(HTint * 10.0^(HTsl * (PL[3, *]/L)))
  HT3 = WHERE(HT[3, *] GT tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
  IF (HT3count GT 0.0) THEN HT[3, HT3] = tss 
  IF (HT3ccount GT 0.0) THEN HT[3, HT3c] = HT[3, HT3c]
  HT[4, *] = EXP(HTint * 10.^(HTsl * (PL[4, *]/L))) 
  HT4 = WHERE(HT[4, *] GT tss, HT4count, complement = HT4c, ncomplement = HT4ccount)
  IF (HT4count GT 0.0) THEN HT[4, HT4] = tss 
  IF (HT4ccount GT 0.0) THEN HT[4, HT4c] = HT[4, HT4c]
  HT[5, *] = EXP(HTint * 10.^(HTsl * (PL[5, *]/L))) 
  HT5 = WHERE(HT[5, *] GT tss, HT5count, complement = HT5c, ncomplement = HT5ccount)
  IF (HT5count GT 0.0) THEN HT[5, HT5] = tss 
  IF (HT5ccount GT 0.0) THEN HT[5, HT5c] =  HT[5, HT5c] 
;  HT[6, *] = EXP(HTint * 10.^(HTsl * (PL[6, *]/L))) 
;  HT6 = WHERE(HT[6, *] GT 360.0, HT6count, complement = HT6c, ncomplement = HT6ccount)
;  IF (HT6count GT 0.0) THEN HT[6, HT6] = 360.0 $
;  ELSE HT[6, HT6c] = HT[6, HT6c]
;  HT[7, *] = EXP(HTint * 10.^(HTsl * (PL[7, *]/L))) 
;  HT7 = WHERE(HT[7, *] GT 360.0, HT7count, complement = HT7c, ncomplement = HT7ccount)
;  IF (HT7count GT 0.0) THEN HT[7, HT7] = 360.0 $
;  ELSE HT[7, HT7c] = HT[7, HT7c]
;  HT[8, *] = EXP(HTint * 10.^(HTsl * (PL[8, *]/l))) 
;  HT8 = WHERE(HT[8, *] GT 360.0, HT8count, complement = HT8c, ncomplement = HT8ccount)
;  IF (HT8count GT 0.0) THEN HT[8, HT8] = 360.0 $
;  ELSE HT[8, HT8c] = HT[8, HT8c] 
;  PRINT, 'Handling time (HT, s)'
;  PRINT, HT
  SumHT[*] = HT[0,*] + HT[1,*] + HT[2,*] + HT[3,*] + HT[4,*] + HT[5,*]; + HT[6,*] + HT[7,*] + HT[8,*]
;  PRINT, 'Potential total handling time (SumHT, s)'
;  PRINT, SumHT
  
; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(nROG); probability of all prey atacked and captured
  t = FLTARR(m, nROG);  probability of each prey atacked and captured
  t[0,*] = (Calpha[0,*] * dens[0,*])
  t[1,*] = (Calpha[1,*] * dens[1,*])
  t[2,*] = (Calpha[2,*] * dens[2,*])
  t[3,*] = (Calpha[3,*] * dens[3,*])
  t[4,*] = (Calpha[4,*] * dens[4,*])
  t[5,*] = (Calpha[5,*] * dens[5,*])
;  t[6,*] = (Calpha[6,*] * dens[6,*])
;  t[7,*] = (Calpha[7,*] * dens[7,*])
;  t[8,*] = (Calpha[8,*] * dens[8,*])
  TOT[*] = t[0,*] + t[1,*] + t[2,*] + t[3,*] + t[4,*] + t[5,*]; + t[6,*] + t[7,*] + t[8,*]
;  PRINT, 'Proportion of each prey item attcked and captured (t)'
;  PRINT, t
;  PRINT, 'Proportion of all prey itROG attcked and captured (tot)'
;  PRINT, TOT
  
  Q = FLTARR(m,nROG); Probability of attack and capture
  TOTNZ = WHERE(TOT[*] GT 0.0, TOTNZcount, complement = TOTZ, ncomplement = TOTZcount)
  ; If no prey is available in a cell, Q = 0
  IF TOTNZcount GT 0.0 THEN BEGIN
    Q[0,TOTNZ] = DOUBLE(t[0,TOTNZ] / TOT[TOTNZ]) 
    Q[1,TOTNZ] = DOUBLE(t[1,TOTNZ] / TOT[TOTNZ])
    Q[2,TOTNZ] = DOUBLE(t[2,TOTNZ] / TOT[TOTNZ])
    Q[3,TOTNZ] = DOUBLE(t[3,TOTNZ] / TOT[TOTNZ])
    Q[4,TOTNZ] = DOUBLE(t[4,TOTNZ] / TOT[TOTNZ])
    Q[5,TOTNZ] = DOUBLE(t[5,TOTNZ] / TOT[TOTNZ])
  ;  Q[6,TOTNZ] = DOUBLE(t[6,TOTNZ] / TOT[TOTNZ])
  ;  Q[7,TOTNZ] = DOUBLE(t[7,TOTNZ] / TOT[TOTNZ])
  ;  Q[8,TOTNZ] = DOUBLE(t[8,TOTNZ] / TOT[TOTNZ])
  ENDIF 
  IF TOTZcount GT 0.0 THEN BEGIN
    Q[0,TOTZ] = 0.0
    Q[1,TOTZ] = 0.0
    Q[2,TOTZ] = 0.0
    Q[3,TOTZ] = 0.0
    Q[4,TOTZ] = 0.0
    Q[5,TOTZ] = 0.0
  ;  Q[6,TOTZ] = 0.0
  ;  Q[7,TOTZ] = 0.0
  ;  Q[8,TOTZ] = 0.0
  ENDIF
;  PRINT, 'Probability of attack and cature (Q) without temperature and DO effect'
;  PRINT, Q
  

;; Temperature-dependent function for C 
;  ; Parameter values for energy loss
;  fTfc = FLTARR(nROG)
;  ;values are for larval yellow perch
;;  TL = WHERE(length LE 20.0, TLcount, complement = TLL, ncomplement = TLLcount)
;;  IF (TLcount GT 0.0) THEN BEGIN
;  CK1 = 0.113
;  CK4 = 0.419
;  CQ = 5.594
;  CTM = 25.706
;  CTO = 24.648
;  CTL = 28.992
;  G1 = (1. / (CTO - CQ)) * ALOG((0.98 * (1.- CK1)) / (CK1 * 0.02))
;  G2 = (1. / (CTL - CTM)) * ALOG((0.98 * (1.- CK4)) / (CK4 * 0.02))
;  L1 = EXP(G1 * (Temp - CQ))
;  L2 = EXP(G2 * (CTL - Temp))
;  KA = (CK1 * L1) / (1. + CK1 * (L1 - 1.))
;  KB = (CK4 * L2) / (1. + CK4 * (L2 - 1.))
;  fTfc = KA * KB
;  ;ENDIF; ELSE BEGIN
;  ;values are for juvenile and adult yellow perch
;;  IF (TLLcount GT 0.0) THEN BEGIN 
;
;;  ENDIF
;;  PRINT, 'ftfc'
;;  PRINT, ftfc
;  Q[0, *] = Q[0, *] * (fTfc * fDOfc2)^0.5
;  Q[1, *] = Q[1, *] * (fTfc * fDOfc2)^0.5
;  Q[2, *] = Q[2, *] * (fTfc * fDOfc2)^0.5
;  Q[3, *] = Q[3, *] * (fTfc * fDOfc2)^0.5
;  Q[4, *] = Q[4, *] * (fTfc * fDOfc2)^0.5
;  Q[5, *] = Q[5, *] * (fTfc * fDOfc2)^0.5
;;  Q[6, *] = Q[6, *] * (fTfc * fDOfc2)^0.5
;;  Q[7, *] = Q[7, *] * (fTfc * fDOfc2)^0.5
;;  Q[8, *] = Q[8, *] * (fTfc * fDOfc2)^0.5
;  PRINT, 'Probability of attack and cature (Q) with temperature and DO effect'
;  PRINT, Q
  

; Calculate the number of each prey consumed 
  E = FLTARR(m, nROG); encounter rate in individuals
  
  EPintra = FLTARR(nROG); encounter rate in individuals
  EPinter = FLTARR(nROG); encounter rate in individuals
  
  NumP = FLTARR(m, nROG); potential total number of prey consumed 
  FOR ind = 0L, nROG - 1L DO BEGIN ; for each superindividual
    ; Calculate realized encounter rate, E, based on a poisson distribution in individuals/ts
    IF ER[0, ind] GT 0. THEN E[0, ind] = RANDOMU(seed, POISSON = [ER[0, ind]], /double)
    IF ER[1, ind] GT 0. THEN E[1, ind] = RANDOMU(seed, POISSON = [ER[1, ind]], /double)
    IF ER[2, ind] GT 0. THEN E[2, ind] = RANDOMU(seed, POISSON = [ER[2, ind]], /double)
    IF ER[3, ind] GT 0. THEN E[3, ind] = RANDOMU(seed, POISSON = [ER[3, ind]], /double)
    IF ER[4, ind] GT 0. THEN E[4, ind] = RANDOMU(seed, POISSON = [ER[4, ind]], /double)
    IF ER[5, ind] GT 0. THEN E[5, ind] = RANDOMU(seed, POISSON = [ER[5, ind]], /double)
;    IF ER[6, ind] GT 0. THEN E[6, ind] = RANDOMU(seed, POISSON = [ER[6, ind]], /double)
;    IF ER[7, ind] GT 0. THEN E[7, ind] = RANDOMU(seed, POISSON = [ER[7, ind]], /double)
;    IF ER[8, ind] GT 0. THEN E[8, ind] = RANDOMU(seed, POISSON = [ER[8, ind]], /double)

    IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
    IF ERPinter[ind] GT 0. THEN EPinter[ind] = RANDOMU(seed, POISSON = [ERPinter[ind]], /double)
    
    ; Stochastic estimates for the number and tROGe of prey based on E from binomial distriution
    IF E[0, ind] GT 0. THEN NumP[0, ind] = (RANDOMU(seed, BINOMIAL = [E[0, ind], Q[0, ind]], /double))
    IF E[1, ind] GT 0. THEN NumP[1, ind] = (RANDOMU(seed, BINOMIAL = [E[1, ind], Q[1, ind]], /double))
    IF E[2, ind] GT 0. THEN NumP[2, ind] = (RANDOMU(seed, BINOMIAL = [E[2, ind], Q[2, ind]], /double))
    IF E[3, ind] GT 0. THEN NumP[3, ind] = (RANDOMU(seed, BINOMIAL = [E[3, ind], Q[3, ind]], /double))
    IF E[4, ind] GT 0. THEN NumP[4, ind] = (RANDOMU(seed, BINOMIAL = [E[4, ind], Q[4, ind]], /double))
    IF E[5, ind] GT 0. THEN NumP[5, ind] = (RANDOMU(seed, BINOMIAL = [E[5, ind], Q[5, ind]], /double))
;    IF E[6, ind] GT 0. THEN NumP[6, ind] = (RANDOMU(seed, BINOMIAL = [E[6, ind], Q[6, ind]], /double))
;    IF E[7, ind] GT 0. THEN NumP[7, ind] = (RANDOMU(seed, BINOMIAL = [E[7, ind], Q[7, ind]], /double))
;    IF E[8, ind] GT 0. THEN NumP[8, ind] = (RANDOMU(seed, BINOMIAL = [E[8, ind], Q[8, ind]], /double))                   
  ENDFOR
;  PRINT, 'Realized encounter rate (E, #/ts)'
;  PRINT, E
;  PRINT, 'Stochastic potential number of prey consumed (NumP)'
;  PRINT, NumP

  SD = FLTARR(m, nROG); handling time (HT) > 360s, then no conumption during each time step 
  SD[0,*] =  E[0,*] * Q[0,*] * HT[0,*]; 
  SD[1,*] =  E[1,*] * Q[1,*] * HT[1,*]; 
  SD[2,*] =  E[2,*] * Q[2,*] * HT[2,*]; 
  HT3 = WHERE(HT[3, *] EQ tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
  IF (HT3count GT 0.0) THEN SD[3, HT3] = 0.0 
  IF (HT3ccount GT 0.0) THEN SD[3, HT3c] =  E[3, HT3c] * Q[3, HT3c] * HT[3, HT3c]; 
  HT4 = WHERE(HT[4, *] EQ tss, HT4count, complement = HT4c, ncomplement = HT4ccount)
  IF (HT4count GT 0.0) THEN SD[4, HT4] = 0.0 
  IF (HT4ccount GT 0.0) THEN SD[4, HT4c] =  E[4, HT4c] * Q[4, HT4c] * HT[4, HT4c]; 
  HT5 = WHERE(HT[5, *] EQ tss, HT5count, complement = HT5c, ncomplement = HT5ccount)
  IF (HT5count GT 0.0) THEN SD[5, HT5] = 0.0 
  IF (HT5ccount GT 0.0) THEN SD[5, HT5c] =  E[5, HT5c] * Q[5, HT5c] * HT[5, HT5c];
;  HT6 = WHERE(HT[6, *] EQ 360.0, HT6count, complement = HT6c, ncomplement = HT6ccount)
;  IF (HT6count GT 0.0) THEN SD[6, HT6] = 0.0 $
;  ELSE SD[6, HT6c] =  E[6, HT6c] * Q[6, HT6c] * HT[6, HT6c];
;  HT7 = WHERE(HT[7, *] EQ 360.0, HT7count, complement = HT7c, ncomplement = HT7ccount)
;  IF (HT7count GT 0.0) THEN SD[7, HT7] = 0.0 $
;  ELSE SD[7, HT7c] =  E[7, HT7c] * Q[7, HT7c] * HT[7, HT7c];
;  HT8 = WHERE(HT[8, *] EQ 360.0, HT8count, complement = HT8c, ncomplement = HT8ccount)
;  IF (HT8count GT 0.0) THEN SD[8, HT8] = 0.0 $
;  ELSE SD[8, HT8c] =  E[8, HT8c] * Q[8, HT8c] * HT[8, HT8c];
;  PRINT, 'SD'
;  PRINT, SD
  SumDen = FLTARR(nROG)
  SumDen[*] = SD[0, *] + SD[1, *] + SD[2, *] + SD[3, *] + SD[4, *] + SD[5, *]; + SD[6, *] + SD[7, *] + SD[8, *]
;  PRINT, 'SumDen'
;  PRINT, SumDen

  
; calculate the amount of each prey type consumed 
 ; IF handlign time is greater than 360, no consumption
  cons = FLTARR(m, nROG)
  cons[0,*] = DOUBLE(PW[0,*] * Nump[0,*]) 
  cons[1,*] = DOUBLE(PW[1,*] * Nump[1,*]) 
  cons[2,*] = DOUBLE(PW[2,*] * Nump[2,*])
  HT3 = WHERE(HT[3, *] EQ tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
  IF (HT3count GT 0.0) THEN cons[3, HT3] = 0.0 
  IF (HT3ccount GT 0.0) THEN cons[3, HT3c] = DOUBLE(PW[3,HT3c] * Nump[3,HT3c])
  HT4 = WHERE(HT[4, *] EQ tss, HT4count, complement = HT4c, ncomplement = HT4ccount)
  IF (HT4count GT 0.0) THEN cons[4, HT4] = 0.0 
  IF (HT4ccount GT 0.0) THEN cons[4, HT4c] = DOUBLE(PW[4, HT4c] * Nump[4, HT4c]) 
  HT5 = WHERE(HT[5, *] EQ tss, HT5count, complement = HT5c, ncomplement = HT5ccount)
  IF (HT5count GT 0.0) THEN cons[5, HT5] = 0.0 
  IF (HT5ccount GT 0.0) THEN cons[5, HT5c] = DOUBLE(PW[5, HT5c] * Nump[5, HT5c]) 
;  HT6 = WHERE(HT[6, *] EQ 360.0, HT6count, complement = HT6c, ncomplement = HT6ccount)
;  IF (HT6count GT 0.0) THEN cons[6, HT6] = 0.0 $
;  ELSE cons[6, HT6c] = DOUBLE(PW[6, HT6c] * Nump[6, HT6c]) 
;  HT7 = WHERE(HT[7,*] EQ 360.0, HT7count, complement = HT7c, ncomplement = HT7ccount)
;  IF (HT7count GT 0.0) THEN cons[7, HT7] = 0.0 $
;  ELSE cons[7, HT7c] = DOUBLE(PW[7, HT7c] * Nump[7, HT7c]) 
;  HT8 = WHERE(HT[8, *] EQ 360.0, HT8count, complement = HT8c, ncomplement = HT8ccount)
;  IF (HT8count GT 0.0) THEN cons[8, HT8] = 0.0 $
;  ELSE cons[8, HT8c] = DOUBLE(PW[8, HT8c] * Nump[8, HT8c]) 
;  PRINT, 'Potential amount of each prey tROGe consumed (cons, g)'
;  PRINT, cons
    
;  PRINT, 'Realised intraspecific competitor encounter rate (EPintra, #/s)'
;  PRINT, (EPintra[0:100])
;  PRINT, 'Realised interspecific competitor encounter rate (EPinter, #/s)'
;  PRINT, (EPinter[0:100])
; Consumption for each prey tROGe accounting for foraging in g in time step = 6min
  ; without competition********************* NO DENSITY-DEPENDENCE**************************
;  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;;  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds])))
;;  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds])))
;;  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds])))

  ; Use biomass for inter- and intra- specific interactions
  densPintra = ROGpbio[33, *]
  densPinter = ROGpbio[30, *] + ROGpbio[31, *] + ROGpbio[32, *] + ROGpbio[34, *]
  
  ; With low competition - Beddington-DeAngelis model*********************DENSITY-DEPENDENCE**************************
  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
;  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
;  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
;  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  ;PRINT, 'Consumption per prey (C, g/ts)'
  ;PRINT, C[*, 0:100]
  
;  ; With high competition - Crowley-Matin model
;  C[0, tds] = DOUBLE((Cons[0, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;;  C[6, tds] = DOUBLE((Cons[6, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;;  C[7, tds] = DOUBLE((Cons[7, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;;  C[8, tds] = DOUBLE((Cons[8, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C[*, 0:100]
;  PRINT, 'Volume searched (VS, L or m2 /s)'
;  PRINT, VS
; PRINT, 'densPintra'
; PRINT, densPintra[0:100]
; PRINT, 'densPinter'
; PRINT, densPinter[0:100]
  TotCts[tds]= DOUBLE(C[0,tds] + C[1, tds] + C[2, tds] + C[3, tds] + C[4, tds] + C[5, tds]); + C[6, tds] + C[7, tds] + C[8, tds])
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, (TotCts)

  Cratio = FLTARR(m, nROG); PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
  TotCtsNZ = WHERE(TotCts NE 0., TotCtsNZcount)
  IF TotCtsNZcount GT 0. THEN BEGIN
    Cratio[0, TotCtsNZ] = DOUBLE(C[0, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[1, TotCtsNZ] = DOUBLE(C[1, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[2, TotCtsNZ] = DOUBLE(C[2, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[3, TotCtsNZ] = DOUBLE(C[3, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[4, TotCtsNZ] = DOUBLE(C[4, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[5, TotCtsNZ] = DOUBLE(C[5, TotCtsNZ] / TotCts[TotCtsNZ])
    ;Cratio[6, TotCtsNZ] = DOUBLE(C[6, TotCtsNZ] / TotCts[TotCtsNZ])
    ;Cratio[7, TotCtsNZ] = DOUBLE(C[7, TotCtsNZ] / TotCts[TotCtsNZ])
    ;Cratio[8, TotCtsNZ] = DOUBLE(C[8, TotCtsNZ] / TotCts[TotCtsNZ])
  ENDIF
  ;PRINT, 'Cratio'
  ;PRINT, Cratio

;; Consumption with temperature and DO effects
;  C[0, tds] = DOUBLE(C[0, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[1, tds] = DOUBLE(C[1, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[2, tds] = DOUBLE(C[2, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[3, tds] = DOUBLE(C[3, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[4, tds] = DOUBLE(C[4, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[5, tds] = DOUBLE(C[5, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[6, tds] = DOUBLE(C[6, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[7, tds] = DOUBLE(C[7, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  C[8, tds] = DOUBLE(C[8, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey tROGe
;  PRINT, 'Consumption with temp and DO effects'
;  PRINT, C
  ;potst[tds] = double(C[0,tds] + C[1,tds] + C[2,tds] + C[3,tds] + C[4,tds] + C[5,tds] + prestom[tds])
  ;possible cons + what is left in the stomach
  
; Determine potential stomach weight in g after current time step = 6 min
  PotSt = FLTARR(m, nROG)
  TotPotSt = FLTARR(nROG)
  Potst[0, tds] = C[0, tds] + CAftDig0[tds]
  Potst[1, tds] = C[1, tds] + CAftDig1[tds]
  Potst[2, tds] = C[2, tds] + CAftDig2[tds]
  Potst[3, tds] = C[3, tds] + CAftDig3[tds]
  Potst[4, tds] = C[4, tds] + CAftDig4[tds]
  Potst[5, tds] = C[5, tds] + CAftDig5[tds]
;  Potst[6, tds] = C[6, tds] + CAftDig6[tds]
;  Potst[7, tds] = C[7, tds] + CAftDig7[tds]
;  Potst[8, tds] = C[8, tds] + CAftDig8[tds]
  TotPotSt[tds] = DOUBLE(PotSt[0,tds] + Potst[1, tds] + potst[2, tds] + potst[3, tds] + potst[4, tds] + potst[5, tds]); $
  ;+ potst[6, tds] + potst[7, tds] + potst[8, tds]); + prestom[tds])
  ;possible cons + what is left in the stomach
;  PRINT, 'Potential stomach weight per prey (g)'
;  PRINT, Potst
;  PRINT, 'Potential total stomach weight (g)'
;  PRINT, TotPotSt
  
; Check if potential stomach weight is greater than stomach capacity
  nstom = FLTARR(nROG)
  Premove = FLTARR(nROG)
  TotCAftDig = FLTARR(nROG)
  RemCAftDig = FLTARR(nROG)
  RemCAftDig0 = FLTARR(nROG)
  RemCAftDig1 = FLTARR(nROG)
  RemCAftDig2 = FLTARR(nROG)
  RemCAftDig3 = FLTARR(nROG)
  RemCAftDig4 = FLTARR(nROG)
  RemCAftDig5 = FLTARR(nROG)
;  PRINT, 'Stomach capacity'
;  PRINT, TRANSPOSE(stcap)
  PT = WHERE(TotPotSt LT StCap, PTcount, complement = P, ncomplement = Pcount)
  ; If less than stomach capacity, fish keep its potential
  PRINT, 'Number of fish with overconsumption =', Pcount
  IF (PTcount GT 0.) THEN Nstom[PT] = TotPotSt[PT]; no change in consumption
  ; If more than stomach capacity, fish can eat to capacity
  IF (Pcount GT 0.0) THEN BEGIN
    ; AND need to remove biomass from diet so that nstom = stcap
    Premove[P] = DOUBLE(stcap[P] / TotPotSt[P])
;    PRINT, 'Premove'
;    PRINT, (premove)

    ; Need to remove additional amount for previously undigested food
    TotCAftDig[P] = CAftDig0[p] + CAftDig1[p] + CAftDig2[p] + CAftDig3[p] + CAftDig4[p] + CAftDig5[p]; + CAftDig6[p] + CAftDig7[p] + CAftDig8[p]
    RemCAftDig[P] = TotCAftDig[P] - TotCAftDig[P] * Premove[P]; ***SUBSCRIPT P ONLY****
    RemCAftDig0[P] = RemCAftDig[P] * Cratio[0, P]
    RemCAftDig1[P] = RemCAftDig[P] * Cratio[1, P]
    RemCAftDig2[P] = RemCAftDig[P] * Cratio[2, P]
    RemCAftDig3[P] = RemCAftDig[P] * Cratio[3, P]
    RemCAftDig4[P] = RemCAftDig[P] * Cratio[4, P]
    RemCAftDig5[P] = RemCAftDig[P] * Cratio[5, P]  
    ;RemCAftDig6 = RemCAftDig * Cratio[6, P]
    ;RemCAftDig7 = RemCAftDig * Cratio[7, P]
    ;RemCAftDig8 = RemCAftDig * Cratio[8, P]
    
    C[0, p] = DOUBLE(Premove[P] * C[0, p] - RemCAftDig0[P]) ;new g of prey after removing specific prey item...
    C[1, p] = DOUBLE(Premove[P] * C[1, p] - RemCAftDig1[P])
    C[2, p] = DOUBLE(Premove[P] * C[2, p] - RemCAftDig2[P])
    C[3, p] = DOUBLE(Premove[P] * C[3, p] - RemCAftDig3[P])
    C[4, p] = DOUBLE(Premove[P] * C[4, p] - RemCAftDig4[P])
    C[5, p] = DOUBLE(Premove[P] * C[5, p] - RemCAftDig5[P])
    ;C[6, p] = DOUBLE(Premove * C[6, p] - RemCAftDig6)
    ;C[7, p] = DOUBLE(Premove * C[7, p] - RemCAftDig7)
    ;C[8, p] = DOUBLE(Premove * C[8, p] - RemCAftDig8)

    TotCts[P]= DOUBLE(C[0,P] + C[1, P] + C[2, P] + C[3, P] + C[4, P] + C[5, P]); + C[6, P] + C[7, P] + C[8, P])
;    PRINT, 'Consumption per prey after adjusting for overconsumption (C, g/ts)'
;    PRINT, TRANSPOSE(C)
;    PRINT, 'Total consumption after adjusting for overconsumption (TotCts, g/ts)'
;    PRINT, (TotCts)
    Potst[0, p] = C[0, P] + CAftDig0[P]
    Potst[1, p] = C[1, P] + CAftDig1[P]
    Potst[2, p] = C[2, P] + CAftDig2[P]
    Potst[3, P] = C[3, P] + CAftDig3[P]
    Potst[4, P] = C[4, P] + CAftDig4[P]
    Potst[5, P] = C[5, P] + CAftDig5[P]
;    Potst[6, P] = C[6, P] + CAftDig6[P]
;    Potst[7, P] = C[7, P] + CAftDig7[P]
;    Potst[8, P] = C[8, P] + CAftDig8[P]
    TotPotSt[P] = DOUBLE(PotSt[0,P] + Potst[1, P] + potst[2, P] + potst[3, P] + potst[4, P] + potst[5, P]); $
    ;+ potst[6, P] + potst[7, P] + potst[8, P]);
    Nstom[P] = TotPotSt[P]
;    PRINT, 'Potential stomach weight per prey (g) AFTER adjusting for overconsumption'
;    PRINT, Potst
;    PRINT, 'Potential total stomach weight (g) AFTER adjusting for overconsumption'
;    PRINT, TotPotSt
  ENDIF
;  PRINT, 'New stomach content (g) before digestion'
;  PRINT, Nstom
  Czoopl1 = C[0, *]
  Czoopl2 = C[1, *]
  Czoopl3 = C[2, *]
  ;PRINT, 'Czoopl =', Czoopl1

; Temperature-dependent digestion and gut evacuation
 ; should be in GROWTH SUBROUTINE?(i.e., Eges)
  ;Gut evacuation rate, R, for yellow perch based on Eurasian perch from Durbin et al. 1983
  ROGGutEvacR = 0.0182 * EXP(0.14 * Temp) / 60.0 * fDOfc2; in g/min acclimated temperature-dependent
;  PRINT, 'ROGGutEvacR'
;  PRINT, TRANSPOSE(ROGGutEvacR)

  ; Food digeseted over time step = 6 min
;  PRINT, 'Prey specific stomach content before Digestion'
;  PRINT, PotSt[*, tds]
  ; Digestion and evacuation of each prey from current and previous ts
  ;newstomAFTdig = prestom[*] * exp(-ROGGutEvacR * ts) + ((newstom - prestom[*]) / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[0, tds] = (CAftDig0[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[0, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[0,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[1, tds] = (CAftDig1[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[1, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[1,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[2, tds] = (CAftDig2[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[2, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[2,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[3, tds] = (CAftDig3[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[3, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[3,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[4, tds] = (CAftDig4[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[4, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[4,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[5, tds] = (CAftDig5[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[5, tds]) * EXP(-ROGGutEvacR[tds] * ts)); + (C[5,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
;  CAftDig[6, tds] = (CAftDig6[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[6, tds]) * EXP(-ROGGutEvacR[tds] * ts));
;  CAftDig[7, tds] = (CAftDig7[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[7, tds]) * EXP(-ROGGutEvacR[tds] * ts));
;  CAftDig[8, tds] = (CAftDig8[tds] * EXP(-ROGGutEvacR[tds] * ts) + (C[8, tds]) * EXP(-ROGGutEvacR[tds] * ts));
  
  ; DigestedFood = Nstom - NstomAFTdig; per time step = 6min
  DigestedFood[0, tds] = DOUBLE(potst[0, tds] - CAftDig[0, tds])
  DigestedFood[1, tds] = DOUBLE(potst[1, tds] - CAftDig[1, tds])
  DigestedFood[2, tds] = DOUBLE(potst[2, tds] - CAftDig[2, tds])
  DigestedFood[3, tds] = DOUBLE(potst[3, tds] - CAftDig[3, tds])
  DigestedFood[4, tds] = DOUBLE(potst[4, tds] - CAftDig[4, tds])
  DigestedFood[5, tds] = DOUBLE(potst[5, tds] - CAftDig[5, tds])
;  DigestedFood[6, tds] = DOUBLE(potst[6, tds] - CAftDig[6, tds])
;  DigestedFood[7, tds] = DOUBLE(potst[7, tds] - CAftDig[7, tds])
;  DigestedFood[8, tds] = DOUBLE(potst[8, tds] - CAftDig[8, tds])

  ; Determine total non-digested stomach content in g after time step = 6 min
  PotStAftDig[tds] = DOUBLE(CAftDig[0, tds] + CAftDig[1, tds] + CAftDig[2, tds] + CAftDig[3, tds] + CAftDig[4, tds] + CAftDig[5, tds]); $
  ;+ CAftDig[6, tds] + CAftDig[7, tds] + CAftDig[8, tds])
  NewStom[tds] = (PotStAftDig[tds]); tds = TotCday < ROGcmx
  
  ; Determine daily cumulative food consumption 
  TotCday[tds] = (TotCday[tds] + TotCts[tds]) 
  TotC[0, tds] = C[0, tds] + TotC0[tds]
  TotC[1, tds] = C[1, tds] + TotC1[tds]
  TotC[2, tds] = C[2, tds] + TotC2[tds]
  TotC[3, tds] = C[3, tds] + TotC3[tds]
  TotC[4, tds] = C[4, tds] + TotC4[tds]
  TotC[5, tds] = C[5, tds] + TotC5[tds]
;  TotC[6, tds] = C[6, tds] + TotC6[tds]
;  TotC[7, tds] = C[7, tds] + TotC7[tds]
;  TotC[8, tds] = C[8, tds] + TotC8[tds]
;  PRINT, 'Total daily cumulative consumption (TotCday, g/day)'
;  PRINT, TRANSPOSE(totcday)
;  PRINT, 'Daily cumulative consumption for each prey (TotC, g/day)'
;  PRINT, TRANSPOSE(TotC)
  
  ENDIF
;ENDIF;****************************************************************************************************************************

;*********If the previous stomach content is larger than CMAX -> No consumption - digestion/evacuation only************************
PRINT, 'Number of fish with full stomach =', dcount
IF (dcount GT 0.0)  THEN BEGIN; dcount = totcday > ROGcmx 
; OR ((iHour LT 4L) AND (iHour GT 15L)) OR ((iHour LT 4L) AND (iHour GT 20L))
  ; Digestion and evacuation for each prey item
  ROGGutEvacR = 0.0182 * EXP(0.14 * Temp) / 60.0 * fDOfc2 ;in g/min temperature-dependent
  CAftDig[0, d] = DOUBLE(CAftDig[0, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[0,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[1, d] = DOUBLE(CAftDig[1, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[1,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[2, d] = DOUBLE(CAftDig[2, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[2,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[3, d] = DOUBLE(CAftDig[3, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[3,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[4, d] = DOUBLE(CAftDig[4, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[4,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
  CAftDig[5, d] = DOUBLE(CAftDig[5, d] * EXP(-ROGGutEvacR[d] * ts)); + (C[5,*] / ROGGutEvacR) * (1 - exp(-ROGGutEvacR * ts))
;  CAftDig[6, d] = DOUBLE(CAftDig[6, d] * EXP(-ROGGutEvacR[d] * ts))
;  CAftDig[7, d] = DOUBLE(CAftDig[7, d] * EXP(-ROGGutEvacR[d] * ts))
;  CAftDig[8, d] = DOUBLE(CAftDig[8, d] * EXP(-ROGGutEvacR[d] * ts))
;  print, 'Undigested pret item (CAftDig, g)'
;  PRINT, TRANSPOSE(CAftDig[*, d])
  PotStAftDig[d] = DOUBLE(CAftDig[0,d] + CAftDig[1,d] + CAftDig[2,d] + CAftDig[3,d] + CAftDig[4,d] + CAftDig[5,d]); $
  ;+ CAftDig[6,d] + CAftDig[7,d] + CAftDig[8,d])
  NewStom[d] = PotStAftDig[d];
  
  DigestedFood[0,d] = DOUBLE(CAftDig0[d] - CAftDig[0,d])
  DigestedFood[1,d] = DOUBLE(CAftDig1[d] - CAftDig[1,d])
  DigestedFood[2,d] = DOUBLE(CAftDig2[d] - CAftDig[2,d])
  DigestedFood[3,d] = DOUBLE(CAftDig3[d] - CAftDig[3,d])
  DigestedFood[4,d] = DOUBLE(CAftDig4[d] - CAftDig[4,d])
  DigestedFood[5,d] = DOUBLE(CAftDig5[d] - CAftDig[5,d])
;  DigestedFood[6,d] = DOUBLE(CAftDig6[d] - CAftDig[6,d])
;  DigestedFood[7,d] = DOUBLE(CAftDig7[d] - CAftDig[7,d])
;  DigestedFood[8,d] = DOUBLE(CAftDig8[d] - CAftDig[8,d])

  TotCday[d] = TotCday[d]; No consumption during this time step
  TotC[0, d] = TotC0[d]
  TotC[1, d] = TotC1[d]
  TotC[2, d] = TotC2[d]
  TotC[3, d] = TotC3[d]
  TotC[4, d] = TotC4[d]
  TotC[5, d] = TotC5[d]
;  TotC[6, d] = TotC6[d]
;  TotC[7, d] = TotC7[d]
;  TotC[8, d] = TotC8[d]
ENDIF;****************************************************************************************************************************

;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, total(DigestedFood[0:5, 0:100],1)
;PRINT, 'Undigested prey itROG (CAftDig, g)'
;PRINT, TOTAL(CAftDig[*, 0:100],1)  
;PRINT, 'Total non-digested stomach content (potstAftDig, g)'
;PRINT, (potstAftDig[*])
;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Total daily cumulative consumption (g/day)'
;PRINT, (TotCday[*])

;VerSize = (Grid2D[3, ROG[13, *]]/20L)*1000L; individual cell depth in mm, there are always 20 vertical cells.
;  ;CellDepth = (VerSize[*]/1000)
;  ;PRINT, 'Cell depth (m)'
;  ;PRINT, CellDepth
;  ZooplBio1 = (ROG[15,*])*4000000000D*(VerSize[*]/1000.); g per cell of 2km x 2km x depth from g/L 
;  ZooplBio2 = (ROG[16,*])*4000000000D*(VerSize[*]/1000.); g per cell of 2km x 2km x depth from g/L 
;  ZooplBio3 = (ROG[17,*])*4000000000D*(VerSize[*]/1000.); g per cell of 2km x 2km x depth from g/L 
;  ZooplBioAft1 = ZooplBio1 - C[0,*]*ROG[0,*]; Czoopl1 = g per individual
;  ZooplBioAft2 = ZooplBio2 - C[1,*]*ROG[0,*];
;  ZooplBioAft3 = ZooplBio3 - C[2,*]*ROG[0,*];
;  PRINT, 'ZooplBio2'
;  PRINT, TRANSPOSE(ZooplBio2)
;  PRINT, 'Czoopl2*ROG[0,*]'
;  PRINT, TRANSPOSE(C[2,*]*ROG[0,*])
;  PRINT, 'ZooplBioAft2'
;  PRINT, TRANSPOSE(ZooplBioAft2)

consumption = FLTARR(50, nROG)
; Digested food itROG used for growth subroutine
consumption[0,*] = DigestedFood[0,*]; g digested for each prey tROGe
consumption[1,*] = DigestedFood[1,*]; g digested for each prey tROGe
consumption[2,*] = DigestedFood[2,*]; g digested for each prey tROGe
consumption[3,*] = DigestedFood[3,*]; g digested for each prey tROGe
consumption[4,*] = DigestedFood[4,*]; g digested for each prey tROGe
consumption[5,*] = DigestedFood[5,*]; g digested for each prey tROGe
;consumption[6,*] = DigestedFood[6,*]; g digested for each prey tROGe
;consumption[7,*] = DigestedFood[7,*]; g digested for each prey tROGe
;consumption[8,*] = DigestedFood[8,*]; g digested for each prey tROGe

consumption[9,*] = NewStom[*]; new weight of stomach content
consumption[10,*] = TotCday[*]; new total cumulative consumption after time step (= 6 min) need to be updated every 24h

; undigested food in the stomach carried over to the next time step
consumption[11,*] = CAftDig[0,*]; + CAftDig6[0,*]
consumption[12,*] = CAftDig[1,*]; + CAftDig6[1,*]
consumption[13,*] = CAftDig[2,*]; + CAftDig6[2,*]
consumption[14,*] = CAftDig[3,*]; + CAftDig6[3,*]
consumption[15,*] = CAftDig[4,*]; + CAftDig6[4,*]
consumption[16,*] = CAftDig[5,*]; + CAftDig6[5,*]
;consumption[17,*] = CAftDig[6,*]; + CAftDig6[3,*]
;consumption[18,*] = CAftDig[7,*]; + CAftDig6[4,*]
;consumption[19,*] = CAftDig[8,*]; + CAftDig6[5,*]

; the amount of each prey consumed per time step (= 6 min) 
consumption[20,*] = C[0,*]; 
consumption[21,*] = C[1,*];
consumption[22,*] = C[2,*]; 
consumption[23,*] = C[3,*]; 
consumption[24,*] = C[4,*]; 
consumption[25,*] = C[5,*]; 
;consumption[26,*] = C[6,*]; 
;consumption[27,*] = C[7,*]; 
;consumption[28,*] = C[8,*];

; total amount of prey consumed after time step (= 6 min) need to be updated every 24h
consumption[29,*] = TotC[0,*]; total amount of daily consumption of microzooplankton
consumption[30,*] = TotC[1,*]; total amount of daily consumption of microzooplankton
consumption[31,*] = TotC[2,*]; total amount of daily consumption of microzooplankton
consumption[32,*] = TotC[3,*]; total amount of daily consumption of microzooplankton
consumption[33,*] = TotC[4,*]; total amount of daily consumption of microzooplankton
consumption[34,*] = TotC[5,*]; total amount of daily consumption of microzooplankton
;consumption[35,*] = TotC[6,*]; total amount of daily consumption of microzooplankton
;consumption[36,*] = TotC[7,*]; total amount of daily consumption of microzooplankton
;consumption[37,*] = TotC[8,*]; total amount of daily consumption of microzooplankton

consumption[38,*] = C[0,*]+C[1,*]+C[2,*]; Total zooplankton consumption by superindividuals (x N)
;consumption[39,*] = ZooplBioAft1+ZooplBioAft2+ZooplBioAft3; Total zooplankton available in each cell AFTER fish feeding

; the NUMBER of each prey consumed per time step (= 6 min) 
Non0Prey0 = WHERE((PW[0, *] GT 0.), Non0Prey0count)
IF Non0Prey0count GT 0. THEN consumption[40, Non0Prey0] = CEIL(C[0, Non0Prey0]/PW[0, Non0Prey0]);
Non0Prey1 = WHERE((PW[1, *] GT 0.), Non0Prey1count)
IF Non0Prey1count GT 0. THEN consumption[41, Non0Prey1] = CEIL(C[1, Non0Prey1]/PW[1, Non0Prey1]);
Non0Prey2 = WHERE((PW[2, *] GT 0.), Non0Prey2count)
IF Non0Prey2count GT 0. THEN consumption[42, Non0Prey2] = CEIL(C[2, Non0Prey2]/PW[2, Non0Prey2]); 
Non0Prey3 = WHERE((PW[3, *] GT 0.), Non0Prey3count)
IF Non0Prey3count GT 0. THEN consumption[43, Non0Prey3] = CEIL(C[3, Non0Prey3]/PW[3, Non0Prey3]); 
Non0Prey4 = WHERE((PW[4, *] GT 0.), Non0Prey4count)
IF Non0Prey4count GT 0. THEN consumption[44, Non0Prey4] = CEIL(C[4, Non0Prey4]/PW[4, Non0Prey4]); 
Non0Prey5 = WHERE((PW[5, *] GT 0.), Non0Prey5count)
IF Non0Prey5count GT 0. THEN consumption[45, Non0Prey5] = CEIL(C[5, Non0Prey5]/PW[5, Non0Prey5]); 
;Non0Prey6 = WHERE((PW[6, *] GT 0.), Non0Prey6count)
;IF Non0Prey6count GT 0. THEN consumption[46, Non0Prey6] = CEIL(C[6, Non0Prey6]/PW[6, Non0Prey6]); 
;Non0Prey7 = WHERE((PW[7, *] GT 0.), Non0Prey7count)
;IF Non0Prey7count GT 0. THEN consumption[47, Non0Prey7] = CEIL(C[7, Non0Prey7]/PW[7, Non0Prey7]); 
;Non0Prey8 = WHERE((PW[8, *] GT 0.), Non0Prey8count)
;IF Non0Prey8count GT 0. THEN consumption[48, Non0Prey8] = CEIL(C[8, Non0Prey8]/PW[8, Non0Prey8]);

; Stomach fullness
consumption[49, *] = NewStom / (stcap) * 100.; StomFull

;PRINT, 'C (g) per time step'
;PRINT, 'Digested microzooplankton (g)'
;PRINT, TRANSPOSE(consumption[0,*])
;PRINT, 'Digested small mesozooplankton (g)'
;PRINT, TRANSPOSE(consumption[1,*])
;PRINT, 'Digested large mesozooplankton (g)'
;PRINT, TRANSPOSE(consumption[2,*])
;PRINT, 'Digested chironomids (g)'
;PRINT, TRANSPOSE(consumption[3,*])
;PRINT, 'Digested invasive species (g)'
;PRINT, TRANSPOSE(consumption[4,*])
;PRINT, 'Digested yellow perch (g)'
;PRINT, TRANSPOSE(consumption[5,*])
;;PRINT, 'Digested emerald shiner (g)'
;;PRINT, TRANSPOSE(consumption[6,*])
;;PRINT, 'Digested rainbow smelt (g)'
;;PRINT, TRANSPOSE(consumption[7,*])
;;PRINT, 'Digested round goby (g)'
;;PRINT, TRANSPOSE(consumption[8,*])
;
;PRINT, 'C (g) stomach content'
;PRINT, TRANSPOSE(consumption[9,*])
;PRINT, 'C (g) total daily cumulative consumption'
;PRINT, TRANSPOSE(consumption[10,*])
;PRINT, 'C (g) daily cumulative consumption of microzooplankton'
;PRINT, TRANSPOSE(consumption[29,*])
;PRINT, 'C (g) daily cumulative consumption of small mesozooplankton'
;PRINT, TRANSPOSE(consumption[30,*])
;PRINT, 'C (g) daily cumulative consumption of large mesozooplankton'
;PRINT, TRANSPOSE(consumption[31,*])
;PRINT, 'C (g) daily cumulative consumption of chironomids'
;PRINT, TRANSPOSE(consumption[32,*])
;PRINT, 'C (g) daily cumulative consumption of invasive species'
;PRINT, TRANSPOSE(consumption[33,*])
;PRINT, 'C (g) daily cumulative consumption of yellow perch'
;PRINT, TRANSPOSE(consumption[34,*])
;;PRINT, 'C (g) daily cumulative consumption of emerald shiner'
;;PRINT, TRANSPOSE(consumption[35,*])
;;PRINT, 'C (g) daily cumulative consumption of rainbow smelt'
;;PRINT, TRANSPOSE(consumption[36,*])
;;PRINT, 'C (g) daily cumulative consumption of round goby'
;;PRINT, TRANSPOSE(consumption[37,*])
;
;PRINT, 'C (g) undigested rotifers'
;PRINT, TRANSPOSE(consumption[11,*])
;PRINT, 'C (g) undigested copepods'
;PRINT, TRANSPOSE(consumption[12,*]) 
;PRINT, 'C (g) undigested cladocerans'
;PRINT, TRANSPOSE(consumption[13,*])
;PRINT, 'C (g) undigested chironomids'
;PRINT, TRANSPOSE(consumption[14,*])
;PRINT, 'C (g) undigested bythotrephes'
;PRINT, TRANSPOSE(consumption[15,*])
;PRINT, 'C (g) undigested yellow perch'
;PRINT, TRANSPOSE(consumption[16,*])
;;PRINT, 'C (g) undigested emerald shiner'
;;PRINT, TRANSPOSE(consumption[17,*])
;;PRINT, 'C (g) undigested rainbow smelt'
;;PRINT, TRANSPOSE(consumption[18,*])
;;PRINT, 'C (g) undigested round goby'
;;PRINT, TRANSPOSE(consumption[19,*])
;;PRINT, 'C (g) All'
;;PRINT, consumption 
;
;PRINT, 'Number of individuals per superindividual'
;PRINT, TRANSPOSE(ROG[0, *])
;PRINT, 'Total zooplankton consumption by superindividuals (x N)'
;PRINT, TRANSPOSE(consumption[38,*])
;PRINT, 'Total zooplankton available in each cell'
;PRINT, TRANSPOSE(ZooplBio1+ZooplBio2+ZooplBio3)
;PRINT, 'Total zooplankton available in each cell AFTER fish feeding'
;PRINT, TRANSPOSE(consumption[39,*])
;
;PRINT, 'Number of consumed microzooplankton'
;PRINT, TRANSPOSE(consumption[40,*])
;PRINT, 'Number of consumed small mesozooplankton'
;PRINT, TRANSPOSE(consumption[41,*])
;PRINT, 'Number of consumed large mesozooplankton'
;PRINT, TRANSPOSE(consumption[42,*])
;PRINT, 'Number of consumed chironomids'
;PRINT, TRANSPOSE(consumption[43,*])
;PRINT, 'Number of consumed invasive species'
;PRINT, TRANSPOSE(consumption[44,*])
;PRINT, 'Number of consumed yellow perch'
;PRINT, TRANSPOSE(consumption[45,*])
;;PRINT, 'Number of consumed emerald shiner'
;;PRINT, TRANSPOSE(consumption[46,*])
;;PRINT, 'Number of consumed rainbow smelt'
;;PRINT, TRANSPOSE(consumption[47,*])
;;PRINT, 'Number of consumed round goby'
;;PRINT, TRANSPOSE(consumption[48,*])

;FOR TEST ONLY******************************
;PRINT, 'density =', dens
;PRINT, 'pbio =', pbio
;PRINT, 'ER =', ER
;PRINT, 'E =', E
;PRINT, 'NumP =', NumP
;PRINT, 'FISHPREY', FISHPREY[*, ROG[14,*]]
;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:499] 
;PRINT, 'PW'
;PRINT, PW 
;PRINT, 'C'
;PRINT, C
;PRINT, 'ROGpbio'
;PRINT, ROGpbio
;PRINT, 'ROG14'
;PRINT, TRANSPOSE(ROG[14, *])
;PRINT, 'ROG14'
;PRINT, TRANSPOSE(ROG[14, *])
;PRINT, 'ROG14'
;PRINT, TRANSPOSE(ROG[14, *])
;****************************************

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Round Goby Foraging Ends Here'
RETURN, Consumption; TURN OFF WHEN TESTING
END