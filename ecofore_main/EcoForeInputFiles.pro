FUNCTION EcoForeInputFiles, iday, TotBenBio, Grid3D, InputArray, FishEnvir
;Function to read in input files from Limnotech
;***read input file from limnotech
;***open the file for reading as file unit 1:

;*******TEST ONLY***********************************************************************************************************
;;PRO EcoForeInputfiles, iday, TotBenBio, Grid3D
;Grid3D = GridCells3D(); INPUT FILE PARAMETER
;Grid2D = GridCells2D()
;
;iday = 243L; INPUT FILE PARAMETER
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell); g/m2
;;FOR IDAY = 243,246 DO BEGIN;***FOR TESTING CHIRODOMID PRODUCTION***********************
;; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IfYLE data  
;; Initial total benthic biomasss in May
;;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
;IF iDAY EQ 243L THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
;BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;ENDIF ELSE TotBenBio = TotBenBio; INPUT FILE PARAMETER
;****************************************************************************************************************************

PRINT, 'Input Files Begins Here'
tstart = systime(/seconds)

;file = FILEPATH('3DFull-9.out', Root_dir = 'H:'
;openr, lun1, file1, /get_lun
;;time info
;info1=fstat(lun1)
;ncols1=1L
;nrows1=info1.size/ncols1/4
;time=fltarr(ncols1,nrows1)
;readu, lun1, time
;free_lun, lun1
;print, time

;maxrec = 57660000L for the whole file
;file = FILEPATH('3DFull-9.out', Root_dir = 'E:');, SUBDIR = 'Documents and Settings\dgoto\Desktop\')
;file = FILEPATH('3DFull-9.out', Root_dir = 'F:');, SUBDIR = 'Documents and Settings\dgoto\Desktop\'); for laptop

; Locate an appropriate input file based on DOY
;***Note that due to the way solar radiation is estimated in the hydrodynamic model,$ 
; light levels in Jan, Feb, Mar, Nov, and Dec are all 0.0 (may need another fuction)******
;***The following DOYs are arranged for Year 2005*****************************************
DOY = iday + 1L; Day of the year
PRINT, 'Day of the Year:', DOY
; January 1-31 (31d)
IF (DOY GE 1L) AND (DOY LE 31L) THEN BEGIN
  DOM = DOY 
  file = FILEPATH('3DFull-1.out', Root_dir = 'F:');
ENDIF
; February 1-28 (28d)
IF (DOY GE 32L) AND (DOY LE 59L) THEN BEGIN
  DOM = DOY - 31L
  file = FILEPATH('3DFull-2.out', Root_dir = 'F:');
ENDIF
; March 1-31 (31d)
IF (DOY GE 60L) AND (DOY LE 90L) THEN BEGIN
  DOM = DOY - 59L 
  file = FILEPATH('3DFull-3.out', Root_dir = 'F:');
ENDIF 
; April 1-30 (30d)
IF (DOY GE 91L) AND (DOY LE 120L) THEN BEGIN
  DOM = DOY - 90L 
  file = FILEPATH('3DFull-4.out', Root_dir = 'F:');
ENDIF
; May 1-31 (31d)
IF (DOY GE 121L) AND (DOY LE 151L) THEN BEGIN
  DOM = DOY - 120L 
  file = FILEPATH('3DFull-5.out', Root_dir = 'F:');
ENDIF
; June 1-30 (30d)
IF (DOY GE 152L) AND (DOY LE 181L) THEN BEGIN
  DOM = DOY - 151L 
  ;file = FILEPATH('3DFull-6.txt', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM');
  ;file = FILEPATH('3DFull-6.TXT', Root_dir = 'F:', SUBDIR = 'LakeErieWaterQualityModelOutput2005')
  ;file = FILEPATH('3DFull-6.TXT', Root_dir = 'C:', SUBDIR = 'Users\dgoto\IDLWorkspace80\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
  file = FILEPATH('3DFull-6.TXT', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
ENDIF
; July 1-31 (31d)
IF (DOY GE 182L) AND (DOY LE 212L) THEN BEGIN
  DOM = DOY - 181L 
    ;file = FILEPATH('3DFull-7.txt', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM');
  ;file = FILEPATH('3DFull-7.TXT', Root_dir = 'F:', SUBDIR = 'LakeErieWaterQualityModelOutput2005');dgoto\IDLWorkspace80
  ;file = FILEPATH('3DFull-7.TXT', Root_dir = 'C:', SUBDIR = 'Users\dgoto\IDLWorkspace80\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
  file = FILEPATH('3DFull-7.TXT', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
ENDIF
; August 1-31 (31d)
IF (DOY GE 213L) AND (DOY LE 243L) THEN BEGIN
  DOM = DOY - 212L 
  ;file = FILEPATH('3DFull-8.txt', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM');
  ;file = FILEPATH('3DFull-8.TXT', Root_dir = 'F:', SUBDIR = 'LakeErieWaterQualityModelOutput2005')
  ;file = FILEPATH('3DFull-8.TXT', Root_dir = 'C:', SUBDIR = 'Users\dgoto\IDLWorkspace80\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
  file = FILEPATH('3DFull-8.TXT', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
ENDIF
; September 1-30 (30d)
IF (DOY GE 244L) AND (DOY LE 273L) THEN BEGIN
  DOM = DOY - 243L
  ;file = FILEPATH('3DFull-9.txt', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM');
  ;file = FILEPATH('3DFull-9.TXT', Root_dir = 'F:', SUBDIR = 'LakeErieWaterQualityModelOutput2005')
  ;file = FILEPATH('3DFull-9.TXT', Root_dir = 'C:', SUBDIR = 'Users\dgoto\IDLWorkspace80\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
  file = FILEPATH('3DFull-9.TXT', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
ENDIF
; October 1-31 (31d)
IF (DOY GE 274L) AND (DOY LE 304L) THEN BEGIN
  DOM = DOY - 273L
  ;file = FILEPATH('3DFull-10.txt', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM');
  ;file = FILEPATH('3DFull-10.TXT', Root_dir = 'F:', SUBDIR = 'LakeErieWaterQualityModelOutput2005')
  ;file = FILEPATH('3DFull-10.TXT', Root_dir = 'C:', SUBDIR = 'Users\dgoto\IDLWorkspace80\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
  file = FILEPATH('3DFull-10.TXT', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\IDLWorkspace71\EcoFore_10_Main\LakeErieWaterQualityModelOutput2005')
ENDIF
; November 1-30 (30d)
  IF (DOY GE 305L) AND (DOY LE 334L) THEN BEGIN
  DOM = DOY - 304L 
  file = FILEPATH('3DFull-11.out', Root_dir = 'F:');
ENDIF
; December 1-31 (31d)
IF (DOY GE 335L) AND (DOY LE 365L) THEN BEGIN
  DOM = DOY - 334L 
  file = FILEPATH('3DFull-12.out', Root_dir = 'F:');
ENDIF
PRINT, 'Day of the Month:', DOM
counter =  24L * (DOM - 1L) 
PRINT, 'Input Counter (24L * (DOM - 1L)):', counter
CellCt = 77500L
pointer = CellCt * counter; 1st line to read in 

IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L
;print, fileinfo, maxrows

; Input file order
; (1) i index, (2) j index, (3) temperature, (4) DO, (5) detrital carbon, (6) zooplankton
; (7) U velocity, (8) V velocity, (9) W velocity (vertical), (10) light

n = cellct*24L
;InputArray =  FLTARR(10L, n)
maxrow = 77500L

;x0 = 0L
;y0 = 0L
;temp0 = 0.0
;doam0 = 0.0
;dc0 = 0.0
;zoop0 = 0.0
;u0 = 0.0
;v0 = 0.0
;ww0 = 0.0
;light0 = 0.0
;count1 = 0L
OPENR, lun, file, /GET_LUN
;POINT_LUN, lun, pointer; return to the previous stored location
SKIP_LUN, lun, pointer,/LINES

info = FSTAT(lun) ; get the file status
;current = info.cur_ptr ; store the current location
READF, lun, InputArray; x0, y0, Temp0, DOam0, DC0, Zoop0, u0, v0, w0, light0
;readu, lun, variable ; read the variable
;point_lun, lun, current
xl = InputArray[0, *]
yl = InputArray[1, *]
Temp = InputArray[2, *]
DOam = InputArray[3, *]
DC = InputArray[4, *]
Zoop = InputArray[5, *]
uw = InputArray[6, *]
vw = InputArray[7, *]
ww = InputArray[8, *]
Light = InputArray[9, *]
FREE_LUN, lun

;***Correction for default zooplankton predation in the Water Quality Model*************
;***Since zooplankton in the water quality model has built-in predation effects,$
;its biomass without predation effects was backcalculated in IBM***:
Kd = 0.011/24.; per day -> need to convert to 1 hour /24
Theta = 1.08;
;ZooDeath = Zoop*kd*theta^(Temp-20)
Zoop2 = Zoop/(1. - kd*theta^(Temp-20.))
Zoop = Zoop2
;PRINT, 'Zoop[0L:99L]'
;PRINT, Zoop[0L:99L]
;****************************************************************

Light2 = Light/175000000000.; conevert from lux to mylux
;PRINT, "Light2", Light2[*, 0L : 99L]
;***Redistribution of zooplankton****************************** 
zoopl = (FLTARR(n))
gzLight = (FLTARR(n))
fMODzTemp = (FLTARR(n))
TotalLightTemp = (FLTARR(n))
Pz = (FLTARR(n))
;Zplkn = FLTARR(20); 1 = top layer; 20 = bottom layer
jv = 19L
; light function -> NEED LAKE ERIE ZOOPLANKTON FUNCTION USING IFYLE DATA
gzLight = EXP(-0.5^((ALOG10(Light2 > 0.00001)-((-6.86))/0.56)^2.))*RANDOMU(seed, n, /DOUBLE)

; Temperture function -> NEED LAKE ERIE ZOOPLANKTON FUNCTION USING IFYLE DATA
fMODzTemp = EXP(-0.5^((DOUBLE(ALOG(Temp > 0.00001))-(ALOG(6.07))/0.2314)^2.))*RANDOMU(seed, n, /DOUBLE)
; the model is for mysid, from Boscarino et al., 2007
;PRINT, "gzLight", gzLight[0L : 7499L]

FOR iv = 0L, n - 1L DO BEGIN
  ; Calculate cumulative zooplankton biomass for each vertical layer
  zoopl[iv] = TOTAL(zoop[iv : jv])
  
  ; the probability of finding zooplankton at depth z, given all available depths
  TotalLightTemp[iv] = TOTAL(fMODzTemp[iv : jv] * gzLight[iv : jv])
  Pz[iv : jv] = fMODzTemp[iv : jv] * gzLight[iv : jv]/TotalLightTemp[iv] 
  
  ; Redistribute zooplankton based on light and DO
  zoopl[iv : jv] = Pz[iv : jv]*zoopl[iv]
  iv = jv
  jv = jv + 20L
ENDFOR
;PRINT, 'Temp =', Temp[0L : 7499L]
;PRINT, 'Light2 =', Light2[0L : 7499L]
ZoopTest = FLTARR(5, N)
ZoopTest[0, *] = Pz
ZoopTest[1, *] = Zoop
ZoopTest[2, *] = Zoopl
;ZoopTest[3, *] = 
;ZoopTest[4, *] =
;PRINT, "Pz", 'Zoop', 'Zoopl'
;PRINT, ZoopTest[0:2, 0:499]
;;PRINT, 'TotalLightTemp =', TotalLightTemp[0L : 77499L]

;PRINT, "fMODzTemp", fMODzTemp[0L : 7499L]

; Create 20-vertical layer array for each x&y cell 
depth = INDGEN(20) + 1L; 1 = top layer; 20 = bottom layer
zl = (depth) # REPLICATE(1., 93000L)

; Locating bottom cells in the 1st-hour inputs
BottomCell = WHERE(zl[0:77499L] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;PRINT, 'Number of bottom cells =', BottomCellcount

; Locating bottom cells in all inputs
BottomCell24 = WHERE(zl[*] EQ 20L , BottomCell24count, complement = NonBottomCell24, ncomplement = NonBottomCell24count)
;PRINT, 'Number of bottom cells 24 =', BottomCell24count
;PRINT, BottomCell24

; Re-assign benthic carbon inputs
;PRINT, 'CARBON (g)'
;PRINT, (DC[0:7499L])
IF BottomCell24count GT 0. THEN DC[BottomCell24] = DC[BottomCell24] 
IF NonBottomCell24count GT 0. THEN DC[NonBottomCell24] = 0.
;PRINT, 'MAX(DC[0:77499L])', MAX(DC[0:77499L])
;PRINT, 'CARBON2 (g)'
;PRINT, (DC[0:77499L])

;CarbonHabitat = DC[0:77499L]/MAX(DC[0:77499L])
;PRINT, 'Habitat quality based on carbon (CarbonHabitat)'
;PRINT, (CarbonHabitat[0:499L])

; Carbon-based daily grwoth rate function from Goedkoope et al. 2007, CJFAS, vol 64, pp.425-
GrowthRate = FLTARR(CellCt); for daily inputs
DCNZ = WHERE(DC[0:77499L] GT 0., DONZcount, complement = DCZ, ncomplement = DCZcount); ONLY WHEN DC IS POSITIVE...
IF DONZcount GT 0. THEN GrowthRate[DCNZ] = 0.1021 * ALOG(DC[DCNZ]*1000.) + 0.6422; /d
;PRINT, 'GrowthRate (/d)'
;PRINT, (GrowthRate[0:77499L])

; Carbon-based benthic habitat quality is determined daily 
GrowRateHabitat = FLTARR(CellCt)
;NZGrowthRate = WHERE(GrowthRate GT 0., NZGrowthRatecount, complement = ZGrowthRate, ncomplement = ZGrowthRatecount)
IF DONZcount GT 0. THEN GrowRateHabitat[DCNZ] = GrowthRate[DCNZ]/MAX(GrowthRate[DCNZ]) 
IF DCZcount GT 0. THEN  GrowRateHabitat[DCZ] = 0.00000001 
;PRINT, 'Habitat quality based on carbon (GrowRateHabitat)'
;PRINT, (GrowRateHabitat[0:499L])

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
Prod = FLTARR(CellCt)
Bmax = MAX(TotBenBio); 1500000.; Bmax = the maximum production; 6 g/m^2 or 1500000 g/km^2
;PosGrowRateHabitat = WHERE(GrowRateHabitat[0:77499L] GT 0., PosGrowRateHabitatcount)

IF BottomCellcount GT 0. THEN Prod[BottomCell] = r * (1.0 + p * SIN((2.0 * !Pi * DOY) / 365.0)) $
                        * (1 - (TotBenBio[BottomCell] /(GrowRateHabitat[BottomCell] * Bmax))) * TotBenBio[BottomCell] 
IF NonBottomCellcount GT 0. THEN Prod[NonBottomCell] = 0.


;PRINT, 'Chironomid production'
;PRINT, Prod[0:77499L]

;TotBenBio = TotBenBio+Prod 
;PRINT, 'Chironomid biomass'
;PRINT, TotBenBio[0:77499L] 
;ENDFOR;***FOR TESTING CHIRODOMID PRODUCTION***********************
;PRINT, n_elements(prod)
;PRINT, n_elements(totbenbio)
;PRINT, n_elements(bottomcell)
;PRINT, n_elements(bottomcell24)
;PRINT, n_elements(zl)
;
;;***Create grid IDs for each X&Y AND X&Y&Z for 24-hour inputs***
;;gID = FLTARR(maxrow); = FID
;;GridIDxy = FLTARR(n)
;;GridNo = FLTARR(n); Assigning each 3D cell a unique id
;;Prod24 = FLTARR(n)
;;jj = 77499L
;;FOR i = 0L, n - 1L DO BEGIN
;;  GridIDxy[i] = TRANSPOSE(GRID3D[3, *]); GridIDxy
;;  GridNo[i] = TRANSPOSE(GRID3D[4, *]); GridNo 
;;  Prod24[i] = Prod[*]
;;  i = jj
;;  jj = jj + 77500L
;;  gID = gID + 1L
;;ENDFOR
;;*****************************************************************
GridIDxy = TRANSPOSE(GRID3D[3, *]) # REPLICATE(1., 24L); GridIDxy
GridNo = TRANSPOSE(GRID3D[4, *]) # REPLICATE(1., 24L); GridNo 
Depth = TRANSPOSE(GRID3D[5, *]) # REPLICATE(1., 24L); GridNo 
Prod24 = Prod[*] # REPLICATE(1., 24L)
;;*****************************************************************

;***Convert carbon mg/L to chironomid g/m3 ~= g/m2 for ~< 1m depth*******
; dry to wet for chironomid 5 - 12%
; Assume 50% carbon
;Chir = FLTARR(n)
;BottomCell = WHERE(zl[*] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN Chir[BottomCell] = DC[BottomCell]*2.0/0.05 ELSE Chir[NonBottomCell] = 0.
;PRINT, 'chironomid'
;PRINT, Chir[0:100]

; Inputs for SE-IBMs
;FishEnvir = FLTARR(16, n)
FishEnvir[0, *] = xl; x ID
FishEnvir[1, *] = yl; y ID
FishEnvir[2, *] = zl; z ID
FishEnvir[3, *] = GridIDxy; X&Y grid cell ID
FishEnvir[4, *] = GridNO; x&y&z cell id

;****the following aooplankton biomass ratios for different classes are based on '83-'87 data from Makarewicz, 1993******
;convert mgC wet /L to g/L
FishEnvir[5, *] = Zoopl / 0.08 * ((.161) * 1.0/ 1000.0 / 1.0); microzooplankton, g/L
FishEnvir[6, *] = Zoopl / 0.08 * ((.587) * 1.0/ 1000.0 / 1.0); mid-size zooplankton; NOT YET, g/L
FishEnvir[7, *] = Zoopl / 0.08 * ((.248) * 1.0/ 1000.0 / 1.0); large-bodied zooplankton; NOT YET, g/L
FishEnvir[8, *] = Prod24; *1.0 * 0.05 / 10.0 * 1.0; Chironomids production ONLY, g/m2

FishEnvir[9, *] = Temp; temperature in C
FishEnvir[10,*] = DOam; DO in mg/L
FishEnvir[11,*] = Light; light
FishEnvir[12,*] = uw*1000.; water current i in mm/s
FishEnvir[13,*] = vw*1000.; water current j in mm/s
FishEnvir[14,*] = ww*1000.; water current w in mm/s
FishEnvir[15,*] = depth
;PRINT, fishenvir[0:7, 77499L:77499L+299L];, fishenvir[1,0L:77499L], fishenvir[11,0L:77499L]
;PRINT, fishenvir[0:15,0L:77499L];


;---Begin Output to a file----------------------------------------------
;OPENW, ounit,'NewInputfilesOut.txt', /GET_LUN, width = 1500L
;PRINT, ounit
;FOR iw = 0L, maxrow - 1L DO PRINTF, ounit, Fishenvir[*, iw];, FORMAT = "(15F10.7)"
; FORMAT = column# F #digits before dicimal point . #digits after dcimal point
;FREE_LUN, ounit
;PRINT, '"Your Output File is Ready"'
;---End Output to a file------------------------------------------------

;***Creat an output file*********************************************************
;outputcounter =  DOY - 182L; Same as the initial day of a daily loop 
;;PRINT, 'Counter', counter
;;PRINT, 'DAY', day
;PRINT, nYP; rows
;pointer = nYP * counter; 1st line to read in 
;data = YP
;; Set up variables.
;   filename = 'IDLoutput.csv'  
;   ;;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
;   s = Size(data, /Dimensions)
;   xsize = s[0]
;   lineWidth = 1600
;   comma = ","
;IF outputcounter EQ 0L THEN BEGIN; 
;; Open the data file for writing.
;   OpenU, lun, filename, /Get_Lun, Width=lineWidth
;ENDIF
;IF outputcounter GT 0L THEN BEGIN; 
;  OpenU, lun, filename, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer, /lines
;  READF, lun
;ENDIF
;; Write the data to the file.
;   sData = StrTrim(data,2)
;   sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;   PrintF, lun, sData
;; Close the file.
;   Free_Lun, lun
;PRINT, '"Your Output File is Ready"'
;*************************************************************************************

PRINT, 'End of Input: DAY', iday + 1L
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading Input Files Ends Here'
RETURN, FishEnvir; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END