FUNCTION ROGMoveH, ROG, nROG, newinput, Grid2D, DOacclim
;function determines movement in X,Y,Z direction for all ROUND GOBY
;**********This function works only for moveing to neiboring cells (wiht relatively large horizontal cells)***************************

;----------------------TEST ONLY---------------------------------------------------------------------------
;PRO ROGMoveH, ROG, nROG, newinput, Grid2D, DOacclim
;; NEED to change NewInputFiles, WAEinitial, WAEacclT, WAEacclDO for testing
;ts = 360L; 6 minutes
;nROG = 50L; number of SI
;ihour = 15L
;ROG = ROGinitial()
;newinput = newinputfiles()
;newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]
;length = FLTARR(nROG); fish length
;length = ROG[1, *]; in mm
;temp = ROG[19, *]; C
;Grid2D = GridCells2D()
;DOacclim = ROGacclDO()
;----------------------------------------------------------------------------------------------------------

PRINT, 'ROG Horizantal Movement Begins Here'
; Randomly determine movement
; Probability of movement in Z has to be greater than in X and Y due to cell size
; 
; NEED TO CHECK BOUNDARY CELLS AFTER THEY MOVE TO A NEW CELL
;******NO NEED TO IDENTIFY THE CURRENT CELL AND INCORPORATE 
;******Change * to 0 in row subscripting*********

;PRINT, 'Inital X', WAE[10, *]
;PRINT, 'Inital Y', WAE[11, *]
;PRINT, 'Inital Z', WAE[12, *]
;PRINT, 'Inital Horizontal ID', WAE[13, *]
;PRINT, 'Inital 3D ID', WAEYP[14, *]
;PRINT, 'Initial fish environment', WAE[15 : 24, *]

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

;NewX = fltarr(nWAE); new X location
;NX = fltarr(nWAE); holds temporary new x cell locations for fish that move
;NewY = fltarr(nWAE); new Y location
;NY = fltarr(nWAE); holds temporary new y cell locations for fish that move
;NewZ = fltarr(nWAE); new Z location

tstart = systime(/seconds)

;***How to make specific random normal distribution
; new_distribution = array * sigma + mean
;sigma = 0.5
;mean = 0.5
;array = RANDOMN(seed, nWAE, /DOUBLE)
;NewRandomn = array * sigma + mean
;PRINT, 'RANDOMN', array
;PRINT, 'NewRAMDOMN', NewRandomn
;***********************************

;;--Horizontal movement-----------------------------------------------------------------------------------------
; Randomly determine if fish will move out of cell -> NEED to change to environmental preference/quality- based
; MoveHor = (RANDOMU(seed, nWAE)); Pobability of horizontal RANDOM movement
; PRINT, 'MoveHor =', movehor

;*****Identify potential cell IDs in all 8 directions*******************************************
; Fish moves in the horizontal -> 8 possible cells to move
;      1 | 2 | 3          UP
;     -----------
;      4 | X | 5  LEFT         RIGHT
;     -----------
;      6 | 7 | 8         DOWN

LocH = FLTARR(27, nROG)
LocHV = FLTARR(9, nROG)
NewGridXY = FLTARR(9, nROG)
; 1 in X and Y dimensions
LocH[0, *] = ROG[10, *] - 1L
LocH[1, *] = ROG[11, *] + 1L
; 2
LocH[2, *] = ROG[10, *]
LocH[3, *] = ROG[11, *] + 1L
; 3
LocH[4, *] = ROG[10, *] + 1L
LocH[5, *] = ROG[11, *] + 1L
; 4
LocH[6, *] = ROG[10, *] - 1L
LocH[7, *] = ROG[11, *] 
; 5
LocH[8, *] = ROG[10, *] + 1L
LocH[9, *] = ROG[11, *] 
; 6
LocH[10, *] = ROG[10, *] - 1L
LocH[11, *] = ROG[11, *] - 1L
; 7
LocH[12, *] = ROG[10, *] 
LocH[13, *] = ROG[11, *] - 1L
; 8
LocH[14, *] = ROG[10, *] + 1L
LocH[15, *] = ROG[11, *] - 1L
; No move = the current cell
LocH[16, *] = ROG[10, *]
LocH[17, *] = ROG[11, *]
;PRINT, 'LocH', LocH[0:17, *]
;LocH[18, *] = WHERE((LocH[0, INDGEN(nYP)] EQ Grid2D[0, *]) AND (LocH[1, INDGEN(nYP)] EQ Grid2D[1, *]), NewXYloc1) 
;PRINT,'LocH[18, INDGEN(nYP)]', LocH[18, *];

FOR ihh = 0L, nROG - 1L DO BEGIN;********************Time-consuming part*********************************************************************
  LocH[18, ihh] = WHERE((LocH[0, ihh] EQ Grid2D[0, *]) AND (LocH[1, ihh] EQ Grid2D[1, *]), NewXYloc1) 
  LocH[19, ihh] = WHERE((LocH[2, ihh] EQ Grid2D[0, *]) AND (LocH[3, ihh] EQ Grid2D[1, *]), NewXYloc2) 
  LocH[20, ihh] = WHERE((LocH[4, ihh] EQ Grid2D[0, *]) AND (LocH[5, ihh] EQ Grid2D[1, *]), NewXYloc3) 
  LocH[21, ihh] = WHERE((LocH[6, ihh] EQ Grid2D[0, *]) AND (LocH[7, ihh] EQ Grid2D[1, *]), NewXYloc4) 
  LocH[22, ihh] = WHERE((LocH[8, ihh] EQ Grid2D[0, *]) AND (LocH[9, ihh] EQ Grid2D[1, *]), NewXYloc5) 
  LocH[23, ihh] = WHERE((LocH[10, ihh] EQ Grid2D[0, *]) AND (LocH[11, ihh] EQ Grid2D[1, *]), NewXYloc6) 
  LocH[24, ihh] = WHERE((LocH[12, ihh] EQ Grid2D[0, *]) AND (LocH[13, ihh] EQ Grid2D[1, *]), NewXYloc7) 
  LocH[25, ihh] = WHERE((LocH[14, ihh] EQ Grid2D[0, *]) AND (LocH[15, ihh] EQ Grid2D[1, *]), NewXYloc8) 
  LocH[26, ihh] = WHERE((LocH[16, ihh] EQ Grid2D[0, *]) AND (LocH[17, ihh] EQ Grid2D[1, *]), NewXloc9) 
  ;PRINT,'hhv', ihh, 'LocH[0, ihh]', LocH[0, ihh];,'Grid2D', Grid2D[0, LocH[0, ihh]], 'LocH[1, ihh]', LocH[1, ihh],'Grid2D', Grid2D[1, LocH[1, ihh]];, 'LocXY', LocXY

; Check if a grid cell exists
;****IF THE CELL DOES NOT EXIST WITHIN NEIBORING CELLS, FISH WILL STAY IN THE CURRENT CELL
  IF (LocH[18, ihh] GE 0.0) THEN NewGridXY[0, ihh] = LocH[18, ihh] ELSE NewGridXY[0, ihh] = ROG[13, ihh] 
  IF (LocH[19, ihh] GE 0.0) THEN NewGridXY[1, ihh] = LocH[19, ihh] ELSE NewGridXY[1, ihh] = ROG[13, ihh] 
  IF (LocH[20, ihh] GE 0.0) THEN NewGridXY[2, ihh] = LocH[20, ihh] ELSE NewGridXY[2, ihh] = ROG[13, ihh] 
  IF (LocH[21, ihh] GE 0.0) THEN NewGridXY[3, ihh] = LocH[21, ihh] ELSE NewGridXY[3, ihh] = ROG[13, ihh] 
  IF (LocH[22, ihh] GE 0.0) THEN NewGridXY[4, ihh] = LocH[22, ihh] ELSE NewGridXY[4, ihh] = ROG[13, ihh] 
  IF (LocH[23, ihh] GE 0.0) THEN NewGridXY[5, ihh] = LocH[23, ihh] ELSE NewGridXY[5, ihh] = ROG[13, ihh] 
  IF (LocH[24, ihh] GE 0.0) THEN NewGridXY[6, ihh] = LocH[24, ihh] ELSE NewGridXY[6, ihh] = ROG[13, ihh] 
  IF (LocH[25, ihh] GE 0.0) THEN NewGridXY[7, ihh] = LocH[25, ihh] ELSE NewGridXY[7, ihh] = ROG[13, ihh] 
  IF (LocH[26, ihh] GE 0.0) THEN NewGridXY[8, ihh] = LocH[26, ihh] ELSE NewGridXY[8, ihh] = ROG[13, ihh] 
  ;PRINT, 'NewGridXY[*, ihh]', NewGridXY[*, ihh]
;PRINT, 'LocH', LocH; NewInput[9, LocH1]
;PRINT, 'NewGridXY', NewGridXY

; NEED a previous vertical position of fish before the horizontal movemnent
; FOR ihhh = 0L, nYP - 1L DO BEGIN
  LocHV[0, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[0, ihh] EQ NewInput[3, *]), NewXYZloc1)
  LocHV[1, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[1, ihh] EQ NewInput[3, *]), NewXYZloc2)
  LocHV[2, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[2, ihh] EQ NewInput[3, *]), NewXYZloc3)
  LocHV[3, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[3, ihh] EQ NewInput[3, *]), NewXYZloc4)
  LocHV[4, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[4, ihh] EQ NewInput[3, *]), NewXYZloc5)
  LocHV[5, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[5, ihh] EQ NewInput[3, *]), NewXYZloc6)
  LocHV[6, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[6, ihh] EQ NewInput[3, *]), NewXYZloc7)
  LocHV[7, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (NewGridXY[7, ihh] EQ NewInput[3, *]), NewXYZloc8)
  LocHV[8, ihh] = WHERE((ROG[12, ihh] EQ NewInput[2, *]) AND (ROG[13, ihh] EQ NewInput[3, *]), NewXYZloc9)
  ;LocHV[10, ihh] = WHERE((YP[12, ihh] EQ NewInput[2, *]) AND (LocH[0, ihh] EQ NewInput[0, *]) AND (LocH[1, ihh] EQ NewInput[1, *]), NewXYZloc10)
; PRINT, 'LocHV[0, ihh]', LocLocHV[0, ihh], 'LocHV[10, ihh]', LocHV[10, ihh] 
ENDFOR;**************************************************************************************************************************

;PRINT, 'NewInput[3, *]', NewInput[3, *]
;PRINT, 'NewGridXY', NewGridXY
;PRINT, 'LocHV', LocHV

; Determine habitat quality of neiboring cells
; ******NEED TO AGGREGATE ZOOPLANKTON AND NO BETHTTREPHE*******

EnvironHV = FLTARR(77, nROG)
; Environmental conditions in 1
;EnvironHV[0:2, *] = newinput[5:7, LocHV[0, *]]; zoopl
;EnvironHV[3, *] = newinput[8, LocHV[0, *]]; bentho
;EnvironHV[4, *] = newinput[9, LocHV[0, *]]; amb temp 
;EnvironHV[5, *] = newinput[10, LocHV[0, *]]; ambDO
;EnvironHV[6, *] = 0.0; Bethotrephe
;EnvironHV[7, *] = 0.0; fish
;EnvironHV[0:5, *] = newinput[5:10, LocHV[0, *]]; all
;PRINT, 'EnvironHV[0:5, *]', EnvironHV[0:5, *]

; Environmental conditions in 2
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

; Environmental conditions in 4
EnvironHV[22:24, *] = newinput[5:7, LocHV[3, *]]; zoopl
EnvironHV[25, *] = newinput[8, LocHV[3, *]]; bentho
EnvironHV[26, *] = newinput[9, LocHV[3, *]]; amb temp 
EnvironHV[27, *] = newinput[10, LocHV[3, *]]; ambDO
EnvironHV[28, *] = 0.0; Bethotrephe
EnvironHV[29, *] = 0.0; fish
EnvironHV[22:27, *] = newinput[5:10, LocHV[3, *]]; all
;PRINT, 'EnvironHV[22:27, *]', EnvironHV[22:27, *]

; Environmental conditions in 5
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

; Environmental conditions in 7
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

; Environmental conditions in X = the current cell
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

DOf1 = fltarr(9, nROG)
DOf2 = fltarr(9, nROG)
DOf3 = fltarr(9, nROG)
DOf = fltarr(9, nROG)
Tf = fltarr(9, nROG)
;DO
FOR ihe = 0L, nROG - 1L DO BEGIN
;DOacclim[14,*] = DOacC1; from acclDO, array locations of individuals who are in cells with DOaccl < DOcrit&minDOcrit
;DOacclim[15,*] = DOacC2; from acclDO, array locations of individuals who are in cells with minDOcrit < DOaccl < DOcrit
;DOacclim[16,*] = DOacC3; from acclDO, locations of individuals who are in cells with DOaccl > DOcrit
; WHEN ambient DO is below the critical DO...
  DOf1[1, ihe] = WHERE(EnvironHV[13, ihe] LT DOacclim[7, ihe], DOf1count2)
  ;DOf1[2, ihe] = WHERE(EnvironHV[19, ihe] LT DOacclim[7, ihe], DOf1count3)
  DOf1[3, ihe] = WHERE(EnvironHV[27, ihe] LT DOacclim[7, ihe], DOf1count4)
  DOf1[4, ihe] = WHERE(EnvironHV[35, ihe] LT DOacclim[7, ihe], DOf1count5)
  ;DOf1[5, ihe] = WHERE(EnvironHV[43, ihe] LT DOacclim[7, ihe], DOf1count6)
  DOf1[6, ihe] = WHERE(EnvironHV[51, ihe] LT DOacclim[7, ihe], DOf1count7)
  ;DOf1[7, ihe] = WHERE(EnvironHV[59, ihe] LT DOacclim[7, ihe], DOf1count8)
  DOf1[8, ihe] = WHERE(EnvironHV[67, ihe] LT DOacclim[7, ihe], DOf1count9)
  ;IF DOf1count1 GT 0.0 THEN DOf[0, ihe] = 0.0; 
  IF DOf1count2 GT 0.0 THEN DOf[1, ihe] = 0.0
  ;IF DOf1count3 GT 0.0 THEN DOf[2, ihe] = 0.0;
  IF DOf1count4 GT 0.0 THEN DOf[3, ihe] = 0.0;
  IF DOf1count5 GT 0.0 THEN DOf[4, ihe] = 0.0;
  ;IF DOf1count6 GT 0.0 THEN DOf[5, ihe] = 0.0;  
  IF DOf1count7 GT 0.0 THEN DOf[6, ihe] = 0.0;  
  ;IF DOf1count8 GT 0.0 THEN DOf[7, ihe] = 0.0; 
  IF DOf1count9 GT 0.0 THEN DOf[8, ihe] = 0.0; 
  ;PRINT, 'DOf', DOf

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
  ;IF DOf2count1 GT 0.0 THEN DOf[0, ihe] = ((EnvironHV[5, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count2 GT 0.0 THEN DOf[1, ihe] = ((EnvironHV[13, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count3 GT 0.0 THEN DOf[2, ihe] = ((EnvironHV[19, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count4 GT 0.0 THEN DOf[3, ihe] = ((EnvironHV[27, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count5 GT 0.0 THEN DOf[4, ihe] = ((EnvironHV[35, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count6 GT 0.0 THEN DOf[5, ihe] = ((EnvironHV[43, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count7 GT 0.0 THEN DOf[6, ihe] = ((EnvironHV[51, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  ;IF DOf2count8 GT 0.0 THEN DOf[7, ihe] = ((EnvironHV[59, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  IF DOf2count9 GT 0.0 THEN DOf[8, ihe] = ((EnvironHV[67, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
  
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
  ;IF DOf3count1 GT 0.0 THEN DOf[0, ihe] = 1.0
  IF DOf3count2 GT 0.0 THEN DOf[1, ihe] = 1.0
  ;IF DOf3count3 GT 0.0 THEN DOf[2, ihe] = 1.0
  IF DOf3count4 GT 0.0 THEN DOf[3, ihe] = 1.0
  IF DOf3count5 GT 0.0 THEN DOf[4, ihe] = 1.0
  ;IF DOf3count6 GT 0.0 THEN DOf[5, ihe] = 1.0
  IF DOf3count7 GT 0.0 THEN DOf[6, ihe] = 1.0
  ;IF DOf3count8 GT 0.0 THEN DOf[7, ihe] = 1.0
  IF DOf3count9 GT 0.0 THEN DOf[8, ihe] = 1.0
ENDFOR

  ; temperature
  TL = WHERE(length LT 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
  ;IF (TLcount GT 0.0) THEN BEGIN
  CTO = 24.648; Optimal temperture for consumption
  CTM = 25.706;  Maximum temperture for consumption
;  ENDIF ;ELSE BEGIN
;  IF (TLLcount GT 0.0) THEN BEGIN 
;  CTO = 22L; Optimal temperture for consumption
;  CTM = 28L;  Maximum temperture for consumption
;  ENDIF ;ELSE BEGIN
  ;Tf1 = WHERE(EnvironHV[4, *] GE CTM, Tfcount1)
  Tf2 = WHERE(EnvironHV[12, *] GE CTM, Tfcount2)
  ;Tf3 = WHERE(EnvironHV[18, *] GE CTM, Tfcount3)
  Tf4 = WHERE(EnvironHV[26, *] GE CTM, Tfcount4)
  Tf5 = WHERE(EnvironHV[34, *] GE CTM, Tfcount5)
  ;Tf6 = WHERE(EnvironHV[42, *] GE CTM, Tfcount6)
  Tf7 = WHERE(EnvironHV[50, *] GE CTM, Tfcount7)
  ;Tf8 = WHERE(EnvironHV[58, *] GE CTM, Tfcount8)
  Tf9 = WHERE(EnvironHV[66, *] GE CTM, Tfcount9)
  ;IF Tfcount1 GT 0.0 THEN Tf[0, Tf1] = 0.0
  IF Tfcount2 GT 0.0 THEN Tf[1, Tf2] = 0.0
  ;IF Tfcount3 GT 0.0 THEN Tf[2, Tf3] = 0.0
  IF Tfcount4 GT 0.0 THEN Tf[3, Tf4] = 0.0
  IF Tfcount5 GT 0.0 THEN Tf[4, Tf5] = 0.0
  ;IF Tfcount6 GT 0.0 THEN Tf[5, Tf6] = 0.0
  IF Tfcount7 GT 0.0 THEN Tf[6, Tf7] = 0.0
  ;IF Tfcount8 GT 0.0 THEN Tf[7, Tf8] = 0.0
  IF Tfcount9 GT 0.0 THEN Tf[8, Tf9] = 0.0
  
  ;Tf1b = WHERE((EnvironHV[4, *] GT CTO) AND (EnvironHV[4, *] LT CTM), Tfcount1b)
  Tf2b = WHERE((EnvironHV[12, *] GT CTO) AND (EnvironHV[12, *] LT CTM), Tfcount2b)
  ;Tf3b = WHERE((EnvironHV[18, *] GT CTO) AND (EnvironHV[18, *] LT CTM), Tfcount3b)
  Tf4b = WHERE((EnvironHV[26, *] GT CTO) AND (EnvironHV[26, *] LT CTM), Tfcount4b)
  Tf5b = WHERE((EnvironHV[34, *] GT CTO) AND (EnvironHV[34, *] LT CTM), Tfcount5b)
  ;Tf6b = WHERE((EnvironHV[42, *] GT CTO) AND (EnvironHV[42, *] LT CTM), Tfcount6b)
  Tf7b = WHERE((EnvironHV[50, *] GT CTO) AND (EnvironHV[50, *] LT CTM), Tfcount7b)
  ;Tf8b = WHERE((EnvironHV[58, *] GT CTO) AND (EnvironHV[58, *] LT CTM), Tfcount8b)
  Tf9b = WHERE((EnvironHV[66, *] GT CTO) AND (EnvironHV[66, *] LT CTM), Tfcount9b)
  ;IF Tfcount1b GT 0.0 THEN Tf[0, Tf1b] = ((CTM - EnvironHV[4,  Tf1b])/(CTM - CTO))
  IF Tfcount2b GT 0.0 THEN Tf[1, Tf2b] = ((CTM - EnvironHV[12, Tf2b])/(CTM - CTO))
  ;IF Tfcount3b GT 0.0 THEN Tf[2, Tf3b] = ((CTM - EnvironHV[18, Tf3b])/(CTM - CTO))
  IF Tfcount4b GT 0.0 THEN Tf[3, Tf4b] = ((CTM - EnvironHV[26, Tf4b])/(CTM - CTO))
  IF Tfcount5b GT 0.0 THEN Tf[4, Tf5b] = ((CTM - EnvironHV[34, Tf5b])/(CTM - CTO))
  ;IF Tfcount6b GT 0.0 THEN Tf[5, Tf6b] = ((CTM - EnvironHV[42, Tf6b])/(CTM - CTO))
  IF Tfcount7b GT 0.0 THEN Tf[6, Tf7b] = ((CTM - EnvironHV[50, Tf7b])/(CTM - CTO))
  ;IF Tfcount8b GT 0.0 THEN Tf[7, Tf8b] = ((CTM - EnvironHV[58, Tf8b])/(CTM - CTO))
  IF Tfcount9b GT 0.0 THEN Tf[8, Tf9b] = ((CTM - EnvironHV[66, Tf9b])/(CTM - CTO))

  ;Tf1c = WHERE(EnvironHV[4, *] LE CTO, Tfcount1c)
  Tf2c = WHERE(EnvironHV[12, *] LE CTO, Tfcount2c)
  ;Tf3c = WHERE(EnvironHV[18, *] LE CTO, Tfcount3c)
  Tf4c = WHERE(EnvironHV[26, *] LE CTO, Tfcount4c)
  Tf5c = WHERE(EnvironHV[34, *] LE CTO, Tfcount5c)
  ;Tf6c = WHERE(EnvironHV[42, *] LE CTO, Tfcount6c)
  Tf7c = WHERE(EnvironHV[50, *] LE CTO, Tfcount7c)
  ;Tf8c = WHERE(EnvironHV[58, *] LE CTO, Tfcount8c)
  Tf9c = WHERE(EnvironHV[66, *] LE CTO, Tfcount9c)
  ;IF Tfcount1c GT 0.0 THEN Tf[0, Tf1c] = 1.0  
  IF Tfcount2c GT 0.0 THEN Tf[1, Tf2c] = 1.0  
  ;IF Tfcount3c GT 0.0 THEN Tf[2, Tf3c] = 1.0  
  IF Tfcount4c GT 0.0 THEN Tf[3, Tf4c] = 1.0  
  IF Tfcount5c GT 0.0 THEN Tf[4, Tf5c] = 1.0  
  ;IF Tfcount6c GT 0.0 THEN Tf[5, Tf6c] = 1.0  
  IF Tfcount7c GT 0.0 THEN Tf[6, Tf7c] = 1.0  
  ;IF Tfcount8c GT 0.0 THEN Tf[7, Tf8c] = 1.0  
  IF Tfcount9c GT 0.0 THEN Tf[8, Tf9c] = 1.0  
 ;PRINT, 'Tf', Tf
;PRINT, 'NewGridID3D2 =', NewGridID3D2 

EnvironHVDO = FLTARR(9, nROG)
EnvironHVT = FLTARR(9, nROG)

EnvironHVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[8, *] = DOUBLE(DOf[8, *] * RANDOMU(seed, nROG, /DOUBLE))

;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component
;EnvironHVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[7, *] = DOUBLE(Tf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[8, *] = DOUBLE(Tf[8, *] * RANDOMU(seed, nROG, /DOUBLE))
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

  ;prey weight
  PW = FLTARR(m); weight of each prey type
  ; assign weights to each prey type in g
  Pw[0] = 0.182 / 1000000.0; rotifers in g from Letcher 
  Pw[1] = 4.988 / 1000000.0; copepods in g from Letcher
  Pw[2] = 4.988 / 1000000.0; cladocerans in g MADE UP!!!
  Pw[3] = 0.001; chironomids in g MADE UP!!!!
  Pw[4] = 0.001; 60 / 1000000; bythotrephes in g, 500 to 700,~600ug dry = 6000 ug wet
  Pw[5] = 0.003; 42.9 / 1000000; fish in g MADE UP!!!
  ;PRINT, 'PW =', pw
  
  ;convert prey biomass (g/L or m^2) into numbers/L or m^2
  dens = fltarr(m*9L, nROG)
  ;dens[0,*] = EnvironHV[0, *] / Pw[0]; for rotifer 
  dens[1,*] = EnvironHV[8, *] / Pw[0]
  ;dens[2,*] = EnvironHV[14, *] / Pw[0]
  dens[3,*] = EnvironHV[22, *] / Pw[0]
  dens[4,*] = EnvironHV[30, *] / Pw[0]
  ;dens[5,*] = EnvironHV[38, *] / Pw[0]
  dens[6,*] = EnvironHV[46, *] / Pw[0]
  ;dens[7,*] = EnvironHV[54, *] / Pw[0]
  dens[8,*] = EnvironHV[62, *] / Pw[0]
  
  ;dens[9,*] = EnvironHV[1, *] / Pw[1]; for copepod
  dens[10,*] = EnvironHV[9, *] / Pw[1]
  ;dens[11,*] = EnvironHV[15, *] / Pw[1]
  dens[12,*] = EnvironHV[23, *] / Pw[1]
  dens[13,*] = EnvironHV[31, *] / Pw[1]
  ;dens[14,*] = EnvironHV[39, *] / Pw[1]
  dens[15,*] = EnvironHV[47, *] / Pw[1]
  ;dens[16,*] = EnvironHV[55, *] / Pw[1]
  dens[17,*] = EnvironHV[63, *] / Pw[1]
  
  ;dens[18,*] = EnvironHV[2, *] / Pw[2]; for cladocerans
  dens[19,*] = EnvironHV[10, *] / Pw[2]
  ;dens[20,*] = EnvironHV[16, *] / Pw[2]
  dens[21,*] = EnvironHV[24, *] / Pw[2]
  dens[22,*] = EnvironHV[32, *] / Pw[2]
  ;dens[23,*] = EnvironHV[40, *] / Pw[2]
  dens[24,*] = EnvironHV[48, *] / Pw[2]
  ;dens[25,*] = EnvironHV[56, *] / Pw[2]
  dens[26,*] = EnvironHV[64, *] / Pw[2]
  
  ;pbio3a = WHERE(EnvironHV[3, *] GT 0.0, pbio3acount, complement = pbio3ac, ncomplement = pbio3account)
  ;IF pbio3acount GT 0.0 THEN dens[27, pbio3a] = EnvironHV[3, pbio3a] / Pw[3] ELSE dens[27, pbio3ac] = 0.0; numbers/m^2 for chironmoid
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
  
  ;dens[36,*] = EnvironHV[6, *] / Pw[4]; for bythotrephes 
  dens[37,*] = EnvironHV[14, *] / Pw[4]
  ;dens[38,*] = EnvironHV[20, *] / Pw[4]
  dens[39,*] = EnvironHV[28, *] / Pw[4]
  dens[40,*] = EnvironHV[36, *] / Pw[4]
  ;dens[41,*] = EnvironHV[44, *] / Pw[4]
  dens[42,*] = EnvironHV[52, *] / Pw[4]
  ;dens[43,*] = EnvironHV[60, *] / Pw[4]
  dens[44,*] = EnvironHV[68, *] / Pw[4]
  
  ;dens[45,*] = EnvironHV[7, *] / Pw[5]; for fish
  dens[46,*] = EnvironHV[15, *] / Pw[5]
  ;dens[47,*] = EnvironHV[21, *] / Pw[5]
  dens[48,*] = EnvironHV[29, *] / Pw[5]
  dens[49,*] = EnvironHV[37, *] / Pw[5]
  ;dens[50,*] = EnvironHV[45, *] / Pw[5]
  dens[51,*] = EnvironHV[53, *] / Pw[5]
  ;dens[52,*] = EnvironHV[61, *] / Pw[5]
  dens[53,*] = EnvironHV[69, *] / Pw[5]
  ;PRINT, 'Density =', dens

; Calculate Chesson's alpha for each prey type; YP[1, *]
;*************MAY NEED TO CHANGE FOR WALLEYE**********************************
  Calpha = FLTARR(m, nROG)
  Calpha[0, *] = 193499 * ROG[1, *]^(-7.64); for rotifers
  Calpha[1, *] = 0.272 * ALOG(ROG[1, *]) - 0.3834; for calanoids
  Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * ROG[1, *]))^(1.0 / 0.031) ; for cladocerans
  PL3 = WHERE((PL[3] / ROG[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
  IF (pl3count GT 0.0) THEN Calpha[3,*] = ABS(0.50 - 1.75 * (PL[3,*] / ROG[1, *])) $
  ELSE Calpha[3,*] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 
  Length4 = WHERE(ROG[1, *] GT 60.0, L4count, complement = L4c, ncomplement = L4ccount)
  IF (L4count GT 0.0) THEN Calpha[4,*] = 0.001 $; for bythotrephes CHANGE!!! with Rainbow smelt from Barnhisel and Harvey
  ELSE Calpha[4,*] = 0.00
  PL5a = WHERE((PL[5] / ROG[1, *]) LT 0.20, pl5acount, complement = pl5ac, ncomplement = pl5account)
  IF (pl5acount GT 0.0) THEN Calpha[5,*] = 0.25 $ ; NEED A FUNCTION, 0.5 - 1.75 * length $
  ELSE Calpha[5,*] = 0.00 ; for fish
  ;PRINT, 'Calpha =', Calpha
  
; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(9, nROG); total number of all prey atacked and captured
  t = FLTARR(m*9, nROG); total number of each prey atacked and captured
  ;t[0,*] = (Calpha[0,*] * dens[0,*])
  t[1,*] = (Calpha[0,*] * dens[1,*])
  ;t[2,*] = (Calpha[0,*] * dens[2,*])
  t[3,*] = (Calpha[0,*] * dens[3,*])
  t[4,*] = (Calpha[0,*] * dens[4,*])
  ;t[5,*] = (Calpha[0,*] * dens[5,*])
  t[6,*] = (Calpha[0,*] * dens[6,*])
  ;t[7,*] = (Calpha[0,*] * dens[7,*])
  t[8,*] = (Calpha[0,*] * dens[8,*])
       
  ;t[9,*] = (Calpha[1,*] * dens[9,*])
  t[10,*] = (Calpha[1,*] * dens[10,*])
  ;t[11,*] = (Calpha[1,*] * dens[11,*])
  t[12,*] = (Calpha[1,*] * dens[12,*])
  t[13,*] = (Calpha[1,*] * dens[13,*])
  ;t[14,*] = (Calpha[1,*] * dens[14,*])
  t[15,*] = (Calpha[1,*] * dens[15,*])
  ;t[16,*] = (Calpha[1,*] * dens[16,*])
  t[17,*] = (Calpha[1,*] * dens[17,*])
      
  ;t[18,*] = (Calpha[2,*] * dens[18,*])
  t[19,*] = (Calpha[2,*] * dens[19,*])
  ;t[20,*] = (Calpha[2,*] * dens[20,*])
  t[21,*] = (Calpha[2,*] * dens[21,*])
  t[22,*] = (Calpha[2,*] * dens[22,*])
  ;t[23,*] = (Calpha[2,*] * dens[23,*])
  t[24,*] = (Calpha[2,*] * dens[24,*])
  ;t[25,*] = (Calpha[2,*] * dens[25,*])
  t[26,*] = (Calpha[2,*] * dens[26,*])
      
  ;t[27,*] = (Calpha[3,*] * dens[27,*])
  t[28,*] = (Calpha[3,*] * dens[28,*])
  ;t[29,*] = (Calpha[3,*] * dens[29,*])
  t[30,*] = (Calpha[3,*] * dens[30,*])
  t[31,*] = (Calpha[3,*] * dens[31,*])
  ;t[32,*] = (Calpha[3,*] * dens[32,*])
  t[33,*] = (Calpha[3,*] * dens[33,*])
  ;t[34,*] = (Calpha[3,*] * dens[34,*])
  t[35,*] = (Calpha[3,*] * dens[35,*])
      
  ;t[36,*] = (Calpha[4,*] * dens[36,*])
  t[37,*] = (Calpha[4,*] * dens[37,*])
  ;t[38,*] = (Calpha[4,*] * dens[38,*])
  t[39,*] = (Calpha[4,*] * dens[39,*])
  t[40,*] = (Calpha[4,*] * dens[40,*])
  ;t[41,*] = (Calpha[4,*] * dens[41,*])
  t[42,*] = (Calpha[4,*] * dens[42,*])
  ;t[43,*] = (Calpha[4,*] * dens[43,*])
  t[44,*] = (Calpha[4,*] * dens[44,*])
      
  ;t[45,*] = (Calpha[5,*] * dens[45,*])
  t[46,*] = (Calpha[5,*] * dens[46,*])
  ;t[47,*] = (Calpha[5,*] * dens[47,*])
  t[48,*] = (Calpha[5,*] * dens[48,*])
  t[49,*] = (Calpha[5,*] * dens[49,*])
  ;t[50,*] = (Calpha[5,*] * dens[50,*])
  t[51,*] = (Calpha[5,*] * dens[51,*])
  ;t[52,*] = (Calpha[5,*] * dens[52,*])
  t[53,*] = (Calpha[5,*] * dens[53,*])
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

; Calculate cumulative prey biomass for each NEIGHBORING layer 
; And copy cumulative prey biomass to all NEIGHBORING cells
preyTOT = FLTARR(nROG)
preyTOT2 = FLTARR(9, nROG)
;prey = INDGEN(nYP)
FOR ivvv = 0L, nROG - 1L DO BEGIN
preyTOT[ivvv] = TOTAL(TOT[0:8, ivvv])  
;ENDFOR
;FOR iii = 0L, nYP - 1L DO BEGIN
preyTOT2[0:8, ivvv] = preyTOT[ivvv]
ENDFOR
;PRINT, 'preyTOT =', preyTOT
;preyTOT[0] = TOTAL(TOT[0:8, 0]) 
;PRINT, 'preyTOT2 =', preyTOT2
;PRINT, 'tot =', TOT

EnvironHVprey = FLTARR(9, nROG)
;EnvironHVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[7, *] = (TOT[7, *] / preyTOT2[7, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[8, *] = (TOT[8, *] / preyTOT2[8, *]) * RANDOMU(seed, nROG, /DOUBLE)
;PRINT, 'EnvironHVprey =', EnvironHVprey

EnvironHVSum = FLTARR(9, nROG)
;EnvironHVSum[0, *] = DOUBLE((EnvironHVDO[0, *] * EnvironHVT[0, *] * EnvironHVprey[0, *])^(1.0/3.0))
EnvironHVSum[1, *] = DOUBLE((EnvironHVDO[1, *] * EnvironHVT[1, *] * EnvironHVprey[1, *])^(1.0/3.0))
;EnvironHVSum[2, *] = DOUBLE((EnvironHVDO[2, *] * EnvironHVT[2, *] * EnvironHVprey[2, *])^(1.0/3.0))
EnvironHVSum[3, *] = DOUBLE((EnvironHVDO[3, *] * EnvironHVT[3, *] * EnvironHVprey[3, *])^(1.0/3.0))
EnvironHVSum[4, *] = DOUBLE((EnvironHVDO[4, *] * EnvironHVT[4, *] * EnvironHVprey[4, *])^(1.0/3.0))
;EnvironHVSum[5, *] = DOUBLE((EnvironHVDO[5, *] * EnvironHVT[5, *] * EnvironHVprey[5, *])^(1.0/3.0))
EnvironHVSum[6, *] = DOUBLE((EnvironHVDO[6, *] * EnvironHVT[6, *] * EnvironHVprey[6, *])^(1.0/3.0))
;EnvironHVSum[7, *] = DOUBLE((EnvironHVDO[7, *] * EnvironHVT[7, *] * EnvironHVprey[7, *])^(1.0/3.0))
EnvironHVSum[8, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[8, *])^(1.0/3.0))
PRINT, 'EnvironHVSum'
PRINT, EnvironHVSum

; Movement in x-dimension -> cells 4 & 5
; Movement in y-dimension -> cells 2 & 7
; fish could also end up in cells 1, 3, 6, and 8, depending on the within-cell locations
; If the current cell is best among neiboring cells, fish will move within the cell randomly.

; Movement in x-dimension
xMove = FLTARR(nROG)
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
yMove = FLTARR(nROG)
; move to cell 2 
yMovePos = WHERE((EnvironHVSum[1, *] GT EnvironHVSum[6, *]) AND (EnvironHVSum[1, *] GT EnvironHVSum[8, *]), yMovePoscount, complement = yMovePosN, ncomplement = yMovePosNcount)
IF yMovePoscount GT 0.0 THEN yMove[yMovePos] = 2
; move to cell 7 
yMoveNeg = WHERE((EnvironHVSum[1, *] LT EnvironHVSum[6, *]) AND (EnvironHVSum[6, *] GT EnvironHVSum[8, *]), yMoveNegcount, complement = yMoveNegN, ncomplement = yMoveNegNcount)
IF yMoveNegcount GT 0.0 THEN yMove[yMoveNeg] = 7
; stay
yMoveNon = WHERE((EnvironHVSum[8, *] GE EnvironHVSum[1, *]) AND (EnvironHVSum[8, *] GE EnvironHVSum[6, *]), yMoveNoncount, complement = yMoveNonN, ncomplement = yMoveNonNcount)
IF yMoveNoncount GT 0.0 THEN yMove[yMoveNon] = 9
;PRINT, 'xMovePos', yMovePos
;PRINT, 'xMoveNeg', yMoveNeg
;PRINT, 'xMoveNon', yMoveNon
PRINT, 'yMove', yMove

  
  ; 1. *******Determine the movement orientation****************************************************
  ; For now, each cell is assumed to have gradients between the current and neiboring cells
  ; fish are able to detect gradients within a cetain range
  HorOriAng = FLTARR(nROG)
 ;TEST ONLY**************************************************************************************
  ;HorOriAng = 45.; horizontal movement orientation angle
  VerOriAng = 90.; vertical movement orientation angle
  ;***********************************************************************************************
;X-Y plane 1
xyMoveOri1 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] GT EnvironHVSum[1, *])), xyMoveOri1count, complement = xyMoveOri1N, ncomplement = xyMoveOri1Ncount)
xyMoveOri2 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] LT EnvironHVSum[1, *])), xyMoveOri2count, complement = xyMoveOri2N, ncomplement = xyMoveOri2Ncount)
IF (xyMoveOri1count GT 0.0) THEN HorOriAng[xyMoveOri1] = 22.5
IF (xyMoveOri2count GT 0.0) THEN HorOriAng[xyMoveOri2] = 67.5
;;X-Y plane 2
xyMoveOri3 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] LT EnvironHVSum[1, *])), xyMoveOri3count, complement = xyMoveOri3N, ncomplement = xyMoveOri3Ncount)
xyMoveOri4 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] GT EnvironHVSum[1, *])), xyMoveOri4count, complement = xyMoveOri4N, ncomplement = xyMoveOri4Ncount)

IF (xyMoveOri3count GT 0.0) THEN HorOriAng[xyMoveOri3] = 22.5+90.
IF (xyMoveOri4count GT 0.0) THEN HorOriAng[xyMoveOri4] = 67.5+90.
;;X-Y plane 3
xyMoveOri5 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] GT EnvironHVSum[6, *])), xyMoveOri5count, complement = xyMoveOri5N, ncomplement = xyMoveOri5Ncount)
xyMoveOri6 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] LT EnvironHVSum[6, *])), xyMoveOri6count, complement = xyMoveOri6N, ncomplement = xyMoveOri6Ncount)

IF (xyMoveOri5count GT 0.0) THEN HorOriAng[xyMoveOri5] = 22.5+180.
IF (xyMoveOri6count GT 0.0) THEN HorOriAng[xyMoveOri6] = 67.5+180.
;;X-Y plane 4
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
PRINT,'HorOriAng', HorOriAng
PRINT, 'COS(HorOriAng)', COS(HorOriAng)
PRINT, 'SIN(HorOriAng)', SIN(HorOriAng)

  ; Determine the distance and direction fish move uisng the habitat quality values estimated above
; Calculate fish swimming speed, S, in body lengths/sec
  ;PRINT, 'Length'
  ;PRINT, Length
  SS = FLTARR(nROG)
  S = FLTARR(nROG)
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
  PRINT, 'Swimming speed (mm/s) ='
  PRINT, SS
  PRINT, 'Swimming speed in x-dimension (mm/s) ='
  PRINT, SS*COS(HorOriAng); * SIN(VerOriAng)
  PRINT, 'Swimming speed in y-dimension (mm/s) ='
  PRINT, SS*SIN(HorOriAng); * SIN(VerOriAng)
;  ;PRINT, 'Swimming speed in Z-dimension (mm/s) =', SS*COS(VerOriAng)
  PRINT, 'Water currents (mm/s) xyz'
  PRINT, newinput[12:15, ROG[14, *]]

  ; Calculate realized swimming speed (mm/s) in xyz-dimensions
  MoveSpeed = FLTARR(5, nROG)
  MoveSpeed[0, *] = SS * COS(HorOriAng) * RANDOMU(seed, nROG, /DOUBLE) + newinput[12, ROG[14, *]]; with a random comopnent
  MoveSpeed[1, *] = SS * SIN(HorOriAng) * RANDOMU(seed, nROG, /DOUBLE) + newinput[13, ROG[14, *]];
  ;MoveSpeed[2, *] = SS*COS(VerOriAng) + newinput[14, YP[14, *]]
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
  xNewLoc = MoveSpeed[0, *]*ts; distance (mm) in x-dimension
  yNewLoc = MoveSpeed[1, *]*ts; distance (mm) in y-dimension
  
  ;***********************************************************************************
  xOldLocWithinCell = FLTARR(nROG); TEST ONLY 
  yOldLocWithinCell = FLTARR(nROG); TEST ONLY
  xOldLocWithinCell[*] = 0.7; TEST ONLY, updated within-cell location from YEP initial
  yOldLocWithinCell[*] = 0.7; TEST ONLY, updated within-cell location from YEP initial
  ;***********************************************************************************
  
  xNewLocWithinCell = FLTARR(nROG)
  yNewLocWithinCell = FLTARR(nROG)
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
  PRINT, 'Realized distance traveled in x-dimension per time step '
  PRINT, xNewLoc
  PRINT, 'Realized distance traveled in y-dimension per time step '
  PRINT, yNewLoc
  PRINT, 'Realized proportional distance traveled in x-dimension per time step '
  PRINT, xNewLocWithinCell
  PRINT, 'Realized proportional distance traveled in y-dimension per time step '
  PRINT, yNewLocWithinCell
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
;  PRINT, 'YP[10, *]'
;  PRINT, TRANSPOSE(YP[10, *])
;  PRINT, 'YP[11, *]'
;  PRINT, TRANSPOSE(YP[11, *])
  
; *****Determine new cell locations****************************************************************************************
xyMoveOut1 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut1count, complement = xyMoveOut1N, ncomplement = xyMoveOut1Ncount)
IF xyMoveOut1count GT 0.0 THEN ROG[13, xyMoveOut1] = NewGridXY[0, xyMoveOut1]
;PRINT,'xyMoveOut1', xyMoveOut1
xyMoveOut2 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut2count, complement = xyMoveOut2N, ncomplement = xyMoveOut2Ncount)
IF xyMoveOut2count GT 0.0 THEN ROG[13, xyMoveOut2] = NewGridXY[1, xyMoveOut2]
;PRINT,'xyMoveOut2', xyMoveOut2
xyMoveOut3 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut3count, complement = xyMoveOut3N, ncomplement = xyMoveOut3Ncount)
IF xyMoveOut3count GT 0.0 THEN ROG[13, xyMoveOut3] = NewGridXY[2, xyMoveOut3]
;PRINT,'xyMoveOut3', xyMoveOut3
xyMoveOut4 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut4count, complement = xyMoveOut4N, ncomplement = xyMoveOut4Ncount)
IF xyMoveOut4count GT 0.0 THEN ROG[13, xyMoveOut4] = NewGridXY[3, xyMoveOut4]
;PRINT,'xyMoveOut4', xyMoveOut4
xyMoveOut5 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut5count, complement = xyMoveOut5N, ncomplement = xyMoveOut5Ncount)
IF xyMoveOut5count GT 0.0 THEN ROG[13, xyMoveOut5] = NewGridXY[4, xyMoveOut5]
;PRINT,'xyMoveOut5', xyMoveOut5
xyMoveOut6 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut6count, complement = xyMoveOut6N, ncomplement = xyMoveOut6Ncount)
IF xyMoveOut6count GT 0.0 THEN ROG[13, xyMoveOut6] = NewGridXY[5, xyMoveOut6]
;PRINT,'xyMoveOut6', xyMoveOut6
xyMoveOut7 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut7count, complement = xyMoveOut7N, ncomplement = xyMoveOut7Ncount)
IF xyMoveOut7count GT 0.0 THEN ROG[13, xyMoveOut7] = NewGridXY[6, xyMoveOut7]
;PRINT,'xyMoveOut7', xyMoveOut7
xyMoveOut8 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut8count, complement = xyMoveOut8N, ncomplement = xyMoveOut8Ncount)
IF xyMoveOut8count GT 0.0 THEN ROG[13, xyMoveOut8] = NewGridXY[7, xyMoveOut8]
;PRINT,'xyMoveOut8', xyMoveOut8
xyMoveOut9 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut9count, complement = xyMoveOut9N, ncomplement = xyMoveOut9Ncount)
IF xyMoveOut9count GT 0.0 THEN ROG[13, xyMoveOut9] = NewGridXY[8, xyMoveOut9]
PRINT,'xyMoveOut9', xyMoveOut9
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
PRINT, 'NewGridXY'
PRINT, TRANSPOSE(ROG[13, *])
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

FishHorMove = FLTARR(4, nROG)
FishHorMove[0, *] = ROG[13, *]; New horizontal cell ID
FishHorMove[1, *] = xNewLocWithinCell; New within-cell location in x-dimension in new cell
FishHorMove[2, *] = yNewLocWithinCell; New within-cell location in y-dimension in new cell

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'ROG Horizontal Movement Ends Here'
RETURN, FishHorMove
END