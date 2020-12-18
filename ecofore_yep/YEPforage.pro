FUNCTION YEPForage, iHour, Length, Temp, Light, YPpbio, YPcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
CAftDig6, CAftDig7, CAftDig8, StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, TotC6, TotC7, TotC8, ts, nYP, DOa, $
DOacclC, DOcritC, YP, Grid2D, NewInput10, TotBenBio
; This function calculates total consumption (g) by yellow perch

PRINT, 'YEPForage Begins Here'
tstart = SYSTIME(/seconds)


tss = ts*60.; time step in secound
m = 9; the number of prey types
NewStom = FLTARR(nYP); the amount of food in stomach
TotC = FLTARR(m, nYP); daily cumulative consumption of each prey item 
TotCts = FLTARR(nYP); total daily cumulative consumption 
DigestedFood = FLTARR(m, nYP); the amount of digested prey used for growth
PotStAftDig = FLTARR(nYP); potential stomach content after digestion 
C = FLTARR(m, nYP); the amount of each prey item consumed per time step
CAftDig = FLTARR(m ,nYP); the amoung of each prey item digested
;CAftDig[0,*] = CAftDig0[*]
;CAftDig[1,*] = CAftDig1[*]
;CAftDig[2,*] = CAftDig2[*]
;CAftDig[3,*] = CAftDig3[*]
;CAftDig[4,*] = CAftDig4[*]
;CAftDig[5,*] = CAftDig5[*]
;CAftDig[6,*] = CAftDig6[*]
;CAftDig[7,*] = CAftDig7[*]
;CAftDig[8,*] = CAftDig8[*]
;PRINT, 'CAftDig'
;PRINT, CAftDig[0:8,*]

;PRINT, 'TotCday'
;PRINT, TRANSPOSE(TotCday)
;PRINT, 'YPcmx'
;PRINT, (YPcmx)
;PRINT, 'Previous stomach content (PreStom)'
;PRINT, TRANSPOSE(PreStom)
;PRINT, 'Stomach Capacity (StCap)'
;PRINT, TRANSPOSE(StCap)

; Determine prey characteristics for each prey type (m)
; Prey length (mm)
PL = FLTARR(m+1, nYP)
PL[0, *] = RANDOMU(seed, nYP)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nYP)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nYP)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nYP)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nYP)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm
PL[5, *] = YPpbio[6, *]; length for yellow perch in mm 
PL[6, *] = YPpbio[10, *]; length for emerald shiner in mm 
PL[7, *] = YPpbio[14, *]; length for rainbow smelt in mm 
PL[8, *] = YPpbio[18, *]; length for round goby in mm 
PL[9, *] = YPpbio[22, *]; length for WALLEYE in mm 
;PRINT, 'Prey length (PL, mm)'
;PRINT, PL

; Prey individual weight (g, wet)
;**********NEED TO LENGTH-WEIGHT REALTIONSHIPS FOR PREY**********
PW = FLTARR(m+1, nYP); weight of each prey type
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.0; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.0; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.0; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.0; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet
PW[5, *] = YPpbio[7, *];
PW[6, *] = YPpbio[11, *];
PW[7, *] = YPpbio[15, *];
PW[8, *] = YPpbio[19, *];
PW[9, *] = YPpbio[23, *];
;PRINT, 'Prey weight (PW, g wet)'
;PRINT, PW

; Convert prey biomass (g/L or m^2) into numbers/L or /m^2
dens = FLTARR(m+1, nYP)
dens[0,*] = YPpbio[0,*] / Pw[0,*]; for microzooplankton 
dens[1,*] = YPpbio[1,*] / Pw[1,*]; for small mesozooplankton
dens[2,*] = YPpbio[2,*] / Pw[2,*]; for large mesozooplankton

pbio3 = WHERE(YPpbio[3,*] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
IF pbio3count GT 0.0 THEN dens[3, pbio3] = YPpbio[3, pbio3] / Pw[3,pbio3] ELSE dens[3, pbio3c] = 0.0; for chironmoid

pbio4 = WHERE(YPpbio[4,*] GT 0.0, pbio4count, complement = pbio4c, ncomplement = pbio4ccount)
IF pbio4count GT 0.0 THEN dens[4, pbio4] = YPpbio[4, pbio4] / Pw[4,pbio4] ELSE dens[4, pbio4c] = 0.0; for invasive species 

pbio5 = WHERE(YPpbio[8,*] GT 0.0 AND PW[5, *] GT 0.0, pbio5count, complement = pbio5c, ncomplement = pbio5ccount)
IF pbio5count GT 0.0 THEN dens[5, pbio5] = YPpbio[8, pbio5] / Pw[5,pbio5] ELSE dens[5, pbio5c] = 0.0; for yellow perch
pbio6 = WHERE(YPpbio[12,*] GT 0.0 AND PW[6, *] GT 0.0, pbio6count, complement = pbio6c, ncomplement = pbio6ccount)
IF pbio6count GT 0.0 THEN dens[6, pbio6] = YPpbio[12, pbio6] / Pw[6,pbio6] ELSE dens[6, pbio6c] = 0.0; for emerald shiner
pbio7 = WHERE(YPpbio[16,*] GT 0.0 AND PW[7, *] GT 0.0, pbio7count, complement = pbio7c, ncomplement = pbio7ccount)
IF pbio7count GT 0.0 THEN dens[7, pbio7] = YPpbio[16, pbio7] / Pw[7,pbio7] ELSE dens[7, pbio7c] = 0.0; for rainbow smlet
pbio8 = WHERE(YPpbio[20,*] GT 0.0 AND PW[8, *] GT 0.0, pbio8count, complement = pbio8c, ncomplement = pbio8ccount)
IF pbio8count GT 0.0 THEN dens[8, pbio8] = YPpbio[20, pbio8] / Pw[8,pbio8] ELSE dens[8, pbio8c] = 0.0; for round goby
pbio9 = WHERE(YPpbio[24,*] GT 0.0 AND PW[9, *] GT 0.0, pbio9count, complement = pbio9c, ncomplement = pbio9ccount)
IF pbio9count GT 0.0 THEN dens[9, pbio9] = YPpbio[24, pbio9] / Pw[9, pbio9] ELSE dens[9, pbio9c] = 0.0; for Walleye
;PRINT, 'Prey density (dens)'
;PRINT, dens


; Determine if there is a hypoxia effect
fDOfc2 = FLTARR(nYP)
DOc = WHERE(2*DOcritC GE DOacclC, DOccount, complement = DOcc, ncomplement = DOcccount)
IF (DOccount GT 0.0) THEN fDOfc2[DOc] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclC[DOc] + (4. - 2*DOcritC[DOc])) + 6.5916))
IF (DOcccount GT 0.0) THEN fDOfc2[DOcc] = 1.0
PRINT, 'Number of fish in hypoxic cells (DOccount) =', DOccount


; Determine if food consumption has reached daily Cmax or full stomach in the previous time step
tds = WHERE((TotCday LT YPcmx) AND (PreStom LT Stcap), tdscount, complement = d, ncomplement = dcount)
PRINT, 'Number of fish with less than full stomach =', tdscount
;IF ((iHour GE 4L) AND (iHour LE 20L)) THEN BEGIN; restricting foraging within only daylight hours 5am to 9pm
IF (tdscount GT 0.0) THEN BEGIN; if fish hasn't consumed more than cmax in the previous time step

; Fish swimming speed calculation, S, in body lengths/sec
  SS = FLTARR(nYP)
  S = FLTARR(nYP)
  L = WHERE(Length LT 20., Lcount, complement = LL, ncomplement = LLcount)
  IF (Lcount GT 0.) THEN S[L] = 3.3354 * ALOG(length[L]) - 4.8758;(-0.0797 * (length[l] * length[l]) + 1.9294 * length[l] - 8.1761)
   ;SS equation based on data from Houde 1969 in body lengths/sec
  IF (LLcount GT 0.0) THEN S[LL] = (0.28 * Temp[LL] + 7.89) / (0.1 * Length[LL])
   ;in body lengths/sec; from Breck 1997 and Hergenrader and Hasler 1967 
  ; Converts SS into mm/s
  SS = (S * length)
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS

; Calculate predator size-based prey selectivity (Chesson's alpha) for each prey type
  Calpha = FLTARR(m, nYP); from Letcher et al. for zooplankton
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
 
  PL5 = WHERE(((PL[5, *] / Length) LT 0.2) AND (Length LE 80.0), PL5count, complement = PL5c, ncomplement = PL5ccount)
  PL5a = WHERE(((PL[5, *] / Length) GT 0.2) AND (Length LE 80.0), PL5acount, complement = PL5ac, ncomplement = PL5account)
  IF (Length80count GT 0.0) THEN Calpha[5, Length80] = 0.5
  IF (PL5count GT 0.0) THEN Calpha[5, PL5] = 0.25 
  IF (PL5acount GT 0.0) THEN Calpha[5, PL5a] = 0.00 ; for fish
  
  PL6 = WHERE(((PL[6, *] / length) LT 0.2) AND (Length LE 80.0), PL6count, complement = PL6c, ncomplement = PL6ccount)
  PL6a = WHERE(((PL[6, *] / Length) GT 0.2) AND (Length LE 80.0), PL6acount, complement = PL6ac, ncomplement = PL6account)
  IF (Length80count GT 0.0) THEN Calpha[6, Length80] = 0.5
  IF (PL6count GT 0.0) THEN Calpha[6, PL6] = 0.25 
  IF (PL6acount GT 0.0) THEN Calpha[6, PL6a] = 0.00 ; for fish
  
  PL7 = WHERE(((PL[7, *] / length) LT 0.2) AND (Length LE 80.0), PL7count, complement = PL7c, ncomplement = PL7ccount)
  PL7a = WHERE(((PL[7, *] / Length) GT 0.2) AND (Length LE 80.0), PL7acount, complement = PL7ac, ncomplement = PL7account)
  IF (Length80count GT 0.0) THEN Calpha[7, Length80] = 0.5
  IF (PL7count GT 0.0) THEN Calpha[7, PL7] = 0.25 
  IF (PL7acount GT 0.0) THEN Calpha[7, PL7a] = 0.00 ; for fish
  
  PL8 = WHERE(((PL[8, *] / length) LT 0.2) AND (Length LE 80.0), PL8count, complement = PL8c, ncomplement = PL8ccount)
  PL8a = WHERE(((PL[8, *] / Length) GT 0.2) AND (Length LE 80.0), PL8acount, complement = PL8ac, ncomplement = PL8account)
  IF (Length80count GT 0.0) THEN Calpha[8, Length80] = 0.5
  IF (PL8count GT 0.0) THEN Calpha[8, PL8] = 0.25 
  IF (PL8acount GT 0.0) THEN Calpha[8, PL8a] = 0.00 ; for fish
  
  ; Determine light effect
  ; LId (z,t) = LI(0,t)*exp(-z*k), light intensity at depth z time t with light extinction coefficient, k 
  ;litfac = FLTARR(nYP); a multiplication factor to include the effect of light intensity on RD
  litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.
  ;or R = 4.3 I*(0.1+I)^(-1) from Richmond et al., 2003
;  PRINT, 'Light intensity (lux)'
;  PRINT, TRANSPOSE(light)
;  PRINT, 'Light multiplication factor'
;  PRINT, litfac
  
  ; Determine foraging for each prey type present
  ; Calculate reactive distance in mm (from cm), Breck and Gitter. 1983.
  ;****Reactive distance may be used for the movement decision***********************
  
  ; Calculate alpha = fish length function in reactive distance, RD
  alphaDig = FLTARR(nYP)
  ;alpha = (0.0167 * exp(9.14 - 2.4 * alog(length) + 0.229 * (alog(length))^2));*!pi/180*(1/60)
  ; from Breck and Gitter, 1983
  ;ln(alpha) = 9.14 - 2.4*alog(length) + 0.229*(alog(length))^2
  alphaDig = EXP(9.14 - 2.4 * ALOG(length) + 0.229 * (ALOG(length))^2.0) / 60.0
  ;alphaRad = alphaDig*2*!PI/360

  RD = FLTARR(m+1, nYP); RD = 0.5*PL/tan(2.0*!PI*(1.0/360.0)*alphaDig/2.0)
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
  ; calculate reactive area in mm^2 for zoolplankton diet
  ; Include tubididty from Rose et al. 1996 for flounder
  ;IF RD LT 15 THEN Frd = 0.8 - 0.025 * RD
  ;IF RD GE 15 THEN Frd = 0.4  
  
  ; For larval fish (less than 20mm) that can perceive one half of the circle defined by reactive distance
  prop = FLTARR(nYP)
  Larva = WHERE(length LE 20.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
  IF (Larvacount GT 0.0) THEN prop[Larva] = 0.5
  IF (JuvAducount GT 0.0) THEN prop[JuvAdu] = 1.0 
;  PRINT, 'Proporton of reactive distance'
;  PRINT, prop
  
  ; Reactive area (mm2)
  RA = FLTARR(m+1, nYP)
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
  ;  RA = (RD * Frd)^2 * !PI * prop with turbidity
  ;  PRINT, 'Reactive area (RA, mm2)'
  ;  PRINT, RA

; Volume (zooplankton) or area (benthos) searched in L or m^2 PER SECOUND
;***CHANGE IN UNIT BECAUSE OF UNIT FOR DENSITY INPUTS
  VS = FLTARR(m+1, nYP); MULTIPLY BY 10.00^(-6.00) from mm3 to L OR mm2 to m2
  VS[0, *] = DOUBLE(SS * RA[0, *] * 10.0^(-6.0))
  VS[1, *] = DOUBLE(SS * RA[1, *] * 10.0^(-6.0))
  VS[2, *] = DOUBLE(SS * RA[2, *] * 10.0^(-6.0))
  VS[3, *] = DOUBLE(SS * 2.0 * RD[3, *] * SIN(!PI/3.0) * 10.0^(-6.0))
  ; Area for benthos from Breck 1993; VS[3,*] = SS * 2.0 * Frd * RD[3,*] with turbidity
  VS[4, *] = DOUBLE(SS * RA[4, *] * 10.0^(-6.0))
  VS[5, *] = DOUBLE(SS * RA[5, *] * 10.0^(-6.0))
  VS[6, *] = DOUBLE(SS * RA[6, *] * 10.0^(-6.0))
  VS[7, *] = DOUBLE(SS * RA[7, *] * 10.0^(-6.0))
  VS[8, *] = DOUBLE(SS * RA[8, *] * 10.0^(-6.0))
  VS[9, *] = DOUBLE(SS * RA[9, *] * 10.0^(-6.0))  
  
  ; Determine if fish dive into the hypoxic bottom cell
  ;VerSize = FLTARR(nYP)
  TimeVerMig = FLTARR(nYP)
  ;****IF zooplankton Calpha < benthic Calpha AND cell DO < DOcrit******-> Conditional diving
  BenFish = WHERE(Calpha[3, *] GT 0., BenFishcount)
  ;PRINT, 'Location of benthivore (3D Cell ID)'
  ;PRINT,  (BenFish)
  
  VerLoc = YP[12, *]; a current vertical location of fish
  HorID = YP[13, *]; horizontal cell ID
  HypoHypo = NewInput10[((20L - VerLoc) + YP[14, *])]; DO level of the bottom cell with the same horizontal location
  ;PRINT, 'Bottom cell DO level'
  ;PRINT, TRANSPOSE(HypoHypo)
  
  HypoHypoDO = WHERE(2*DOcritC GE HypoHypo, HypoHypoDOcount, complement = HypoDO, ncomplement = HypoHypoDOcount)
  ;PRINT, 'DOcrit FOR FEEDING/DIGESTION'
  ;PRINT, TRANSPOSE(2*DOcritC)
  PRINT, 'Number of fish in hypoxic/stressful bottom cells =', HypoHypoDOcount
  VerSize = (Grid2D[3, YP[13, *]]/20.)*1000.; individual cell depth in mm, there are always 20 vertical cells.
  TimeVerMig[*] = VerSize * (20L - VerLoc)/SS * 2. ; in s, time for fish to migrate down to the bottom cell and back up 
  ; ->>>>SS needs to be adjusted for vertical migration...
 
  ;IF TimeVerMIg*2 > 360L THEN fish will feed on zooplankton in the cell...
  NewHT4 = FLTARR(nYP)
  BenBio = FLTARR(nYP)
  BenNum = FLTARR(nYP)
  ;DivingFish = WHERE(((HT[4, *] + TimeVerMig[*]*2.) LT ts*60.), DivingFishcount, complement = NonDivingFish, ncomplement = NonDivingFishcount)
  DivingFish = WHERE(((VerLoc GE 15.) AND (VerLoc LT 20.) AND (Calpha[3, *] GT 0.)), DivingFishcount, complement = NonDivingFish, ncomplement = NonDivingFishcount)
  PRINT, 'Number of diving fish =', N_ELEMENTS(DivingFish)
  IF (DivingFishcount GT 0.) AND (HypoHypoDOcount GT 0.) THEN BEGIN
    BenBio[DivingFish] = TotBenBio[((20L - VerLoc[DivingFish]) + YP[14, DivingFish])]; Additional benthic biomass availability
    ;PRINT, 'Benthio availability for diving fish (g/m2)'
    ;PRINT, (BenBio[DivingFish])
    ;BenBioNZ = WHERE(BenBio GT 0., BenBioNZcount, complement = BenBioZ, ncomplement = BenBioZcount)
    ;IF BenBioNZcount GT 0. THEN BenNum[BenBioNZ] = BenBio[BenBioNZ] / Pw[3, BenBioNZ] ELSE BenNum[BenBioZ] = 0.0
    BenNum[DivingFish] = BenBio[DivingFish] / Pw[3, DivingFish]
    ;PRINT, 'FISH VERTICAL LOCATION CHECK'
    ;PRINT, TRANSPOSE(NewInput[2, ((20L - VerLoc) + YP[14, *])])
  ENDIF
  ;PRINT, 'Bentho individual weight (PW, g wet)'
  ;PRINT, TRANSPOSE(PW[3, DivingFish])
  ;PRINT, 'Additional benthic biomass for diving fish'
  ;PRINT, BenNum[DivingFish]
  ;PRINT, 'Vertical location of fish'
  ;PRINT, TRANSPOSE(VerLoc)
  ;PRINT, 'Horisontal ID', HorID
  ;PRINT, 'Depth cell size (mm)'
  ;PRINT, TRANSPOSE(VerSize)
  ;PRINT, 'Time required to migrate to the hypoxic hypolimnion (TimeVerMig, s)'
  ;PRINT, TimeVerMig
  ;*******************************************************************************
  
; Calculate potential encounter rate # PER SECOUND
;*****NEED to incorporate size-based inter-/intra-specific interactions and density dependence****
  ER = FLTARR(m, nYP)
  ;********"ROUND" or "CEIL"?***************
  ER[0, *] = CEIL(VS[0, *] * dens[0, *]); 
  ER[1, *] = CEIL(VS[1, *] * dens[1, *]); 
  ER[2, *] = CEIL(VS[2, *] * dens[2, *]); 
  ER[3, *] = CEIL(VS[3, *] * dens[3, *]); 
  ER[4, *] = CEIL(VS[4, *] * dens[4, *]); 
  ER[5, *] = CEIL(VS[5, *] * dens[5, *]); 
  ER[6, *] = CEIL(VS[6, *] * dens[6, *]); 
  ER[7, *] = CEIL(VS[7, *] * dens[7, *]); 
  ER[8, *] = CEIL(VS[8, *] * dens[8, *]); 
;  PRINT, 'Encounter rate (ER, #/s)'
;  PRINT, ER
  
  ERP = FLTARR(5, nYP); ENCOUNTER RATE FOR COMPETITORS
  ERP[0, *] = CEIL(VS[5, *] * dens[5, *]); yellow perch
  ERP[1, *] = CEIL(VS[6, *] * dens[6, *]); emerald shiner
  ERP[2, *] = CEIL(VS[7, *] * dens[7, *]); rainbow smelt
  ERP[3, *] = CEIL(VS[8, *] * dens[8, *]); round goby
  ERP[4, *] = CEIL(VS[9, *] * dens[9, *]); WALLEYE
  
  ERPintra = FLTARR(nYP)
  ERPinter = FLTARR(nYP)
  Age2plus = WHERE(YP[6, *] GE 2L, Age2pluscount, complement = Age01, ncomplement = Age01count)
  IF Age01count GT 0. THEN BEGIN
    ERPintra[Age01] = ERP[0, Age01] 
    ERPinter[Age01] = ERP[1, Age01] + ERP[2, Age01] + ERP[3, Age01] + ERP[4, Age01]
  ENDIF
  IF Age2pluscount GT 0. THEN BEGIN
    ERPintra[Age2plus] = ERP[0, Age2plus]; - ERPintra[Age01]
    ERPinter[Age2plus] = ERP[4, Age2plus]
  ENDIF
;  PRINT, 'Competitor encounter rate (ERP, #/s)'
;  PRINT, ERP
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  PRINT, TRANSPOSE(ERPintra)
;  PRINT, 'Interspecific competitor encounter rate (ERPinter, #/s)'
;  PRINT, TRANSPOSE(ERPinter)
  
  
; Calculate handling time in s
;*****HandLing time should not exceed ts
  ;**********Handling time parameters are calibrated for LARVAL YELLOW PERCH******
  L = TRANSPOSE(length)
  HT = FLTARR(m, nYP)
  SumHT = FLTARR(nYP) 
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
  IF (HT5ccount GT 0.0) THEN HT[5, HT5c] = HT[5, HT5c] 
  HT[6, *] = EXP(HTint * 10.^(HTsl * (PL[6, *]/L))) 
  HT6 = WHERE(HT[6, *] GT tss, HT6count, complement = HT6c, ncomplement = HT6ccount)
  IF (HT6count GT 0.0) THEN HT[6, HT6] = tss 
  IF (HT6ccount GT 0.0) THEN HT[6, HT6c] = HT[6, HT6c]
  HT[7, *] = EXP(HTint * 10.^(HTsl * (PL[7, *]/L))) 
  HT7 = WHERE(HT[7, *] GT tss, HT7count, complement = HT7c, ncomplement = HT7ccount)
  IF (HT7count GT 0.0) THEN HT[7, HT7] = tss 
  IF (HT7ccount GT 0.0) THEN HT[7, HT7c] = HT[7, HT7c]
  HT[8, *] = EXP(HTint * 10.^(HTsl * (PL[8, *]/l))) 
  HT8 = WHERE(HT[8, *] GT tss, HT8count, complement = HT8c, ncomplement = HT8ccount)
  IF (HT8count GT 0.0) THEN HT[8, HT8] = tss 
  IF (HT8ccount GT 0.0) THEN HT[8, HT8c] = HT[8, HT8c] 
;  PRINT, 'Expected handling time per prey (HT, s)'
;  PRINT, HT
  SumHT[*] = HT[0, *] + HT[1, *] + HT[2, *] + HT[3, *] + HT[4, *] + HT[5, *] + HT[6, *] + HT[7, *] + HT[8, *]
;  PRINT, 'Potential total handling time (SumHT, s)'
;  PRINT, SumHT

; *****For diving fish only, there is an additional handling time*****************
  PotNumDive = FLTARR(nYP)
  IF (DivingFishcount GT 0.) AND (HypoHypoDOcount GT 0.) THEN BEGIN
     NewHT4[DivingFish] = (HT[4, DivingFish] + TimeVerMig[DivingFish])     
     ;NewHT4NZ = WHERE(NewHT4 GT 0., NewHT4NZcount, complement = NewHT4Z, ncomplement = NewHT4Zcount)
     ;IF NewHT4NZcount GT 0. THEN PotNumDive[NewHT4NZ] = ts*60. / NewHT4[3, NewHT4NZ] ELSE PotNumDive[NewHT4Z] = 0.0
     ;PotNumDive[DivingFish] = ts*60. / NewHT4[DivingFish]
     
     HT[4, DivingFish] = NewHT4[DivingFish]
     dens[3, DivingFish] = dens[3, DivingFish] + BenNum[DivingFish]
  ENDIF
  ;PRINT, 'Potential number of diving to the bottom cell'
  ;PRINT, (PotNumDive[DivingFish])
  ;PRINT, 'New handling time for diving fish'
  ;PRINT, TRANSPOSE(HT[4, DivingFish])
  ;****ASSUME THAT FISH ARE EXPOSED TO 'HYPOXIA' FOR THE WHOLE HT************
  ;PRINT, 'New density of benthos for diving fish'
  ;PRINT, TRANSPOSE(dens[3, DivingFish])
;******************************************************************************
  

; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(nYP); probability of all prey atacked and captured
  t = FLTARR(m, nYP);  probability of each prey atacked and captured
  t[0,*] = (Calpha[0,*] * dens[0,*])
  t[1,*] = (Calpha[1,*] * dens[1,*])
  t[2,*] = (Calpha[2,*] * dens[2,*])
  t[3,*] = (Calpha[3,*] * dens[3,*])
  t[4,*] = (Calpha[4,*] * dens[4,*])
  t[5,*] = (Calpha[5,*] * dens[5,*])
  t[6,*] = (Calpha[6,*] * dens[6,*])
  t[7,*] = (Calpha[7,*] * dens[7,*])
  t[8,*] = (Calpha[8,*] * dens[8,*])
  TOT[*] = t[0,*] + t[1,*] + t[2,*] + t[3,*] + t[4,*] + t[5,*] + t[6,*] + t[7,*] + t[8,*]
  ;PRINT, 'Proportion of each prey item attcked and captured (t)'
  ;PRINT, t
  ;PRINT, 'Proportion of all prey items attcked and captured (tot)'
  ;PRINT, TOT

  Q = FLTARR(m, nYP); Probability of attack and capture
  TOTNZ = WHERE(TOT[*] GT 0.0, TOTNZcount, complement = TOTZ, ncomplement = TOTZcount)
  ; If no prey is available in a cell, Q = 0
  IF TOTNZcount GT 0.0 THEN BEGIN
    Q[0,TOTNZ] = DOUBLE(t[0,TOTNZ] / TOT[TOTNZ]) 
    Q[1,TOTNZ] = DOUBLE(t[1,TOTNZ] / TOT[TOTNZ])
    Q[2,TOTNZ] = DOUBLE(t[2,TOTNZ] / TOT[TOTNZ])
    Q[3,TOTNZ] = DOUBLE(t[3,TOTNZ] / TOT[TOTNZ])
    Q[4,TOTNZ] = DOUBLE(t[4,TOTNZ] / TOT[TOTNZ])
    Q[5,TOTNZ] = DOUBLE(t[5,TOTNZ] / TOT[TOTNZ])
    Q[6,TOTNZ] = DOUBLE(t[6,TOTNZ] / TOT[TOTNZ])
    Q[7,TOTNZ] = DOUBLE(t[7,TOTNZ] / TOT[TOTNZ])
    Q[8,TOTNZ] = DOUBLE(t[8,TOTNZ] / TOT[TOTNZ])
  ENDIF 
  IF TOTZcount GT 0.0 THEN BEGIN
    Q[0,TOTZ] = 0.0
    Q[1,TOTZ] = 0.0
    Q[2,TOTZ] = 0.0
    Q[3,TOTZ] = 0.0
    Q[4,TOTZ] = 0.0
    Q[5,TOTZ] = 0.0
    Q[6,TOTZ] = 0.0
    Q[7,TOTZ] = 0.0
    Q[8,TOTZ] = 0.0
  ENDIF

  
; Estimate the number of each prey consumed PER SECOUND
  E = FLTARR(m, nYP); encounter rate in individuals
  EPintra = FLTARR(nYP); encounter rate in individuals
  EPinter = FLTARR(nYP); encounter rate in individuals
  NumP = FLTARR(m, nYP); potential total number of prey consumed PER SECOUND
  FOR ind = 0L, nYP - 1L DO BEGIN ; for each superindividual
    ; Calculate realized encounter rate, E, based on a poisson distribution in individuals/ts
    IF ER[0, ind] GT 0. THEN E[0, ind] = RANDOMU(seed, POISSON = [ER[0, ind]], /double)
    IF ER[1, ind] GT 0. THEN E[1, ind] = RANDOMU(seed, POISSON = [ER[1, ind]], /double)
    IF ER[2, ind] GT 0. THEN E[2, ind] = RANDOMU(seed, POISSON = [ER[2, ind]], /double)
    IF ER[3, ind] GT 0. THEN E[3, ind] = RANDOMU(seed, POISSON = [ER[3, ind]], /double)
    IF ER[4, ind] GT 0. THEN E[4, ind] = RANDOMU(seed, POISSON = [ER[4, ind]], /double)
    IF ER[5, ind] GT 0. THEN E[5, ind] = RANDOMU(seed, POISSON = [ER[5, ind]], /double)
    IF ER[6, ind] GT 0. THEN E[6, ind] = RANDOMU(seed, POISSON = [ER[6, ind]], /double)
    IF ER[7, ind] GT 0. THEN E[7, ind] = RANDOMU(seed, POISSON = [ER[7, ind]], /double)
    IF ER[8, ind] GT 0. THEN E[8, ind] = RANDOMU(seed, POISSON = [ER[8, ind]], /double)
    
    IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
    IF ERPinter[ind] GT 0. THEN EPinter[ind] = RANDOMU(seed, POISSON = [ERPinter[ind]], /double)

    ;PRINT, 'Q', Q[*, ind]
    ; Stochastic estimates for the number and type of prey based on E from binomial distriution
    IF E[0, ind] GT 0. THEN NumP[0, ind] = (RANDOMU(seed, BINOMIAL = [E[0, ind], Q[0, ind]], /double))
    IF E[1, ind] GT 0. THEN NumP[1, ind] = (RANDOMU(seed, BINOMIAL = [E[1, ind], Q[1, ind]], /double))
    IF E[2, ind] GT 0. THEN NumP[2, ind] = (RANDOMU(seed, BINOMIAL = [E[2, ind], Q[2, ind]], /double))
    IF E[3, ind] GT 0. THEN NumP[3, ind] = (RANDOMU(seed, BINOMIAL = [E[3, ind], Q[3, ind]], /double))
    IF E[4, ind] GT 0. THEN NumP[4, ind] = (RANDOMU(seed, BINOMIAL = [E[4, ind], Q[4, ind]], /double))
    IF E[5, ind] GT 0. THEN NumP[5, ind] = (RANDOMU(seed, BINOMIAL = [E[5, ind], Q[5, ind]], /double))
    IF E[6, ind] GT 0. THEN NumP[6, ind] = (RANDOMU(seed, BINOMIAL = [E[6, ind], Q[6, ind]], /double))
    IF E[7, ind] GT 0. THEN NumP[7, ind] = (RANDOMU(seed, BINOMIAL = [E[7, ind], Q[7, ind]], /double))
    IF E[8, ind] GT 0. THEN NumP[8, ind] = (RANDOMU(seed, BINOMIAL = [E[8, ind], Q[8, ind]], /double))                   
  ENDFOR
;  PRINT, 'Realized encounter rate (E, #/s)'
;  PRINT, E
;  PRINT, 'Stochastic potential number of prey consumed (NumP)'
;  PRINT, NumP

; Calculate the amount of each prey type consumed PER SECOUND
 ; IF handlign time is greater than 360, no consumption
  cons = FLTARR(m, nYP)
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
  HT6 = WHERE(HT[6, *] EQ tss, HT6count, complement = HT6c, ncomplement = HT6ccount)
  IF (HT6count GT 0.0) THEN cons[6, HT6] = 0.0 
  IF (HT6ccount GT 0.0) THEN cons[6, HT6c] = DOUBLE(PW[6, HT6c] * Nump[6, HT6c]) 
  HT7 = WHERE(HT[7,*] EQ tss, HT7count, complement = HT7c, ncomplement = HT7ccount)
  IF (HT7count GT 0.0) THEN cons[7, HT7] = 0.0 
  IF (HT7ccount GT 0.0) THEN cons[7, HT7c] = DOUBLE(PW[7, HT7c] * Nump[7, HT7c]) 
  HT8 = WHERE(HT[8, *] EQ tss, HT8count, complement = HT8c, ncomplement = HT8ccount)
  IF (HT8count GT 0.0) THEN cons[8, HT8] = 0.0 
  IF (HT8ccount GT 0.0) THEN cons[8, HT8c] = DOUBLE(PW[8, HT8c] * Nump[8, HT8c]) 
  
  SD = FLTARR(m,nYP); handling time (HT) > ts in secound, then no conumption during each time step 
  SD[0,*] =  E[0,*] * Q[0,*] * HT[0,*]; = encounter rate x probability of attack x handling time
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
  HT6 = WHERE(HT[6, *] EQ tss, HT6count, complement = HT6c, ncomplement = HT6ccount)
  IF (HT6count GT 0.0) THEN SD[6, HT6] = 0.0 
  IF (HT6ccount GT 0.0) THEN SD[6, HT6c] =  E[6, HT6c] * Q[6, HT6c] * HT[6, HT6c];
  HT7 = WHERE(HT[7, *] EQ tss, HT7count, complement = HT7c, ncomplement = HT7ccount)
  IF (HT7count GT 0.0) THEN SD[7, HT7] = 0.0 
  IF (HT7ccount GT 0.0) THEN SD[7, HT7c] =  E[7, HT7c] * Q[7, HT7c] * HT[7, HT7c];
  HT8 = WHERE(HT[8, *] EQ tss, HT8count, complement = HT8c, ncomplement = HT8ccount)
  IF (HT8count GT 0.0) THEN SD[8, HT8] = 0.0 
  IF (HT8ccount GT 0.0) THEN SD[8, HT8c] =  E[8, HT8c] * Q[8, HT8c] * HT[8, HT8c];
;  PRINT, 'SD'
;  PRINT, SD

  SumDen = FLTARR(nYP)
  SumDen[*] = SD[0, *] + SD[1, *] + SD[2, *] + SD[3, *] + SD[4, *] + SD[5, *] + SD[6, *] + SD[7, *] + SD[8, *]
;  PRINT, 'SumDen'
;  PRINT, SumDen

;  PRINT, 'Realised intraspecific competitor encounter rate (EPintra, #/s)'
;  PRINT, (EPintra[0:100])
;  PRINT, 'Realised interspecific competitor encounter rate (EPinter, #/s)'
;  PRINT, (EPinter[0:100])
; Consumption for each prey type accounting for foraging in g in time step
  ; Without competition*********************NO DENSITY-DEPENDENCE**************************
;  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C[*, 0:200]

  IF Age01count GT 0. THEN BEGIN
    densPintra = dens[5, Age01] * PW[5, Age01]
    densPinter = dens[6, Age01] * PW[6, Age01] + dens[7, Age01] * PW[7, Age01] + dens[8, Age01] * PW[8, Age01] + dens[9, Age01] * PW[9, Age01]
  ENDIF
  IF Age2pluscount GT 0. THEN BEGIN
    densPintra = dens[5, Age2plus] * PW[5, Age2plus]
    densPinter = dens[9, Age2plus] * PW[9, Age2plus]
  ENDIF 
;  densPintra = dens[5, *] * PW[5, *]
;  densPinter = dens[6, *] * PW[6, *] + dens[7, *] * PW[7, *] + dens[8, *] * PW[8, *]
  ; With low competition - Beddington-DeAngelis model*********************DENSITY-DEPENDENCE**************************
  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
  ;PRINT, 'Consumption per prey (C, g/ts)'
  ;PRINT, C;[*, 0:300]
  
  ; With high competition - Crowley-Matin model
;  C[0, tds] = DOUBLE((Cons[0, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[6, tds] = DOUBLE((Cons[6, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[7, tds] = DOUBLE((Cons[7, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[8, tds] = DOUBLE((Cons[8, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C[*, 0:100]
;  PRINT, 'densPintra'
;  PRINT, densPintra[0:100]
;  PRINT, 'densPinter'
;  PRINT, densPinter[0:100]
  TotCts[tds]= DOUBLE(C[0, tds] + C[1, tds] + C[2, tds] + C[3, tds] + C[4, tds] + C[5, tds] $
               + C[6, tds] + C[7, tds] + C[8, tds])
;  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
  
  Cratio = FLTARR(m, nYP); PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
  TotCtsNZ = WHERE(TotCts NE 0., TotCtsNZcount)
  IF TotCtsNZcount GT 0. THEN BEGIN
    Cratio[0, TotCtsNZ] = DOUBLE(C[0, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[1, TotCtsNZ] = DOUBLE(C[1, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[2, TotCtsNZ] = DOUBLE(C[2, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[3, TotCtsNZ] = DOUBLE(C[3, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[4, TotCtsNZ] = DOUBLE(C[4, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[5, TotCtsNZ] = DOUBLE(C[5, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[6, TotCtsNZ] = DOUBLE(C[6, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[7, TotCtsNZ] = DOUBLE(C[7, TotCtsNZ] / TotCts[TotCtsNZ])
    Cratio[8, TotCtsNZ] = DOUBLE(C[8, TotCtsNZ] / TotCts[TotCtsNZ])
  ENDIF  
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, (TotCts)
  
; Consumption with temperature and DO effects
;  C[0, tds] = DOUBLE(C[0, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[1, tds] = DOUBLE(C[1, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[2, tds] = DOUBLE(C[2, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[3, tds] = DOUBLE(C[3, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[4, tds] = DOUBLE(C[4, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[5, tds] = DOUBLE(C[5, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[6, tds] = DOUBLE(C[6, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[7, tds] = DOUBLE(C[7, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  C[8, tds] = DOUBLE(C[8, tds] * fTfc[tds] * fDOfc2[tds]) ;g consumed for each prey type
;  PRINT, 'Consumption with temp and DO effects'
;  PRINT, C
  ;potst[tds] = double(C[0,tds] + C[1,tds] + C[2,tds] + C[3,tds] + C[4,tds] + C[5,tds] + prestom[tds])
  ;possible cons + what is left in the stomach
  
; Determine potential stomach weight in g after current time step
  PotSt = FLTARR(m, nYP)
  TotPotSt = FLTARR(nYP)
  PotSt[0, tds] = C[0, tds] + CAftDig0[tds]
  PotSt[1, tds] = C[1, tds] + CAftDig1[tds]
  PotSt[2, tds] = C[2, tds] + CAftDig2[tds]
  PotSt[3, tds] = C[3, tds] + CAftDig3[tds]
  PotSt[4, tds] = C[4, tds] + CAftDig4[tds]
  PotSt[5, tds] = C[5, tds] + CAftDig5[tds]
  PotSt[6, tds] = C[6, tds] + CAftDig6[tds]
  PotSt[7, tds] = C[7, tds] + CAftDig7[tds]
  PotSt[8, tds] = C[8, tds] + CAftDig8[tds]
  
  TotPotSt[tds] = DOUBLE(PotSt[0,tds] + Potst[1, tds] + potst[2, tds] + potst[3, tds] + potst[4, tds] + potst[5, tds] $
                  + potst[6, tds] + potst[7, tds] + potst[8, tds]); + prestom[tds])
  ;possible cons + what is left in the stomach
;  PRINT, 'Potential stomach weight per prey (g)'
;  PRINT, Potst
;  PRINT, 'Potential total stomach weight (g)'
;  PRINT, TotPotSt
  
; Check if potential stomach weight is greater than stomach capacity
  nstom = FLTARR(nYP)
  Premove = FLTARR(nYP)
  TotCAftDig = FLTARR(nYP)
  RemCAftDig = FLTARR(nYP)
  RemCAftDig0 = FLTARR(nYP)
  RemCAftDig1 = FLTARR(nYP)
  RemCAftDig2 = FLTARR(nYP)
  RemCAftDig3 = FLTARR(nYP)
  RemCAftDig4 = FLTARR(nYP)
  RemCAftDig5 = FLTARR(nYP)
  RemCAftDig6 = FLTARR(nYP)
  RemCAftDig7 = FLTARR(nYP)
  RemCAftDig8 = FLTARR(nYP)
;  PRINT, 'Stomach capacity'
;  PRINT, TRANSPOSE(stcap)
  PT = WHERE(TotPotSt LT StCap, PTcount, complement = P, ncomplement = Pcount)
  ; If less than stomach capacity, fish keep its potential
  PRINT, 'Number of fish with overconsumption =', Pcount
  IF (PTcount GT 0.) THEN Nstom[PT] = TotPotSt[PT]; no change in consumption
  ; If more than stomach capacity, fish can eat to capacity
  IF (Pcount GT 0.) THEN BEGIN
    ; AND need to remove biomass from diet so that nstom = stcap
    Premove[P] = DOUBLE(stcap[P] / TotPotSt[P])
;    PRINT, 'Premove'
;    PRINT, (premove)

    ; Need to remove additional amount for previously undigested food
    TotCAftDig[P] = CAftDig0[p] + CAftDig1[p] + CAftDig2[p] + CAftDig3[p] $
                 + CAftDig4[p] + CAftDig5[p] + CAftDig6[p] + CAftDig7[p] + CAftDig8[p]
    RemCAftDig[P] = TotCAftDig[P] - TotCAftDig[P] * Premove[P]; ***SUBSCRIPT P ONLY****
    RemCAftDig0[P] = RemCAftDig[P] * Cratio[0, P]
    RemCAftDig1[P] = RemCAftDig[P] * Cratio[1, P]
    RemCAftDig2[P] = RemCAftDig[P] * Cratio[2, P]
    RemCAftDig3[P] = RemCAftDig[P] * Cratio[3, P]
    RemCAftDig4[P] = RemCAftDig[P] * Cratio[4, P]
    RemCAftDig5[P] = RemCAftDig[P] * Cratio[5, P]
    RemCAftDig6[P] = RemCAftDig[P] * Cratio[6, P]
    RemCAftDig7[P] = RemCAftDig[P] * Cratio[7, P]
    RemCAftDig8[P] = RemCAftDig[P] * Cratio[8, P]
    
    C[0, p] = DOUBLE(Premove[P] * C[0, p] - RemCAftDig0[P]) ;new g of prey after removing specific prey item...
    C[1, p] = DOUBLE(Premove[P] * C[1, p] - RemCAftDig1[P])
    C[2, p] = DOUBLE(Premove[P] * C[2, p] - RemCAftDig2[P])
    C[3, p] = DOUBLE(Premove[P] * C[3, p] - RemCAftDig3[P])
    C[4, p] = DOUBLE(Premove[P] * C[4, p] - RemCAftDig4[P])
    C[5, p] = DOUBLE(Premove[P] * C[5, p] - RemCAftDig5[P])
    C[6, p] = DOUBLE(Premove[P] * C[6, p] - RemCAftDig6[P])
    C[7, p] = DOUBLE(Premove[P] * C[7, p] - RemCAftDig7[P])
    C[8, p] = DOUBLE(Premove[P] * C[8, p] - RemCAftDig8[P])
    
    TotCts[P]= DOUBLE(C[0,P] + C[1, P] + C[2, P] + C[3, P] + C[4, P] + C[5, P] + C[6, P] + C[7, P] + C[8, P])
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
    Potst[6, P] = C[6, P] + CAftDig6[P]
    Potst[7, P] = C[7, P] + CAftDig7[P]
    Potst[8, P] = C[8, P] + CAftDig8[P]
    TotPotSt[P] = DOUBLE(PotSt[0,P] + Potst[1, P] + potst[2, P] + potst[3, P] + potst[4, P] + potst[5, P] $
                  + potst[6, P] + potst[7, P] + potst[8, P]);
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
  YPGutEvacR = 0.0182 * EXP(0.14 * Temp) / 60.0 * fDOfc2; in g/min acclimated temperature-dependent
;  PRINT, 'YPGutEvacR'
;  PRINT, TRANSPOSE(YPGutEvacR)

  ; Food digeseted over time step = 6 min
;  PRINT, 'Prey specific stomach content before Digestion'
;  PRINT, PotSt[*, tds]
  ; Digestion and evacuation of each prey from current and previous ts
  ;newstomAFTdig = prestom[*] * exp(-YPGutEvacR * ts) + ((newstom - prestom[*]) / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  CAftDig[0, tds] = (CAftDig0[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[0, tds]) * EXP(-YPGutEvacR[tds] * ts)); 
  CAftDig[1, tds] = (CAftDig1[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[1, tds]) * EXP(-YPGutEvacR[tds] * ts)); 
  CAftDig[2, tds] = (CAftDig2[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[2, tds]) * EXP(-YPGutEvacR[tds] * ts)); 
  CAftDig[3, tds] = (CAftDig3[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[3, tds]) * EXP(-YPGutEvacR[tds] * ts)); 
  CAftDig[4, tds] = (CAftDig4[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[4, tds]) * EXP(-YPGutEvacR[tds] * ts)); 
  CAftDig[5, tds] = (CAftDig5[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[5, tds]) * EXP(-YPGutEvacR[tds] * ts));
  CAftDig[6, tds] = (CAftDig6[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[6, tds]) * EXP(-YPGutEvacR[tds] * ts));
  CAftDig[7, tds] = (CAftDig7[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[7, tds]) * EXP(-YPGutEvacR[tds] * ts));
  CAftDig[8, tds] = (CAftDig8[tds] * EXP(-YPGutEvacR[tds] * ts) + (C[8, tds]) * EXP(-YPGutEvacR[tds] * ts));

  ;CAftDig[0,*] = C[0,*]  + (CAftDig[0,*] - C[0,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  ;CAftDig[1,*] = C[1,*]  + (CAftDig[1,*] - C[1,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  ;CAftDig[2,*] = C[2,*]  + (CAftDig[2,*] - C[2,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  ;CAftDig[3,*] = C[3,*]  + (CAftDig[3,*] - C[3,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  ;CAftDig[4,*] = C[4,*]  + (CAftDig[4,*] - C[4,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))
  ;CAftDig[5,*] = C[5,*]  + (CAftDig[5,*] - C[5,*] / YPGutEvacR) * (1 - exp(-YPGutEvacR * ts))

  ; DigestedFood = Nstom - NstomAFTdig; per time step = 6min
  DigestedFood[0, tds] = DOUBLE(potst[0, tds] - CAftDig[0, tds])
  DigestedFood[1, tds] = DOUBLE(potst[1, tds] - CAftDig[1, tds])
  DigestedFood[2, tds] = DOUBLE(potst[2, tds] - CAftDig[2, tds])
  DigestedFood[3, tds] = DOUBLE(potst[3, tds] - CAftDig[3, tds])
  DigestedFood[4, tds] = DOUBLE(potst[4, tds] - CAftDig[4, tds])
  DigestedFood[5, tds] = DOUBLE(potst[5, tds] - CAftDig[5, tds])
  DigestedFood[6, tds] = DOUBLE(potst[6, tds] - CAftDig[6, tds])
  DigestedFood[7, tds] = DOUBLE(potst[7, tds] - CAftDig[7, tds])
  DigestedFood[8, tds] = DOUBLE(potst[8, tds] - CAftDig[8, tds])

  ; Determine total non-digested stomach content in g after time step = 6 min
  PotStAftDig[tds] = DOUBLE(CAftDig[0, tds] + CAftDig[1, tds] + CAftDig[2, tds] + CAftDig[3, tds] + CAftDig[4, tds] + CAftDig[5, tds] $
                     + CAftDig[6, tds] + CAftDig[7, tds] + CAftDig[8, tds])
  NewStom[tds] = (PotStAftDig[tds]); tds = TotCday < YPcmx
  
  ; Determine daily cumulative food consumption 
  TotCday[tds] = (TotCday[tds] + TotCts[tds]) 
  TotC[0, tds] = C[0, tds] + TotC0[tds]
  TotC[1, tds] = C[1, tds] + TotC1[tds]
  TotC[2, tds] = C[2, tds] + TotC2[tds]
  TotC[3, tds] = C[3, tds] + TotC3[tds]
  TotC[4, tds] = C[4, tds] + TotC4[tds]
  TotC[5, tds] = C[5, tds] + TotC5[tds]
  TotC[6, tds] = C[6, tds] + TotC6[tds]
  TotC[7, tds] = C[7, tds] + TotC7[tds]
  TotC[8, tds] = C[8, tds] + TotC8[tds]
;  PRINT, 'Total daily cumulative consumption (TotCday, g/day)'
;  PRINT, TRANSPOSE(totcday)
;  PRINT, 'Daily cumulative consumption for each prey (TotC, g/day)'
;  PRINT, TRANSPOSE(TotC)
  
  ENDIF
;ENDIF;****************************************************************************************************************************

;*********If the previous stomach content is larger than CMAX -> No consumption - digestion/evacuation only************************
PRINT, 'Number of fish with full stomach =', dcount
IF (dcount GT 0.0) THEN BEGIN; dcount = totcday > YPcmx 
; OR ((iHour LT 4L) AND (iHour GT 15L)) OR ((iHour LT 4L) AND (iHour GT 20L)) 
  ; Digestion and evacuation for each prey item
  YPGutEvacR = 0.0182 * EXP(0.14 * Temp) / 60.0 * fDOfc2;in g/min temperature-dependent
  
  CAftDig[0, d] = DOUBLE(CAftDig0[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[1, d] = DOUBLE(CAftDig1[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[2, d] = DOUBLE(CAftDig2[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[3, d] = DOUBLE(CAftDig3[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[4, d] = DOUBLE(CAftDig4[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[5, d] = DOUBLE(CAftDig5[d] * EXP(-YPGutEvacR[d] * ts)); 
  CAftDig[6, d] = DOUBLE(CAftDig6[d] * EXP(-YPGutEvacR[d] * ts))
  CAftDig[7, d] = DOUBLE(CAftDig7[d] * EXP(-YPGutEvacR[d] * ts))
  CAftDig[8, d] = DOUBLE(CAftDig8[d] * EXP(-YPGutEvacR[d] * ts))
;  print, 'Undigested pret item (CAftDig, g)'
;  PRINT, TRANSPOSE(CAftDig[*, d])

  PotStAftDig[d] = DOUBLE(CAftDig[0,d] + CAftDig[1,d] + CAftDig[2,d] + CAftDig[3,d] + CAftDig[4,d] + CAftDig[5,d] $
                   + CAftDig[6,d] + CAftDig[7,d] + CAftDig[8,d])
  NewStom[d] = PotStAftDig[d];
  
  DigestedFood[0,d] = DOUBLE(CAftDig0[d] - CAftDig[0,d])
  DigestedFood[1,d] = DOUBLE(CAftDig1[d] - CAftDig[1,d])
  DigestedFood[2,d] = DOUBLE(CAftDig2[d] - CAftDig[2,d])
  DigestedFood[3,d] = DOUBLE(CAftDig3[d] - CAftDig[3,d])
  DigestedFood[4,d] = DOUBLE(CAftDig4[d] - CAftDig[4,d])
  DigestedFood[5,d] = DOUBLE(CAftDig5[d] - CAftDig[5,d])
  DigestedFood[6,d] = DOUBLE(CAftDig6[d] - CAftDig[6,d])
  DigestedFood[7,d] = DOUBLE(CAftDig7[d] - CAftDig[7,d])
  DigestedFood[8,d] = DOUBLE(CAftDig8[d] - CAftDig[8,d])

  TotCday[d] = TotCday[d]; No consumption during this time step
  TotC[0, d] = TotC0[d]
  TotC[1, d] = TotC1[d]
  TotC[2, d] = TotC2[d]
  TotC[3, d] = TotC3[d]
  TotC[4, d] = TotC4[d]
  TotC[5, d] = TotC5[d]
  TotC[6, d] = TotC6[d]
  TotC[7, d] = TotC7[d]
  TotC[8, d] = TotC8[d]
ENDIF;****************************************************************************************************************************

;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, (DigestedFood[*, *])
;PRINT, 'Undigested prey items (CAftDig, g)'
;PRINT, CAftDig[*, *] 
;CAftDigTEST=FLTARR(M, nYP)
;CAftDigTEST[0,*] = CAftDig0[*]
;CAftDigTEST[1,*] = CAftDig1[*]
;CAftDigTEST[2,*] = CAftDig2[*]
;CAftDigTEST[3,*] = CAftDig3[*]
;CAftDigTEST[4,*] = CAftDig4[*]
;CAftDigTEST[5,*] = CAftDig5[*]
;CAftDigTEST[6,*] = CAftDig6[*]
;CAftDigTEST[7,*] = CAftDig7[*]
;CAftDigTEST[8,*] = CAftDig8[*] 
;PRINT,'CAftDigTEST'
;PRINT, CAftDigTEST

;PRINT, 'Total non-digested stomach content (potstAftDig, g)'
;PRINT, (potstAftDig[*])
;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Total daily cumulative consumption (g/day)'
;PRINT, (TotCday[*])

;CellDepth = (VerSize[*]/1000)
;PRINT, 'Cell depth (m)'
;;PRINT, CellDepth
;ZooplBio1 = (YP[15,*])*4000000000D*((Grid2D[3, YP[13, *]]/20.)*1000./1000.); g per cell of 2km x 2km x depth from g/L 
;ZooplBio2 = (YP[16,*])*4000000000D*((Grid2D[3, YP[13, *]]/20.)*1000./1000.); g per cell of 2km x 2km x depth from g/L 
;ZooplBio3 = (YP[17,*])*4000000000D*((Grid2D[3, YP[13, *]]/20.)*1000./1000.); g per cell of 2km x 2km x depth from g/L 
;ZooplBioAft1 = ZooplBio1 - C[0, *]*YP[0,*]; Czoopl1 = g per individual
;ZooplBioAft2 = ZooplBio2 - C[1, *]*YP[0,*];
;ZooplBioAft3 = ZooplBio3 - C[2, *]*YP[0,*];
;  PRINT, 'ZooplBio2'
;  PRINT, TRANSPOSE(ZooplBio2)
;  PRINT, 'C[1, *]*YP[0,*]'
;  PRINT, TRANSPOSE(C[1, *]*YP[0,*])
;  PRINT, 'ZooplBioAft2'
;  PRINT, TRANSPOSE(ZooplBioAft2)
  
consumption = FLTARR(50, nYP)
; Digested food items used for growth subroutine
consumption[0,*] = DigestedFood[0,*]; g digested for each prey type
consumption[1,*] = DigestedFood[1,*]; g digested for each prey type
consumption[2,*] = DigestedFood[2,*]; g digested for each prey type
consumption[3,*] = DigestedFood[3,*]; g digested for each prey type
consumption[4,*] = DigestedFood[4,*]; g digested for each prey type
consumption[5,*] = DigestedFood[5,*]; g digested for each prey type
consumption[6,*] = DigestedFood[6,*]; g digested for each prey type
consumption[7,*] = DigestedFood[7,*]; g digested for each prey type
consumption[8,*] = DigestedFood[8,*]; g digested for each prey type

consumption[9,*] = NewStom[*]; new weight of stomach content
consumption[10,*] = TotCday[*]; new total cumulative consumption after time step need to be updated every 24h

; undigested food in the stomach carried over to the next time step
consumption[11,*] = CAftDig[0,*]; + CAftDig6[0,*]
consumption[12,*] = CAftDig[1,*]; + CAftDig6[1,*]
consumption[13,*] = CAftDig[2,*]; + CAftDig6[2,*]
consumption[14,*] = CAftDig[3,*]; + CAftDig6[3,*]
consumption[15,*] = CAftDig[4,*]; + CAftDig6[4,*]
consumption[16,*] = CAftDig[5,*]; + CAftDig6[5,*]
consumption[17,*] = CAftDig[6,*]; + CAftDig6[3,*]
consumption[18,*] = CAftDig[7,*]; + CAftDig6[4,*]
consumption[19,*] = CAftDig[8,*]; + CAftDig6[5,*]

; the amount of each prey consumed per time step
consumption[20,*] = C[0,*]; 
consumption[21,*] = C[1,*];
consumption[22,*] = C[2,*]; 
consumption[23,*] = C[3,*]; 
consumption[24,*] = C[4,*]; 
consumption[25,*] = C[5,*]; 
consumption[26,*] = C[6,*]; 
consumption[27,*] = C[7,*]; 
consumption[28,*] = C[8,*];

; total daily amount of prey consumed after time step need to be updated every 24h
consumption[29,*] = TotC[0,*]; total amount of daily consumption of microzooplankton
consumption[30,*] = TotC[1,*]; total amount of daily consumption of mezozooplankton
consumption[31,*] = TotC[2,*]; total amount of daily consumption of mezozooplankton
consumption[32,*] = TotC[3,*]; total amount of daily consumption of 
consumption[33,*] = TotC[4,*]; total amount of daily consumption of 
consumption[34,*] = TotC[5,*]; total amount of daily consumption of 
consumption[35,*] = TotC[6,*]; total amount of daily consumption of 
consumption[36,*] = TotC[7,*]; total amount of daily consumption of 
consumption[37,*] = TotC[8,*]; total amount of daily consumption of 

consumption[38,*] = C[0, *] + C[1, *] + C[2, *]; Total zooplankton consumption by superindividuals (x N)
;consumption[39,*] = ZooplBioAft1 + ZooplBioAft2 + ZooplBioAft3; Total zooplankton available in each cell AFTER fish feeding

; the NUMBER of each prey consumed per time step (= 6 min) 
PW[*,*] = PW[*,*]
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
Non0Prey6 = WHERE((PW[6, *] GT 0.), Non0Prey6count)
IF Non0Prey6count GT 0. THEN consumption[46, Non0Prey6] = CEIL(C[6, Non0Prey6]/PW[6, Non0Prey6]); 
Non0Prey7 = WHERE((PW[7, *] GT 0.), Non0Prey7count)
IF Non0Prey7count GT 0. THEN consumption[47, Non0Prey7] = CEIL(C[7, Non0Prey7]/PW[7, Non0Prey7]); 
Non0Prey8 = WHERE((PW[8, *] GT 0.), Non0Prey8count)
IF Non0Prey8count GT 0. THEN consumption[48, Non0Prey8] = CEIL(C[8, Non0Prey8]/PW[8, Non0Prey8]);

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
;PRINT, 'Digested emerald shiner (g)'
;PRINT, TRANSPOSE(consumption[6,*])
;PRINT, 'Digested rainbow smelt (g)'
;PRINT, TRANSPOSE(consumption[7,*])
;PRINT, 'Digested round goby (g)'
;PRINT, TRANSPOSE(consumption[8,*])
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
;PRINT, 'C (g) daily cumulative consumption of emerald shiner'
;PRINT, TRANSPOSE(consumption[35,*])
;PRINT, 'C (g) daily cumulative consumption of rainbow smelt'
;PRINT, TRANSPOSE(consumption[36,*])
;PRINT, 'C (g) daily cumulative consumption of round goby'
;PRINT, TRANSPOSE(consumption[37,*])
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
;PRINT, 'C (g) undigested emerald shiner'
;PRINT, TRANSPOSE(consumption[17,*])
;PRINT, 'C (g) undigested rainbow smelt'
;PRINT, TRANSPOSE(consumption[18,*])
;PRINT, 'C (g) undigested round goby'
;PRINT, TRANSPOSE(consumption[19,*])
;
;PRINT, 'Number of individuals per superindividual'
;PRINT, TRANSPOSE(YP[0,*])
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
;PRINT, 'Number of consumed emerald shiner'
;PRINT, TRANSPOSE(consumption[46,*])
;PRINT, 'Number of consumed rainbow smelt'
;PRINT, TRANSPOSE(consumption[47,*])
;PRINT, 'Number of consumed round goby'
;PRINT, TRANSPOSE(consumption[48,*])

;***FOR TEST ONLY****************************
;PRINT, 'Encounter rate (ER, #/ts)'
;PRINT, ER

;PRINT, 'Proportion of each prey item attcked and captured (t)'
;PRINT, t
;PRINT, 'Proportion of all prey items attcked and captured (tot)'
;PRINT, TOT
;PRINT, 'Probability of attack and cature (Q) without temperature and DO effect'
;PRINT, Q
;PRINT, 'DOa'
;PRINT, TRANSPOSE(DOa)
;PRINT, 'DOacclC'
;PRINT, TRANSPOSE(DOacclC)
;PRINT, 'DOcritC'
;PRINT, TRANSPOSE(DOcritC)
;PRINT,'fDOfc2'
;PRINT, fDOfc2
;PRINT, 'ftfc'
;PRINT, ftfc
;PRINT, 'Probability of attack and cature (Q) with temperature and DO effect'
;PRINT, Q
;PRINT, 'Realized encounter rate (E, #/ts)'
;PRINT, E
;PRINT, 'Stochastic potential number of prey consumed (NumP)'
;PRINT, NumP
;PRINT, 'SD'
;PRINT, SD
;PRINT, 'SumDen'
;PRINT, SumDen

;PRINT, 'Potential amount of each prey type consumed (cons, g)'
;PRINT, cons
;PRINT, 'Consumption per prey (C, g/ts)'
;PRINT, C

;PRINT, 'Number of consumed prey'
;PRINT, (consumption[40:48,*])

;PRINT, 'Expected handling time per prey (HT, s)'
;PRINT, HT
;PRINT, 'Potential total handling time (SumHT, s)'
;PRINT, SumHT
;PRINT, 'Potential stomach weight per prey (g)'
;PRINT, Potst
;PRINT, 'Potential total stomach weight (g)'
;PRINT, TotPotSt

;PRINT, 'Stomach capacity'
;PRINT, TRANSPOSE(stcap)

;PRINT, 'YPGutEvacR'
;PRINT, TRANSPOSE(YPGutEvacR)
  
;PRINT, 'Prey specific stomach content before Digestion'
;PRINT, PotSt[*, tds]
;PRINT, 'Daily cumulative consumption for each prey (TotC, g/day)'
;PRINT, (TotC)
;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, (DigestedFood[*, *])

;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Stomach Fullness (%)'
;PRINT, TRANSPOSE(consumption[49, *])

;PRINT, 'Cratio'
;PRINT, Cratio

;PRINT, consumption[49, *] 
;PRINT, 'Undigested prey items (CAftDig, g)'
;PRINT, CAftDig[*, *] 

;PRINT, 'Prey density (dens)'
;PRINT, dens
;PRINT, 'Prey length (PL, mm)'
;PRINT, PL
;PRINT, 'pbio', pbio
;PRINT, 'ER', ER
;PRINT, 'E', E
;PRINT, 'NumP', NumP

;PRINT, 'Fish3DCellID'
;PRINT, Fish3DCellID
;PRINT, 'YP[14,*]'
;PRINT, TRANSPOSE(YP[14,*])
;PRINT, 'FISHPREY[0, YEP3DCellID[*]]'
;PRINT, TRANSPOSE(FISHPREY[0, YEP3DCellID[*]])
;PRINT, 'YP[0, *]'
;PRINT, TRANSPOSE(YP[0, *])

;PRINT, 'FISHPREY'
;PRINT, FISHPREY[*, *]
;PRINT, 'YPpbio'
;PRINT, YPpbio; FORAGE PARAMETER
;
;PRINT, 'NUMBER OF YEP SUPERINDIVIDUALS', N_ELEMENTS(YEPFISHPREY[0, YP[14, *]])
;PRINT, 'MultiSI'
;PRINT, MultiSI
;PRINT, 'FISH3DCellIDcount[0, YP[14, *]]'
;PRINT, TRANSPOSE(FISH3DCellIDcount[0, YP[14, *]])
;PRINT, 'YP[14, 0:1000]'
;PRINT, TRANSPOSE(YP[14, 0:1000])
;PRINT, 'FISH3DCellIDcount[0, 0:1000]'
;PRINT, TRANSPOSE(FISH3DCellIDcount[0, 0:1000])
;PRINT, N_ELEMENTS(MultiSI)

;PRINT, 'YEPID'
;PRINT, TRANSPOSE(YEPID)
;PRINT, 'YEPLENGTH'
;PRINT, TRANSPOSE(YEPlength)
;PRINT, 'YEPMultiSI'
;PRINT, (YEPMultiSI)
;PRINT, 'FISHPREY2[1, YP[14, *]]'
;PRINT, TRANSPOSE(FISHPREY2[1, YP[14, *]])
;PRINT, 'FISHPREY[1, YP[14, *]]'
;PRINT, TRANSPOSE(FISHPREY[1, YP[14, *]])
;PRINT, 'YEPweight'
;PRINT, TRANSPOSE(YEPweight)

;PRINT, YP[1, *]*(YP[14, *] EQ MultiSI)
;PRINT, 'Total number of individuals in each cell'
;PRINT,TRANSPOSE(FISHPREY[0, YP[14, *]])
;PRINT, 'Total biomass in each cell'
;PRINT,TRANSPOSE(FISHPREY[3, YP[14, *]])
;PRINT, 'Number of superindividuals in each cell'
;PRINT,TRANSPOSE(FISH3DCellIDcount[YP[14, *]])

;PRINT, 'Fish3DCellID'
;PRINT, Fish3DCellID

;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:499] 
;PRINT, 'PW'
;PRINT, PW 
;PRINT, 'C'
;PRINT, C
;PRINT, 'YPpbio'
;PRINT, YPpbio
;PRINT, 'EMS14'
;PRINT, TRANSPOSE(EMS[14, *])
;PRINT, 'RAS14'
;PRINT, TRANSPOSE(RAS[14, *])
;PRINT, 'YP14'
;PRINT, TRANSPOSE(YP[14, *])
;PRINT, 'FISH LOCATION'
;PRINT, TRANSPOSE(YP[12, *])
;PRINT, 'ftfc'
;PRINT, ftfc
;PRINT, 'Light'
;PRINT, transpose(LIGHT)
;PRINT, 'Light multiplication factor'
;PRINT, transpose(litfac)
;PRINT, 'IHOUR', IHOUR
;PRINT, 'Reactive distance (RD, mm)'
;PRINT, RD 
  ;PRINT, 'Chessons alpha'
  ;PRINT, Calpha
 ;PRINT, 'Probability of attack and cature (Q) without temperature and DO effect'
  ;PRINT, Q
  ;PRINT, 'alphaDig'
  ;PRINT, TRANSPOSE(alphaDig)
;    PRINT, 'C'
;  PRINT, C
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, (TotCts)
;    PRINT, 'Potential amount of each prey type consumed (cons, g)'
;  PRINT, cons
;  PRINT, 'Cratio'
;  PRINT, Cratio
;******************************************

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Yellow Perch Foraging Ends Here'
RETURN, Consumption; TURN OFF WHEN TESTING
END