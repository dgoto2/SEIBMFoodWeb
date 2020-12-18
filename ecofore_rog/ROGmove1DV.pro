FUNCTION ROGMove1DV, ts, iHour, ROG, nROG, NewInput, FISHPREY, zOldLocWithinCell, Oxydebt

;function determines movement in Z direction for all yellow perch
PRINT, 'Round Goby 1D Movement Begins Here'
tstart = SYSTIME(/seconds)

;FishPrey = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)

;*****NEED TO INCORPORATE PREDATOR-BASED HABITAT-QIALITY***********************************
;******NO NEED TO IDENTIFY THE CURRENT CELL AND INCORPORATE 
;******Change * to 0 in row subscripting*********

;*****Identify potential cell IDs in all 6 directions*******************************************
LocV = FLTARR(7L, nROG)
LocV[0, *] = ROG[14, *]; current CELL ID
; VERTICAL LAYERS 0 - 47
; ***Vertical movement is restricted within 3 cells below and above the current layer***
; DOWNWARD MOVEMNT
; current layer -3
Lower3Cells0 = WHERE((ROG[14, *] LE 44L), Lower3Cells0count, complement = NONLower3Cells0, ncomplement = NonLower3Cells0count)
IF Lower3Cells0count GT 0. THEN LocV[1, Lower3Cells0] = LocV[0, Lower3Cells0]+3L;
IF NonLower3Cells0count GT 0. THEN LocV[1, NonLower3Cells0] = LocV[0, NonLower3Cells0];
; current layer -2
Lower2Cells0 = WHERE((ROG[14, *] LE 45L), Lower2Cells0count, complement = NONLower2Cells0, ncomplement = NonLower2Cells0count)
IF Lower2Cells0count GT 0. THEN LocV[2, Lower2Cells0] = LocV[0, Lower2Cells0]+2L; 
IF NonLower2Cells0count GT 0. THEN LocV[2, NonLower2Cells0] = LocV[0, NonLower2Cells0];
; current layer -1
Lower1Cells0 = WHERE((ROG[14, *] LE 46L), Lower1Cells0count, complement = NONLower1Cells0, ncomplement = NonLower1Cells0count)
IF Lower1Cells0count GT 0. THEN LocV[3, Lower1Cells0] = LocV[0, Lower1Cells0]+1L; 
IF NonLower1Cells0count GT 0. THEN LocV[3, NonLower1Cells0] = LocV[0, NonLower1Cells0];
; current layer +1
Upper1Cells0 = WHERE((ROG[14, *] GE 1L), Upper1Cells0count, complement = NONUpper1Cells0, ncomplement = NonUpper1Cells0count)
IF Upper1Cells0count GT 0. THEN LocV[4, Upper1Cells0] = LocV[0, Upper1Cells0]-1L;
IF NonUpper1Cells0count GT 0. THEN LocV[4, NonUpper1Cells0] = LocV[0, NonUpper1Cells0];
; current layer +2
Upper2Cells0 = WHERE((ROG[14, *] GE 2L), Upper2Cells0count, complement = NONUpper2Cells0, ncomplement = NonUpper2Cells0count)
IF Upper2Cells0count GT 0. THEN LocV[5, Upper2Cells0] = LocV[0, Upper2Cells0]-2L;
IF NonUpper2Cells0count GT 0. THEN LocV[5, NonUpper2Cells0] = LocV[0, NonUpper2Cells0];
; current layer +3
Upper3Cells0 = WHERE((ROG[14, *] GE 3L), Upper3Cells0count, complement = NONUpper3Cells0, ncomplement = NonUpper3Cells0count)
IF Upper3Cells0count GT 0. THEN LocV[6, Upper3Cells0] = LocV[0, Upper3Cells0]-3L;
IF NonUpper3Cells0count GT 0. THEN LocV[6, NonUpper3Cells0] = LocV[0, NonUpper3Cells0];
;**********************************************
;PRINT, 'LocV[0:6,*]'
;PRINT, transpose(LocV[0:6,0:100])
 
;****Determine habitat quality of neibouring cells***************************************************************
;******NEED TO AGGREGATE ZOOPLANKTON AND NO invasive species*******
EnvironV = FLTARR(105L, nROG)
;Envir1D3[4, *] = INDGEN(nVerLay)
;Envir1D3[5, *] = zoopl1; microzooplankton, g/L
;Envir1D3[6, *] = zoopl2 ; mid-size zooplankton; NOT YET g/L
;Envir1D3[7, *] = zoopl3; large-bodied zooplankton; NOT YET g/L
;Envir1D3[8, *] = TotBenBio
;Envir1D3[9:10, *] = Envir1D2[9:10, *]; TEMP & O2
;Envir1D3[11, *] = Light
GridCellHorSize = 15500. * 1000000. * .5 / 10.; 1550km2 FOR FISH ARRAY = 1/10 OF LE CENTRAL BASIN

; Environmental conditions in (0) = the current cell
EnvironV[0:8, *] = newinput[3:11, LocV[0, *]];
EnvironV[9, *] = 0.0; invasive species
;**** NEEDED FOR PREDATION RISK***************************************
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
;PRINT,EnvironV[*, 0:100]

;***Assess habitat quality of neibouring cells**********************************************************************
DOf1 = FLTARR(7, nROG)
DOf2 = FLTARR(7, nROG)
DOf3 = FLTARR(7, nROG)
DOf = FLTARR(7, nROG)
Tf = FLTARR(7, nROG)
; DO***************************************************************************************************************
DOacclim = ROGacclDO(ROG[29, *], ROG[28, *], ROG[20, *], ROG[27, *], ROG[26, *], ROG[19, *], ts, ROG[1, *], ROG[2, *], nROG, ROG[63, *])
;PRINT, 'DOacclim[7, *]'
;PRINT, TRANSPOSE(DOacclim[7, 0:100])
;PRINT, 'DOacclim[5, *]'
;PRINT, TRANSPOSE(DOacclim[5, 0:100])
DOf0a = EnvironV[7, *] - 2.5*DOacclim[7, *]
DOf1a = EnvironV[22, *] - 2.5*DOacclim[7, *]
DOf2a = EnvironV[37, *] - 2.5*DOacclim[7, *]
DOf3a = EnvironV[52, *] - 2.5*DOacclim[7, *]
DOf4a = EnvironV[67, *] - 2.5*DOacclim[7, *]
DOf5a = EnvironV[82, *] - 2.5*DOacclim[7, *]
DOf6a = EnvironV[97, *] - 2.5*DOacclim[7, *]

DOf0b = EnvironV[7, *] - 2*DOacclim[5, *]
DOf1b = EnvironV[22, *] - 2*DOacclim[5, *]
DOf2b = EnvironV[37, *] - 2*DOacclim[5, *]
DOf3b = EnvironV[52, *] - 2*DOacclim[5, *]
DOf4b = EnvironV[67, *] - 2*DOacclim[5, *]
DOf5b = EnvironV[82, *] - 2*DOacclim[5, *]
DOf6b = EnvironV[97, *] - 2*DOacclim[5, *]

; WHEN ambient DO is below the mimimum critical DO...
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
IF DOf2count0 GT 0.0 THEN DOf[0, DOf20] = ((EnvironV[7, DOf20] - 2.5*DOacclim[7, DOf20])/(2.*DOacclim[5, DOf20] - 2.5*DOacclim[7, DOf20]))
IF DOf2count1 GT 0.0 THEN DOf[1, DOf21] = ((EnvironV[22, DOf21] - 2.5*DOacclim[7, DOf21])/(2.*DOacclim[5, DOf21] - 2.5*DOacclim[7, DOf21]))
IF DOf2count2 GT 0.0 THEN DOf[2, DOf22] = ((EnvironV[37, DOf22] - 2.5*DOacclim[7, DOf22])/(2.*DOacclim[5, DOf22] - 2.5*DOacclim[7, DOf22]))
IF DOf2count3 GT 0.0 THEN DOf[3, DOf23] = ((EnvironV[52, DOf23] - 2.5*DOacclim[7, DOf23])/(2.*DOacclim[5, DOf23] - 2.5*DOacclim[7, DOf23]))
IF DOf2count4 GT 0.0 THEN DOf[4, DOf24] = ((EnvironV[67, DOf24] - 2.5*DOacclim[7, DOf24])/(2.*DOacclim[5, DOf24] - 2.5*DOacclim[7, DOf24]))
IF DOf2count5 GT 0.0 THEN DOf[5, DOf25] = ((EnvironV[82, DOf25] - 2.5*DOacclim[7, DOf25])/(2.*DOacclim[5, DOf25] - 2.5*DOacclim[7, DOf25]))
IF DOf2count6 GT 0.0 THEN DOf[6, DOf26] = ((EnvironV[97, DOf26] - 2.5*DOacclim[7, DOf26])/(2.*DOacclim[5, DOf26] - 2.5*DOacclim[7, DOf26]))

; WHEN ambient DO is ABOVE the critical DO...
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
CK1 = 0.113
CK4 = 0.419
CQ = 5.594
CTM = 25.706
CTO = 24.648
CTL = 28.992
G1 = (1. / (CTO - CQ)) * ALOG((0.98 * (1.- CK1)) / (CK1 * 0.02))
G2 = (1. / (CTL - CTM)) * ALOG((0.98 * (1.- CK4)) / (CK4 * 0.02))

LA1 = EXP(G1 * (EnvironV[6, *] - CQ))
LB1 = EXP(G2 * (CTL - EnvironV[6, *]))
LA2 = EXP(G1 * (EnvironV[21, *] - CQ))
LB2 = EXP(G2 * (CTL - EnvironV[21, *]))
LA3 = EXP(G1 * (EnvironV[36, *] - CQ))
LB3 = EXP(G2 * (CTL - EnvironV[36, *]))
LA4 = EXP(G1 * (EnvironV[51, *] - CQ))
LB4 = EXP(G2 * (CTL - EnvironV[51, *]))
LA5 = EXP(G1 * (EnvironV[66, *] - CQ))
LB5 = EXP(G2 * (CTL - EnvironV[66, *]))
LA6 = EXP(G1 * (EnvironV[81, *] - CQ))
LB6 = EXP(G2 * (CTL - EnvironV[81, *]))
LA7 = EXP(G1 * (EnvironV[96, *] - CQ))
LB7 = EXP(G2 * (CTL - EnvironV[96, *]))

KA1 = (CK1 * LA1) / (1. + CK1 * (LA1 - 1.))
KB1 = (CK4 * LB1) / (1. + CK4 * (LB1 - 1.))
KA2 = (CK1 * LA2) / (1. + CK1 * (LA2 - 1.))
KB2 = (CK4 * LB2) / (1. + CK4 * (LB2 - 1.))
KA3 = (CK1 * LA3) / (1. + CK1 * (LA3 - 1.))
KB3 = (CK4 * LB3) / (1. + CK4 * (LB3 - 1.))
KA4 = (CK1 * LA4) / (1. + CK1 * (LA4 - 1.))
KB4 = (CK4 * LB4) / (1. + CK4 * (LB4 - 1.))
KA5 = (CK1 * LA5) / (1. + CK1 * (LA5 - 1.))
KB5 = (CK4 * LB5) / (1. + CK4 * (LB5 - 1.))
KA6 = (CK1 * LA6) / (1. + CK1 * (LA6 - 1.))
KB6 = (CK4 * LB6) / (1. + CK4 * (LB6 - 1.))
KA7 = (CK1 * LA7) / (1. + CK1 * (LA7 - 1.))
KB7 = (CK4 * LB7) / (1. + CK4 * (LB7 - 1.))

Tf[0, *] = KA1 * KB1
Tf[1, *] = KA2 * KB2
Tf[2, *] = KA3 * KB3
Tf[3, *] = KA4 * KB4
Tf[4, *] = KA5 * KB5
Tf[5, *] = KA6 * KB6
Tf[6, *] = KA7 * KB7
;PRINT, 'Tf'
;PRINT, Tf

; Light
litfac = FLTARR(7, nROG); a multiplication factor to include the effect of light intensity
t1 = FLTARR(7, nROG)
t2 = FLTARR(7, nROG)
;***litfac using "flicker frequency" from Ali & Ryder***.
la = 0.0183877D
lb = 0.39361465D
lc = 0.0040855314D
ld = -1.7306173D

t1[0, *] = EXP(-1. * lb * (EnvironV[8, *]/100. - ld))
t1[1, *] = EXP(-1. * lb * (EnvironV[23, *]/100. - ld))
t1[2, *] = EXP(-1. * lb * (EnvironV[38, *]/100. - ld))
t1[3, *] = EXP(-1. * lb * (EnvironV[53, *]/100. - ld))
t1[4, *] = EXP(-1. * lb * (EnvironV[68, *]/100. - ld))
t1[5, *] = EXP(-1. * lb * (EnvironV[83, *]/100. - ld))
t1[6, *] = EXP(-1. * lb * (EnvironV[97, *]/100. - ld))
 
t2[0, *] = EXP(-1. * lc * (EnvironV[8, *]/100. - ld))
t2[1, *] = EXP(-1. * lc * (EnvironV[23, *]/100. - ld))
t2[2, *] = EXP(-1. * lc * (EnvironV[38, *]/100. - ld))
t2[3, *] = EXP(-1. * lc * (EnvironV[53, *]/100. - ld))
t2[4, *] = EXP(-1. * lc * (EnvironV[68, *]/100. - ld))
t2[5, *] = EXP(-1. * lc * (EnvironV[83, *]/100. - ld))
t2[6, *] = EXP(-1. * lc * (EnvironV[97, *]/100. - ld))

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

; Incorporate a random component to habitat quality index
EnvironVDO = FLTARR(7, nROG)
EnvironVT = FLTARR(7, nROG)
EnvironVL = FLTARR(7, nROG)
EnvironVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component

EnvironVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component

EnvironVL[0, *] = DOUBLE(litfac[0, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[1, *] = DOUBLE(litfac[1, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[2, *] = DOUBLE(litfac[2, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[3, *] = DOUBLE(litfac[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[4, *] = DOUBLE(litfac[4, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[5, *] = DOUBLE(litfac[5, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironVL[6, *] = DOUBLE(litfac[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;PRINT, 'EnvironVDO'
;PRINT, EnvironVDO[*, 0:100]
;PRINT, 'EnvironVT'
;PRINT, EnvironVT[*, 0:100]

; Determine prey fields*****************************************************************************************************
;prey YP[1, *] 
m = 6; the number of prey types 
PL = FLTARR(m, nROG)
PL[0, *] = RANDOMU(seed, nROG)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nROG)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nROG)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nROG)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nROG)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm

; prey weight
PW = FLTARR(m, nROG); weight of each prey type
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56*ALOG(PL[1, *]))/0.14 / 1000000.; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88*ALOG(PL[2, *]))/0.12 / 1000000.; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet

; convert prey biomass (g/L or m^2) into numbers/L or m^2
dens = FLTARR(m*7, nROG)  
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
;; yellow perch
;pbio5i = WHERE(EnvironV[10, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5icount, complement = pbio5ic, ncomplement = pbio5iccount)
;IF pbio5icount GT 0.0 THEN dens[35, pbio5i] = EnvironV[10, pbio5i] / FISHPREY[2, LocV[0, pbio5i]] ELSE dens[35, pbio5ic] = 0.0; for yellow perch
;pbio5j = WHERE(EnvironV[25, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5jcount, complement = pbio5jc, ncomplement = pbio5jccount)
;IF pbio5jcount GT 0.0 THEN dens[36, pbio5j] = EnvironV[25, pbio5j] / FISHPREY[2, LocV[1, pbio5j]] ELSE dens[36, pbio5jc] = 0.0; for yellow perch
;pbio5k = WHERE(EnvironV[40, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5kcount, complement = pbio5kc, ncomplement = pbio5kccount)
;IF pbio5kcount GT 0.0 THEN dens[37, pbio5k] = EnvironV[40, pbio5k] / FISHPREY[2, LocV[2, pbio5k]] ELSE dens[37, pbio5kc] = 0.0; for yellow perch
;pbio5l = WHERE(EnvironV[55, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5lcount, complement = pbio5lc, ncomplement = pbio5lccount)
;IF pbio5lcount GT 0.0 THEN dens[38, pbio5l] = EnvironV[55, pbio5l] / FISHPREY[2, LocV[3, pbio5l]] ELSE dens[38, pbio5lc] = 0.0; for yellow perch
;pbio5o = WHERE(EnvironV[70, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5ocount, complement = pbio5oc, ncomplement = pbio5occount)
;IF pbio5ocount GT 0.0 THEN dens[39, pbio5o] = EnvironV[70, pbio5o] / FISHPREY[2, LocV[4, pbio5o]] ELSE dens[39, pbio5oc] = 0.0; for yellow perch
;pbio5p = WHERE(EnvironV[85, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5pcount, complement = pbio5pc, ncomplement = pbio5pccount)
;IF pbio5pcount GT 0.0 THEN dens[40, pbio5p] = EnvironV[85, pbio5p] / FISHPREY[2, LocV[5, pbio5p]] ELSE dens[40, pbio5pc] = 0.0; for yellow perch
;pbio5q = WHERE(EnvironV[100, *] GT 0.0 AND FISHPREY[2, *] GT 0.0, pbio5qcount, complement = pbio5qc, ncomplement = pbio5qccount)
;IF pbio5qcount GT 0.0 THEN dens[41, pbio5q] = EnvironV[100, pbio5q] / FISHPREY[2, LocV[6, pbio5q]] ELSE dens[41, pbio5qc] = 0.0; for yellow perch
;PRINT, 'DENS'
;PRINT, DENS[*, 0:100]

; Calculate Chesson's alpha for each prey type; YP[1, *]
Calpha = FLTARR(50, nROG); from Letcher et al. for zooplankton
Calpha[0, *] = 193499 * ROG[1, *]^(-7.64); for microzooplankton - rotifers
Calpha[1, *] = 0.272 * ALOG(ROG[1, *]) - 0.3834; for mesozooplankton1 - calanoids
Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * ROG[1, *]))^(1.0 / 0.031); for mesozooplankton2 - cladocerans

PL3 = WHERE((PL[3, *] / ROG[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
IF (pl3count GT 0.0) THEN Calpha[3, PL3] = ABS(0.50 - 1.75 * (PL[3, PL3] / ROG[1, PL3]))
IF (pl3ccount GT 0.0) THEN Calpha[3, PL3c] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 

Length60 = WHERE(ROG[1, *] GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)
IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.

Length80 = WHERE((ROG[1, *] GT 80.0), Length80count, complement = Length80c, ncomplement = Length80ccount)
 
PL5A = WHERE(((FISHPREY[1, LocV[0, *]] / ROG[1, *]) LT 0.2), PL5Acount, complement = PL5Ac, ncomplement = PL5Account)
PL5Aa = WHERE(((FISHPREY[1, LocV[0, *]] / ROG[1, *]) GE 0.2), PL5Aacount, complement = PL5Aac, ncomplement = PL5Aaccount)
IF (Length80count GT 0.0)  AND (PL5Acount GT 0.0) THEN Calpha[5, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Acount GT 0.0) THEN Calpha[5, PL5A] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Aacount GT 0.0) THEN Calpha[5, PL5Aa] = 0.00 ; for YEP 

PL5B = WHERE(((FISHPREY[1, LocV[1, *]] / ROG[1, *]) LT 0.2), PL5Bcount, complement = PL5Bc, ncomplement = PL5Bccount)
PL5Ba = WHERE(((FISHPREY[1, LocV[1, *]] / ROG[1, *]) GE 0.2), PL5Bacount, complement = PL5Bac, ncomplement = PL5Baccount)
IF (Length80count GT 0.0) AND (PL5Bcount GT 0.0) THEN Calpha[6, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Bcount GT 0.0) THEN Calpha[6, PL5B] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Bacount GT 0.0) THEN Calpha[6, PL5Ba] = 0.00 ; for YEP

PL5C = WHERE(((FISHPREY[1, LocV[2, *]] / ROG[1, *]) LT 0.2), PL5Ccount, complement = PL5Cc, ncomplement = PL5Cccount)
PL5Ca = WHERE(((FISHPREY[1, LocV[2, *]] / ROG[1, *]) GE 0.2), PL5Cacount, complement = PL5Cac, ncomplement = PL5Caccount)
IF (Length80count GT 0.0) AND (PL5Ccount GT 0.0) THEN Calpha[7, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Ccount GT 0.0) THEN Calpha[7, PL5C] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Cacount GT 0.0) THEN Calpha[7, PL5Ca] = 0.00 ; for YEP

PL5D = WHERE(((FISHPREY[1, LocV[3, *]] / ROG[1, *]) LT 0.2), PL5Dcount, complement = PL5Dc, ncomplement = PL5Dccount)
PL5Da = WHERE(((FISHPREY[1, LocV[3, *]] / ROG[1, *]) GE 0.2), PL5Dacount, complement = PL5Dac, ncomplement = PL5Daccount)
IF (Length80count GT 0.0) AND (PL5Dcount GT 0.0) THEN Calpha[8, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Dcount GT 0.0) THEN Calpha[8, PL5D] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Dacount GT 0.0) THEN Calpha[8, PL5Da] = 0.00 ; for YEP

PL5E = WHERE(((FISHPREY[1, LocV[4, *]] / ROG[1, *]) LT 0.2), PL5Ecount, complement = PL5Ec, ncomplement = PL5Eccount)
PL5Ea = WHERE(((FISHPREY[1, LocV[4, *]] / ROG[1, *]) GE 0.2), PL5Eacount, complement = PL5Eac, ncomplement = PL5Eaccount)
IF (Length80count GT 0.0) AND (PL5Ecount GT 0.0) THEN Calpha[9, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Ecount GT 0.0) THEN Calpha[9, PL5E] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Eacount GT 0.0) THEN Calpha[9, PL5Ea] = 0.00 ; for YEP

PL5F = WHERE(((FISHPREY[1, LocV[5, *]] / ROG[1, *]) LT 0.2), PL5Fcount, complement = PL5Fc, ncomplement = PL5Fccount)
PL5Fa = WHERE(((FISHPREY[1, LocV[5, *]] / ROG[1, *]) GE 0.2), PL5Facount, complement = PL5Fac, ncomplement = PL5Faccount)
IF (Length80count GT 0.0) AND (PL5Fcount GT 0.0) THEN Calpha[10, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Fcount GT 0.0) THEN Calpha[10, PL5F] = 0.25 
IF (Length80ccount GT 0.0) AND (PL5Facount GT 0.0) THEN Calpha[10, PL5Fa] = 0.00 ; for YEP

PL5G = WHERE(((FISHPREY[1, LocV[6, *]] / ROG[1, *]) LT 0.2), PL5Gcount, complement = PL5Gc, ncomplement = PL5Gccount)
PL5Ga = WHERE(((FISHPREY[1, LocV[6, *]] / ROG[1, *]) GE 0.2), PL5Gacount, complement = PL5Gac, ncomplement = PL5Gaccount)
IF (Length80count GT 0.0) AND (PL5Gcount GT 0.0) THEN Calpha[11, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Gcount GT 0.0) THEN Calpha[11, PL5G] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Gacount GT 0.0) THEN Calpha[11, PL5Ga] = 0.00 ; for YEP
;PRINT, 'Calpha'
;PRINT, Calpha

; Calculate attack probability using chesson's alpha = capture efficiency
TOT = FLTARR(7, nROG); total number of all prey atacked and captured
t = FLTARR(m*7, nROG); total number of each prey atacked and captured
; microzooplankton
t[0,*] = (Calpha[0,*] * dens[0,*])     
t[1,*] = (Calpha[0,*] * dens[1,*])
t[2,*] = (Calpha[0,*] * dens[2,*])    
t[3,*] = (Calpha[0,*] * dens[3,*])    
t[4,*] = (Calpha[0,*] * dens[4,*])   
t[5,*] = (Calpha[0,*] * dens[5,*])
t[6,*] = (Calpha[0,*] * dens[6,*]) 
; small mesozooplankton
t[7,*] = (Calpha[1,*] * dens[7,*])
t[8,*] = (Calpha[1,*] * dens[8,*])
t[9,*] = (Calpha[1,*] * dens[9,*]) 
t[10,*] = (Calpha[1,*] * dens[10,*]) 
t[11,*] = (Calpha[1,*] * dens[11,*])
t[12,*] = (Calpha[1,*] * dens[12,*])
t[13,*] = (Calpha[1,*] * dens[13,*])
; large mesozooplanton
t[14,*] = (Calpha[2,*] * dens[14,*])
t[15,*] = (Calpha[2,*] * dens[15,*])
t[16,*] = (Calpha[2,*] * dens[16,*])
t[17,*] = (Calpha[2,*] * dens[17,*])
t[18,*] = (Calpha[2,*] * dens[18,*])
t[19,*] = (Calpha[2,*] * dens[19,*])
t[20,*] = (Calpha[2,*] * dens[20,*])
; benthos
t[21,*] = (Calpha[3,*] * dens[21,*])  
t[22,*] = (Calpha[3,*] * dens[22,*])
t[23,*] = (Calpha[3,*] * dens[23,*])
t[24,*] = (Calpha[3,*] * dens[24,*])
t[25,*] = (Calpha[3,*] * dens[25,*])
t[26,*] = (Calpha[3,*] * dens[26,*])
t[27,*] = (Calpha[3,*] * dens[27,*])
; invasive species
t[28,*] = (Calpha[4,*] * dens[28,*])
t[29,*] = (Calpha[4,*] * dens[29,*])
t[30,*] = (Calpha[4,*] * dens[30,*])
t[31,*] = (Calpha[4,*] * dens[31,*])
t[32,*] = (Calpha[4,*] * dens[32,*])
t[33,*] = (Calpha[4,*] * dens[33,*])
t[34,*] = (Calpha[4,*] * dens[34,*])
; yellow perch
t[35,*] = (Calpha[5,*] * dens[35,*])
t[36,*] = (Calpha[6,*] * dens[36,*])
t[37,*] = (Calpha[7,*] * dens[37,*])
t[38,*] = (Calpha[8,*] * dens[38,*])
t[39,*] = (Calpha[9,*] * dens[39,*])
t[40,*] = (Calpha[10,*] * dens[40,*])
t[41,*] = (Calpha[11,*] * dens[41,*])

TOT[0, *] = t[0,*] + t[7,*] + t[14,*] + t[21,*] + t[28,*]; + t[35,*]
TOT[1, *] = t[1,*] + t[8,*] + t[15,*] + t[22,*] + t[29,*]; + t[36,*]
TOT[2, *] = t[2,*] + t[9,*] + t[16,*] + t[23,*] + t[30,*]; + t[37,*]
TOT[3, *] = t[3,*] + t[10,*] + t[17,*] + t[24,*] + t[31,*]; + t[38,*] 
TOT[4, *] = t[4,*] + t[11,*] + t[18,*] + t[25,*] + t[32,*]; + t[39,*] 
TOT[5, *] = t[5,*] + t[12,*] + t[19,*] + t[26,*] + t[33,*]; + t[40,*] 
TOT[6, *] = t[6,*] + t[13,*] + t[20,*] + t[27,*] + t[34,*]; + t[41,*]
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
preyTOT = FLTARR(nROG)
preyTOT2 = FLTARR(7, nROG)
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

EnvironVprey = FLTARR(7, nROG)
EnvironVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nROG, /DOUBLE)
;PRINT, 'EnvironVprey'
;PRINT, EnvironVprey[*, 0:100]
;**********************************************************************************************************************

; Determine overall habitat quality with a random component
EnvironVSum = FLTARR(7, nROG)
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
Gutfull2 = (100.- (ROG[60, *] < 100.0))/100.; < (1./3.); * RANDOMU(seed, nYP, /DOUBLE)
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

Gutfull4 = (1. - EnvironVDO[0, *]);DO
Gutfull5 = (1. - EnvironVDO[1, *])
Gutfull6 = (1. - EnvironVDO[2, *])
Gutfull7 = (1. - EnvironVDO[3, *])
Gutfull8 = (1. - EnvironVDO[4, *])
Gutfull9 = (1. - EnvironVDO[5, *])
Gutfull10 = (1. - EnvironVDO[6, *])

Gutfull11 = (1. - Gutfull4) * (1 - EnvironVL[0, *]); Light
Gutfull12 = (1. - Gutfull5) * (1 - EnvironVL[1, *])
Gutfull13 = (1. - Gutfull6) * (1 - EnvironVL[2, *])
Gutfull14 = (1. - Gutfull7) * (1 - EnvironVL[3, *])
Gutfull15 = (1. - Gutfull8) * (1 - EnvironVL[4, *])
Gutfull16 = (1. - Gutfull9) * (1 - EnvironVL[5, *])
Gutfull17 = (1. - Gutfull10) * (1 - EnvironVL[6, *])

Gutfull18 = (1 - Gutfull4 - Gutfull11)*(Gutfull2); prey
Gutfull19 = (1 - Gutfull5 - Gutfull12)*(Gutfull2)
Gutfull20 = (1 - Gutfull6 - Gutfull13)*(Gutfull2)
Gutfull21 = (1 - Gutfull7 - Gutfull14)*(Gutfull2)
Gutfull22 = (1 - Gutfull8 - Gutfull15)*(Gutfull2)
Gutfull23 = (1 - Gutfull9 - Gutfull16)*(Gutfull2)
Gutfull24 = (1 - Gutfull10 - Gutfull17)*(Gutfull2)

; 3. tempearture; x Prey
Gutfull18 = (1 - Gutfull4 - Gutfull11)*(Gutfull2);  higher the gutfullness, lower the weight
Gutfull19 = (1 - Gutfull5 - Gutfull12)*(Gutfull2)
Gutfull20 = (1 - Gutfull6 - Gutfull13)*(Gutfull2)
Gutfull21 = (1 - Gutfull7 - Gutfull14)*(Gutfull2)
Gutfull22 = (1 - Gutfull8 - Gutfull15)*(Gutfull2)
Gutfull23 = (1 - Gutfull9 - Gutfull16)*(Gutfull2)
Gutfull24 = (1 - Gutfull10 - Gutfull17)*(Gutfull2)

; 4. prey; x temperature
Gutfull25 = (1 - Gutfull4 - Gutfull11 - Gutfull18); 
Gutfull26 = (1 - Gutfull5 - Gutfull12 - Gutfull19)
Gutfull27 = (1 - Gutfull6 - Gutfull13 - Gutfull20)
Gutfull28 = (1 - Gutfull7 - Gutfull14 - Gutfull21)
Gutfull29 = (1 - Gutfull8 - Gutfull15 - Gutfull22)
Gutfull30 = (1 - Gutfull9 - Gutfull16 - Gutfull23)
Gutfull31 = (1 - Gutfull10 - Gutfull17 - Gutfull24)

;EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull4 * EnvironVT[0, *]^gutfull25 * EnvironVL[0, *]^gutfull11 * EnvironVprey[0, *]^gutfull18)
;EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull5 * EnvironVT[1, *]^gutfull26 * EnvironVL[1, *]^gutfull12 * EnvironVprey[1, *]^gutfull19)
;EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull6 * EnvironVT[2, *]^gutfull27 * EnvironVL[2, *]^gutfull13 * EnvironVprey[2, *]^gutfull20)
;EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull7 * EnvironVT[3, *]^gutfull28 * EnvironVL[3, *]^gutfull14 * EnvironVprey[3, *]^gutfull21)
;EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull8 * EnvironVT[4, *]^gutfull29 * EnvironVL[4, *]^gutfull15 * EnvironVprey[4, *]^gutfull22)
;EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull9 * EnvironVT[5, *]^gutfull30 * EnvironVL[5, *]^gutfull16 * EnvironVprey[5, *]^gutfull23)
;EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull10 * EnvironVT[6, *]^gutfull31 * EnvironVL[6, *]^gutfull17 * EnvironVprey[6, *]^gutfull24)

EnvironVSum[0, *] = DOUBLE(EnvironVDO[0, *]^gutfull4 * EnvironVT[0, *]^gutfull18 * EnvironVL[0, *]^gutfull11 * EnvironVprey[0, *]^gutfull25)
EnvironVSum[1, *] = DOUBLE(EnvironVDO[1, *]^gutfull5 * EnvironVT[1, *]^gutfull19 * EnvironVL[1, *]^gutfull12 * EnvironVprey[1, *]^gutfull26)
EnvironVSum[2, *] = DOUBLE(EnvironVDO[2, *]^gutfull6 * EnvironVT[2, *]^gutfull20 * EnvironVL[2, *]^gutfull13 * EnvironVprey[2, *]^gutfull27)
EnvironVSum[3, *] = DOUBLE(EnvironVDO[3, *]^gutfull7 * EnvironVT[3, *]^gutfull21 * EnvironVL[3, *]^gutfull14 * EnvironVprey[3, *]^gutfull28)
EnvironVSum[4, *] = DOUBLE(EnvironVDO[4, *]^gutfull8 * EnvironVT[4, *]^gutfull22 * EnvironVL[4, *]^gutfull15 * EnvironVprey[4, *]^gutfull29)
EnvironVSum[5, *] = DOUBLE(EnvironVDO[5, *]^gutfull9 * EnvironVT[5, *]^gutfull23 * EnvironVL[5, *]^gutfull16 * EnvironVprey[5, *]^gutfull30)
EnvironVSum[6, *] = DOUBLE(EnvironVDO[6, *]^gutfull10 * EnvironVT[6, *]^gutfull24 * EnvironVL[6, *]^gutfull17 * EnvironVprey[6, *]^gutfull31)
;PRINT, 'ENVIRONVSUM'
;PRINT, ENVIRONVSUM[*, 0:100]

; Determine fish movement orientation****************************************************************************************
; 1. determine which neighbouring cell to move
; Movement in z-dimension
zMove = FLTARR(nROG)
;EnvironVSumMax1 = MAX(EnvironVSum[1:3, *], DIMENSION = 1) - MAX(EnvironVSum[4:6, *], DIMENSION = 1)
;EnvironVSumMax2 = MAX(EnvironVSum[1:3, *], DIMENSION = 1) - EnvironVSum[0, *]
;EnvironVSumMax3 = MAX(EnvironVSum[4:6, *], DIMENSION = 1) - EnvironVSum[0, *]

EnvironVSumMax1 = TOTAL(EnvironVSum[1:3, *], 1)/3 - TOTAL(EnvironVSum[4:6, *], 1)/3
EnvironVSumMax2 = TOTAL(EnvironVSum[1:3, *], 1)/3 - EnvironVSum[0, *]
EnvironVSumMax3 = TOTAL(EnvironVSum[4:6, *], 1)/3 - EnvironVSum[0, *]

; move downward (3)
zMoveNeg = WHERE((EnvironVSumMax1 GT 0.) AND (EnvironVSumMax2 GT 0.), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
IF zMoveNegcount GT 0.0 THEN zMove[zMoveNeg] = 3
; move upward (4)
zMovePos = WHERE((EnvironVSumMax1 LT 0.) AND (EnvironVSumMax3 GT 0.), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
IF zMovePoscount GT 0.0 THEN zMove[zMovePos] = 4
; stay (0)
zMoveNon = WHERE((EnvironVSumMax2 LE 0.) AND (EnvironVSumMax3 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
IF zMoveNoncount GT 0.0 THEN zMove[zMoveNon] = 0
;PRINT, 'zMove'
;PRINT, zMove[0:100]
;zMovePos = FLTARR(nYP)
;zMoveNeg = FLTARR(nYP)
;zMoveNon = FLTARR(nYP)

;2. Determine specific fish movement orientation angle****************************************************
; For now, each cell is assumed to have gradients between the current and neiboring cells
; fish are able to detect gradients within a cetain range... 
; Vertical movement
VerOriAng = FLTARR(nROG)
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
SS = FLTARR(nROG)
S = FLTARR(nROG)
l = WHERE(ROG[1, *] LT 20.0, lcount, complement = ll, ncomplement = llcount)
IF (lcount GT 0.0) THEN S[l] = 3.3354 * ALOG(ROG[1, l]) - 4.8758;(-0.0797 * (YP[1, *][l] * YP[1, *][l]) + 1.9294 * YP[1, *][l] - 8.1761)
;SS equation based on data from Houde 1969 in body YP[1, *]s/sec
IF (llcount GT 0.0) THEN S[ll] = (0.28 * ROG[26, ll] + 7.89) / (0.1 * ROG[1, ll])
 ;in body YP[1, *]s/sec; from Breck 1997 and Hergenrader and Hasler 1967
; Converts SS into mm/s
SS = S * ROG[1, *]
;PRINT, 'S =', S
;  PRINT, 'Swimming speed (mm/s)'
;  PRINT, SS
;  PRINT, 'Swimming speed in Z-dimension (mm/s)'
;  PRINT, SS*COS(VerOriAng)

; Calculate realized swimming speed (mm/s) in z-dimension
MoveSpeed = FLTARR(5, nROG)
IF (Lcount GT 0.0) THEN MoveSpeed[2, L] = SS[L] * COS(VerOriAng[L]) * RANDOMU(seed, Lcount, /DOUBLE); VERTICAL DIRECTION
IF (LLcount GT 0.0) THEN MoveSpeed[2, LL] = SS[LL]/(ts*10.) * COS(VerOriAng[LL]) * RANDOMU(seed, LLcount, /DOUBLE); VERTICAL DIRECTION

; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
;MoveSpeed[4, *] = (0.102*(YP[1, *]/39.10/EXP(0.330)) + 30.3) * 10.0;n critical swimming speed for adult yellow perch from Nelson, 1989, J. Exp. Biol.
;***Maximum speed is also used for 'URGENCY' move? (from Goodwin et al., 2001)***
;PRINT, 'Realized movement speed (mm/s)'
;PRINT, MoveSpeed

; Distance fish move in each time step OR shorter subtime step???
ts2 = 120L; frequency of turning = >1
;******Determine the distance tarveled**********************************************************  
; Cell size in horizontal direction = 2.0km = 2000m = 2000000mm
zNewLoc = MoveSpeed[2, *] * ts * 60.; distance (mm) in z-dimension

zNewLocWithinCell = FLTARR(nROG)
VerSize = FLTARR(nROG)
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
IF zMoveOut0count GT 0.0 THEN ROG[14, zMoveOut0] = LocV[6, zMoveOut0];
IF zMoveOut1count GT 0.0 THEN ROG[14, zMoveOut1] = LocV[6, zMoveOut1];
IF zMoveOut2count GT 0.0 THEN ROG[14, zMoveOut2] = LocV[5, zMoveOut2];
IF zMoveOut3count GT 0.0 THEN ROG[14, zMoveOut3] = LocV[4, zMoveOut3];
IF zMoveOut4count GT 0.0 THEN ROG[14, zMoveOut4] = LocV[0, zMoveOut4];
IF zMoveOut5count GT 0.0 THEN ROG[14, zMoveOut5] = LocV[3, zMoveOut5];
IF zMoveOut6count GT 0.0 THEN ROG[14, zMoveOut6] = LocV[2, zMoveOut6];
IF zMoveOut7count GT 0.0 THEN ROG[14, zMoveOut7] = LocV[1, zMoveOut7];
IF zMoveOut8count GT 0.0 THEN ROG[14, zMoveOut8] = LocV[1, zMoveOut8];

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
NewFishEnviron = FLTARR(17, nROG)
NewFishEnviron[0:15, *] = NewInput[*, ROG[14, *]];YP[14, *] New 3D gridcell ID
NewFishEnviron[16, *] = zNewLocWithinCell; New within-cell location in z-dimension in new cell
;PRINT, 'NewFishEnviron[0:4, *]'
;PRINT, NewFishEnviron[0:4, *]
;PRINT, 'YP[14, *]'
;PRINT, YP[14, *]

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'Round Goby 1D Movement Ends Here'
RETURN, NewFishEnviron; TURN OFF WHEN TESTING
END