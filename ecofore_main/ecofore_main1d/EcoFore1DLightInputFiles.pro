FUNCTION EcoFore1DLightInputFiles, iYEAR
;Function to read in 1D LIGHT input files from Limnotech
;***read input file from limnotech
;***open the file for reading as file unit 1:

;*******TEST ONLY***********************************************************************************************************
;iYEAR = 1987L
;TEMP = FLTARR(100)
;TEMP = 20.
;ZOOP = FLTARR(100)
;ZOOP = .01
;LIGHTEX = 0.5
;DEPTH = 0.25
;****************************************************************************************************************************

PRINT, '1D Light Input Files Begins Here'
tstart = systime(/seconds)

;DOY = iday + 1L; Day of the year
; 48 VERTIAL LAYERS

; YEAR 1987
IF iYEAR EQ 1987L THEN BEGIN
  ;file = FILEPATH('1DLightOutput87.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput87.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput87.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1988
IF iYEAR EQ 1988L THEN BEGIN 
  ;file = FILEPATH('1DLightOutput88.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1989 
IF iYEAR EQ 1989L THEN BEGIN
  ;file = FILEPATH('1DLightOutput89.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput89.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput89.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1990
IF iYEAR EQ 1990L THEN BEGIN
  ;file = FILEPATH('1DLightOutput90.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput90.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput90.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1991
IF iYEAR EQ 1991L THEN BEGIN
  ;file = FILEPATH('1DLightOutput91.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput91.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput91.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1992
IF iYEAR EQ 1992L THEN BEGIN
  ;file = FILEPATH('1DLightOutput92.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput92.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput92.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1993
IF iYEAR EQ 1993L THEN BEGIN
  ;file = FILEPATH('1DLightOutput93.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput93.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput93.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1994
IF iYEAR EQ 1994L THEN BEGIN
  ;file = FILEPATH('1DLightOutput94.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput94.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput94.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1995
IF iYEAR EQ 1995L THEN BEGIN
  ;file = FILEPATH('1DLightOutput95.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput95.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput95.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1996
IF iYEAR EQ 1996L THEN BEGIN
  ;file = FILEPATH('1DLightOutput96.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput96.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput96.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1997
IF iYEAR EQ 1997L THEN BEGIN
  ;file = FILEPATH('1DLightOutput97.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput97.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput97.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1998
IF iYEAR EQ 1998L THEN BEGIN
  ;file = FILEPATH('1DLightOutput88.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput88.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 1999
IF iYEAR EQ 1999L THEN BEGIN
  ;file = FILEPATH('1DLightOutput99.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput99.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput99.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2000
IF iYEAR EQ 2000L THEN BEGIN
  ;file = FILEPATH('1DLightOutput00.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput00.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput00.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2001
IF iYEAR EQ 2001L THEN BEGIN
  ;DOM = DOY - 151L 
  ;file = FILEPATH('1DLightOutput01.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput01.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput01.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2002
IF iYEAR EQ 2002L THEN BEGIN
  ;file = FILEPATH('1DLightOutput02.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput02.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput02.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2003
IF iYEAR EQ 2003L THEN BEGIN
  ;file = FILEPATH('1DLightOutput03.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput03.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput03.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2004
IF iYEAR EQ 2004L THEN BEGIN
 ;file = FILEPATH('1DLightOutput04.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
 file = FILEPATH('1DLightOutput04.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
 ;file = FILEPATH('1DLightOutput04.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF
; YEAR 2005
IF iYEAR EQ 2005L THEN BEGIN
  ;file = FILEPATH('1DLightOutput05.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM\LakeErieWaterQuality1DModelOutput1987-2005');
  file = FILEPATH('1DLightOutput05.csv', Root_dir = 'C:', SUBDIR = 'Users\forbeslab\IDLWorkspace81_V\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
  ;file = FILEPATH('1DLightOutput05.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQuality1DModelOutput1987-2005')
ENDIF

IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L
;print, fileinfo, maxrows

; Input file order
; (1) month, (2) day, (3) hour, (4) minute, (5) surface light
nn = 30984L;30960L ;26496L **mid-November, shifted a bit to line up with reality
n = 30960L
InputArray = FLTARR(5L, NN)
OPENR, lun, file, /GET_LUN
READF, lun, InputArray;
;MONTH = InputArray[0, *]
;DAY = InputArray[1, *]
;HOUR = InputArray[2, *]
;MINUTE = InputArray[3, *]
;LIGHTSURF = InputArray[4, *]
MONTH = InputArray[0, 0:30959]
DAY = InputArray[1, 0:30959]
HOUR = InputArray[2, 0:30959]
MINUTE = InputArray[3, 0:30959]
LIGHTSURF = InputArray[4, 23:30982]
FREE_LUN, lun
;PRINT, INPUTARRAY

;; to convedret langely to lux
;Light = (LIGHTSURF * EXP(-1.* LIGHTEX * DEPTH)) * 331.69

; LIGHT Inputs for SE-IBMs
FishLightEnvir = FLTARR(5L, N)
FishLightEnvir[0, *] = MONTH 
FishLightEnvir[1, *] = DAY
FishLightEnvir[2, *] = HOUR
FishLightEnvir[3, *] = MINUTE
FishLightEnvir[4, *] = LIGHTsurf
;PRINT, TRANSPOSE(FishLightEnvir[4, 0:143L])

PRINT, 'End of Input: YEAR', iYEAR
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading 1D LIGHT Input Files Ends Here'
RETURN, FishLightEnvir; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END