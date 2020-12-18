FUNCTION RASForage, iHour, Length, Temp, Light, RASpbio, RAScmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, ts, nRAS, DOa, DOacclC, DOcritC, RAS;, Grid2D
; This function calculates total consumption (g) by rainbow smelt

PRINT, 'RASForage Begins Here'
tstart = SYSTIME(/seconds)

tss = ts*60.; time step in secound
m = 6; the number of prey tRASes 
NewStom = FLTARR(nRAS); the amount of food in stomach
TotC = FLTARR(m, nRAS); daily cumulative consumption of each prey item 
TotCts = FLTARR(nRAS)
DigestedFood = FLTARR(m, nRAS); the total amount of digested prey used for growth
PotStAftDig = FLTARR(nRAS); potential stomach content after digestion 
C = FLTARR(m, nRAS); the amount of each prey item consumed per time step
CAftDig = FLTARR(m ,nRAS); the amoung of each prey item digested
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

RASGutEvacR = FLTARR(nRAS)

;PRINT, 'TotCday'
;PRINT, TRANSPOSE(TotCday)
;PRINT, 'RAScmx'
;PRINT, (RAScmx)
;PRINT, 'Previous stomach content (PreStom)'
;PRINT, TRANSPOSE(PreStom)
;PRINT, 'Stomach Capacity (StCap)'
;PRINT, TRANSPOSE(StCap)


; Determine prey characteristics for each prey tRASe (m)
; Prey length (mm)
PL = FLTARR(m+4, nRAS)
PL[0, *] = RANDOMU(seed, nRAS)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nRAS)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nRAS)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nRAS)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nRAS)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm

PL[5, *] = RASpbio[6, *]; length for yellow perch in mm 
PL[6, *] = RASpbio[10, *]; length for emerald shiner in mm 
PL[7, *] = RASpbio[14, *]; length for rainbow smelt in mm 
PL[8, *] = RASpbio[18, *]; length for round goby in mm 
PL[9, *] = RASpbio[22, *]; length for WALLEYE in mm 
;  PRINT, 'Prey length (PL, mm)'
;  PRINT, PL


; Prey individual weight (g, wet)
PW = FLTARR(m+4, nRAS); weight of each prey tRASe
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.0; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.0; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.0; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.0; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet

PW[5, *] = RASpbio[7, *];
PW[6, *] = RASpbio[11, *];
PW[7, *] = RASpbio[15, *];
PW[8, *] = RASpbio[19, *];
PW[9, *] = RASpbio[23, *];
;  PRINT, 'Prey weight (PW, g wet)'
;  PRINT, PW


 ; Convert prey biomass (g/L or m^2) into numbers/L or /m^2
dens = FLTARR(m+4, nRAS)
dens[0,*] = RASpbio[0,*] / Pw[0,*]; for microzooplankton 
dens[1,*] = RASpbio[1,*] / Pw[1,*]; for small mesozooplankton
dens[2,*] = RASpbio[2,*] / Pw[2,*]; for large mesozooplankton

pbio3 = WHERE(RASpbio[3,*] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
IF pbio3count GT 0.0 THEN dens[3, pbio3] = RASpbio[3, pbio3] / Pw[3,pbio3] ELSE dens[3, pbio3c] = 0.0; for chironmoid
pbio4 = WHERE(RASpbio[4,*] GT 0.0, pbio4count, complement = pbio4c, ncomplement = pbio4ccount)
IF pbio4count GT 0.0 THEN dens[4, pbio4] = RASpbio[4, pbio4] / Pw[4,pbio4] ELSE dens[4, pbio4c] = 0.0; for invasive species 

dens[5, *] = RASpbio[5, *]; for yellow perch
dens[6, *] = RASpbio[9, *]; for emerald shiner
dens[7, *] = RASpbio[13, *]; for rainbow smlet
dens[8, *] = RASpbio[17, *]; round goby 
dens[9, *] = RASpbio[21, *]; for walleye
;  PRINT, 'Prey density (dens)'
;  PRINT, dens


; Determine if the acclimated DO level is below the critical DO level
fDOfc2 = FLTARR(nRAS)
;  PRINT, 'DOa'
;  PRINT, TRANSPOSE(DOa)
;  PRINT, 'DOacclC'
;  PRINT, TRANSPOSE(DOacclC)
;  PRINT, 'DOcritC'
;  PRINT, TRANSPOSE(DOcritC)
DOc = WHERE(2*DOcritC GE DOacclC, DOccount, complement = DOcc, ncomplement = DOcccount)
IF (DOccount GT 0.0) THEN fDOfc2[DOc] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclC[DOc] + (4. - 2*DOcritC[DOc])) + 6.5916))
IF (DOcccount GT 0.0) THEN fDOfc2[DOcc] = 1.0
;***Hypoxia effect is incorporated in the digestion process (physiological) -> slows digestion -> lowers foraging***
PRINT, 'Number of fish in hypooxic cells (DOccount) =', DOccount
;  PRINT,'fDOfc2'
;  PRINT, fDOfc2


; Determine if food consumption has reached daily Cmax or full stomach in the previous time step
tds = WHERE((TotCday LT RAScmx) AND (PreStom LT Stcap), tdscount, complement = d, ncomplement = dcount)
PRINT, 'Number of fish with less than full stomach =', tdscount
IF (tdscount GT 0.0) THEN BEGIN; if fish hasn't consumed more than cmax in the previous time step


  ; Fish swimming speed calculation, S, in body lengths/sec
  SS = FLTARR(nRAS)
  S = FLTARR(nRAS)
  L = WHERE(Length LT 20., Lcount, complement = LL, ncomplement = LLcount)
  IF (Lcount GT 0.) THEN S[L] = 3.3354 * ALOG(length[L]) - 4.8758;(-0.0797 * (length[l] * length[l]) + 1.9294 * length[l] - 8.1761)
   ;SS equation based on data from Houde 1969 in body lengths/sec
  IF (LLcount GT 0.0) THEN S[LL] = (0.28 * Temp[LL] + 7.89) / (0.1 * Length[LL])
   ;in body lengths/sec; from Breck 1997 and Hergenrader and Hasler 1967 
  ;PRINT, 'S =', S
  ; Converts SS into mm/s
  SS = (S * length)
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS


; Calculate predator size-based prey selectivity (Chesson's alpha) for each prey type
  Calpha = FLTARR(m, nRAS); from Letcher et al. for zooplankton
  Calpha[0, *] = 193499 * Length^(-7.64); for microzooplankton - rotifers
  Calpha[1, *] = (0.272 * ALOG(Length[*]) - 0.3834) < 1.; for mesozooplankton1 - calanoids
  Calpha[2, *] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * length))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
  
  PL3 = WHERE((PL[3, *] / Length) LE 0.2, PL3count, complement = PL3c, ncomplement = pl3ccount)
  IF (PL3count GT 0.0) THEN Calpha[3, PL3] = ABS(0.6 - 1.75 * (PL[3, PL3] / Length[PL3])) ;$
  IF (PL3ccount GT 0.0) THEN Calpha[3, PL3c] = 0.; for benthic prey for flounder by Rose et al. 1996 
  
;  Length60 = WHERE(Length GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)
;  IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001 ;$; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
;  IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.
  
;  LengthGT100 = WHERE((Length GT 100.0), LengthGT100count, complement = LengthLE100, ncomplement = LengthLE100ccount)
;  IF (LengthGT100count GT 0.0) THEN BEGIN
;    PL5 = WHERE(((PL[5, LengthGT100] / Length[LengthGT100]) LE 0.2), PL5count, complement = PL5c, ncomplement = PL5ccount)
;    IF (PL5count GT 0.0) THEN Calpha[5, LengthGT100[PL5]] = 0.5
;    IF (PL5ccount GT 0.0) THEN Calpha[5, LengthGT100[PL5c]] = 0.00 ; for fish
;  ENDIF
;  PRINT, 'Chessons alpha'
;  PRINT, Calpha
  
  
  ; Determine light effect
  ; LId (z,t) = LI(0,t)*exp(-z*k), light intensity at depth z time t with light extinction coefficient, k   
  litfac = FLTARR(nRAS); a multiplication factor to include the effect of light intensity on RD
  litfac[*] = (126.31 + (-113.6 * EXP(-1.0 * light[*]))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.
  ;or R = 4.3 I*(0.1+I)^(-1) from Richmond et al., 2003
;  PRINT, 'Light intensity (lux)'
;  PRINT, TRANSPOSE(light)
;  PRINT, 'Light multiplication factor'
;  PRINT, litfac
  
  
  ; Calculate reactive distance in mm (from cm), Breck and Gitter. 1983.
  ;****Reactive distance may be used for the movement decision***********************
  ; Calculate alpha = fish length function in reactive distance, RD
  alphaDig = FLTARR(nRAS)
  ;alpha = (0.0167 * exp(9.14 - 2.4 * alog(length) + 0.229 * (alog(length))^2));*!pi/180*(1/60)
  ; from Breck and Gitter, 1983
  ;ln(alpha) = 9.14 - 2.4*alog(length) + 0.229*(alog(length))^2
  alphaDig = EXP(9.14 - 2.4 * ALOG(length) + 0.229*(ALOG(length))^2.0) / 60.0
  ;alphaRad = alphaDig*2*!PI/360
;  PRINT, 'alphaDig'
;  PRINT, TRANSPOSE(alphaDig)
  
  RD = FLTARR(m+4, nRAS); RD = 0.5*PL/tan(2.0*!PI*(1.0/360.0)*alphaDig/2.0)
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
  prop = FLTARR(nRAS)
  Larva = WHERE(length LE 20.0, Larvacount, complement = JuvAdu, ncomplement = JuvAducount)
  IF (Larvacount GT 0.0) THEN prop[Larva] = 0.50 
  IF (JuvAducount GT 0.0) THEN prop[JuvAdu] = 1.0 
;  PRINT, 'Proporton of reactive distance'
;  PRINT, prop
  
  ; Reactive area (mm2)
  RA = FLTARR(m+4, nRAS)
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
  VS = FLTARR(m+4, nRAS); MULTIPLY BY 10.00^(-6.00) from mm3 to L OR mm2 to m2
  VS[0,*] = DOUBLE(SS * RA[0,*] * 10.00^(-6.00))
  VS[1,*] = DOUBLE(SS * RA[1,*] * 10.00^(-6.00))
  VS[2,*] = DOUBLE(SS * RA[2,*] * 10.00^(-6.00))
  VS[3,*] = DOUBLE(SS * 2.0 * RD[3, *] * SIN(!PI/3.0) * 10.00^(-6.00)); Area for benthos from Breck 1993; VS[3,*] = SS * 2.0 * Frd * RD[3,*] with turbidity
  VS[4,*] = DOUBLE(SS * RA[4,*] * 10.00^(-6.00))
  
  VS[5,*] = DOUBLE(SS * RA[5,*] * 10.00^(-9.00)); mm3 to m3 for fish
  VS[6,*] = DOUBLE(SS * RA[6,*] * 10.00^(-9.00))
  VS[7,*] = DOUBLE(SS * RA[7,*] * 10.00^(-9.00))
  VS[8,*] = DOUBLE(SS * RA[8,*] * 10.00^(-9.00))
  VS[9,*] = DOUBLE(SS * RA[9,*] * 10.00^(-9.00))
;  PRINT, 'Volume searched (VS, L or m2 /s)'
;  PRINT, VS


; Calculate potential encounter rate # per time step (ts)
  ER = FLTARR(m, nRAS)
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
  
  ;***size-based inter-/intra-specific interactions and density dependence***
  ERP = FLTARR(5, nRAS); ENCOUNTER RATE FOR COMPETITORS
  ; Forage fish only
  ERP[0, *] = CEIL(VS[5, *] * RASpbio[25, *]); yellow perch
  ERP[1, *] = CEIL(VS[6, *] * RASpbio[26, *]); emerald shiner
  ERP[2, *] = CEIL(VS[7, *] * RASpbio[27, *]); rainbow smelt
  ERP[3, *] = CEIL(VS[8, *] * RASpbio[28, *]); round goby
  ERP[4, *] = CEIL(VS[9, *] * RASpbio[29, *]); walleye
  
  ERPintra = FLTARR(nRAS)
  ERPinter = FLTARR(nRAS)
  ERPintra[*] = ERP[2, *]
  ERPinter[*] = ERP[1, *] + ERP[3, *] + ERP[0, *] + ERP[4, *]
;  PRINT, 'Competitor encounter rate (ERP, #/s)'
;  PRINT, ERP
;  PRINT, 'Intraspecific competitor encounter rate (ERPintra, #/s)'
;  PRINT, TRANSPOSE(ERPintra)
;  PRINT, 'Interspecific competitor encounter rate (ERPinter, #/s)'
;  PRINT, TRANSPOSE(ERPinter)
  
  
; Calculate handling time in s
;*****HandLing time should not exceed ts*******
  ;**********Handling time parameters are calibrated for LARVAL YELLOW PERCH******
  ;**********NEED TO FIND PARAMTERS FOR LARGE FISH AND OTEHR SPECIES**********
  L = TRANSPOSE(length)
  HT = FLTARR(m, nRAS)
  SumHT = FLTARR(nRAS) 
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
;  SumHT[*] = HT[0,*] + HT[1,*] + HT[2,*] + HT[3,*] + HT[4,*] + HT[5,*]; + HT[6,*] + HT[7,*] + HT[8,*]
;  PRINT, 'Potential total handling time (SumHT, s)'
;  PRINT, SumHT
  
  
; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(nRAS); probability of all prey atacked and captured
  t = FLTARR(m, nRAS);  probability of each prey atacked and captured
  t[0,*] = (Calpha[0,*] * dens[0,*]) * PW[0, *]
  t[1,*] = (Calpha[1,*] * dens[1,*]) * PW[1, *]
  t[2,*] = (Calpha[2,*] * dens[2,*]) * PW[2, *]
  t[3,*] = (Calpha[3,*] * dens[3,*]) * PW[3, *]
  t[4,*] = (Calpha[4,*] * dens[4,*]) * PW[4, *]
  t[5,*] = (Calpha[5,*] * dens[5,*]) * PW[5, *]
;  t[6,*] = (Calpha[6,*] * dens[6,*])
;  t[7,*] = (Calpha[7,*] * dens[7,*])
;  t[8,*] = (Calpha[8,*] * dens[8,*])
  TOT[*] = t[0,*] + t[1,*] + t[2,*] + t[3,*] + t[4,*] + t[5,*]; + t[6,*] + t[7,*] + t[8,*]
;  PRINT, 'Proportion of each prey item attcked and captured (t)'
;  PRINT, t
;  PRINT, 'Proportion of all prey itRAS attcked and captured (tot)'
;  PRINT, TOT
  
  
  Q = FLTARR(m,nRAS); Probability of attack and capture
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

  
; Calculate the number of each prey consumed 
  E = FLTARR(m, nRAS); encounter rate in individuals
  
  EPintra = FLTARR(nRAS); encounter rate in individuals
  EPinter = FLTARR(nRAS); encounter rate in individuals
  
  NumP = FLTARR(m, nRAS); potential total number of prey consumed 
  FOR ind = 0L, nRAS - 1L DO BEGIN ; for each superindividual
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
;    
    IF ERPintra[ind] GT 0. THEN EPintra[ind] = RANDOMU(seed, POISSON = [ERPintra[ind]], /double)
    IF ERPinter[ind] GT 0. THEN EPinter[ind] = RANDOMU(seed, POISSON = [ERPinter[ind]], /double)
;    
    ; Stochastic estimates for the number and tRASe of prey based on E from binomial distriution
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


  SD = FLTARR(m,nRAS); handling time (HT) > ts, then no conumption during each time step 
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
  SumDen = FLTARR(nRAS)
  SumDen[*] = SD[0, *] + SD[1, *] + SD[2, *] + SD[3, *] + SD[4, *] + SD[5, *]; + SD[6, *] + SD[7, *] + SD[8, *]
;  PRINT, 'SumDen'
;  PRINT, SumDen
  

; calculate the amount of each prey type consumed 
 ; IF handlign time is greater than ts, no consumption
  cons = FLTARR(m, nRAS)
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
;  PRINT, 'Potential amount of each prey tRASe consumed (cons, g)'
;  PRINT, cons
    
    
;  PRINT, 'Realised intraspecific competitor encounter rate (EPintra, #/s)'
;  PRINT, (EPintra[0:100])
;  PRINT, 'Realised interspecific competitor encounter rate (EPinter, #/s)'
;  PRINT, (EPinter[0:100])

; Consumption for each prey type accounting for foraging in g in time step
  ; = Diet Consumption Rate Index for each prey type*********************NO DENSITY-DEPENDENCE**************************
;  C[0, tds] = DOUBLE((Cons[0, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[1, tds] = DOUBLE((Cons[1, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[2, tds] = DOUBLE((Cons[2, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[3, tds] = DOUBLE((Cons[3, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[4, tds] = DOUBLE((Cons[4, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)
;  C[5, tds] = DOUBLE((Cons[5, tds] / (1.0 + SumDen[tds]))* 60.0 * ts)

;;  C[6, tds] = DOUBLE((Cons[6, tds] / (1.0 + SumDen[tds])))
;;  C[7, tds] = DOUBLE((Cons[7, tds] / (1.0 + SumDen[tds])))
;;  C[8, tds] = DOUBLE((Cons[8, tds] / (1.0 + SumDen[tds])))
;  PRINT, 'Consumption per prey (C, g/ts)'
;  PRINT, C


  ; Use biomass for inter- and intra- specific interactions
  densPintra = FLTARR(nRAS)
  densPinter = FLTARR(nRAS)
  densPintra[*] = RASpbio[32, *]
  densPinter[*] = RASpbio[30, *] + RASpbio[31, *] + RASpbio[33, *] + RASpbio[34, *]
  
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
;;  PRINT, 'Volume searched (VS, L or m2 /s)'
;;  PRINT, VS
; PRINT, 'densPintra'
; PRINT, densPintra[0:100]
; PRINT, 'densPinter'
; PRINT, densPinter[0:100]

 TotCts[tds]= DOUBLE(C[0,tds] + C[1, tds] + C[2, tds] + C[3, tds] + C[4, tds] + C[5, tds]); + C[6, tds] + C[7, tds] + C[8, tds])
;  PRINT, 'Total consumption (TotCts, g/ts)'
;  PRINT, (TotCts)


  Cratio = FLTARR(m, nRAS); PROPORTIONS OF PREY-SPECIFIC CONSUMPTION
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
  
  
; Determine potential stomach weight in g after the current time step
  PotSt = FLTARR(m, nRAS)
  TotPotSt = FLTARR(nRAS)
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
  nstom = FLTARR(nRAS)
  Premove = FLTARR(nRAS)
  TotCAftDig = FLTARR(nRAS)
  RemCAftDig = FLTARR(nRAS)
  RemCAftDig0 = FLTARR(nRAS)
  RemCAftDig1 = FLTARR(nRAS)
  RemCAftDig2 = FLTARR(nRAS)
  RemCAftDig3 = FLTARR(nRAS)
  RemCAftDig4 = FLTARR(nRAS)
  RemCAftDig5 = FLTARR(nRAS)
  
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
    TotCAftDig[P] = CAftDig0[p] + CAftDig1[p] + CAftDig2[p] + CAftDig3[p] + CAftDig4[p] + CAftDig5[p]; + CAftDig6[p] + CAftDig7[p] + CAftDig8[p]
    RemCAftDig[P] = TotCAftDig[P] - TotCAftDig[P] * Premove[P]; ***SUBSCRIPT P ONLY****
    ; the total amount of food needed to remove for previously undigested food 
    RemCAftDig0[P] = RemCAftDig[P] * Cratio[0, P]
    RemCAftDig1[P] = RemCAftDig[P] * Cratio[1, P]
    RemCAftDig2[P] = RemCAftDig[P] * Cratio[2, P]
    RemCAftDig3[P] = RemCAftDig[P] * Cratio[3, P]
    RemCAftDig4[P] = RemCAftDig[P] * Cratio[4, P]
    RemCAftDig5[P] = RemCAftDig[P] * Cratio[5, P]  
    ;RemCAftDig6 = RemCAftDig * Cratio[6, P]
    ;RemCAftDig7 = RemCAftDig * Cratio[7, P]
    ;RemCAftDig8 = RemCAftDig * Cratio[8, P]
    
    ; remove the additional amount of consumed food for the previously undigested
    ; excess food can be removed only from the food consumed in the current time step
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
;    
    ; determine prey-specific food consumption adjusted for overconsumption
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


; Temperature-dependent digestion and gut evacuation
;***Hypoxia effect is incorporated in the digestion process (physiological) -> slows digestion -> lowers foraging***
  ;Gut evacuation rate, R, for yellow perch based on Eurasian perch from Durbin et al. 1983
   ;RASGutEvacR = FLTARR(nRAS)
   LengthLE20 = WHERE(Length LE 43.0, LengthLE20count, complement = LengthGT20, ncomplement = LengthGT20count)
;    RASGutEvacR[LengthGT80] = 0.36 * EXP(((temp[LengthGT80] - 10.71)^2.)/(-29.93)) / 60.0 * fDOfc2[LengthGT80]; for smelt 
   IF (LengthLE20count GT 0.0) THEN RASGutEvacR[LengthLE20] = 0.36 * EXP(((temp[LengthLE20] - 10.71)^2.)/(-29.93)) * fDOfc2[LengthLE20] / 0.2 / 60.0; for smelt 
   ;IF (LengthLE45count GT 0.0) THEN RASGutEvacR[LengthLE45] = 0.0182 * EXP(0.14 * Temp[LengthLE45]) / 60.0 * fDOfc2[LengthLE45]; in g/min acclimated temperature-dependent   
   IF (LengthGT20count GT 0.0) THEN RASGutEvacR[LengthGT20] = 0.36 * EXP(((temp[LengthGT20] - 10.71)^2.)/(-29.93)) * fDOfc2[LengthGT20] / 0.1 / 60.0; for smelt 
  ; -> low digestion at high temp; Karnitz, 1992, Masters thesis, South Dakota University
;  PRINT, 'RASGutEvacR'
;  PRINT, TRANSPOSE(RASGutEvacR)

  ; determine food digesetion over time step
;  PRINT, 'Prey specific stomach content before Digestion'
;  PRINT, PotSt[*, tds]
  ; Digestion and evacuation of each prey from current and previous ts
  ;newstomAFTdig = prestom[*] * exp(-RASGutEvacR * ts) + ((newstom - prestom[*]) / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[0, tds] = (CAftDig0[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[0, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
  CAftDig[1, tds] = (CAftDig1[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[1, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
  CAftDig[2, tds] = (CAftDig2[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[2, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
  CAftDig[3, tds] = (CAftDig3[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[3, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
  CAftDig[4, tds] = (CAftDig4[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[4, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
  CAftDig[5, tds] = (CAftDig5[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[5, tds]) * EXP(-RASGutEvacR[tds] * ts)); 
;  CAftDig[6, tds] = (CAftDig6[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[6, tds]) * EXP(-RASGutEvacR[tds] * ts));
;  CAftDig[7, tds] = (CAftDig7[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[7, tds]) * EXP(-RASGutEvacR[tds] * ts));
;  CAftDig[8, tds] = (CAftDig8[tds] * EXP(-RASGutEvacR[tds] * ts) + (C[8, tds]) * EXP(-RASGutEvacR[tds] * ts));

  ; determine the amount of food digested per time step
  ; DigestedFood = Nstom - NstomAFTdig; per time step
  DigestedFood[0, tds] = DOUBLE(potst[0, tds] - CAftDig[0, tds])
  DigestedFood[1, tds] = DOUBLE(potst[1, tds] - CAftDig[1, tds])
  DigestedFood[2, tds] = DOUBLE(potst[2, tds] - CAftDig[2, tds])
  DigestedFood[3, tds] = DOUBLE(potst[3, tds] - CAftDig[3, tds])
  DigestedFood[4, tds] = DOUBLE(potst[4, tds] - CAftDig[4, tds])
  DigestedFood[5, tds] = DOUBLE(potst[5, tds] - CAftDig[5, tds])
;  DigestedFood[6, tds] = DOUBLE(potst[6, tds] - CAftDig[6, tds])
;  DigestedFood[7, tds] = DOUBLE(potst[7, tds] - CAftDig[7, tds])
;  DigestedFood[8, tds] = DOUBLE(potst[8, tds] - CAftDig[8, tds])


  ; Determine total non-digested stomach content in g after time step
  PotStAftDig[tds] = DOUBLE(CAftDig[0, tds] + CAftDig[1, tds] + CAftDig[2, tds] + CAftDig[3, tds] + CAftDig[4, tds] + CAftDig[5, tds]); $
  ;+ CAftDig[6, tds] + CAftDig[7, tds] + CAftDig[8, tds])
  NewStom[tds] = (PotStAftDig[tds]); tds = TotCday < RAScmx
  
  
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

ENDIF;****************************************************************************************************************************


;*********If the previous stomach content is larger than CMAX -> No consumption - digestion/evacuation only************************
PRINT, 'Number of fish with full stomach or Cmax =', dcount
IF (dcount GT 0.0)  THEN BEGIN; dcount = totcday > RAScmx 
; OR ((iHour LT 4L) AND (iHour GT 15L)) OR ((iHour LT 4L) AND (iHour GT 20L))

  ; Digestion and evacuation for each prey item
   LengthLE45 = WHERE(Length LE 43.0, LengthLE45count, complement = LengthGT45, ncomplement = LengthGT45count)
   IF (LengthLE45count GT 0.0) THEN RASGutEvacR[LengthLE45] = 0.36 * EXP(((temp[LengthLE45] - 10.71)^2.)/(-29.93)) * fDOfc2[LengthLE45] / 0.2 / 60.0; for smelt 
   IF (LengthGT45count GT 0.0) THEN RASGutEvacR[LengthGT45] = 0.36 * EXP(((temp[LengthGT45] - 10.71)^2.)/(-29.93)) * fDOfc2[LengthGT45] / 0.1 / 60.0; for smelt 
   
  
  CAftDig[0, d] = DOUBLE(CAftDig0[d] * EXP(-RASGutEvacR[d] * ts)); + (C[0,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[1, d] = DOUBLE(CAftDig1[d] * EXP(-RASGutEvacR[d] * ts)); + (C[1,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[2, d] = DOUBLE(CAftDig2[d] * EXP(-RASGutEvacR[d] * ts)); + (C[2,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[3, d] = DOUBLE(CAftDig3[d] * EXP(-RASGutEvacR[d] * ts)); + (C[3,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[4, d] = DOUBLE(CAftDig4[d] * EXP(-RASGutEvacR[d] * ts)); + (C[4,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
  CAftDig[5, d] = DOUBLE(CAftDig5[d] * EXP(-RASGutEvacR[d] * ts)); + (C[5,*] / RASGutEvacR) * (1 - exp(-RASGutEvacR * ts))
;  CAftDig[6, d] = DOUBLE(CAftDig[6, d] * EXP(-RASGutEvacR[d] * ts))
;  CAftDig[7, d] = DOUBLE(CAftDig[7, d] * EXP(-RASGutEvacR[d] * ts))
;  CAftDig[8, d] = DOUBLE(CAftDig[8, d] * EXP(-RASGutEvacR[d] * ts))
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

;PRINT, 'Total daily cumulative consumption (g/day)'
;PRINT, (TotCday[*])
;PRINT, 'New Digested prey item (DigestedFood, g)'
;PRINT, total(DigestedFood[0:5, 0:100], 1)
;PRINT, 'Undigested prey itRAS (CAftDig, g)'
;PRINT, TOTAL(CAftDig[*, 0:100],1)  
;PRINT, 'Total non-digested stomach content (potstAftDig, g)'
;PRINT, (potstAftDig[*])
;PRINT, 'New Stomach content (NewStom, g)'
;PRINT, (NewStom[*])
;PRINT, 'Stomach capacity'
;PRINT, TRANSPOSE(stcap)

;VerSize = (Grid2D[3, RAS[13, *]]/20L)*1000L; individual cell depth in mm, there are always 20 vertical cells.
;;CellDepth = (VerSize[*]/1000)
;;PRINT, 'Cell depth (m)'
;;PRINT, CellDepth
;ZooplBio1 = (RAS[15,*])*4000000000D*(VerSize[*]/1000); g per cell of 2km x 2km x depth from g/L 
;ZooplBio2 = (RAS[16,*])*4000000000D*(VerSize[*]/1000); g per cell of 2km x 2km x depth from g/L 
;ZooplBio3 = (RAS[17,*])*4000000000D*(VerSize[*]/1000); g per cell of 2km x 2km x depth from g/L 
;ZooplBioAft1 = ZooplBio1 - C[0,*]*RAS[0,*]; Czoopl1 = g per individual
;ZooplBioAft2 = ZooplBio2 - C[1,*]*RAS[0,*];
;ZooplBioAft3 = ZooplBio3 - C[2,*]*RAS[0,*];
;  PRINT, 'ZooplBio2'
;  PRINT, TRANSPOSE(ZooplBio2)
;  PRINT, 'Czoopl2*RAS[0,*]'
;  PRINT, TRANSPOSE(C[2,*]*RAS[0,*])
;  PRINT, 'ZooplBioAft2'
;  PRINT, TRANSPOSE(ZooplBioAft2)


consumption = FLTARR(50, nRAS)
; Digested food items used for growth subroutine
consumption[0,*] = DigestedFood[0,*]; g digested for each prey tRASe
consumption[1,*] = DigestedFood[1,*]; g digested for each prey tRASe
consumption[2,*] = DigestedFood[2,*]; g digested for each prey tRASe
consumption[3,*] = DigestedFood[3,*]; g digested for each prey tRASe
consumption[4,*] = DigestedFood[4,*]; g digested for each prey tRASe
consumption[5,*] = DigestedFood[5,*]; g digested for each prey tRASe
;consumption[6,*] = DigestedFood[6,*]; g digested for each prey tRASe
;consumption[7,*] = DigestedFood[7,*]; g digested for each prey tRASe
;consumption[8,*] = DigestedFood[8,*]; g digested for each prey tRASe

consumption[9,*] = NewStom[*]; new weight of stomach content
consumption[10,*] = TotCday[*]; new total cumulative consumption after time step need to be updated every 24h

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
consumption[29,*] = TotC[0,*]; total amount of daily consumption 
consumption[30,*] = TotC[1,*]; total amount of daily consumption 
consumption[31,*] = TotC[2,*]; total amount of daily consumption 
consumption[32,*] = TotC[3,*]; total amount of daily consumption 
consumption[33,*] = TotC[4,*]; total amount of daily consumption 
consumption[34,*] = TotC[5,*]; total amount of daily consumption 
;consumption[35,*] = TotC[6,*]; total amount of daily consumption 
;consumption[36,*] = TotC[7,*]; total amount of daily consumption 
;consumption[37,*] = TotC[8,*]; total amount of daily consumption 

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
consumption[49, *] = NewStom / (stcap) * 100.; 

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
;PRINT, TRANSPOSE(RAS[0, *])
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


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
;PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Rainbow Smelt Foraging Ends Here'
RETURN, Consumption; TURN OFF WHEN TESTING
END