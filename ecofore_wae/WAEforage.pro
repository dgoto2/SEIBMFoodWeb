FUNCTION WAEforage, iHour, Length, Temp, Light, WAEpbio, WAEcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
CAftDig6, CAftDig7, CAftDig8, CAftDig9, StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, TotC6, TotC7, TotC8, TotC9, $
ts, nWAE, DOa, DOacclC, DOcritC, WAE;, Grid2D
; This function calculates total consumption (g) by walleye
 
PRINT, 'WAEForage Begins Here'
tstart = SYSTIME(/seconds)
  
YOY = WHERE(WAE[6, *] LT 1., YOYcount, complement = YAO, ncomplement = YAOcount)

tss = ts*60.; time step in secound
m = 10; the number of prey types 
NewStom = FLTARR(nWAE); the amount of food in stomach
TotC = FLTARR(m, nWAE); daily cumulative consumption of each prey item 
TotCts = FLTARR(nWAE)
WAEGutEvacR = FLTARR(nWAE)
DigestedFood = FLTARR(m, nWAE); the total amount of digested prey used for growth
PotStAftDig = FLTARR(nWAE); potential stomach content after digestion 
C = FLTARR(m, nWAE); the amount of each prey item consumed per time step
CAftDig = FLTARR(m, nWAE); the amoung of each prey item digested
;CAftDig[0,*] = CAftDig0[*]
;CAftDig[1,*] = CAftDig1[*]
;CAftDig[2,*] = CAftDig2[*]
;CAftDig[3,*] = CAftDig3[*]
;CAftDig[4,*] = CAftDig4[*]
;CAftDig[5,*] = CAftDig5[*]
;CAftDig[6,*] = CAftDig6[*]
;CAftDig[7,*] = CAftDig7[*]
;CAftDig[8,*] = CAftDig8[*]
;CAftDig[9,*] = CAftDig9[*]
;PRINT, 'CAftDig'
;PRINT, CAftDig[0:9,*]
;
;PRINT, 'TotCday'
;PRINT, TRANSPOSE(TotCday)
;PRINT, 'WAEcmx'
;PRINT, (WAEcmx)
;PRINT, 'Previous stomach content (PreStom)'
;PRINT, TRANSPOSE(PreStom)
;PRINT, 'Stomach Capacity (StCap)'
;PRINT, TRANSPOSE(StCap)


; Determine prey length for each prey type (m) in the model
; Prey length 
PL = FLTARR(m, nWAE)
PL[0, *] = RANDOMU(seed, nWAE)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nWAE)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nWAE)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nWAE)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nWAE)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm

;***IF THERE ARE MORE THAN ONE SP IN A CELL, RANDOMLY CHOOSE ONE FOR EACH TS
PL[5, *] = WAEpbio[6, *]; length for yellow perch in mm 
PL[6, *] = WAEpbio[10, *]; length for emerald shiner in mm 
PL[7, *] = WAEpbio[14, *]; length for rainbow smelt in mm 
PL[8, *] = WAEpbio[18, *]; length for round goby in mm 
PL[9, *] = WAEpbio[22, *]; length for walleye in mm 
;  PRINT, 'Prey length (PL, mm)'
;  PRINT, PL


; Prey individual weight (g, wet)
PW = FLTARR(m, nWAE); weight of each prey type
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.0; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.0; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.0; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.0; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet

;***IF THERE ARE MORE THAN ONE SP IN A CELL, RANDOMLY CHOOSE ONE FOR EACH TS
Pw[5, *] = WAEpbio[7, *];
Pw[6, *] = WAEpbio[11, *];
Pw[7, *] = WAEpbio[15, *];
Pw[8, *] = WAEpbio[19, *];
Pw[9, *] = WAEpbio[23, *];
;PRINT,'Prey weight (PW, g wet)'
;;  PRINT, PW
;IF YOYcount GT 0. THEN PRINT, PW[5:9, YOY[0:99L]]
  
  
  
; Convert prey biomass (g/L or m^2) into numbers/L or m^2
dens = FLTARR(m, nWAE)
dens[0,*] = WAEpbio[0,*] / Pw[0,*]; for rotifer 
dens[1,*] = WAEpbio[1,*] / Pw[1,*]; for copepod
dens[2,*] = WAEpbio[2,*] / Pw[2,*]; for cladocerans
pbio3 = WHERE(WAEpbio[3,*] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
IF pbio3count GT 0.0 THEN dens[3, pbio3] = WAEpbio[3, pbio3] / Pw[3, pbio3] 
IF pbio3ccount GT 0.0 THEN dens[3, pbio3c] = 0.0; for chironmoid
pbio4 = WHERE(WAEpbio[4,*] GT 0.0, pbio4count, complement = pbio4c, ncomplement = pbio4ccount)
IF pbio4count GT 0.0 THEN dens[4, pbio4] = WApbio[4, pbio4] / Pw[4, pbio4] 
IF pbio4ccount GT 0.0 THEN dens[4, pbio4c] = 0.0; for invasive species

dens[5, *] = WAEpbio[5, *]; for yellow perch
dens[6, *] = WAEpbio[9, *]; for emerald shiner
dens[7, *] = WAEpbio[13, *]; for rainbow smlet
dens[8, *] = WAEpbio[17, *]; round goby 
dens[9, *] = WAEpbio[21, *]; for walleye
;PRINT, 'Prey density (dens)'
;IF YOYcount GT 0. THEN PRINT, dens[0:9, YOY[0:99L]]


; Determine if the acclimated DO level is below the critical DO level
fDOfc2 = FLTARR(nWAE)
DOc = WHERE(2.*DOcritC GE DOacclC, DOccount, complement = DOcc, ncomplement = DOcccount)
IF (DOccount GT 0.0) THEN fDOfc2[DOc] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclC[DOc] + (4. - 2*DOcritC[DOc])) + 6.5916))
IF (DOcccount GT 0.0) THEN fDOfc2[DOcc] = 1.0
;***Hypoxia effect is incorporated in the digestion process (physiological) -> slows digestion -> lowers foraging***
PRINT, 'Number of fish in hypoxic cells (DOccount) =', DOccount
;PRINT,'fDOfc2'
;PRINT, fDOfc2


; Determine if food consumption has reached daily Cmax or full stomach in the previous time step
tds = WHERE((TotCday LT WAEcmx) AND (PreStom LT StCap), tdscount, complement = d, ncomplement = dcount)
PRINT, 'Number of fish with less than full stomach or Cmax =', tdscount
IF (tdscount GT 0.0) THEN BEGIN; if fish hasn't consumed more than cmax for the last 24 hours


; Fish swimming speed calculation, S, in body lengths/sec
  SS = FLTARR(nWAE)
  S = FLTARR(nWAE)
  L = WHERE(length LT 20.0, Lcount, complement = LL, ncomplement = LLcount)
  IF (Lcount GT 0.0) THEN S[L] = 3.0227 * ALOG(length[L]) - 4.6273; for walleye <20mm; Houde, 1969  
   ;SS equation based on data from Houde 1969 in body lengths/sec
  IF (LLcount GT 0.0) THEN S[LL] = 1000 * (0.263 + 0.72 * length[LL] + 0.012 * Temp[LL])
  ; for walleye >20mm; Peake et al., 2000
  ; Converts SS into mm/s
  IF (Lcount GT 0.0) THEN SS[L] = S[L] * WAE[1, L]
  IF (LLcount GT 0.0) THEN SS[LL] = S[LL] 
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS


; Calculate predator size-based prey selectivity (Chesson's alpha) for each prey type
  Calpha = FLTARR(m, nWAE);********NEED TO GET WALLEYE-SEPECIFIC INFORMATION**************** CHANGED TO SOME EXTENT
  Calpha[0, *] = 193499 * Length^(-7.64); for microzooplankton - rotifers
  
  MinLenPisc = 43.; minimum length to become piscivore
    
  LengthLTMinLen = WHERE((Length LT MinLenPisc), LengthLTMinLencount, complement = LengthGEMinLen, ncomplement = LengthGEMinLencount)
  IF (LengthLTMinLencount GT 0.0) THEN BEGIN
    Calpha[1, LengthLTMinLen] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length[LengthLTMinLen]))^(1.0 / 0.031) ; for mesozooplankton1 - calanoids  
    Calpha[2, LengthLTMinLen] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length[LengthLTMinLen]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
    
    PL3 = WHERE((PL[3, LengthLTMinLen] / Length[LengthLTMinLen]) LE 0.2, PL3count, complement = PL3c, ncomplement = pl3ccount)
    IF (PL3count GT 0.0) THEN Calpha[3, LengthLTMinLen[PL3]] = ABS(1. - 1.75 * (PL[3, LengthLTMinLen[PL3]] / Length[LengthLTMinLen[PL3]]))
    IF (PL3ccount GT 0.0) THEN Calpha[3, LengthLTMinLen[PL3c]] = 0. ;for benthic prey for flounder by Rose et al. 1996        
  ENDIF
  
  IF (LengthGEMinLencount GT 0.0) THEN BEGIN
    Calpha[1, LengthGEMinLen] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length[LengthGEMinLen]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
    Calpha[2, LengthGEMinLen] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length[LengthGEMinLen]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
 
    PL3 = WHERE((PL[3, LengthGEMinLen] / Length[LengthGEMinLen]) LE 0.2, PL3count, complement = PL3c, ncomplement = pl3ccount)
    IF (PL3count GT 0.0) THEN Calpha[3, LengthGEMinLen[PL3]] = ABS(1. - 1.75 * (PL[3, LengthGEMinLen[PL3]] / Length[LengthGEMinLen[PL3]]))
    IF (PL3ccount GT 0.0) THEN Calpha[3, LengthGEMinLen[PL3c]] = 0. ;for benthic prey for flounder by Rose et al. 1996      
  ENDIF
  
;  Length60 = WHERE(Length GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)  
;  IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
;  IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.
  
  LengthLT200 = WHERE((Length LT 200.0), LengthLT200count, complement = LengthGE200, ncomplement = LengthGE200count)
  
  IF (LengthLT200count GT 0.0) THEN BEGIN
    PL5 = WHERE(((PL[5, LengthLT200] / Length[LengthLT200]) LT 0.6), PL5count, complement = PL5c, ncomplement = PL5ccount)
    IF (PL5count GT 0.0) THEN Calpha[5, LengthLT200[PL5]] = 0.5
    IF (PL5ccount GT 0.0) THEN Calpha[5, LengthLT200[PL5c]] = 0.; for yellow perch
  ENDIF
  IF (LengthGE200count GT 0.0) THEN BEGIN
    PL5 = WHERE(((PL[5, LengthGE200] / Length[LengthGE200]) LT 0.4), PL5count, complement = PL5c, ncomplement = PL5ccount)
    IF (PL5count GT 0.0) THEN Calpha[5, LengthGE200[PL5]] = 0.5
    IF (PL5ccount GT 0.0) THEN Calpha[5, LengthGE200[PL5c]] = 0.; for yellow perch
  ENDIF
  
  IF (LengthLT200count GT 0.0) THEN BEGIN
    PL6 = WHERE(((PL[6, LengthLT200] / Length[LengthLT200]) LT 0.6), PL6count, complement = PL6c, ncomplement = PL6ccount)
    IF (PL6count GT 0.0) THEN Calpha[6, LengthLT200[PL6]] = 0.5
    IF (PL6ccount GT 0.0) THEN Calpha[6, LengthLT200[PL6c]] = 0.; for emerals shiner
  ENDIF
  IF (LengthGE200count GT 0.0) THEN BEGIN
    PL6 = WHERE(((PL[6, LengthGE200] / Length[LengthGE200]) LT 0.4), PL6count, complement = PL6c, ncomplement = PL6ccount)
    IF (PL6count GT 0.0) THEN Calpha[6, LengthGE200[PL6]] = 0.5
    IF (PL6ccount GT 0.0) THEN Calpha[6, LengthGE200[PL6c]] = 0.; for emerald shiner
  ENDIF  
  
  IF (LengthLT200count GT 0.0) THEN BEGIN
    PL7 = WHERE(((PL[7, LengthLT200] / Length[LengthLT200]) LT 0.6), PL7count, complement = PL7c, ncomplement = PL7ccount)
    IF (PL7count GT 0.0) THEN Calpha[7, LengthLT200[PL7]] = 0.5
    IF (PL7ccount GT 0.0) THEN Calpha[7, LengthLT200[PL7c]] = 0.; for rainbow smelt
  ENDIF
  IF (LengthGE200count GT 0.0) THEN BEGIN
    PL7 = WHERE(((PL[7, LengthGE200] / Length[LengthGE200]) LT 0.4), PL7count, complement = PL7c, ncomplement = PL7ccount)
    IF (PL7count GT 0.0) THEN Calpha[7, LengthGE200[PL7]] = 0.5
    IF (PL7ccount GT 0.0) THEN Calpha[7, LengthGE200[PL7c]] = 0.00 ; for rainbow smelt
  ENDIF
  
   
  IF (LengthLT200count GT 0.0) THEN BEGIN
    PL8 = WHERE(((PL[8, LengthLT200] / Length[LengthLT200]) LT 0.6), PL8count, complement = PL8c, ncomplement = PL8ccount)
    IF (PL8count GT 0.0) THEN Calpha[8, LengthLT200[PL8]] = 0.5
    IF (PL8ccount GT 0.0) THEN Calpha[8, LengthLT200[PL8c]] = 0.00 ; for round goby
  ENDIF
  IF (LengthGE200count GT 0.0) THEN BEGIN
    PL8 = WHERE(((PL[8, LengthGE200] / Length[LengthGE200]) LT 0.4), PL8count, complement = PL8c, ncomplement = PL8ccount)
    IF (PL8count GT 0.0) THEN Calpha[8, LengthGE200[PL8]] = 0.5
    IF (PL8ccount GT 0.0) THEN Calpha[8, LengthGE200[PL8c]] = 0.00 ; for round goby
  ENDIF
  
  IF (LengthLT200count GT 0.0) THEN BEGIN
    PL9 = WHERE(((PL[9, LengthLT200] / Length[LengthLT200]) LT 0.6), PL9count, complement = PL9c, ncomplement = PL9ccount)
    IF (PL9count GT 0.0) THEN Calpha[9, LengthLT200[PL9]] = 0.5
    IF (PL9ccount GT 0.0) THEN Calpha[9, LengthLT200[PL9c]] = 0.00 ; for walleye
  ENDIF
  IF (LengthGE200count GT 0.0) THEN BEGIN
    PL9 = WHERE(((PL[9, LengthGE200] / Length[LengthGE200]) LT 0.4), PL9count, complement = PL9c, ncomplement = PL9ccount)
    IF (PL9count GT 0.0) THEN Calpha[9, LengthGE200[PL9]] = 0.5
    IF (PL9ccount GT 0.0) THEN Calpha[9, LengthGE200[PL9c]] = 0.00 ; for walleye
  ENDIF 
  ;PRINT, 'Chessons alpha'
  ;PRINT, Calpha
  ;IF YOYcount GT 0. THEN PRINT, CALPHA[5:9, YOY[0:99L]]

  ; Determine light effect
  ;IF(MAX(light) NE 0) THEN BEGIN;
  litfac = FLTARR(nWAE); a multiplication factor to include the effect of light intensity on RD 
  ;***litfac for walleye using "flicker frequency" from Ali & Ryder***. 
  ;LIGHT = LIGHT/100.; ************ADJUSTING LIGHT INTENSITY for SIMPLE 3D INPUTS****************************
  
   la = 0.0183877D
   lb = 0.39361465D
   lc = 0.0040855314D
   ld = -1.7306173D
   t1 = EXP(-1. * lb * (light - ld))
   t2 = EXP(-1. * lc * (light - ld))
   t3 = lc - lb
   litfac = (((la + lb) * (t1 - t2)) / t3)
  ;endif
;  PRINT, 'Light intensity (lux)'
;  PRINT, TRANSPOSE(light)
  ;PRINT, 'Light multiplication factor'
  ;PRINT, TRANSPOSE(litfac)
  
  
  ; Compute reactive distance (RD) of predator based on pred and prey lengths
 ;*****Reactive distance may be used for the movement decision************************************************************
  ; Calculate reactive distance in mm (from cm), Breck and Gitter. 1983.
  ; Calculate alpha = fish length function in reactive distance, RD
  alphaDig = FLTARR(nWAE)
  RD = FLTARR(m, nWAE)
  ;alphadig =  fish length function in reactive distance, RD
  IF (Lcount GT 0.0) THEN BEGIN
    ; For walleye <20mm
    alphaDig[L] = EXP(9.14 - 2.4 * ALOG(length[L]) + 0.229*(ALOG(length[L]))^2.0) / 60.0
    ;alphaRad = alphaDig*2*!PI/360
    
    ; RD = 0.5*PL/tan(2.0*!PI*(1.0/360.0)*alphaDig/2.0)
    RD[0, L] = 0.5 * PL[0, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac  
    RD[1, L] = 0.5 * PL[1, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[2, L] = 0.5 * PL[2, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[3, L] = 0.5 * PL[3, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * 0.36 * litfac; for benthic prey from Breck 1993
    RD[4, L] = 0.5 * PL[4, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac
    RD[5, L] = 0.5 * PL[5, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[6, L] = 0.5 * PL[6, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[7, L] = 0.5 * PL[7, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[8, L] = 0.5 * PL[8, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
    RD[9, L] = 0.5 * PL[9, L] / TAN(2.0 * !PI * (1.0/360.0) * alphaDig[L] / 2.0) * litfac 
  ENDIF
  
  IF (LLcount GT 0.0) THEN BEGIN
    ; For walleye >20mm
    ; RD equation for larger fishes from Guma'a 1993 -> based on perch 
    alphaDig[LL] = (168.8 - 0.94 * (length[LL] / 10.))
    alphaDig50 = WHERE((alphaDig[LL] LT 50.), alphaDig50count, complement = alphaDig50N, ncomplement = alphaDig50Ncount)
    IF (alphaDig50 GT 0.) THEN alphaDig[LL] = 50.
    alphaDig[LL] = alphaDig[LL]/60. * 3.14159/180.  ; alpha in min, convert to rad
    
    RD[0, LL] = PL[0, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[1, LL] = PL[1, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[2, LL] = PL[2, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[3, LL] = PL[3, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[4, LL] = PL[4, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[5, LL] = PL[5, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[6, LL] = PL[6, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[7, LL] = PL[7, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[8, LL] = PL[8, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
    RD[9, LL] = PL[9, LL] /(2.0 * TAN(alphaDig[LL] / 2.0)) * litfac 
  ENDIF
;  PRINT, 'alphaDig'
;  PRINT, (alphaDig)
;  PRINT, 'Reactive distance (RD, mm)'
;  PRINT, RD  

  ; Calculate reactive area in mm^2 for zoolplankton diet
  ; Include tubididty from Rose et al. 1996 for founder
  ;IF RD LT 15 THEN Frd = 0.8 - 0.025 * RD
  ;IF RD GE 15 THEN Frd = 0.4  
  ; endif

  
  ; For larval fish (less than 20mm) that can perceive one half of the circle defined by reactive distance
  prop = FLTARR(nWAE)
  Larva = WHERE(length LE 20.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
  IF (Larvacount GT 0.0) THEN prop[Larva] = 0.50 
  IF (JuvAducount GT 0.0) THEN prop[JuvAdu] = 1.0 
;  PRINT, 'Proporton of reactive distance'
;  PRINT, prop
  
  ; Reactive area (mm2)
  RA = FLTARR(m, nWAE)
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
  VS = FLTARR(m, nWAE); MULTIPLY BY 10.00^(-6.00) from mm3 to L OR mm2 to m2 
  VS[0,*] = DOUBLE(SS * RA[0,*] * 10.00^(-6.00))
  VS[1,*] = DOUBLE(SS * RA[1,*] * 10.00^(-6.00))
  VS[2,*] = DOUBLE(SS * RA[2,*] * 10.00^(-6.00))
  VS[3,*] = DOUBLE(SS * 2.0 * RD[3, *] * SIN(!PI/3.0) * 10.00^(-6.00)); Area for benthos from Breck 1993; VS[3,*] = SS * 2.0 * Frd * RD[3,*] with turbidity
  VS[4,*] = DOUBLE(SS * RA[4,*] * 10.00^(-6.00))
  
  VS[5,*] = DOUBLE(SS * RA[5,*] * 10.00^(-9.00)); mm3 to m3 for fish prey
  VS[6,*] = DOUBLE(SS * RA[6,*] * 10.00^(-9.00))
  VS[7,*] = DOUBLE(SS * RA[7,*] * 10.00^(-9.00))
  VS[8,*] = DOUBLE(SS * RA[8,*] * 10.00^(-9.00))
  VS[9,*] = DOUBLE(SS * RA[9,*] * 10.00^(-9.00))
;  PRINT, 'Volume searched (VS, L or m2 or m3 /s)'
;  PRINT, VS
  

; Calculate potential encounter rate # per secound
  ER = FLTARR(m, nWAE); uint
  ER[0,*] = CEIL(VS[0,*] * dens[0,*]); 
  ER[1,*] = CEIL(VS[1,*] * dens[1,*]); 
  ER[2,*] = CEIL(VS[2,*] * dens[2,*]); 
  ER[3,*] = CEIL(VS[3,*] * dens[3,*]); 
  ER[4,*] = CEIL(VS[4,*] * dens[4,*]); 
  ER[5,*] = CEIL(VS[5,*] * dens[5,*]); 
  ER[6,*] = CEIL(VS[6,*] * dens[6,*]); 
  ER[7,*] = CEIL(VS[7,*] * dens[7,*]); 
  ER[8,*] = CEIL(VS[8,*] * dens[8,*]); 
  ER[9,*] = CEIL(VS[9,*] * dens[9,*]); 
  ;PRINT, 'Encounter rate (ER, #/s)'
  ;PRINT, ER
  
  
  ;*****size-based inter-/intra-specific interactions and density dependence***
  ERP = FLTARR(10, nWAE); ENCOUNTER RATE FOR COMPETITORS
  ; ALL
  ERP[0, *] = CEIL(VS[5, *] * WAEpbio[25, *]); yellow perch
  ERP[1, *] = CEIL(VS[6, *] * WAEpbio[26, *]); emerald shiner
  ERP[2, *] = CEIL(VS[7, *] * WAEpbio[27, *]); rainbow smelt
  ERP[3, *] = CEIL(VS[8, *] * WAEpbio[28, *]); round goby
  ERP[4, *] = CEIL(VS[9, *] * WAEpbio[29, *]); walleye
  ; FORAGE FISH ONLY
  ERP[5, *] = CEIL(VS[5, *] * WAEpbio[35, *]); yellow perch
  ERP[6, *] = CEIL(VS[6, *] * WAEpbio[36, *]); emerald shiner
  ERP[7, *] = CEIL(VS[7, *] * WAEpbio[37, *]); rainbow smelt
  ERP[8, *] = CEIL(VS[8, *] * WAEpbio[38, *]); round goby
  ERP[9, *] = CEIL(VS[9, *] * WAEpbio[39, *]); walleye
  
  ERPintra = FLTARR(nWAE)
  ERPinter = FLTARR(nWAE)
  Age1plus = WHERE(WAE[1, *] GE MinLenPisc, Age1pluscount, complement = Age0, ncomplement = Age0count)
  IF Age0count GT 0. THEN BEGIN; larval and juvenile YOY
    ERPintra[Age0] = ERP[9, Age0] 
    ERPinter[Age0] = ERP[5, Age0] + ERP[6, Age0] + ERP[7, Age0] + ERP[8, Age0]
  ENDIF
  IF Age1pluscount GT 0. THEN BEGIN; Age1+ -> Not competing with forage fishes
    ERPintra[Age1plus] = ERP[4, Age1plus] - ERP[9, Age1plus]
    ERPinter[Age1plus] = ERP[0, Age1plus] - ERP[5, Age1plus]
  ENDIF
;  PRINT, 'Competitor encounter rate (ERP, #/s)'
;  PRINT, ERP
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  PRINT, TRANSPOSE(ERPintra)
;  PRINT, 'Interspecific competitor encounter rate (ERPinter, #/s)'
;  PRINT, TRANSPOSE(ERPinter)
  
  
; Calculate handling time in s
;*****HandLing time should not exceed ts*******
  ;**********Handling time parameters are calibrated for LARVAL YELLOW PERCH******
  L = TRANSPOSE(length)
  HT = FLTARR(m, nWAE) 
  SumHT = FLTARR(nWAE) 
  ;HTsl = FLTARR(nWAE)
     
  HTint = 0.264; for LARVAL YELLOW PERCH
  ;HTsl = 7.0151; for LARVAL YELLOW PERCH
  HTsl = 2.315; MODIFIRED TO ALLOW YOY TO FEED ON FISH PREY
  
  
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
  HT[9, *] = EXP(HTint * 10.^(HTsl * (PL[9, *]/l))) 
  HT9 = WHERE(HT[9, *] GT tss, HT9count, complement = HT9c, ncomplement = HT9ccount)
  IF (HT9count GT 0.0) THEN HT[9, HT9] = tss
  IF (HT9ccount GT 0.0) THEN HT[9, HT9c] = HT[9, HT9c] 
  ;PRINT, 'Expected handling time per prey (HT, s)'
  ;PRINT, HT
  ;IF YOYcount GT 0. THEN PRINT, HT[0:9, YOY[0:99L]]        

  SumHT[*] = HT[0,*] + HT[1,*] + HT[2,*] + HT[3,*] + HT[4,*] + HT[5,*] + HT[6,*] + HT[7,*] + HT[8,*] + HT[9,*]
;  PRINT, 'Expected total handling time (SumHT, s)'
;  PRINT, SumHT
  
  
; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(nWAE); total number of all prey atacked and captured
  t = FLTARR(m, nWAE); total number of each prey atacked and captured
  ;LengthLT30 = WHERE((Length LT 30.0), LengthLT30count, complement = LengthGE30, ncomplement = LengthGE30count)
;  IF (LengthLT30count GT 0.0) THEN BEGIN
;    t[0,LengthLT30] = (Calpha[0,LengthLT30] * dens[0,LengthLT30])
;    t[1,LengthLT30] = (Calpha[1,LengthLT30] * dens[1,LengthLT30])
;    t[2,LengthLT30] = (Calpha[2,LengthLT30] * dens[2,LengthLT30])
;    t[3,LengthLT30] = (Calpha[3,LengthLT30] * dens[3,LengthLT30])
;    t[4,LengthLT30] = (Calpha[4,LengthLT30] * dens[4,LengthLT30])
;    t[5,LengthLT30] = (Calpha[5,LengthLT30] * dens[5,LengthLT30])
;    t[6,LengthLT30] = (Calpha[6,LengthLT30] * dens[6,LengthLT30])
;    t[7,LengthLT30] = (Calpha[7,LengthLT30] * dens[7,LengthLT30])
;    t[8,LengthLT30] = (Calpha[8,LengthLT30] * dens[8,LengthLT30])
;    t[9,LengthLT30] = (Calpha[9,LengthLT30] * dens[9,LengthLT30])
;  ENDIF
;  IF (LengthGE30count GT 0.0) THEN BEGIN  
;    t[0,LengthGE30] = (Calpha[0,LengthGE30] * dens[0,LengthGE30] * PW[0, LengthGE30])
;    t[1,LengthGE30] = (Calpha[1,LengthGE30] * dens[1,LengthGE30] * PW[1, LengthGE30])
;    t[2,LengthGE30] = (Calpha[2,LengthGE30] * dens[2,LengthGE30] * PW[2, LengthGE30])
;    t[3,LengthGE30] = (Calpha[3,LengthGE30] * dens[3,LengthGE30] * PW[3, LengthGE30])
;    t[4,LengthGE30] = (Calpha[4,LengthGE30] * dens[4,LengthGE30] * PW[4, LengthGE30])
;    t[5,LengthGE30] = (Calpha[5,LengthGE30] * dens[5,LengthGE30] * PW[5, LengthGE30])
;    t[6,LengthGE30] = (Calpha[6,LengthGE30] * dens[6,LengthGE30] * PW[6, LengthGE30])
;    t[7,LengthGE30] = (Calpha[7,LengthGE30] * dens[7,LengthGE30] * PW[7, LengthGE30])
;    t[8,LengthGE30] = (Calpha[8,LengthGE30] * dens[8,LengthGE30] * PW[8, LengthGE30])
;    t[9,LengthGE30] = (Calpha[9,LengthGE30] * dens[9,LengthGE30] * PW[9, LengthGE30])
;  ENDIF
  t[0, *] = Calpha[0, *] * dens[0, *] * PW[0, *]
  t[1, *] = Calpha[1, *] * dens[1, *] * PW[1, *]
  t[2, *] = Calpha[2, *] * dens[2, *] * PW[2, *]
  t[3, *] = Calpha[3, *] * dens[3, *] * PW[3, *]
  t[4, *] = Calpha[4, *] * dens[4, *] * PW[4, *]
  t[5, *] = Calpha[5, *] * dens[5, *] * PW[5, *]
  t[6, *] = Calpha[6, *] * dens[6, *] * PW[6, *]
  t[7, *] = Calpha[7, *] * dens[7, *] * PW[7, *]
  t[8, *] = Calpha[8, *] * dens[8, *] * PW[8, *]
  t[9, *] = Calpha[9, *] * dens[9, *] * PW[9, *]
  TOT[*] = t[0,*] + t[1,*] + t[2,*] + t[3,*] + t[4,*] + t[5,*] + t[6,*] + t[7,*] + t[8,*] + t[9,*]
;  PRINT, 'Proportion of each prey item attcked and captured (t)'
;  PRINT, t
  ;PRINT, 'Proportion of all prey items attcked and captured (tot)'
;  PRINT, TOT
;IF YOYcount GT 0. THEN PRINT, T[0:9, YOY[0:99L]]        

  Q = FLTARR(m,nWAE); Probability of attack and capture
  TOTNZ = WHERE(TOT[*] GT 0.0, TOTNZcount, complement = TOTZ, ncomplement = TOTZcount)
  ; If no prey is available in a cell, Q = 0
  IF TOTNZcount GT 0.0 THEN BEGIN
    Q[0,TOTNZ] = DOUBLE(t[0,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[1,TOTNZ] = DOUBLE(t[1,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[2,TOTNZ] = DOUBLE(t[2,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[3,TOTNZ] = DOUBLE(t[3,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[4,TOTNZ] = DOUBLE(t[4,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[5,TOTNZ] = DOUBLE(t[5,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[6,TOTNZ] = DOUBLE(t[6,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[7,TOTNZ] = DOUBLE(t[7,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[8,TOTNZ] = DOUBLE(t[8,TOTNZ] / TOT[TOTNZ]) < 1.
    Q[9,TOTNZ] = DOUBLE(t[9,TOTNZ] / TOT[TOTNZ]) < 1.
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
    Q[9,TOTZ] = 0.0
  ENDIF
  ;PRINT, 'Probability of attack and cature (Q) without temperature and DO effect'
  ;PRINT, Q
  ;IF YOYcount GT 0. THEN PRINT, Q[0:9, YOY[0:99L]]  
  
; Calculate the number of each prey consumed 
  E = FLTARR(m, nWAE); encounter rate in individuals/ts
  EPintra = FLTARR(nWAE); encounter rate in individuals
  EPinter = FLTARR(nWAE); encounter rate in individuals
  NumP = FLTARR(m, nWAE); total number consumed per time step
  FOR ind = 0L, nWAE - 1L DO BEGIN ; for each superindividual
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
    IF ER[9, ind] GT 0. THEN E[9, ind] = RANDOMU(seed, POISSON = [ER[9, ind]], /double)
    
    IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
    IF ERPinter[ind] GT 0. THEN EPinter[ind] = RANDOMU(seed, POISSON = [ERPinter[ind]], /double)
    
    ; Stochastic estimates for the number and type of prey based on E from binomial distriution
    IF E[0, ind] GT 0. AND Q[0, ind] GT 0. THEN NumP[0, ind] = (RANDOMU(seed, BINOMIAL = [E[0, ind], Q[0, ind]], /double))
    IF E[1, ind] GT 0. AND Q[1, ind] GT 0. THEN NumP[1, ind] = (RANDOMU(seed, BINOMIAL = [E[1, ind], Q[1, ind]], /double))
    IF E[2, ind] GT 0. AND Q[2, ind] GT 0. THEN NumP[2, ind] = (RANDOMU(seed, BINOMIAL = [E[2, ind], Q[2, ind]], /double))
    IF E[3, ind] GT 0. AND Q[3, ind] GT 0. THEN NumP[3, ind] = (RANDOMU(seed, BINOMIAL = [E[3, ind], Q[3, ind]], /double))
    IF E[4, ind] GT 0. AND Q[4, ind] GT 0. THEN NumP[4, ind] = (RANDOMU(seed, BINOMIAL = [E[4, ind], Q[4, ind]], /double))
    IF E[5, ind] GT 0. AND Q[5, ind] GT 0. THEN NumP[5, ind] = (RANDOMU(seed, BINOMIAL = [E[5, ind], Q[5, ind]], /double))
    IF E[6, ind] GT 0. AND Q[6, ind] GT 0. THEN NumP[6, ind] = (RANDOMU(seed, BINOMIAL = [E[6, ind], Q[6, ind]], /double))
    IF E[7, ind] GT 0. AND Q[7, ind] GT 0. THEN NumP[7, ind] = (RANDOMU(seed, BINOMIAL = [E[7, ind], Q[7, ind]], /double))
    IF E[8, ind] GT 0. AND Q[8, ind] GT 0. THEN NumP[8, ind] = (RANDOMU(seed, BINOMIAL = [E[8, ind], Q[8, ind]], /double))         
    IF E[9, ind] GT 0. AND Q[9, ind] GT 0. THEN NumP[9, ind] = (RANDOMU(seed, BINOMIAL = [E[9, ind], Q[9, ind]], /double))          
  ENDFOR
;  PRINT, 'Realized encounter rate (E, #/ts)'
;;  PRINT, E
;IF YOYcount GT 0. THEN PRINT, E[0:9, YOY[0:99L]]
;  PRINT, 'Stochastic potential number of prey consumed (NumP)'
;;  PRINT, NumP
;IF YOYcount GT 0. THEN PRINT, NUMP[0:9, YOY[0:99L]]  
  
  
  SD = FLTARR(m, nWAE); handling time (HT) > ts, then no conumption during each time step 
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
  HT6 = WHERE(HT[6, *] EQ tss, HT6count, complement = HT6c, ncomplement = HT6ccount)
  IF (HT6count GT 0.0) THEN SD[6, HT6] = 0.0 
  IF (HT6ccount GT 0.0) THEN SD[6, HT6c] =  E[6, HT6c] * Q[6, HT6c] * HT[6, HT6c];
  HT7 = WHERE(HT[7, *] EQ tss, HT7count, complement = HT7c, ncomplement = HT7ccount)
  IF (HT7count GT 0.0) THEN SD[7, HT7] = 0.0 
  IF (HT7ccount GT 0.0) THEN SD[7, HT7c] =  E[7, HT7c] * Q[7, HT7c] * HT[7, HT7c];
  HT8 = WHERE(HT[8, *] EQ tss, HT8count, complement = HT8c, ncomplement = HT8ccount)
  IF (HT8count GT 0.0) THEN SD[8, HT8] = 0.0 
  IF (HT8ccount GT 0.0) THEN SD[8, HT8c] =  E[8, HT8c] * Q[8, HT8c] * HT[8, HT8c];
  HT9 = WHERE(HT[9, *] EQ tss, HT9count, complement = HT9c, ncomplement = HT9ccount)
  IF (HT9count GT 0.0) THEN SD[9, HT9] = 0.0 
  IF (HT9ccount GT 0.0) THEN SD[9, HT9c] =  E[9, HT9c] * Q[9, HT9c] * HT[9, HT9c];
;  PRINT, 'SD'
;;  PRINT, SD
;IF YOYcount GT 0. THEN PRINT, sd[0:9, YOY[0:99L]]  

  SumDen = FLTARR(nWAE)
  SumDen[*] = SD[0, *] + SD[1, *] + SD[2, *] + SD[3, *] + SD[4, *] + SD[5, *] + SD[6, *] + SD[7, *] + SD[8, *] + SD[9, *]
;  PRINT, 'SumDen'
;  PRINT, SumDen


;calculate total grams for each prey type consumed 
 ; IF handlign time is greater than ts, no consumption
  cons = FLTARR(m, nWAE)
  cons[0,*] = DOUBLE(pw[0,*] * Nump[0,*]) ;total grams consumed  
  cons[1,*] = DOUBLE(pw[1,*] * Nump[1,*]) ;total grams consumed  
  cons[2,*] = DOUBLE(pw[2,*] * Nump[2,*]) ;total grams consumed  
  HT3 = WHERE(HT[3, *] EQ tss, HT3count, complement = HT3c, ncomplement = HT3ccount)
  IF (HT3count GT 0.0) THEN cons[3, HT3] = 0.0 
  IF (HT3ccount GT 0.0) THEN cons[3, HT3c] = DOUBLE(PW[3, HT3c] * Nump[3,HT3c])
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
  HT9 = WHERE(HT[9, *] EQ tss, HT9count, complement = HT9c, ncomplement = HT9ccount)
  IF (HT9count GT 0.0) THEN cons[9, HT9] = 0.0 
  IF (HT9ccount GT 0.0) THEN cons[9, HT9c] = DOUBLE(PW[9, HT9c] * Nump[9, HT9c]) 
;  PRINT, 'Potential amount of each prey type consumed (cons, g)'
;  ;PRINT, cons
; IF YOYcount GT 0. THEN PRINT, CONS[0:9, YOY[0:99L]]       
        
   ; consumption for each prey type accounting for foraging in g in time step from HT
;  PRINT, 'Realised intraspecific competitor encounter rate (EPintra, #/s)'
;  PRINT, (EPintra[0:100])
;  PRINT, 'Realised interspecific competitor encounter rate (EPinter, #/s)'
;  PRINT, (EPinter[0:100])  

  ; without competition********************* NO DENSITY-DEPENDENCE**************************
;  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[9, tds] = DOUBLE((Cons[9, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
; ; PRINT, 'Consumption per prey (C, g/ts)'
; ; PRINT, C


  ; Use biomass for inter- and intra- specific interactions
  densPintra = FLTARR(nWAE)
  densPinter = FLTARR(nWAE)
  IF Age0count GT 0. THEN BEGIN; YOY
    densPintra[Age0] = WAEpbio[44, Age0]
    densPinter[Age0] = WAEpbio[40, Age0] + WAEpbio[41, Age0] + WAEpbio[42, Age0] + WAEpbio[43, Age0]
  ENDIF
  IF Age1pluscount GT 0. THEN BEGIN; Age1+
    densPintra[Age1plus] = WAEpbio[34, Age1plus] - WAEpbio[44, Age1plus]
    densPinter[Age1plus] = WAEpbio[30, Age1plus] - WAEpbio[40, Age1plus]; yellow perch only
  ENDIF 
  
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
  C[9, tds] = DOUBLE((Cons[9, tds] / (1.0 + SumDen[tds] + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds]))* 60.0 * ts)
;  PRINT, 'Consumption per prey (C, g/ts)'
  ;PRINT, C[*, 0:100]
  
  
;  ; With high competition - Crowley-Matin model
;  C[0, tds] = DOUBLE((Cons[0, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[6, tds] = DOUBLE((Cons[6, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[7, tds] = DOUBLE((Cons[7, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[8, tds] = DOUBLE((Cons[8, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  C[9, tds] = DOUBLE((Cons[9, tds] / ((1.0 + SumDen[tds]) * (1.0 + EPintra[tds] * densPintra[tds] + EPinter[tds] * densPinter[tds])))* 60.0 * ts)
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C[*, 0:100]
;;  PRINT, 'Volume searched (VS, L or m2 /s)'
;;  PRINT, VS
;   PRINT, 'densPintra'
;   PRINT, densPintra[0:100]
;   PRINT, 'densPinter'
;   PRINT, densPinter[0:100]

   TotCts[tds]= DOUBLE(C[0,tds] + C[1, tds] + C[2, tds] + C[3, tds] + C[4, tds] $
                + C[5, tds] + C[6, tds] + C[7, tds] + C[8, tds] + C[9, tds])
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, (TotCts)


  Cratio = FLTARR(m, nWAE); PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
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
    Cratio[9, TotCtsNZ] = DOUBLE(C[9, TotCtsNZ] / TotCts[TotCtsNZ])
  ENDIF

  
  ; Determine potential stomach weight in g after the current time step
  potst = FLTARR(m, nWAE)
  TotPotSt = FLTARR(nWAE)
  Potst[0, tds] = C[0, tds] + CAftDig0[tds]
  Potst[1, tds] = C[1, tds] + CAftDig1[tds]
  Potst[2, tds] = C[2, tds] + CAftDig2[tds]
  Potst[3, tds] = C[3, tds] + CAftDig3[tds]
  Potst[4, tds] = C[4, tds] + CAftDig4[tds]
  Potst[5, tds] = C[5, tds] + CAftDig5[tds]
  Potst[6, tds] = C[6, tds] + CAftDig6[tds]
  Potst[7, tds] = C[7, tds] + CAftDig7[tds]
  Potst[8, tds] = C[8, tds] + CAftDig8[tds]
  potst[9, tds] = C[9, tds] + CAftDig9[tds]
  
  TotPotSt[tds] = DOUBLE(PotSt[0,tds] + Potst[1, tds] + potst[2, tds] + potst[3, tds] + potst[4, tds] + potst[5, tds] $
                  + potst[6, tds] + potst[7, tds] + potst[8, tds] + potst[9, tds])
  ;possible cons + what is left in the stomach
;  PRINT, 'Potential stomach weight per prey (g)'
;  PRINT, Potst
;  PRINT, 'Potential total stomach weight (g)'
;  PRINT, TotPotSt
  
  
  ; Check if potential stomach weight is greater than stomach capacity
  Nstom = FLTARR(nWAE)
  Premove = FLTARR(nWAE)
  TotCAftDig = FLTARR(nWAE)
  RemCAftDig = FLTARR(nWAE)
  RemCAftDig0 = FLTARR(nWAE)
  RemCAftDig1 = FLTARR(nWAE)
  RemCAftDig2 = FLTARR(nWAE)
  RemCAftDig3 = FLTARR(nWAE)
  RemCAftDig4 = FLTARR(nWAE)
  RemCAftDig5 = FLTARR(nWAE)
  RemCAftDig6 = FLTARR(nWAE)
  RemCAftDig7 = FLTARR(nWAE)
  RemCAftDig8 = FLTARR(nWAE)
  RemCAftDig9 = FLTARR(nWAE)
;    PRINT, 'Stomach capacity'
;    PRINT, TRANSPOSE(StCap)

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
     
  ; Determine additional amount needed to remove for previously undigested food
    TotCAftDig[P] = CAftDig0[p] + CAftDig1[p] + CAftDig2[p] + CAftDig3[p] $
               + CAftDig4[p] + CAftDig5[p] + CAftDig6[p] + CAftDig7[p] + CAftDig8[p] + CAftDig9[p]
    RemCAftDig[P] = TotCAftDig[P] - TotCAftDig[P] * Premove[P]; ***SUBSCRIPT P ONLY**** 
    ; the total amount of food needed to remove for previously undigested food 
    RemCAftDig0[P] = RemCAftDig[P] * Cratio[0, P]
    RemCAftDig1[P] = RemCAftDig[P] * Cratio[1, P]
    RemCAftDig2[P] = RemCAftDig[P] * Cratio[2, P]
    RemCAftDig3[P] = RemCAftDig[P] * Cratio[3, P]
    RemCAftDig4[P] = RemCAftDig[P] * Cratio[4, P]
    RemCAftDig5[P] = RemCAftDig[P] * Cratio[5, P]
    RemCAftDig6[P] = RemCAftDig[P] * Cratio[6, P]
    RemCAftDig7[P] = RemCAftDig[P] * Cratio[7, P]
    RemCAftDig8[P] = RemCAftDig[P] * Cratio[8, P]
    RemCAftDig9[P] = RemCAftDig[P] * Cratio[9, P]
    
  ; remove the additional amount of consumed food for the previously undigested
  ; excess food can be removed only from the food consumed in the current time step
    C[0, p] = DOUBLE(Premove[P] * C[0, p] - RemCAftDig0[P]) ;new g of prey after removing specific prey item...
    C[1, p] = DOUBLE(Premove[P] * C[1, p] - RemCAftDig1[P])
    C[2, p] = DOUBLE(Premove[P] * C[2, p] - RemCAftDig2[P])
    C[3, p] = DOUBLE(Premove[P] * C[3, p] - RemCAftDig3[P])
    C[4, p] = DOUBLE(Premove[P] * C[4, p] - RemCAftDig4[P])
    C[5, p] = DOUBLE(Premove[P] * C[5, p] - RemCAftDig5[P])
    C[6, p] = DOUBLE(Premove[P] * C[6, p] - RemCAftDig6[P])
    C[7, p] = DOUBLE(Premove[P] * C[7, p] - RemCAftDig7[P])
    C[8, p] = DOUBLE(Premove[P] * C[8, p] - RemCAftDig8[P])
    C[9, p] = DOUBLE(Premove[P] * C[9, p] - RemCAftDig9[P])
   
    TotCts[P]= DOUBLE(C[0,P] + C[1, P] + C[2, P] + C[3, P] + C[4, P] + $
               C[5, P] + C[6, P] + C[7, P] + C[8, P] + C[9, P])
               
  ;    PRINT, 'Consumption per prey after adjusting for overconsumption (C, g/ts)'
  ;    PRINT, TRANSPOSE(C)
  ;    PRINT, 'Total consumption after adjusting for overconsumption (TotCts, g/ts)'
  ;    PRINT, (TotCts)
  
    ; determine prey-specific weight adjusted for overconsumption
    Potst[0, p] = C[0, P] + CAftDig0[P]
    Potst[1, p] = C[1, P] + CAftDig1[P]
    Potst[2, p] = C[2, P] + CAftDig2[P]
    Potst[3, P] = C[3, P] + CAftDig3[P]
    Potst[4, P] = C[4, P] + CAftDig4[P]
    Potst[5, P] = C[5, P] + CAftDig5[P]
    Potst[6, P] = C[6, P] + CAftDig6[P]
    Potst[7, P] = C[7, P] + CAftDig7[P]
    Potst[8, P] = C[8, P] + CAftDig8[P]
    Potst[9, P] = C[9, P] + CAftDig9[P]
    
    TotPotSt[P] = DOUBLE(PotSt[0,P] + Potst[1, P] + potst[2, P] + potst[3, P] + potst[4, P] + potst[5, P] $
                  + potst[6, P] + potst[7, P] + potst[8, P] + potst[9, P]);
    Nstom[P] = TotPotSt[P]
  ;    PRINT, 'Potential stomach weight per prey (g) AFTER adjusting for overconsumption'
  ;    PRINT, Potst
  ;    PRINT, 'Potential total stomach weight (g) AFTER adjusting for overconsumption'
  ;    PRINT, TotPotSt
  ENDIF
    ;PRINT, 'New stomach content (g) before digestion'
    ;PRINT, Nstom
;    Czoopl1 = C[0, tds]
;    Czoopl2 = C[1, tds]
;    Czoopl3 = C[2, tds]
    ;PRINT, 'Czoopl =', Czoopl1


; Temperature-dependent digestion and gut evacuation
  ;Gut evacuation rate, R, for Walleye from walleye larvae from Johnston and Mathias, Journal of Fish Biology (1996) 49, 375–389
  Larva2 = WHERE(WAE[1, *] LT 43., Larva2count, COMPLEMENT = JuvAdlt2, NCOMPLEMENT = JuvAdlt2count)
  IF Larva2count GT 0. THEN WAEGutEvacR[Larva2] = EXP(-14.5 + 1.33 * Temp[Larva2] - 0.0329 * Temp[Larva2]^2.- 0.0157*Temp[Larva2] * ALOG(WAE[2, Larva2])) / 60. / 1. * fDOfc2[Larva2]; in g/min temperature-dependent
  IF JuvAdlt2count GT 0. THEN WAEGutEvacR[JuvAdlt2] = EXP(-14.5 + 1.33 * Temp[JuvAdlt2] - 0.0329 * Temp[JuvAdlt2]^2.- 0.0157*Temp[JuvAdlt2] * ALOG(WAE[2, JuvAdlt2])) / 60. /1. * fDOfc2[JuvAdlt2]; in g/min temperature-dependent
  
  ;WAE[2, *] = WEIGHT-> dry weight mg ( * 0.1 * 1000.)

  ; Food digeseted over time step
;  PRINT, 'Prey specific stomach content before Digestion'
;  PRINT, PotSt[*, tds]

  ; Digestion and evacuation of each prey from current and previous ts
  CAftDig[0, tds] = (CAftDig0[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[0, tds]) * EXP(-WAEGutEvacR[tds] * ts));
  CAftDig[1, tds] = (CAftDig1[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[1, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[2, tds] = (CAftDig2[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[2, tds]) * EXP(-WAEGutEvacR[tds] * ts));
  CAftDig[3, tds] = (CAftDig3[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[3, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[4, tds] = (CAftDig4[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[4, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[5, tds] = (CAftDig5[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[5, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[6, tds] = (CAftDig6[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[6, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[7, tds] = (CAftDig7[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[7, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[8, tds] = (CAftDig8[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[8, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 
  CAftDig[9, tds] = (CAftDig9[tds] * EXP(-WAEGutEvacR[tds] * ts) + (C[9, tds]) * EXP(-WAEGutEvacR[tds] * ts)); 

  DigestedFood[0, tds] = DOUBLE(potst[0, tds] - CAftDig[0, tds])
  DigestedFood[1, tds] = DOUBLE(potst[1, tds] - CAftDig[1, tds])
  DigestedFood[2, tds] = DOUBLE(potst[2, tds] - CAftDig[2, tds])
  DigestedFood[3, tds] = DOUBLE(potst[3, tds] - CAftDig[3, tds])
  DigestedFood[4, tds] = DOUBLE(potst[4, tds] - CAftDig[4, tds])
  DigestedFood[5, tds] = DOUBLE(potst[5, tds] - CAftDig[5, tds])
  DigestedFood[6, tds] = DOUBLE(potst[6, tds] - CAftDig[6, tds])
  DigestedFood[7, tds] = DOUBLE(potst[7, tds] - CAftDig[7, tds])
  DigestedFood[8, tds] = DOUBLE(potst[8, tds] - CAftDig[8, tds])
  DigestedFood[9, tds] = DOUBLE(potst[9, tds] - CAftDig[9, tds])


  ; Determine total non-digested stomach weight in g after each time step
  potstAftDig[tds] = DOUBLE(CAftDig[0,tds] + CAftDig[1,tds] + CAftDig[2,tds] + CAftDig[3,tds] + CAftDig[4,tds] + CAftDig[5,tds]$
                   + CAftDig[6,tds] + CAftDig[7,tds] + CAftDig[8,tds] + CAftDig[9,tds]);
  NewStom[tds] = (PotStAftDig[tds]); tds = TotCday < YPcmx

  
  ; Determine daily cumulative food consumption 
  TotCday[tds] = TotCday[tds] + TotCts[tds]
  TotC[0, tds] = C[0, tds] + TotC0[tds]
  TotC[1, tds] = C[1, tds] + TotC1[tds]
  TotC[2, tds] = C[2, tds] + TotC2[tds]
  TotC[3, tds] = C[3, tds] + TotC3[tds]
  TotC[4, tds] = C[4, tds] + TotC4[tds]
  TotC[5, tds] = C[5, tds] + TotC5[tds]
  TotC[6, tds] = C[6, tds] + TotC6[tds]
  TotC[7, tds] = C[7, tds] + TotC7[tds]
  TotC[8, tds] = C[8, tds] + TotC8[tds]
  TotC[9, tds] = C[9, tds] + TotC9[tds]
;  PRINT, 'Total daily cumulative consumption (TotCday, g/day)'
;  PRINT, TRANSPOSE(totcday)
;  PRINT, 'Daily cumulative consumption for each prey (TotC, g/day)'
;  PRINT, (TotC)
;  VerSize = FLTARR(nWAE)

ENDIF;****************************************************************************************************************************


;*********If the previous stomach content is larger than CMAX -> No consumption - digestion/evacuation only***********************
PRINT, 'Number of fish with full stomach or Cmax =', dcount

IF (dcount GT 0.0) THEN BEGIN; dcount = totcday > YPcmx 
  ; Digestion and evacuation for each prey item
  Larva2 = WHERE(WAE[1, *] LT 43., Larva2count, COMPLEMENT = JuvAdlt2, NCOMPLEMENT = JuvAdlt2count)
  IF Larva2count GT 0. THEN WAEGutEvacR[Larva2] = EXP(-14.5 + 1.33 * Temp[Larva2] - 0.0329 * Temp[Larva2]^2.- 0.0157*Temp[Larva2] * ALOG(WAE[2, Larva2])) / 60. / 1. * fDOfc2[Larva2]; in g/min temperature-dependent
  IF JuvAdlt2count GT 0. THEN WAEGutEvacR[JuvAdlt2] = EXP(-14.5 + 1.33 * Temp[JuvAdlt2] - 0.0329 * Temp[JuvAdlt2]^2.- 0.0157*Temp[JuvAdlt2] * ALOG(WAE[2, JuvAdlt2])) / 60. / 1. * fDOfc2[JuvAdlt2]; in g/min temperature-dependent
  
  CAftDig[0,d] = DOUBLE(CAftDig0[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[1,d] = DOUBLE(CAftDig1[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[2,d] = DOUBLE(CAftDig2[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[3,d] = DOUBLE(CAftDig3[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[4,d] = DOUBLE(CAftDig4[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[5,d] = DOUBLE(CAftDig5[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[6,d] = DOUBLE(CAftDig6[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[7,d] = DOUBLE(CAftDig7[d] * EXP(-WAEGutEvacR[d] * ts));
  CAftDig[8,d] = DOUBLE(CAftDig8[d] * EXP(-WAEGutEvacR[d] * ts)); 
  CAftDig[9,d] = DOUBLE(CAftDig9[d] * EXP(-WAEGutEvacR[d] * ts)); 


  ; Determine total non-digested stomach content in g after time step
  PotStAftDig[d] = DOUBLE(CAftDig[0,d] + CAftDig[1,d] + CAftDig[2,d] + CAftDig[3,d] + CAftDig[4,d] + CAftDig[5,d]$
                   + CAftDig[6,d] + CAftDig[7,d] + CAftDig[8,d]+ CAftDig[9,d]);
  NewStom[d] = PotStAftDig[d]


  ; DigestedFood per time step
  DigestedFood[0,d] = DOUBLE(CAftDig0[d] - CAftDig[0,d])
  DigestedFood[1,d] = DOUBLE(CAftDig1[d] - CAftDig[1,d])
  DigestedFood[2,d] = DOUBLE(CAftDig2[d] - CAftDig[2,d])
  DigestedFood[3,d] = DOUBLE(CAftDig3[d] - CAftDig[3,d])
  DigestedFood[4,d] = DOUBLE(CAftDig4[d] - CAftDig[4,d])
  DigestedFood[5,d] = DOUBLE(CAftDig5[d] - CAftDig[5,d])
  DigestedFood[6,d] = DOUBLE(CAftDig6[d] - CAftDig[6,d])
  DigestedFood[7,d] = DOUBLE(CAftDig7[d] - CAftDig[7,d])
  DigestedFood[8,d] = DOUBLE(CAftDig8[d] - CAftDig[8,d])
  DigestedFood[9,d] = DOUBLE(CAftDig9[d] - CAftDig[9,d])


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
  TotC[9, d] = TotC9[d]
ENDIF;****************************************************************************************************************************

;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, (DigestedFood[*, *])

;PRINT, 'Undigested prey items (CAftDig, g)'
;PRINT, CAftDig[*, *]  
;PRINT, 'Total non-digested stomach content (potstAftDig, g)'
;PRINT, (potstAftDig[*])
;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Total daily cumulative consumption (g/day)'
;PRINT, (TotCday[*])

;VerSize = (Grid2D[3, WAE[13, *]]/20.)*1000.; individual cell depth in mm, there are always 20 vertical cells.
;CellDepth = (VerSize[*]/1000.)
;;PRINT, 'Cell depth (m)'
;;PRINT, CellDepth
;ZooplBio1 = DOUBLE((WAE[15,*])*4000000000D*(VerSize[*]/1000.)); g per cell of 2km x 2km x depth from g/L 
;ZooplBio2 = DOUBLE((WAE[16,*])*4000000000D*(VerSize[*]/1000.)); g per cell of 2km x 2km x depth from g/L 
;ZooplBio3 = DOUBLE((WAE[17,*])*4000000000D*(VerSize[*]/1000.)); g per cell of 2km x 2km x depth from g/L 
;ZooplBioAft1 = ZooplBio1 - C[0,*]*WAE[0,*]; Czoopl1 = g per individual
;ZooplBioAft2 = ZooplBio2 - C[1,*]*WAE[0,*];
;ZooplBioAft3 = ZooplBio3 - C[2,*]*WAE[0,*];
;PRINT, 'ZooplBio2'
;PRINT, TRANSPOSE(ZooplBio2)
;PRINT, 'Czoopl2*YP[0,*]'
;PRINT, TRANSPOSE(C[2,*]*WAE[0,*])
;PRINT, 'ZooplBioAft2'
;PRINT, TRANSPOSE(ZooplBioAft2)


consumption = FLTARR(55, nWAE)
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
consumption[9,*] = DigestedFood[9,*]; g digested for each prey type

consumption[10,*] = NewStom[*]; new weight of stomach content
consumption[11,*] = TotCday[*]; new total cumulative consumption after time step (= 6 min) need to be updated every 24h

; undigested food in the stomach carried over to the next time step
consumption[12,*] = CAftDig[0,*]; + CAftDig6[0,*]
consumption[13,*] = CAftDig[1,*]; + CAftDig6[1,*]
consumption[14,*] = CAftDig[2,*]; + CAftDig6[2,*]
consumption[15,*] = CAftDig[3,*]; + CAftDig6[3,*]
consumption[16,*] = CAftDig[4,*]; + CAftDig6[4,*]
consumption[17,*] = CAftDig[5,*]; + CAftDig6[5,*]
consumption[18,*] = CAftDig[6,*]; + CAftDig6[3,*]
consumption[19,*] = CAftDig[7,*]; + CAftDig6[4,*]
consumption[20,*] = CAftDig[8,*]; + CAftDig6[5,*]
consumption[21,*] = CAftDig[9,*]; + CAftDig6[5,*]

; The amount of each prey consumed per time step
consumption[22,*] = C[0,*]; 
consumption[23,*] = C[1,*];
consumption[24,*] = C[2,*]; 
consumption[25,*] = C[3,*]; 
consumption[26,*] = C[4,*]; 
consumption[27,*] = C[5,*]; 
consumption[28,*] = C[6,*]; 
consumption[29,*] = C[7,*]; 
consumption[30,*] = C[8,*];
consumption[31,*] = C[9,*];

; Total amount of prey consumed after time step (= 6 min) need to be updated every 24h
consumption[32,*] = TotC[0,*]; total amount of daily consumption 
consumption[33,*] = TotC[1,*]; total amount of daily consumption 
consumption[34,*] = TotC[2,*]; total amount of daily consumption 
consumption[35,*] = TotC[3,*]; total amount of daily consumption 
consumption[36,*] = TotC[4,*]; total amount of daily consumption 
consumption[37,*] = TotC[5,*]; total amount of daily consumption 
consumption[38,*] = TotC[6,*]; total amount of daily consumption 
consumption[39,*] = TotC[7,*]; total amount of daily consumption 
consumption[40,*] = TotC[8,*]; total amount of daily consumption 
consumption[41,*] = TotC[9,*]; total amount of daily consumption 

consumption[42,*] = C[0,*]+C[1,*]+C[2,*]; Total zooplankton consumption by superindividuals (x N)
;consumption[43,*] = ZooplBioAft1+ZooplBioAft2+ZooplBioAft3; Total zooplankton available in each cell AFTER fish feeding

; The NUMBER of each prey consumed per time step (= 6 min) 
Non0Prey0 = WHERE((PW[0, *] GT 0.), Non0Prey0count)
IF Non0Prey0count GT 0. THEN consumption[44, Non0Prey0] = ROUND(C[0, Non0Prey0]/PW[0, Non0Prey0]);
Non0Prey1 = WHERE((PW[1, *] GT 0.), Non0Prey1count)
IF Non0Prey1count GT 0. THEN consumption[45, Non0Prey1] = ROUND(C[1, Non0Prey1]/PW[1, Non0Prey1]);
Non0Prey2 = WHERE((PW[2, *] GT 0.), Non0Prey2count)
IF Non0Prey2count GT 0. THEN consumption[46, Non0Prey2] = ROUND(C[2, Non0Prey2]/PW[2, Non0Prey2]); 
Non0Prey3 = WHERE((PW[3, *] GT 0.), Non0Prey3count)
IF Non0Prey3count GT 0. THEN consumption[47, Non0Prey3] = ROUND(C[3, Non0Prey3]/PW[3, Non0Prey3]); 
Non0Prey4 = WHERE((PW[4, *] GT 0.), Non0Prey4count)
IF Non0Prey4count GT 0. THEN consumption[48, Non0Prey4] = ROUND(C[4, Non0Prey4]/PW[4, Non0Prey4]); 

Non0Prey5 = WHERE((PW[5, *] GT 0.), Non0Prey5count)
IF Non0Prey5count GT 0. THEN consumption[49, Non0Prey5] = ROUND(C[5, Non0Prey5]/PW[5, Non0Prey5]); 
Non0Prey6 = WHERE((PW[6, *] GT 0.), Non0Prey6count)
IF Non0Prey6count GT 0. THEN consumption[50, Non0Prey6] = ROUND(C[6, Non0Prey6]/PW[6, Non0Prey6]); 
Non0Prey7 = WHERE((PW[7, *] GT 0.), Non0Prey7count)
IF Non0Prey7count GT 0. THEN consumption[51, Non0Prey7] = ROUND(C[7, Non0Prey7]/PW[7, Non0Prey7]); 
Non0Prey8 = WHERE((PW[8, *] GT 0.), Non0Prey8count)
IF Non0Prey8count GT 0. THEN consumption[52, Non0Prey8] = ROUND(C[8, Non0Prey8]/PW[8, Non0Prey8]);
Non0Prey9 = WHERE((PW[9, *] GT 0.), Non0Prey9count)
IF Non0Prey9count GT 0. THEN consumption[53, Non0Prey9] = ROUND(C[9, Non0Prey9]/PW[9, Non0Prey9]);

; Stomach fullness
consumption[54, *] = NewStom / (stcap) * 100.; StomFull


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
;PRINT, 'Digested walleye (g)'
;PRINT, TRANSPOSE(consumption[9,*])
;
;PRINT, 'C (g) stomach content'
;PRINT, TRANSPOSE(consumption[10,*])
;PRINT, 'C (g) total daily cumulative consumption'
;PRINT, TRANSPOSE(consumption[11,*])
;PRINT, 'C (g) daily cumulative consumption of microzooplankton'
;PRINT, TRANSPOSE(consumption[32,*])
;PRINT, 'C (g) daily cumulative consumption of small mesozooplankton'
;PRINT, TRANSPOSE(consumption[33,*])
;PRINT, 'C (g) daily cumulative consumption of large mesozooplankton'
;PRINT, TRANSPOSE(consumption[34,*])
;PRINT, 'C (g) daily cumulative consumption of chironomids'
;PRINT, TRANSPOSE(consumption[35,*])
;PRINT, 'C (g) daily cumulative consumption of invasive species'
;PRINT, TRANSPOSE(consumption[36,*])
;PRINT, 'C (g) daily cumulative consumption of yellow perch'
;PRINT, TRANSPOSE(consumption[37,*])
;PRINT, 'C (g) daily cumulative consumption of emerald shiner'
;PRINT, TRANSPOSE(consumption[38,*])
;PRINT, 'C (g) daily cumulative consumption of rainbow smelt'
;PRINT, TRANSPOSE(consumption[39,*])
;PRINT, 'C (g) daily cumulative consumption of round goby'
;PRINT, TRANSPOSE(consumption[40,*])
;PRINT, 'C (g) daily cumulative consumption of walleye'
;PRINT, TRANSPOSE(consumption[41,*])
;
;PRINT, 'C (g) undigested rotifers'
;PRINT, TRANSPOSE(consumption[12,*])
;PRINT, 'C (g) undigested copepods'
;PRINT, TRANSPOSE(consumption[13,*]) 
;PRINT, 'C (g) undigested cladocerans'
;PRINT, TRANSPOSE(consumption[14,*])
;PRINT, 'C (g) undigested chironomids'
;PRINT, TRANSPOSE(consumption[15,*])
;PRINT, 'C (g) undigested bythotrephes'
;PRINT, TRANSPOSE(consumption[16,*])
;PRINT, 'C (g) undigested yellow perch'
;PRINT, TRANSPOSE(consumption[17,*])
;PRINT, 'C (g) undigested emerald shiner'
;PRINT, TRANSPOSE(consumption[18,*])
;PRINT, 'C (g) undigested rainbow smelt'
;PRINT, TRANSPOSE(consumption[19,*])
;PRINT, 'C (g) undigested round goby'
;PRINT, TRANSPOSE(consumption[20,*])
;PRINT, 'C (g) undigested walleye'
;PRINT, TRANSPOSE(consumption[21,*])

;PRINT, 'Number of individuals per superindividual'
;PRINT, TRANSPOSE(WAE[0,*])
;PRINT, 'Total zooplankton consumption by superindividuals (x N)'
;PRINT, TRANSPOSE(consumption[42,*])
;PRINT, 'Total zooplankton available in each cell'
;PRINT, TRANSPOSE(ZooplBio1+ZooplBio2+ZooplBio3)
;PRINT, 'Total zooplankton available in each cell AFTER fish feeding'
;PRINT, TRANSPOSE(consumption[43,*])
;
;PRINT, 'Number of consumed microzooplankton'
;PRINT, TRANSPOSE(consumption[44,*])
;PRINT, 'Number of consumed small mesozooplankton'
;PRINT, TRANSPOSE(consumption[45,*])
;PRINT, 'Number of consumed large mesozooplankton'
;PRINT, TRANSPOSE(consumption[46,*])
;PRINT, 'Number of consumed chironomids'
;PRINT, TRANSPOSE(consumption[47,*])
;PRINT, 'Number of consumed invasive species'
;PRINT, TRANSPOSE(consumption[48,*])
;PRINT, 'Number of consumed yellow perch'
;PRINT, TRANSPOSE(consumption[49,0:200])
;PRINT, 'Number of consumed emerald shiner'
;PRINT, TRANSPOSE(consumption[50,0:200])
;PRINT, 'Number of consumed rainbow smelt'
;PRINT, TRANSPOSE(consumption[51,0:200])
;PRINT, 'Number of consumed round goby'
;PRINT, TRANSPOSE(consumption[52,0:200])
;PRINT, 'Number of consumed walleye'
;PRINT, TRANSPOSE(consumption[53,0:200])
 
t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Walleye Foraging Ends Here'
RETURN, Consumption; TURN OFF WHEN TESTING
END