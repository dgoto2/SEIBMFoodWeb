
; Time steps of simulations
ts = 15L ;minutes in a time step
td = (60L/ts)*24L ; number of time steps in a day

nGridcell = 77500L; the number of total grid cells
nEnvir3d = 77500*24L
TotBenBio = FLTARR(nGridcell)
Envir3d2 = FLTARR(16L, nGridcell)
;***************************************Spatial Component***********************************************
Grid3D2 =FLTARR(5L, nGridcell)
Grid2D2 = FLTARR(4L, 3875L)
Grid3D = GridCells3D()
Grid3D2 = Grid3D
;GrdCell3D[0, *] = xloc
;GrdCell3D[1, *] = yloc
;GrdCell3D[2, *] = zloc
;GrdCell3D[3, *] = GridID; for x and y
;GrdCell3D[4, *] = GridNo
Grid2D = GridCells2D()
Grid2D2 = Grid2D
;xyH[0, *] = xH
;xyH[1, *] = yH
;xyH[2, *] = xyID
;xyH[3, *] = Dpt
;********************************************************************************************************
;**The number of days in each month of 2005, DOY = iday + 1L***********************************
;IF (DOY GE 1L) AND (DOY LE 31L) January 1-31 (31d)
;IF (DOY GE 32L) AND (DOY LE 59L) February 1-28 (28d) 
;IF (DOY GE 60L) AND (DOY LE 90L) March 1-31 (31d)
;IF (DOY GE 91L) AND (DOY LE 120L) April 1-30 (30d)
;IF (DOY GE 121L) AND (DOY LE 151L) May 1-31 (31d)
;IF (DOY GE 152L) AND (DOY LE 181L) June 1-30 (30d)
;IF (DOY GE 182L) AND (DOY LE 212L) July 1-31 (31d)
;IF (DOY GE 213L) AND (DOY LE 243L) August 1-31 (31d)
;IF (DOY GE 244L) AND (DOY LE 273L) September 1-30 (30d)
;IF (DOY GE 274L) AND (DOY LE 304L) October 1-31 (31d)
;IF (DOY GE 305L) AND (DOY LE 334L) November 1-30 (30d)
;IF (DOY GE 335L) AND (DOY LE 365L) December 1-31 (31d)   
;***********************************************************************************************
tstart1 = SYSTIME(/seconds)

FOR iDay = 182L - 1L, 273L - 1L DO BEGIN;(Change iday values in other sub routines)*************DAYLY LOOP***************************************************************
  PRINT, 'DAY', iday + 1L; day of the year 
  counter =  iDay - 182L + 1L;*****FOR OUTPUT FILES (DOY)**************** 
  ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)********************
  PRINT, 'Counter', counter
  tstart2 = SYSTIME(/seconds)
  
  ; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IFYLE data  
  ; Initial total benthic biomasss in May
  ;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
  IF iDAY EQ 181L THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
    BottomCell = WHERE(Grid3D2[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
    IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
  ENDIF ELSE TotBenBio = TotBenBio
  
  ; Read a daily environmental input
  Envir3d = EcoForeInputFiles(iday, TotBenBio, Grid3D2) 
  
  FOR iHour = 0L, 23L DO BEGIN;************************************HOURLY LOOP***************************************************************
    PRINT,  'DAY', iday + 1L, '     HOUR', ihour + 1L
    ;inputcounter =  ihour + 24L * (iday); inpucounter + 1
    ;PRINT, 'INPUT COUNTER', inputcounter
    ;
    ; Call only an hourly input from a daily input read from the file
     ; HourInput = [77500L * ihour : 77500L * ihour + 77499L]
     Envir3d2 = Envir3d[*, 77500L * ihour : 77500L * ihour + 77499L]
     ;PRINT, 'Hourly Input',  envir3d2
   ENDFOR  
ENDFOR
PRINT, Envir3d2
END