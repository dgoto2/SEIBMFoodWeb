FUNCTION YEPMove1DV, ts, iHour, YP, nYP, NewInput, FISHPREY, FishPred, zOldLocWithinCell, Oxydebt
;function determines movement in Z direction for all yellow perch

PRINT, 'Yellow Perch Movement Begins Here'
tstart = SYSTIME(/seconds)

;*****NEED TO INCORPORATE PREDATOR-BASED HABITAT-QIALITY***********************************
;******NO NEED TO IDENTIFY THE CURRENT CELL AND INCORPORATE 
;******Change * to 0 in row subscripting*********

;*****Identify potential cell IDs in all 6 directions*******************************************
LocV = FLTARR(7L, nYP)
LocV[0, *] = YP[14, *]; current CELL ID
; VERTICAL LAYERS 0 - 47
; ***Vertical movement is restricted within 3 cells below and above the current layer***

; DOWNWARD MOVEMNT
; current layer -3
Lower3Cells0 = WHERE((YP[14, *] LE 44L), Lower3Cells0count, complement = NONLower3Cells0, ncomplement = NonLower3Cells0count)
IF Lower3Cells0count GT 0. THEN LocV[1, Lower3Cells0] = LocV[0, Lower3Cells0]+3L;
IF NonLower3Cells0count GT 0. THEN LocV[1, NonLower3Cells0] = LocV[0, NonLower3Cells0];

; current layer -2
Lower2Cells0 = WHERE((YP[14, *] LE 45L), Lower2Cells0count, complement = NONLower2Cells0, ncomplement = NonLower2Cells0count)
IF Lower2Cells0count GT 0. THEN LocV[2, Lower2Cells0] = LocV[0, Lower2Cells0]+2L; 
IF NonLower2Cells0count GT 0. THEN LocV[2, NonLower2Cells0] = LocV[0, NonLower2Cells0];

; current layer -1
Lower1Cells0 = WHERE((YP[14, *] LE 46L), Lower1Cells0count, complement = NONLower1Cells0, ncomplement = NonLower1Cells0count)
IF Lower1Cells0count GT 0. THEN LocV[3, Lower1Cells0] = LocV[0, Lower1Cells0]+1L; 
IF NonLower1Cells0count GT 0. THEN LocV[3, NonLower1Cells0] = LocV[0, NonLower1Cells0];

; UPWARD MOVEMENT
; current layer +1
Upper1Cells0 = WHERE((YP[14, *] GE 1L), Upper1Cells0count, complement = NONUpper1Cells0, ncomplement = NonUpper1Cells0count)
IF Upper1Cells0count GT 0. THEN LocV[4, Upper1Cells0] = LocV[0, Upper1Cells0]-1L;
IF NonUpper1Cells0count GT 0. THEN LocV[4, NonUpper1Cells0] = LocV[0, NonUpper1Cells0];

; current layer +2
Upper2Cells0 = WHERE((YP[14, *] GE 2L), Upper2Cells0count, complement = NONUpper2Cells0, ncomplement = NonUpper2Cells0count)
IF Upper2Cells0count GT 0. THEN LocV[5, Upper2Cells0] = LocV[0, Upper2Cells0]-2L;
IF NonUpper2Cells0count GT 0. THEN LocV[5, NonUpper2Cells0] = LocV[0, NonUpper2Cells0];

; current layer +3
Upper3Cells0 = WHERE((YP[14, *] GE 3L), Upper3Cells0count, complement = NONUpper3Cells0, ncomplement = NonUpper3Cells0count)
IF Upper3Cells0count GT 0. THEN LocV[6, Upper3Cells0] = LocV[0, Upper3Cells0]-3L;
IF NonUpper3Cells0count GT 0. THEN LocV[6, NonUpper3Cells0] = LocV[0, NonUpper3Cells0];
;**********************************************
;PRINT, 'LocV[0:6,*]'
;PRINT, transpose(LocV[0:6,0:100])
 
 
;****Determine habitat quality of neibouring cells***************************************************************
EnvironV = FLTARR(105L, nYP)
;Envir1D3[4, *] = INDGEN(nVerLay)
;Envir1D3[5, *] = zoopl1; microzooplankton, g/L
;Envir1D3[6, *] = zoopl2 ; mid-size zooplankton; NOT YET g/L
;Envir1D3[7, *] = zoopl3; large-bodied zooplankton; NOT YET g/L
;Envir1D3[8, *] = TotBenBio
;Envir1D3[9:10, *] = Envir1D2[9:10, *]; TEMP & O2
;Envir1D3[11, *] = Light
GridCellHorSize = 15500. * 1000000. * .5 / 10.; in L, 1550km2 FOR FISH ARRAY = 1/10 OF LE CENTRAL BASIN, 1m3 = 1000L

; Environmental conditions in (0) = the current cell
EnvironV[0:8, *] = newinput[3:11, LocV[0, *]];
EnvironV[9, *] = 0.0; invasive species
EnvironV[10, *] = FISHPREY[5, LocV[0, *]] / GridCellHorSize; YEP BIOMASS
EnvironV[11, *] = FISHPREY[11, LocV[0, *]] / GridCellHorSize; EMS
EnvironV[12, *] = FISHPREY[17, LocV[0, *]] / GridCellHorSize; RAS
EnvironV[13, *] = FISHPREY[23, LocV[0, *]] / GridCellHorSize; ROG
EnvironV[14, *] = FISHPREY[29, LocV[0, *]] / GridCellHorSize; WAE

; Environmental conditions for potential vertical movement
;LocV# for vertical movement = 1, 2, 3, 4, 5, 6
; -3
EnvironV[15:23, *] = newinput[3:11, LocV[1, *]];9 parameters
EnvironV[24, *] = 0.0; invasive species
EnvironV[25, *] = FISHPREY[5, LocV[1, *]] / GridCellHorSize; YEP
EnvironV[26, *] = FISHPREY[11, LocV[1, *]] / GridCellHorSize; EMS
EnvironV[27, *] = FISHPREY[17, LocV[1, *]] / GridCellHorSize; RAS
EnvironV[28, *] = FISHPREY[23, LocV[1, *]] / GridCellHorSize; ROG
EnvironV[29, *] = FISHPREY[29, LocV[1, *]] / GridCellHorSize; WAE

; -2
EnvironV[30:38, *] = newinput[3:11, LocV[2, *]];
EnvironV[39, *] = 0.0; invasive species
EnvironV[40, *] = FISHPREY[5, LocV[2, *]] / GridCellHorSize; YEP
EnvironV[41, *] = FISHPREY[11, LocV[2, *]] / GridCellHorSize; EMS
EnvironV[42, *] = FISHPREY[17, LocV[2, *]] / GridCellHorSize; RAS
EnvironV[43, *] = FISHPREY[23, LocV[2, *]] / GridCellHorSize; ROG
EnvironV[44, *] = FISHPREY[29, LocV[2, *]] / GridCellHorSize; WAE

; -1
EnvironV[45:53, *] = newinput[3:11, LocV[3, *]];
EnvironV[54, *] = 0.0; invasive species
EnvironV[55, *] = FISHPREY[5, LocV[3, *]] / GridCellHorSize; YEP
EnvironV[56, *] = FISHPREY[11, LocV[3, *]] / GridCellHorSize; EMS
EnvironV[57, *] = FISHPREY[17, LocV[3, *]] / GridCellHorSize; RAS
EnvironV[58, *] = FISHPREY[23, LocV[3, *]] / GridCellHorSize; ROG
EnvironV[59, *] = FISHPREY[29, LocV[3, *]] / GridCellHorSize; WAE

; +1
EnvironV[60:68, *] = newinput[3:11, LocV[4, *]];
EnvironV[69, *] = 0.0; invasive species
EnvironV[70, *] = FISHPREY[5, LocV[4, *]] / GridCellHorSize; YEP
EnvironV[71, *] = FISHPREY[11, LocV[4, *]] / GridCellHorSize; EMS
EnvironV[72, *] = FISHPREY[17, LocV[4, *]] / GridCellHorSize; RAS
EnvironV[73, *] = FISHPREY[23, LocV[4, *]] / GridCellHorSize; ROG
EnvironV[74, *] = FISHPREY[29, LocV[4, *]] / GridCellHorSize; WAE

; +2
EnvironV[75:83, *] = newinput[3:11, LocV[5, *]];
EnvironV[84, *] = 0.0; invasive species
EnvironV[85, *] = FISHPREY[5, LocV[5, *]] / GridCellHorSize; YEP
EnvironV[86, *] = FISHPREY[11, LocV[5, *]] / GridCellHorSize; EMS
EnvironV[87, *] = FISHPREY[17, LocV[5, *]] / GridCellHorSize; RAS
EnvironV[88, *] = FISHPREY[23, LocV[5, *]] / GridCellHorSize; ROG
EnvironV[89, *] = FISHPREY[29, LocV[5, *]] / GridCellHorSize; WAE

; +3
EnvironV[90:98, *] = newinput[3:11, LocV[6, *]];
EnvironV[99, *] = 0.0; invasive species
EnvironV[100, *] = FISHPREY[5, LocV[6, *]] / GridCellHorSize; YEP
EnvironV[101, *] = FISHPREY[11, LocV[6, *]] / GridCellHorSize; EMS
EnvironV[102, *] = FISHPREY[17, LocV[6, *]] / GridCellHorSize; RAS
EnvironV[103, *] = FISHPREY[23, LocV[6, *]] / GridCellHorSize; ROG
EnvironV[104, *] = FISHPREY[29, LocV[6, *]] / GridCellHorSize; WAE
;PRINT,'EnvironV[*, 0:100]'
;PRINT, TRANSPOSE(EnvironV[1, 0:200])
;PRINT, TRANSPOSE(EnvironV[16, 0:200])
;PRINT, TRANSPOSE(EnvironV[31, 0:200])
;PRINT, TRANSPOSE(EnvironV[46, 0:200])
;PRINT, TRANSPOSE(EnvironV[61, 0:200])
;PRINT, TRANSPOSE(EnvironV[76, 0:200])


;***Assess habitat quality of neibouring cells**********************************************************************
DOf1 = FLTARR(7, nYP)
DOf2 = FLTARR(7, nYP)
DOf3 = FLTARR(7, nYP)
DOf = FLTARR(7, nYP)
Tf = FLTARR(7, nYP)
; DO***************************************************************************************************************
DOacclim = YEPacclDO(YP[29, *], YP[28, *], YP[20, *], YP[27, *], YP[26, *], YP[19, *], ts, YP[1, *], YP[2, *], nYP, YP[63, *])
;PRINT, 'DOacclim[7, *]'
;PRINT, TRANSPOSE(DOacclim[7, 0:100])
;PRINT, 'DOacclim[5, *]'
;PRINT, TRANSPOSE(DOacclim[5, 0:100])

; for movement, the critical DO level is slightly higher than the critical level for physiological processes
DOf0a = EnvironV[7, *] - 5*DOacclim[7, *]
DOf1a = EnvironV[22, *] - 5*DOacclim[7, *]
DOf2a = EnvironV[37, *] - 5*DOacclim[7, *]
DOf3a = EnvironV[52, *] - 5*DOacclim[7, *]
DOf4a = EnvironV[67, *] - 5*DOacclim[7, *]
DOf5a = EnvironV[82, *] - 5*DOacclim[7, *]
DOf6a = EnvironV[97, *] - 5*DOacclim[7, *]

DOf0b = EnvironV[7, *] - 2.*DOacclim[5, *]
DOf1b = EnvironV[22, *] - 2.*DOacclim[5, *]
DOf2b = EnvironV[37, *] - 2.*DOacclim[5, *]
DOf3b = EnvironV[52, *] - 2.*DOacclim[5, *]
DOf4b = EnvironV[67, *] - 2.*DOacclim[5, *]
DOf5b = EnvironV[82, *] - 2.*DOacclim[5, *]
DOf6b = EnvironV[97, *] - 2.*DOacclim[5, *]
;PRINT, 'DOacclim[7, *]'
;PRINT, TRANSPOSE(4*DOacclim[7, 0:100])
;PRINT, 'DOacclim[5, *]'
;PRINT, TRANSPOSE(2*DOacclim[5, 0:100])

; When ambient DO is below the mimimum critical DO...
DOf10 = WHERE(DOf0a LT 0., DOf1count0)
DOf11 = WHERE(DOf1a LT 0., DOf1count1)
DOf12 = WHERE(DOf2a LT 0., DOf1count2)
DOf13 = WHERE(DOf3a LT 0., DOf1count3)
DOf14 = WHERE(DOf4a LT 0., DOf1count4)
DOf15 = WHERE(DOf5a LT 0., DOf1count5)
DOf16 = WHERE(DOf6a LT 0., DOf1count6)
IF DOf1count0 GT 0.0 THEN DOf[0, DOf10] = 0.0; 
IF DOf1count1 GT 0.0 THEN DOf[1, DOf11] = 0.0; 
IF DOf1count2 GT 0.0 THEN DOf[2, DOf12] = 0.0; 
IF DOf1count3 GT 0.0 THEN DOf[3, DOf13] = 0.0; 
IF DOf1count4 GT 0.0 THEN DOf[4, DOf14] = 0.0; 
IF DOf1count5 GT 0.0 THEN DOf[5, DOf15] = 0.0; 
IF DOf1count6 GT 0.0 THEN DOf[6, DOf16] = 0.0; 

; WHEN ambient DO is between the minimum critical DO and the critical DO...
DOf20 = WHERE(((DOf0a GE 0.) AND (DOf0b LE 0.)), DOf2count0)
DOf21 = WHERE(((DOf1a GE 0.) AND (DOf1b LE 0.)), DOf2count1)  
DOf22 = WHERE(((DOf2a GE 0.) AND (DOf2b LE 0.)), DOf2count2)
DOf23 = WHERE(((DOf3a GE 0.) AND (DOf3b LE 0.)), DOf2count3)
DOf24 = WHERE(((DOf4a GE 0.) AND (DOf4b LE 0.)), DOf2count4)
DOf25 = WHERE(((DOf5a GE 0.) AND (DOf5b LE 0.)), DOf2count5)
DOf26 = WHERE(((DOf6a GE 0.) AND (DOf6b LE 0.)), DOf2count6)
IF DOf2count0 GT 0.0 THEN DOf[0, DOf20] = ((EnvironV[7, DOf20] - 5*DOacclim[7, DOf20])/(2.*DOacclim[5, DOf20] - 5*DOacclim[7, DOf20]))
IF DOf2count1 GT 0.0 THEN DOf[1, DOf21] = ((EnvironV[22, DOf21] - 5*DOacclim[7, DOf21])/(2.*DOacclim[5, DOf21] - 5*DOacclim[7, DOf21]))
IF DOf2count2 GT 0.0 THEN DOf[2, DOf22] = ((EnvironV[37, DOf22] - 5*DOacclim[7, DOf22])/(2.*DOacclim[5, DOf22] - 5*DOacclim[7, DOf22]))
IF DOf2count3 GT 0.0 THEN DOf[3, DOf23] = ((EnvironV[52, DOf23] - 5*DOacclim[7, DOf23])/(2.*DOacclim[5, DOf23] - 5*DOacclim[7, DOf23]))
IF DOf2count4 GT 0.0 THEN DOf[4, DOf24] = ((EnvironV[67, DOf24] - 5*DOacclim[7, DOf24])/(2.*DOacclim[5, DOf24] - 5*DOacclim[7, DOf24]))
IF DOf2count5 GT 0.0 THEN DOf[5, DOf25] = ((EnvironV[82, DOf25] - 5*DOacclim[7, DOf25])/(2.*DOacclim[5, DOf25] - 5*DOacclim[7, DOf25]))
IF DOf2count6 GT 0.0 THEN DOf[6, DOf26] = ((EnvironV[97, DOf26] - 5*DOacclim[7, DOf26])/(2.*DOacclim[5, DOf26] - 5*DOacclim[7, DOf26]))

; When ambient DO is ABOVE the critical DO...
DOf30 = WHERE((DOf0b GT 0.), DOf3count0)
DOf31 = WHERE((DOf1b GT 0.), DOf3count1)
DOf32 = WHERE((DOf2b GT 0.), DOf3count2)
DOf33 = WHERE((DOf3b GT 0.), DOf3count3)
DOf34 = WHERE((DOf4b GT 0.), DOf3count4)
DOf35 = WHERE((DOf5b GT 0.), DOf3count5)
DOf36 = WHERE((DOf6b GT 0.), DOf3count6)
IF DOf3count0 GT 0.0 THEN DOf[0, DOf30] = 1.0
IF DOf3count1 GT 0.0 THEN DOf[1, DOf31] = 1.0
IF DOf3count2 GT 0.0 THEN DOf[2, DOf32] = 1.0
IF DOf3count3 GT 0.0 THEN DOf[3, DOf33] = 1.0
IF DOf3count4 GT 0.0 THEN DOf[4, DOf34] = 1.0
IF DOf3count5 GT 0.0 THEN DOf[5, DOf35] = 1.0
IF DOf3count6 GT 0.0 THEN DOf[6, DOf36] = 1.0
;PRINT, 'DOf'
;PRINT, DOf[*, *]
;*************************************************************************************************************************


; Temperature**************************************************************************************************************
;CTO = Optimal temperture for consumption
;CTM = Maximum temperture for consumption
CA = FLTARR(nYP)
CB = FLTARR(nYP)
CQ = FLTARR(nYP)
CTM = FLTARR(nYP)
CTO = FLTARR(nYP)
;values are for larval yellow perch
TL = WHERE(YP[1, *] LT 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CA[TL] = 0.51
  CB[TL] = -0.42
  CQ[TL] = 2.3
  CTM[TL] = 32.0
  CTO[TL] = 29.0
ENDIF
;values are for juvenile yellow perch
TLL = WHERE((YP[1, *] GE 20.0 ) AND (YP[1, *] LT 100.0 ), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  CA[TLL] = 0.25
  CB[TLL] = -0.27
  CQ[TLL] = 2.3
  CTM[TLL] = 32.0
  CTO[TLL] = 29.0
ENDIF
;values are for adult yellow perch
TLLL = WHERE((YP[1, *] GE 100.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  CA[TLLL] = 0.25
  CB[TLLL] = -0.27
  CQ[TLLL] = 2.3
  CTM[TLLL] = 28.0
  CTO[TLLL] = 23.0
ENDIF

V_C0 = (CTM - EnvironV[6, *]) / (CTM - CTO)
V_C1 = (CTM - EnvironV[21, *]) / (CTM - CTO)
V_C2 = (CTM - EnvironV[36, *]) / (CTM - CTO)
V_C3 = (CTM - EnvironV[51, *]) / (CTM - CTO)
V_C4 = (CTM - EnvironV[66, *]) / (CTM - CTO)
V_C5 = (CTM - EnvironV[81, *]) / (CTM - CTO)
V_C6 = (CTM - EnvironV[96, *]) / (CTM - CTO)

Z_C = ALOG(CQ) * (CTM - CTO)
Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0

Tf[0, *] = V_C0^X_C * EXP(X_C * (1.0 - V_C0))
Tf[1, *] = V_C1^X_C * EXP(X_C * (1.0 - V_C1))
Tf[2, *] = V_C2^X_C * EXP(X_C * (1.0 - V_C2))
Tf[3, *] = V_C3^X_C * EXP(X_C * (1.0 - V_C3))
Tf[4, *] = V_C4^X_C * EXP(X_C * (1.0 - V_C4))
Tf[5, *] = V_C5^X_C * EXP(X_C * (1.0 - V_C5))
Tf[6, *] = V_C6^X_C * EXP(X_C * (1.0 - V_C6))
;PRINT, 'Tf'
;PRINT, Tf
;***********************************************************************************************************************


; Light*****************************************************************************************************************
litfac = FLTARR(7, nYP); a multiplication factor to include the effect of light intensity
t1 = FLTARR(7, nYP)
t2 = FLTARR(7, nYP)
;***litfac using "flicker frequency" from Ali & Ryder***.
; this light function reflects avoidance of high light level behaviors at the surface
la = 0.0183877D
lb = 0.39361465D
lc = 0.0040855314D
ld = -1.7306173D

t1[0, *] = EXP(-1. * lb * (EnvironV[8, *] - ld))
t1[1, *] = EXP(-1. * lb * (EnvironV[23, *] - ld))
t1[2, *] = EXP(-1. * lb * (EnvironV[38, *] - ld))
t1[3, *] = EXP(-1. * lb * (EnvironV[53, *] - ld))
t1[4, *] = EXP(-1. * lb * (EnvironV[68, *] - ld))
t1[5, *] = EXP(-1. * lb * (EnvironV[83, *] - ld))
t1[6, *] = EXP(-1. * lb * (EnvironV[98, *] - ld))
 
t2[0, *] = EXP(-1. * lc * (EnvironV[8, *] - ld))
t2[1, *] = EXP(-1. * lc * (EnvironV[23, *] - ld))
t2[2, *] = EXP(-1. * lc * (EnvironV[38, *] - ld))
t2[3, *] = EXP(-1. * lc * (EnvironV[53, *] - ld))
t2[4, *] = EXP(-1. * lc * (EnvironV[68, *] - ld))
t2[5, *] = EXP(-1. * lc * (EnvironV[83, *] - ld))
t2[6, *] = EXP(-1. * lc * (EnvironV[98, *] - ld))

t3 = lc - lb
litfac[0, *] = ABS(((la + lb) * (t1[0, *] - t2[0, *])) / t3)
litfac[1, *] = ABS(((la + lb) * (t1[1, *] - t2[1, *])) / t3)
litfac[2, *] = ABS(((la + lb) * (t1[2, *] - t2[2, *])) / t3)
litfac[3, *] = ABS(((la + lb) * (t1[3, *] - t2[3, *])) / t3)
litfac[4, *] = ABS(((la + lb) * (t1[4, *] - t2[4, *])) / t3)
litfac[5, *] = ABS(((la + lb) * (t1[5, *] - t2[5, *])) / t3)
litfac[6, *] = ABS(((la + lb) * (t1[6, *] - t2[6, *])) / t3)
;PRINT, 'Light intensity (lux)'
;PRINT, TRANSPOSE(newinput[11, 0:77499*24:77500])
;PRINT, N_ELEMENTS(NEWINPUT[11, *])
;PRINT, 'Light multiplication factor'
;PRINT, TRANSPOSE(litfac)
;***********************************************************************************************************************


; Incorporate a random component to habitat quality index
EnvironVDO = FLTARR(7, nYP)
EnvironVT = FLTARR(7, nYP)
EnvironVL = FLTARR(7, nYP)

EnvironVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nYP, /DOUBLE))
;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component

EnvironVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nYP, /DOUBLE))
;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component

EnvironVL[0, *] = DOUBLE(litfac[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[1, *] = DOUBLE(litfac[1, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[2, *] = DOUBLE(litfac[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[3, *] = DOUBLE(litfac[3, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[4, *] = DOUBLE(litfac[4, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[5, *] = DOUBLE(litfac[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironVL[6, *] = DOUBLE(litfac[6, *] * RANDOMU(seed, nYP, /DOUBLE))
;PRINT, 'EnvironVDO'
;PRINT, EnvironVDO[*, 0:100]
;PRINT, 'EnvironVT'
;PRINT, EnvironVT[*, 0:100]


; Determine predation risk*****************************************************************************************************
; Fish prey density
; Walleye
Preddens = FLTARR(14, nYP)
Preddens[0, *] = FishPred[7, LocV[0, *]]/ GridCellHorSize
Preddens[1, *] = FishPred[7, LocV[1, *]]/ GridCellHorSize
Preddens[2, *] = FishPred[7, LocV[2, *]]/ GridCellHorSize
Preddens[3, *] = FishPred[7, LocV[3, *]]/ GridCellHorSize
Preddens[4, *] = FishPred[7, LocV[4, *]]/ GridCellHorSize
Preddens[5, *] = FishPred[7, LocV[5, *]]/ GridCellHorSize
Preddens[6, *] = FishPred[7, LocV[6, *]]/ GridCellHorSize

; yellow perch
Preddens[7, *] = FishPred[3, LocV[0, *]]/ GridCellHorSize
Preddens[8, *] = FishPred[3, LocV[1, *]]/ GridCellHorSize
Preddens[9, *] = FishPred[3, LocV[2, *]]/ GridCellHorSize
Preddens[10, *] = FishPred[3, LocV[3, *]]/ GridCellHorSize
Preddens[11, *] = FishPred[3, LocV[4, *]]/ GridCellHorSize
Preddens[12, *] = FishPred[3, LocV[5, *]]/ GridCellHorSize
Preddens[13, *] = FishPred[3, LocV[6, *]]/ GridCellHorSize
;PRINT, 'DENS'
;PRINT, DENS[*, 0:100]

LengthLT200A = WHERE((FishPred[5, LocV[0, *]] LT 200.0) AND (FishPred[5, LocV[0, *]] GT 0.), LengthLT200Acount); 
LengthLT200B = WHERE((FishPred[5, LocV[1, *]] LT 200.0) AND (FishPred[5, LocV[1, *]] GT 0.), LengthLT200Bcount); 
LengthLT200C = WHERE((FishPred[5, LocV[2, *]] LT 200.0) AND (FishPred[5, LocV[2, *]] GT 0.), LengthLT200Ccount); 
LengthLT200D = WHERE((FishPred[5, LocV[3, *]] LT 200.0) AND (FishPred[5, LocV[3, *]] GT 0.), LengthLT200Dcount); 
LengthLT200E = WHERE((FishPred[5, LocV[4, *]] LT 200.0) AND (FishPred[5, LocV[4, *]] GT 0.), LengthLT200Ecount); 
LengthLT200F = WHERE((FishPred[5, LocV[5, *]] LT 200.0) AND (FishPred[5, LocV[5, *]] GT 0.), LengthLT200Fcount); 
LengthLT200G = WHERE((FishPred[5, LocV[6, *]] LT 200.0) AND (FishPred[5, LocV[6, *]] GT 0.), LengthLT200Gcount); 

LengthGE200A = WHERE((FishPred[5, LocV[0, *]] GE 200.0), LengthGE200Acount); 
LengthGE200B = WHERE((FishPred[5, LocV[1, *]] GE 200.0), LengthGE200Bcount); 
LengthGE200C = WHERE((FishPred[5, LocV[2, *]] GE 200.0), LengthGE200Ccount); 
LengthGE200D = WHERE((FishPred[5, LocV[3, *]] GE 200.0), LengthGE200Dcount); 
LengthGE200E = WHERE((FishPred[5, LocV[4, *]] GE 200.0), LengthGE200Ecount); 
LengthGE200F = WHERE((FishPred[5, LocV[5, *]] GE 200.0), LengthGE200Fcount); 
LengthGE200G = WHERE((FishPred[5, LocV[6, *]] GE 200.0), LengthGE200Gcount); 

PredRisk = FLTARR(14, nYP)
; walleye predators
IF (LengthLT200Acount GT 0.0) THEN BEGIN
  PredL1A = WHERE(((YP[1, LengthLT200A] / FishPred[5, LocV[0, LengthLT200A]]) LT 0.6), PredL1Acount, complement = PredL1Ac, ncomplement = PredL1Account)
  IF (PredL1Acount GT 0.0) THEN PredRisk[0, LengthLT200A[PredL1A]] = 0.9
  IF (PredL1Account GT 0.0) THEN PredRisk[0, LengthLT200A[PredL1Ac]] = 0.00 ; 
ENDIF  
IF (LengthGE200Acount GT 0.0) THEN BEGIN
  PredL1A = WHERE(((YP[1, LengthGE200A] / FishPred[5, LocV[0, LengthGE200A]]) LT 0.4), PredL1Acount, complement = PredL1Ac, ncomplement = PredL1Account)
  IF (PredL1Acount GT 0.0) THEN PredRisk[0, LengthGE200A[PredL1A]] = 0.9
  IF (PredL1Account GT 0.0) THEN PredRisk[0, LengthGE200A[PredL1Ac]] = 0.00 ;
ENDIF

IF (LengthLT200Bcount GT 0.0) THEN BEGIN
  PredL1B = WHERE(((YP[1, LengthLT200B] / FishPred[5, LocV[1, LengthLT200B]]) LT 0.6), PredL1Bcount, complement = PredL1Bc, ncomplement = PredL1Bccount)
  IF (PredL1Bcount GT 0.0) THEN PredRisk[1, LengthLT200B[PredL1B]] = 0.9
  IF (PredL1Bccount GT 0.0) THEN PredRisk[1, LengthLT200B[PredL1Bc]] = 0.00 ; 
ENDIF  
IF (LengthGE200Bcount GT 0.0) THEN BEGIN
  PredL1B = WHERE(((YP[1, LengthGE200B] / FishPred[5, LocV[1, LengthGE200B]]) LT 0.4), PredL1Bcount, complement = PredL1Bc, ncomplement = PredL1Bccount)
  IF (PredL1Bcount GT 0.0) THEN PredRisk[1, LengthGE200B[PredL1B]] = 0.9
  IF (PredL1Bccount GT 0.0) THEN PredRisk[1, LengthGE200B[PredL1Bc]] = 0.00 ; 
ENDIF

IF (LengthLT200Ccount GT 0.0) THEN BEGIN
  PredL1C = WHERE(((YP[1, LengthLT200C] / FishPred[5, LocV[2, LengthLT200C]]) LT 0.6), PredL1Ccount, complement = PredL1Cc, ncomplement = PredL1Cccount)
  IF (PredL1Ccount GT 0.0) THEN PredRisk[2, LengthLT200C[PredL1C]] = 0.9
  IF (PredL1Cccount GT 0.0) THEN PredRisk[2, LengthLT200C[PredL1Cc]] = 0.00 ; 
ENDIF  
IF (LengthGE200Ccount GT 0.0) THEN BEGIN
  PredL1C = WHERE(((YP[1, LengthGE200C] / FishPred[5, LocV[2, LengthGE200C]]) LT 0.4), PredL1Ccount, complement = PredL1Cc, ncomplement = PredL1Cccount)
  IF (PredL1Ccount GT 0.0) THEN PredRisk[2, LengthGE200C[PredL1C]] = 0.9
  IF (PredL1Cccount GT 0.0) THEN PredRisk[2, LengthGE200C[PredL1Cc]] = 0.00 ; 
ENDIF

IF (LengthLT200Dcount GT 0.0) THEN BEGIN
  PredL1D = WHERE(((YP[1, LengthLT200D] / FishPred[5, LocV[3, LengthLT200D]]) LT 0.6), PredL1Dcount, complement = PredL1Dc, ncomplement = PredL1Dccount)
  IF (PredL1Dcount GT 0.0) THEN PredRisk[3, LengthLT200D[PredL1D]] = 0.9
  IF (PredL1Dccount GT 0.0) THEN PredRisk[3, LengthLT200D[PredL1Dc]] = 0.00 ;
ENDIF  
IF (LengthGE200Dcount GT 0.0) THEN BEGIN
  PredL1D = WHERE(((YP[1, LengthGE200D] / FishPred[5, LocV[3, LengthGE200D]]) LT 0.4), PredL1Dcount, complement = PredL1Dc, ncomplement = PredL1Dccount)
  IF (PredL1Dcount GT 0.0) THEN PredRisk[3, LengthGE200D[PredL1D]] = 0.9
  IF (PredL1Dccount GT 0.0) THEN PredRisk[3, LengthGE200D[PredL1Dc]] = 0.00 ; 
ENDIF

IF (LengthLT200Ecount GT 0.0) THEN BEGIN
  PredL1E = WHERE(((YP[1, LengthLT200E] / FishPred[5, LocV[4, LengthLT200E]]) LT 0.6), PredL1Ecount, complement = PredL1Ec, ncomplement = PredL1Eccount)
  IF (PredL1Ecount GT 0.0) THEN PredRisk[4, LengthLT200E[PredL1E]] = 0.9
  IF (PredL1Eccount GT 0.0) THEN PredRisk[4, LengthLT200E[PredL1Ec]] = 0.00 ; for walleye
ENDIF  
IF (LengthGE200Ecount GT 0.0) THEN BEGIN
  PredL1E = WHERE(((YP[1, LengthGE200E] / FishPred[5, LocV[4, LengthGE200E]]) LT 0.4), PredL1Ecount, complement = PredL1Ec, ncomplement = PredL1Eccount)
  IF (PredL1Ecount GT 0.0) THEN PredRisk[4, LengthGE200E[PredL1E]] = 0.9
  IF (PredL1Eccount GT 0.0) THEN PredRisk[4, LengthGE200E[PredL1Ec]] = 0.00 ; for walleye
ENDIF

IF (LengthLT200Fcount GT 0.0) THEN BEGIN
  PredL1F = WHERE(((YP[1, LengthLT200F] / FishPred[5, LocV[5, LengthLT200F]]) LT 0.6), PredL1Fcount, complement = PredL1Fc, ncomplement = PredL1Fccount)
  IF (PredL1Fcount GT 0.0) THEN PredRisk[5, LengthLT200F[PredL1F]] = 0.9
  IF (PredL1Fccount GT 0.0) THEN PredRisk[5, LengthLT200F[PredL1Fc]] = 0.00 ; for walleye
ENDIF  
IF (LengthGE200Fcount GT 0.0) THEN BEGIN
  PredL1F = WHERE(((YP[1, LengthGE200F] / FishPred[5, LocV[5, LengthGE200F]]) LT 0.4), PredL1Fcount, complement = PredL1Fc, ncomplement = PredL1Fccount)
  IF (PredL1Fcount GT 0.0) THEN PredRisk[5, LengthGE200F[PredL1F]] = 0.9
  IF (PredL1Fccount GT 0.0) THEN PredRisk[5, LengthGE200F[PredL1Fc]] = 0.00 ; for walleye
ENDIF

IF (LengthLT200Gcount GT 0.0) THEN BEGIN
  PredL1G = WHERE(((YP[1, LengthLT200G] / FishPred[5, LocV[6, LengthLT200G]]) LT 0.6), PredL1Gcount, complement = PredL1Gc, ncomplement = PredL1Gccount)
  IF (PredL1Gcount GT 0.0) THEN PredRisk[6, LengthLT200G[PredL1G]] = 0.9
  IF (PredL1Gccount GT 0.0) THEN PredRisk[6, LengthLT200G[PredL1Gc]] = 0.00 ; for walleye
ENDIF  
IF (LengthGE200Gcount GT 0.0) THEN BEGIN
  PredL1G = WHERE(((YP[1, LengthGE200G] / FishPred[5, LocV[6, LengthGE200G]]) LT 0.4), PredL1Gcount, complement = PredL1Gc, ncomplement = PredL1Gccount)
  IF (PredL1Gcount GT 0.0) THEN PredRisk[6, LengthGE200G[PredL1G]] = 0.9
  IF (PredL1Gccount GT 0.0) THEN PredRisk[6, LengthGE200G[PredL1Gc]] = 0.00 ; for walleye
ENDIF

LengthGE150A = WHERE((FishPred[0, LocV[0, *]] GE 150.0), LengthGE150Acount); 
LengthGE150B = WHERE((FishPred[0, LocV[1, *]] GE 150.0), LengthGE150Bcount); 
LengthGE150C = WHERE((FishPred[0, LocV[2, *]] GE 150.0), LengthGE150Ccount); 
LengthGE150D = WHERE((FishPred[0, LocV[3, *]] GE 150.0), LengthGE150Dcount); 
LengthGE150E = WHERE((FishPred[0, LocV[4, *]] GE 150.0), LengthGE150Ecount); 
LengthGE150F = WHERE((FishPred[0, LocV[5, *]] GE 150.0), LengthGE150Fcount); 
LengthGE150G = WHERE((FishPred[0, LocV[6, *]] GE 150.0), LengthGE150Gcount); 

; perch predators
IF (LengthGE150Acount GT 0.0) THEN BEGIN
  PredL2A = WHERE(((YP[1, LengthGE150A] / FishPred[0, LocV[0, LengthGE150A]]) LT 0.2), PredL2Acount, complement = PredL2Ac, ncomplement = PredL2Account)
  IF (PredL2Acount GT 0.0) THEN PredRisk[7, LengthGE150A[PredL2A]] = 0.6
  IF (PredL2Account GT 0.0) THEN PredRisk[7, LengthGE150A[PredL2Ac]] = 0.; 
ENDIF  
IF (LengthGE150Bcount GT 0.0) THEN BEGIN
  PredL2B = WHERE(((YP[1, LengthGE150B] / FishPred[0, LocV[1, LengthGE150B]]) LT 0.2), PredL2Bcount, complement = PredL2Bc, ncomplement = PredL2Bccount)
  IF (PredL2Bcount GT 0.0) THEN PredRisk[8, LengthGE150B[PredL2B]] = 0.6
  IF (PredL2Bccount GT 0.0) THEN PredRisk[8, LengthGE150B[PredL2Bc]] = 0.; 
ENDIF
IF (LengthGE150Ccount GT 0.0) THEN BEGIN
  PredL2C = WHERE(((YP[1, LengthGE150C] / FishPred[0, LocV[2, LengthGE150C]]) LT 0.2), PredL2Ccount, complement = PredL2Cc, ncomplement = PredL2Cccount)
  IF (PredL2Ccount GT 0.0) THEN PredRisk[9, LengthGE150C[PredL2C]] = 0.6
  IF (PredL2Cccount GT 0.0) THEN PredRisk[9, LengthGE150C[PredL2Cc]] = 0.; 
ENDIF  
IF (LengthGE150Dcount GT 0.0) THEN BEGIN
  PredL2D = WHERE(((YP[1, LengthGE150D] / FishPred[0, LocV[3, LengthGE150D]]) LT 0.2), PredL2Dcount, complement = PredL2Dc, ncomplement = PredL2Dccount)
  IF (PredL2Dcount GT 0.0) THEN PredRisk[10, LengthGE150D[PredL2D]] = 0.6
  IF (PredL2Dccount GT 0.0) THEN PredRisk[10, LengthGE150D[PredL2Dc]] = 0.; 
ENDIF  
IF (LengthGE150Ecount GT 0.0) THEN BEGIN
  PredL2E = WHERE(((YP[1, LengthGE150E] / FishPred[0, LocV[4, LengthGE150E]]) LT 0.2), PredL2Ecount, complement = PredL2Ec, ncomplement = PredL2Eccount)
  IF (PredL2Ecount GT 0.0) THEN PredRisk[11, LengthGE150E[PredL2E]] = 0.6
  IF (PredL2Eccount GT 0.0) THEN PredRisk[11, LengthGE150E[PredL2Ec]] = 0.; 
ENDIF  
IF (LengthGE150Fcount GT 0.0) THEN BEGIN
  PredL2F = WHERE(((YP[1, LengthGE150F] / FishPred[0, LocV[5, LengthGE150F]]) LT 0.2), PredL2Fcount, complement = PredL2Fc, ncomplement = PredL2Fccount)
  IF (PredL2Fcount GT 0.0) THEN PredRisk[12, LengthGE150F[PredL2F]] = 0.6
  IF (PredL2Fccount GT 0.0) THEN PredRisk[12, LengthGE150F[PredL2Fc]] = 0.; 
ENDIF  
IF (LengthGE150Gcount GT 0.0) THEN BEGIN
  PredL2G = WHERE(((YP[1, LengthGE150G] / FishPred[0, LocV[6, LengthGE150G]]) LT 0.2), PredL2Gcount, complement = PredL2Gc, ncomplement = PredL2Gccount)
  IF (PredL2Gcount GT 0.0) THEN PredRisk[13, LengthGE150G[PredL2G]] = 0.6
  IF (PredL2Gccount GT 0.0) THEN PredRisk[13, LengthGE150G[PredL2Gc]] = 0.; 
ENDIF  

; Calculate attack probability using chesson's alpha = capture efficiency
TOTpred = FLTARR(7, nYP); total number of all prey atacked and captured
Predt = FLTARR(2*7, nYP); total number of each prey atacked and captured
; walleye
Predt[0,*] = (PredRisk[0,*] * Preddens[0,*]); * FishPred[6, LocV[0, *]]
Predt[1,*] = (PredRisk[1,*] * Preddens[1,*]); * FishPred[6, LocV[1, *]]
Predt[2,*] = (PredRisk[2,*] * Preddens[2,*]); * FishPred[6, LocV[2, *]]
Predt[3,*] = (PredRisk[3,*] * Preddens[3,*]); * FishPred[6, LocV[3, *]]
Predt[4,*] = (PredRisk[4,*] * Preddens[4,*]); * FishPred[6, LocV[4, *]]
Predt[5,*] = (PredRisk[5,*] * Preddens[5,*]); * FishPred[6, LocV[5, *]]
Predt[6,*] = (PredRisk[6,*] * Preddens[6,*]); * FishPred[6, LocV[6, *]]

; yellow perch
Predt[7,*] = (PredRisk[7,*] * Preddens[7,*]); * FishPred[1, LocV[0, *]]
Predt[8,*] = (PredRisk[8,*] * Preddens[8,*]); * FishPred[1, LocV[1, *]]
Predt[9,*] = (PredRisk[9,*] * Preddens[9,*]); * FishPred[1, LocV[2, *]]
Predt[10,*] = (PredRisk[10,*] * Preddens[10,*]); * FishPred[1, LocV[3, *]]
Predt[11,*] = (PredRisk[11,*] * Preddens[11,*]); * FishPred[1, LocV[4, *]]
Predt[12,*] = (PredRisk[12,*] * Preddens[12,*]); * FishPred[1, LocV[5, *]]
Predt[13,*] = (PredRisk[13,*] * Preddens[13,*]); * FishPred[1, LocV[6, *]]

TOTpred[0, *] = Predt[0,*] + Predt[7,*] 
TOTpred[1, *] = Predt[1,*] + Predt[8,*] 
TOTpred[2, *] = Predt[2,*] + Predt[9,*] 
TOTpred[3, *] = Predt[3,*] + Predt[10,*] 
TOTpred[4, *] = Predt[4,*] + Predt[11,*]
TOTpred[5, *] = Predt[5,*] + Predt[12,*] 
TOTpred[6, *] = Predt[6,*] + Predt[13,*] 
;PRINT, 'TOTpred'
;PRINT, TRANSPOSE(TOTpred[*, 0:99])


; Calculate WEIGHTED cumulative prey biomass for each NEIGHBORING layer 
; And copy cumulative prey biomass to all NEIGHBORING cells
predTOT = FLTARR(nYP)
predTOT = TOTAL(TOTpred[0:6, *], 1)  
predTOT2 = FLTARR(7, nYP)
predTOT2[0, *] = predTOT
predTOT2[1, *] = predTOT
predTOT2[2, *] = predTOT
predTOT2[3, *] = predTOT
predTOT2[4, *] = predTOT
predTOT2[5, *] = predTOT
predTOT2[6, *] = predTOT
;PRINT, 'PredTOT'
;PRINT, PredTOT2[*, 0:100]

EnvironVpred = FLTARR(7, nYP)
predTOTnz = WHERE(predTOT GT 0., predTOTnzcount, COMPLEMENT = predTOTz, NCOMPLEMENT = predTOTzcount)
IF predTOTnzcount GT 0. THEN BEGIN
  EnvironVpred[0, predTOTnz] = (1. - TOTpred[0, predTOTnz] / predTOT2[0, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[1, predTOTnz] = (1. - TOTpred[1, predTOTnz] / predTOT2[1, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[2, predTOTnz] = (1. - TOTpred[2, predTOTnz] / predTOT2[2, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[3, predTOTnz] = (1. - TOTpred[3, predTOTnz] / predTOT2[3, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[4, predTOTnz] = (1. - TOTpred[4, predTOTnz] / predTOT2[4, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[5, predTOTnz] = (1. - TOTpred[5, predTOTnz] / predTOT2[5, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
  EnvironVpred[6, predTOTnz] = (1. - TOTpred[6, predTOTnz] / predTOT2[6, predTOTnz]) * RANDOMU(seed, predTOTnzcount, /DOUBLE)
ENDIF 
IF predTOTzcount GT 0. THEN BEGIN
  EnvironVpred[0, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[1, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[2, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[3, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[4, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[5, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
  EnvironVpred[6, predTOTz] = RANDOMU(seed, predTOTzcount, /DOUBLE)
ENDIF 
;PRINT, 'EnvironVpred'
;PRINT, TRANSPOSE(EnvironVpred[*, 0:99])
;***********************************************************************************************************************


; Determine prey fields*****************************************************************************************************
;prey YP[1, *] 
m = 10; the number of prey types 
PL = FLTARR(m, nYP)
PL[0, *] = RANDOMU(seed, nYP)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nYP)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nYP)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nYP)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nYP)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm
;PL[5, *] = FISHPREY[1, *]; length for yellow perch in mm 
;PL[6, *] = FISHPREY[5, *]; length for emerald shiner in mm 
;PL[7, *] = FISHPREY[9, *]; length for rainbow smelt in mm 
;PL[8, *] = FISHPREY[13, *]; length for round goby in mm 


; prey weight
PW = FLTARR(m, nYP); weight of each prey type
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet
;PW[5, *] = FISHPREY[2, *];
;PW[6, *] = FISHPREY[6, *];
;PW[7, *] = FISHPREY[10, *];
;PW[8, *] = FISHPREY[14, *];


; convert prey biomass (g/L or m^2) into numbers/L or m^2
dens = FLTARR(m*7, nYP)  
; microzooplankton
dens[0,*] = EnvironV[2, *] / Pw[0, *]
dens[1,*] = EnvironV[17, *] / Pw[0, *]
dens[2,*] = EnvironV[32, *] / Pw[0, *]
dens[3,*] = EnvironV[47, *] / Pw[0, *]
dens[4,*] = EnvironV[62, *] / Pw[0, *]
dens[5,*] = EnvironV[77, *] / Pw[0, *]
dens[6,*] = EnvironV[92, *] / Pw[0, *]

; small mesozooplankton
dens[7,*] = EnvironV[3, *] / Pw[1, *]
dens[8,*] = EnvironV[18, *] / Pw[1, *]
dens[9,*] = EnvironV[33, *] / Pw[1, *]
dens[10,*] = EnvironV[48, *] / Pw[1, *]
dens[11,*] = EnvironV[63, *] / Pw[1, *]
dens[12,*] = EnvironV[78, *] / Pw[1, *]
dens[13,*] = EnvironV[93, *] / Pw[1, *]

; large mesozooplankton
dens[14,*] = EnvironV[4, *] / Pw[2, *]
dens[15,*] = EnvironV[19, *] / Pw[2, *]
dens[16,*] = EnvironV[34, *] / Pw[2, *]
dens[17,*] = EnvironV[49, *] / Pw[2, *]
dens[18,*] = EnvironV[64, *] / Pw[2, *]
dens[19,*] = EnvironV[79, *] / Pw[2, *]
dens[20,*] = EnvironV[94, *] / Pw[2, *]

; benthos (chironmoids), numbers/m^2
pbio3i = WHERE(EnvironV[5, *] GT 0.0, pbio3icount, complement = pbio3ic, ncomplement = pbio3iccount)
IF pbio3icount GT 0.0 THEN dens[21, pbio3i] = EnvironV[5, pbio3i] / Pw[3, pbio3i] ELSE dens[21, pbio3ic] = 0.0
pbio3j = WHERE(EnvironV[20, *] GT 0.0, pbio3jcount, complement = pbio3jc, ncomplement = pbio3jccount)
IF pbio3jcount GT 0.0 THEN dens[22, pbio3j] = EnvironV[20, pbio3j] / Pw[3, pbio3j] ELSE dens[22, pbio3jc] = 0.0
pbio3k = WHERE(EnvironV[35, *] GT 0.0, pbio3kcount, complement = pbio3kc, ncomplement = pbio3kccount)
IF pbio3kcount GT 0.0 THEN dens[23, pbio3k] = EnvironV[35, pbio3k] / Pw[3, pbio3k] ELSE dens[23, pbio3kc] = 0.0
pbio3l = WHERE(EnvironV[50, *] GT 0.0, pbio3lcount, complement = pbio3lc, ncomplement = pbio3lccount)
IF pbio3lcount GT 0.0 THEN dens[24, pbio3l] = EnvironV[50, pbio3l] / Pw[3, pbio3l] ELSE dens[24, pbio3lc] = 0.0
pbio3o = WHERE(EnvironV[65, *] GT 0.0, pbio3ocount, complement = pbio3oc, ncomplement = pbio3occount)
IF pbio3ocount GT 0.0 THEN dens[25, pbio3o] = EnvironV[65, pbio3o] / Pw[3, pbio3o] ELSE dens[25, pbio3oc] = 0.0
pbio3p = WHERE(EnvironV[80, *] GT 0.0, pbio3pcount, complement = pbio3pc, ncomplement = pbio3pccount)
IF pbio3pcount GT 0.0 THEN dens[26, pbio3p] = EnvironV[80, pbio3p] / Pw[3, pbio3p] ELSE dens[26, pbio3pc] = 0.0
pbio3q = WHERE(EnvironV[95, *] GT 0.0, pbio3qcount, complement = pbio3qc, ncomplement = pbio3qccount)
IF pbio3qcount GT 0.0 THEN dens[27, pbio3q] = EnvironV[95, pbio3q] / Pw[3, pbio3q] ELSE dens[27, pbio3qc] = 0.0

; Invasive species (0 for now)
dens[28,*] = EnvironV[9, *] / Pw[4, *]
dens[29,*] = EnvironV[24, *] / Pw[4, *]
dens[30,*] = EnvironV[39, *] / Pw[4, *]
dens[31,*] = EnvironV[54, *] / Pw[4, *]
dens[32,*] = EnvironV[69, *] / Pw[4, *]
dens[33,*] = EnvironV[84, *] / Pw[4, *]
dens[34,*] = EnvironV[99, *] / Pw[4, *]

; Fish prey
; yellow perch
dens[35, *] = FISHPREY[4, LocV[0, *]]
dens[36, *] = FISHPREY[4, LocV[1, *]]
dens[37, *] = FISHPREY[4, LocV[2, *]]
dens[38, *] = FISHPREY[4, LocV[3, *]]
dens[39, *] = FISHPREY[4, LocV[4, *]]
dens[40, *] = FISHPREY[4, LocV[5, *]]
dens[41, *] = FISHPREY[4, LocV[6, *]]

; Emerald Shiner 
dens[42, *] = FISHPREY[10, LocV[0, *]]
dens[43, *] = FISHPREY[10, LocV[1, *]]
dens[44, *] = FISHPREY[10, LocV[2, *]]
dens[45, *] = FISHPREY[10, LocV[3, *]]
dens[46, *] = FISHPREY[10, LocV[4, *]]
dens[47, *] = FISHPREY[10, LocV[5, *]]
dens[48, *] = FISHPREY[10, LocV[6, *]]

; Rainbow Smelt
dens[49, *] = FISHPREY[16, LocV[0, *]]
dens[50, *] = FISHPREY[16, LocV[1, *]]
dens[51, *] = FISHPREY[16, LocV[2, *]]
dens[52, *] = FISHPREY[16, LocV[3, *]]
dens[53, *] = FISHPREY[16, LocV[4, *]]
dens[54, *] = FISHPREY[16, LocV[5, *]]
dens[55, *] = FISHPREY[16, LocV[6, *]]

;; Round Goby
;dens[56, *] = FISHPREY[22, LocV[0, *]]
;dens[57, *] = FISHPREY[22, LocV[1, *]]
;dens[58, *] = FISHPREY[22, LocV[2, *]]
;dens[59, *] = FISHPREY[22, LocV[3, *]]
;dens[60, *] = FISHPREY[22, LocV[4, *]]
;dens[61, *] = FISHPREY[22, LocV[5, *]]
;dens[62, *] = FISHPREY[22, LocV[6, *]]

; Walleye
dens[63, *] = FISHPREY[28, LocV[0, *]]
dens[64, *] = FISHPREY[28, LocV[1, *]]
dens[65, *] = FISHPREY[28, LocV[2, *]]
dens[66, *] = FISHPREY[28, LocV[3, *]]
dens[67, *] = FISHPREY[28, LocV[4, *]]
dens[68, *] = FISHPREY[28, LocV[5, *]]
dens[69, *] = FISHPREY[28, LocV[6, *]]
;PRINT, 'DENS'
;PRINT, DENS[*, 0:100]


; Calculate Chesson's alpha for each prey type
Calpha = FLTARR(56, nYP); from Letcher et al. for zooplankton
Calpha[0, *] = 193499 * YP[1, *]^(-7.64); for microzooplankton - rotifers
;Calpha[1, *] = (0.272 * ALOG(Length[*]) - 0.3834) < 1.; for mesozooplankton1 - calanoids
;Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * YP[1, *]))^(1.0 / 0.031) 
  
LengthLT35 = WHERE((YP[1, *] LT 150.0), LengthLT35count, complement = LengthGE35, ncomplement = LengthGE35count)
IF (LengthLT35count GT 0.0) THEN BEGIN
  Calpha[1, LengthLT35] = (0.272 * ALOG(YP[1, LengthLT35]) - 0.3834) < 1.; for mesozooplankton1 - calanoids
  Calpha[2, LengthLT35] = 1. / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * YP[1, LengthLT35]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
ENDIF
IF (LengthGE35count GT 0.0) THEN BEGIN
  Calpha[1, LengthGE35] = 0.1 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * YP[1, LengthGE35]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
  Calpha[2, LengthGE35] = 0.1 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * YP[1, LengthGE35]))^(1.0 / 0.031) ; for mesozooplankton2 - cladocerans
ENDIF

PL3 = WHERE((PL[3, *] / YP[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
IF (pl3count GT 0.0) THEN Calpha[3, PL3] = ABS(1. - 1.75 * (PL[3, PL3] / YP[1, PL3]))
IF (pl3ccount GT 0.0) THEN Calpha[3, PL3c] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 

;Length60 = WHERE(YP[1, *] GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)
;IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
;IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.
 
LengthGT100 = WHERE((YP[1, *] GT 150.0), LengthGT100count, complement = LengthLE100, ncomplement = LengthLE100ccount)

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5A = WHERE(((FISHPREY[1, LocV[0, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Acount, complement = PL5Ac, ncomplement = PL5Account)
  IF (PL5Acount GT 0.0) THEN Calpha[5, LengthGT100[PL5A]] = 0.6
  IF (PL5Account GT 0.0) THEN Calpha[5, LengthGT100[PL5Ac]] = 0. ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5B = WHERE(((FISHPREY[1, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Bcount, complement = PL5Bc, ncomplement = PL5Bccount)
  IF (PL5Bcount GT 0.0) THEN Calpha[6, LengthGT100[PL5B]] = 0.6
  IF (PL5Bccount GT 0.0) THEN Calpha[6, LengthGT100[PL5Bc]] = 0. ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5C = WHERE(((FISHPREY[1, LocV[2, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Ccount, complement = PL5Cc, ncomplement = PL5Cccount)
  IF (PL5Ccount GT 0.0) THEN Calpha[7, LengthGT100[PL5C]] = 0.6
  IF (PL5Cccount GT 0.0) THEN Calpha[7, LengthGT100[PL5Cc]] = 0. ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5D = WHERE(((FISHPREY[1, LocV[3, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Dcount, complement = PL5Dc, ncomplement = PL5Dccount)
  IF (PL5Dcount GT 0.0) THEN Calpha[8, LengthGT100[PL5D]] = 0.6
  IF (PL5Dccount GT 0.0) THEN Calpha[8, LengthGT100[PL5Dc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5E = WHERE(((FISHPREY[1, LocV[4, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Ecount, complement = PL5Ec, ncomplement = PL5Eccount)
  IF (PL5Ecount GT 0.0) THEN Calpha[9, LengthGT100[PL5E]] = 0.6
  IF (PL5Eccount GT 0.0) THEN Calpha[9, LengthGT100[PL5Ec]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5F = WHERE(((FISHPREY[1, LocV[5, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Fcount, complement = PL5Fc, ncomplement = PL5Fccount)
  IF (PL5Fcount GT 0.0) THEN Calpha[10, LengthGT100[PL5F]] = 0.6
  IF (PL5Fccount GT 0.0) THEN Calpha[10, LengthGT100[PL5Fc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL5G = WHERE(((FISHPREY[1, LocV[6, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL5Gcount, complement = PL5Gc, ncomplement = PL5Gccount)
  IF (PL5Gcount GT 0.0) THEN Calpha[11, LengthGT100[PL5G]] = 0.6
  IF (PL5Gccount GT 0.0) THEN Calpha[11, LengthGT100[PL5Gc]] = 0.00 ; for fish
ENDIF


IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6A = WHERE(((FISHPREY[7, LocV[0, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Acount, complement = PL6Ac, ncomplement = PL6Account)
  IF (PL6Acount GT 0.0) THEN Calpha[12, LengthGT100[PL6A]] = 0.6
  IF (PL6Account GT 0.0) THEN Calpha[12, LengthGT100[PL6Ac]] = 0.00 ; for SHINER
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6B = WHERE(((FISHPREY[7, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Bcount, complement = PL6Bc, ncomplement = PL6Bccount)
  IF (PL6Bcount GT 0.0) THEN Calpha[13, LengthGT100[PL6B]] = 0.6
  IF (PL6Bccount GT 0.0) THEN Calpha[13, LengthGT100[PL6Bc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6C = WHERE(((FISHPREY[7, LocV[2, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Ccount, complement = PL6Cc, ncomplement = PL6Cccount)
  IF (PL6Ccount GT 0.0) THEN Calpha[14, LengthGT100[PL6C]] = 0.6
  IF (PL6Cccount GT 0.0) THEN Calpha[14, LengthGT100[PL6Cc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6D = WHERE(((FISHPREY[7, LocV[3, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Dcount, complement = PL6Dc, ncomplement = PL6Dccount)
  IF (PL6Dcount GT 0.0) THEN Calpha[15, LengthGT100[PL6D]] = 0.6
  IF (PL6Dccount GT 0.0) THEN Calpha[15, LengthGT100[PL6Dc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6E = WHERE(((FISHPREY[7, LocV[4, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Ecount, complement = PL6Ec, ncomplement = PL6Eccount)
  IF (PL6Ecount GT 0.0) THEN Calpha[16, LengthGT100[PL6E]] = 0.6
  IF (PL6Eccount GT 0.0) THEN Calpha[16, LengthGT100[PL6Ec]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6F = WHERE(((FISHPREY[7, LocV[5, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Fcount, complement = PL6Fc, ncomplement = PL6Fccount)
  IF (PL6Fcount GT 0.0) THEN Calpha[17, LengthGT100[PL6F]] = 0.6
  IF (PL6Fccount GT 0.0) THEN Calpha[17, LengthGT100[PL6Fc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL6G = WHERE(((FISHPREY[7, LocV[6, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL6Gcount, complement = PL6Gc, ncomplement = PL6Gccount)
  IF (PL6Gcount GT 0.0) THEN Calpha[18, LengthGT100[PL6G]] = 0.6
  IF (PL6Gccount GT 0.0) THEN Calpha[18, LengthGT100[PL6Gc]] = 0.00 ; for fish
ENDIF


IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7A = WHERE(((FISHPREY[13, LocV[0, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Acount, complement = PL7Ac, ncomplement = PL7Account)
  IF (PL7Acount GT 0.0) THEN Calpha[19, LengthGT100[PL7A]] = 0.6
  IF (PL7Account GT 0.0) THEN Calpha[19, LengthGT100[PL7Ac]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7B = WHERE(((FISHPREY[13, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Bcount, complement = PL7Bc, ncomplement = PL7Bccount)
  IF (PL7Bcount GT 0.0) THEN Calpha[20, LengthGT100[PL7B]] = 0.6
  IF (PL7Bccount GT 0.0) THEN Calpha[20, LengthGT100[PL7Bc]] = 0.00 ; for fish
ENDIF 

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7C = WHERE(((FISHPREY[13, LocV[2, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Ccount, complement = PL7Cc, ncomplement = PL7Cccount)
  IF (PL7Ccount GT 0.0) THEN Calpha[21, LengthGT100[PL7C]] = 0.6
  IF (PL7Cccount GT 0.0) THEN Calpha[21, LengthGT100[PL7Cc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7D = WHERE(((FISHPREY[13, LocV[3, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Dcount, complement = PL7Dc, ncomplement = PL7Dccount)
  IF (PL7Dcount GT 0.0) THEN Calpha[22, LengthGT100[PL7D]] = 0.6
  IF (PL7Dccount GT 0.0) THEN Calpha[22, LengthGT100[PL7Dc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7E = WHERE(((FISHPREY[13, LocV[4, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Ecount, complement = PL7Ec, ncomplement = PL7Eccount)
  IF (PL7Ecount GT 0.0) THEN Calpha[23, LengthGT100[PL7E]] = 0.6
  IF (PL7Eccount GT 0.0) THEN Calpha[23, LengthGT100[PL7Ec]] = 0.00 ; for fish
ENDIF 

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7F = WHERE(((FISHPREY[13, LocV[5, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Fcount, complement = PL7Fc, ncomplement = PL7Fccount)
  IF (PL7Fcount GT 0.0) THEN Calpha[24, LengthGT100[PL7F]] = 0.6
  IF (PL7Fccount GT 0.0) THEN Calpha[24, LengthGT100[PL7Fc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL7G = WHERE(((FISHPREY[13, LocV[6, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL7Gcount, complement = PL7Gc, ncomplement = PL7Gccount)
  IF (PL7Gcount GT 0.0) THEN Calpha[25, LengthGT100[PL7G]] = 0.6
  IF (PL7Gccount GT 0.0) THEN Calpha[25, LengthGT100[PL7Gc]] = 0.00 ; for fish
ENDIF


IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8A = WHERE(((FISHPREY[19, LocV[0, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Acount, complement = PL8Ac, ncomplement = PL8Account)
  IF (PL8Acount GT 0.0) THEN Calpha[26, LengthGT100[PL8A]] = 0.6
  IF (PL8Account GT 0.0) THEN Calpha[26, LengthGT100[PL8Ac]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8B = WHERE(((FISHPREY[19, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Bcount, complement = PL8Bc, ncomplement = PL8Bccount)
  IF (PL8Bcount GT 0.0) THEN Calpha[27, LengthGT100[PL8B]] = 0.6
  IF (PL8Bccount GT 0.0) THEN Calpha[27, LengthGT100[PL8Bc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8C = WHERE(((FISHPREY[19, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Ccount, complement = PL8Cc, ncomplement = PL8Cccount)
  IF (PL8Ccount GT 0.0) THEN Calpha[28, LengthGT100[PL8C]] = 0.6
  IF (PL8Cccount GT 0.0) THEN Calpha[28, LengthGT100[PL8Cc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8D = WHERE(((FISHPREY[19, LocV[3, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Dcount, complement = PL8Dc, ncomplement = PL8Dccount)
  IF (PL8Dcount GT 0.0) THEN Calpha[29, LengthGT100[PL8D]] = 0.6
  IF (PL8Dccount GT 0.0) THEN Calpha[29, LengthGT100[PL8Dc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8E = WHERE(((FISHPREY[19, LocV[4, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Ecount, complement = PL8Ec, ncomplement = PL8Eccount)
  IF (PL8Ecount GT 0.0) THEN Calpha[30, LengthGT100[PL8E]] = 0.6
  IF (PL8Eccount GT 0.0) THEN Calpha[30, LengthGT100[PL8Ec]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8F = WHERE(((FISHPREY[19, LocV[5, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Fcount, complement = PL8Fc, ncomplement = PL8Fccount)
  IF (PL8Fcount GT 0.0) THEN Calpha[31, LengthGT100[PL8F]] = 0.6
  IF (PL8Fccount GT 0.0) THEN Calpha[31, LengthGT100[PL8Fc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL8G = WHERE(((FISHPREY[19, LocV[6, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL8Gcount, complement = PL8Gc, ncomplement = PL8Gccount)
  IF (PL8Gcount GT 0.0) THEN Calpha[32, LengthGT100[PL8G]] = 0.6
  IF (PL8Gccount GT 0.0) THEN Calpha[32, LengthGT100[PL8Gc]] = 0.00 ; for fish
ENDIF


IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9A = WHERE(((FISHPREY[25, LocV[0, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Acount, complement = PL9Ac, ncomplement = PL9Account)
  IF (PL9Acount GT 0.0) THEN Calpha[49, LengthGT100[PL9A]] = 0.6
  IF (PL9Account GT 0.0) THEN Calpha[49, LengthGT100[PL9Ac]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9B = WHERE(((FISHPREY[25, LocV[1, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Bcount, complement = PL9Bc, ncomplement = PL9Bccount)
  IF (PL9Bcount GT 0.0) THEN Calpha[50, LengthGT100[PL9B]] = 0.6
  IF (PL9Bccount GT 0.0) THEN Calpha[50, LengthGT100[PL9Bc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9C = WHERE(((FISHPREY[25, LocV[2, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Ccount, complement = PL9Cc, ncomplement = PL9Cccount)
  IF (PL9Ccount GT 0.0) THEN Calpha[51, LengthGT100[PL9C]] = 0.6
  IF (PL9Cccount GT 0.0) THEN Calpha[51, LengthGT100[PL9Cc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9D = WHERE(((FISHPREY[25, LocV[3, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Dcount, complement = PL9Dc, ncomplement = PL9Dccount)
  IF (PL9Dcount GT 0.0) THEN Calpha[52, LengthGT100[PL9D]] = 0.6
  IF (PL9Dccount GT 0.0) THEN Calpha[52, LengthGT100[PL9Dc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9E = WHERE(((FISHPREY[25, LocV[4, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Ecount, complement = PL9Ec, ncomplement = PL9Eccount)
  IF (PL9Ecount GT 0.0) THEN Calpha[53, LengthGT100[PL9E]] = 0.6
  IF (PL9Eccount GT 0.0) THEN Calpha[53, LengthGT100[PL9Ec]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9F = WHERE(((FISHPREY[25, LocV[5, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Fcount, complement = PL9Fc, ncomplement = PL9Fccount)
  IF (PL9Fcount GT 0.0) THEN Calpha[54, LengthGT100[PL9F]] = 0.6
  IF (PL9Fccount GT 0.0) THEN Calpha[54, LengthGT100[PL9Fc]] = 0.00 ; for fish
ENDIF

IF (LengthGT100count GT 0.0) THEN BEGIN
  PL9G = WHERE(((FISHPREY[25, LocV[6, LengthGT100]] / YP[1, LengthGT100]) LE 0.2), PL9Gcount, complement = PL9Gc, ncomplement = PL9Gccount)
  IF (PL9Gcount GT 0.0) THEN Calpha[55, LengthGT100[PL9G]] = 0.6
  IF (PL9Gccount GT 0.0) THEN Calpha[55, LengthGT100[PL9Gc]] = 0.00 ; for fish
ENDIF
;PRINT, 'Calpha'
;PRINT, Calpha


; Calculate attack probability using chesson's alpha = capture efficiency
TOT = FLTARR(7, nYP); total number of all prey atacked and captured
t = FLTARR(m*7, nYP); total number of each prey atacked and captured
; microzooplankton
t[0,*] = (Calpha[0,*] * dens[0,*]) * pw[0, *]   
t[1,*] = (Calpha[0,*] * dens[1,*]) * pw[0, *] 
t[2,*] = (Calpha[0,*] * dens[2,*]) * pw[0, *]    
t[3,*] = (Calpha[0,*] * dens[3,*]) * pw[0, *]     
t[4,*] = (Calpha[0,*] * dens[4,*]) * pw[0, *]    
t[5,*] = (Calpha[0,*] * dens[5,*]) * pw[0, *] 
t[6,*] = (Calpha[0,*] * dens[6,*]) * pw[0, *]  

; small mesozooplankton
t[7,*] = (Calpha[1,*] * dens[7,*]) * pw[1, *] 
t[8,*] = (Calpha[1,*] * dens[8,*]) * pw[1, *] 
t[9,*] = (Calpha[1,*] * dens[9,*]) * pw[1, *]  
t[10,*] = (Calpha[1,*] * dens[10,*]) * pw[1, *]  
t[11,*] = (Calpha[1,*] * dens[11,*]) * pw[1, *] 
t[12,*] = (Calpha[1,*] * dens[12,*]) * pw[1, *] 
t[13,*] = (Calpha[1,*] * dens[13,*]) * pw[1, *] 

; large mesozooplanton
t[14,*] = (Calpha[2,*] * dens[14,*]) * pw[2, *] 
t[15,*] = (Calpha[2,*] * dens[15,*]) * pw[2, *] 
t[16,*] = (Calpha[2,*] * dens[16,*]) * pw[2, *] 
t[17,*] = (Calpha[2,*] * dens[17,*]) * pw[2, *] 
t[18,*] = (Calpha[2,*] * dens[18,*]) * pw[2, *] 
t[19,*] = (Calpha[2,*] * dens[19,*]) * pw[2, *] 
t[20,*] = (Calpha[2,*] * dens[20,*]) * pw[2, *] 

; benthos
t[21,*] = (Calpha[3,*] * dens[21,*]) * pw[3, *]   
t[22,*] = (Calpha[3,*] * dens[22,*]) * pw[3, *] 
t[23,*] = (Calpha[3,*] * dens[23,*]) * pw[3, *] 
t[24,*] = (Calpha[3,*] * dens[24,*]) * pw[3, *] 
t[25,*] = (Calpha[3,*] * dens[25,*]) * pw[3, *] 
t[26,*] = (Calpha[3,*] * dens[26,*]) * pw[3, *] 
t[27,*] = (Calpha[3,*] * dens[27,*]) * pw[3, *] 

;; invasive species
;t[28,*] = (Calpha[4,*] * dens[28,*])
;t[29,*] = (Calpha[4,*] * dens[29,*])
;t[30,*] = (Calpha[4,*] * dens[30,*])
;t[31,*] = (Calpha[4,*] * dens[31,*])
;t[32,*] = (Calpha[4,*] * dens[32,*])
;t[33,*] = (Calpha[4,*] * dens[33,*])
;t[34,*] = (Calpha[4,*] * dens[34,*])

; yellow perch
t[35,*] = (Calpha[5,*] * dens[35,*]) * FISHPREY[2, LocV[0, *]]
t[36,*] = (Calpha[6,*] * dens[36,*]) * FISHPREY[2, LocV[1, *]]
t[37,*] = (Calpha[7,*] * dens[37,*]) * FISHPREY[2, LocV[2, *]]
t[38,*] = (Calpha[8,*] * dens[38,*]) * FISHPREY[2, LocV[3, *]]
t[39,*] = (Calpha[9,*] * dens[39,*]) * FISHPREY[2, LocV[4, *]]
t[40,*] = (Calpha[10,*] * dens[40,*]) * FISHPREY[2, LocV[5, *]]
t[41,*] = (Calpha[11,*] * dens[41,*]) * FISHPREY[2, LocV[6, *]]

; emerald shiner
t[42,*] = (Calpha[12,*] * dens[42,*]) * FISHPREY[8, LocV[0, *]]
t[43,*] = (Calpha[13,*] * dens[43,*]) * FISHPREY[8, LocV[1, *]]
t[44,*] = (Calpha[14,*] * dens[44,*]) * FISHPREY[8, LocV[2, *]]
t[45,*] = (Calpha[15,*] * dens[45,*]) * FISHPREY[8, LocV[3, *]]
t[46,*] = (Calpha[16,*] * dens[46,*]) * FISHPREY[8, LocV[4, *]]
t[47,*] = (Calpha[17,*] * dens[47,*]) * FISHPREY[8, LocV[5, *]]
t[48,*] = (Calpha[18,*] * dens[48,*]) * FISHPREY[8, LocV[6, *]]

; rainbow smelt
t[49,*] = (Calpha[19,*] * dens[49,*]) * FISHPREY[14, LocV[0, *]]
t[50,*] = (Calpha[20,*] * dens[50,*]) * FISHPREY[14, LocV[1, *]]
t[51,*] = (Calpha[21,*] * dens[51,*]) * FISHPREY[14, LocV[2, *]]
t[52,*] = (Calpha[22,*] * dens[52,*]) * FISHPREY[14, LocV[3, *]]
t[53,*] = (Calpha[23,*] * dens[53,*]) * FISHPREY[14, LocV[4, *]]
t[54,*] = (Calpha[24,*] * dens[54,*]) * FISHPREY[14, LocV[5, *]]
t[55,*] = (Calpha[25,*] * dens[55,*]) * FISHPREY[14, LocV[6, *]]

;; round goby
;t[56,*] = (Calpha[26,*] * dens[56,*])
;t[57,*] = (Calpha[27,*] * dens[57,*])
;t[58,*] = (Calpha[28,*] * dens[58,*])
;t[59,*] = (Calpha[29,*] * dens[59,*])
;t[60,*] = (Calpha[30,*] * dens[60,*])
;t[61,*] = (Calpha[31,*] * dens[61,*])
;t[62,*] = (Calpha[32,*] * dens[62,*])

;; walleye
;t[63,*] = (Calpha[33,*] * dens[63,*]) * FISHPREY[26, LocV[0, *]]
;t[64,*] = (Calpha[34,*] * dens[64,*]) * FISHPREY[26, LocV[1, *]]
;t[65,*] = (Calpha[35,*] * dens[65,*]) * FISHPREY[26, LocV[2, *]]
;t[66,*] = (Calpha[36,*] * dens[66,*]) * FISHPREY[26, LocV[3, *]]
;t[67,*] = (Calpha[37,*] * dens[67,*]) * FISHPREY[26, LocV[4, *]]
;t[68,*] = (Calpha[38,*] * dens[68,*]) * FISHPREY[26, LocV[5, *]]
;t[69,*] = (Calpha[39,*] * dens[69,*]) * FISHPREY[26, LocV[6, *]]
;PRINT, 't'
;PRINT, t[*, 0:100]

TOT[0, *] = t[0,*] + t[7,*] + t[14,*] + t[21,*] + t[28,*] + t[35,*] + t[42,*] + t[49,*] + t[56,*] + t[63,*]
TOT[1, *] = t[1,*] + t[8,*] + t[15,*] + t[22,*] + t[29,*] + t[36,*] + t[43,*] + t[50,*] + t[57,*] + t[64,*]
TOT[2, *] = t[2,*] + t[9,*] + t[16,*] + t[23,*] + t[30,*] + t[37,*] + t[44,*] + t[51,*] + t[58,*] + t[65,*]
TOT[3, *] = t[3,*] + t[10,*] + t[17,*] + t[24,*] + t[31,*] + t[38,*] + t[45,*] + t[52,*] + t[59,*] + t[66,*]
TOT[4, *] = t[4,*] + t[11,*] + t[18,*] + t[25,*] + t[32,*] + t[39,*] + t[46,*] + t[53,*] + t[60,*] + t[67,*]
TOT[5, *] = t[5,*] + t[12,*] + t[19,*] + t[26,*] + t[33,*] + t[40,*] + t[47,*] + t[54,*] + t[61,*] + t[68,*]
TOT[6, *] = t[6,*] + t[13,*] + t[20,*] + t[27,*] + t[34,*] + t[41,*] + t[48,*] + t[55,*] + t[62,*] + t[69,*]
;PRINT, 'TOT'
;PRINT, TOT[*, 0:100]


; Add small value for zero prey cells to avoid floating errors
TOT00 = WHERE(TOT[0, *] EQ 0.0, TOT00count, complement = TOTN00, ncomplement = TOTN00count)
IF TOT00count GT 0.0 THEN TOT[0, TOT00] = TOT[0, TOT00] + 10.0^(-20.0)
TOT01 = WHERE(TOT[1, *] EQ 0.0, TOT01count, complement = TOTN01, ncomplement = TOTN01count)
IF TOT01count GT 0.0 THEN TOT[1, TOT01] = TOT[1, TOT01] + 10.0^(-20.0)
TOT02 = WHERE(TOT[2, *] EQ 0.0, TOT02count, complement = TOTN02, ncomplement = TOTN02count)
IF TOT02count GT 0.0 THEN TOT[2, TOT02] = TOT[2, TOT02] + 10.0^(-20.0)
TOT03 = WHERE(TOT[3, *] EQ 0.0, TOT03count, complement = TOTN03, ncomplement = TOTN03count)
IF TOT03count GT 0.0 THEN TOT[3, TOT03] = TOT[3, TOT03] + 10.0^(-20.0)
TOT04 = WHERE(TOT[4, *] EQ 0.0, TOT04count, complement = TOTN04, ncomplement = TOTN04count)
IF TOT04count GT 0.0 THEN TOT[4, TOT04] = TOT[4, TOT04] + 10.0^(-20.0)
TOT05 = WHERE(TOT[5, *] EQ 0.0, TOT05count, complement = TOTN05, ncomplement = TOTN05count)
IF TOT05count GT 0.0 THEN TOT[5, TOT05] = TOT[5, TOT05] + 10.0^(-20.0)
TOT06 = WHERE(TOT[6, *] EQ 0.0, TOT06count, complement = TOTN06, ncomplement = TOTN06count)
IF TOT06count GT 0.0 THEN TOT[6, TOT06] = TOT[6, TOT06] + 10.0^(-20.0)


; Calculate WEIGHTED cumulative prey biomass for each NEIGHBORING layer 
; And copy cumulative prey biomass to all NEIGHBORING cells
preyTOT = FLTARR(nYP)
preyTOT2 = FLTARR(7, nYP)
preyTOT = TOTAL(TOT[0:6, *], 1)  
preyTOT2[0, *] = preyTOT
preyTOT2[1, *] = preyTOT
preyTOT2[2, *] = preyTOT
preyTOT2[3, *] = preyTOT
preyTOT2[4, *] = preyTOT
preyTOT2[5, *] = preyTOT
preyTOT2[6, *] = preyTOT
;PRINT, 'PREYTOT'
;PRINT, PREYTOT2[*, 0:100]

EnvironVprey = FLTARR(7, nYP)
EnvironVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nYP, /DOUBLE)
;PRINT, 'EnvironVprey'
;PRINT, EnvironVprey[*, 0:100]
;**********************************************************************************************************************


; Determine overall habitat quality with a random component
EnvironVSum = FLTARR(7, nYP)
;EnvironHVSum[9, *] = DOUBLE((EnvironHVDO[9, *] * EnvironHVT[9, *] * EnvironHVprey[9, *])^(1.0/3.0))
;EnvironHVSum[10, *] = DOUBLE((EnvironHVDO[10, *] * EnvironHVT[10, *] * EnvironHVprey[10, *])^(1.0/3.0))
;EnvironHVSum[11, *] = DOUBLE((EnvironHVDO[11, *] * EnvironHVT[11, *] * EnvironHVprey[11, *])^(1.0/3.0))
;EnvironHVSum[12, *] = DOUBLE((EnvironHVDO[12, *] * EnvironHVT[12, *] * EnvironHVprey[12, *])^(1.0/3.0))
;EnvironHVSum[13, *] = DOUBLE((EnvironHVDO[13, *] * EnvironHVT[13, *] * EnvironHVprey[13, *])^(1.0/3.0))
;EnvironHVSum[14, *] = DOUBLE((EnvironHVDO[14, *] * EnvironHVT[14, *] * EnvironHVprey[14, *])^(1.0/3.0))
;EnvironHVSum[15, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[15, *])^(1.0/3.0))
;PRINT, 'EnvironHVSum'
;PRINT, EnvironHVSum


; WITH GUT FULLNESS EFFECT
Gutfull2 = (100.- (YP[60, *] < 100.0))/100.; < (1./3.); * RANDOMU(seed, nYP, /DOUBLE)
Gutfull = (1. - Gutfull2)/2.
;print, 'gutfull', transpose(gutfull)
;PRINT, 'gutfull2'
;PRINT, (gutfull2[0:100])
;EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull * EnvironVT[0, *]^gutfull * EnvironVprey[0, *]^gutfull2)
;EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull * EnvironVT[1, *]^gutfull * EnvironVprey[1, *]^gutfull2)
;EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull * EnvironVT[2, *]^gutfull * EnvironVprey[2, *]^gutfull2)
;EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull * EnvironVT[3, *]^gutfull * EnvironVprey[3, *]^gutfull2)
;EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull * EnvironVT[4, *]^gutfull * EnvironVprey[4, *]^gutfull2)
;EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull * EnvironVT[5, *]^gutfull * EnvironVprey[5, *]^gutfull2)
;EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull * EnvironVT[6, *]^gutfull * EnvironVprey[6, *]^gutfull2)


; WITH LIGHT EFFECT ON VERTICAL MOVEMENT
;Gutfull3 = (1. - Gutfull2)/3.
;EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull3 * EnvironVT[0, *]^gutfull3 * EnvironVL[0, *]^gutfull3 * EnvironVprey[0, *]^gutfull2)
;EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull3 * EnvironVT[1, *]^gutfull3 * EnvironVL[1, *]^gutfull3 * EnvironVprey[1, *]^gutfull2)
;EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull3 * EnvironVT[2, *]^gutfull3 * EnvironVL[2, *]^gutfull3 * EnvironVprey[2, *]^gutfull2)
;EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull3 * EnvironVT[3, *]^gutfull3 * EnvironVL[3, *]^gutfull3 * EnvironVprey[3, *]^gutfull2)
;EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull3 * EnvironVT[4, *]^gutfull3 * EnvironVL[4, *]^gutfull3 * EnvironVprey[4, *]^gutfull2)
;EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull3 * EnvironVT[5, *]^gutfull3 * EnvironVL[5, *]^gutfull3 * EnvironVprey[5, *]^gutfull2)
;EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull3 * EnvironVT[6, *]^gutfull3 * EnvironVL[6, *]^gutfull3 * EnvironVprey[6, *]^gutfull2)


; hierherchical habitat quality assessment
; first, determine weight of each environmental factor
; 1. DO
Gutfull4 = (1. - EnvironVDO[0, *]); higher the DO-based habitat quality index, lower the weight
Gutfull5 = (1. - EnvironVDO[1, *])
Gutfull6 = (1. - EnvironVDO[2, *])
Gutfull7 = (1. - EnvironVDO[3, *])
Gutfull8 = (1. - EnvironVDO[4, *])
Gutfull9 = (1. - EnvironVDO[5, *])
Gutfull10 = (1. - EnvironVDO[6, *])

; 2. Predation risk
Gutfull11 = (1. - Gutfull4) * (1 - EnvironVpred[0, *]);  higher the light-based habitat quality index, lower the weight
Gutfull12 = (1. - Gutfull5) * (1 - EnvironVpred[1, *])
Gutfull13 = (1. - Gutfull6) * (1 - EnvironVpred[2, *])
Gutfull14 = (1. - Gutfull7) * (1 - EnvironVpred[3, *])
Gutfull15 = (1. - Gutfull8) * (1 - EnvironVpred[4, *])
Gutfull16 = (1. - Gutfull9) * (1 - EnvironVpred[5, *])
Gutfull17 = (1. - Gutfull10) * (1 - EnvironVpred[6, *])

; 3. Light 
Gutfull18 = (1 - Gutfull4 - Gutfull11) * (1 - EnvironVL[0, *]); higher the temp-based habitat quality index, lower the weight
Gutfull19 = (1 - Gutfull5 - Gutfull12) * (1 - EnvironVL[1, *])
Gutfull20 = (1 - Gutfull6 - Gutfull13) * (1 - EnvironVL[2, *])
Gutfull21 = (1 - Gutfull7 - Gutfull14) * (1 - EnvironVL[3, *])
Gutfull22 = (1 - Gutfull8 - Gutfull15) * (1 - EnvironVL[4, *])
Gutfull23 = (1 - Gutfull9 - Gutfull16) * (1 - EnvironVL[5, *])
Gutfull24 = (1 - Gutfull10 - Gutfull17) * (1 - EnvironVL[6, *])

; 4. tempearture; 
Gutfull25 = (1 - gutfull4 - gutfull11 - gutfull18) * (1 - EnvironVT[0, *]); higher the temp-based habitat quality index, lower the weight
Gutfull26 = (1 - gutfull5 - gutfull12 - gutfull19) * (1 - EnvironVT[1, *])
Gutfull27 = (1 - gutfull6 - gutfull13 - gutfull20) * (1 - EnvironVT[2, *])
Gutfull28 = (1 - gutfull7 - gutfull14 - gutfull21) * (1 - EnvironVT[3, *])
Gutfull29 = (1 - gutfull8 - gutfull15 - gutfull22) * (1 - EnvironVT[4, *])
Gutfull30 = (1 - gutfull9 - gutfull16 - gutfull23) * (1 - EnvironVT[5, *])
Gutfull31 = (1 - gutfull10 - gutfull17 - gutfull24) * (1 - EnvironVT[6, *])

; 5. prey; 
gutfull32 = (1 - gutfull4 - gutfull11 - gutfull18 - Gutfull25) * (gutfull2);  higher the gutfullness and prey-based habitat quality, lower the weight 
gutfull33 = (1 - gutfull5 - gutfull12 - gutfull19 - Gutfull26) * (gutfull2)
gutfull34 = (1 - gutfull6 - gutfull13 - gutfull20 - Gutfull27) * (gutfull2)
gutfull35 = (1 - gutfull7 - gutfull14 - gutfull21 - Gutfull28) * (gutfull2)
gutfull36 = (1 - gutfull8 - gutfull15 - gutfull22 - Gutfull29) * (gutfull2)
gutfull37 = (1 - gutfull9 - gutfull16 - gutfull23 - Gutfull30) * (gutfull2)
gutfull38 = (1 - gutfull10 - gutfull17 - gutfull24 - Gutfull31) * (gutfull2)

EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull4 * EnvironVpred[0, *]^gutfull11 * EnvironVT[0, *]^gutfull25 * EnvironVL[0, *]^gutfull18 * EnvironVprey[0, *]^gutfull32)
EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull5 * EnvironVpred[1, *]^gutfull12 * EnvironVT[1, *]^gutfull26 * EnvironVL[1, *]^gutfull19 * EnvironVprey[1, *]^gutfull33)
EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull6 * EnvironVpred[2, *]^gutfull13 * EnvironVT[2, *]^gutfull27 * EnvironVL[2, *]^gutfull20 * EnvironVprey[2, *]^gutfull34)
EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull7 * EnvironVpred[3, *]^gutfull14 * EnvironVT[3, *]^gutfull28 * EnvironVL[3, *]^gutfull21 * EnvironVprey[3, *]^gutfull35)
EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull8 * EnvironVpred[4, *]^gutfull15 * EnvironVT[4, *]^gutfull29 * EnvironVL[4, *]^gutfull22 * EnvironVprey[4, *]^gutfull36)
EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull9 * EnvironVpred[5, *]^gutfull16 * EnvironVT[5, *]^gutfull30 * EnvironVL[5, *]^gutfull23 * EnvironVprey[5, *]^gutfull37)
EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull10 * EnvironVpred[6, *]^gutfull17 * EnvironVT[6, *]^gutfull31 * EnvironVL[6, *]^gutfull24 * EnvironVprey[6, *]^gutfull38)
;PRINT, 'ENVIRONVSUM'
;PRINT, ENVIRONVSUM[*, 0:100]


; Determine fish movement orientation****************************************************************************************
; 1. determine which neighbouring cell to move
; Movement in z-dimension
zMove = FLTARR(nYP)

EnvironVSumMax1 = MAX(EnvironVSum[1:3, *], DIMENSION = 1) - MAX(EnvironVSum[4:6, *], DIMENSION = 1)
EnvironVSumMax2 = MAX(EnvironVSum[1:3, *], DIMENSION = 1) - EnvironVSum[0, *]
EnvironVSumMax3 = MAX(EnvironVSum[4:6, *], DIMENSION = 1) - EnvironVSum[0, *]


; Vertical movement direction is determined by averages of 3 layers above vs 3layers below the current layer
;EnvironVSumMax1 = TOTAL(EnvironVSum[1:3, *], 1)/3 - TOTAL(EnvironVSum[4:6, *], 1)/3
;EnvironVSumMax2 = TOTAL(EnvironVSum[1:3, *], 1)/3 - EnvironVSum[0, *]
;EnvironVSumMax3 = TOTAL(EnvironVSum[4:6, *], 1)/3 - EnvironVSum[0, *]

; move downward (3)
zMoveNeg = WHERE((EnvironVSumMax1 GT 0.) AND (EnvironVSumMax2 GT 0.), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
IF zMoveNegcount GT 0.0 THEN zMove[zMoveNeg] = 3

; move upward (4)
zMovePos = WHERE((EnvironVSumMax1 LT 0.) AND (EnvironVSumMax3 GT 0.), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
IF zMovePoscount GT 0.0 THEN zMove[zMovePos] = 4

; stay (0)
zMoveNon = WHERE((EnvironVSumMax2 LE 0.) AND (EnvironVSumMax3 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
IF zMoveNoncount GT 0.0 THEN zMove[zMoveNon] = 0


;2. Determine specific fish movement orientation angle****************************************************
; For now, each cell is assumed to have gradients between the current and neiboring cells
; fish are able to detect gradients within a cetain range... 
; Vertical movement
VerOriAng = FLTARR(nYP)

; Downward
zMoveOri1 = WHERE((zMove EQ 3), zMoveOri1count, complement = zMoveOri1N, ncomplement = zMoveOri1Ncount)
IF (zMoveOri1count GT 0.0) THEN VerOriAng[zMoveOri1] = RANDOMU(seed, zMoveOri1count)*(MAX(180.)-MIN(90.))+MIN(90.)

; Upward
zMoveOri2 = WHERE((zMove EQ 4), zMoveOri2count, complement = zMoveOri2N, ncomplement = zMoveOri2Ncount)
IF (zMoveOri2count GT 0.0) THEN VerOriAng[zMoveOri2] = RANDOMU(seed, zMoveOri2count)*(MAX(90.)-MIN(0.))+MIN(0.)

; stay
zMoveOri3 = WHERE((zMove EQ 0), zMoveOri3count, complement = zMoveOri3N, ncomplement = zMoveOri3Ncount)
IF (zMoveOri3count GT 0.0)  THEN VerOriAng[zMoveOri3] = RANDOMU(seed, zMoveOri3count)*(MAX(135)-MIN(45))+MIN(45); randomu(seed, zMoveOri5count)*(max(180)-min(0))+min(0)
;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)

; Convert degrees to radians
VerOriAng = VerOriAng*(!pi/180.)
;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)


;3. Determine the distance and direction fish move uisng the habitat quality values estimated above***************************
; Calculate fish swimming speed, S, in body YP[1, *]s/sec
SS = FLTARR(nYP)
S = FLTARR(nyp)
l = WHERE(YP[1, *] LT 20.0, lcount, complement = ll, ncomplement = llcount)
IF (Lcount GT 0.0) THEN S[l] = 3.3354 * ALOG(YP[1, l]) - 4.8758;(-0.0797 * (YP[1, *][l] * YP[1, *][l]) + 1.9294 * YP[1, *][l] - 8.1761)
 ;SS equation based on data from Houde 1969 in body YP[1, *]s/sec
IF (LLcount GT 0.0) THEN S[ll] = (0.28 * YP[26, ll] + 7.89) / (0.1 * YP[1, ll])
 ;in body YP[1, *]s/sec; from Breck 1997 and Hergenrader and Hasler 1967
; Converts SS into mm/s
SS = (S * YP[1, *])
;PRINT, 'S =', S
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS
;  PRINT, 'Swimming speed in Z-dimension (mm/s)'
;  PRINT, SS*COS(VerOriAng)

; Calculate realized swimming speed (mm/s) in z-dimension
MoveSpeed = FLTARR(5, nYP)
IF (Lcount GT 0.0) THEN MoveSpeed[2, L] = SS[L] * COS(VerOriAng[L]) * RANDOMU(seed, Lcount, /DOUBLE); VERTICAL DIRECTION
IF (LLcount GT 0.0) THEN MoveSpeed[2, LL] = SS[LL]/(ts*6.) * COS(VerOriAng[LL]) * RANDOMU(seed, LLcount, /DOUBLE); VERTICAL DIRECTION

; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
;MoveSpeed[4, *] = (0.102*(YP[1, *]/39.10/EXP(0.330)) + 30.3) * 10.0;n critical swimming speed for adult yellow perch from Nelson, 1989, J. Exp. Biol.
;***Maximum speed is also used for 'URGENCY' move? (from Goodwin et al., 2001)***
;PRINT, 'Realized movement speed (mm/s)'
;PRINT, MoveSpeed


; Distance fish move in each time step OR shorter subtime step???
ts2 = 120L; frequency of turning = >1
zNewLoc = MoveSpeed[2, *]*ts*60.; distance (mm) in z-dimension

zNewLocWithinCell = FLTARR(nYP)
VerSize = FLTARR(nYP)
VerSize[*] = .5 * 1000.;
;PRINT, 'Vertical cell size (mm)'
;PRINT, VerSize


; Proportional within-cell location in z-dimension
zMovePosLoc = WHERE((zNewLoc[*] GE 0.), zMovePosLoccount, complement = zMoveNegLoc, ncomplement = zMoveNegLoccount)
IF zMovePosLoccount GT 0.0 THEN zNewLocWithinCell[zMovePosLoc] = zNewLoc[zMovePosLoc]/(VerSize[zMovePosLoc]) + zOldLocWithinCell[zMovePosLoc]; proportional distance in y-dimension
IF zMoveNegLoccount GT 0.0 THEN zNewLocWithinCell[zMoveNegLoc] = zNewLoc[zMoveNegLoc]/(VerSize[zMoveNegLoc]) + zOldLocWithinCell[zMoveNegLoc]; proportional distance in y-dimension  


;**************NEED TO ADJUST PROPORTIONAL VERTICAL MOVEMENT*******************************
; IF > 3 OR -3,
;PRINT, 'Realized distance (mm) traveled in z-dimension per time step '
;PRINT, (zNewLoc[0:100])
;PRINT, 'Realized proportional distance traveled in z-dimension per time step '
;PRINT, zNewLocWithinCell[0:100]
;PRINT, 'MoveSpeed[2, *]'
;PRINT, TRANSPOSE(MoveSpeed[2, *])


; *****Determine new cell locations****************************************************************************************
; Identify new vertical cell
zMoveOut0 = WHERE((zNewLocWithinCell GT 4.), zMoveOut0count, complement = zMoveOut0N, ncomplement = zMoveOut0Ncount)
zMoveOut1 = WHERE(((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut1count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut2 = WHERE(((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut2count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut3 = WHERE(((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut3count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut4 = WHERE(((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut4count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut5 = WHERE(((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut5count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut6 = WHERE(((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut6count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut7 = WHERE(((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut7count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut8 = WHERE((zNewLocWithinCell LT -3.), zMoveOut8count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
IF zMoveOut0count GT 0.0 THEN YP[14, zMoveOut0] = LocV[6, zMoveOut0];
IF zMoveOut1count GT 0.0 THEN YP[14, zMoveOut1] = LocV[6, zMoveOut1];
IF zMoveOut2count GT 0.0 THEN YP[14, zMoveOut2] = LocV[5, zMoveOut2];
IF zMoveOut3count GT 0.0 THEN YP[14, zMoveOut3] = LocV[4, zMoveOut3];
IF zMoveOut4count GT 0.0 THEN YP[14, zMoveOut4] = LocV[0, zMoveOut4];
IF zMoveOut5count GT 0.0 THEN YP[14, zMoveOut5] = LocV[3, zMoveOut5];
IF zMoveOut6count GT 0.0 THEN YP[14, zMoveOut6] = LocV[2, zMoveOut6];
IF zMoveOut7count GT 0.0 THEN YP[14, zMoveOut7] = LocV[1, zMoveOut7];
IF zMoveOut8count GT 0.0 THEN YP[14, zMoveOut8] = LocV[1, zMoveOut8];


; When fish moves out the current cell, a within-cell location needs to be updated
; Movement in positive z-dimension 
zMoveOutPos = WHERE((zNewLocWithinCell GT 1.0), zMoveOutPoscount, complement = zMoveOutPosN, ncomplement = zMoveOutPosNcount)
IF zMoveOutPoscount GT 0.0 THEN zNewLocWithinCell[zMoveOutPos] = zNewLocWithinCell[zMoveOutPos] - FLOOR(zNewLocWithinCell[zMoveOutPos])

; Movement in negative z-dimension
zMoveOutNeg = WHERE((zNewLocWithinCell LT 0.0), zMoveOutNegcount, complement = zMoveOutNegN, ncomplement = zMoveOutNegNcount)
IF zMoveOutNegcount GT 0.0 THEN zNewLocWithinCell[zMoveOutNeg] = zNewLocWithinCell[zMoveOutNeg] + CEIL(ABS(zNewLocWithinCell[zMoveOutNeg]))  
;PRINT,'zMoveOutPos', zMoveOutPos
;PRINT,'zMoveOutNeg', zMoveOutNeg
;PRINT, 'New within-cell location in z-dimension in new cell '
;PRINT, zNewLocWithinCell[0:200]


; New environmental conditions
NewFishEnviron = FLTARR(17, nYP)
NewFishEnviron[0:15, *] = NewInput[*, YP[14, *]];YP[14, *] New 3D gridcell ID
NewFishEnviron[16, *] = zNewLocWithinCell; New within-cell location in z-dimension in new cell
;PRINT, 'NewFishEnviron[0:4, *]'
;PRINT, NewFishEnviron[0:4, *]

 
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Yellow Perch Movement Ends Here'
RETURN, NewFishEnviron; TURN OFF WHEN TESTING
END