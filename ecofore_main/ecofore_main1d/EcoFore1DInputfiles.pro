FUNCTION EcoFore1DInputFiles, iYear, DOY, TotBenBio
;Function to read in input files from Limnotech
;***read input file from limnotech
;***open the file for reading as file unit 1:

PRINT, '1D Input Files Begins Here'
tstart = systime(/seconds)

;DOY = iday + 1L; Day of the year
; 48 VERTIAL LAYERS

; YEAR 1987
IF iYEAR EQ 1987L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput87.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput87.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput87.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1988
IF iYEAR EQ 1988L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput88.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1989
IF iYEAR EQ 1989L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput89.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput89.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput89.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1990
IF iYEAR EQ 1990L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput90.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput90.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput90.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1991
IF iYEAR EQ 1991L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput91.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput91.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput91.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1992
IF iYEAR EQ 1992L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput92.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput92.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput92.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1993
IF iYEAR EQ 1993L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput93.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput93.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput93.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1994
IF iYEAR EQ 1994L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput94.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput94.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput94.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1995
IF iYEAR EQ 1995L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput95.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput95.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1996 
IF iYEAR EQ 1996L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput96.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput96.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1997
IF iYEAR EQ 1997L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput97.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput97.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1998
IF iYEAR EQ 1998L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput98.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput98.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput98.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1999
IF iYEAR EQ 1999L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput99.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput99.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2000
IF iYEAR EQ 2000L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput00.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput00.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2001
IF iYEAR EQ 2001L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput01.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput01.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2002
IF iYEAR EQ 2002L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput02.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput02.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2003
IF iYEAR EQ 2003L THEN BEGIN
  ;file = FILEPATH('1DHypoxiaOutput03.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput03.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2004 
IF iYEAR EQ 2004L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput04.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput04.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2005
IF iYEAR EQ 2005L THEN BEGIN 
  ;file = FILEPATH('1DHypoxiaOutput05.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DHypoxiaOutput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DHypoxiaOutput05.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF

IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Input file order
; (1) month, (2) day, (3) year, (4) depth (m), (5) Dissolved Oxygen (mg/L), (6) Light Extinction (1/m) 
; (7) Phytoplankton Biomass (mgC/L), (8) Temperature (C), (9) Zooplankton Biomass (mgC/L), (10) Detrital Carbon (mgC/L)
N = 12000L;9216L; 8832L
InputArray = FLTARR(10L, N)
OPENR, lun, file, /GET_LUN
READF, lun, InputArray;
MONTH = InputArray[0, *]
DAY = InputArray[1, *]
YEAR = InputArray[2, *]
DEPTH = InputArray[3, *]
OXYGEN = InputArray[4, *]
LIGHTEX = InputArray[5, *]
PHYTO = InputArray[6, *]
TEMP = InputArray[7, *]
ZOOP = InputArray[8, *]
CARBON = InputArray[9, *]
FREE_LUN, lun
;PRINT, InputArray

;***Correction for default zooplankton predation in the Water Quality Model*************
;***Since zooplankton in the water quality model has built-in predation effects,$
;its biomass without predation effects was backcalculated in IBM***:
Kd = 0.011; per day -> need to convert to 1 hour /24
Theta = 1.08;
;ZooDeath = Zoop*kd*theta^(Temp-20)
Zoop2 = Zoop/(1. - kd*theta^(Temp-20.))
Zoop = Zoop2
;PRINT, 'Zoop[0L:99L]'
;PRINT, Zoop[0L:99L]
;****************************************************************

; Locating bottom cells in the inputs
BottomCell = WHERE(DEPTH EQ 23.75, BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;PRINT, 'Number of bottom cells =', BottomCellcount

; Re-assign benthic carbon inputs
;PRINT, 'CARBON (g)'
;PRINT, (DC[0:7499L])
IF BottomCellcount GT 0. THEN CARBON[BottomCell] = CARBON[BottomCell] 
IF NonBottomCellcount GT 0. THEN CARBON[NonBottomCell] = 0.
;PRINT, 'CARBON2 (g)'
;PRINT, TRANSPOSE(CARBON)

; Carbon-based daily grwoth rate function from Goedkoope et al. 2007, CJFAS, vol 64, pp.425-
GrowthRate = FLTARR(N); for daily inputs
DCNZ = WHERE(CARBON GT 0., DONZcount, complement = DCZ, ncomplement = DCZcount); ONLY WHEN DC IS POSITIVE...
;IF DONZcount GT 0. THEN GrowthRate[DCNZ] = 0.1021 * ALOG(CARBON[DCNZ]*1000.) + 0.6422; /d
GrowthRate[dcnz] = 0.1021 * ALOG(CARBON[dcnz]*1000.) + 0.6422; /d
;PRINT, 'GrowthRate (/d)'
;PRINT, (GrowthRate)

; Carbon-based benthic habitat quality is determined daily 
GrowRateHabitat = FLTARR(N)
;NZGrowthRate = WHERE(GrowthRate GT 0., NZGrowthRatecount, complement = ZGrowthRate, ncomplement = ZGrowthRatecount)
;IF DONZcount GT 0. THEN GrowRateHabitat[DCNZ] = GrowthRate[DCNZ]/MAX(GrowthRate[DCNZ]) 
;IF DCZcount GT 0. THEN  GrowRateHabitat[DCZ] = 0.00000001 
GrowRateHabitat = 1.;GrowthRate/MAX(GrowthRate) 
;PRINT, 'Habitat quality based on carbon (GrowRateHabitat)'
;PRINT, (GrowRateHabitat)

; Calculate production in g/d 
r = 0.0175; r is the growth rate (/d)
p = 0.25; p a term that accounts for the variation that occurs in benthic macros-> should be temp-dependent (determined by DOY?)
;q = FLTARR(n);q is a habitat quality value ranges from 0.1-1
;q = RANDOMU(seed, n) + 0.1
;PRINT, 'Habitat quality (q)'
;PRINT, q[0:499L]
;qtb = WHERE(q GT 1.0, qtbcount, complement = qtbc, ncomplement = qtbccount)
;IF qtbcount GT 0.0 THEN q[qtb] = 1.0 

;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:499L]; TotBenBio is the biomass in each cell
Prod = FLTARR(N)
Bmax = 6.679; MAX(TotBenBio); 1500000.; Bmax = the maximum production; 6 g/m^2 or 1500000 g/km^2
IF BottomCellcount GT 0. THEN Prod[BottomCell] = r * (1.0 + p * SIN((2.0 * !Pi * DOY) / 365.0)) $
                                       * (1 - (TotBenBio[BottomCell]/(GrowRateHabitat[BottomCell] * Bmax))) * TotBenBio[BottomCell] 
IF NonBottomCellcount GT 0. THEN Prod[NonBottomCell] = 0.
;PRINT, 'Chironomid production'
;PRINT, Prod[BottomCell];[0:47]
;PRINT, 'BMAX =', BMAX
;print, min(totbenbio)
;print, transpose(growratehabitat)
;PRINT, 'GrowthRate'
;print, (growthrate)
;print, (carbon[bottomcell])
;print, max(prod)
;print, min(r*(1.0 + p * SIN((2.0 * !Pi * DOY) / 365.0))) 
;print, min(GrowRateHabitat[BottomCell] * Bmax)

;TotBenBio = TotBenBio+Prod 
;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:77499L] 
;ENDFOR;***FOR TESTING CHIRODOMID PRODUCTION***********************
;PRINT, n_elements(prod)
;PRINT, n_elements(totbenbio)
;PRINT, n_elements(bottomcell)
;PRINT, n_elements(bottomcell24)
;PRINT, n_elements(zl)


; Inputs for SE-IBMs
FishEnvir = FLTARR(12, n)
FishEnvir[0, *] = MONTH;
FishEnvir[1, *] = DAY;
FishEnvir[2, *] = YEAR;
FishEnvir[3, *] = DEPTH;
FishEnvir[4, *] = CARBON;

;****the following aooplankton biomass ratios for different classes are based on '83-'87 data from Makarewicz, 1993******
;convert mgC wet /L to g/L
FishEnvir[5, *] = ZOOP; microzooplankton, g/L
FishEnvir[6, *] = ZOOP ; mid-size zooplankton; NOT YET g/L
FishEnvir[7, *] = ZOOP; large-bodied zooplankton; NOT YET g/L
FishEnvir[8, *] = Prod; *1.0 * 0.05 / 10.0 * 1.0; Chironomids production ONLY g/m2

FishEnvir[9, *] = TEMP; temperature in C
FishEnvir[10,*] = OXYGEN; DO in mg/L
FishEnvir[11,*] = LIGHTEX; light
;PRINT, fishenvir[0:7, 77499L:77499L+299L];
;PRINT, fishenvir[0:15,0L:77499L];


PRINT, 'End of Input: YEAR', iYEAR, '     DAY', DOY
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading 1D Input Files Ends Here'
RETURN, FishEnvir; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END