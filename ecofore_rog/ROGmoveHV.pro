FUNCTION ROGMoveHV, ts, iHour, ROG, nROG, NewInput, TotBenBio, Grid2D, xOldLocWithinCell, yOldLocWithinCell, zOldLocWithinCell, Oxydebt
;function determines movement in X,Y,Z direction for all Round Goby
;******This function works only for moveing to neighboring cells (wiht relatively large horizontal cells)***************************

;;**********************TEST ONLY*************************************************
;PRO ROGMoveHV, ROG, nROG, NewInput, TotBenBio, Grid2D, xOldLocWithinCell, yOldLocWithinCell, zOldLocWithinCell
;; NEED to change NewInputFiles, YPinitial, YEPacclT, YEPacclDO for testing
;nROG = 50000L; number of SI YP, MOVEMENT PARAMETER
;
;ihour = 15L
;newinput = EcoForeInputFiles()
;newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]; MOVEMENT PARAMETER
;
;Grid3D2 = GridCells3D()
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell); g/m2
;BottomCell = WHERE(Grid3D2[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;TotBenBio = TotBenBio + NewInput[8, *]; MOVEMENT PARAMETER
;
;NpopROG= 50000000L; number of WAE individuals
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput); MOVEMENT PARAMETER
;Grid2D = GridCells2D(); MOVEMENT PARAMETER
;
;Temp = ROG[19, *]
;
;ts = 6L; 6 minutes
;Length = ROG[1, *]; in mm
;Weight = ROG[2, *]; in g
;TacclR = ROG[27, *]
;TacclC = ROG[26, *]
;Tamb = ROG[19, *]
;DOa = ROG[20, *]
;DOacclR = ROG[29, *]
;DOacclC = ROG[28, *]
;DOacclim = ROGacclDO(DOacclR, DOacclC, DOa, TacclR, TacclC, Tamb, ts, Length, Weight, nROG); MOVEMENT PARAMETER
;
;xOldLocWithinCell = ROG[39, *]; MOVEMENT PARAMETER 
;yOldLocWithinCell = ROG[40, *]; MOVEMENT PARAMETER
;zOldLocWithinCell = ROG[41, *]; MOVEMENT PARAMETER
;;***********************************************************************************

PRINT, 'Round Goby Movement Begins Here'

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

tstart = SYSTIME(/seconds)
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

LocH = FLTARR(30, nROG)
LocHV = FLTARR(9*7L, nROG)
NewGridXY = FLTARR(10L, nROG)
; 1 in X and Y dimensions
;LocH[0, *] = ROG[10, *] - 1L
;LocH[1, *] = ROG[11, *] + 1L
;; 2
;LocH[2, *] = ROG[10, *]
;LocH[3, *] = ROG[11, *] + 1L
;; 3
;LocH[4, *] = ROG[10, *] + 1L
;LocH[5, *] = ROG[11, *] + 1L
; 4
LocH[6, *] = ROG[10, *] - 1L
;; LocH[6, *] NEEDS TO BE > 43.0
;NZLocH6 = WHERE((LocH[6, *] GE 43.0), NZLocH6count, complement = ZLocH6, ncomplement = ZLocH6count);
;IF (NZLocH6count GT 0.0) THEN LocH[6, NZLocH6] = LocH[6, NZLocH6]
;IF (ZLocH6count GT 0.0) THEN LocH[6, ZLocH6] = ROG[10, ZLocH6]+1L
LocH[7, *] = ROG[11, *] 
; 5
LocH[8, *] = ROG[10, *] + 1L
;; LocH[6, *] NEEDS TO BE < 140.0
;NZLocH8 = WHERE((LocH[8, *] LE 140.0), NZLocH8count, complement = ZLocH8, ncomplement = ZLocH8count);
;IF (NZLocH8count GT 0.0) THEN LocH[8, NZLocH8] = LocH[8, NZLocH8]
;IF (ZLocH8count GT 0.0) THEN LocH[8, ZLocH8] = ROG[10, ZLocH8]-1L
LocH[9, *] = ROG[11, *] 
;; 6
;LocH[10, *] = ROG[10, *] - 1L
;LocH[11, *] = ROG[11, *] - 1L
;; 7
;LocH[12, *] = ROG[10, *] 
;LocH[13, *] = ROG[11, *] - 1L
;; 8
;LocH[14, *] = ROG[10, *] + 1L
;LocH[15, *] = ROG[11, *] - 1L
;; No move = the current cell
;LocH[16, *] = ROG[10, *]
;LocH[17, *] = ROG[11, *]
;;PRINT, 'LocH', LocH[0:17, *]
 
;****************Identify neighbouring cell IDs***********************************************************************************
FOR ihh = 0L, nROG - 1L DO BEGIN;*****Time-consuming part*********************************************************************
  ;LocH[18, ihh] = WHERE((LocH[0, ihh] EQ Grid2D[0, *]) AND (LocH[1, ihh] EQ Grid2D[1, *]), NewXYloc1) 
  ;LocH[19, ihh] = WHERE((LocH[2, ihh] EQ Grid2D[0, *]) AND (LocH[3, ihh] EQ Grid2D[1, *]), NewXYloc2) 
  ;LocH[20, ihh] = WHERE((LocH[4, ihh] EQ Grid2D[0, *]) AND (LocH[5, ihh] EQ Grid2D[1, *]), NewXYloc3) 
  LocH[21, ihh] = WHERE((LocH[6, ihh] EQ Grid2D[0, *]) AND (LocH[7, ihh] EQ Grid2D[1, *]), NewXYloc4);
  LocH[22, ihh] = WHERE((LocH[8, ihh] EQ Grid2D[0, *]) AND (LocH[9, ihh] EQ Grid2D[1, *]), NewXYloc5);
  ;LocH[23, ihh] = WHERE((LocH[10, ihh] EQ Grid2D[0, *]) AND (LocH[11, ihh] EQ Grid2D[1, *]), NewXYloc6) 
  ;LocH[24, ihh] = WHERE((LocH[12, ihh] EQ Grid2D[0, *]) AND (LocH[13, ihh] EQ Grid2D[1, *]), NewXYloc7) 
  ;LocH[25, ihh] = WHERE((LocH[14, ihh] EQ Grid2D[0, *]) AND (LocH[15, ihh] EQ Grid2D[1, *]), NewXYloc8) 
  ;LocH[26, ihh] = WHERE((LocH[16, ihh] EQ Grid2D[0, *]) AND (LocH[17, ihh] EQ Grid2D[1, *]), NewXYloc9) 
ENDFOR;**************************************************************************************************************************
;PRINT, 'NewGridXY', NewGridXY
NNLocH21 = WHERE((LocH[21, *] GE 0.0), NNLocH21count, complement = NLocH21, ncomplement = NLocH21count);
NNLocH22 = WHERE((LocH[22, *] GE 0.0), NNLocH22count, complement = NLocH22, ncomplement = NLocH22count);
;PRINT, 'NLocH21'
;PRINT, NLocH21
;PRINT, 'NLocH22'
;PRINT, NLocH22
IF (NNLocH21count GT 0.0) THEN NewGridXY[3, NNLocH21] = LocH[21, NNLocH21]
IF (NLocH21count GT 0.0) THEN NewGridXY[3, NLocH21] = LocH[21, NLocH21];
IF (NNLocH22count GT 0.0) THEN NewGridXY[4, NNLocH22] = LocH[22, NNLocH22]
IF (NLocH22count GT 0.0) THEN NewGridXY[4, NLocH22] = LocH[22, NLocH22];
;PRINT, 'NewGridXY3'
;PRINT, transpose(NewGridXY[3,0:200])
;PRINT, 'NewGridXY4'
;PRINT, transpose(NewGridXY[4,0:200])

IF (NNLocH21count GT 0.0) THEN NewGridXY[0, NNLocH21] = NewGridXY[3, NNLocH21]+1L; 1-> 4. +1
NewGridXY[1, *] = ROG[13, *]+1L; 2-> CURRENT +1 
IF (NNLocH22count GT 0.0) THEN NewGridXY[2, NNLocH22] = NewGridXY[4, NNLocH22]+1L; 3 ->5. +1
;NewGridXY[3, PLocH21]; 4 
;NewGridXY[4, PLocH22];  5
NewGridXY[5, *] = NewGridXY[3, *]-1L; 6 -> 4. - 1
NewGridXY[6, *] = ROG[13, *]-1L; 7 -> CURRENT - 1
NewGridXY[7, *] = NewGridXY[4, *]-1L; 8 -> 5. - 1

;; NewGridXY and YP[13, *] NEED TO BE > 0.0
;NZNewGridXY3 = WHERE((NewGridXY[3, *] GT 0.0), NZNewGridXY3count, complement = ZNewGridXY3, ncomplement = ZNewGridXY3count);
;NZROG13 = WHERE((ROG[13, *] GT 0.0), NZROG13count, complement = ZROG13, ncomplement = ZROG13count);
;NZNewGridXY4 = WHERE((NewGridXY[4, *] GT 0.0), NZNewGridXY4count, complement = ZNewGridXY4, ncomplement = ZNewGridXY4count);
;IF (NZNewGridXY3count GT 0.0) THEN NewGridXY[5, NZNewGridXY3] = NewGridXY[3, NZNewGridXY3]-1L; 6 -> 4. -1
;IF (ZNewGridXY3count GT 0.0) THEN NewGridXY[5, ZNewGridXY3] = NewGridXY[3, ZNewGridXY3]+1L; 6 -> 4. -1
;IF (NZROG13count GT 0.0) THEN NewGridXY[6, NZROG13] = ROG[13, NZROG13]-1L; 7 -> CURRENT -1
;IF (ZROG13count GT 0.0) THEN NewGridXY[6, ZROG13] = ROG[13, ZROG13]+1L; 7 -> CURRENT -1
;IF (NZNewGridXY4count GT 0.0) THEN NewGridXY[7, NZNewGridXY4] = NewGridXY[4, NZNewGridXY4]-1L; 8 -> 5. -1
;IF (ZNewGridXY4count GT 0.0) THEN NewGridXY[7, ZNewGridXY4] = NewGridXY[4, ZNewGridXY4]+1L; 8 -> 5. -1
NewGridXY[8, *] = ROG[13, *]; 9 -> CURRENT
;PRINT, 'NewGridXY', NewGridXY
 
; Test if the cells exit (Xloc is still the same) 
; Location 1 & 6 -> xlocation should be Loc[6, *]=4
LocNH7A = WHERE((NewGridXY[0, *] GE 0.0) AND (Grid2D[0, NewGridXY[0, *]] EQ LocH[6, *]), LocNH7Acount, complement = LocH7A, ncomplement = LocH7Acount) ; LocH[7, *]
IF (LocNH7Acount GT 0.) THEN NewGridXY[0, LocNH7A] = NewGridXY[0, LocNH7A]; WAE[13, LocNH7]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH7Acount GT 0.) THEN NewGridXY[0, LocH7A] = -1L; WAE[13, LocNH7]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

LocNH7B = WHERE((NewGridXY[5, *] GE 0.0) AND (Grid2D[0, NewGridXY[5, *]] EQ LocH[6, *]), LocNH7Bcount, complement = LocH7B, ncomplement = LocH7Bcount) ; LocH[7, *]
IF (LocNH7Bcount GT 0.) THEN NewGridXY[5, LocNH7B] = NewGridXY[5, LocNH7B]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH7Bcount GT 0.) THEN NewGridXY[5, LocH7B] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

;PRINT, 'LocNH7count', LocNH7count 
; Location 3 & 8 -> xlocation should be Loc[8, *]=5
LocNH9A = WHERE((NewGridXY[2, *] GE 0.0) AND (Grid2D[0, NewGridXY[2, *]] EQ LocH[8, *]), LocNH9Acount, complement = LocH9A, ncomplement = LocH9Acount) ; LocH[7, *]
IF (LocNH9Acount GT 0.) THEN NewGridXY[2, LocNH9A] = NewGridXY[2, LocNH9A]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH9Acount GT 0.) THEN NewGridXY[2, LocH9A] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

LocNH9B = WHERE((NewGridXY[7, *] GE 0.0) AND (Grid2D[0, NewGridXY[7, *]] EQ LocH[8, *]), LocNH9Bcount, complement = LocH9B, ncomplement = LocH9Bcount) ; LocH[7, *]
IF (LocNH9Bcount GT 0.) THEN NewGridXY[7, LocNH9B] = NewGridXY[7, LocNH9B]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH9Bcount GT 0.) THEN NewGridXY[7, LocH9B] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

;PRINT, 'LocNH9count', LocNH9count 
; Location 2 & 7 -> xlocation should be YP[10, *]=9
LocNH17A = WHERE((NewGridXY[1, *] GE 0.0) AND (Grid2D[0, NewGridXY[1, *]] EQ ROG[10, *]), LocNH17Acount, complement = LocH17A, ncomplement = LocH17Acount) ; LocH[7, *]
IF (LocNH17Acount GT 0.) THEN NewGridXY[1, LocNH17A] = NewGridXY[1, LocNH17A]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH17Acount GT 0.) THEN NewGridXY[1, LocH17A] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

LocNH17B = WHERE((NewGridXY[6, *] GE 0.0) AND (Grid2D[0, NewGridXY[6, *]] EQ ROG[10, *]), LocNH17Bcount, complement = LocH17B, ncomplement = LocH17Bcount) ; LocH[7, *]
IF (LocNH17Bcount GT 0.) THEN NewGridXY[6, LocNH17B] = NewGridXY[6, LocNH17B]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH17Bcount GT 0.) THEN NewGridXY[6, LocH17B] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

;PRINT, 'LocNH17count', LocNH17count
;PRINT, 'NewGridXY'
;PRINT, transpose(NewGridXY[*,0:100])

;*****GRID ID STRATS FROM "0"************************
; NEED a previous vertical position of fish before the horizontal movemnent
; current layer*********to get 3D ID,  =20*(2DID) + (depth-1)***************
NZNewGridXY0 = WHERE((NewGridXY[0, *] GE 0.0), NZNewGridXY0count, complement = ZNewGridXY0, ncomplement = ZNewGridXY0count);
NZNewGridXY1 = WHERE((NewGridXY[1, *] GE 0.0), NZNewGridXY1count, complement = ZNewGridXY1, ncomplement = ZNewGridXY1count);
NZNewGridXY2 = WHERE((NewGridXY[2, *] GE 0.0), NZNewGridXY2count, complement = ZNewGridXY2, ncomplement = ZNewGridXY2count);
NZNewGridXY3 = WHERE((NewGridXY[3, *] GE 0.0), NZNewGridXY3count, complement = ZNewGridXY3, ncomplement = ZNewGridXY3count);
NZNewGridXY4 = WHERE((NewGridXY[4, *] GE 0.0), NZNewGridXY4count, complement = ZNewGridXY4, ncomplement = ZNewGridXY4count);
NZNewGridXY5 = WHERE((NewGridXY[5, *] GE 0.0), NZNewGridXY5count, complement = ZNewGridXY5, ncomplement = ZNewGridXY5count);
NZNewGridXY6 = WHERE((NewGridXY[6, *] GE 0.0), NZNewGridXY6count, complement = ZNewGridXY6, ncomplement = ZNewGridXY6count);
NZNewGridXY7 = WHERE((NewGridXY[7, *] GE 0.0), NZNewGridXY7count, complement = ZNewGridXY7, ncomplement = ZNewGridXY7count);
NZNewGridXY8 = WHERE((NewGridXY[8, *] GE 0.0), NZNewGridXY8count, complement = ZNewGridXY8, ncomplement = ZNewGridXY8count);
;PRINT, 'ZNewGridXYcount=', ZNewGridXY0count
;PRINT, 'NZNewGridXY=', ZNewGridXY0
;TESTGRID=NewGridXY[0, NZNewGridXY0]
;PRINT, 'NewGridXY[*, NZNewGridXY]', TRANSPOSE(TESTGRID[0, 0:100])
;PRINT, 'NewGridXY[*, *]', NewGridXY[*, 0:100]

IF (NZNewGridXY0count GT 0.0) THEN LocHV[0, NZNewGridXY0] = (NewGridXY[0, NZNewGridXY0])*20. + (ROG[12, NZNewGridXY0]-1.) 
IF (NZNewGridXY1count GT 0.0) THEN LocHV[1, NZNewGridXY1] = (NewGridXY[1, NZNewGridXY1])*20. + (ROG[12, NZNewGridXY1]-1.) 
IF (NZNewGridXY2count GT 0.0) THEN LocHV[2, NZNewGridXY2] = (NewGridXY[2, NZNewGridXY2])*20. + (ROG[12, NZNewGridXY2]-1.) 
IF (NZNewGridXY3count GT 0.0) THEN LocHV[3, NZNewGridXY3] = (NewGridXY[3, NZNewGridXY3])*20. + (ROG[12, NZNewGridXY3]-1.) 
IF (NZNewGridXY4count GT 0.0) THEN LocHV[4, NZNewGridXY4] = (NewGridXY[4, NZNewGridXY4])*20. + (ROG[12, NZNewGridXY4]-1.) 
IF (NZNewGridXY5count GT 0.0) THEN LocHV[5, NZNewGridXY5] = (NewGridXY[5, NZNewGridXY5])*20. + (ROG[12, NZNewGridXY5]-1.) 
IF (NZNewGridXY6count GT 0.0) THEN LocHV[6, NZNewGridXY6] = (NewGridXY[6, NZNewGridXY6])*20. + (ROG[12, NZNewGridXY6]-1.) 
IF (NZNewGridXY7count GT 0.0) THEN LocHV[7, NZNewGridXY7] = (NewGridXY[7, NZNewGridXY7])*20. + (ROG[12, NZNewGridXY7]-1.) 
IF (NZNewGridXY8count GT 0.0) THEN LocHV[8, NZNewGridXY8] = (NewGridXY[8, NZNewGridXY8])*20. + (ROG[12, NZNewGridXY8]-1.) 

IF (ZNewGridXY0count GT 0.0) THEN LocHV[0, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[1, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[2, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[3, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[4, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[5, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[6, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[7, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[8, ZNewGridXY8] = -1. 
;PRINT, 'LocHV[0:8,*]'
;PRINT, LocHV[0:8, 0:100]
  
; Vertical movement is restricted within 3 cells below and above the current layer
;DOWNWARD MOVEMNT
; current layer -3
Lower3Cells0 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[0, *] GE 0.0), Lower3Cells0count)
Lower3Cells1 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[1, *] GE 0.0), Lower3Cells1count)
Lower3Cells2 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[2, *] GE 0.0), Lower3Cells2count)
Lower3Cells3 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[3, *] GE 0.0), Lower3Cells3count)
Lower3Cells4 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[4, *] GE 0.0), Lower3Cells4count)
Lower3Cells5 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[5, *] GE 0.0), Lower3Cells5count)
Lower3Cells6 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[6, *] GE 0.0), Lower3Cells6count)
Lower3Cells7 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[7, *] GE 0.0), Lower3Cells7count)
Lower3Cells8 = WHERE((ROG[12, *] LE 17L) AND (NewGridXY[8, *] GE 0.0), Lower3Cells8count)
IF Lower3Cells0count GT 0. THEN LocHV[9, Lower3Cells0] = LocHV[0, Lower3Cells0]+3L; 
IF Lower3Cells1count GT 0. THEN LocHV[10, Lower3Cells1] = LocHV[1, Lower3Cells1]+3L; 
IF Lower3Cells2count GT 0. THEN LocHV[11, Lower3Cells2] = LocHV[2, Lower3Cells2]+3L; 
IF Lower3Cells3count GT 0. THEN LocHV[12, Lower3Cells3] = LocHV[3, Lower3Cells3]+3L; 
IF Lower3Cells4count GT 0. THEN LocHV[13, Lower3Cells4] = LocHV[4, Lower3Cells4]+3L; 
IF Lower3Cells5count GT 0. THEN LocHV[14, Lower3Cells5] = LocHV[5, Lower3Cells5]+3L; 
IF Lower3Cells6count GT 0. THEN LocHV[15, Lower3Cells6] = LocHV[6, Lower3Cells6]+3L; 
IF Lower3Cells7count GT 0. THEN LocHV[16, Lower3Cells7] = LocHV[7, Lower3Cells7]+3L; 
IF Lower3Cells8count GT 0. THEN LocHV[17, Lower3Cells8] = LocHV[8, Lower3Cells8]+3L; 
NONLower3Cells0 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[0, *] GE 0.0), NonLower3Cells0count)
NONLower3Cells1 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[1, *] GE 0.0), NonLower3Cells1count)
NONLower3Cells2 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[2, *] GE 0.0), NonLower3Cells2count)
NONLower3Cells3 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[3, *] GE 0.0), NonLower3Cells3count)
NONLower3Cells4 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[4, *] GE 0.0), NonLower3Cells4count)
NONLower3Cells5 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[5, *] GE 0.0), NonLower3Cells5count)
NONLower3Cells6 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[6, *] GE 0.0), NonLower3Cells6count)
NONLower3Cells7 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[7, *] GE 0.0), NonLower3Cells7count)
NONLower3Cells8 = WHERE((ROG[12, *] GT 17L) AND (NewGridXY[8, *] GE 0.0), NonLower3Cells8count)
IF NonLower3Cells0count GT 0. THEN LocHV[9, NonLower3Cells0] = LocHV[0, NonLower3Cells0];
IF NonLower3Cells1count GT 0. THEN LocHV[10, NonLower3Cells1] = LocHV[1, NonLower3Cells1];
IF NonLower3Cells2count GT 0. THEN LocHV[11, NonLower3Cells2] = LocHV[2, NonLower3Cells2];
IF NonLower3Cells3count GT 0. THEN LocHV[12, NonLower3Cells3] = LocHV[3, NonLower3Cells3];
IF NonLower3Cells4count GT 0. THEN LocHV[13, NonLower3Cells4] = LocHV[4, NonLower3Cells4];
IF NonLower3Cells5count GT 0. THEN LocHV[14, NonLower3Cells5] = LocHV[5, NonLower3Cells5];
IF NonLower3Cells6count GT 0. THEN LocHV[15, NonLower3Cells6] = LocHV[6, NonLower3Cells6];
IF NonLower3Cells7count GT 0. THEN LocHV[16, NonLower3Cells7] = LocHV[7, NonLower3Cells7];
IF NonLower3Cells8count GT 0. THEN LocHV[17, NonLower3Cells8] = LocHV[8, NonLower3Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[9, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[10, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[11, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[12, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[13, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[14, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[15, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[16, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[17, ZNewGridXY8] = -1. 
; current layer -2
Lower2Cells0 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[0, *] GE 0.0), Lower2Cells0count)
Lower2Cells1 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[1, *] GE 0.0), Lower2Cells1count)
Lower2Cells2 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[2, *] GE 0.0), Lower2Cells2count)
Lower2Cells3 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[3, *] GE 0.0), Lower2Cells3count)
Lower2Cells4 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[4, *] GE 0.0), Lower2Cells4count)
Lower2Cells5 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[5, *] GE 0.0), Lower2Cells5count)
Lower2Cells6 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[6, *] GE 0.0), Lower2Cells6count)
Lower2Cells7 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[7, *] GE 0.0), Lower2Cells7count)
Lower2Cells8 = WHERE((ROG[12, *] LE 18L) AND (NewGridXY[8, *] GE 0.0), Lower2Cells8count)
IF Lower2Cells0count GT 0. THEN LocHV[18, Lower2Cells0] = LocHV[0, Lower2Cells0]+2L; 
IF Lower2Cells1count GT 0. THEN LocHV[19, Lower2Cells1] = LocHV[1, Lower2Cells1]+2L; 
IF Lower2Cells2count GT 0. THEN LocHV[20, Lower2Cells2] = LocHV[2, Lower2Cells2]+2L; 
IF Lower2Cells3count GT 0. THEN LocHV[21, Lower2Cells3] = LocHV[3, Lower2Cells3]+2L; 
IF Lower2Cells4count GT 0. THEN LocHV[22, Lower2Cells4] = LocHV[4, Lower2Cells4]+2L; 
IF Lower2Cells5count GT 0. THEN LocHV[23, Lower2Cells5] = LocHV[5, Lower2Cells5]+2L; 
IF Lower2Cells6count GT 0. THEN LocHV[24, Lower2Cells6] = LocHV[6, Lower2Cells6]+2L; 
IF Lower2Cells7count GT 0. THEN LocHV[25, Lower2Cells7] = LocHV[7, Lower2Cells7]+2L; 
IF Lower2Cells8count GT 0. THEN LocHV[26, Lower2Cells8] = LocHV[8, Lower2Cells8]+2L; 
NONLower2Cells0 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[0, *] GE 0.0), NonLower2Cells0count)
NONLower2Cells1 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[1, *] GE 0.0), NonLower2Cells1count)
NONLower2Cells2 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[2, *] GE 0.0), NonLower2Cells2count)
NONLower2Cells3 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[3, *] GE 0.0), NonLower2Cells3count)
NONLower2Cells4 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[4, *] GE 0.0), NonLower2Cells4count)
NONLower2Cells5 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[5, *] GE 0.0), NonLower2Cells5count)
NONLower2Cells6 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[6, *] GE 0.0), NonLower2Cells6count)
NONLower2Cells7 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[7, *] GE 0.0), NonLower2Cells7count)
NONLower2Cells8 = WHERE((ROG[12, *] GT 18L) AND (NewGridXY[8, *] GE 0.0), NonLower2Cells8count)
IF NonLower2Cells0count GT 0. THEN LocHV[18, NonLower2Cells0] = LocHV[0, NonLower2Cells0];
IF NonLower2Cells1count GT 0. THEN LocHV[19, NonLower2Cells1] = LocHV[1, NonLower2Cells1];
IF NonLower2Cells2count GT 0. THEN LocHV[20, NonLower2Cells2] = LocHV[2, NonLower2Cells2];
IF NonLower2Cells3count GT 0. THEN LocHV[21, NonLower2Cells3] = LocHV[3, NonLower2Cells3];
IF NonLower2Cells4count GT 0. THEN LocHV[22, NonLower2Cells4] = LocHV[4, NonLower2Cells4];
IF NonLower2Cells5count GT 0. THEN LocHV[23, NonLower2Cells5] = LocHV[5, NonLower2Cells5];
IF NonLower2Cells6count GT 0. THEN LocHV[24, NonLower2Cells6] = LocHV[6, NonLower2Cells6];
IF NonLower2Cells7count GT 0. THEN LocHV[25, NonLower2Cells7] = LocHV[7, NonLower2Cells7];
IF NonLower2Cells8count GT 0. THEN LocHV[26, NonLower2Cells8] = LocHV[8, NonLower2Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[18, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[19, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[20, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[21, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[22, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[23, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[24, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[25, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[26, ZNewGridXY8] = -1. 
; current layer -1
Lower1Cells0 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[0, *] GE 0.0), Lower1Cells0count)
Lower1Cells1 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[1, *] GE 0.0), Lower1Cells1count)
Lower1Cells2 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[2, *] GE 0.0), Lower1Cells2count)
Lower1Cells3 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[3, *] GE 0.0), Lower1Cells3count)
Lower1Cells4 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[4, *] GE 0.0), Lower1Cells4count)
Lower1Cells5 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[5, *] GE 0.0), Lower1Cells5count)
Lower1Cells6 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[6, *] GE 0.0), Lower1Cells6count)
Lower1Cells7 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[7, *] GE 0.0), Lower1Cells7count)
Lower1Cells8 = WHERE((ROG[12, *] LE 19L) AND (NewGridXY[8, *] GE 0.0), Lower1Cells8count)
IF Lower1Cells0count GT 0. THEN LocHV[27, Lower1Cells0] = LocHV[0, Lower1Cells0]+1L; 
IF Lower1Cells1count GT 0. THEN LocHV[28, Lower1Cells1] = LocHV[1, Lower1Cells1]+1L; 
IF Lower1Cells2count GT 0. THEN LocHV[29, Lower1Cells2] = LocHV[2, Lower1Cells2]+1L; 
IF Lower1Cells3count GT 0. THEN LocHV[30, Lower1Cells3] = LocHV[3, Lower1Cells3]+1L; 
IF Lower1Cells4count GT 0. THEN LocHV[31, Lower1Cells4] = LocHV[4, Lower1Cells4]+1L; 
IF Lower1Cells5count GT 0. THEN LocHV[32, Lower1Cells5] = LocHV[5, Lower1Cells5]+1L; 
IF Lower1Cells6count GT 0. THEN LocHV[33, Lower1Cells6] = LocHV[6, Lower1Cells6]+1L; 
IF Lower1Cells7count GT 0. THEN LocHV[34, Lower1Cells7] = LocHV[7, Lower1Cells7]+1L; 
IF Lower1Cells8count GT 0. THEN LocHV[35, Lower1Cells8] = LocHV[8, Lower1Cells8]+1L; 
NONLower1Cells0 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[0, *] GE 0.0), NonLower1Cells0count)
NONLower1Cells1 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[1, *] GE 0.0), NonLower1Cells1count)
NONLower1Cells2 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[2, *] GE 0.0), NonLower1Cells2count)
NONLower1Cells3 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[3, *] GE 0.0), NonLower1Cells3count)
NONLower1Cells4 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[4, *] GE 0.0), NonLower1Cells4count)
NONLower1Cells5 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[5, *] GE 0.0), NonLower1Cells5count)
NONLower1Cells6 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[6, *] GE 0.0), NonLower1Cells6count)
NONLower1Cells7 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[7, *] GE 0.0), NonLower1Cells7count)
NONLower1Cells8 = WHERE((ROG[12, *] GT 19L) AND (NewGridXY[8, *] GE 0.0), NonLower1Cells8count)
IF NonLower1Cells0count GT 0. THEN LocHV[27, NonLower1Cells0] = LocHV[0, NonLower1Cells0];
IF NonLower1Cells1count GT 0. THEN LocHV[28, NonLower1Cells1] = LocHV[1, NonLower1Cells1];
IF NonLower1Cells2count GT 0. THEN LocHV[29, NonLower1Cells2] = LocHV[2, NonLower1Cells2];
IF NonLower1Cells3count GT 0. THEN LocHV[30, NonLower1Cells3] = LocHV[3, NonLower1Cells3];
IF NonLower1Cells4count GT 0. THEN LocHV[31, NonLower1Cells4] = LocHV[4, NonLower1Cells4];
IF NonLower1Cells5count GT 0. THEN LocHV[32, NonLower1Cells5] = LocHV[5, NonLower1Cells5];
IF NonLower1Cells6count GT 0. THEN LocHV[33, NonLower1Cells6] = LocHV[6, NonLower1Cells6];
IF NonLower1Cells7count GT 0. THEN LocHV[34, NonLower1Cells7] = LocHV[7, NonLower1Cells7];
IF NonLower1Cells8count GT 0. THEN LocHV[35, NonLower1Cells8] = LocHV[8, NonLower1Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[27, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[28, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[29, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[30, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[31, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[32, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[33, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[34, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[35, ZNewGridXY8] = -1. 
; current layer +1
Upper1Cells0 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[0, *] GE 0.0), Upper1Cells0count)
Upper1Cells1 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[1, *] GE 0.0), Upper1Cells1count)
Upper1Cells2 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[2, *] GE 0.0), Upper1Cells2count)
Upper1Cells3 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[3, *] GE 0.0), Upper1Cells3count)
Upper1Cells4 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[4, *] GE 0.0), Upper1Cells4count)
Upper1Cells5 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[5, *] GE 0.0), Upper1Cells5count)
Upper1Cells6 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[6, *] GE 0.0), Upper1Cells6count)
Upper1Cells7 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[7, *] GE 0.0), Upper1Cells7count)
Upper1Cells8 = WHERE((ROG[12, *] GE 2L) AND (NewGridXY[8, *] GE 0.0), Upper1Cells8count)
IF Upper1Cells0count GT 0. THEN LocHV[36, Upper1Cells0] = LocHV[0, Upper1Cells0]-1L;
IF Upper1Cells1count GT 0. THEN LocHV[37, Upper1Cells1] = LocHV[1, Upper1Cells1]-1L;
IF Upper1Cells2count GT 0. THEN LocHV[38, Upper1Cells2] = LocHV[2, Upper1Cells2]-1L;
IF Upper1Cells3count GT 0. THEN LocHV[39, Upper1Cells3] = LocHV[3, Upper1Cells3]-1L;
IF Upper1Cells4count GT 0. THEN LocHV[40, Upper1Cells4] = LocHV[4, Upper1Cells4]-1L;
IF Upper1Cells5count GT 0. THEN LocHV[41, Upper1Cells5] = LocHV[5, Upper1Cells5]-1L;
IF Upper1Cells6count GT 0. THEN LocHV[42, Upper1Cells6] = LocHV[6, Upper1Cells6]-1L;
IF Upper1Cells7count GT 0. THEN LocHV[43, Upper1Cells7] = LocHV[7, Upper1Cells7]-1L;
IF Upper1Cells8count GT 0. THEN LocHV[44, Upper1Cells8] = LocHV[8, Upper1Cells8]-1L;
NONUpper1Cells0 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[0, *] GE 0.0), NonUpper1Cells0count)
NONUpper1Cells1 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[1, *] GE 0.0), NonUpper1Cells1count)
NONUpper1Cells2 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[2, *] GE 0.0), NonUpper1Cells2count)
NONUpper1Cells3 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[3, *] GE 0.0), NonUpper1Cells3count)
NONUpper1Cells4 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[4, *] GE 0.0), NonUpper1Cells4count)
NONUpper1Cells5 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[5, *] GE 0.0), NonUpper1Cells5count)
NONUpper1Cells6 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[6, *] GE 0.0), NonUpper1Cells6count)
NONUpper1Cells7 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[7, *] GE 0.0), NonUpper1Cells7count)
NONUpper1Cells8 = WHERE((ROG[12, *] LT 2L) AND (NewGridXY[8, *] GE 0.0), NonUpper1Cells8count)
IF NonUpper1Cells0count GT 0. THEN LocHV[36, NonUpper1Cells0] = LocHV[0, NonUpper1Cells0];
IF NonUpper1Cells1count GT 0. THEN LocHV[37, NonUpper1Cells1] = LocHV[1, NonUpper1Cells1];
IF NonUpper1Cells2count GT 0. THEN LocHV[38, NonUpper1Cells2] = LocHV[2, NonUpper1Cells2];
IF NonUpper1Cells3count GT 0. THEN LocHV[39, NonUpper1Cells3] = LocHV[3, NonUpper1Cells3];
IF NonUpper1Cells4count GT 0. THEN LocHV[40, NonUpper1Cells4] = LocHV[4, NonUpper1Cells4];
IF NonUpper1Cells5count GT 0. THEN LocHV[41, NonUpper1Cells5] = LocHV[5, NonUpper1Cells5];
IF NonUpper1Cells6count GT 0. THEN LocHV[42, NonUpper1Cells6] = LocHV[6, NonUpper1Cells6];
IF NonUpper1Cells7count GT 0. THEN LocHV[43, NonUpper1Cells7] = LocHV[7, NonUpper1Cells7];
IF NonUpper1Cells8count GT 0. THEN LocHV[44, NonUpper1Cells8] = LocHV[8, NonUpper1Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[36, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[37, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[38, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[39, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[40, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[41, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[42, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[43, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[44, ZNewGridXY8] = -1. 
; current layer +2
Upper2Cells0 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[0, *] GE 0.0), Upper2Cells0count)
Upper2Cells1 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[1, *] GE 0.0), Upper2Cells1count)
Upper2Cells2 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[2, *] GE 0.0), Upper2Cells2count)
Upper2Cells3 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[3, *] GE 0.0), Upper2Cells3count)
Upper2Cells4 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[4, *] GE 0.0), Upper2Cells4count)
Upper2Cells5 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[5, *] GE 0.0), Upper2Cells5count)
Upper2Cells6 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[6, *] GE 0.0), Upper2Cells6count)
Upper2Cells7 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[7, *] GE 0.0), Upper2Cells7count)
Upper2Cells8 = WHERE((ROG[12, *] GE 3L) AND (NewGridXY[8, *] GE 0.0), Upper2Cells8count)
IF Upper2Cells0count GT 0. THEN LocHV[45, Upper2Cells0] = LocHV[0, Upper2Cells0]-2L;
IF Upper2Cells1count GT 0. THEN LocHV[46, Upper2Cells1] = LocHV[1, Upper2Cells1]-2L;
IF Upper2Cells2count GT 0. THEN LocHV[47, Upper2Cells2] = LocHV[2, Upper2Cells2]-2L;
IF Upper2Cells3count GT 0. THEN LocHV[48, Upper2Cells3] = LocHV[3, Upper2Cells3]-2L;
IF Upper2Cells4count GT 0. THEN LocHV[49, Upper2Cells4] = LocHV[4, Upper2Cells4]-2L;
IF Upper2Cells5count GT 0. THEN LocHV[50, Upper2Cells5] = LocHV[5, Upper2Cells5]-2L;
IF Upper2Cells6count GT 0. THEN LocHV[51, Upper2Cells6] = LocHV[6, Upper2Cells6]-2L;
IF Upper2Cells7count GT 0. THEN LocHV[52, Upper2Cells7] = LocHV[7, Upper2Cells7]-2L;
IF Upper2Cells8count GT 0. THEN LocHV[53, Upper2Cells8] = LocHV[8, Upper2Cells8]-2L;
NONUpper2Cells0 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[0, *] GE 0.0), NonUpper2Cells0count)
NONUpper2Cells1 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[1, *] GE 0.0), NonUpper2Cells1count)
NONUpper2Cells2 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[2, *] GE 0.0), NonUpper2Cells2count)
NONUpper2Cells3 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[3, *] GE 0.0), NonUpper2Cells3count)
NONUpper2Cells4 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[4, *] GE 0.0), NonUpper2Cells4count)
NONUpper2Cells5 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[5, *] GE 0.0), NonUpper2Cells5count)
NONUpper2Cells6 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[6, *] GE 0.0), NonUpper2Cells6count)
NONUpper2Cells7 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[7, *] GE 0.0), NonUpper2Cells7count)
NONUpper2Cells8 = WHERE((ROG[12, *] LT 3L) AND (NewGridXY[8, *] GE 0.0), NonUpper2Cells8count)
IF NonUpper2Cells0count GT 0. THEN LocHV[45, NonUpper2Cells0] = LocHV[0, NonUpper2Cells0];
IF NonUpper2Cells1count GT 0. THEN LocHV[46, NonUpper2Cells1] = LocHV[1, NonUpper2Cells1];
IF NonUpper2Cells2count GT 0. THEN LocHV[47, NonUpper2Cells2] = LocHV[2, NonUpper2Cells2];
IF NonUpper2Cells3count GT 0. THEN LocHV[48, NonUpper2Cells3] = LocHV[3, NonUpper2Cells3];
IF NonUpper2Cells4count GT 0. THEN LocHV[49, NonUpper2Cells4] = LocHV[4, NonUpper2Cells4];
IF NonUpper2Cells5count GT 0. THEN LocHV[50, NonUpper2Cells5] = LocHV[5, NonUpper2Cells5];
IF NonUpper2Cells6count GT 0. THEN LocHV[51, NonUpper2Cells6] = LocHV[6, NonUpper2Cells6];
IF NonUpper2Cells7count GT 0. THEN LocHV[52, NonUpper2Cells7] = LocHV[7, NonUpper2Cells7];
IF NonUpper2Cells8count GT 0. THEN LocHV[53, NonUpper2Cells8] = LocHV[8, NonUpper2Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[45, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[46, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[47, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[48, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[49, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[50, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[51, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[52, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[53, ZNewGridXY8] = -1. 
; current layer +3
Upper3Cells0 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[0, *] GE 0.0), Upper3Cells0count)
Upper3Cells1 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[1, *] GE 0.0), Upper3Cells1count)
Upper3Cells2 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[2, *] GE 0.0), Upper3Cells2count)
Upper3Cells3 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[3, *] GE 0.0), Upper3Cells3count)
Upper3Cells4 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[4, *] GE 0.0), Upper3Cells4count)
Upper3Cells5 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[5, *] GE 0.0), Upper3Cells5count)
Upper3Cells6 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[6, *] GE 0.0), Upper3Cells6count)
Upper3Cells7 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[7, *] GE 0.0), Upper3Cells7count)
Upper3Cells8 = WHERE((ROG[12, *] GE 4L) AND (NewGridXY[8, *] GE 0.0), Upper3Cells8count)
IF Upper3Cells0count GT 0. THEN LocHV[54, Upper3Cells0] = LocHV[0, Upper3Cells0]-3L;
IF Upper3Cells1count GT 0. THEN LocHV[55, Upper3Cells1] = LocHV[1, Upper3Cells1]-3L;
IF Upper3Cells2count GT 0. THEN LocHV[56, Upper3Cells2] = LocHV[2, Upper3Cells2]-3L;
IF Upper3Cells3count GT 0. THEN LocHV[57, Upper3Cells3] = LocHV[3, Upper3Cells3]-3L;
IF Upper3Cells4count GT 0. THEN LocHV[58, Upper3Cells4] = LocHV[4, Upper3Cells4]-3L;
IF Upper3Cells5count GT 0. THEN LocHV[59, Upper3Cells5] = LocHV[5, Upper3Cells5]-3L;
IF Upper3Cells6count GT 0. THEN LocHV[60, Upper3Cells6] = LocHV[6, Upper3Cells6]-3L;
IF Upper3Cells7count GT 0. THEN LocHV[61, Upper3Cells7] = LocHV[7, Upper3Cells7]-3L;
IF Upper3Cells8count GT 0. THEN LocHV[62, Upper3Cells8] = LocHV[8, Upper3Cells8]-3L;
NONUpper3Cells0 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[0, *] GE 0.0), NonUpper3Cells0count)
NONUpper3Cells1 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[1, *] GE 0.0), NonUpper3Cells1count)
NONUpper3Cells2 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[2, *] GE 0.0), NonUpper3Cells2count)
NONUpper3Cells3 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[3, *] GE 0.0), NonUpper3Cells3count)
NONUpper3Cells4 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[4, *] GE 0.0), NonUpper3Cells4count)
NONUpper3Cells5 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[5, *] GE 0.0), NonUpper3Cells5count)
NONUpper3Cells6 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[6, *] GE 0.0), NonUpper3Cells6count)
NONUpper3Cells7 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[7, *] GE 0.0), NonUpper3Cells7count)
NONUpper3Cells8 = WHERE((ROG[12, *] LT 4L) AND (NewGridXY[8, *] GE 0.0), NonUpper3Cells8count)
IF NonUpper3Cells0count GT 0. THEN LocHV[54, NonUpper3Cells0] = LocHV[0, NonUpper3Cells0];
IF NonUpper3Cells1count GT 0. THEN LocHV[55, NonUpper3Cells1] = LocHV[1, NonUpper3Cells1];
IF NonUpper3Cells2count GT 0. THEN LocHV[56, NonUpper3Cells2] = LocHV[2, NonUpper3Cells2];
IF NonUpper3Cells3count GT 0. THEN LocHV[57, NonUpper3Cells3] = LocHV[3, NonUpper3Cells3];
IF NonUpper3Cells4count GT 0. THEN LocHV[58, NonUpper3Cells4] = LocHV[4, NonUpper3Cells4];
IF NonUpper3Cells5count GT 0. THEN LocHV[59, NonUpper3Cells5] = LocHV[5, NonUpper3Cells5];
IF NonUpper3Cells6count GT 0. THEN LocHV[60, NonUpper3Cells6] = LocHV[6, NonUpper3Cells6];
IF NonUpper3Cells7count GT 0. THEN LocHV[61, NonUpper3Cells7] = LocHV[7, NonUpper3Cells7];
IF NonUpper3Cells8count GT 0. THEN LocHV[62, NonUpper3Cells8] = LocHV[8, NonUpper3Cells8];
IF (ZNewGridXY0count GT 0.0) THEN LocHV[54, ZNewGridXY0] = -1. 
IF (ZNewGridXY1count GT 0.0) THEN LocHV[55, ZNewGridXY1] = -1. 
IF (ZNewGridXY2count GT 0.0) THEN LocHV[56, ZNewGridXY2] = -1. 
IF (ZNewGridXY3count GT 0.0) THEN LocHV[57, ZNewGridXY3] = -1. 
IF (ZNewGridXY4count GT 0.0) THEN LocHV[58, ZNewGridXY4] = -1. 
IF (ZNewGridXY5count GT 0.0) THEN LocHV[59, ZNewGridXY5] = -1. 
IF (ZNewGridXY6count GT 0.0) THEN LocHV[60, ZNewGridXY6] = -1. 
IF (ZNewGridXY7count GT 0.0) THEN LocHV[61, ZNewGridXY7] = -1. 
IF (ZNewGridXY8count GT 0.0) THEN LocHV[62, ZNewGridXY8] = -1. 
;ENDFOR;**********************************************
;PRINT, 'NewInput[3, *]', NewInput[3, *]
;PRINT, 'NewGridXY', NewGridXY
;PRINT, 'YP[12, *]', transpose(YP[12, *])

;PRINT, 'LocHV[0:8,*]'
;PRINT, transpose(LocHV[0:8,0:100])
;PRINT, 'LocHV[9:17,*]'
;PRINT, transpose(LocHV[9:17,0:100])
;PRINT, 'LocHV[18:26,*]'
;PRINT, transpose(LocHV[18:26,0:100])
;PRINT, 'LocHV[27:35,*]'
;PRINT, transpose(LocHV[27:35,0:100])
;PRINT, 'LocHV[36:44,*]'
;PRINT, transpose(LocHV[36:44,0:100])
;PRINT, 'LocHV[54:62, 0:200]'
;PRINT, TRANSPOSE(LocHV[54:62, 0:100])
  
 
;****Determine habitat quality of neibouring cells******************************************************************************
; ******NEED TO AGGREGATE ZOOPLANKTON AND NO invasive species*******
EnvironHV = FLTARR(124L, nROG)

;ADJUSTING DAILY LIGHT INTENSITY
IF ((iHour LE 4L) OR (iHour GT 20L)) THEN newinput[11, *]= .5; night time light intensity

; Environmental conditions in 1
;EnvironHV[0:5, *] = newinput[5:10, LocHV[0, *]]; x3zoopl, bentho, temp, DO
;EnvironHV[6, *] = 0.0; invasive species
;EnvironHV[7, *] = 0.0; fish
; Environmental conditions in (2)
; Environmental conditions in (2)
EnvironHV[8:13, NZNewGridXY1] = newinput[5:10, LocHV[1, NZNewGridXY1]]
EnvironHV[11, NZNewGridXY1] = TotBenBio[LocHV[1, NZNewGridXY1]]
EnvironHV[14, NZNewGridXY1] = 0.0; invasive species
EnvironHV[15, NZNewGridXY1] = newinput[11, LocHV[1, NZNewGridXY1]]; light
; Environmental conditions in 3
;EnvironHV[14:19, *] = newinput[5:10, LocHV[2, *]]
;EnvironHV[20, *] = 0.0; invasive species
;EnvironHV[21, *] = 0.0; fish
; Environmental conditions in (4)
EnvironHV[22:27, NZNewGridXY3] = newinput[5:10, LocHV[3, NZNewGridXY3]]
EnvironHV[25, NZNewGridXY3] = TotBenBio[LocHV[3, NZNewGridXY3]]
EnvironHV[28, NZNewGridXY3] = 0.0; invasive species
EnvironHV[29, NZNewGridXY3] = newinput[11, LocHV[3, NZNewGridXY3]]; light
; Environmental conditions in (5)
EnvironHV[30:35, NZNewGridXY4] = newinput[5:10, LocHV[4, NZNewGridXY4]]; 
EnvironHV[33, NZNewGridXY4] = TotBenBio[LocHV[4, NZNewGridXY4]]
EnvironHV[36, NZNewGridXY4] = 0.0; invasive species
EnvironHV[37, NZNewGridXY4] = newinput[11, LocHV[4, NZNewGridXY4]]; light
; Environmental conditions in 6
;EnvironHV[38:43, *] = newinput[5:10, LocHV[5, *]]
;EnvironHV[44, *] = 0.0; invasive species
;EnvironHV[45, *] = 0.0; fish
; Environmental conditions in (7)
EnvironHV[46:51, NZNewGridXY6] = newinput[5:10, LocHV[6, NZNewGridXY6]]
EnvironHV[49, NZNewGridXY6] = TotBenBio[LocHV[6, NZNewGridXY6]]
EnvironHV[52, NZNewGridXY6] = 0.0; invasive species
EnvironHV[53, NZNewGridXY6] = newinput[11, LocHV[6, NZNewGridXY6]]; light
; Environmental conditions in 8
;EnvironHV[54:59, *] = newinput[5:10, LocHV[7, *]]; 
;EnvironHV[60, *] = 0.0; invasive species
;EnvironHV[61, *] = 0.0; fish
; Environmental conditions in (X or 9) = the current cell
EnvironHV[62:67, NZNewGridXY8] = newinput[5:10, LocHV[8, NZNewGridXY8]]
EnvironHV[65, NZNewGridXY8] = TotBenBio[LocHV[8, NZNewGridXY8]]
EnvironHV[68, NZNewGridXY8] = 0.0; invasive species
EnvironHV[69, NZNewGridXY8] = newinput[11, LocHV[8, NZNewGridXY8]]; light
; Environmental conditions for potential vertical movement
;LocHV# for vertical movement = 17, 26, 35, 44, 53, 62
; -3
NNLocHV17 = WHERE((LocHV[17, *] GE 0.0), NNLocHV17count, complement = NLocHV17, ncomplement = NLocHV17count);
IF (NNLocHV17count GT 0.0) THEN BEGIN
EnvironHV[77:82, NNLocHV17] = newinput[5:10, LocHV[17, NNLocHV17]];
EnvironHV[80, NNLocHV17] = TotBenBio[LocHV[17, NNLocHV17]]
EnvironHV[83, NNLocHV17] = 0.0; invasive species
EnvironHV[84, NNLocHV17] = newinput[11, LocHV[17, NNLocHV17]]; light
ENDIF
; -2
NNLocHV26 = WHERE((LocHV[26, *] GE 0.0), NNLocHV26count, complement = NLocHV26, ncomplement = NLocHV26count);
IF (NNLocHV26count GT 0.0) THEN BEGIN
EnvironHV[85:90, NNLocHV26] = newinput[5:10, LocHV[26, NNLocHV26]];
EnvironHV[88, NNLocHV26] = TotBenBio[LocHV[26, NNLocHV26]]
EnvironHV[91, NNLocHV26] = 0.0; invasive species
EnvironHV[92, NNLocHV26] = newinput[11, LocHV[26, NNLocHV26]]; light
ENDIF
; -1
NNLocHV35 = WHERE((LocHV[35, *] GE 0.0), NNLocHV35count, complement = NLocHV35, ncomplement = NLocHV35count);
IF (NNLocHV35count GT 0.0) THEN BEGIN
EnvironHV[92:97, NNLocHV35] = newinput[5:10, LocHV[35, NNLocHV35]];
EnvironHV[95, NNLocHV35] = TotBenBio[LocHV[35, NNLocHV35]]
EnvironHV[98, NNLocHV35] = 0.0; invasive species
EnvironHV[99, NNLocHV35] = newinput[11, LocHV[35, NNLocHV35]]; light
ENDIF
; +1
NNLocHV44 = WHERE((LocHV[44, *] GE 0.0), NNLocHV44count, complement = NLocHV44, ncomplement = NLocHV44count);
IF (NNLocHV44count GT 0.0) THEN BEGIN
EnvironHV[100:105, NNLocHV44] = newinput[5:10, LocHV[44, NNLocHV44]];
EnvironHV[103, NNLocHV44] = TotBenBio[LocHV[44, NNLocHV44]]
EnvironHV[106, NNLocHV44] = 0.0; invasive species
EnvironHV[107, NNLocHV44] = newinput[11, LocHV[44, NNLocHV44]]; light
ENDIF
; +2
NNLocHV53 = WHERE((LocHV[53, *] GE 0.0), NNLocHV53count, complement = NLocHV53, ncomplement = NLocHV53count);
IF (NNLocHV53count GT 0.0) THEN BEGIN
EnvironHV[108:113, NNLocHV53] = newinput[5:10, LocHV[53, NNLocHV53]];
EnvironHV[111, NNLocHV53] = TotBenBio[LocHV[53, NNLocHV53]]
EnvironHV[114, NNLocHV53] = 0.0; invasive species
EnvironHV[115, NNLocHV53] = newinput[11, LocHV[53, NNLocHV53]]; light
ENDIF
; +3
NNLocHV62 = WHERE((LocHV[62, *] GE 0.0), NNLocHV62count, complement = NLocHV62, ncomplement = NLocHV62count);
IF (NNLocHV62count GT 0.0) THEN BEGIN
EnvironHV[116:121, NNLocHV62] = newinput[5:10, LocHV[62, NNLocHV62]];
EnvironHV[119, NNLocHV62] = TotBenBio[LocHV[62, NNLocHV62]]
EnvironHV[122, NNLocHV62] = 0.0; invasive species
EnvironHV[123, NNLocHV62] = newinput[11, LocHV[62, NNLocHV62]]; light
ENDIF


; Assess habitat quality of neighbouring cells
DOf1 = FLTARR(9+6, nROG)
DOf2 = FLTARR(9+6, nROG)
DOf3 = FLTARR(9+6, nROG)
DOf = FLTARR(9+6, nROG)
Tf = FLTARR(9+6, nROG)

; DO
DOacclim = ROGacclDO(ROG[29, *], ROG[28, *], ROG[20, *], ROG[27, *], ROG[26, *], ROG[19, *], ts, ROG[1, *], ROG[2, *], nROG, ROG[63, *]); MOVEMENT PARAMETER 
DOf1a = EnvironHV[13, *] - 2*DOacclim[7, *]
DOf3a = EnvironHV[27, *] - 2.5*DOacclim[7, *]
DOf4a = EnvironHV[35, *] - 2.5*DOacclim[7, *]
DOf6a = EnvironHV[51, *] - 2.5*DOacclim[7, *]
DOf8a = EnvironHV[67, *] - 2.5*DOacclim[7, *]
DOf9a = EnvironHV[82, *] - 2.5*DOacclim[7, *]
DOf10a = EnvironHV[90, *] - 2.5*DOacclim[7, *]
DOf11a = EnvironHV[97, *] - 2.5*DOacclim[7, *]
DOf12a = EnvironHV[105, *] - 2.5*DOacclim[7, *]
DOf13a = EnvironHV[113, *] - 2.5*DOacclim[7, *]
DOf14a = EnvironHV[121, *] - 2.5*DOacclim[7, *]

DOf1b = EnvironHV[13, *] - 2*DOacclim[5, *]
DOf3b = EnvironHV[27, *] - 2*DOacclim[5, *]
DOf4b = EnvironHV[35, *] - 2*DOacclim[5, *]
DOf6b = EnvironHV[51, *] - 2*DOacclim[5, *]
DOf8b = EnvironHV[67, *] - 2*DOacclim[5, *]
DOf9b = EnvironHV[82, *] - 2*DOacclim[5, *]
DOf10b = EnvironHV[90, *] - 2*DOacclim[5, *]
DOf11b = EnvironHV[97, *] - 2*DOacclim[5, *]
DOf12b = EnvironHV[105, *] - 2*DOacclim[5, *]
DOf13b = EnvironHV[113, *] - 2*DOacclim[5, *]
DOf14b = EnvironHV[121, *] - 2*DOacclim[5, *]

; WHEN ambient DO is lower than minimal DOcrit...
;DOf10 = WHERE(EnvironHV[5, ihe] LT DOacclim[7, ihe], DOf1count1)
DOf11 = WHERE(DOf1a LT 0., DOf1count2)
;DOf12 = WHERE(EnvironHV[19, ihe] LT DOacclim[7, ihe], DOf1count3)
DOf13 = WHERE(DOf3a LT 0., DOf1count4)
DOf14 = WHERE(DOf4a LT 0., DOf1count5)
;DOf15 = WHERE(EnvironHV[43, ihe] LT DOacclim[7, ihe], DOf1count6)
DOf16 = WHERE(DOf6a LT 0., DOf1count7)
;DOf17 = WHERE(EnvironHV[59, ihe] LT DOacclim[7, ihe], DOf1count8)
DOf18 = WHERE(DOf8a LT 0., DOf1count9)
DOf19 = WHERE(DOf9a LT 0., DOf1count10)
DOf110 = WHERE(DOf10a LT 0., DOf1count11)
DOf111 = WHERE(DOf11a LT 0., DOf1count12)
DOf112 = WHERE(DOf12a LT 0., DOf1count13)
DOf113 = WHERE(DOf13a LT 0., DOf1count14)
DOf114 = WHERE(DOf14a LT 0., DOf1count15)
;IF DOf1count1 GT 0.0 THEN DOf[0, DOf11] = 0.0; 
IF DOf1count2 GT 0.0 THEN DOf[1, DOf11] = 0.0
;IF DOf1count3 GT 0.0 THEN DOf[2, DOf11] = 0.0;
IF DOf1count4 GT 0.0 THEN DOf[3, DOf13] = 0.0;
IF DOf1count5 GT 0.0 THEN DOf[4, DOf14] = 0.0;
;IF DOf1count6 GT 0.0 THEN DOf[5, ihe] = 0.0;  
IF DOf1count7 GT 0.0 THEN DOf[6, DOf16] = 0.0;  
;IF DOf1count8 GT 0.0 THEN DOf[7, DOf11] = 0.0; 
IF DOf1count9 GT 0.0 THEN DOf[8, DOf18] = 0.0; 
IF DOf1count10 GT 0.0 THEN DOf[9, DOf19] = 0.0; 
IF DOf1count11 GT 0.0 THEN DOf[10, DOf110] = 0.0; 
IF DOf1count12 GT 0.0 THEN DOf[11, DOf111] = 0.0; 
IF DOf1count13 GT 0.0 THEN DOf[12, DOf112] = 0.0; 
IF DOf1count14 GT 0.0 THEN DOf[13, DOf113] = 0.0; 
IF DOf1count15 GT 0.0 THEN DOf[14, DOf114] = 0.0; 

; WHEN ambient DO is between the minimum critical DO and the critical DO...
;DOf20 = WHERE(EnvironHV[5, ihe] GE DOacclim[7, ihe] AND EnvironHV[5, ihe] LE DOacclim[5, ihe], DOf2count1)
DOf21 = WHERE(((DOf1a GE 0.) AND (DOf1b LE 0.)), DOf2count2)
;DOf22 = WHERE(EnvironHV[19, ihe] GE DOacclim[7, ihe] AND EnvironHV[19, ihe] LE DOacclim[5, ihe], DOf2count3)
DOf23 = WHERE(((DOf3a GE 0.) AND (DOf3b LE 0.)), DOf2count4)
DOf24 = WHERE(((DOf4a GE 0.) AND (DOf4b LE 0.)), DOf2count5)
;DOf25 = WHERE(EnvironHV[43, ihe] GE DOacclim[7, ihe] AND EnvironHV[43, ihe] LE DOacclim[5, ihe], DOf2count6)
DOf26 = WHERE(((DOf6a GE 0.) AND (DOf6b LE 0.)), DOf2count7)
;DOf27 = WHERE(EnvironHV[59, ihe] GE DOacclim[7, ihe] AND EnvironHV[59, ihe] LE DOacclim[5, ihe], DOf2count8)
DOf28 = WHERE(((DOf8a GE 0.) AND (DOf8b LE 0.)), DOf2count9)
DOf29 = WHERE(((DOf9a GE 0.) AND (DOf9b LE 0.)), DOf2count10)  
DOf210 = WHERE(((DOf10a GE 0.) AND (DOf10b LE 0.)), DOf2count11)
DOf211 = WHERE(((DOf11a GE 0.) AND (DOf11b LE 0.)), DOf2count12)
DOf212 = WHERE(((DOf12a GE 0.) AND (DOf12b LE 0.)), DOf2count13)
DOf213 = WHERE(((DOf13a GE 0.) AND (DOf13b LE 0.)), DOf2count14)
DOf214 = WHERE(((DOf14a GE 0.) AND (DOf14b LE 0.)), DOf2count15)

;IF DOf2count1 GT 0.0 THEN DOf[0, ihe] = ((EnvironHV[5, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
IF DOf2count2 GT 0.0 THEN DOf[1, DOf21] = ((EnvironHV[13, DOf21] - 2.5*DOacclim[7, DOf21])/(2.*DOacclim[5, DOf21] - 2.5*DOacclim[7, DOf21]))
;IF DOf2count3 GT 0.0 THEN DOf[2, ihe] = ((EnvironHV[19, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
IF DOf2count4 GT 0.0 THEN DOf[3, DOf23] = ((EnvironHV[27, DOf23] - 2.5*DOacclim[7, DOf23])/(2.*DOacclim[5, DOf23] - 2.5*DOacclim[7, DOf23]))
IF DOf2count5 GT 0.0 THEN DOf[4, DOf24] = ((EnvironHV[35, DOf24] - 2.5*DOacclim[7, DOf24])/(2.*DOacclim[5, DOf24] - 2.5*DOacclim[7, DOf24]))
;IF DOf2count6 GT 0.0 THEN DOf[5, ihe] = ((EnvironHV[43, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
IF DOf2count7 GT 0.0 THEN DOf[6, DOf26] = ((EnvironHV[51, DOf26] - 2.5*DOacclim[7, DOf26])/(2.*DOacclim[5, DOf26] - 2.5*DOacclim[7, DOf26]))
;IF DOf2count8 GT 0.0 THEN DOf[7, ihe] = ((EnvironHV[59, ihe] - DOacclim[7, ihe])/(DOacclim[5, ihe] - DOacclim[7, ihe]))
IF DOf2count9 GT 0.0 THEN DOf[8, DOf28] = ((EnvironHV[67, DOf28] - 2.5*DOacclim[7, DOf28])/(2.*DOacclim[5, DOf28] - 2.5*DOacclim[7, DOf28]))
IF DOf2count10 GT 0.0 THEN DOf[9, DOf29] = ((EnvironHV[82, DOf29] - 2.5*DOacclim[7, DOf29])/(2.*DOacclim[5, DOf29] - 2.5*DOacclim[7, DOf29]))
IF DOf2count11 GT 0.0 THEN DOf[10, DOf210] = ((EnvironHV[90, DOf210] - 2.5*DOacclim[7, DOf210])/(2.*DOacclim[5, DOf210] - 2.5*DOacclim[7, DOf210]))
IF DOf2count12 GT 0.0 THEN DOf[11, DOf211] = ((EnvironHV[97, DOf211] - 2.5*DOacclim[7, DOf211])/(2.*DOacclim[5, DOf211] - 2.5*DOacclim[7, DOf211]))
IF DOf2count13 GT 0.0 THEN DOf[12, DOf212] = ((EnvironHV[105, DOf212] - 2.5*DOacclim[7, DOf212])/(2.*DOacclim[5, DOf212] - 2.5*DOacclim[7, DOf212]))
IF DOf2count14 GT 0.0 THEN DOf[13, DOf213] = ((EnvironHV[113, DOf213] - 2.5*DOacclim[7, DOf213])/(2.*DOacclim[5, DOf213] - 2.5*DOacclim[7, DOf213]))
IF DOf2count15 GT 0.0 THEN DOf[14, DOf214] = ((EnvironHV[121, DOf214] - 2.5*DOacclim[7, DOf214])/(2.*DOacclim[5, DOf214] - 2.5*DOacclim[7, DOf214]))

; WHEN ambient DO is above the critical DO...
;DOf30 = WHERE(EnvironHV[5, ihe] GT DOacclim[5, ihe], DOf3count1)
DOf31 = WHERE((DOf1b GT 0.), DOf3count2)
;DOf32 = WHERE(EnvironHV[19, ihe] GT DOacclim[5, ihe], DOf3count3)
DOf33 = WHERE((DOf3b GT 0.), DOf3count4)
DOf34 = WHERE((DOf4b GT 0.), DOf3count5)
;DOf35 = WHERE(EnvironHV[43, ihe] GT DOacclim[5, ihe], DOf3count6)
DOf36 = WHERE((DOf6b GT 0.), DOf3count7)
;DOf37 = WHERE(EnvironHV[59, ihe] GT DOacclim[5, ihe], DOf3count8)
DOf38 = WHERE((DOf8b GT 0.), DOf3count9)
DOf39 = WHERE((DOf9b GT 0.), DOf3count10)
DOf310 = WHERE((DOf10b GT 0.), DOf3count11)
DOf311 = WHERE((DOf11b GT 0.), DOf3count12)
DOf312 = WHERE((DOf12b GT 0.), DOf3count13)
DOf313 = WHERE((DOf13b GT 0.), DOf3count14)
DOf314 = WHERE((DOf14b GT 0.), DOf3count15)

;IF DOf3count1 GT 0.0 THEN DOf[0, ihe] = 1.0
IF DOf3count2 GT 0.0 THEN DOf[1, DOf31] = 1.0
;IF DOf3count3 GT 0.0 THEN DOf[2, ihe] = 1.0
IF DOf3count4 GT 0.0 THEN DOf[3, DOf33] = 1.0
IF DOf3count5 GT 0.0 THEN DOf[4, DOf34] = 1.0
;IF DOf3count6 GT 0.0 THEN DOf[5, ihe] = 1.0
IF DOf3count7 GT 0.0 THEN DOf[6, DOf36] = 1.0
;IF DOf3count8 GT 0.0 THEN DOf[7, ihe] = 1.0
IF DOf3count9 GT 0.0 THEN DOf[8, DOf38] = 1.0
IF DOf3count10 GT 0.0 THEN DOf[9, DOf39] = 1.0
IF DOf3count11 GT 0.0 THEN DOf[10, DOf310] = 1.0
IF DOf3count12 GT 0.0 THEN DOf[11, DOf311] = 1.0
IF DOf3count13 GT 0.0 THEN DOf[12, DOf312] = 1.0
IF DOf3count14 GT 0.0 THEN DOf[13, DOf313] = 1.0
IF DOf3count15 GT 0.0 THEN DOf[14, DOf314] = 1.0
;PRINT, 'DOf[*, *]', DOf[*, *]
;****************************************************************************************

; Temperature
CK1 = 0.113
CK4 = 0.419
CQ = 5.594
CTM = 25.706
CTO = 24.648
CTL = 28.992
G1 = (1. / (CTO - CQ)) * ALOG((0.98 * (1.- CK1)) / (CK1 * 0.02))
G2 = (1. / (CTL - CTM)) * ALOG((0.98 * (1.- CK4)) / (CK4 * 0.02))

;LA1 = EXP(G1 * (EnvironHV[4, *] - CQ))
;LB1 = EXP(G2 * (CTL - EnvironHV[4, *]))
LA2 = EXP(G1 * (EnvironHV[12, *] - CQ))
LB2 = EXP(G2 * (CTL - EnvironHV[12, *]))
;LA3 = EXP(G1 * (EnvironHV[18, *] - CQ))
;LB3 = EXP(G2 * (CTL - EnvironHV[18, *]))
LA4 = EXP(G1 * (EnvironHV[26, *] - CQ))
LB4 = EXP(G2 * (CTL - EnvironHV[26, *]))
LA5 = EXP(G1 * (EnvironHV[34, *] - CQ))
LB5 = EXP(G2 * (CTL - EnvironHV[34, *]))
;LA6 = EXP(G1 * (EnvironHV[42, *] - CQ))
;LB6 = EXP(G2 * (CTL - EnvironHV[42, *]))
LA7 = EXP(G1 * (EnvironHV[50, *] - CQ))
LB7 = EXP(G2 * (CTL - EnvironHV[50, *]))
;LA8 = EXP(G1 * (EnvironHV[58, *] - CQ))
;LB8 = EXP(G2 * (CTL - EnvironHV[58, *]))
LA9 = EXP(G1 * (EnvironHV[66, *] - CQ))
LB9 = EXP(G2 * (CTL - EnvironHV[66, *]))
LA10 = EXP(G1 * (EnvironHV[81, *] - CQ))
LB10 = EXP(G2 * (CTL - EnvironHV[81, *]))
LA11 = EXP(G1 * (EnvironHV[89, *] - CQ))
LB11 = EXP(G2 * (CTL - EnvironHV[89, *]))
LA12 = EXP(G1 * (EnvironHV[96, *] - CQ))
LB12 = EXP(G2 * (CTL - EnvironHV[96, *]))
LA13 = EXP(G1 * (EnvironHV[104, *] - CQ))
LB13 = EXP(G2 * (CTL - EnvironHV[104, *]))
LA14 = EXP(G1 * (EnvironHV[112, *] - CQ))
LB14 = EXP(G2 * (CTL - EnvironHV[112, *]))
LA15 = EXP(G1 * (EnvironHV[120, *] - CQ))
LB15 = EXP(G2 * (CTL - EnvironHV[120, *]))

;KA1 = (CK1 * LA1) / (1. + CK1 * (LA1 - 1.))
;KB1 = (CK4 * LB1) / (1. + CK4 * (LB1 - 1.))
KA2 = (CK1 * LA2) / (1. + CK1 * (LA2 - 1.))
KB2 = (CK4 * LB2) / (1. + CK4 * (LB2 - 1.))
;KA3 = (CK1 * LA3) / (1. + CK1 * (LA3 - 1.))
;KB3 = (CK4 * LB3) / (1. + CK4 * (LB3 - 1.))
KA4 = (CK1 * LA4) / (1. + CK1 * (LA4 - 1.))
KB4 = (CK4 * LB4) / (1. + CK4 * (LB4 - 1.))
KA5 = (CK1 * LA5) / (1. + CK1 * (LA5 - 1.))
KB5 = (CK4 * LB5) / (1. + CK4 * (LB5 - 1.))
;KA6 = (CK1 * LA6) / (1. + CK1 * (LA6 - 1.))
;KB6 = (CK4 * LB6) / (1. + CK4 * (LB6 - 1.))
KA7 = (CK1 * LA7) / (1. + CK1 * (LA7 - 1.))
KB7 = (CK4 * LB7) / (1. + CK4 * (LB7 - 1.))
;KA8 = (CK1 * LA8) / (1. + CK1 * (LA8 - 1.))
;KB8 = (CK4 * LB8) / (1. + CK4 * (LB8 - 1.))
KA9 = (CK1 * LA9) / (1. + CK1 * (LA9 - 1.))
KB9 = (CK4 * LB9) / (1. + CK4 * (LB9 - 1.))
KA10 = (CK1 * LA10) / (1. + CK1 * (LA10 - 1.))
KB10 = (CK4 * LB10) / (1. + CK4 * (LB10 - 1.))
KA11 = (CK1 * LA11) / (1. + CK1 * (LA11 - 1.))
KB11 = (CK4 * LB11) / (1. + CK4 * (LB11 - 1.))
KA12 = (CK1 * LA12) / (1. + CK1 * (LA12 - 1.))
KB12 = (CK4 * LB12) / (1. + CK4 * (LB12 - 1.))
KA13 = (CK1 * LA13) / (1. + CK1 * (LA13 - 1.))
KB13 = (CK4 * LB13) / (1. + CK4 * (LB13 - 1.))
KA14 = (CK1 * LA14) / (1. + CK1 * (LA14 - 1.))
KB14 = (CK4 * LB14) / (1. + CK4 * (LB14 - 1.))
KA15 = (CK1 * LA15) / (1. + CK1 * (LA15 - 1.))
KB15 = (CK4 * LB15) / (1. + CK4 * (LB15 - 1.))

;Tf[0, *] = KA1 * KB1
Tf[1, *] = KA2 * KB2
;Tf[2, *] = KA3 * KB3
Tf[3, *] = KA4 * KB4
Tf[4, *] = KA5 * KB5
;Tf[5, *] = KA6 * KB6
Tf[6, *] = KA7 * KB7
;Tf[7, *] = KA8 * KB8
Tf[8, *] = KA9 * KB9
Tf[9, *] = KA10 * KB10
Tf[10, *] = KA11 * KB11
Tf[11, *] = KA12 * KB12
Tf[12, *] = KA13 * KB13
Tf[13, *] = KA14 * KB14
Tf[14, *] = KA15 * KB15

;CTO = 24.648; Optimal temperture for consumption for round goby
;CTM = 25.706;  Maximum temperture for consumption
;
;; Only upper lethal temperature is considered...
;;Tf1 = WHERE(EnvironHV[4, *] GE CTM, Tfcount1)
;Tf2 = WHERE(EnvironHV[12, *] GE CTM, Tfcount2)
;;Tf3 = WHERE(EnvironHV[18, *] GE CTM, Tfcount3)
;Tf4 = WHERE(EnvironHV[26, *] GE CTM, Tfcount4)
;Tf5 = WHERE(EnvironHV[34, *] GE CTM, Tfcount5)
;;Tf6 = WHERE(EnvironHV[42, *] GE CTM, Tfcount6)
;Tf7 = WHERE(EnvironHV[50, *] GE CTM, Tfcount7)
;;Tf8 = WHERE(EnvironHV[58, *] GE CTM, Tfcount8)
;Tf9 = WHERE(EnvironHV[66, *] GE CTM, Tfcount9)
;
;Tf10 = WHERE(EnvironHV[81, *] GE CTM, Tfcount10)
;Tf11 = WHERE(EnvironHV[89, *] GE CTM, Tfcount11)
;Tf12 = WHERE(EnvironHV[96, *] GE CTM, Tfcount12)
;Tf13 = WHERE(EnvironHV[104, *] GE CTM, Tfcount13)
;Tf14 = WHERE(EnvironHV[112, *] GE CTM, Tfcount14)
;Tf15 = WHERE(EnvironHV[120, *] GE CTM, Tfcount15)
;
;;IF Tfcount1 GT 0.0 THEN Tf[0, Tf1] = 0.0
;IF Tfcount2 GT 0.0 THEN Tf[1, Tf2] = 0.0
;;IF Tfcount3 GT 0.0 THEN Tf[2, Tf3] = 0.0
;IF Tfcount4 GT 0.0 THEN Tf[3, Tf4] = 0.0
;IF Tfcount5 GT 0.0 THEN Tf[4, Tf5] = 0.0
;;IF Tfcount6 GT 0.0 THEN Tf[5, Tf6] = 0.0
;IF Tfcount7 GT 0.0 THEN Tf[6, Tf7] = 0.0
;;IF Tfcount8 GT 0.0 THEN Tf[7, Tf8] = 0.0
;IF Tfcount9 GT 0.0 THEN Tf[8, Tf9] = 0.0
;IF Tfcount10 GT 0.0 THEN Tf[8, Tf10] = 0.0
;IF Tfcount11 GT 0.0 THEN Tf[8, Tf11] = 0.0
;IF Tfcount12 GT 0.0 THEN Tf[8, Tf12] = 0.0
;IF Tfcount13 GT 0.0 THEN Tf[8, Tf13] = 0.0
;IF Tfcount14 GT 0.0 THEN Tf[8, Tf14] = 0.0
;IF Tfcount15 GT 0.0 THEN Tf[8, Tf15] = 0.0
;
;; Ambient temperature is between optimal temperture and maximum temperature...
;;Tf1b = WHERE((EnvironHV[4, *] GT CTO) AND (EnvironHV[4, *] LT CTM), Tfcount1b)
;Tf2b = WHERE((EnvironHV[12, *] GT CTO) AND (EnvironHV[12, *] LT CTM), Tfcount2b)
;;Tf3b = WHERE((EnvironHV[18, *] GT CTO) AND (EnvironHV[18, *] LT CTM), Tfcount3b)
;Tf4b = WHERE((EnvironHV[26, *] GT CTO) AND (EnvironHV[26, *] LT CTM), Tfcount4b)
;Tf5b = WHERE((EnvironHV[34, *] GT CTO) AND (EnvironHV[34, *] LT CTM), Tfcount5b)
;;Tf6b = WHERE((EnvironHV[42, *] GT CTO) AND (EnvironHV[42, *] LT CTM), Tfcount6b)
;Tf7b = WHERE((EnvironHV[50, *] GT CTO) AND (EnvironHV[50, *] LT CTM), Tfcount7b)
;;Tf8b = WHERE((EnvironHV[58, *] GT CTO) AND (EnvironHV[58, *] LT CTM), Tfcount8b)
;Tf9b = WHERE((EnvironHV[66, *] GT CTO) AND (EnvironHV[66, *] LT CTM), Tfcount9b)
;Tf10b = WHERE((EnvironHV[81, *] GT CTO) AND (EnvironHV[81, *] LT CTM), Tfcount10b)
;Tf11b = WHERE((EnvironHV[89, *] GT CTO) AND (EnvironHV[89, *] LT CTM), Tfcount11b)
;Tf12b = WHERE((EnvironHV[96, *] GT CTO) AND (EnvironHV[96, *] LT CTM), Tfcount12b)
;Tf13b = WHERE((EnvironHV[104, *] GT CTO) AND (EnvironHV[104, *] LT CTM), Tfcount13b)
;Tf14b = WHERE((EnvironHV[112, *] GT CTO) AND (EnvironHV[112, *] LT CTM), Tfcount14b)
;Tf15b = WHERE((EnvironHV[120, *] GT CTO) AND (EnvironHV[120, *] LT CTM), Tfcount15b)
;   
;;IF Tfcount1b GT 0.0 THEN Tf[0, Tf1b] = ((CTM - EnvironHV[4,  Tf1b])/(CTM - CTO))
;IF Tfcount2b GT 0.0 THEN Tf[1, Tf2b] = ((CTM - EnvironHV[12, Tf2b])/(CTM - CTO))
;;IF Tfcount3b GT 0.0 THEN Tf[2, Tf3b] = ((CTM - EnvironHV[18, Tf3b])/(CTM - CTO))
;IF Tfcount4b GT 0.0 THEN Tf[3, Tf4b] = ((CTM - EnvironHV[26, Tf4b])/(CTM - CTO))
;IF Tfcount5b GT 0.0 THEN Tf[4, Tf5b] = ((CTM - EnvironHV[34, Tf5b])/(CTM - CTO))
;;IF Tfcount6b GT 0.0 THEN Tf[5, Tf6b] = ((CTM - EnvironHV[42, Tf6b])/(CTM - CTO))
;IF Tfcount7b GT 0.0 THEN Tf[6, Tf7b] = ((CTM - EnvironHV[50, Tf7b])/(CTM - CTO))
;;IF Tfcount8b GT 0.0 THEN Tf[7, Tf8b] = ((CTM - EnvironHV[58, Tf8b])/(CTM - CTO))
;IF Tfcount9b GT 0.0 THEN Tf[8, Tf9b] = ((CTM - EnvironHV[66, Tf9b])/(CTM - CTO))
;
;IF Tfcount10b GT 0.0 THEN Tf[9, Tf10b] = ((CTM - EnvironHV[81, Tf10b])/(CTM - CTO))
;IF Tfcount11b GT 0.0 THEN Tf[10, Tf11b] = ((CTM - EnvironHV[89, Tf11b])/(CTM - CTO))
;IF Tfcount12b GT 0.0 THEN Tf[11, Tf12b] = ((CTM - EnvironHV[96, Tf12b])/(CTM - CTO))
;IF Tfcount13b GT 0.0 THEN Tf[12, Tf13b] = ((CTM - EnvironHV[104, Tf13b])/(CTM - CTO))
;IF Tfcount14b GT 0.0 THEN Tf[13, Tf14b] = ((CTM - EnvironHV[112, Tf14b])/(CTM - CTO))
;IF Tfcount15b GT 0.0 THEN Tf[14, Tf15b] = ((CTM - EnvironHV[120, Tf15b])/(CTM - CTO))
;
;; When ambient temperture is equal to or less than ambient temperature...
;;Tf1c = WHERE(EnvironHV[4, *] LE CTO, Tfcount1c)
;Tf2c = WHERE(EnvironHV[12, *] LE CTO, Tfcount2c)
;;Tf3c = WHERE(EnvironHV[18, *] LE CTO, Tfcount3c)
;Tf4c = WHERE(EnvironHV[26, *] LE CTO, Tfcount4c)
;Tf5c = WHERE(EnvironHV[34, *] LE CTO, Tfcount5c)
;;Tf6c = WHERE(EnvironHV[42, *] LE CTO, Tfcount6c)
;Tf7c = WHERE(EnvironHV[50, *] LE CTO, Tfcount7c)
;;Tf8c = WHERE(EnvironHV[58, *] LE CTO, Tfcount8c)
;Tf9c = WHERE(EnvironHV[66, *] LE CTO, Tfcount9c)
;
;Tf10c = WHERE(EnvironHV[81, *] LE CTO, Tfcount10c)
;Tf11c = WHERE(EnvironHV[89, *] LE CTO, Tfcount11c) 
;Tf12c = WHERE(EnvironHV[96, *] LE CTO, Tfcount12c)
;Tf13c = WHERE(EnvironHV[104, *] LE CTO, Tfcount13c)
;Tf14c = WHERE(EnvironHV[112, *] LE CTO, Tfcount14c)
;Tf15c = WHERE(EnvironHV[120, *] LE CTO, Tfcount15c)
;  
;;IF Tfcount1c GT 0.0 THEN Tf[0, Tf1c] = 1.0 
;IF Tfcount2c GT 0.0 THEN Tf[1, Tf2c] = 1.0  
;;IF Tfcount3c GT 0.0 THEN Tf[2, Tf3c] = 1.0  
;IF Tfcount4c GT 0.0 THEN Tf[3, Tf4c] = 1.0  
;IF Tfcount5c GT 0.0 THEN Tf[4, Tf5c] = 1.0  
;;IF Tfcount6c GT 0.0 THEN Tf[5, Tf6c] = 1.0  
;IF Tfcount7c GT 0.0 THEN Tf[6, Tf7c] = 1.0  
;;IF Tfcount8c GT 0.0 THEN Tf[7, Tf8c] = 1.0  
;IF Tfcount9c GT 0.0 THEN Tf[8, Tf9c] = 1.0  
;IF Tfcount10c GT 0.0 THEN Tf[9, Tf10c] = 1.0 
;IF Tfcount11c GT 0.0 THEN Tf[10, Tf11c] = 1.0 
;IF Tfcount12c GT 0.0 THEN Tf[11, Tf12c] = 1.0 
;IF Tfcount13c GT 0.0 THEN Tf[12, Tf13c] = 1.0 
;IF Tfcount14c GT 0.0 THEN Tf[13, Tf14c] = 1.0 
;IF Tfcount15c GT 0.0 THEN Tf[14, Tf15c] = 1.0 

; Determine temperature- and DO- based neighboring habitat quality with a random component
EnvironHVDO = FLTARR(15, nROG)
EnvironHVT = FLTARR(15, nROG)
;EnvironHVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVDO[7, *] = DOUBLE(DOf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[8, *] = DOUBLE(DOf[8, *] * RANDOMU(seed, nROG, /DOUBLE))

EnvironHVDO[9, *] = DOUBLE(DOf[9, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[10, *] = DOUBLE(DOf[10, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[11, *] = DOUBLE(DOf[11, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[12, *] = DOUBLE(DOf[12, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[13, *] = DOUBLE(DOf[13, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVDO[14, *] = DOUBLE(DOf[14, *] * RANDOMU(seed, nROG, /DOUBLE))
;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component

;EnvironHVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nROG, /DOUBLE))
;EnvironHVT[7, *] = DOUBLE(Tf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[8, *] = DOUBLE(Tf[8, *] * RANDOMU(seed, nROG, /DOUBLE))

EnvironHVT[9, *] = DOUBLE(Tf[9, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[10, *] = DOUBLE(Tf[10, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[11, *] = DOUBLE(Tf[11, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[12, *] = DOUBLE(Tf[12, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[13, *] = DOUBLE(Tf[13, *] * RANDOMU(seed, nROG, /DOUBLE))
EnvironHVT[14, *] = DOUBLE(Tf[14, *] * RANDOMU(seed, nROG, /DOUBLE))
;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component
;PRINT, 'EnvironHVDO'
;PRINT, EnvironHVDO
;PRINT, 'EnvironHVT'
;PRINT, EnvironHVT

; Determine prey-based habitat quality
; Determines a prey length for each prey type (m) in the model
;prey length 
m = 10; the number of prey types 
PL = FLTARR(m, nROG)
PL[0, *] = RANDOMU(seed, nROG)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nROG)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nROG)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nROG)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nROG)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm
;PL[5, *] = FISHPREY[1, *]; length for yellow perch in mm 
;PL[6, *] = FISHPREY[5, *]; length for emerald shiner in mm 
;PL[7, *] = FISHPREY[9, *]; length for rainbow smelt in mm 
;PL[8, *] = FISHPREY[13, *]; length for round goby in mm 
;PL[9, *] = FISHPREY[17, *]; length for WALLEYE in mm 

; prey weight
PW = FLTARR(m, nROG); weight of each prey type
; assign weights to each prey type in g
PW[0, *] = 0.182 / 1000000.0; microzooplankton (rotifers) in g from Letcher 
PW[1, *] = EXP(ALOG(2.66) + 2.56 * ALOG(PL[1, *]))/0.14 / 1000000.0; small mesozooplankton (copepods) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[2, *] = EXP(ALOG(2.49) + 1.88 * ALOG(PL[2, *]))/0.12 / 1000000.0; large mesozooplankton (cladocerans) in g from Kawabata and Urabe 1998 Freshwater Biology
PW[3, *] = 0.0013*(PL[3, *]^2.69) / 0.12 / 1000.0; chironomids in g from Nalepa for 2005 Lake Erie data
PW[4, *] = 0.001; 60 / 1000000; invasive species in g, 500 to 700,~600ug dry = 6000 ug wet
;PW[5, *] = FISHPREY[2, *];
;PW[6, *] = FISHPREY[6, *];
;PW[7, *] = FISHPREY[10, *];
;PW[8, *] = FISHPREY[14, *];
;PW[9, *] = FISHPREY[18, *];

; convert prey biomass (g/L or m^2) into numbers/L or m^2
dens = FLTARR(m*(9+6), nROG)
; microzooplankton
;dens[0,*] = EnvironHV[0, *] / Pw[0]
dens[1,*] = EnvironHV[8, *] / Pw[0, *]
;dens[2,*] = EnvironHV[14, *] / Pw[0]
dens[3,*] = EnvironHV[22, *] / Pw[0, *]
dens[4,*] = EnvironHV[30, *] / Pw[0, *]
;dens[5,*] = EnvironHV[38, *] / Pw[0]
dens[6,*] = EnvironHV[46, *] / Pw[0, *]
;dens[7,*] = EnvironHV[54, *] / Pw[0]
dens[8,*] = EnvironHV[62, *] / Pw[0, *]

dens[54,*] = EnvironHV[77, *] / Pw[0, *]
dens[55,*] = EnvironHV[85, *] / Pw[0, *]
dens[56,*] = EnvironHV[92, *] / Pw[0, *]
dens[57,*] = EnvironHV[100, *] / Pw[0, *]
dens[58,*] = EnvironHV[108, *] / Pw[0, *]
dens[59,*] = EnvironHV[116, *] / Pw[0, *]

; small mesozooplankton
;dens[9,*] = EnvironHV[1, *] / Pw[1]
dens[10,*] = EnvironHV[9, *] / Pw[1, *]
;dens[11,*] = EnvironHV[15, *] / Pw[1]
dens[12,*] = EnvironHV[23, *] / Pw[1, *]
dens[13,*] = EnvironHV[31, *] / Pw[1, *]
;dens[14,*] = EnvironHV[39, *] / Pw[1]
dens[15,*] = EnvironHV[47, *] / Pw[1, *]
;dens[16,*] = EnvironHV[55, *] / Pw[1]
dens[17,*] = EnvironHV[63, *] / Pw[1, *]

dens[60,*] = EnvironHV[78, *] / Pw[1, *]
dens[61,*] = EnvironHV[86, *] / Pw[1, *]
dens[62,*] = EnvironHV[93, *] / Pw[1, *]
dens[63,*] = EnvironHV[101, *] / Pw[1, *]
dens[64,*] = EnvironHV[109, *] / Pw[1, *]
dens[65,*] = EnvironHV[117, *] / Pw[1, *]

; large mesozooplankton
;dens[18,*] = EnvironHV[2, *] / Pw[2]
dens[19,*] = EnvironHV[10, *] / Pw[2, *]
;dens[20,*] = EnvironHV[16, *] / Pw[2]
dens[21,*] = EnvironHV[24, *] / Pw[2, *]
dens[22,*] = EnvironHV[32, *] / Pw[2, *]
;dens[23,*] = EnvironHV[40, *] / Pw[2]
dens[24,*] = EnvironHV[48, *] / Pw[2, *]
;dens[25,*] = EnvironHV[56, *] / Pw[2]
dens[26,*] = EnvironHV[64, *] / Pw[2, *]

dens[66,*] = EnvironHV[79, *] / Pw[2, *]
dens[67,*] = EnvironHV[87, *] / Pw[2, *]
dens[68,*] = EnvironHV[94, *] / Pw[2, *]
dens[69,*] = EnvironHV[102, *] / Pw[2, *]
dens[70,*] = EnvironHV[110, *] / Pw[2, *]
dens[71,*] = EnvironHV[118, *] / Pw[2, *]

; benthos (chironmoids), numbers/m^2
;pbio3a = WHERE(EnvironHV[3, *] GT 0.0, pbio3acount, complement = pbio3ac, ncomplement = pbio3account)
;IF pbio3acount GT 0.0 THEN dens[27, pbio3a] = EnvironHV[3, pbio3a] / Pw[3] ELSE dens[27, pbio3ac] = 0.0
pbio3b = WHERE(EnvironHV[11, *] GT 0.0, pbio3bcount, complement = pbio3bc, ncomplement = pbio3bccount)
IF pbio3bcount GT 0.0 THEN dens[28, pbio3b] = EnvironHV[11, pbio3b] / Pw[3, pbio3b] ELSE dens[28, pbio3bc] = 0.0
;pbio3c = WHERE(EnvironHV[17, *] GT 0.0, pbio3ccount, complement = pbio3cc, ncomplement = pbio3cccount)
;IF pbio3ccount GT 0.0 THEN dens[29, pbio3c] = EnvironHV[17, pbio3c] / Pw[3] ELSE dens[29, pbio3cc] = 0.0
pbio3d = WHERE(EnvironHV[25, *] GT 0.0, pbio3dcount, complement = pbio3dc, ncomplement = pbio3dccount)
IF pbio3dcount GT 0.0 THEN dens[30, pbio3d] = EnvironHV[25, pbio3d] / Pw[3, pbio3d] ELSE dens[30, pbio3dc] = 0.0
pbio3e = WHERE(EnvironHV[33, *] GT 0.0, pbio3ecount, complement = pbio3ec, ncomplement = pbio3eccount)
IF pbio3ecount GT 0.0 THEN dens[31, pbio3e] = EnvironHV[33, pbio3e] / Pw[3, pbio3e] ELSE dens[31, pbio3ec] = 0.0
;pbio3f = WHERE(EnvironHV[41, *] GT 0.0, pbio3fcount, complement = pbio3fc, ncomplement = pbio3fccount)
;IF pbio3fcount GT 0.0 THEN dens[32, pbio3f] = EnvironHV[41, pbio3f] / Pw[3] ELSE dens[32, pbio3fc] = 0.0
pbio3g = WHERE(EnvironHV[49, *] GT 0.0, pbio3gcount, complement = pbio3gc, ncomplement = pbio3gccount)
IF pbio3gcount GT 0.0 THEN dens[33, pbio3g] = EnvironHV[49, pbio3g] / Pw[3, pbio3g] ELSE dens[33, pbio3gc] = 0.0
;pbio3h = WHERE(EnvironHV[57, *] GT 0.0, pbio3hcount, complement = pbio3hc, ncomplement = pbio3hccount)
;IF pbio3hcount GT 0.0 THEN dens[34, pbio3h] = EnvironHV[57, pbio3h] / Pw[3] ELSE dens[34, pbio3hc] = 0.0
pbio3i = WHERE(EnvironHV[65, *] GT 0.0, pbio3icount, complement = pbio3ic, ncomplement = pbio3iccount)
IF pbio3icount GT 0.0 THEN dens[35, pbio3i] = EnvironHV[65, pbio3i] / Pw[3, pbio3i] ELSE dens[35, pbio3ic] = 0.0

pbio3j = WHERE(EnvironHV[80, *] GT 0.0, pbio3jcount, complement = pbio3jc, ncomplement = pbio3jccount)
IF pbio3jcount GT 0.0 THEN dens[72, pbio3j] = EnvironHV[80, pbio3j] / Pw[3, pbio3j] ELSE dens[72, pbio3jc] = 0.0
pbio3k = WHERE(EnvironHV[88, *] GT 0.0, pbio3kcount, complement = pbio3kc, ncomplement = pbio3kccount)
IF pbio3kcount GT 0.0 THEN dens[73, pbio3k] = EnvironHV[88, pbio3k] / Pw[3, pbio3k] ELSE dens[73, pbio3kc] = 0.0
pbio3l = WHERE(EnvironHV[95, *] GT 0.0, pbio3lcount, complement = pbio3lc, ncomplement = pbio3lccount)
IF pbio3lcount GT 0.0 THEN dens[74, pbio3l] = EnvironHV[95, pbio3l] / Pw[3, pbio3l] ELSE dens[74, pbio3lc] = 0.0
pbio3o = WHERE(EnvironHV[103, *] GT 0.0, pbio3ocount, complement = pbio3oc, ncomplement = pbio3occount)
IF pbio3ocount GT 0.0 THEN dens[75, pbio3o] = EnvironHV[103, pbio3o] / Pw[3, pbio3o] ELSE dens[75, pbio3oc] = 0.0
pbio3p = WHERE(EnvironHV[111, *] GT 0.0, pbio3pcount, complement = pbio3pc, ncomplement = pbio3pccount)
IF pbio3pcount GT 0.0 THEN dens[76, pbio3p] = EnvironHV[111, pbio3p] / Pw[3, pbio3p] ELSE dens[76, pbio3pc] = 0.0
pbio3q = WHERE(EnvironHV[119, *] GT 0.0, pbio3qcount, complement = pbio3qc, ncomplement = pbio3qccount)
IF pbio3qcount GT 0.0 THEN dens[77, pbio3q] = EnvironHV[119, pbio3q] / Pw[3, pbio3q] ELSE dens[77, pbio3qc] = 0.0
 
; Invasive species
;dens[36,*] = EnvironHV[6, *] / Pw[4,*]
dens[37,*] = EnvironHV[14, *] / Pw[4,*]
;dens[38,*] = EnvironHV[20, *] / Pw[4, *]
dens[39,*] = EnvironHV[28, *] / Pw[4,*]
dens[40,*] = EnvironHV[36, *] / Pw[4, *]
;dens[41,*] = EnvironHV[44, *] / Pw[4, *]
dens[42,*] = EnvironHV[52, *] / Pw[4, *]
;dens[43,*] = EnvironHV[60, *] / Pw[4, *]
dens[44,*] = EnvironHV[68, *] / Pw[4, *]

dens[78,*] = EnvironHV[83, *] / Pw[4, *]
dens[79,*] = EnvironHV[91, *] / Pw[4, *]
dens[80,*] = EnvironHV[98, *] / Pw[4, *]
dens[81,*] = EnvironHV[106, *] / Pw[4, *]
dens[82,*] = EnvironHV[114, *] / Pw[4, *]
dens[83,*] = EnvironHV[122, *] / Pw[4, *]
  
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

dens[84,*] = EnvironHV[84, *] / Pw[5]
dens[85,*] = EnvironHV[92, *] / Pw[5]
dens[86,*] = EnvironHV[99, *] / Pw[5]
dens[87,*] = EnvironHV[107, *] / Pw[5]
dens[88,*] = EnvironHV[115, *] / Pw[5]
dens[89,*] = EnvironHV[123, *] / Pw[5]
;PRINT, 'Density =', dens

; Calculate Chesson's alpha for each prey type; YP[1, *]
Calpha = FLTARR(m, nROG)
Calpha[0, *] = 193499 * ROG[1, *]^(-7.64); for rotifers
Calpha[1, *] = 0.272 * ALOG(ROG[1, *]) - 0.3834; for calanoids
Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * ROG[1, *]))^(1.0 / 0.031) ; for cladocerans
PL3 = WHERE((PL[3] / ROG[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
IF (pl3count GT 0.0) THEN Calpha[3, PL3] = ABS(0.50 - 1.75 * (PL[3, PL3] / ROG[1, PL3])) 
IF (pl3ccount GT 0.0) THEN  Calpha[3, PL3c] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 
Length4 = WHERE(ROG[1, *] GT 60.0, L4count, complement = L4c, ncomplement = L4ccount)
IF (L4count GT 0.0) THEN Calpha[4, Length4] = 0.001 ; for bythotrephes CHANGE!!! with Rainbow smelt from Barnhisel and Harvey
IF (L4ccount GT 0.0) THEN Calpha[4, L4c] = 0.00
PL5a = WHERE((PL[5] / ROG[1, *]) LT 0.20, pl5acount, complement = pl5ac, ncomplement = pl5account)
IF (pl5acount GT 0.0) THEN Calpha[5, PL5a] = 0.25  ; NEED A FUNCTION, 0.5 - 1.75 * length $
IF (pl5account GT 0.0) THEN Calpha[5, PL5ac] = 0.00 ; for fish
;PRINT, 'Calpha =', Calpha

; Calculate attack probability using chesson's alpha = capture efficiency
TOT = FLTARR(9+6, nROG); total number of all prey atacked and captured
t = FLTARR(m*(9+6), nROG); total number of each prey atacked and captured
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
preyTOT = FLTARR(nROG)
preyTOT2 = FLTARR(9, nROG)
; For vertical movement
preyTOT3 = FLTARR(nROG)
preyTOT4 = FLTARR(7, nROG)

preyTOT = TOTAL(TOT[0:8, *], 1)  
preyTOT2[0, *] = preyTOT
preyTOT2[1, *] = preyTOT
preyTOT2[2, *] = preyTOT
preyTOT2[3, *] = preyTOT
preyTOT2[4, *] = preyTOT
preyTOT2[5, *] = preyTOT
preyTOT2[6, *] = preyTOT
preyTOT2[7, *] = preyTOT
preyTOT2[8, *] = preyTOT

preyTOT3 = TOTAL(TOT[8:14, *], 1)
preyTOT4[0, *] = preyTOT3
preyTOT4[1, *] = preyTOT3
preyTOT4[2, *] = preyTOT3
preyTOT4[3, *] = preyTOT3
preyTOT4[4, *] = preyTOT3
preyTOT4[5, *] = preyTOT3
preyTOT4[6, *] = preyTOT3
;PRINT, 'preyTOT2'
;PRINT, preyTOT2
;PRINT, 'preyTOT4'
;PRINT, preyTOT4

;FOR ivvv = 0L, nROG - 1L DO BEGIN
;  preyTOT[ivvv] = TOTAL(TOT[0:8, ivvv])  
;  preyTOT3[ivvv] = TOTAL(TOT[8:14, ivvv])  
;  preyTOT2[0:8, ivvv] = preyTOT[ivvv]
;  preyTOT4[0:6, ivvv] = preyTOT3[ivvv]
;ENDFOR
;PRINT, 'preyTOT2'
;PRINT, preyTOT2
;PRINT, 'preyTOT4'
;PRINT, preyTOT4
;PRINT, 'tot =', TOT

;Determine prey-based habitat quality in neighboring cells with a random component
EnvironHVprey = FLTARR(9+7, nROG)
; For horizontal movement
;EnvironHVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nROG, /DOUBLE)
;EnvironHVprey[7, *] = (TOT[7, *] / preyTOT2[7, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[8, *] = (TOT[8, *] / preyTOT2[8, *]) * RANDOMU(seed, nROG, /DOUBLE)
; For vertical movement
EnvironHVprey[9, *] = (TOT[9, *] / preyTOT4[1, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[10, *] = (TOT[10, *] / preyTOT4[2, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[11, *] = (TOT[11, *] / preyTOT4[3, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[12, *] = (TOT[12, *] / preyTOT4[4, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[13, *] = (TOT[13, *] / preyTOT4[5, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[14, *] = (TOT[14, *] / preyTOT4[6, *]) * RANDOMU(seed, nROG, /DOUBLE)
EnvironHVprey[15, *] = (TOT[8, *] / preyTOT4[0, *]) * RANDOMU(seed, nROG, /DOUBLE)
;PRINT, 'EnvironHVprey =', EnvironHVprey

EnvironHVSum = FLTARR(9+7, nROG)
;;EnvironHVSum[0, *] = DOUBLE((EnvironHVDO[0, *] * EnvironHVT[0, *] * EnvironHVprey[0, *])^(1.0/3.0))
;EnvironHVSum[1, *] = DOUBLE((EnvironHVDO[1, *] * EnvironHVT[1, *] * EnvironHVprey[1, *])^(1.0/3.0))
;;EnvironHVSum[2, *] = DOUBLE((EnvironHVDO[2, *] * EnvironHVT[2, *] * EnvironHVprey[2, *])^(1.0/3.0))
;EnvironHVSum[3, *] = DOUBLE((EnvironHVDO[3, *] * EnvironHVT[3, *] * EnvironHVprey[3, *])^(1.0/3.0))
;EnvironHVSum[4, *] = DOUBLE((EnvironHVDO[4, *] * EnvironHVT[4, *] * EnvironHVprey[4, *])^(1.0/3.0))
;;EnvironHVSum[5, *] = DOUBLE((EnvironHVDO[5, *] * EnvironHVT[5, *] * EnvironHVprey[5, *])^(1.0/3.0))
;EnvironHVSum[6, *] = DOUBLE((EnvironHVDO[6, *] * EnvironHVT[6, *] * EnvironHVprey[6, *])^(1.0/3.0))
;;EnvironHVSum[7, *] = DOUBLE((EnvironHVDO[7, *] * EnvironHVT[7, *] * EnvironHVprey[7, *])^(1.0/3.0))
;EnvironHVSum[8, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[8, *])^(1.0/3.0))
;
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
Gutfull2 = (100.- (ROG[60, *] < 100.0))/100.; < (1./3.); * RANDOMU(seed, nROG, /DOUBLE)
Gutfull = (1. - Gutfull2)/2.
;print, 'gutfull', transpose(gutfull)
;print, 'gutfull2', transpose(gutfull2)
;EnvironHVDO[1, *]^ * EnvironHVT[1, *] ^ * EnvironHVprey[1, *]^
EnvironHVSum[1, *] = DOUBLE(EnvironHVDO[1, *]^gutfull * EnvironHVT[1, *]^gutfull * EnvironHVprey[1, *]^gutfull2)
EnvironHVSum[3, *] = DOUBLE(EnvironHVDO[3, *]^gutfull * EnvironHVT[3, *]^gutfull * EnvironHVprey[3, *]^gutfull2)
EnvironHVSum[4, *] = DOUBLE(EnvironHVDO[4, *]^gutfull * EnvironHVT[4, *]^gutfull * EnvironHVprey[4, *]^gutfull2)
EnvironHVSum[6, *] = DOUBLE(EnvironHVDO[6, *]^gutfull * EnvironHVT[6, *]^gutfull * EnvironHVprey[6, *]^gutfull2)
EnvironHVSum[8, *] = DOUBLE(EnvironHVDO[8, *]^gutfull * EnvironHVT[8, *]^gutfull * EnvironHVprey[8, *]^gutfull2)

;EnvironHVSum[9, *] = DOUBLE(EnvironHVDO[9, *]^gutfull * EnvironHVT[9, *]^gutfull * EnvironHVprey[9, *]^gutfull2)
;EnvironHVSum[10, *] = DOUBLE(EnvironHVDO[10, *]^gutfull * EnvironHVT[10, *]^gutfull * EnvironHVprey[10, *]^gutfull2)
;EnvironHVSum[11, *] = DOUBLE(EnvironHVDO[11, *]^gutfull * EnvironHVT[11, *]^gutfull * EnvironHVprey[11, *]^gutfull2)
;EnvironHVSum[12, *] = DOUBLE(EnvironHVDO[12, *]^gutfull * EnvironHVT[12, *]^gutfull * EnvironHVprey[12, *]^gutfull2)
;EnvironHVSum[13, *] = DOUBLE(EnvironHVDO[13, *]^gutfull * EnvironHVT[13, *]^gutfull * EnvironHVprey[13, *]^gutfull2)
;EnvironHVSum[14, *] = DOUBLE(EnvironHVDO[14, *]^gutfull * EnvironHVT[14, *]^gutfull * EnvironHVprey[14, *]^gutfull2)
;EnvironHVSum[15, *] = DOUBLE(EnvironHVDO[8, *]^gutfull * EnvironHVT[8, *]^gutfull * EnvironHVprey[15, *]^gutfull2)

Gutfull4 = (1. - EnvironHVDO[9, *]);DO
Gutfull5 = (1. - EnvironHVDO[10, *])
Gutfull6 = (1. - EnvironHVDO[11, *])
Gutfull7 = (1. - EnvironHVDO[12, *])
Gutfull8 = (1. - EnvironHVDO[13, *])
Gutfull9 = (1. - EnvironHVDO[14, *])
Gutfull10 = (1. - EnvironHVDO[8, *])

;Gutfull11 = (1. - Gutfull4) * (1 - EnvironHVL[9, *]); Light
;Gutfull12 = (1. - Gutfull5) * (1 - EnvironHVL[10, *])
;Gutfull13 = (1. - Gutfull6) * (1 - EnvironHVL[11, *])
;Gutfull14 = (1. - Gutfull7) * (1 - EnvironHVL[12, *])
;Gutfull15 = (1. - Gutfull8) * (1 - EnvironHVL[13, *])
;Gutfull16 = (1. - Gutfull9) * (1 - EnvironHVL[14, *])
;Gutfull17 = (1. - Gutfull10) * (1 - EnvironHVL[8, *])

Gutfull18 = (1 - Gutfull4)*(Gutfull2); prey
Gutfull19 = (1 - Gutfull5)*(Gutfull2)
Gutfull20 = (1 - Gutfull6)*(Gutfull2)
Gutfull21 = (1 - Gutfull7)*(Gutfull2)
Gutfull22 = (1 - Gutfull8)*(Gutfull2)
Gutfull23 = (1 - Gutfull9)*(Gutfull2)
Gutfull24 = (1 - Gutfull10)*(Gutfull2)

Gutfull25 = (1 - Gutfull4 - Gutfull18); temperature
Gutfull26 = (1 - Gutfull5 - Gutfull19)
Gutfull27 = (1 - Gutfull6 - Gutfull20)
Gutfull28 = (1 - Gutfull7 - Gutfull21)
Gutfull29 = (1 - Gutfull8 - Gutfull22)
Gutfull30 = (1 - Gutfull9 - Gutfull23)
Gutfull31 = (1 - Gutfull10 - Gutfull24)

EnvironHVSum[9, *] = DOUBLE(EnvironHVDO[9, *]^gutfull4 * EnvironHVT[9, *]^gutfull25 * EnvironHVprey[9, *]^gutfull18)
EnvironHVSum[10, *] = DOUBLE(EnvironHVDO[10, *]^gutfull5 * EnvironHVT[10, *]^gutfull26 * EnvironHVprey[10, *]^gutfull19)
EnvironHVSum[11, *] = DOUBLE(EnvironHVDO[11, *]^gutfull6 * EnvironHVT[11, *]^gutfull27 * EnvironHVprey[11, *]^gutfull20)
EnvironHVSum[12, *] = DOUBLE(EnvironHVDO[12, *]^gutfull7 * EnvironHVT[12, *]^gutfull28 * EnvironHVprey[12, *]^gutfull21)
EnvironHVSum[13, *] = DOUBLE(EnvironHVDO[13, *]^gutfull8 * EnvironHVT[13, *]^gutfull29 * EnvironHVprey[13, *]^gutfull22)
EnvironHVSum[14, *] = DOUBLE(EnvironHVDO[14, *]^gutfull9 * EnvironHVT[14, *]^gutfull30 * EnvironHVprey[14, *]^gutfull23)
EnvironHVSum[15, *] = DOUBLE(EnvironHVDO[8, *]^gutfull10 * EnvironHVT[8, *]^gutfull31 * EnvironHVprey[15, *]^gutfull24)

;PRINT, 'GUT FULLNESS',YP[60, *]
;PRINT, 'ENVIRONHVSUM'
;PRINT, ENVIRONHVSUM


; Movement in x-dimension -> cells 4 & 5
; Movement in y-dimension -> cells 2 & 7
; fish could also end up in cells 1, 3, 6, and 8, depending on the within-cell locations
; If the current cell is best among neiboring cells, fish will move within the cell randomly.
; Movement in x-dimension
xMove = FLTARR(nROG)
; move to cell 5
xMovePos = WHERE((EnvironHVSum[4, *] GT EnvironHVSum[3, *]) AND (EnvironHVSum[4, *] GT EnvironHVSum[8, *]), xMovePoscount, complement = xMovePosN, ncomplement = xMovePosNcount)
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
;PRINT, 'xMove', xMove

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
;PRINT, 'yMovePos', yMovePos
;PRINT, 'yMoveNeg', yMoveNeg
;PRINT, 'yMoveNon', yMoveNon

; Movement in z-dimension
zMove = FLTARR(nROG)
;EnvironHVSumMax1 = MAX(EnvironHVSum[9:11, *], DIMENSION = 1) - MAX(EnvironHVSum[12:14, *], DIMENSION = 1)
;EnvironHVSumMax2 = MAX(EnvironHVSum[9:11, *], DIMENSION = 1) - EnvironHVSum[15, *]
;EnvironHVSumMax3 = MAX(EnvironHVSum[12:14, *], DIMENSION = 1) - EnvironHVSum[15, *]
EnvironHVSumMax1 = TOTAL(EnvironHVSum[9:11, *], 1)/3 - TOTAL(EnvironHVSum[12:14, *], 1)/3
EnvironHVSumMax2 = TOTAL(EnvironHVSum[9:11, *], 1)/3 - EnvironHVSum[15, *]
EnvironHVSumMax3 = TOTAL(EnvironHVSum[12:14, *], 1)/3 - EnvironHVSum[15, *]
; move downward (11)
zMoveNeg = WHERE((EnvironHVSumMax1 GT 0.) AND (EnvironHVSumMax2 GT 0.), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
IF zMoveNegcount GT 0.0 THEN zMove[zMoveNeg] = 11
; move upward (12)
zMovePos = WHERE((EnvironHVSumMax1 LT 0.) AND (EnvironHVSumMax3 GT 0.), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
IF zMovePoscount GT 0.0 THEN zMove[zMovePos] = 12
; stay (15)
zMoveNon = WHERE((EnvironHVSumMax2 LE 0.) AND (EnvironHVSumMax3 LE 0.), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
IF zMoveNoncount GT 0.0 THEN zMove[zMoveNon] = 15
;PRINT, 'zMove'
;PRINT, zMove

;zMovePos = FLTARR(nROG)
;zMoveNeg = FLTARR(nROG)
;zMoveNon = FLTARR(nROG)
;FOR iv = 0L, nROG - 1L DO BEGIN
;  ; move upward (11)
;  zMovePos[iv] = WHERE(((MAX(EnvironHVSum[9:11, iv]) GT MAX(EnvironHVSum[12:14, iv])) AND (MAX(EnvironHVSum[9:11, iv]) GT EnvironHVSum[15, iv])), zMovePoscount, complement = zMovePosN, ncomplement = zMovePosNcount)
;  IF zMovePoscount GT 0.0 THEN zMove[iv] = 11
;  ; move downward (12)
;  zMoveNeg[iv] = WHERE(((MAX(EnvironHVSum[9:11, iv]) LT MAX(EnvironHVSum[12:14, iv])) AND (MAX(EnvironHVSum[12:14, iv]) GT EnvironHVSum[15, iv])), zMoveNegcount, complement = zMoveNegN, ncomplement = zMoveNegNcount)
;  IF zMoveNegcount GT 0.0 THEN zMove[iv] = 12
;  ; stay (15)
;  zMoveNon[iv] = WHERE(((EnvironHVSum[15, iv] GE MAX(EnvironHVSum[9:11, iv])) AND (EnvironHVSum[15, iv] GE MAX(EnvironHVSum[12:14, iv]))), zMoveNoncount, complement = zMoveNonN, ncomplement = zMoveNonNcount)
;  IF zMoveNoncount GT 0.0 THEN zMove[iv] = 15
;  ;PRINT, 'zMovePos', zMovePos
;  ;PRINT, 'zMoveNeg', zMoveNeg
;  ;PRINT, 'zMoveNon', zMoveNon
;ENDFOR
;PRINT, 'zMove', zMove

;*******Determine the movement orientation****************************************************
  ; For now, each cell is assumed to have gradients between the current and neiboring cells
  ; fish are able to detect gradients within a cetain range... 

; Horizontal movement
HorOriAng = FLTARR(nROG)
;X-Y plane 1
xyMoveOri1 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] GT EnvironHVSum[1, *])), xyMoveOri1count, complement = xyMoveOri1N, ncomplement = xyMoveOri1Ncount)
xyMoveOri2 = WHERE(((xMove EQ 5) AND (yMove EQ 2) AND (EnvironHVSum[4, *] LE EnvironHVSum[1, *])), xyMoveOri2count, complement = xyMoveOri2N, ncomplement = xyMoveOri2Ncount)
IF (xyMoveOri1count GT 0.0) THEN HorOriAng[xyMoveOri1] = RANDOMU(seed, xyMoveOri1count)*(MAX(45)-MIN(0))+MIN(0)
IF (xyMoveOri2count GT 0.0) THEN HorOriAng[xyMoveOri2] = RANDOMU(seed, xyMoveOri2count)*(MAX(90)-MIN(45))+MIN(45)
;X-Y plane 2
xyMoveOri3 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] LE EnvironHVSum[1, *])), xyMoveOri3count, complement = xyMoveOri3N, ncomplement = xyMoveOri3Ncount)
xyMoveOri4 = WHERE(((xMove EQ 4) AND (yMove EQ 2) AND (EnvironHVSum[3, *] GT EnvironHVSum[1, *])), xyMoveOri4count, complement = xyMoveOri4N, ncomplement = xyMoveOri4Ncount)
IF (xyMoveOri3count GT 0.0) THEN HorOriAng[xyMoveOri3] = RANDOMU(seed, xyMoveOri3count)*(MAX(135)-MIN(90))+MIN(90)
IF (xyMoveOri4count GT 0.0) THEN HorOriAng[xyMoveOri4] = RANDOMU(seed, xyMoveOri4count)*(MAX(180)-MIN(135))+MIN(135)
;X-Y plane 3
xyMoveOri5 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] GT EnvironHVSum[6, *])), xyMoveOri5count, complement = xyMoveOri5N, ncomplement = xyMoveOri5Ncount)
xyMoveOri6 = WHERE(((xMove EQ 4) AND (yMove EQ 7) AND (EnvironHVSum[3, *] LE EnvironHVSum[6, *])), xyMoveOri6count, complement = xyMoveOri6N, ncomplement = xyMoveOri6Ncount)
IF (xyMoveOri5count GT 0.0) THEN HorOriAng[xyMoveOri5] = RANDOMU(seed, xyMoveOri5count)*(MAX(225)-MIN(180))+MIN(180)
IF (xyMoveOri6count GT 0.0) THEN HorOriAng[xyMoveOri6] = RANDOMU(seed, xyMoveOri6count)*(MAX(270)-MIN(225))+MIN(225)
;X-Y plane 4
xyMoveOri7 = WHERE(((xMove EQ 5) AND (yMove EQ 7) AND (EnvironHVSum[4, *] LE EnvironHVSum[6, *])), xyMoveOri7count, complement = xyMoveOri7N, ncomplement = xyMoveOri7Ncount)
xyMoveOri8 = WHERE(((xMove EQ 5) AND (yMove EQ 7) AND (EnvironHVSum[4, *] GT EnvironHVSum[6, *])), xyMoveOri8count, complement = xyMoveOri8N, ncomplement = xyMoveOri8Ncount)
IF (xyMoveOri7count GT 0.0) THEN HorOriAng[xyMoveOri7] = RANDOMU(seed, xyMoveOri7count)*(MAX(315)-MIN(270))+MIN(270)
IF (xyMoveOri8count GT 0.0) THEN HorOriAng[xyMoveOri8] = RANDOMU(seed, xyMoveOri8count)*(MAX(360)-MIN(315))+MIN(315)
; stay
xyMoveOri9 = WHERE(((xMove EQ 9) AND (yMove EQ 9)), xyMoveOri9count, complement = xyMoveOri9N, ncomplement = xyMoveOri9Ncount)
IF (xyMoveOri9count GT 0.0)  THEN HorOriAng[xyMoveOri9] = RANDOMU(seed, xyMoveOri9count)*(MAX(360)-MIN(0))+MIN(0)
; Movement in positive x-dimension only
xyMoveOri10 = WHERE(((xMove EQ 5) AND (yMove EQ 9)), xyMoveOri10count, complement = xyMoveOri10N, ncomplement = xyMoveOri10Ncount)
IF (xyMoveOri10count GT 0.0)  THEN HorOriAng[xyMoveOri10] = RANDOMU(seed, xyMoveOri10count)*(MAX(45)-MIN(-45))+MIN(-45)
; Movement in positive y-dimension only
xyMoveOri11 = WHERE(((xMove EQ 9) AND (yMove EQ 2)), xyMoveOri11count, complement = xyMoveOri11N, ncomplement = xyMoveOri11Ncount)
IF (xyMoveOri11count GT 0.0)  THEN HorOriAng[xyMoveOri11] = RANDOMU(seed, xyMoveOri11count)*(MAX(135)-MIN(45))+MIN(45)
; Movement in negative x-dimension only
xyMoveOri12 = WHERE(((xMove EQ 4) AND (yMove EQ 9)), xyMoveOri12count, complement = xyMoveOri12N, ncomplement = xyMoveOri12Ncount)
IF (xyMoveOri12count GT 0.0)  THEN HorOriAng[xyMoveOri12] = RANDOMU(seed, xyMoveOri12count)*(MAX(225)-MIN(135))+MIN(135)
; Movement in negative y-dimension only
xyMoveOri13 = WHERE(((xMove EQ 9) AND (yMove EQ 7)), xyMoveOri13count, complement = xyMoveOri13N, ncomplement = xyMoveOri13Ncount)
IF (xyMoveOri13count GT 0.0)  THEN HorOriAng[xyMoveOri13] = RANDOMU(seed, xyMoveOri13count)*(MAX(315)-MIN(225))+MIN(225)

; Vertical movement
VerOriAng = FLTARR(nROG)
; Downward
zMoveOri1 = WHERE((zMove EQ 11), zMoveOri1count, complement = zMoveOri1N, ncomplement = zMoveOri1Ncount)
IF (zMoveOri1count GT 0.0) THEN VerOriAng[zMoveOri1] = RANDOMU(seed, zMoveOri1count)*(MAX(180.)-MIN(90.))+MIN(90.)
; Upward
zMoveOri2 = WHERE((zMove EQ 12), zMoveOri2count, complement = zMoveOri2N, ncomplement = zMoveOri2Ncount)
IF (zMoveOri2count GT 0.0) THEN VerOriAng[zMoveOri2] = RANDOMU(seed, zMoveOri2count)*(MAX(90.)-MIN(0.))+MIN(0.)
; stay
zMoveOri3 = WHERE((zMove EQ 15), zMoveOri3count, complement = zMoveOri3N, ncomplement = zMoveOri3Ncount)
IF (zMoveOri3count GT 0.0)  THEN VerOriAng[zMoveOri3] = RANDOMU(seed, zMoveOri3count)*(MAX(135)-MIN(45))+MIN(45); randomu(seed, zMoveOri5count)*(max(180)-min(0))+min(0)
;PRINT,'HorOriAng', HorOriAng
;PRINT, 'COS(HorOriAng)', COS(HorOriAng)
;PRINT, 'SIN(HorOriAng)', SIN(HorOriAng)
;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)
; Convert degrees to radians
HorOriAng = HorOriAng*(!pi/180.)
VerOriAng = VerOriAng*(!pi/180.)
;PRINT, 'COS(HorOriAng)', COS(HorOriAng)
;PRINT, 'SIN(HorOriAng)', SIN(HorOriAng)
;PRINT, 'COS(VerOriAng)', COS(VerOriAng)
;PRINT, 'SIN(VerOriAng)', SIN(VerOriAng)

; Determine the distance and direction fish move uisng the habitat quality values estimated above
; Calculate fish swimming speed, S, in body lengths/sec
;PRINT, 'Length'
;PRINT, Length
SS = FLTARR(nROG)
S = FLTARR(nROG); NEED A SS FUNCTION FOR ROUND GOBY 
l = WHERE(ROG[1, *] LT 20.0, lcount, complement = ll, ncomplement = llcount)
IF (lcount GT 0.0) THEN $
S[l] = 3.0227 * ALOG(ROG[1, l]) - 4.6273; for walleye <20mm, Houde, 1969 
 ;SS equation based on data from Houde 1969 in body lengths/sec
IF (llcount GT 0.0) THEN $
S[ll] = 1000 * (0.263 + 0.72 * ROG[1, ll] + 0.012 * ROG[26, ll]); for walleye >20mm; Peake et al., 2000
; Converts SS into mm/s
SS = (S * ROG[1, *])
;PRINT, 'S =', S
;;PRINT, 'Swimming speed (mm/s)'
;;PRINT, SS
;PRINT, 'Swimming speed in x-dimension (mm/s)'
;PRINT, SS*COS(HorOriAng) * SIN(VerOriAng)
;PRINT, 'Swimming speed in y-dimension (mm/s)'
;PRINT, SS*SIN(HorOriAng) * SIN(VerOriAng)
;PRINT, 'Swimming speed in Z-dimension (mm/s)'
;PRINT, SS*COS(VerOriAng)
;PRINT, 'Water currents (mm/s) xyz'
;PRINT, newinput[12:15, ROG[14, *]]

; Calculate realized swimming speed (mm/s) in xyz-dimensions
MoveSpeed = FLTARR(5, nROG)
MoveSpeed[0, *] = SS*COS(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nROG, /DOUBLE) + newinput[12, ROG[14, *]]; with a random comopnent
MoveSpeed[1, *] = SS*SIN(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nROG, /DOUBLE) + newinput[13, ROG[14, *]];
IF (Lcount GT 0.0) THEN MoveSpeed[2, L] = SS[L] * COS(VerOriAng[L]) * RANDOMU(seed, Lcount, /DOUBLE)+ newinput[14, ROG[14, L]]; VERTICAL DIRECTION
IF (LLcount GT 0.0) THEN MoveSpeed[2, LL] = SS[LL]/(ts*10.) * COS(VerOriAng[LL]) * RANDOMU(seed, LLcount, /DOUBLE)+ newinput[14, ROG[14, LL]]; VERTICAL DIRECTION
MoveSpeed[3, *] = (MoveSpeed[0, *]^2 + MoveSpeed[1, *]^2)^0.5;  actual swimming speed, HORIZONTAL DIRECTION FOR NOW
; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
MoveSpeed[4, *] = (0.102*(ROG[1, *]/39.10/EXP(0.330)) + 30.3) * 10.0
;n critical swimming speed for adult yellow perch from Nelson, 1989, J. Exp. Biol.**************NEED TO FIND IT FOR WALLEYE*********
;***Maximum speed is also used for 'URGENCY' move? (from Goodwin et al., 2001)***
;PRINT, 'Realized movement speed (mm/s)'
;PRINT, MoveSpeed

; Distance fish move in each time step OR shorter subtime step???
ts2 = 120L; frequency of turning = >1
;******Determine the distance tarveled**********************************************************  
; Cell size in horizontal direction = 2.0km = 2000m = 2000000mm
xNewLoc = MoveSpeed[0, *]*ts*60.; distance (mm) in x-dimension
yNewLoc = MoveSpeed[1, *]*ts*60.; distance (mm) in y-dimension
zNewLoc = MoveSpeed[2, *]*ts*60.; distance (mm) in z-dimension
xNewLocWithinCell = FLTARR(nROG)
yNewLocWithinCell = FLTARR(nROG)
zNewLocWithinCell = FLTARR(nROG)
VerSize = FLTARR(nROG)
VerSize[*] = (Grid2D[3, ROG[13, *]]/20.)*1000.; in mm
;PRINT, 'Vertical cell size (mm)', VerSize

; Proportional within-cell location in x-dimension 
xMovePosLoc = WHERE((xNewLoc[*] GE 0.), xMovePosLoccount, complement = xMoveNegLoc, ncomplement = xMoveNegLoccount)
;xMovePosLoc = WHERE((xMove EQ 5.0) OR (yMove EQ 9.0), xMovePosLoccount, complement = xMovePosLocN, ncomplement = xMovePosLocNcount)
IF xMovePosLoccount GT 0.0 THEN xNewLocWithinCell[xMovePosLoc] = xNewLoc[xMovePosLoc]/2000000. + xOldLocWithinCell[xMovePosLoc]; proportional distance in x-dimension
;xMoveNegLoc = WHERE((xMove EQ 4.0), xMoveNegLoccount, complement = xMoveNegLocN, ncomplement = xMoveNegLocNcount)
IF xMoveNegLoccount GT 0.0 THEN xNewLocWithinCell[xMoveNegLoc] = xNewLoc[xMoveNegLoc]/2000000. + xOldLocWithinCell[xMoveNegLoc]; proportional distance in x-dimension

; Proportional within-cell location in y-dimension 
yMovePosLoc = WHERE((yNewLoc[*] GE 0.), yMovePosLoccount, complement = yMoveNegLoc, ncomplement = yMoveNegLoccount)
;yMovePosLoc = WHERE((yMove EQ 2.0) OR (yMove EQ 9.0), yMovePosLoccount, complement = yMovePosLocN, ncomplement = yMovePosLocNcount)
IF yMovePosLoccount GT 0.0 THEN yNewLocWithinCell[yMovePosLoc] = yNewLoc[yMovePosLoc]/2000000. + yOldLocWithinCell[yMovePosLoc]; proportional distance in y-dimension
;yMoveNegLoc = WHERE((yMove EQ 7.0), yMoveNegLoccount, complement = yMoveNegLocN, ncomplement = yMoveNegLocNcount)
IF yMoveNegLoccount GT 0.0 THEN yNewLocWithinCell[yMoveNegLoc] = yNewLoc[yMoveNegLoc]/2000000. + yOldLocWithinCell[yMoveNegLoc]; proportional distance in y-dimension  

; Proportional within-cell location in z-dimension 
zMovePosLoc = WHERE((zNewLoc[*] GE 0.), zMovePosLoccount, complement = zMoveNegLoc, ncomplement = zMoveNegLoccount)
;zMovePosLoc = WHERE((zMove EQ 12.0), zMovePosLoccount, complement = zMovePosLocN, ncomplement = zMovePosLocNcount)
IF zMovePosLoccount GT 0.0 THEN zNewLocWithinCell[zMovePosLoc] = zNewLoc[zMovePosLoc]/(VerSize[zMovePosLoc]) + zOldLocWithinCell[zMovePosLoc]; proportional distance in y-dimension
;zMoveNegLoc = WHERE((zMove EQ 11.0), zMoveNegLoccount, complement = zMoveNegLocN, ncomplement = zMoveNegLocNcount)
IF zMoveNegLoccount GT 0.0 THEN zNewLocWithinCell[zMoveNegLoc] = zNewLoc[zMoveNegLoc]/(VerSize[zMoveNegLoc]) + zOldLocWithinCell[zMoveNegLoc]; proportional distance in y-dimension  
;PRINT, 'Realized distance (mm) traveled in x-dimension per time step '
;PRINT, TRANSPOSE(xNewLoc)
;PRINT, 'Realized distance (mm) traveled in y-dimension per time step '
;PRINT, TRANSPOSE(yNewLoc)
;PRINT, 'Realized distance (mm) traveled in z-dimension per time step '
;PRINT, TRANSPOSE(zNewLoc)
;PRINT, 'Realized proportional distance traveled in x-dimension per time step '
;PRINT, xNewLocWithinCell
;PRINT, 'Realized proportional distance traveled in y-dimension per time step '
;PRINT, yNewLocWithinCell
;PRINT, 'Realized proportional distance traveled in z-dimension per time step '
;PRINT, zNewLocWithinCell
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
;  PRINT, 'YP[10, *]'
;  PRINT, TRANSPOSE(YP[10, *])
;  PRINT, 'YP[11, *]'
;  PRINT, TRANSPOSE(YP[11, *])
  
; *****Determine new cell locations****************************************************************************************
; Identify new 3D grid cell IDs
;xyMoveOut1 - Loc1
zMoveOut11 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND (zNewLocWithinCell GT 4.), zMoveOut11count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut12 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut12count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut13 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut13count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut14 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut14count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut15 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut15count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut16 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut16count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut17 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut17count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut18 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut18count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut19 = WHERE((NewGridXY[0, *] GE 0.0) AND (xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GT 1.0) AND (zNewLocWithinCell LT -3.), zMoveOut19count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut2 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut2count, complement = xyMoveOut2N, ncomplement = xyMoveOut2Ncount)
zMoveOut21 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND (zNewLocWithinCell GT 4.), zMoveOut21count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut22 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut22count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut23 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut23count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut24 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut24count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut25 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut25count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut26 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut26count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut27 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut27count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut28 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut28count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut29 = WHERE((NewGridXY[1, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GT 1.0)) AND (zNewLocWithinCell LT -3.), zMoveOut29count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut3 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)), xyMoveOut3count, complement = xyMoveOut3N, ncomplement = xyMoveOut3Ncount)
zMoveOut31 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND (zNewLocWithinCell GT 4.), zMoveOut31count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut32 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut32count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut33 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut33count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut34 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut34count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut35 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut35count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut36 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut36count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut37 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut37count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut38 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut38count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut39 = WHERE((NewGridXY[2, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GT 1.0)) AND (zNewLocWithinCell LT -3.), zMoveOut39count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut4 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut4count, complement = xyMoveOut4N, ncomplement = xyMoveOut4Ncount)
zMoveOut41 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell GT 4.), zMoveOut41count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut42 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut42count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut43 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut43count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut44 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut44count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut45 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut45count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut46 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut46count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut47 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut47count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut48 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut48count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut49 = WHERE((NewGridXY[3, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell LT -3.), zMoveOut49count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut5 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut5count, complement = xyMoveOut5N, ncomplement = xyMoveOut5Ncount)
zMoveOut51 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell GT 4.), zMoveOut51count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut52 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut52count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut53 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut53count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut54 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut54count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut55 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut55count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut56 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut56count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut57 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut57count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut58 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut58count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut59 = WHERE((NewGridXY[4, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell LT -3.), zMoveOut59count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut6 = WHERE(((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut6count, complement = xyMoveOut6N, ncomplement = xyMoveOut6Ncount)
zMoveOut61 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell GT 4.), zMoveOut61count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut62 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut62count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut63 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut63count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut64 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut64count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut65 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut65count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut66 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut66count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut67 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut67count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut68 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut68count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut69 = WHERE((NewGridXY[5, *] GE 0.0) AND ((xNewLocWithinCell LT 0.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell LT -3.), zMoveOut69count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut7 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut7count, complement = xyMoveOut7N, ncomplement = xyMoveOut7Ncount)
zMoveOut71 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell GT 4.), zMoveOut71count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut72 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut72count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut73 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut73count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut74 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut74count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut75 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut75count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut76 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut76count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut77 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut77count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut78 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut78count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut79 = WHERE((NewGridXY[6, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell LT -3.), zMoveOut79count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut8 = WHERE(((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)), xyMoveOut8count, complement = xyMoveOut8N, ncomplement = xyMoveOut8Ncount)
zMoveOut81 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell GT 4.), zMoveOut81count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut82 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut82count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut83 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut83count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut84 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut84count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut85 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut85count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut86 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut86count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut87 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut87count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut88 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut88count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut89 = WHERE((NewGridXY[7, *] GE 0.0) AND ((xNewLocWithinCell GT 1.0) AND (yNewLocWithinCell LT 0.0)) AND (zNewLocWithinCell LT -3.), zMoveOut89count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;xyMoveOut9 = WHERE(((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)), xyMoveOut9count, complement = xyMoveOut9N, ncomplement = xyMoveOut9Ncount)
zMoveOut91 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell GT 4.), zMoveOut91count, complement = zMoveOut1N, ncomplement = zMoveOut1Ncount)
zMoveOut92 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 3.) AND (zNewLocWithinCell LE 4.)), zMoveOut92count, complement = zMoveOut2N, ncomplement = zMoveOut2Ncount)
zMoveOut93 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 2.) AND (zNewLocWithinCell LE 3.)), zMoveOut93count, complement = zMoveOut3N, ncomplement = zMoveOut3Ncount)
zMoveOut94 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 1.) AND (zNewLocWithinCell LE 2.)), zMoveOut94count, complement = zMoveOut4N, ncomplement = zMoveOut4Ncount)
zMoveOut95 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT 0.) AND (zNewLocWithinCell LE 1.)), zMoveOut95count, complement = zMoveOut5N, ncomplement = zMoveOut5Ncount)
zMoveOut96 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -1.) AND (zNewLocWithinCell LE 0.)), zMoveOut96count, complement = zMoveOut6N, ncomplement = zMoveOut6Ncount)
zMoveOut97 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -2.) AND (zNewLocWithinCell LE -1.)), zMoveOut97count, complement = zMoveOut7N, ncomplement = zMoveOut7Ncount)
zMoveOut98 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND ((zNewLocWithinCell GT -3.) AND (zNewLocWithinCell LE -2.)), zMoveOut98count, complement = zMoveOut8N, ncomplement = zMoveOut8Ncount)
zMoveOut99 = WHERE((NewGridXY[8, *] GE 0.0) AND ((xNewLocWithinCell GE 0.0) AND (xNewLocWithinCell LE 1.0) AND (yNewLocWithinCell GE 0.0) AND (yNewLocWithinCell LE 1.0)) AND (zNewLocWithinCell LT -3.), zMoveOut99count, complement = zMoveOut9N, ncomplement = zMoveOut9Ncount)

;IF xyMoveOut1count GT 0.0 THEN BEGIN; XYloc = 1
  IF zMoveOut11count GT 0.0 THEN ROG[14, zMoveOut11] = LocHV[54, zMoveOut11];zMove[zMoveOut1] = 9
  IF zMoveOut12count GT 0.0 THEN ROG[14, zMoveOut12] = LocHV[54, zMoveOut12];zMove[zMoveOut2] = 9
  IF zMoveOut13count GT 0.0 THEN ROG[14, zMoveOut13] = LocHV[45, zMoveOut13];zMove[zMoveOut3] = 10
  IF zMoveOut14count GT 0.0 THEN ROG[14, zMoveOut14] = LocHV[36, zMoveOut14];zMove[zMoveOut4] = 11
  IF zMoveOut15count GT 0.0 THEN ROG[14, zMoveOut15] = LocHV[0, zMoveOut15];zMove[zMoveOut5] = 15
  IF zMoveOut16count GT 0.0 THEN ROG[14, zMoveOut16] = LocHV[27, zMoveOut16];zMove[zMoveOut6] = 12
  IF zMoveOut17count GT 0.0 THEN ROG[14, zMoveOut17] = LocHV[18, zMoveOut17];zMove[zMoveOut7] = 13
  IF zMoveOut18count GT 0.0 THEN ROG[14, zMoveOut18] = LocHV[9, zMoveOut18];zMove[zMoveOut8] = 14
  IF zMoveOut19count GT 0.0 THEN ROG[14, zMoveOut19] = LocHV[9, zMoveOut19];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut1', xyMoveOut1
;IF xyMoveOut2count GT 0.0 THEN BEGIN; XYloc = 2
  IF zMoveOut21count GT 0.0 THEN ROG[14, zMoveOut21] = LocHV[55, zMoveOut21];zMove[zMoveOut1] = 9
  IF zMoveOut22count GT 0.0 THEN ROG[14, zMoveOut22] = LocHV[55, zMoveOut22];zMove[zMoveOut2] = 9
  IF zMoveOut23count GT 0.0 THEN ROG[14, zMoveOut23] = LocHV[46, zMoveOut23];zMove[zMoveOut3] = 10
  IF zMoveOut24count GT 0.0 THEN ROG[14, zMoveOut24] = LocHV[37, zMoveOut24];zMove[zMoveOut4] = 11
  IF zMoveOut25count GT 0.0 THEN ROG[14, zMoveOut25] = LocHV[1, zMoveOut25];zMove[zMoveOut5] = 15
  IF zMoveOut26count GT 0.0 THEN ROG[14, zMoveOut26] = LocHV[28, zMoveOut26];zMove[zMoveOut6] = 12
  IF zMoveOut27count GT 0.0 THEN ROG[14, zMoveOut27] = LocHV[19, zMoveOut27];zMove[zMoveOut7] = 13
  IF zMoveOut28count GT 0.0 THEN ROG[14, zMoveOut28] = LocHV[10, zMoveOut28];zMove[zMoveOut8] = 14
  IF zMoveOut29count GT 0.0 THEN ROG[14, zMoveOut29] = LocHV[10, zMoveOut29];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut2', xyMoveOut2
;IF xyMoveOut3count GT 0.0 THEN BEGIN; XYloc = 3
  IF zMoveOut31count GT 0.0 THEN ROG[14, zMoveOut31] = LocHV[56, zMoveOut31];zMove[zMoveOut1] = 9
  IF zMoveOut32count GT 0.0 THEN ROG[14, zMoveOut32] = LocHV[56, zMoveOut32];zMove[zMoveOut2] = 9
  IF zMoveOut33count GT 0.0 THEN ROG[14, zMoveOut33] = LocHV[47, zMoveOut33];zMove[zMoveOut3] = 10
  IF zMoveOut34count GT 0.0 THEN ROG[14, zMoveOut34] = LocHV[38, zMoveOut34];zMove[zMoveOut4] = 11
  IF zMoveOut35count GT 0.0 THEN ROG[14, zMoveOut35] = LocHV[2, zMoveOut35];zMove[zMoveOut5] = 15
  IF zMoveOut36count GT 0.0 THEN ROG[14, zMoveOut36] = LocHV[29, zMoveOut36];zMove[zMoveOut6] = 12
  IF zMoveOut37count GT 0.0 THEN ROG[14, zMoveOut37] = LocHV[20, zMoveOut37];zMove[zMoveOut7] = 13
  IF zMoveOut38count GT 0.0 THEN ROG[14, zMoveOut38] = LocHV[11, zMoveOut38];zMove[zMoveOut8] = 14
  IF zMoveOut39count GT 0.0 THEN ROG[14, zMoveOut39] = LocHV[11, zMoveOut39];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut3', xyMoveOut3
;IF xyMoveOut4count GT 0.0 THEN BEGIN; XYloc = 4
  IF zMoveOut41count GT 0.0 THEN ROG[14, zMoveOut41] = LocHV[57, zMoveOut41];zMove[zMoveOut1] = 9
  IF zMoveOut42count GT 0.0 THEN ROG[14, zMoveOut42] = LocHV[57, zMoveOut42];zMove[zMoveOut2] = 9
  IF zMoveOut43count GT 0.0 THEN ROG[14, zMoveOut43] = LocHV[48, zMoveOut43];zMove[zMoveOut3] = 10
  IF zMoveOut44count GT 0.0 THEN ROG[14, zMoveOut44] = LocHV[39, zMoveOut44];zMove[zMoveOut4] = 11
  IF zMoveOut45count GT 0.0 THEN ROG[14, zMoveOut45] = LocHV[3, zMoveOut45];zMove[zMoveOut5] = 15
  IF zMoveOut46count GT 0.0 THEN ROG[14, zMoveOut46] = LocHV[30, zMoveOut46];zMove[zMoveOut6] = 12
  IF zMoveOut47count GT 0.0 THEN ROG[14, zMoveOut47] = LocHV[21, zMoveOut47];zMove[zMoveOut7] = 13
  IF zMoveOut48count GT 0.0 THEN ROG[14, zMoveOut48] = LocHV[12, zMoveOut48];zMove[zMoveOut8] = 14
  IF zMoveOut49count GT 0.0 THEN ROG[14, zMoveOut49] = LocHV[12, zMoveOut49];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut4', xyMoveOut4
;IF xyMoveOut5count GT 0.0 THEN BEGIN; XYloc = 5
  IF zMoveOut51count GT 0.0 THEN ROG[14, zMoveOut51] = LocHV[58, zMoveOut51];zMove[zMoveOut1] = 9
  IF zMoveOut52count GT 0.0 THEN ROG[14, zMoveOut52] = LocHV[58, zMoveOut52];zMove[zMoveOut2] = 9
  IF zMoveOut53count GT 0.0 THEN ROG[14, zMoveOut53] = LocHV[49, zMoveOut53];zMove[zMoveOut3] = 10
  IF zMoveOut54count GT 0.0 THEN ROG[14, zMoveOut54] = LocHV[40, zMoveOut54];zMove[zMoveOut4] = 11
  IF zMoveOut55count GT 0.0 THEN ROG[14, zMoveOut55] = LocHV[4, zMoveOut55];zMove[zMoveOut5] = 15
  IF zMoveOut56count GT 0.0 THEN ROG[14, zMoveOut56] = LocHV[31, zMoveOut56];zMove[zMoveOut6] = 12
  IF zMoveOut57count GT 0.0 THEN ROG[14, zMoveOut57] = LocHV[22, zMoveOut57];zMove[zMoveOut7] = 13
  IF zMoveOut58count GT 0.0 THEN ROG[14, zMoveOut58] = LocHV[13, zMoveOut58];zMove[zMoveOut8] = 14
  IF zMoveOut59count GT 0.0 THEN ROG[14, zMoveOut59] = LocHV[13, zMoveOut59];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut5', xyMoveOut5
;IF xyMoveOut6count GT 0.0 THEN BEGIN; XYloc = 6
  IF zMoveOut61count GT 0.0 THEN ROG[14, zMoveOut61] = LocHV[59, zMoveOut61];zMove[zMoveOut1] = 9
  IF zMoveOut62count GT 0.0 THEN ROG[14, zMoveOut62] = LocHV[59, zMoveOut62];zMove[zMoveOut2] = 9
  IF zMoveOut63count GT 0.0 THEN ROG[14, zMoveOut63] = LocHV[50, zMoveOut63];zMove[zMoveOut3] = 10
  IF zMoveOut64count GT 0.0 THEN ROG[14, zMoveOut64] = LocHV[41, zMoveOut64];zMove[zMoveOut4] = 11
  IF zMoveOut65count GT 0.0 THEN ROG[14, zMoveOut65] = LocHV[5, zMoveOut65];zMove[zMoveOut5] = 15
  IF zMoveOut66count GT 0.0 THEN ROG[14, zMoveOut66] = LocHV[32, zMoveOut66];zMove[zMoveOut6] = 12
  IF zMoveOut67count GT 0.0 THEN ROG[14, zMoveOut67] = LocHV[23, zMoveOut67];zMove[zMoveOut7] = 13
  IF zMoveOut68count GT 0.0 THEN ROG[14, zMoveOut68] = LocHV[14, zMoveOut68];zMove[zMoveOut8] = 14
  IF zMoveOut69count GT 0.0 THEN ROG[14, zMoveOut69] = LocHV[14, zMoveOut69];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut6', xyMoveOut6
;IF xyMoveOut7count GT 0.0 THEN BEGIN; XYloc = 7
  IF zMoveOut71count GT 0.0 THEN ROG[14, zMoveOut71] = LocHV[60, zMoveOut71];zMove[zMoveOut1] = 9
  IF zMoveOut72count GT 0.0 THEN ROG[14, zMoveOut72] = LocHV[60, zMoveOut72];zMove[zMoveOut2] = 9
  IF zMoveOut73count GT 0.0 THEN ROG[14, zMoveOut73] = LocHV[51, zMoveOut73];zMove[zMoveOut3] = 10
  IF zMoveOut74count GT 0.0 THEN ROG[14, zMoveOut74] = LocHV[42, zMoveOut74];zMove[zMoveOut4] = 11
  IF zMoveOut75count GT 0.0 THEN ROG[14, zMoveOut75] = LocHV[6, zMoveOut75];zMove[zMoveOut5] = 15
  IF zMoveOut76count GT 0.0 THEN ROG[14, zMoveOut76] = LocHV[33, zMoveOut76];zMove[zMoveOut6] = 12
  IF zMoveOut77count GT 0.0 THEN ROG[14, zMoveOut77] = LocHV[24, zMoveOut77];zMove[zMoveOut7] = 13
  IF zMoveOut78count GT 0.0 THEN ROG[14, zMoveOut78] = LocHV[15, zMoveOut78];zMove[zMoveOut8] = 14
  IF zMoveOut79count GT 0.0 THEN ROG[14, zMoveOut79] = LocHV[15, zMoveOut79];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut7', xyMoveOut7
;IF xyMoveOut8count GT 0.0 THEN BEGIN; XYloc = 8
  IF zMoveOut81count GT 0.0 THEN ROG[14, zMoveOut81] = LocHV[61, zMoveOut81];zMove[zMoveOut1] = 9
  IF zMoveOut82count GT 0.0 THEN ROG[14, zMoveOut82] = LocHV[61, zMoveOut82];zMove[zMoveOut2] = 9
  IF zMoveOut83count GT 0.0 THEN ROG[14, zMoveOut83] = LocHV[52, zMoveOut83];zMove[zMoveOut3] = 10
  IF zMoveOut84count GT 0.0 THEN ROG[14, zMoveOut84] = LocHV[43, zMoveOut84];zMove[zMoveOut4] = 11
  IF zMoveOut85count GT 0.0 THEN ROG[14, zMoveOut85] = LocHV[7, zMoveOut85];zMove[zMoveOut5] = 15
  IF zMoveOut86count GT 0.0 THEN ROG[14, zMoveOut86] = LocHV[34, zMoveOut86];zMove[zMoveOut6] = 12
  IF zMoveOut87count GT 0.0 THEN ROG[14, zMoveOut87] = LocHV[25, zMoveOut87];zMove[zMoveOut7] = 13
  IF zMoveOut88count GT 0.0 THEN ROG[14, zMoveOut88] = LocHV[16, zMoveOut88];zMove[zMoveOut8] = 14
  IF zMoveOut89count GT 0.0 THEN ROG[14, zMoveOut89] = LocHV[16, zMoveOut89];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut8', xyMoveOut8
;IF xyMoveOut9count GT 0.0 THEN BEGIN; XYloc = 9
  IF zMoveOut91count GT 0.0 THEN ROG[14, zMoveOut91] = LocHV[62, zMoveOut91];zMove[zMoveOut1] = 9
  IF zMoveOut92count GT 0.0 THEN ROG[14, zMoveOut92] = LocHV[62, zMoveOut92];zMove[zMoveOut2] = 9
  IF zMoveOut93count GT 0.0 THEN ROG[14, zMoveOut93] = LocHV[53, zMoveOut93];zMove[zMoveOut3] = 10
  IF zMoveOut94count GT 0.0 THEN ROG[14, zMoveOut94] = LocHV[44, zMoveOut94];zMove[zMoveOut4] = 11
  IF zMoveOut95count GT 0.0 THEN ROG[14, zMoveOut95] = LocHV[8, zMoveOut95];zMove[zMoveOut6] = 12
  IF zMoveOut96count GT 0.0 THEN ROG[14, zMoveOut96] = LocHV[35, zMoveOut96];zMove[zMoveOut6] = 12
  IF zMoveOut97count GT 0.0 THEN ROG[14, zMoveOut97] = LocHV[26, zMoveOut97];zMove[zMoveOut7] = 13
  IF zMoveOut98count GT 0.0 THEN ROG[14, zMoveOut98] = LocHV[17, zMoveOut98];zMove[zMoveOut8] = 14
  IF zMoveOut99count GT 0.0 THEN ROG[14, zMoveOut99] = LocHV[17, zMoveOut99];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut9', xyMoveOut9
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
;PRINT, 'NewGrid 3D ID with vertical movement'
;PRINT, TRANSPOSE(ROG[14, *])
;PRINT, 'NewInput[2, WAE[14, *]]', transpose(NewInput[2, ROG[14, *]])
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
;
; Movement in positive y-dimension 
yMoveOutPos = WHERE((yNewLocWithinCell GT 1.0), yMoveOutPoscount, complement = yMoveOutPosN, ncomplement = yMoveOutPosNcount)
IF yMoveOutPoscount GT 0.0 THEN yNewLocWithinCell[yMoveOutPos] = yNewLocWithinCell[yMoveOutPos] - FLOOR(yNewLocWithinCell[yMoveOutPos])
; Movement in negative y-dimension
yMoveOutNeg = WHERE((yNewLocWithinCell LT 0.0), yMoveOutNegcount, complement = yMoveOutNegN, ncomplement = yMoveOutNegNcount)
IF yMoveOutNegcount GT 0.0 THEN yNewLocWithinCell[yMoveOutNeg] = yNewLocWithinCell[yMoveOutNeg] + CEIL(ABS(yNewLocWithinCell[yMoveOutNeg]))  
;PRINT,'yMoveOutPos', yMoveOutPos
;PRINT,'yMoveOutNeg', yMoveOutNeg
;
; Movement in positive z-dimension 
zMoveOutPos = WHERE((zNewLocWithinCell GT 1.0), zMoveOutPoscount, complement = zMoveOutPosN, ncomplement = zMoveOutPosNcount)
IF zMoveOutPoscount GT 0.0 THEN zNewLocWithinCell[zMoveOutPos] = zNewLocWithinCell[zMoveOutPos] - FLOOR(zNewLocWithinCell[zMoveOutPos])
; Movement in negative y-dimension
zMoveOutNeg = WHERE((zNewLocWithinCell LT 0.0), zMoveOutNegcount, complement = zMoveOutNegN, ncomplement = zMoveOutNegNcount)
IF zMoveOutNegcount GT 0.0 THEN zNewLocWithinCell[zMoveOutNeg] = zNewLocWithinCell[zMoveOutNeg] + CEIL(ABS(zNewLocWithinCell[zMoveOutNeg]))  
;PRINT,'zMoveOutPos', zMoveOutPos
;PRINT,'zMoveOutNeg', zMoveOutNeg
;PRINT, 'New within-cell location in x-dimension in new cell '
;PRINT, xNewLocWithinCell
;PRINT, 'New within-cell location in y-dimension in new cell '
;PRINT, yNewLocWithinCell
;PRINT, 'New within-cell location in z-dimension in new cell '
;PRINT, zNewLocWithinCell

; Update environmental conditions of fish
NewFishEnviron = FLTARR(20, nROG)
NewFishEnviron[0:15, *] = NewInput[*, ROG[14, *]];YP[14, *] New 3D gridcell ID
NewFishEnviron[8, *] = TotBenBio[ROG[14, *]];YP[14, *] New TotBenBio
NewFishEnviron[16, *] = xNewLocWithinCell; New within-cell location in x-dimension in new cell
NewFishEnviron[17, *] = yNewLocWithinCell; New within-cell location in y-dimension in new cell
NewFishEnviron[18, *] = zNewLocWithinCell; New within-cell location in z-dimension in new cell
;PRINT, NewFishEnviron
;PRINT, 'TotBenBio '
;PRINT, TOTBENBIO[0:199]

;******THE FOLLOWING IS FOR FINDING MULTIPLE FISH IN THE SAME CELL***************************************
;FishLocID = WAE[14, *]
;UniqFishLocID = FishLocID[UNIQ(FishLocID, SORT(FishLocID))]
;PRINT, 'FishLocID'
;PRINT, TRANSPOSE(FishLocID)
;PRINT, 'UniqFishLocID'
;PRINT, (UniqFishLocID)
;PRINT, 'Number of superindividuals =', N_ELEMENTS(FishLocID)
;PRINT, 'Number of superindividuals in different cells =', N_ELEMENTS(UniqFishLocID)
;PRINT, 'Number of superindividuals in SAME cells =', N_ELEMENTS(FishLocID) - N_ELEMENTS(UniqFishLocID)
;
;PRINT, 'FishLocID RANKED SUBSCRIPTS'
;PRINT, (RANKS(FISHLOCID(SORT(FishLocID))))
;PRINT, 'FishLocID SORTED SUBSCRIPTS'
;PRINT, (SORT(FishLocID))

;;DupFishLocID = FLTARR(nWAE)
;;FOR I = 0, N_ELEMENTS(UniqFishLocID)-1L DO BEGIN
;DupFishLocID = WHERE(FishLocID[UNIQ(FishLocID, SORT(FishLocID))], DupFishLocIDcount, complement = NonDupFishLocID, ncomplement = NonDupFishLocIDcount)
;;ENDFOR
;PRINT, NonDupFishLocID
;***************************************************************************************************************

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Round Goby Movement Ends Here'
RETURN, NewFishEnviron; TURN OFF WHEN TESTING
END