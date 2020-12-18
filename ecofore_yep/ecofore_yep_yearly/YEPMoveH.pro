;FUNCTION YEPMoveH, YP, nYP, newinput, Grid2D, DOacclim
;function determines movement in X,Y,Z direction for all yellow perch
;******This function works only for moveing to neiboring cells (wiht relatively large horizontal cells)***************************

;**********************TEST ONLY*************************************************
PRO YEPMoveH, YP, nYP, newinput, Grid2D, DOacclim, xOldLocWithinCell, yOldLocWithinCell, zOldLocWithinCell
; NEED to change NewInputFiles, YPinitial, YEPacclT, YEPacclDO for testing
ts = 6L; 6 minutes
nYP = 100L; number of SI YP
ihour = 15L
newinput = NewInputFiles()
newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]
YP = YPinitial()
length = FLTARR(nYP); fish length
length = YP[1, *]; in mm
Temp = YP[19, *]
Grid2D = GridCells2D()
DOacclim = YEPacclDO()
xOldLocWithinCell = YP[39, *]; TEST ONLY 
yOldLocWithinCell = YP[40, *]; TEST ONLY
zOldLocWithinCell = YP[41, *]
xOldLocWithinCell[*] = 0.5; TEST ONLY, updated within-cell location from initial
yOldLocWithinCell[*] = 0.5; TEST ONLY, updated within-cell location from initial
zOldLocWithinCell[*] = 0.0
;HorOriAng = 45.; horizontal movement orientation angle
;VerOriAng = 45.; vertical movement orientation angle
;***********************************************************************************

PRINT, 'Horizantal Movement Begins Here'
; Randomly determine movement
; Probability of movement in Z has to be greater than in X and Y due to cell size

; NEED TO CHECK BOUNDARY CELLS AFTER THEY MOVE TO A NEW CELL
;******NO NEED TO IDENTIFY THE CURRENT CELL AND INCORPORATE 
;******Change * to 0 in row subscripting*********
;PRINT, 'Inital X', YP[10, *]
;PRINT, 'Inital Y', YP[11, *]
;PRINT, 'Inital Z', YP[12, *]
;PRINT, 'Inital Horizontal ID', YP[13, *]
;PRINT, 'Inital 3D ID', YP[14, *]
;PRINT, 'Initial fish environment', YP[15 : 24, *]
;15 = Fishenvir[5,*] = microzooplankton
;16 = Fishenvir[6,*] = mid-sized zooplankton
;17 = Fishenvir[7,*] = large zooplankton
;18 = Fishenvir[8,*] = chironomids
;19 = Fishenvir[9,*] = temperature
;20 = Fishenvir[10,*] = DO
;21 = Fishenvir[11,*] = light
;22 = Fishenvir[12,*] = current i
;23 = Fishenvir[13,*] = current j
;24 = Fishenvir[14,*] = dpt ; depth
;NewX = fltarr(nYP); new X location
;NX = fltarr(nYP); holds temporary new x cell locations for fish that move
;NewY = fltarr(nYP); new Y location
;NY = fltarr(nYP); holds temporary new y cell locations for fish that move
;NewZ = fltarr(nYP); new Z location

tstart = systime(/seconds)
;***How to make specific random normal distribution***********
; new_distribution = array * sigma + mean
;sigma = 0.5
;mean = 0.5
;array = RANDOMN(seed, nYP, /DOUBLE)
;NewRandomn = array * sigma + mean
;PRINT, 'RANDOMN', array
;PRINT, 'NewRAMDOMN', NewRandomn
;**************************************************************

;**Horizontal movement*****************************************************************************************
; Randomly determine if fish will move out of cell -> NEED to change to environmental preference/quality- based
; MoveHor = (RANDOMU(seed, nYP)); Pobability of horizontal RANDOM movement
; PRINT, 'MoveHor =', movehor

;*****Identify potential cell IDs in all 8 directions*******************************************
; Fish moves in the horizontal -> 8 possible cells to move
;      1 | 2 | 3               UP
;     -----------
;      4 | X | 5        LEFT         RIGHT
;     -----------
;      6 | 7 | 8              DOWN

;*********Include additional horizontal layers for vertical movement???********
LocH = FLTARR(27, nYP)
LocHV = FLTARR(9*7L, nYP)
NewGridXY = FLTARR(9L, nYP)
; 1 in X and Y dimensions
LocH[0, *] = YP[10, *] - 1L
LocH[1, *] = YP[11, *] + 1L
; 2
LocH[2, *] = YP[10, *]
LocH[3, *] = YP[11, *] + 1L
; 3
LocH[4, *] = YP[10, *] + 1L
LocH[5, *] = YP[11, *] + 1L
; 4
LocH[6, *] = YP[10, *] - 1L
LocH[7, *] = YP[11, *] 
; 5
LocH[8, *] = YP[10, *] + 1L
LocH[9, *] = YP[11, *] 
; 6
LocH[10, *] = YP[10, *] - 1L
LocH[11, *] = YP[11, *] - 1L
; 7
LocH[12, *] = YP[10, *] 
LocH[13, *] = YP[11, *] - 1L
; 8
LocH[14, *] = YP[10, *] + 1L
LocH[15, *] = YP[11, *] - 1L
; No move = the current cell
LocH[16, *] = YP[10, *]
LocH[17, *] = YP[11, *]
;PRINT, 'LocH', LocH[0:17, *]
;PRINT,'LocH[18, INDGEN(nYP)]', LocH[18, *];
;****************Identify neibouring cell IDs***********************************************************************************
FOR ihh = 0L, nYP - 1L DO BEGIN;*****Time-consuming part*********************************************************************
  LocH[18, ihh] = WHERE((LocH[0, ihh] EQ Grid2D[0, *]) AND (LocH[1, ihh] EQ Grid2D[1, *]), NewXYloc1) 
  LocH[19, ihh] = WHERE((LocH[2, ihh] EQ Grid2D[0, *]) AND (LocH[3, ihh] EQ Grid2D[1, *]), NewXYloc2) 
  LocH[20, ihh] = WHERE((LocH[4, ihh] EQ Grid2D[0, *]) AND (LocH[5, ihh] EQ Grid2D[1, *]), NewXYloc3) 
  LocH[21, ihh] = WHERE((LocH[6, ihh] EQ Grid2D[0, *]) AND (LocH[7, ihh] EQ Grid2D[1, *]), NewXYloc4) 
  LocH[22, ihh] = WHERE((LocH[8, ihh] EQ Grid2D[0, *]) AND (LocH[9, ihh] EQ Grid2D[1, *]), NewXYloc5) 
  LocH[23, ihh] = WHERE((LocH[10, ihh] EQ Grid2D[0, *]) AND (LocH[11, ihh] EQ Grid2D[1, *]), NewXYloc6) 
  LocH[24, ihh] = WHERE((LocH[12, ihh] EQ Grid2D[0, *]) AND (LocH[13, ihh] EQ Grid2D[1, *]), NewXYloc7) 
  LocH[25, ihh] = WHERE((LocH[14, ihh] EQ Grid2D[0, *]) AND (LocH[15, ihh] EQ Grid2D[1, *]), NewXYloc8) 
  LocH[26, ihh] = WHERE((LocH[16, ihh] EQ Grid2D[0, *]) AND (LocH[17, ihh] EQ Grid2D[1, *]), NewXloc9) 
; PRINT,'hhv', ihh, 'LocH[0, ihh]', LocH[0, ihh];,'Grid2D', Grid2D[0, LocH[0, ihh]], 'LocH[1, ihh]', LocH[1, ihh],'Grid2D', Grid2D[1, LocH[1, ihh]];, 'LocXY', LocXY

; Check if a grid cell exists
;****IF THE CELL DOES NOT EXIST WITHIN NEIBOURING CELLS, FISH WILL STAY IN THE CURRENT CELL
  IF (LocH[18, ihh] GE 0.0) THEN NewGridXY[0, ihh] = LocH[18, ihh] ELSE NewGridXY[0, ihh] = YP[13, ihh] 
  IF (LocH[19, ihh] GE 0.0) THEN NewGridXY[1, ihh] = LocH[19, ihh] ELSE NewGridXY[1, ihh] = YP[13, ihh] 
  IF (LocH[20, ihh] GE 0.0) THEN NewGridXY[2, ihh] = LocH[20, ihh] ELSE NewGridXY[2, ihh] = YP[13, ihh] 
  IF (LocH[21, ihh] GE 0.0) THEN NewGridXY[3, ihh] = LocH[21, ihh] ELSE NewGridXY[3, ihh] = YP[13, ihh]
  IF (LocH[22, ihh] GE 0.0) THEN NewGridXY[4, ihh] = LocH[22, ihh] ELSE NewGridXY[4, ihh] = YP[13, ihh]
  IF (LocH[23, ihh] GE 0.0) THEN NewGridXY[5, ihh] = LocH[23, ihh] ELSE NewGridXY[5, ihh] = YP[13, ihh]
  IF (LocH[24, ihh] GE 0.0) THEN NewGridXY[6, ihh] = LocH[24, ihh] ELSE NewGridXY[6, ihh] = YP[13, ihh] 
  IF (LocH[25, ihh] GE 0.0) THEN NewGridXY[7, ihh] = LocH[25, ihh] ELSE NewGridXY[7, ihh] = YP[13, ihh] 
  IF (LocH[26, ihh] GE 0.0) THEN NewGridXY[8, ihh] = LocH[26, ihh] ELSE NewGridXY[8, ihh] = YP[13, ihh]

;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[0, ihh] = LocH[18, ihh] ELSE NewGridXY[0, ihh] = YP[13, ihh] 
;  IF (NewXYloc2 GT 0.0) THEN NewGridXY[1, ihh] = LocH[19, ihh] ELSE NewGridXY[1, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[2, ihh] = LocH[20, ihh] ELSE NewGridXY[2, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[3, ihh] = LocH[21, ihh] ELSE NewGridXY[3, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[4, ihh] = LocH[22, ihh] ELSE NewGridXY[4, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[5, ihh] = LocH[23, ihh] ELSE NewGridXY[5, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[6, ihh] = LocH[24, ihh] ELSE NewGridXY[6, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[7, ihh] = LocH[25, ihh] ELSE NewGridXY[7, ihh] = YP[13, ihh] 
;  IF (NewXYloc1 GT 0.0) THEN NewGridXY[8, ihh] = LocH[26, ihh] ELSE NewGridXY[8, ihh] = YP[13, ihh]

; NEED a previous vertical position of fish before the horizontal movemnent
 ; current layer
  LocHV[0, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[0, ihh] EQ NewInput[3, *]), NewXYZloc1)
  LocHV[1, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[1, ihh] EQ NewInput[3, *]), NewXYZloc2)
  LocHV[2, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[2, ihh] EQ NewInput[3, *]), NewXYZloc3)
  LocHV[3, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[3, ihh] EQ NewInput[3, *]), NewXYZloc4)
  LocHV[4, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[4, ihh] EQ NewInput[3, *]), NewXYZloc5)
  LocHV[5, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[5, ihh] EQ NewInput[3, *]), NewXYZloc6)
  LocHV[6, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[6, ihh] EQ NewInput[3, *]), NewXYZloc7)
  LocHV[7, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (NewGridXY[7, ihh] EQ NewInput[3, *]), NewXYZloc8)
  LocHV[8, ihh] = WHERE(((YP[12, ihh]) EQ NewInput[2, *]) AND (YP[13, ihh] EQ NewInput[3, *]), NewXYZloc9)
  ; Vertical movement is restricted within 3 cells below and above the current layer
  ; current layer -3
  IF (YP[12, ihh] LE 17L) THEN BEGIN
  LocHV[9, ihh] = LocHV[0, ihh]+3L; 
  LocHV[10, ihh] = LocHV[1, ihh]+3L; 
  LocHV[11, ihh] = LocHV[2, ihh]+3L; 
  LocHV[12, ihh] = LocHV[3, ihh]+3L; 
  LocHV[13, ihh] = LocHV[4, ihh]+3L; 
  LocHV[14, ihh] = LocHV[5, ihh]+3L; 
  LocHV[15, ihh] = LocHV[6, ihh]+3L; 
  LocHV[16, ihh] = LocHV[7, ihh]+3L; 
  LocHV[17, ihh] = LocHV[8, ihh]+3L; 
  ENDIF ELSE BEGIN
  LocHV[9, ihh] = LocHV[0, ihh]; 
  LocHV[10, ihh] = LocHV[1, ihh]; 
  LocHV[11, ihh] = LocHV[2, ihh]; 
  LocHV[12, ihh] = LocHV[3, ihh]; 
  LocHV[13, ihh] = LocHV[4, ihh]; 
  LocHV[14, ihh] = LocHV[5, ihh]; 
  LocHV[15, ihh] = LocHV[6, ihh]; 
  LocHV[16, ihh] = LocHV[7, ihh]; 
  LocHV[17, ihh] = LocHV[8, ihh];
  ENDELSE
  ; current layer -2
  IF (YP[12, ihh] LE 18L) THEN BEGIN
  LocHV[18, ihh] = LocHV[0, ihh]+2L; 
  LocHV[19, ihh] = LocHV[1, ihh]+2L; 
  LocHV[20, ihh] = LocHV[2, ihh]+2L; 
  LocHV[21, ihh] = LocHV[3, ihh]+2L; 
  LocHV[22, ihh] = LocHV[4, ihh]+2L; 
  LocHV[23, ihh] = LocHV[5, ihh]+2L; 
  LocHV[24, ihh] = LocHV[6, ihh]+2L; 
  LocHV[25, ihh] = LocHV[7, ihh]+2L; 
  LocHV[26, ihh] = LocHV[8, ihh]+2L; 
  ENDIF ELSE BEGIN
  LocHV[18, ihh] = LocHV[0, ihh]; 
  LocHV[19, ihh] = LocHV[1, ihh]; 
  LocHV[20, ihh] = LocHV[2, ihh]; 
  LocHV[21, ihh] = LocHV[3, ihh]; 
  LocHV[22, ihh] = LocHV[4, ihh]; 
  LocHV[23, ihh] = LocHV[5, ihh]; 
  LocHV[24, ihh] = LocHV[6, ihh]; 
  LocHV[25, ihh] = LocHV[7, ihh]; 
  LocHV[26, ihh] = LocHV[8, ihh]; 
  ENDELSE
  ; current layer -1
  IF (YP[12, ihh] LE 19L) THEN BEGIN
  LocHV[27, ihh] = LocHV[0, ihh]+2L; 
  LocHV[28, ihh] = LocHV[1, ihh]+2L; 
  LocHV[29, ihh] = LocHV[2, ihh]+2L; 
  LocHV[30, ihh] = LocHV[3, ihh]+2L; 
  LocHV[31, ihh] = LocHV[4, ihh]+2L; 
  LocHV[32, ihh] = LocHV[5, ihh]+2L; 
  LocHV[33, ihh] = LocHV[6, ihh]+2L; 
  LocHV[34, ihh] = LocHV[7, ihh]+2L; 
  LocHV[35, ihh] = LocHV[8, ihh]+2L; 
ENDIF ELSE BEGIN
  LocHV[27, ihh] = LocHV[0, ihh]; 
  LocHV[28, ihh] = LocHV[1, ihh]; 
  LocHV[29, ihh] = LocHV[2, ihh]; 
  LocHV[30, ihh] = LocHV[3, ihh]; 
  LocHV[31, ihh] = LocHV[4, ihh]; 
  LocHV[32, ihh] = LocHV[5, ihh]; 
  LocHV[33, ihh] = LocHV[6, ihh]; 
  LocHV[34, ihh] = LocHV[7, ihh]; 
  LocHV[35, ihh] = LocHV[8, ihh]
  ENDELSE
  ; current layer +1
  IF (YP[12, ihh] GE 2L) THEN BEGIN
  LocHV[36, ihh] = LocHV[0, ihh]-1L; 
  LocHV[37, ihh] = LocHV[1, ihh]-1L; 
  LocHV[38, ihh] = LocHV[2, ihh]-1L; 
  LocHV[39, ihh] = LocHV[3, ihh]-1L; 
  LocHV[40, ihh] = LocHV[4, ihh]-1L; 
  LocHV[41, ihh] = LocHV[5, ihh]-1L; 
  LocHV[42, ihh] = LocHV[6, ihh]-1L; 
  LocHV[43, ihh] = LocHV[7, ihh]-1L; 
  LocHV[44, ihh] = LocHV[8, ihh]-1L; 
  ENDIF ELSE BEGIN
  LocHV[36, ihh] = LocHV[0, ihh]; 
  LocHV[37, ihh] = LocHV[1, ihh]; 
  LocHV[38, ihh] = LocHV[2, ihh]; 
  LocHV[39, ihh] = LocHV[3, ihh]; 
  LocHV[40, ihh] = LocHV[4, ihh]; 
  LocHV[41, ihh] = LocHV[5, ihh]; 
  LocHV[42, ihh] = LocHV[6, ihh]; 
  LocHV[43, ihh] = LocHV[7, ihh]; 
  LocHV[44, ihh] = LocHV[8, ihh];
  ENDELSE
  ; current layer +2
  IF (YP[12, ihh] GE 3L) THEN BEGIN
  LocHV[45, ihh] = LocHV[0, ihh]-2L; 
  LocHV[46, ihh] = LocHV[1, ihh]-2L; 
  LocHV[47, ihh] = LocHV[2, ihh]-2L; 
  LocHV[48, ihh] = LocHV[3, ihh]-2L; 
  LocHV[49, ihh] = LocHV[4, ihh]-2L; 
  LocHV[50, ihh] = LocHV[5, ihh]-2L; 
  LocHV[51, ihh] = LocHV[6, ihh]-2L; 
  LocHV[52, ihh] = LocHV[7, ihh]-2L; 
  LocHV[53, ihh] = LocHV[8, ihh]-2L; 
  ENDIF ELSE BEGIN
  LocHV[45, ihh] = LocHV[0, ihh]; 
  LocHV[46, ihh] = LocHV[1, ihh]; 
  LocHV[47, ihh] = LocHV[2, ihh]; 
  LocHV[48, ihh] = LocHV[3, ihh]; 
  LocHV[49, ihh] = LocHV[4, ihh]; 
  LocHV[50, ihh] = LocHV[5, ihh]; 
  LocHV[51, ihh] = LocHV[6, ihh]; 
  LocHV[52, ihh] = LocHV[7, ihh]; 
  LocHV[53, ihh] = LocHV[8, ihh];
  ENDELSE
  ; current layer +3
  IF (YP[12, ihh] GE 4L) THEN BEGIN
  LocHV[54, ihh] = LocHV[0, ihh]-3L; 
  LocHV[55, ihh] = LocHV[1, ihh]-3L; 
  LocHV[56, ihh] = LocHV[2, ihh]-3L; 
  LocHV[57, ihh] = LocHV[3, ihh]-3L;
  LocHV[58, ihh] = LocHV[4, ihh]-3L; 
  LocHV[59, ihh] = LocHV[5, ihh]-3L; 
  LocHV[60, ihh] = LocHV[6, ihh]-3L; 
  LocHV[61, ihh] = LocHV[7, ihh]-3L; 
  LocHV[62, ihh] = LocHV[8, ihh]-3L;
  ENDIF ELSE BEGIN
  LocHV[54, ihh] = LocHV[0, ihh]; 
  LocHV[55, ihh] = LocHV[1, ihh]; 
  LocHV[56, ihh] = LocHV[2, ihh]; 
  LocHV[57, ihh] = LocHV[3, ihh]; 
  LocHV[58, ihh] = LocHV[4, ihh]; 
  LocHV[59, ihh] = LocHV[5, ihh]; 
  LocHV[60, ihh] = LocHV[6, ihh]; 
  LocHV[61, ihh] = LocHV[7, ihh]; 
  LocHV[62, ihh] = LocHV[8, ihh]
  ENDELSE
; LocHV[10, ihh] = WHERE((YP[12, ihh] EQ NewInput[2, *]) AND (LocH[0, ihh] EQ NewInput[0, *]) AND (LocH[1, ihh] EQ NewInput[1, *]), NewXYZloc10)
; PRINT, 'LocHV[0, ihh]', LocLocHV[0, ihh], 'LocHV[10, ihh]', LocHV[10, ihh] 
ENDFOR;**************************************************************************************************************************
;PRINT, 'NewInput[3, *]', NewInput[3, *]
;PRINT, 'NewGridXY', NewGridXY
PRINT, 'YP[12, *]', transpose(YP[12, *])
PRINT, 'LocHV[0:8,*]', transpose(LocHV[0:8,*])
PRINT, 'LocHV[9:17,*]', transpose(LocHV[9:17,*])
PRINT, 'LocHV[18:26,*]', transpose(LocHV[18:26,*])
PRINT, 'LocHV[27:35,*]', transpose(LocHV[27:35,*])
PRINT, 'LocHV[36:44,*]', transpose(LocHV[36:44,*])

;CheckVerMov = fltarr(6L, nYP)
;CheckVerMov[0,*]=YP[12, *]
;CheckVerMov[1,*]=LocHV[0:8,*]
;CheckVerMov[2,*]=LocHV[9:17,*]
;CheckVerMov[3,*]=LocHV[18:26,*]
;CheckVerMov[4,*]=LocHV[27:35,*]
;CheckVerMov[5,*]=LocHV[36:44,*]
;PRINT, 'CheckVerMov[0:2,*]', CheckVerMov[0:2,*]
;*****REMOVING FOR-LOOP************************************
;LocH2 = fltarr(4, nyp)
;LocH2[0, *] = Grid2D[2, loch[0,*]]
;LocH2[1, *] = Grid2D[2, [loch[0,*]]]
;LocH2[1, *] 
;print, 'loch2', loch2
;print, 'YP[10:11,*]', YP[10:11,*]
;PRINT, 'GRID2D', transpose(GRID2D[0:1, *])
 ;LocH18 = WHERE((transpose(LocH[0, *]) GE 0), NewXYloc1) 
;Print, 'LocH18', LocH18
;**********************************************************
 
;****Determine habitat quality of neibouring cells******************************************************************************
; ******NEED TO AGGREGATE ZOOPLANKTON AND NO BETHTTREPHE*******
EnvironHV = FLTARR(124L, nYP)
; Environmental conditions in 1
;EnvironHV[0:2, *] = newinput[5:7, LocHV[0, *]]; zoopl
;EnvironHV[3, *] = newinput[8, LocHV[0, *]]; bentho
;EnvironHV[4, *] = newinput[9, LocHV[0, *]]; amb temp 
;EnvironHV[5, *] = newinput[10, LocHV[0, *]]; ambDO
;EnvironHV[6, *] = 0.0; Bethotrephe
;EnvironHV[7, *] = 0.0; fish
;EnvironHV[0:5, *] = newinput[5:10, LocHV[0, *]]; all
;PRINT, 'EnvironHV[0:5, *]', EnvironHV[0:5, *]

; Environmental conditions in (2)
EnvironHV[8:10, *] = newinput[5:7, LocHV[1, *]]; zoopl
EnvironHV[11, *] = newinput[8, LocHV[1, *]]; bentho
EnvironHV[12, *] = newinput[9, LocHV[1, *]]; amb temp 
EnvironHV[13, *] = newinput[10, LocHV[1, *]]; ambDO
EnvironHV[14, *] = 0.0; Bethotrephe
EnvironHV[15, *] = 0.0; fish
EnvironHV[8:13, *] = newinput[5:10, LocHV[1, *]]; all
;PRINT, 'EnvironHV[8:13, *]', EnvironHV[8:13, *] 

; Environmental conditions in 3
;EnvironHV[14:16, *] = newinput[5:7, LocHV[2, *]]; zoopl
;EnvironHV[17, *] = newinput[8, LocHV[2, *]]; bentho
;EnvironHV[18, *] = newinput[9, LocHV[2, *]]; amb temp 
;EnvironHV[19, *] = newinput[10, LocHV[2, *]]; ambDO
;EnvironHV[20, *] = 0.0; Bethotrephe
;EnvironHV[21, *] = 0.0; fish
;EnvironHV[14:19, *] = newinput[5:10, LocHV[2, *]]; all
;PRINT, 'EnvironHV[14:19, *]', EnvironHV[14:19, *] 

; Environmental conditions in (4)
EnvironHV[22:24, *] = newinput[5:7, LocHV[3, *]]; zoopl
EnvironHV[25, *] = newinput[8, LocHV[3, *]]; bentho
EnvironHV[26, *] = newinput[9, LocHV[3, *]]; amb temp 
EnvironHV[27, *] = newinput[10, LocHV[3, *]]; ambDO
EnvironHV[28, *] = 0.0; Bethotrephe
EnvironHV[29, *] = 0.0; fish
EnvironHV[22:27, *] = newinput[5:10, LocHV[3, *]]; all
;PRINT, 'EnvironHV[22:27, *]', EnvironHV[22:27, *]

; Environmental conditions in (5)
EnvironHV[30:32, *] = newinput[5:7, LocHV[4, *]]; zoopl
EnvironHV[33, *] = newinput[8, LocHV[4, *]]; bentho
EnvironHV[34, *] = newinput[9, LocHV[4, *]]; amb temp 
EnvironHV[35, *] = newinput[10, LocHV[4, *]]; ambDO
EnvironHV[36, *] = 0.0; Bethotrephe
EnvironHV[37, *] = 0.0; fish
EnvironHV[30:35, *] = newinput[5:10, LocHV[4, *]]; all
;PRINT, 'EnvironHV[30:35, *]', EnvironHV[30:35, *]

; Environmental conditions in 6
;EnvironHV[38:40, *] = newinput[5:7, LocHV[5, *]]; zoopl
;EnvironHV[41, *] = newinput[8, LocHV[5, *]]; bentho
;EnvironHV[42, *] = newinput[9, LocHV[5, *]]; amb temp 
;EnvironHV[43, *] = newinput[10, LocHV[5, *]]; ambDO
;EnvironHV[44, *] = 0.0; Bethotrephe
;EnvironHV[45, *] = 0.0; fish
;EnvironHV[38:43, *] = newinput[5:10, LocHV[5, *]]; all
;PRINT, 'EnvironHV[38:43, *]', EnvironHV[38:43, *] 

; Environmental conditions in (7)
EnvironHV[46:48, *] = newinput[5:7, LocHV[6, *]]; zoopl
EnvironHV[49, *] = newinput[8, LocHV[6, *]]; bentho
EnvironHV[50, *] = newinput[9, LocHV[6, *]]; amb temp 
EnvironHV[51, *] = newinput[10, LocHV[6, *]]; ambDO
EnvironHV[52, *] = 0.0; Bethotrephe
EnvironHV[53, *] = 0.0; fish
EnvironHV[46:51, *] = newinput[5:10, LocHV[6, *]]; all
;PRINT, 'EnvironHV[46:51, *]', EnvironHV[46:51, *]

; Environmental conditions in 8
;EnvironHV[54:56, *] = newinput[5:7, LocHV[7, *]]; zoopl
;EnvironHV[57, *] = newinput[8, LocHV[7, *]]; bentho
;EnvironHV[58, *] = newinput[9, LocHV[7, *]]; amb temp 
;EnvironHV[59, *] = newinput[10, LocHV[7, *]]; ambDO
;EnvironHV[60, *] = 0.0; Bethotrephe
;EnvironHV[61, *] = 0.0; fish
;EnvironHV[54:59, *] = newinput[5:10, LocHV[7, *]]; all
;PRINT, 'EnvironHV[54:59, *]', EnvironHV[54:59, *] 

; Environmental conditions in (X) = the current cell
EnvironHV[62:64, *] = newinput[5:7, LocHV[8, *]]; zoopl
EnvironHV[65, *] = newinput[8, LocHV[8, *]]; bentho
EnvironHV[66, *] = newinput[9, LocHV[8, *]]; amb temp 
EnvironHV[67, *] = newinput[10, LocHV[8, *]]; ambDO
EnvironHV[68, *] = 0.0; Bethotrephe
EnvironHV[69, *] = 0.0; fish
EnvironHV[62:67, *] = newinput[5:10, LocHV[8, *]]; all
;PRINT, 'EnvironHV[54:59, *]', EnvironHV[54:59, *] 

;EnvironHV[68, *] = newinput[3, LocHV[0, *]]; 2DID
EnvironHV[69, *] = newinput[3, LocHV[1, *]]; 2DID
;EnvironHV[70, *] = newinput[3, LocHV[2, *]]; 2DID
EnvironHV[71, *] = newinput[3, LocHV[3, *]]; 2DID
EnvironHV[72, *] = newinput[3, LocHV[4, *]]; 2DID
;EnvironHV[73, *] = newinput[3, LocHV[5, *]]; 2DID
EnvironHV[74, *] = newinput[3, LocHV[6, *]]; 2DID
;EnvironHV[75, *] = newinput[3, LocHV[7, *]]; 2DID
EnvironHV[76, *] = newinput[3, LocHV[8, *]]; 2DID



; Environmental conditions for potential vertical movement
;LocHV# for vertical movement = 17, 26, 35, 44, 53, 62
; -3
EnvironHV[77:82, *] = newinput[5:10, LocHV[17, *]];
EnvironHV[83, *] = 0.0; Bethotrephe
EnvironHV[84, *] = 0.0; fish
; -2
EnvironHV[85:90, *] = newinput[5:10, LocHV[26, *]];
EnvironHV[91, *] = 0.0; Bethotrephe
EnvironHV[92, *] = 0.0; fish
; -1
EnvironHV[92:97, *] = newinput[5:10, LocHV[35, *]];
EnvironHV[98, *] = 0.0; Bethotrephe
EnvironHV[99, *] = 0.0; fish
; +1
EnvironHV[100:105, *] = newinput[5:10, LocHV[44, *]];
EnvironHV[106, *] = 0.0; Bethotrephe
EnvironHV[107, *] = 0.0; fish
; +2
EnvironHV[108:113, *] = newinput[5:10, LocHV[53, *]];
EnvironHV[114, *] = 0.0; Bethotrephe
EnvironHV[115, *] = 0.0; fish
; +3
EnvironHV[116:121, *] = newinput[5:10, LocHV[62, *]];
EnvironHV[122, *] = 0.0; Bethotrephe
EnvironHV[123, *] = 0.0; fish

; Assess habitat quality of neibouring cells
DOf1 = FLTARR(9+6, nYP)
DOf2 = FLTARR(9+6, nYP)
DOf3 = FLTARR(9+6, nYP)
DOf = FLTARR(9+6, nYP)
Tf = FLTARR(9+6, nYP)
;DO
FOR ihe = 0L, nYP - 1L DO BEGIN
;DOacclim[14,*] = DOacC1; from acclDO, array locations of individuals who are in cells with DOaccl < DOcrit&minDOcrit
;DOacclim[15,*] = DOacC2; from acclDO, array locations of individuals who are in cells with minDOcrit < DOaccl < DOcrit
;DOacclim[16,*] = DOacC3; from acclDO, locations of individuals who are in cells with DOaccl > DOcrit
; WHEN ambient DO is below the critical DO...
  ;DOf1[0, ihe] = WHERE(EnvironHV[5, ihe] LT DOacclim[7, ihe], DOf1count1)
  DOf1[1, ihe] = WHERE(EnvironHV[13, ihe] LT DOacclim[7, ihe], DOf1count2)
  ;DOf1[2, ihe] = WHERE(EnvironHV[19, ihe] LT DOacclim[7, ihe], DOf1count3)
  DOf1[3, ihe] = WHERE(EnvironHV[27, ihe] LT DOacclim[7, ihe], DOf1count4)
  DOf1[4, ihe] = WHERE(EnvironHV[35, ihe] LT DOacclim[7, ihe], DOf1count5)
  ;DOf1[5, ihe] = WHERE(EnvironHV[43, ihe] LT DOacclim[7, ihe], DOf1count6)
  DOf1[6, ihe] = WHERE(EnvironHV[51, ihe] LT DOacclim[7, ihe], DOf1count7)
  ;DOf1[7, ihe] = WHERE(EnvironHV[59, ihe] LT DOacclim[7, ihe], DOf1count8)
  DOf1[8, ihe] = WHERE(EnvironHV[67, ihe] LT DOacclim[7, ihe], DOf1count9)
  
  DOf1[9, ihe] = WHERE(EnvironHV[82, ihe] LT DOacclim[7, ihe], DOf1count10)
  DOf1[10, ihe] = WHERE(EnvironHV[90, ihe] LT DOacclim[7, ihe], DOf1count11)
  DOf1[11, ihe] = WHERE(EnvironHV[97, ihe] LT DOacclim[7, ihe], DOf1count12)
  DOf1[12, ihe] = WHERE(EnvironHV[105, ihe] LT DOacclim[7, ihe], DOf1count13)
  DOf1[13, ihe] = WHERE(EnvironHV[113, ihe] LT DOacclim[7, ihe], DOf1count14)
  DOf1[14, ihe] = WHERE(EnvironHV[121, ihe] LT DOacclim[7, ihe], DOf1count15)
  
  ;IF DOf1count1 GT 0.0 THEN DOf[0, ihe] = 0.0; 
  IF DOf1count2 GT 0.0 THEN DOf[1, ihe] = 0.0
  ;IF DOf1count3 GT 0.0 THEN DOf[2, ihe] = 0.0;
  IF DOf1count4 GT 0.0 THEN DOf[3, ihe] = 0.0;
  IF DOf1count5 GT 0.0 THEN DOf[4, ihe] = 0.0;
  ;IF DOf1count6 GT 0.0 THEN DOf[5, ihe] = 0.0;  
  IF DOf1count7 GT 0.0 THEN DOf[6, ihe] = 0.0;  
  ;IF DOf1count8 GT 0.0 THEN DOf[7, ihe] = 0.0; 
  IF DOf1count9 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  
  IF DOf1count10 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  IF DOf1count11 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  IF DOf1count12 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  IF DOf1count13 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  IF DOf1count14 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  IF DOf1count15 GT 0.0 THEN DOf[8, ihe] = 0.0; 

; WHEN ambient DO is between the minimum critical DO and the critical DO...
  ;DOf2[0, ihe] = WHERE(EnvironHV[5, ihe] GE DOacclim[7, ihe] AND EnvironHV[5, ihe] LE DOacclim[5, ihe], DOf2count1)
  DOf2[1, ihe] = WHERE(EnvironHV[13, ihe] GE DOacclim[7, ihe] AND EnvironHV[13, ihe] LE DOacclim[5, ihe], DOf2count2)
  ;DOf2[2, ihe] = WHERE(EnvironHV[19, ihe] GE DOacclim[7, ihe] AND EnvironHV[19, ihe] LE DOacclim[5, ihe], DOf2count3)
  DOf2[3, ihe] = WHERE(EnvironHV[27, ihe] GE DOacclim[7, ihe] AND EnvironHV[27, ihe] LE DOacclim[5, ihe], DOf2count4)
  DOf2[4, ihe] = WHERE(EnvironHV[35, ihe] GE DOacclim[7, ihe] AND EnvironHV[35, ihe] LE DOacclim[5, ihe], DOf2count5)
  ;DOf2[5, ihe] = WHERE(EnvironHV[43, ihe] GE DOacclim[7, ihe] AND EnvironHV[43, ihe] LE DOacclim[5, ihe], DOf2count6)
  DOf2[6, ihe] = WHERE(EnvironHV[51, ihe] GE DOacclim[7, ihe] AND EnvironHV[51, ihe] LE DOacclim[5, ihe], DOf2count7)
  ;DOf2[7, ihe] = WHERE(EnvironHV[59, ihe] GE DOacclim[7, ihe] AND EnvironHV[59, ihe] LE DOacclim[5, ihe], DOf2count8)
  DOf2[8, ihe] = WHERE(EnvironHV[67, ihe] GE DOacclim[7, ihe] AND EnvironHV[67, ihe] LE DOacclim[5, ihe], DOf2count9)

  DOf2[9, ihe] = WHERE(EnvironHV[82, ihe] GE DOacclim[7, ihe] AND EnvironHV[82, ihe] LE DOacclim[5, ihe], DOf2count10)  
  DOf2[10, ihe] = WHERE(EnvironHV[90, ihe] GE DOacclim[7, ihe] AND EnvironHV[90, ihe] LE DOacclim[5, ihe], DOf2count11)
  DOf2[11, ihe] = WHERE(EnvironHV[97, ihe] GE DOacclim[7, ihe] AND EnvironHV[97, ihe] LE DOacclim[5, ihe], DOf2count12)
  DOf2[12, ihe] = WHERE(EnvironHV[105, ihe] GE DOacclim[7, ihe] AND EnvironHV[105, ihe] LE DOacclim[5, ihe], DOf2count13)
  DOf2[13, ihe] = WHERE(EnvironHV[113, ihe] GE DOacclim[7, ihe] AND EnvironHV[113, ihe] LE DOacclim[5, ihe], DOf2count14)
  DOf2[14, ihe] = WHERE(EnvironHV[121, ihe] GE DOacclim[7, ihe] AND EnvironHV[121, ihe] LE DOacclim[5, ihe], DOf2count15)
  
  ;IF DOf2count1 GT 0.0 THEN DOf[0, ihe] = ((EnvironHV[5, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count2 GT 0.0 THEN DOf[1, ihe] = ((EnvironHV[13, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count3 GT 0.0 THEN DOf[2, ihe] = ((EnvironHV[19, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count4 GT 0.0 THEN DOf[3, ihe] = ((EnvironHV[27, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count5 GT 0.0 THEN DOf[4, ihe] = ((EnvironHV[35, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count6 GT 0.0 THEN DOf[5, ihe] = ((EnvironHV[43, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count7 GT 0.0 THEN DOf[6, ihe] = ((EnvironHV[51, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count8 GT 0.0 THEN DOf[7, ihe] = ((EnvironHV[59, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count9 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[67, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  
  IF DOf2count10 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[82, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count11 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[90, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count12 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[97, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count13 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[105, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count14 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[113, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count15 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[121, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  
; WHEN ambient DO is below the mimimum critical DO...
  ;DOf3[0, ihe] = WHERE(EnvironHV[5, ihe] GT DOacclim[5, ihe], DOf3count1)
  DOf3[1, ihe] = WHERE(EnvironHV[13, ihe] GT DOacclim[5, ihe], DOf3count2)
  ;DOf3[2, ihe] = WHERE(EnvironHV[19, ihe] GT DOacclim[5, ihe], DOf3count3)
  DOf3[3, ihe] = WHERE(EnvironHV[27, ihe] GT DOacclim[5, ihe], DOf3count4)
  DOf3[4, ihe] = WHERE(EnvironHV[35, ihe] GT DOacclim[5, ihe], DOf3count5)
  ;DOf3[5, ihe] = WHERE(EnvironHV[43, ihe] GT DOacclim[5, ihe], DOf3count6)
  DOf3[6, ihe] = WHERE(EnvironHV[51, ihe] GT DOacclim[5, ihe], DOf3count7)
  ;DOf3[7, ihe] = WHERE(EnvironHV[59, ihe] GT DOacclim[5, ihe], DOf3count8)
  DOf3[8, ihe] = WHERE(EnvironHV[67, ihe] GT DOacclim[5, ihe], DOf3count9)
  DOf3[9, ihe] = WHERE(EnvironHV[82, ihe] GT DOacclim[5, ihe], DOf3count10)
  DOf3[10, ihe] = WHERE(EnvironHV[90, ihe] GT DOacclim[5, ihe], DOf3count11)
  DOf3[11, ihe] = WHERE(EnvironHV[97, ihe] GT DOacclim[5, ihe], DOf3count12)
  DOf3[12, ihe] = WHERE(EnvironHV[105, ihe] GT DOacclim[5, ihe], DOf3count13)
  DOf3[13, ihe] = WHERE(EnvironHV[113, ihe] GT DOacclim[5, ihe], DOf3count14)
  DOf3[14, ihe] = WHERE(EnvironHV[121, ihe] GT DOacclim[5, ihe], DOf3count15)
  
  ;IF DOf3count1 GT 0.0 THEN DOf[0, ihe] = 1.0
  IF DOf3count2 GT 0.0 THEN DOf[1, ihe] = 1.0
  ;IF DOf3count3 GT 0.0 THEN DOf[2, ihe] = 1.0
  IF DOf3count4 GT 0.0 THEN DOf[3, ihe] = 1.0
  IF DOf3count5 GT 0.0 THEN DOf[4, ihe] = 1.0
  ;IF DOf3count6 GT 0.0 THEN DOf[5, ihe] = 1.0
  IF DOf3count7 GT 0.0 THEN DOf[6, ihe] = 1.0
  ;IF DOf3count8 GT 0.0 THEN DOf[7, ihe] = 1.0
  IF DOf3count9 GT 0.0 THEN DOf[8, ihe] = 1.0
IF DOf3count10 GT 0.0 THEN DOf[9, ihe] = 1.0
IF DOf3count11 GT 0.0 THEN DOf[10, ihe] = 1.0
IF DOf3count12 GT 0.0 THEN DOf[11, ihe] = 1.0
IF DOf3count13 GT 0.0 THEN DOf[12, ihe] = 1.0
IF DOf3count14 GT 0.0 THEN DOf[13, ihe] = 1.0
IF DOf3count15 GT 0.0 THEN DOf[14, ihe] = 1.0
ENDFOR

  ; temperature
  CTO = 19L; Optimal temperture for consumption
  CTM = 32L;  Maximum temperture for consumption
  ;Tf1 = WHERE(EnvironHV[4, *] GE CTM, Tfcount1)
  Tf2 = WHERE(EnvironHV[12, *] GE CTM, Tfcount2)
  ;Tf3 = WHERE(EnvironHV[18, *] GE CTM, Tfcount3)
  Tf4 = WHERE(EnvironHV[26, *] GE CTM, Tfcount4)
  Tf5 = WHERE(EnvironHV[34, *] GE CTM, Tfcount5)
  ;Tf6 = WHERE(EnvironHV[42, *] GE CTM, Tfcount6)
  Tf7 = WHERE(EnvironHV[50, *] GE CTM, Tfcount7)
  ;Tf8 = WHERE(EnvironHV[58, *] GE CTM, Tfcount8)
  Tf9 = WHERE(EnvironHV[66, *] GE CTM, Tfcount9)
  
  Tf10 = WHERE(EnvironHV[81, *] GE CTM, Tfcount10)
  Tf11 = WHERE(EnvironHV[89, *] GE CTM, Tfcount11)
  Tf12 = WHERE(EnvironHV[96, *] GE CTM, Tfcount12)
  Tf13 = WHERE(EnvironHV[104, *] GE CTM, Tfcount13)
  Tf14 = WHERE(EnvironHV[112, *] GE CTM, Tfcount14)
  Tf15 = WHERE(EnvironHV[120, *] GE CTM, Tfcount15)
  
  ;IF Tfcount1 GT 0.0 THEN Tf[0, Tf1] = 0.0
  IF Tfcount2 GT 0.0 THEN Tf[1, Tf2] = 0.0
  ;IF Tfcount3 GT 0.0 THEN Tf[2, Tf3] = 0.0
  IF Tfcount4 GT 0.0 THEN Tf[3, Tf4] = 0.0
  IF Tfcount5 GT 0.0 THEN Tf[4, Tf5] = 0.0
  ;IF Tfcount6 GT 0.0 THEN Tf[5, Tf6] = 0.0
  IF Tfcount7 GT 0.0 THEN Tf[6, Tf7] = 0.0
  ;IF Tfcount8 GT 0.0 THEN Tf[7, Tf8] = 0.0
  IF Tfcount9 GT 0.0 THEN Tf[8, Tf9] = 0.0
  IF Tfcount10 GT 0.0 THEN Tf[8, Tf10] = 0.0
  IF Tfcount11 GT 0.0 THEN Tf[8, Tf11] = 0.0
  IF Tfcount12 GT 0.0 THEN Tf[8, Tf12] = 0.0
  IF Tfcount13 GT 0.0 THEN Tf[8, Tf13] = 0.0
  IF Tfcount14 GT 0.0 THEN Tf[8, Tf14] = 0.0
  IF Tfcount15 GT 0.0 THEN Tf[8, Tf15] = 0.0
  
  ;Tf1b = WHERE((EnvironHV[4, *] GT CTO) AND (EnvironHV[4, *] LT CTM), Tfcount1b)
  Tf2b = WHERE((EnvironHV[12, *] GT CTO) AND (EnvironHV[12, *] LT CTM), Tfcount2b)
  ;Tf3b = WHERE((EnvironHV[18, *] GT CTO) AND (EnvironHV[18, *] LT CTM), Tfcount3b)
  Tf4b = WHERE((EnvironHV[26, *] GT CTO) AND (EnvironHV[26, *] LT CTM), Tfcount4b)
  Tf5b = WHERE((EnvironHV[34, *] GT CTO) AND (EnvironHV[34, *] LT CTM), Tfcount5b)
  ;Tf6b = WHERE((EnvironHV[42, *] GT CTO) AND (EnvironHV[42, *] LT CTM), Tfcount6b)
  Tf7b = WHERE((EnvironHV[50, *] GT CTO) AND (EnvironHV[50, *] LT CTM), Tfcount7b)
  ;Tf8b = WHERE((EnvironHV[58, *] GT CTO) AND (EnvironHV[58, *] LT CTM), Tfcount8b)
  Tf9b = WHERE((EnvironHV[66, *] GT CTO) AND (EnvironHV[66, *] LT CTM), Tfcount9b)
  Tf10b = WHERE((EnvironHV[81, *] GT CTO) AND (EnvironHV[81, *] LT CTM), Tfcount10b)
  Tf11b = WHERE((EnvironHV[89, *] GT CTO) AND (EnvironHV[89, *] LT CTM), Tfcount11b)
  Tf12b = WHERE((EnvironHV[96, *] GT CTO) AND (EnvironHV[96, *] LT CTM), Tfcount12b)
  Tf13b = WHERE((EnvironHV[104, *] GT CTO) AND (EnvironHV[104, *] LT CTM), Tfcount13b)
  Tf14b = WHERE((EnvironHV[112, *] GT CTO) AND (EnvironHV[112, *] LT CTM), Tfcount14b)
  Tf15b = WHERE((EnvironHV[120, *] GT CTO) AND (EnvironHV[120, *] LT CTM), Tfcount15b)
   
  ;IF Tfcount1b GT 0.0 THEN Tf[0, Tf1b] = ((CTM - EnvironHV[4,  Tf1b])/(CTM - CTO))
  IF Tfcount2b GT 0.0 THEN Tf[1, Tf2b] = ((CTM - EnvironHV[12, Tf2b])/(CTM - CTO))
  ;IF Tfcount3b GT 0.0 THEN Tf[2, Tf3b] = ((CTM - EnvironHV[18, Tf3b])/(CTM - CTO))
  IF Tfcount4b GT 0.0 THEN Tf[3, Tf4b] = ((CTM - EnvironHV[26, Tf4b])/(CTM - CTO))
  IF Tfcount5b GT 0.0 THEN Tf[4, Tf5b] = ((CTM - EnvironHV[34, Tf5b])/(CTM - CTO))
  ;IF Tfcount6b GT 0.0 THEN Tf[5, Tf6b] = ((CTM - EnvironHV[42, Tf6b])/(CTM - CTO))
  IF Tfcount7b GT 0.0 THEN Tf[6, Tf7b] = ((CTM - EnvironHV[50, Tf7b])/(CTM - CTO))
  ;IF Tfcount8b GT 0.0 THEN Tf[7, Tf8b] = ((CTM - EnvironHV[58, Tf8b])/(CTM - CTO))
  IF Tfcount9b GT 0.0 THEN Tf[8, Tf9b] = ((CTM - EnvironHV[66, Tf9b])/(CTM - CTO))

IF Tfcount10b GT 0.0 THEN Tf[9, Tf10b] = ((CTM - EnvironHV[81, Tf10b])/(CTM - CTO))
IF Tfcount11b GT 0.0 THEN Tf[10, Tf11b] = ((CTM - EnvironHV[89, Tf11b])/(CTM - CTO))
IF Tfcount12b GT 0.0 THEN Tf[11, Tf12b] = ((CTM - EnvironHV[96, Tf12b])/(CTM - CTO))
IF Tfcount13b GT 0.0 THEN Tf[12, Tf13b] = ((CTM - EnvironHV[104, Tf13b])/(CTM - CTO))
IF Tfcount14b GT 0.0 THEN Tf[13, Tf14b] = ((CTM - EnvironHV[112, Tf14b])/(CTM - CTO))
IF Tfcount15b GT 0.0 THEN Tf[14, Tf15b] = ((CTM - EnvironHV[120, Tf15b])/(CTM - CTO))

  ;Tf1c = WHERE(EnvironHV[4, *] LE CTO, Tfcount1c)
  Tf2c = WHERE(EnvironHV[12, *] LE CTO, Tfcount2c)
  ;Tf3c = WHERE(EnvironHV[18, *] LE CTO, Tfcount3c)
  Tf4c = WHERE(EnvironHV[26, *] LE CTO, Tfcount4c)
  Tf5c = WHERE(EnvironHV[34, *] LE CTO, Tfcount5c)
  ;Tf6c = WHERE(EnvironHV[42, *] LE CTO, Tfcount6c)
  Tf7c = WHERE(EnvironHV[50, *] LE CTO, Tfcount7c)
  ;Tf8c = WHERE(EnvironHV[58, *] LE CTO, Tfcount8c)
  Tf9c = WHERE(EnvironHV[66, *] LE CTO, Tfcount9c)
  
  Tf10c = WHERE(EnvironHV[81, *] LE CTO, Tfcount10c)
  Tf11c = WHERE(EnvironHV[89, *] LE CTO, Tfcount11c) 
  Tf12c = WHERE(EnvironHV[96, *] LE CTO, Tfcount12c)
  Tf13c = WHERE(EnvironHV[104, *] LE CTO, Tfcount13c)
  Tf14c = WHERE(EnvironHV[112, *] LE CTO, Tfcount14c)
  Tf15c = WHERE(EnvironHV[120, *] LE CTO, Tfcount15c)
  
  ;IF Tfcount1c GT 0.0 THEN Tf[0, Tf1c] = 1.0 
  IF Tfcount2c GT 0.0 THEN Tf[1, Tf2c] = 1.0  
  ;IF Tfcount3c GT 0.0 THEN Tf[2, Tf3c] = 1.0  
  IF Tfcount4c GT 0.0 THEN Tf[3, Tf4c] = 1.0  
  IF Tfcount5c GT 0.0 THEN Tf[4, Tf5c] = 1.0  
  ;IF Tfcount6c GT 0.0 THEN Tf[5, Tf6c] = 1.0  
  IF Tfcount7c GT 0.0 THEN Tf[6, Tf7c] = 1.0  
  ;IF Tfcount8c GT 0.0 THEN Tf[7, Tf8c] = 1.0  
  IF Tfcount9c GT 0.0 THEN Tf[8, Tf9c] = 1.0  
  IF Tfcount10c GT 0.0 THEN Tf[9, Tf10c] = 1.0 
  IF Tfcount11c GT 0.0 THEN Tf[10, Tf11c] = 1.0 
  IF Tfcount12c GT 0.0 THEN Tf[11, Tf12c] = 1.0 
  IF Tfcount13c GT 0.0 THEN Tf[12, Tf13c] = 1.0 
  IF Tfcount14c GT 0.0 THEN Tf[13, Tf14c] = 1.0 
  IF Tfcount15c GT 0.0 THEN Tf[14, Tf15c] = 1.0 

EnvironHVDO = FLTARR(15, nYP)
EnvironHVT = FLTARR(15, nYP)
;EnvironHVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVDO[7, *] = DOUBLE(DOf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[8, *] = DOUBLE(DOf[8, *] * RANDOMU(seed, nYP, /DOUBLE))

EnvironHVDO[9, *] = DOUBLE(DOf[9, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[10, *] = DOUBLE(DOf[10, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[11, *] = DOUBLE(DOf[11, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[12, *] = DOUBLE(DOf[12, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[13, *] = DOUBLE(DOf[13, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[14, *] = DOUBLE(DOf[14, *] * RANDOMU(seed, nYP, /DOUBLE))
;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component

;EnvironHVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nYP, /DOUBLE))
;EnvironHVT[7, *] = DOUBLE(Tf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[8, *] = DOUBLE(Tf[8, *] * RANDOMU(seed, nYP, /DOUBLE))

EnvironHVT[9, *] = DOUBLE(Tf[9, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[10, *] = DOUBLE(Tf[10, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[11, *] = DOUBLE(Tf[11, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[12, *] = DOUBLE(Tf[12, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[13, *] = DOUBLE(Tf[13, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[14, *] = DOUBLE(Tf[14, *] * RANDOMU(seed, nYP, /DOUBLE))

;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component
;PRINT, 'EnvironHVDO'
;PRINT, EnvironHVDO
;PRINT, 'EnvironHVT'
;PRINT, EnvironHVT

;EnvironVSum = FLTARR(8, nYP)
;EnvironVSum[0, *] = DOUBLE((EnvironHVDO[0, *] * EnvironHVT[0, *])^(1.0/2.0))
;EnvironVSum[1, *] = DOUBLE((EnvironHVDO[1, *] * EnvironHVT[1, *])^(1.0/2.0))
;EnvironVSum[2, *] = DOUBLE((EnvironHVDO[2, *] * EnvironHVT[2, *])^(1.0/2.0))
;EnvironVSum[3, *] = DOUBLE((EnvironHVDO[3, *] * EnvironHVT[3, *])^(1.0/2.0))
;EnvironVSum[4, *] = DOUBLE((EnvironHVDO[4, *] * EnvironHVT[4, *])^(1.0/2.0))
;EnvironVSum[5, *] = DOUBLE((EnvironHVDO[5, *] * EnvironHVT[5, *])^(1.0/2.0))
;EnvironVSum[6, *] = DOUBLE((EnvironHVDO[6, *] * EnvironHVT[6, *])^(1.0/2.0))
;EnvironVSum[7, *] = DOUBLE((EnvironHVDO[7, *] * EnvironHVT[7, *])^(1.0/2.0))
;EnvironVSum[1, *] = (EnvironV8 * EnvironV9 * EnvironV10)
;EnvironVSum[2, *] = EnvironV8; DO index
;EnvironVSum[3, *] = EnvironV9; TEMP index
;EnvironVSum[4, *] = EnvironV10; prey index
;EnvironVSum[5, *] = NewInput[10, NewGridID3D2]; ambient DO
;PRINT, 'EnvironVSum', EnvironVSum; Temp&DO-based habitat index with a random component


; determines a prey length for each prey type (m) in the model
  ;prey length 
  m = 6L
  PL = FLTARR(m)
  PL[0] = 0.2; length for microzooplankton, rotifer in mm from Letcher et al. 2006
  PL[1] = 0.83; length for mid-sized zooplankton, copepod in mm from Letcher et al. 2006 
  PL[2] = 1.2; length for large-bodied zooplankton, cladocerans in mm (1.0 - 1.5) 
  PL[3] = 2.0; length for chironmoid in mm MADE UP!!! -> Benthos
  PL[4] = 3.2; length for bythotrephes in mm  -> Zooplankton
  PL[5] = 6.5; length for fish in mm 
  ;PRINT, 'PL =', PL
  ; prey weight
  PW = FLTARR(m); weight of each prey type
  ; assign weights to each prey type in g
  Pw[0] = 0.182 / 1000000.0; rotifers in g from Letcher 
  Pw[1] = 4.988 / 1000000.0; copepods in g from Letcher
  Pw[2] = 4.988 / 1000000.0; cladocerans in g MADE UP!!!
  Pw[3] = 0.001; chironomids in g MADE UP!!!!
  Pw[4] = 0.001; 60 / 1000000; bythotrephes in g, 500 to 700,~600ug dry = 6000 ug wet
  Pw[5] = 0.003; 42.9 / 1000000; fish in g MADE UP!!!
  ;PRINT, 'PW =', pw
  
  ; convert prey biomass (g/L or m^2) into numbers/L or m^2
  dens = fltarr(m*(9+6), nYP)
  ; microzooplankton
  ;dens[0,*] = EnvironHV[0, *] / Pw[0]
  dens[1,*] = EnvironHV[8, *] / Pw[0]
  ;dens[2,*] = EnvironHV[14, *] / Pw[0]
  dens[3,*] = EnvironHV[22, *] / Pw[0]
  dens[4,*] = EnvironHV[30, *] / Pw[0]
  ;dens[5,*] = EnvironHV[38, *] / Pw[0]
  dens[6,*] = EnvironHV[46, *] / Pw[0]
  ;dens[7,*] = EnvironHV[54, *] / Pw[0]
  dens[8,*] = EnvironHV[62, *] / Pw[0]
  
  dens[54,*] = EnvironHV[77, *] / Pw[0]
  dens[55,*] = EnvironHV[85, *] / Pw[0]
  dens[56,*] = EnvironHV[92, *] / Pw[0]
  dens[57,*] = EnvironHV[100, *] / Pw[0]
  dens[58,*] = EnvironHV[108, *] / Pw[0]
  dens[59,*] = EnvironHV[116, *] / Pw[0]
  
  ; small mesozooplankton
  ;dens[9,*] = EnvironHV[1, *] / Pw[1]
  dens[10,*] = EnvironHV[9, *] / Pw[1]
  ;dens[11,*] = EnvironHV[15, *] / Pw[1]
  dens[12,*] = EnvironHV[23, *] / Pw[1]
  dens[13,*] = EnvironHV[31, *] / Pw[1]
  ;dens[14,*] = EnvironHV[39, *] / Pw[1]
  dens[15,*] = EnvironHV[47, *] / Pw[1]
  ;dens[16,*] = EnvironHV[55, *] / Pw[1]
  dens[17,*] = EnvironHV[63, *] / Pw[1]
  
  dens[60,*] = EnvironHV[78, *] / Pw[1]
  dens[61,*] = EnvironHV[86, *] / Pw[1]
  dens[62,*] = EnvironHV[93, *] / Pw[1]
  dens[63,*] = EnvironHV[101, *] / Pw[1]
  dens[64,*] = EnvironHV[109, *] / Pw[1]
  dens[65,*] = EnvironHV[117, *] / Pw[1]
  
  ; large mesozooplankton
  ;dens[18,*] = EnvironHV[2, *] / Pw[2]
  dens[19,*] = EnvironHV[10, *] / Pw[2]
  ;dens[20,*] = EnvironHV[16, *] / Pw[2]
  dens[21,*] = EnvironHV[24, *] / Pw[2]
  dens[22,*] = EnvironHV[32, *] / Pw[2]
  ;dens[23,*] = EnvironHV[40, *] / Pw[2]
  dens[24,*] = EnvironHV[48, *] / Pw[2]
  ;dens[25,*] = EnvironHV[56, *] / Pw[2]
  dens[26,*] = EnvironHV[64, *] / Pw[2]
  
  dens[66,*] = EnvironHV[79, *] / Pw[2]
  dens[67,*] = EnvironHV[87, *] / Pw[2]
  dens[68,*] = EnvironHV[94, *] / Pw[2]
  dens[69,*] = EnvironHV[102, *] / Pw[2]
  dens[70,*] = EnvironHV[110, *] / Pw[2]
  dens[71,*] = EnvironHV[118, *] / Pw[2]
  
  ; numbers/m^2 for benthos (chironmoids)
  ;pbio3a = WHERE(EnvironHV[3, *] GT 0.0, pbio3acount, complement = pbio3ac, ncomplement = pbio3account)
  ;IF pbio3acount GT 0.0 THEN dens[27, pbio3a] = EnvironHV[3, pbio3a] / Pw[3] ELSE dens[27, pbio3ac] = 0.0
  pbio3b = WHERE(EnvironHV[11, *] GT 0.0, pbio3bcount, complement = pbio3bc, ncomplement = pbio3bccount)
  IF pbio3bcount GT 0.0 THEN dens[28, pbio3b] = EnvironHV[11, pbio3b] / Pw[3] ELSE dens[28, pbio3bc] = 0.0
  ;pbio3c = WHERE(EnvironHV[17, *] GT 0.0, pbio3ccount, complement = pbio3cc, ncomplement = pbio3cccount)
  ;IF pbio3ccount GT 0.0 THEN dens[29, pbio3c] = EnvironHV[17, pbio3c] / Pw[3] ELSE dens[29, pbio3cc] = 0.0
  pbio3d = WHERE(EnvironHV[25, *] GT 0.0, pbio3dcount, complement = pbio3dc, ncomplement = pbio3dccount)
  IF pbio3dcount GT 0.0 THEN dens[30, pbio3d] = EnvironHV[25, pbio3d] / Pw[3] ELSE dens[30, pbio3dc] = 0.0
  pbio3e = WHERE(EnvironHV[33, *] GT 0.0, pbio3ecount, complement = pbio3ec, ncomplement = pbio3eccount)
  IF pbio3ecount GT 0.0 THEN dens[31, pbio3e] = EnvironHV[33, pbio3e] / Pw[3] ELSE dens[31, pbio3ec] = 0.0
  ;pbio3f = WHERE(EnvironHV[41, *] GT 0.0, pbio3fcount, complement = pbio3fc, ncomplement = pbio3fccount)
  ;IF pbio3fcount GT 0.0 THEN dens[32, pbio3f] = EnvironHV[41, pbio3f] / Pw[3] ELSE dens[32, pbio3fc] = 0.0
  pbio3g = WHERE(EnvironHV[49, *] GT 0.0, pbio3gcount, complement = pbio3gc, ncomplement = pbio3gccount)
  IF pbio3gcount GT 0.0 THEN dens[33, pbio3g] = EnvironHV[49, pbio3g] / Pw[3] ELSE dens[33, pbio3gc] = 0.0
  ;pbio3h = WHERE(EnvironHV[57, *] GT 0.0, pbio3hcount, complement = pbio3hc, ncomplement = pbio3hccount)
  ;IF pbio3hcount GT 0.0 THEN dens[34, pbio3h] = EnvironHV[57, pbio3h] / Pw[3] ELSE dens[34, pbio3hc] = 0.0
  pbio3i = WHERE(EnvironHV[65, *] GT 0.0, pbio3icount, complement = pbio3ic, ncomplement = pbio3iccount)
  IF pbio3icount GT 0.0 THEN dens[35, pbio3i] = EnvironHV[65, pbio3i] / Pw[3] ELSE dens[35, pbio3ic] = 0.0
  
  pbio3j = WHERE(EnvironHV[80, *] GT 0.0, pbio3jcount, complement = pbio3jc, ncomplement = pbio3jccount)
  IF pbio3jcount GT 0.0 THEN dens[71, pbio3j] = EnvironHV[80, pbio3j] / Pw[3] ELSE dens[71, pbio3jc] = 0.0
  pbio3k = WHERE(EnvironHV[88, *] GT 0.0, pbio3kcount, complement = pbio3kc, ncomplement = pbio3kccount)
  IF pbio3kcount GT 0.0 THEN dens[72, pbio3k] = EnvironHV[88, pbio3k] / Pw[3] ELSE dens[72, pbio3kc] = 0.0
  pbio3l = WHERE(EnvironHV[95, *] GT 0.0, pbio3lcount, complement = pbio3lc, ncomplement = pbio3lccount)
  IF pbio3lcount GT 0.0 THEN dens[73, pbio3l] = EnvironHV[95, pbio3l] / Pw[3] ELSE dens[73, pbio3lc] = 0.0
  pbio3o = WHERE(EnvironHV[103, *] GT 0.0, pbio3ocount, complement = pbio3oc, ncomplement = pbio3occount)
  IF pbio3ocount GT 0.0 THEN dens[74, pbio3o] = EnvironHV[103, pbio3o] / Pw[3] ELSE dens[74, pbio3oc] = 0.0
  pbio3p = WHERE(EnvironHV[111, *] GT 0.0, pbio3pcount, complement = pbio3pc, ncomplement = pbio3pccount)
  IF pbio3pcount GT 0.0 THEN dens[75, pbio3p] = EnvironHV[111, pbio3p] / Pw[3] ELSE dens[75, pbio3pc] = 0.0
  pbio3q = WHERE(EnvironHV[119, *] GT 0.0, pbio3qcount, complement = pbio3qc, ncomplement = pbio3qccount)
  IF pbio3qcount GT 0.0 THEN dens[76, pbio3q] = EnvironHV[119, pbio3q] / Pw[3] ELSE dens[76, pbio3qc] = 0.0
  
  ; Invasive species
  ;dens[36,*] = EnvironHV[6, *] / Pw[4]
  dens[37,*] = EnvironHV[14, *] / Pw[4]
  ;dens[38,*] = EnvironHV[20, *] / Pw[4]
  dens[39,*] = EnvironHV[28, *] / Pw[4]
  dens[40,*] = EnvironHV[36, *] / Pw[4]
  ;dens[41,*] = EnvironHV[44, *] / Pw[4]
  dens[42,*] = EnvironHV[52, *] / Pw[4]
  ;dens[43,*] = EnvironHV[60, *] / Pw[4]
  dens[44,*] = EnvironHV[68, *] / Pw[4]
  
  dens[77,*] = EnvironHV[83, *] / Pw[4]
  dens[78,*] = EnvironHV[91, *] / Pw[4]
  dens[79,*] = EnvironHV[98, *] / Pw[4]
  dens[80,*] = EnvironHV[106, *] / Pw[4]
  dens[81,*] = EnvironHV[114, *] / Pw[4]
  dens[82,*] = EnvironHV[122, *] / Pw[4]
  
  ; Fish prey
  ;dens[45,*] = EnvironHV[7, *] / Pw[5]
  dens[46,*] = EnvironHV[15, *] / Pw[5]
  ;dens[47,*] = EnvironHV[21, *] / Pw[5]
  dens[48,*] = EnvironHV[29, *] / Pw[5]
  dens[49,*] = EnvironHV[37, *] / Pw[5]
  ;dens[50,*] = EnvironHV[45, *] / Pw[5]
  dens[51,*] = EnvironHV[53, *] / Pw[5]
  ;dens[52,*] = EnvironHV[61, *] / Pw[5]
  dens[53,*] = EnvironHV[69, *] / Pw[5]
  
  dens[83,*] = EnvironHV[84, *] / Pw[5]
  dens[84,*] = EnvironHV[92, *] / Pw[5]
  dens[85,*] = EnvironHV[99, *] / Pw[5]
  dens[86,*] = EnvironHV[107, *] / Pw[5]
  dens[87,*] = EnvironHV[115, *] / Pw[5]
  dens[88,*] = EnvironHV[123, *] / Pw[5]
 ;PRINT, 'Density =', dens

; Calculate Chesson's alpha for each prey type; YP[1, *]
  Calpha = FLTARR(m, nYP)
  Calpha[0, *] = 193499 * YP[1, *]^(-7.64); for rotifers
  Calpha[1, *] = 0.272 * ALOG(YP[1, *]) - 0.3834; for calanoids
  Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * YP[1, *]))^(1.0 / 0.031) ; for cladocerans
  PL3 = WHERE((PL[3] / YP[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
  IF (pl3count GT 0.0) THEN Calpha[3,*] = ABS(0.50 - 1.75 * (PL[3,*] / YP[1, *])) $
  ELSE Calpha[3,*] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 
  Length4 = WHERE(YP[1, *] GT 60.0, L4count, complement = L4c, ncomplement = L4ccount)
  IF (L4count GT 0.0) THEN Calpha[4,*] = 0.001 $; for bythotrephes CHANGE!!! with Rainbow smelt from Barnhisel and Harvey
  ELSE Calpha[4,*] = 0.00
  PL5a = WHERE((PL[5] / YP[1, *]) LT 0.20, pl5acount, complement = pl5ac, ncomplement = pl5account)
  IF (pl5acount GT 0.0) THEN Calpha[5,*] = 0.25 $ ; NEED A FUNCTION, 0.5 - 1.75 * length $
  ELSE Calpha[5,*] = 0.00 ; for fish
  ;PRINT, 'Calpha =', Calpha
  
; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(9+6, nYP); total number of all prey atacked and captured
  t = FLTARR(m*(9+6), nYP); total number of each prey atacked and captured
  ;t[0,*] = (Calpha[0,*] * dens[0,*])
  t[1,*] = (Calpha[0,*] * dens[1,*])
  ;t[2,*] = (Calpha[0,*] * dens[2,*])
  t[3,*] = (Calpha[0,*] * dens[3,*])
  t[4,*] = (Calpha[0,*] * dens[4,*])
  ;t[5,*] = (Calpha[0,*] * dens[5,*])
  t[6,*] = (Calpha[0,*] * dens[6,*])
  ;t[7,*] = (Calpha[0,*] * dens[7,*])
  t[8,*] = (Calpha[0,*] * dens[8,*])
       
  t[54,*] = (Calpha[0,*] * dens[54,*])
  t[55,*] = (Calpha[0,*] * dens[55,*])    
  t[56,*] = (Calpha[0,*] * dens[56,*])    
  t[57,*] = (Calpha[0,*] * dens[57,*])   
  t[58,*] = (Calpha[0,*] * dens[58,*])
  t[59,*] = (Calpha[0,*] * dens[59,*]) 
       
  ;t[9,*] = (Calpha[1,*] * dens[9,*])
  t[10,*] = (Calpha[1,*] * dens[10,*])
  ;t[11,*] = (Calpha[1,*] * dens[11,*])
  t[12,*] = (Calpha[1,*] * dens[12,*])
  t[13,*] = (Calpha[1,*] * dens[13,*])
  ;t[14,*] = (Calpha[1,*] * dens[14,*])
  t[15,*] = (Calpha[1,*] * dens[15,*])
  ;t[16,*] = (Calpha[1,*] * dens[16,*])
  t[17,*] = (Calpha[1,*] * dens[17,*])
  
  t[60,*] = (Calpha[1,*] * dens[60,*])
  t[61,*] = (Calpha[1,*] * dens[61,*]) 
  t[62,*] = (Calpha[1,*] * dens[62,*])
  t[63,*] = (Calpha[1,*] * dens[63,*])
  t[64,*] = (Calpha[1,*] * dens[64,*])
  t[65,*] = (Calpha[1,*] * dens[65,*])
      
  ;t[18,*] = (Calpha[2,*] * dens[18,*])
  t[19,*] = (Calpha[2,*] * dens[19,*])
  ;t[20,*] = (Calpha[2,*] * dens[20,*])
  t[21,*] = (Calpha[2,*] * dens[21,*])
  t[22,*] = (Calpha[2,*] * dens[22,*])
  ;t[23,*] = (Calpha[2,*] * dens[23,*])
  t[24,*] = (Calpha[2,*] * dens[24,*])
  ;t[25,*] = (Calpha[2,*] * dens[25,*])
  t[26,*] = (Calpha[2,*] * dens[26,*])
      
  t[66,*] = (Calpha[2,*] * dens[66,*])
  t[67,*] = (Calpha[2,*] * dens[67,*])
  t[68,*] = (Calpha[2,*] * dens[68,*])
  t[69,*] = (Calpha[2,*] * dens[69,*])
  t[70,*] = (Calpha[2,*] * dens[70,*])
  t[71,*] = (Calpha[2,*] * dens[71,*])

  ;t[27,*] = (Calpha[3,*] * dens[27,*])
  t[28,*] = (Calpha[3,*] * dens[28,*])
  ;t[29,*] = (Calpha[3,*] * dens[29,*])
  t[30,*] = (Calpha[3,*] * dens[30,*])
  t[31,*] = (Calpha[3,*] * dens[31,*])
  ;t[32,*] = (Calpha[3,*] * dens[32,*])
  t[33,*] = (Calpha[3,*] * dens[33,*])
  ;t[34,*] = (Calpha[3,*] * dens[34,*])
  t[35,*] = (Calpha[3,*] * dens[35,*])
      
  t[72,*] = (Calpha[3,*] * dens[72,*])
  t[73,*] = (Calpha[3,*] * dens[73,*])
  t[74,*] = (Calpha[3,*] * dens[74,*])
  t[75,*] = (Calpha[3,*] * dens[75,*])
  t[76,*] = (Calpha[3,*] * dens[76,*])
  t[77,*] = (Calpha[3,*] * dens[77,*])
      
      
  ;t[36,*] = (Calpha[4,*] * dens[36,*])
  t[37,*] = (Calpha[4,*] * dens[37,*])
  ;t[38,*] = (Calpha[4,*] * dens[38,*])
  t[39,*] = (Calpha[4,*] * dens[39,*])
  t[40,*] = (Calpha[4,*] * dens[40,*])
  ;t[41,*] = (Calpha[4,*] * dens[41,*])
  t[42,*] = (Calpha[4,*] * dens[42,*])
  ;t[43,*] = (Calpha[4,*] * dens[43,*])
  t[44,*] = (Calpha[4,*] * dens[44,*])
  
  t[78,*] = (Calpha[4,*] * dens[78,*])
  t[79,*] = (Calpha[4,*] * dens[79,*])
  t[80,*] = (Calpha[4,*] * dens[80,*])
  t[81,*] = (Calpha[4,*] * dens[81,*])
  t[82,*] = (Calpha[4,*] * dens[82,*])
  t[83,*] = (Calpha[4,*] * dens[83,*])

  ;t[45,*] = (Calpha[5,*] * dens[45,*])
  t[46,*] = (Calpha[5,*] * dens[46,*])
  ;t[47,*] = (Calpha[5,*] * dens[47,*])
  t[48,*] = (Calpha[5,*] * dens[48,*])
  t[49,*] = (Calpha[5,*] * dens[49,*])
  ;t[50,*] = (Calpha[5,*] * dens[50,*])
  t[51,*] = (Calpha[5,*] * dens[51,*])
  ;t[52,*] = (Calpha[5,*] * dens[52,*])
  t[53,*] = (Calpha[5,*] * dens[53,*])

  t[84,*] = (Calpha[5,*] * dens[84,*])
  t[85,*] = (Calpha[5,*] * dens[85,*])
  t[86,*] = (Calpha[5,*] * dens[86,*])
  t[87,*] = (Calpha[5,*] * dens[87,*])
  t[88,*] = (Calpha[5,*] * dens[88,*])
  t[89,*] = (Calpha[5,*] * dens[89,*])
;PRINT, 't =', t

  ;TOT[0, *] = t[0,*] + t[9,*] + t[18,*] + t[27,*] + t[36,*] + t[45,*]
  TOT[1, *] = t[1,*] + t[10,*] + t[19,*] + t[28,*] + t[37,*] + t[46,*]
  ;TOT[2, *] = t[2,*] + t[11,*] + t[20,*] + t[29,*] + t[38,*] + t[47,*]
  TOT[3, *] = t[3,*] + t[12,*] + t[21,*] + t[30,*] + t[39,*] + t[48,*]
  TOT[4, *] = t[4,*] + t[13,*] + t[22,*] + t[31,*] + t[40,*] + t[49,*]
  ;TOT[5, *] = t[5,*] + t[14,*] + t[23,*] + t[32,*] + t[41,*] + t[50,*]
  TOT[6, *] = t[6,*] + t[15,*] + t[24,*] + t[33,*] + t[42,*] + t[51,*]
  ;TOT[7, *] = t[7,*] + t[16,*] + t[25,*] + t[34,*] + t[43,*] + t[52,*]
  
  TOT[8, *] = t[8,*] + t[17,*] + t[26,*] + t[35,*] + t[44,*] + t[53,*]
  
  TOT[9, *] = t[54,*] + t[60,*] + t[66,*] + t[72,*] + t[78,*] + t[84,*]
  TOT[10, *] = t[55,*] + t[61,*] + t[67,*] + t[73,*] + t[79,*] + t[85,*]
  TOT[11, *] = t[56,*] + t[62,*] + t[68,*] + t[74,*] + t[80,*] + t[86,*]
  TOT[12, *] = t[57,*] + t[63,*] + t[69,*] + t[75,*] + t[81,*] + t[87,*]
  TOT[13, *] = t[58,*] + t[64,*] + t[70,*] + t[76,*] + t[82,*] + t[88,*]
  TOT[14, *] = t[59,*] + t[65,*] + t[71,*] + t[77,*] + t[83,*] + t[89,*] 
  
; Add small value for zero prey cells to avoid floating errors
  ;TOT01 = WHERE(TOT[0, *] EQ 0.0, TOT01count, complement = TOTN01, ncomplement = TOTN01count)
  ;IF TOT01count GT 0.0 THEN TOT[0, TOT01] = TOT[0, TOT01] + 10.0^(-20.0)
  TOT02 = WHERE(TOT[1, *] EQ 0.0, TOT02count, complement = TOTN02, ncomplement = TOTN02count)
  IF TOT02count GT 0.0 THEN TOT[1, TOT02] = TOT[1, TOT02] + 10.0^(-20.0)
  ;TOT03 = WHERE(TOT[2, *] EQ 0.0, TOT03count, complement = TOTN03, ncomplement = TOTN03count)
  ;IF TOT03count GT 0.0 THEN TOT[2, TOT03] = TOT[2, TOT03] + 10.0^(-20.0)
  TOT04 = WHERE(TOT[3, *] EQ 0.0, TOT04count, complement = TOTN04, ncomplement = TOTN04count)
  IF TOT04count GT 0.0 THEN TOT[3, TOT04] = TOT[3, TOT04] + 10.0^(-20.0)
  TOT05 = WHERE(TOT[4, *] EQ 0.0, TOT05count, complement = TOTN05, ncomplement = TOTN05count)
  IF TOT05count GT 0.0 THEN TOT[4, TOT05] = TOT[4, TOT05] + 10.0^(-20.0)
  ;TOT06 = WHERE(TOT[5, *] EQ 0.0, TOT06count, complement = TOTN06, ncomplement = TOTN06count)
  ;IF TOT06count GT 0.0 THEN TOT[5, TOT06] = TOT[5, TOT06] + 10.0^(-20.0)
  TOT07 = WHERE(TOT[6, *] EQ 0.0, TOT07count, complement = TOTN07, ncomplement = TOTN07count)
  IF TOT07count GT 0.0 THEN TOT[6, TOT07] = TOT[6, TOT07] + 10.0^(-20.0)
  ;TOT08 = WHERE(TOT[7, *] EQ 0.0, TOT08count, complement = TOTN08, ncomplement = TOTN08count)
  ;IF TOT08count GT 0.0 THEN TOT[7, TOT08] = TOT[7, TOT08] + 10.0^(-20.0)
  TOT09 = WHERE(TOT[8, *] EQ 0.0, TOT09count, complement = TOTN09, ncomplement = TOTN09count)
  IF TOT09count GT 0.0 THEN TOT[8, TOT09] = TOT[8, TOT09] + 10.0^(-20.0)

  TOT010 = WHERE(TOT[9, *] EQ 0.0, TOT010count, complement = TOTN010, ncomplement = TOTN010count)
  IF TOT010count GT 0.0 THEN TOT[9, TOT010] = TOT[9, TOT010] + 10.0^(-20.0)
  TOT011 = WHERE(TOT[10, *] EQ 0.0, TOT011count, complement = TOTN011, ncomplement = TOTN011count)
  IF TOT011count GT 0.0 THEN TOT[10, TOT011] = TOT[10, TOT011] + 10.0^(-20.0)
  TOT012 = WHERE(TOT[11, *] EQ 0.0, TOT012count, complement = TOTN012, ncomplement = TOTN012count)
  IF TOT012count GT 0.0 THEN TOT[11, TOT012] = TOT[11, TOT012] + 10.0^(-20.0)
  TOT013 = WHERE(TOT[12, *] EQ 0.0, TOT013count, complement = TOTN013, ncomplement = TOTN013count)
  IF TOT013count GT 0.0 THEN TOT[12, TOT013] = TOT[12, TOT013] + 10.0^(-20.0)
  TOT014 = WHERE(TOT[13, *] EQ 0.0, TOT014count, complement = TOTN014, ncomplement = TOTN014count)
  IF TOT014count GT 0.0 THEN TOT[13, TOT014] = TOT[13, TOT014] + 10.0^(-20.0)
  TOT015 = WHERE(TOT[14, *] EQ 0.0, TOT015count, complement = TOTN015, ncomplement = TOTN015count)
  IF TOT015count GT 0.0 THEN TOT[14, TOT015] = TOT[14, TOT015] + 10.0^(-20.0)

; Calculate cumulative prey biomass for each NEIGHBORING layer 
; And copy cumulative prey biomass to all NEIGHBORING cells
; For horizontal movement
preyTOT = FLTARR(nYP)
preyTOT2 = FLTARR(9, nYP)
; For vertical movement
preyTOT3 = FLTARR(nYP)
preyTOT4 = FLTARR(7, nYP)
FOR ivvv = 0L, nYP - 1L DO BEGIN
preyTOT[ivvv] = TOTAL(TOT[0:8, ivvv])  
preyTOT3[ivvv] = TOTAL(TOT[8:14, ivvv])  
preyTOT2[0:8, ivvv] = preyTOT[ivvv]
preyTOT4[0:6, ivvv] = preyTOT3[ivvv]
ENDFOR
;PRINT, 'preyTOT =', preyTOT
;preyTOT[0] = TOTAL(TOT[0:8, 0]) 
PRINT, 'preyTOT2'
PRINT, preyTOT2
PRINT, 'preyTOT4'
PRINT, preyTOT4
;PRINT, 'tot =', TOT


EnvironHVprey = FLTARR(9+7, nYP)
; For horizontal movement
;EnvironHVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nYP, /DOUBLE)
;EnvironHVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nYP, /DOUBLE)
;EnvironHVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nYP, /DOUBLE)
;EnvironHVprey[7, *] = (TOT[7, *] / preyTOT2[7, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[8, *] = (TOT[8, *] / preyTOT2[8, *]) * RANDOMU(seed, nYP, /DOUBLE)
; For vertical movement
EnvironHVprey[9, *] = (TOT[9, *] / preyTOT4[1, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[10, *] = (TOT[10, *] / preyTOT4[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[11, *] = (TOT[11, *] / preyTOT4[3, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[12, *] = (TOT[12, *] / preyTOT4[4, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[13, *] = (TOT[13, *] / preyTOT4[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[14, *] = (TOT[14, *] / preyTOT4[6, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[15, *] = (TOT[8, *] / preyTOT4[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
PRINT, 'EnvironHVprey =', EnvironHVprey

EnvironHVSum = FLTARR(9+7, nYP)
;EnvironHVSum[0, *] = DOUBLE((EnvironHVDO[0, *] * EnvironHVT[0, *] * EnvironHVprey[0, *])^(1.0/3.0))
EnvironHVSum[1, *] = DOUBLE((EnvironHVDO[1, *] * EnvironHVT[1, *] * EnvironHVprey[1, *])^(1.0/3.0))
;EnvironHVSum[2, *] = DOUBLE((EnvironHVDO[2, *] * EnvironHVT[2, *] * EnvironHVprey[2, *])^(1.0/3.0))
EnvironHVSum[3, *] = DOUBLE((EnvironHVDO[3, *] * EnvironHVT[3, *] * EnvironHVprey[3, *])^(1.0/3.0))
EnvironHVSum[4, *] = DOUBLE((EnvironHVDO[4, *] * EnvironHVT[4, *] * EnvironHVprey[4, *])^(1.0/3.0))
;EnvironHVSum[5, *] = DOUBLE((EnvironHVDO[5, *] * EnvironHVT[5, *] * EnvironHVprey[5, *])^(1.0/3.0))
EnvironHVSum[6, *] = DOUBLE((EnvironHVDO[6, *] * EnvironHVT[6, *] * EnvironHVprey[6, *])^(1.0/3.0))
;EnvironHVSum[7, *] = DOUBLE((EnvironHVDO[7, *] * EnvironHVT[7, *] * EnvironHVprey[7, *])^(1.0/3.0))
EnvironHVSum[8, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[8, *])^(1.0/3.0))

EnvironHVSum[9, *] = DOUBLE((EnvironHVDO[9, *] * EnvironHVT[9, *] * EnvironHVprey[9, *])^(1.0/3.0))
EnvironHVSum[10, *] = DOUBLE((EnvironHVDO[10, *] * EnvironHVT[10, *] * EnvironHVprey[10, *])^(1.0/3.0))
EnvironHVSum[11, *] = DOUBLE((EnvironHVDO[11, *] * EnvironHVT[11, *] * EnvironHVprey[11, *])^(1.0/3.0))
EnvironHVSum[12, *] = DOUBLE((EnvironHVDO[12, *] * EnvironHVT[12, *] * EnvironHVprey[12, *])^(1.0/3.0))
EnvironHVSum[13, *] = DOUBLE((EnvironHVDO[13, *] * EnvironHVT[13, *] * EnvironHVprey[13, *])^(1.0/3.0))
EnvironHVSum[14, *] = DOUBLE((EnvironHVDO[14, *] * EnvironHVT[14, *] * EnvironHVprey[14, *])^(1.0/3.0))
EnvironHVSum[15, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[15, *])^(1.0/3.0))
PRINT, 'EnvironHVSum'
PRINT, EnvironHVSum

; Movement in x-dimension -> cells 4 & 5
; Movement in y-dimension -> cells 2 & 7
; fish could also end up in cells 1, 3, 6, and 8, depending on the within-cell locations
; If the current cell is best among neiboring cells, fish will move within the cell randomly.

; Movement in x-dimension
xMove = FLTARR(nYP)
; move to cell 5
xMovePos = WHERE((EnvironHVSum[3, *] LT EnvironHVSum[4, *]) AND (EnvironHVSum[4, *] GT EnvironHVSum[8, *]), xMovePoscount, complement = xMovePosN, ncomplement = xMovePosNcount)
IF xMovePoscount GT 0.0 THEN xMove[xMovePos] = 5
; move to cell 4 
xMoveNeg = WHERE((EnvironHVSum[3, *] GT EnvironHVSum[4, *]) AND (EnvironHVSum[3, *] GT EnvironHVSum[8, *]), xMoveNegcount, complement = xMoveNegN, ncomplement = xMoveNegNcount)
IF xMoveNegcount GT 0.0 THEN xMove[xMoveNeg] = 4
; stay
xMoveNon = WHERE((EnvironHVSum[8, *] GE EnvironHVSum[4, *]) AND (EnvironHVSum[8, *] GE EnvironHVSum[3, *]), xMoveNoncount, complement = xMoveNonN, ncomplement = xMoveNonNcount)
IF xMoveNoncount GT 0.0 THEN xMove[xMoveNon] = 9
;PRINT, 'xMovePos', xMovePos
;PRINT, 'xMoveNeg', xMoveNeg
;PRINT, 'xMoveNon', xMoveNon
PRINT, 'xMove', xMove
; Movement in y-dimension
yMove = FLTARR(nYP)
; move to cell 2 
yMovePos = WHERE((EnvironHVSum[1, *] GT EnvironHVSum[6, *]) AND (EnvironHVSum[1, *] GT EnvironHVSum[8, *]), yMovePoscount, complement = yMovePosN, ncomplement = yMovePosNcount)
IF yMovePoscount GT 0.0 THEN yMove[yMovePos] = 2
; move to cell 7 
yMoveNeg = WHERE((EnvironHVSum[1, *] LT EnvironHVSum[6, *]) AND (EnvironHVSum[6, *] GT EnvironHVSum[8, *]), yMoveNegcount, complement = yMoveNegN, ncomplement = yMoveNegNcount)
IF yMoveNegcount GT 0.0 THEN yMove[yMoveNeg] = 7
; stay
yMoveNon = WHERE((EnvironHVSum[8, *] GE EnvironHVSum[1, *]) AND (EnvironHVSum[8, *] GE EnvironHVSum[6, *]), yMoveNoncount, complement = yMoveNonN, ncomplement = yMoveNonNcount)
IF yMoveNoncount GT 0.0 THEN yMove[yMoveNon] = 9
;PRINT, 'yMovePos', yMovePos
;PRINT, 'yMoveNeg', yMoveNeg
;PRINT, 'yMoveNon', yMoveNon

; Movement in z-dimension
zMove = FLTARR(nYP)
zMovePos = FLTARR(nYP)
zMoveNeg = FLTARR(nYP)
zMoveNon = FLTARR(nYP)
FOR iv = 0L, nYP - 1L DO BEGIN
; move upward (11)
zMovePos[iv] = WHERE(((MAX(EnvironHVSum[9:11, iv]) GT MAX(EnvironHVSum[12:14, iv])) AND (MAX(EnvironHVSum[9:11, iv]) GT EnvironHVSum[15, iv])), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
IF zMovePoscount GT 0.0 THEN zMove[iv] = 11
; move downward (12)
zMoveNeg[iv] = WHERE(((MAX(EnvironHVSum[9:11, iv]) LT MAX(EnvironHVSum[12:14, iv])) AND (MAX(EnvironHVSum[12:14, iv]) GT EnvironHVSum[15, iv])), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
IF zMoveNegcount GT 0.0 THEN zMove[iv] = 12
; stay (15)
zMoveNon[iv] = WHERE(((EnvironHVSum[15, iv] GE MAX(EnvironHVSum[9:11, iv])) AND (EnvironHVSum[15, iv] GE MAX(EnvironHVSum[12:14, iv]))), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
IF zMoveNoncount GT 0.0 THEN zMove[iv] = 15
;PRINT, 'zMovePos', zMovePos
;PRINT, 'zMoveNeg', zMoveNeg
;PRINT, 'zMoveNon', zMoveNon
ENDFOR
PRINT, 'zMove', zMove

; 1. *******Determine the movement orientation****************************************************
  ; For now, each cell is assumed to have gradients between the current and neiboring cells
  ; fish are able to detect gradients within a cetain range... 
HorOriAng = FLTARR(nYP)
;X-Y plane 1
xyMoveOri1 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] GT EnvironHVSum[1, *])), xyMoveOri1count, complement = xyMoveOri1N, ncomplement = xyMoveOri1Ncount)
xyMoveOri2 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] LT EnvironHVSum[1, *])), xyMoveOri2count, complement = xyMoveOri2N, ncomplement = xyMoveOri2Ncount)
IF (xyMoveOri1count GT 0.0) THEN HorOriAng[xyMoveOri1] = 22.5
IF (xyMoveOri2count GT 0.0) THEN HorOriAng[xyMoveOri2] = 67.5
;X-Y plane 2
xyMoveOri3 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] LT EnvironHVSum[1, *])), xyMoveOri3count, complement = xyMoveOri3N, ncomplement = xyMoveOri3Ncount)
xyMoveOri4 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] GT EnvironHVSum[1, *])), xyMoveOri4count, complement = xyMoveOri4N, ncomplement = xyMoveOri4Ncount)
IF (xyMoveOri3count GT 0.0) THEN HorOriAng[xyMoveOri3] = 22.5+90.
IF (xyMoveOri4count GT 0.0) THEN HorOriAng[xyMoveOri4] = 67.5+90.
;X-Y plane 3
xyMoveOri5 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] GT EnvironHVSum[6, *])), xyMoveOri5count, complement = xyMoveOri5N, ncomplement = xyMoveOri5Ncount)
xyMoveOri6 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] LT EnvironHVSum[6, *])), xyMoveOri6count, complement = xyMoveOri6N, ncomplement = xyMoveOri6Ncount)
IF (xyMoveOri5count GT 0.0) THEN HorOriAng[xyMoveOri5] = 22.5+180.
IF (xyMoveOri6count GT 0.0) THEN HorOriAng[xyMoveOri6] = 67.5+180.
;X-Y plane 4
xyMoveOri7 = WHERE(((xMove EQ 5) AND (yMove EQ 7) AND (EnvironHVSum[4, *] LT EnvironHVSum[6, *])), xyMoveOri7count, complement = xyMoveOri7N, ncomplement = xyMoveOri7Ncount)
xyMoveOri8 = WHERE(((xMove EQ 5) AND (yMove EQ 7) AND (EnvironHVSum[4, *] GT EnvironHVSum[6, *])), xyMoveOri8count, complement = xyMoveOri8N, ncomplement = xyMoveOri8Ncount)
IF (xyMoveOri7count GT 0.0) THEN HorOriAng[xyMoveOri7] = 22.5+270.
IF (xyMoveOri8count GT 0.0) THEN HorOriAng[xyMoveOri8] = 67.5+270.
; stay
xyMoveOri9 = WHERE(((xMove EQ 9) AND (yMove EQ 9)), xyMoveOri9count, complement = xyMoveOri9N, ncomplement = xyMoveOri9Ncount)
IF (xyMoveOri9count GT 0.0)  THEN HorOriAng[xyMoveOri9] = randomu(seed, xyMoveOri9count)*(max(360)-min(0))+min(0)
; Movement in positive x-dimension only
xyMoveOri10 = WHERE(((xMove EQ 5) AND (yMove EQ 9)), xyMoveOri10count, complement = xyMoveOri10N, ncomplement = xyMoveOri10Ncount)
IF (xyMoveOri10count GT 0.0)  THEN HorOriAng[xyMoveOri10] = 0.
; Movement in positive y-dimension only
xyMoveOri11 = WHERE(((xMove EQ 9) AND (yMove EQ 2)), xyMoveOri11count, complement = xyMoveOri11N, ncomplement = xyMoveOri11Ncount)
IF (xyMoveOri11count GT 0.0)  THEN HorOriAng[xyMoveOri11] = 90.
; Movement in negative x-dimension only
xyMoveOri12 = WHERE(((xMove EQ 4) AND (yMove EQ 9)), xyMoveOri12count, complement = xyMoveOri12N, ncomplement = xyMoveOri12Ncount)
IF (xyMoveOri12count GT 0.0)  THEN HorOriAng[xyMoveOri12] = 180.
; Movement in negative y-dimension only
xyMoveOri13 = WHERE(((xMove EQ 9) AND (yMove EQ 7)), xyMoveOri13count, complement = xyMoveOri13N, ncomplement = xyMoveOri13Ncount)
IF (xyMoveOri13count GT 0.0)  THEN HorOriAng[xyMoveOri13] = 270.

; Vertical movement
VerOriAng = FLTARR(nYP)
; Upward
zMoveOri1 = WHERE((zMove EQ 11), zMoveOri1count, complement = zMoveOri1N, ncomplement = zMoveOri1Ncount)
IF (zMoveOri1count GT 0.0) THEN VerOriAng[zMoveOri1] = RANDOMU(seed, zMoveOri1count)*(MAX(90)-MIN(0))+MIN(0)
; Downward
zMoveOri2 = WHERE((zMove EQ 12), zMoveOri2count, complement = zMoveOri2N, ncomplement = zMoveOri2Ncount)
IF (zMoveOri2count GT 0.0) THEN VerOriAng[zMoveOri2] = RANDOMU(seed, zMoveOri2count)*(MAX(180)-MIN(90))+MIN(90)
zMoveOri3 = WHERE((zMove EQ 15), zMoveOri3count, complement = zMoveOri3N, ncomplement = zMoveOri3Ncount)
IF (zMoveOri3count GT 0.0)  THEN VerOriAng[zMoveOri3] = 90.; randomu(seed, zMoveOri5count)*(max(180)-min(0))+min(0)

PRINT,'HorOriAng', HorOriAng
PRINT, 'COS(HorOriAng)', COS(HorOriAng)
PRINT, 'SIN(HorOriAng)', SIN(HorOriAng)
PRINT, 'COS(VerOriAng)', COS(VerOriAng)
PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)
; Convert degrees to radians
HorOriAng = HorOriAng*(!pi/180L)
VerOriAng = VerOriAng*(!pi/180L)
PRINT, 'COS(HorOriAng)', COS(HorOriAng)
PRINT, 'SIN(HorOriAng)', SIN(HorOriAng)
PRINT, 'COS(VerOriAng)', COS(VerOriAng)
PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)

  ; Determine the distance and direction fish move uisng the habitat quality values estimated above
; Calculate fish swimming speed, S, in body lengths/sec
  ;PRINT, 'Length'
  ;PRINT, Length
  SS = FLTARR(nYP)
  S = FLTARR(nyp)
  l = WHERE(length LT 20.0, lcount, complement = ll, ncomplement = llcount)
  IF (lcount GT 0.0) THEN $
  S[l] = 3.3354 * ALOG(length[l]) - 4.8758;(-0.0797 * (length[l] * length[l]) + 1.9294 * length[l] - 8.1761)
   ;SS equation based on data from Houde 1969 in body lengths/sec
  IF (llcount GT 0.0) THEN $
  S[ll] = (0.28 * Temp[ll] + 7.89) / (0.1 * length[ll])
   ;in body lengths/sec; from Breck 1997 and Hergenrader and Hasler 1967
   ; = 3.0227 * ALOG(length[l]) - 4.6273 for walleye <20mm; Houde, 1969  
   ; = 1000 * (0.263 + 0.72 * length[ll] + 0.012 * Temp[ll]) for walleye >20mm; Peake et al., 2000
  ; Converts SS into mm/s
  SS = (S * length)
  ;PRINT, 'S =', S
  PRINT, 'Swimming speed (mm/s)'
  PRINT, SS
  PRINT, 'Swimming speed in x-dimension (mm/s)'
  PRINT, SS*COS(HorOriAng) * SIN(VerOriAng)
  PRINT, 'Swimming speed in y-dimension (mm/s)'
  PRINT, SS*SIN(HorOriAng) * SIN(VerOriAng)
  PRINT, 'Swimming speed in Z-dimension (mm/s)'
  PRINT, SS*COS(VerOriAng)
  PRINT, 'Water currents (mm/s) xyz'
  PRINT, newinput[12:15, YP[14, *]]

  ; Calculate realized swimming speed (mm/s) in xyz-dimensions
  MoveSpeed = FLTARR(5,nYP)
  MoveSpeed[0, *] = SS*COS(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nYP, /DOUBLE) + newinput[12, YP[14, *]]; with a random comopnent
  MoveSpeed[1, *] = SS*SIN(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nYP, /DOUBLE) + newinput[13, YP[14, *]];
  MoveSpeed[2, *] = SS*COS(VerOriAng)/10L * RANDOMU(seed, nYP, /DOUBLE) + newinput[14, YP[14, *]]; VERTICAL DIRECTION
  MoveSpeed[3, *] = (MoveSpeed[0, *]^2 + MoveSpeed[1, *]^2)^0.5;  actual swimming speed, HORIZONTAL DIRECTION FOR NOW
  ; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
  MoveSpeed[4, *] = (0.102*(Length/39.10/EXP(0.330)) + 30.3) * 10.0;n critical swimming speed for adult yellow perch from Nelson, 1989, J. Exp. Biol.
  ;***Maximum speed is also used for 'URGENCY' move? (from Goodwin et al., 2001)***
  PRINT, 'Realized movement speed (mm/s)'
  PRINT, MoveSpeed
  
  ; Distance fish move in each time step OR shorter subtime step???
  ts2 = 120L; frequency of turning = >1
 
  ; 2. ******Determine the distance tarveled**********************************************************
  ; Identify the cell ID
  
  ; Cell size in horizontal direction = 2.0km = 2000m = 2000000mm
  xNewLoc = MoveSpeed[0, *]*ts*60L; distance (mm) in x-dimension
  yNewLoc = MoveSpeed[1, *]*ts*60L; distance (mm) in y-dimension
  zNewLoc = MoveSpeed[2, *]*ts*60L; distance (mm) in z-dimension
  
  xNewLocWithinCell = FLTARR(nYP)
  yNewLocWithinCell = FLTARR(nYP)
  zNewLocWithinCell = FLTARR(nYP)
  VerSize = FLTARR(nYP)
  VerSize[*] = (Grid2D[3, YP[13, *]]/20L)*1000L
  PRINT, 'VerSize', VerSize
  ; Proportional within-cell location in x-dimension 
  xMovePosLoc = WHERE((xMove GE 5.0), xMovePosLoccount, complement = xMovePosLocN, ncomplement = xMovePosLocNcount)
  IF xMovePosLoccount GT 0.0 THEN xNewLocWithinCell[xMovePosLoc] = xNewLoc[xMovePosLoc]/2000000. + xOldLocWithinCell[xMovePosLoc]; proportional distance in x-dimension
  xMoveNegLoc = WHERE((xMove EQ 4.0), xMoveNegLoccount, complement = xMoveNegLocN, ncomplement = xMoveNegLocNcount)
  IF xMoveNegLoccount GT 0.0 THEN xNewLocWithinCell[xMoveNegLoc] = xNewLoc[xMoveNegLoc]/2000000. - xOldLocWithinCell[xMoveNegLoc]; proportional distance in x-dimension

  ; Proportional within-cell location in y-dimension 
  yMovePosLoc = WHERE((yMove GE 7.0), yMovePosLoccount, complement = yMovePosLocN, ncomplement = yMovePosLocNcount)
  IF yMovePosLoccount GT 0.0 THEN yNewLocWithinCell[yMovePosLoc] = yNewLoc[yMovePosLoc]/2000000. + yOldLocWithinCell[yMovePosLoc]; proportional distance in y-dimension
  yMoveNegLoc = WHERE((yMove EQ 2.0), yMoveNegLoccount, complement = yMoveNegLocN, ncomplement = yMoveNegLocNcount)
  IF yMoveNegLoccount GT 0.0 THEN yNewLocWithinCell[yMoveNegLoc] = yNewLoc[yMoveNegLoc]/2000000. - yOldLocWithinCell[yMoveNegLoc]; proportional distance in y-dimension  

  ; Proportional within-cell location in z-dimension 
  zMovePosLoc = WHERE((zMove EQ 11.0), zMovePosLoccount, complement = zMovePosLocN, ncomplement = zMovePosLocNcount)
  IF zMovePosLoccount GT 0.0 THEN zNewLocWithinCell[zMovePosLoc] = zNewLoc[zMovePosLoc]/(VerSize[zMovePosLoc]) + zOldLocWithinCell[zMovePosLoc]; proportional distance in y-dimension
  zMoveNegLoc = WHERE((zMove EQ 12.0), zMoveNegLoccount, complement = zMoveNegLocN, ncomplement = zMoveNegLocNcount)
  IF zMoveNegLoccount GT 0.0 THEN zNewLocWithinCell[zMoveNegLoc] = zNewLoc[zMoveNegLoc]/(VerSize[zMoveNegLoc]) - zOldLocWithinCell[zMoveNegLoc]; proportional distance in y-dimension  
  
  ;*****FISH CAN MOVE ONLY UP TO 3 VERTICAL BELOW ABOVE CELLS********************************
  
  PRINT, 'Realized distance traveled in x-dimension per time step '
  PRINT, xNewLoc
  PRINT, 'Realized distance traveled in y-dimension per time step '
  PRINT, yNewLoc
  PRINT, 'Realized distance traveled in z-dimension per time step '
  PRINT, zNewLoc
  PRINT, 'Realized proportional distance traveled in x-dimension per time step '
  PRINT, xNewLocWithinCell
  PRINT, 'Realized proportional distance traveled in y-dimension per time step '
  PRINT, yNewLocWithinCell
   PRINT, 'Realized proportional distance traveled in z-dimension per time step '
  PRINT, zNewLocWithinCell
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
;  PRINT, 'YP[10, *]'
;  PRINT, TRANSPOSE(YP[10, *])
;  PRINT, 'YP[11, *]'
;  PRINT, TRANSPOSE(YP[11, *])
  
; *****Determine new cell locations****************************************************************************************

; No vertical movement
xyMoveOut1 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut1count, complement = xyMoveOut1N, ncomplement = xyMoveOut1Ncount)
IF xyMoveOut1count GT 0.0 THEN YP[14, xyMoveOut1] = LocHV[0, xyMoveOut1]
;PRINT,'xyMoveOut1', xyMoveOut1
xyMoveOut2 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut2count, complement = xyMoveOut2N, ncomplement = xyMoveOut2Ncount)
IF xyMoveOut2count GT 0.0 THEN YP[14, xyMoveOut2] = LocHV[1, xyMoveOut2]
;PRINT,'xyMoveOut2', xyMoveOut2
xyMoveOut3 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut3count, complement = xyMoveOut3N, ncomplement = xyMoveOut3Ncount)
IF xyMoveOut3count GT 0.0 THEN YP[14, xyMoveOut3] = LocHV[2, xyMoveOut3]
;PRINT,'xyMoveOut3', xyMoveOut3
xyMoveOut4 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut4count, complement = xyMoveOut4N, ncomplement = xyMoveOut4Ncount)
IF xyMoveOut4count GT 0.0 THEN YP[14, xyMoveOut4] = LocHV[3, xyMoveOut4]
;PRINT,'xyMoveOut4', xyMoveOut4
xyMoveOut5 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut5count, complement = xyMoveOut5N, ncomplement = xyMoveOut5Ncount)
IF xyMoveOut5count GT 0.0 THEN YP[14, xyMoveOut5] = LocHV[4, xyMoveOut5]
;PRINT,'xyMoveOut5', xyMoveOut5
xyMoveOut6 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut6count, complement = xyMoveOut6N, ncomplement = xyMoveOut6Ncount)
IF xyMoveOut6count GT 0.0 THEN YP[14, xyMoveOut6] = LocHV[5, xyMoveOut6]
;PRINT,'xyMoveOut6', xyMoveOut6
xyMoveOut7 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut7count, complement = xyMoveOut7N, ncomplement = xyMoveOut7Ncount)
IF xyMoveOut7count GT 0.0 THEN YP[14, xyMoveOut7] = LocHV[6, xyMoveOut7]
;PRINT,'xyMoveOut7', xyMoveOut7
xyMoveOut8 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut8count, complement = xyMoveOut8N, ncomplement = xyMoveOut8Ncount)
IF xyMoveOut8count GT 0.0 THEN YP[14, xyMoveOut8] = LocHV[7, xyMoveOut8]
;PRINT,'xyMoveOut8', xyMoveOut8
xyMoveOut9 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut9count, complement = xyMoveOut9N, ncomplement = xyMoveOut9Ncount)
IF xyMoveOut9count GT 0.0 THEN YP[14, xyMoveOut9] = LocHV[8, xyMoveOut9]
;PRINT,'xyMoveOut9', xyMoveOut9
;  IF (LocH[18, ihh] GE 0.0) THEN NewGridXY[0, ihh] = LocH[18, ihh] ELSE NewGridXY[0, ihh] = YP[13, ihh] = 1
;  IF (LocH[19, ihh] GE 0.0) THEN NewGridXY[1, ihh] = LocH[19, ihh] ELSE NewGridXY[1, ihh] = YP[13, ihh] = 2
;  IF (LocH[20, ihh] GE 0.0) THEN NewGridXY[2, ihh] = LocH[20, ihh] ELSE NewGridXY[2, ihh] = YP[13, ihh] = 3
;  IF (LocH[21, ihh] GE 0.0) THEN NewGridXY[3, ihh] = LocH[21, ihh] ELSE NewGridXY[3, ihh] = YP[13, ihh] = 4
;  IF (LocH[22, ihh] GE 0.0) THEN NewGridXY[4, ihh] = LocH[22, ihh] ELSE NewGridXY[4, ihh] = YP[13, ihh] = 5
;  IF (LocH[23, ihh] GE 0.0) THEN NewGridXY[5, ihh] = LocH[23, ihh] ELSE NewGridXY[5, ihh] = YP[13, ihh] = 6
;  IF (LocH[24, ihh] GE 0.0) THEN NewGridXY[6, ihh] = LocH[24, ihh] ELSE NewGridXY[6, ihh] = YP[13, ihh] = 7
;  IF (LocH[25, ihh] GE 0.0) THEN NewGridXY[7, ihh] = LocH[25, ihh] ELSE NewGridXY[7, ihh] = YP[13, ihh] = 8
;  IF (LocH[26, ihh] GE 0.0) THEN NewGridXY[8, ihh] = LocH[26, ihh] ELSE NewGridXY[8, ihh] = YP[13, ihh] = 9 stay
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
PRINT, 'NewGrid 3D ID with no vertical movement'
PRINT, TRANSPOSE(YP[14, *])
;  PRINT, 'YP[10, *]'
;  PRINT, TRANSPOSE(YP[10, *])
;  PRINT, 'YP[11, *]'
;  PRINT, TRANSPOSE(YP[11, *])


; When fish moves out the current cell, a within-cell location needs to be updated
; Movement in positive x-dimension  
xMoveOutPos = WHERE((xNewLocWithinCell GT 1.0), xMoveOutPoscount, complement = xMoveOutPosN, ncomplement = xMoveOutPosNcount)
IF xMoveOutPoscount GT 0.0 THEN xNewLocWithinCell[xMoveOutPos] = xNewLocWithinCell[xMoveOutPos] - FLOOR(xNewLocWithinCell[xMoveOutPos])
; Movement in negative x-dimension
xMoveOutNeg = WHERE((xNewLocWithinCell LT 0.0), xMoveOutNegcount, complement = xMoveOutNegN, ncomplement = xMoveOutNegNcount)
IF xMoveOutNegcount GT 0.0 THEN xNewLocWithinCell[xMoveOutNeg] = xNewLocWithinCell[xMoveOutNeg] + CEIL(ABS(xNewLocWithinCell[xMoveOutNeg])) 
;PRINT,'xMoveOutPos', xMoveOutPos
;PRINT,'xMoveOutNeg', xMoveOutNeg

; Movement in positive y-dimension 
yMoveOutPos = WHERE((yNewLocWithinCell GT 1.0), yMoveOutPoscount, complement = yMoveOutPosN, ncomplement = yMoveOutPosNcount)
IF yMoveOutPoscount GT 0.0 THEN yNewLocWithinCell[yMoveOutPos] = yNewLocWithinCell[yMoveOutPos] - FLOOR(yNewLocWithinCell[yMoveOutPos])
; Movement in negative y-dimension
yMoveOutNeg = WHERE((yNewLocWithinCell LT 0.0), yMoveOutNegcount, complement = yMoveOutNegN, ncomplement = yMoveOutNegNcount)
IF yMoveOutNegcount GT 0.0 THEN yNewLocWithinCell[yMoveOutNeg] = yNewLocWithinCell[yMoveOutNeg] + CEIL(ABS(yNewLocWithinCell[yMoveOutNeg]))  
;PRINT,'xMoveOutPos', xMoveOutPos
;PRINT,'xMoveOutNeg', xMoveOutNeg
  PRINT, 'New within-cell location in x-dimension in new cell '
  PRINT, xNewLocWithinCell
  PRINT, 'New within-cell location in y-dimension in new cell '
  PRINT, yNewLocWithinCell

  
;EnvironHVMax = FLTARR(nYP)
;EnvironHVMax2 = FLTARR(nYP)
;;EnvironHVMax3 = FLTARR(nYP)
;; Create array with highest habitat quality-based probability for fish
;FOR iv = 0L, nYP - 1L DO BEGIN
;;FOR ivv = iv, jv DO BEGIN 
;IF (TOTAL(EnvironHVSum[0:8, iv]) EQ 0.0) THEN BEGIN
;EnvironHVMax2[iv] = YP[13, iv]
;ENDIF ELSE BEGIN 
;EnvironHVMax[iv] = WHERE(MAX(EnvironHVSum[0:8, iv]) EQ EnvironHVSum[0:8, iv])
;;PRINT, 'EnvironVmax =', EnvironVMax[iv]
;EnvironHVMax2[iv] = NewGridXY[EnvironHVMax[iv], iv]
;ENDELSE
;ENDFOR
;PRINT, 'EnvironHVMax =', EnvironHVMax
;PRINT, 'EnvironHVMax2 ='
;PRINT, EnvironHVMax2; horizontal cell ID with max DO-based probablity 
;PRINT, 'YP[13, *]',    TRANSPOSE(YP[13, *])

;NewGridID2D = FLTARR(nYP)
;FOR ev = 0L, nYP - 1L DO BEGIN    
;    NewGridID2D[ev] = WHERE((EnvironHVMax2[ev] EQ newinput[3, *]) AND YP[12, ev] EQ newinput[2, *], NewXYloc2);
;ENDFOR

FishHorMove = FLTARR(4, nYP)
FishHorMove[0, *] = YP[13, *]; New horizontal cell ID
FishHorMove[1, *] = xNewLocWithinCell; New within-cell location in x-dimension in new cell
FishHorMove[2, *] = yNewLocWithinCell; New within-cell location in y-dimension in new cell

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Horizontal Movement Ends Here'
;RETURN, FishHorMove
END