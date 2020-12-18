FUNCTION WAEMoveHV, ts, iHour, WAE, nWAE, NewInput, TotBenBio, FISHPREY, Grid2D, xOldLocWithinCell, yOldLocWithinCell, $
zOldLocWithinCell, Oxydebt

;function determines movement in X,Y,Z direction for all walleye
;******This function works only for moving to neighboring cells (wiht relatively large horizontal cells)***************************

;**********************TEST ONLY*************************************************
;PRO WAEMoveHV, WAE, nWAE, NewInput, TotBenBio, FISHPREY, Grid2D, xOldLocWithinCell, yOldLocWithinCell, zOldLocWithinCell
;; NEED to change NewInputFiles, YPinitial, YEPacclT, YEPacclDO for testing
;nWAE = 50000L; number of SI YP, MOVEMENT PARAMETER
;nYP = 100000L; the numbner of yellow perch superindividuals
;nEMS = 100000L;
;nRAS = 100000L;
;nROG = 100000L;
;
;ts = 15L; in minutes
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
;NpopWAE = 50000000L; number of WAE individuals
;WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, NewInput); MOVEMENT PARAMETER
;
;NpopYP = 50000000L; number of YP individuals
;NpopEMS = 50000000L; number of EMS individuals
;NpopRAS = 50000000L; number of RAS individuals
;NpopROG = 50000000L; number of ROG individuals
;YP = YEPinitial(NpopYP, nYP, TotBenBio, NewInput)
;EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, NewInput)
;RAS = RASinitial(NpopRAS, nRAS, TotBenBio, NewInput)
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput)
;
;Grid2D = GridCells2D(); MOVEMENT PARAMETER
;
;Temp = WAE[19, *]
;
;;Length = WAE[1, *]; in mm
;;Weight = WAE[2, *]; in g
;;TacclR = WAE[27, *]
;;TacclC = WAE[26, *]
;;Tamb = WAE[19, *]
;;DOa = WAE[20, *]
;;DOacclR = WAE[29, *]
;;DOacclC = WAE[28, *]
;;DOacclim = WAEacclDO(DOacclR, DOacclC, DOa, TacclR, TacclC, Tamb, ts, Length, Weight, nWAE); MOVEMENT PARAMETER
;
;xOldLocWithinCell = WAE[39, *]; MOVEMENT PARAMETER 
;yOldLocWithinCell = WAE[40, *]; MOVEMENT PARAMETER
;zOldLocWithinCell = WAE[41, *]; MOVEMENT PARAMETER
;
; ;********************************************************
;; Creat a fish prey array for potential predators, per L
;nGridcell = 77500L
;YEPFISHPREY = FLTARR(5L, nGridcell)
;RASFISHPREY = FLTARR(5L, nGridcell)
;EMSFISHPREY = FLTARR(5L, nGridcell)
;ROGFISHPREY = FLTARR(5L, nGridcell)
;WAEFISHPREY = FLTARR(5L, nGridcell)
;FISHPREY = FLTARR(20L, nGridcell)
;
;; yellow perch as prey
;YEPFISHPREY[0, YP[14, *]] = YP[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;YEPFISHPREY[1, YP[14, *]] = YP[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;YEPFISHPREY[2, YP[14, *]] = YP[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;YEPFISHPREY[3, YP[14, *]] = YP[2, *] * YP[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; emrald shiner as prey
;EMSFISHPREY[0, EMS[14, *]] = EMS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;EMSFISHPREY[1, EMS[14, *]] = EMS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;EMSFISHPREY[2, EMS[14, *]] = EMS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;EMSFISHPREY[3, EMS[14, *]] = EMS[2, *] * EMS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; rainbow smelt as prey
;RASFISHPREY[0, RAS[14, *]] = RAS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;RASFISHPREY[1, RAS[14, *]] = RAS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;RASFISHPREY[2, RAS[14, *]] = RAS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;RASFISHPREY[3, RAS[14, *]] = RAS[2, *] * RAS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; round goby as prey
;ROGFISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;ROGFISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;ROGFISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;ROGFISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; walleye as prey
;WAEFISHPREY[0, WAE[14, *]] = WAE[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;WAEFISHPREY[1, WAE[14, *]] = WAE[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;WAEFISHPREY[2, WAE[14, *]] = WAE[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;WAEFISHPREY[3, WAE[14, *]] = WAE[2, *] * WAE[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;FISHPREY[0:3, *] = YEPFISHPREY[0:3, *]
;FISHPREY[4:7, *] = EMSFISHPREY[0:3, *]
;FISHPREY[8:11, *] = RASFISHPREY[0:3, *]
;FISHPREY[12:15, *] = ROGFISHPREY[0:3, *]
;FISHPREY[16:19, *] = WAEFISHPREY[0:3, *]
;***********************************************************************************

PRINT, 'Walleye Movement Begins Here'

;FishPrey = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)

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

LocH = FLTARR(30, nWAE)
LocHV = FLTARR(9*7L, nWAE)
NewGridXY = FLTARR(10L, nWAE)
;; 1 in X and Y dimensions
;LocH[0, *] = WAE[10, *] - 1L
;LocH[1, *] = WAE[11, *] + 1L
;; 2
;LocH[2, *] = WAE[10, *]
;LocH[3, *] = WAE[11, *] + 1L
;; 3
;LocH[4, *] = WAE[10, *] + 1L
;LocH[5, *] = WAE[11, *] + 1L
; 4
LocH[6, *] = WAE[10, *] - 1L
; LocH[6, *] NEEDS TO BE > 43.0
;NZLocH6 = WHERE((LocH[6, *] GE 43.0), NZLocH6count, complement = ZLocH6, ncomplement = ZLocH6count);
;IF (NZLocH6count GT 0.0) THEN LocH[6, NZLocH6] = LocH[6, NZLocH6]
;IF (ZLocH6count GT 0.0) THEN LocH[6, ZLocH6] = WAE[10, ZLocH6]+1L
LocH[7, *] = WAE[11, *] 
; 5
LocH[8, *] = WAE[10, *] + 1L
; LocH[6, *] NEEDS TO BE < 140.0
;NZLocH8 = WHERE((LocH[8, *] LE 140.0), NZLocH8count, complement = ZLocH8, ncomplement = ZLocH8count);
;IF (NZLocH8count GT 0.0) THEN LocH[8, NZLocH8] = LocH[8, NZLocH8]
;IF (ZLocH8count GT 0.0) THEN LocH[8, ZLocH8] = WAE[10, ZLocH8]-1L
LocH[9, *] = WAE[11, *] 
; 6
;LocH[10, *] = WAE[10, *] - 1L
;LocH[11, *] = WAE[11, *] - 1L
;; 7
;LocH[12, *] = WAE[10, *] 
;LocH[13, *] = WAE[11, *] - 1L
;; 8
;LocH[14, *] = WAE[10, *] + 1L
;LocH[15, *] = WAE[11, *] - 1L
;; No move = the current cell
;LocH[16, *] = WAE[10, *]
;LocH[17, *] = WAE[11, *]
;PRINT, 'LocH', LocH[0:17, *]
 
;****************Identify neighbouring cell IDs***********************************************************************************
FOR ihh = 0L, nWAE - 1L DO BEGIN;*****Time-consuming part*********************************************************************
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
;PRINT, 'LOCH21'
;PRINT, TRANSPOSE(LocH[21, 0:200])
;PRINT, 'LOCH22'
;PRINT, TRANSPOSE(LocH[22, 0:200])
;PRINT, 'WAE[13, *]'
;PRINT, TRANSPOSE(WAE[13, 0:200])
;
; Check if a grid cell exists
NNLocH21 = WHERE((LocH[21, *] GE 0.0), NNLocH21count, complement = NLocH21, ncomplement = NLocH21count);
NNLocH22 = WHERE((LocH[22, *] GE 0.0), NNLocH22count, complement = NLocH22, ncomplement = NLocH22count);
;PRINT, 'NLocH21'
;PRINT, NLocH21
;PRINT, 'NLocH22'
;PRINT, NLocH22
; If not, fish can move in the one direction...
IF (NNLocH21count GT 0.0) THEN NewGridXY[3, NNLocH21] = LocH[21, NNLocH21]
IF (NLocH21count GT 0.0) THEN NewGridXY[3, NLocH21] = LocH[21, NLocH21];
IF (NNLocH22count GT 0.0) THEN NewGridXY[4, NNLocH22] = LocH[22, NNLocH22]
IF (NLocH22count GT 0.0) THEN NewGridXY[4, NLocH22] = LocH[22, NLocH22];
;PRINT, 'NewGridXY3'
;PRINT, TRANSPOSE(NewGridXY[3,0:100])
;PRINT, 'NewGridXY4'
;PRINT, TRANSPOSE(NewGridXY[4,0:100])
;PRINT, 'YP[13, *]'
;PRINT, TRANSPOSE(YP[13, 0:500])

IF (NNLocH21count GT 0.0) THEN NewGridXY[0, NNLocH21] = NewGridXY[3, NNLocH21]+1L; 1-> 4. +1
NewGridXY[1, *] = WAE[13, *]+1L; 2-> CURRENT +1 
IF (NNLocH22count GT 0.0) THEN NewGridXY[2, NNLocH22] = NewGridXY[4, NNLocH22]+1L; 3 ->5. +1
;NewGridXY[3, PLocH21]; 4 
;NewGridXY[4, PLocH22];  5
NewGridXY[5, *] = NewGridXY[3, *]-1L; 6 -> 4. - 1
NewGridXY[6, *] = WAE[13, *]-1L; 7 -> CURRENT - 1
NewGridXY[7, *] = NewGridXY[4, *]-1L; 8 -> 5. - 1
;; NewGridXY and YP[13, *] NEED TO BE > 0.0
;NZNewGridXY3 = WHERE((NewGridXY[3, *] GT 0.0), NZNewGridXY3count, complement = ZNewGridXY3, ncomplement = ZNewGridXY3count);
;NZWAE13 = WHERE((WAE[13, *] GT 0.0), NZWAE13count, complement = ZWAE13, ncomplement = ZWAE13count);
;NZNewGridXY4 = WHERE((NewGridXY[4, *] GT 0.0), NZNewGridXY4count, complement = ZNewGridXY4, ncomplement = ZNewGridXY4count);
;IF (NZNewGridXY3count GT 0.0) THEN NewGridXY[5, NZNewGridXY3] = NewGridXY[3, NZNewGridXY3]-1L; 6 -> 4. -1
;IF (ZNewGridXY3count GT 0.0) THEN NewGridXY[5, ZNewGridXY3] = NewGridXY[3, ZNewGridXY3]+1L; 6 -> 4. -1
;IF (NZWAE13count GT 0.0) THEN NewGridXY[6, NZWAE13] = WAE[13, NZWAE13]-1L; 7 -> CURRENT -1
;IF (ZWAE13count GT 0.0) THEN NewGridXY[6, ZWAE13] = WAE[13, ZWAE13]+1L; 7 -> CURRENT -1
;IF (NZNewGridXY4count GT 0.0) THEN NewGridXY[7, NZNewGridXY4] = NewGridXY[4, NZNewGridXY4]-1L; 8 -> 5. -1
;IF (ZNewGridXY4count GT 0.0) THEN NewGridXY[7, ZNewGridXY4] = NewGridXY[4, ZNewGridXY4]+1L; 8 -> 5. -1
NewGridXY[8, *] = WAE[13, *]; 9 -> CURRENT
;PRINT, 'NewGridXY', NewGridXY
 
; Test if the Xloc OF THE CELL is still the same... 
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
LocNH17A = WHERE((NewGridXY[1, *] GE 0.0) AND (Grid2D[0, NewGridXY[1, *]] EQ WAE[10, *]), LocNH17Acount, complement = LocH17A, ncomplement = LocH17Acount) ; LocH[7, *]
IF (LocNH17Acount GT 0.) THEN NewGridXY[1, LocNH17A] = NewGridXY[1, LocNH17A]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH17Acount GT 0.) THEN NewGridXY[1, LocH17A] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 

LocNH17B = WHERE((NewGridXY[6, *] GE 0.0) AND (Grid2D[0, NewGridXY[6, *]] EQ WAE[10, *]), LocNH17Bcount, complement = LocH17B, ncomplement = LocH17Bcount) ; LocH[7, *]
IF (LocNH17Bcount GT 0.) THEN NewGridXY[6, LocNH17B] = NewGridXY[6, LocNH17B]; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
IF (LocH17Bcount GT 0.) THEN NewGridXY[6, LocH17B] = -1L; ELSE NewGridXY[0, LocH7] = NewGridXY[0, LocH7] 
;PRINT, 'LocNH17count', LocNH17count
;PRINT, 'NewGridXY'
;PRINT, transpose(NewGridXY[*,0:100])
;
;*****GRID ID STRATS FROM "0"************************
; NEED a previous vertical position of fish before the horizontal movemnent
; Current layer*********to get 3D ID, =20*(2DID) + (depth-1)***************
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

IF (NZNewGridXY0count GT 0.0) THEN LocHV[0, NZNewGridXY0] = (NewGridXY[0, NZNewGridXY0])*20. + (WAE[12, NZNewGridXY0]-1.) 
IF (NZNewGridXY1count GT 0.0) THEN LocHV[1, NZNewGridXY1] = (NewGridXY[1, NZNewGridXY1])*20. + (WAE[12, NZNewGridXY1]-1.) 
IF (NZNewGridXY2count GT 0.0) THEN LocHV[2, NZNewGridXY2] = (NewGridXY[2, NZNewGridXY2])*20. + (WAE[12, NZNewGridXY2]-1.) 
IF (NZNewGridXY3count GT 0.0) THEN LocHV[3, NZNewGridXY3] = (NewGridXY[3, NZNewGridXY3])*20. + (WAE[12, NZNewGridXY3]-1.) 
IF (NZNewGridXY4count GT 0.0) THEN LocHV[4, NZNewGridXY4] = (NewGridXY[4, NZNewGridXY4])*20. + (WAE[12, NZNewGridXY4]-1.) 
IF (NZNewGridXY5count GT 0.0) THEN LocHV[5, NZNewGridXY5] = (NewGridXY[5, NZNewGridXY5])*20. + (WAE[12, NZNewGridXY5]-1.) 
IF (NZNewGridXY6count GT 0.0) THEN LocHV[6, NZNewGridXY6] = (NewGridXY[6, NZNewGridXY6])*20. + (WAE[12, NZNewGridXY6]-1.) 
IF (NZNewGridXY7count GT 0.0) THEN LocHV[7, NZNewGridXY7] = (NewGridXY[7, NZNewGridXY7])*20. + (WAE[12, NZNewGridXY7]-1.) 
IF (NZNewGridXY8count GT 0.0) THEN LocHV[8, NZNewGridXY8] = (NewGridXY[8, NZNewGridXY8])*20. + (WAE[12, NZNewGridXY8]-1.) 

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

; Vertical movement is restricted within 3 cells below and above the current layer FOR NOW
;DOWNWARD MOVEMNT
; current layer -3
Lower3Cells0 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[0, *] GE 0.0), Lower3Cells0count)
Lower3Cells1 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[1, *] GE 0.0), Lower3Cells1count)
Lower3Cells2 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[2, *] GE 0.0), Lower3Cells2count)
Lower3Cells3 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[3, *] GE 0.0), Lower3Cells3count)
Lower3Cells4 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[4, *] GE 0.0), Lower3Cells4count)
Lower3Cells5 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[5, *] GE 0.0), Lower3Cells5count)
Lower3Cells6 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[6, *] GE 0.0), Lower3Cells6count)
Lower3Cells7 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[7, *] GE 0.0), Lower3Cells7count)
Lower3Cells8 = WHERE((WAE[12, *] LE 17L) AND (NewGridXY[8, *] GE 0.0), Lower3Cells8count)
IF Lower3Cells0count GT 0. THEN LocHV[9, Lower3Cells0] = LocHV[0, Lower3Cells0]+3L; 
IF Lower3Cells1count GT 0. THEN LocHV[10, Lower3Cells1] = LocHV[1, Lower3Cells1]+3L; 
IF Lower3Cells2count GT 0. THEN LocHV[11, Lower3Cells2] = LocHV[2, Lower3Cells2]+3L; 
IF Lower3Cells3count GT 0. THEN LocHV[12, Lower3Cells3] = LocHV[3, Lower3Cells3]+3L; 
IF Lower3Cells4count GT 0. THEN LocHV[13, Lower3Cells4] = LocHV[4, Lower3Cells4]+3L; 
IF Lower3Cells5count GT 0. THEN LocHV[14, Lower3Cells5] = LocHV[5, Lower3Cells5]+3L; 
IF Lower3Cells6count GT 0. THEN LocHV[15, Lower3Cells6] = LocHV[6, Lower3Cells6]+3L; 
IF Lower3Cells7count GT 0. THEN LocHV[16, Lower3Cells7] = LocHV[7, Lower3Cells7]+3L; 
IF Lower3Cells8count GT 0. THEN LocHV[17, Lower3Cells8] = LocHV[8, Lower3Cells8]+3L; 
NONLower3Cells0 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[0, *] GE 0.0), NonLower3Cells0count)
NONLower3Cells1 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[1, *] GE 0.0), NonLower3Cells1count)
NONLower3Cells2 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[2, *] GE 0.0), NonLower3Cells2count)
NONLower3Cells3 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[3, *] GE 0.0), NonLower3Cells3count)
NONLower3Cells4 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[4, *] GE 0.0), NonLower3Cells4count)
NONLower3Cells5 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[5, *] GE 0.0), NonLower3Cells5count)
NONLower3Cells6 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[6, *] GE 0.0), NonLower3Cells6count)
NONLower3Cells7 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[7, *] GE 0.0), NonLower3Cells7count)
NONLower3Cells8 = WHERE((WAE[12, *] GT 17L) AND (NewGridXY[8, *] GE 0.0), NonLower3Cells8count)
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
Lower2Cells0 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[0, *] GE 0.0), Lower2Cells0count)
Lower2Cells1 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[1, *] GE 0.0), Lower2Cells1count)
Lower2Cells2 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[2, *] GE 0.0), Lower2Cells2count)
Lower2Cells3 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[3, *] GE 0.0), Lower2Cells3count)
Lower2Cells4 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[4, *] GE 0.0), Lower2Cells4count)
Lower2Cells5 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[5, *] GE 0.0), Lower2Cells5count)
Lower2Cells6 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[6, *] GE 0.0), Lower2Cells6count)
Lower2Cells7 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[7, *] GE 0.0), Lower2Cells7count)
Lower2Cells8 = WHERE((WAE[12, *] LE 18L) AND (NewGridXY[8, *] GE 0.0), Lower2Cells8count)
IF Lower2Cells0count GT 0. THEN LocHV[18, Lower2Cells0] = LocHV[0, Lower2Cells0]+2L; 
IF Lower2Cells1count GT 0. THEN LocHV[19, Lower2Cells1] = LocHV[1, Lower2Cells1]+2L; 
IF Lower2Cells2count GT 0. THEN LocHV[20, Lower2Cells2] = LocHV[2, Lower2Cells2]+2L; 
IF Lower2Cells3count GT 0. THEN LocHV[21, Lower2Cells3] = LocHV[3, Lower2Cells3]+2L; 
IF Lower2Cells4count GT 0. THEN LocHV[22, Lower2Cells4] = LocHV[4, Lower2Cells4]+2L; 
IF Lower2Cells5count GT 0. THEN LocHV[23, Lower2Cells5] = LocHV[5, Lower2Cells5]+2L; 
IF Lower2Cells6count GT 0. THEN LocHV[24, Lower2Cells6] = LocHV[6, Lower2Cells6]+2L; 
IF Lower2Cells7count GT 0. THEN LocHV[25, Lower2Cells7] = LocHV[7, Lower2Cells7]+2L; 
IF Lower2Cells8count GT 0. THEN LocHV[26, Lower2Cells8] = LocHV[8, Lower2Cells8]+2L; 
NONLower2Cells0 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[0, *] GE 0.0), NonLower2Cells0count)
NONLower2Cells1 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[1, *] GE 0.0), NonLower2Cells1count)
NONLower2Cells2 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[2, *] GE 0.0), NonLower2Cells2count)
NONLower2Cells3 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[3, *] GE 0.0), NonLower2Cells3count)
NONLower2Cells4 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[4, *] GE 0.0), NonLower2Cells4count)
NONLower2Cells5 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[5, *] GE 0.0), NonLower2Cells5count)
NONLower2Cells6 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[6, *] GE 0.0), NonLower2Cells6count)
NONLower2Cells7 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[7, *] GE 0.0), NonLower2Cells7count)
NONLower2Cells8 = WHERE((WAE[12, *] GT 18L) AND (NewGridXY[8, *] GE 0.0), NonLower2Cells8count)
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
Lower1Cells0 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[0, *] GE 0.0), Lower1Cells0count)
Lower1Cells1 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[1, *] GE 0.0), Lower1Cells1count)
Lower1Cells2 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[2, *] GE 0.0), Lower1Cells2count)
Lower1Cells3 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[3, *] GE 0.0), Lower1Cells3count)
Lower1Cells4 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[4, *] GE 0.0), Lower1Cells4count)
Lower1Cells5 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[5, *] GE 0.0), Lower1Cells5count)
Lower1Cells6 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[6, *] GE 0.0), Lower1Cells6count)
Lower1Cells7 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[7, *] GE 0.0), Lower1Cells7count)
Lower1Cells8 = WHERE((WAE[12, *] LE 19L) AND (NewGridXY[8, *] GE 0.0), Lower1Cells8count)
IF Lower1Cells0count GT 0. THEN LocHV[27, Lower1Cells0] = LocHV[0, Lower1Cells0]+1L; 
IF Lower1Cells1count GT 0. THEN LocHV[28, Lower1Cells1] = LocHV[1, Lower1Cells1]+1L; 
IF Lower1Cells2count GT 0. THEN LocHV[29, Lower1Cells2] = LocHV[2, Lower1Cells2]+1L; 
IF Lower1Cells3count GT 0. THEN LocHV[30, Lower1Cells3] = LocHV[3, Lower1Cells3]+1L; 
IF Lower1Cells4count GT 0. THEN LocHV[31, Lower1Cells4] = LocHV[4, Lower1Cells4]+1L; 
IF Lower1Cells5count GT 0. THEN LocHV[32, Lower1Cells5] = LocHV[5, Lower1Cells5]+1L; 
IF Lower1Cells6count GT 0. THEN LocHV[33, Lower1Cells6] = LocHV[6, Lower1Cells6]+1L; 
IF Lower1Cells7count GT 0. THEN LocHV[34, Lower1Cells7] = LocHV[7, Lower1Cells7]+1L; 
IF Lower1Cells8count GT 0. THEN LocHV[35, Lower1Cells8] = LocHV[8, Lower1Cells8]+1L; 
NONLower1Cells0 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[0, *] GE 0.0), NonLower1Cells0count)
NONLower1Cells1 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[1, *] GE 0.0), NonLower1Cells1count)
NONLower1Cells2 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[2, *] GE 0.0), NonLower1Cells2count)
NONLower1Cells3 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[3, *] GE 0.0), NonLower1Cells3count)
NONLower1Cells4 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[4, *] GE 0.0), NonLower1Cells4count)
NONLower1Cells5 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[5, *] GE 0.0), NonLower1Cells5count)
NONLower1Cells6 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[6, *] GE 0.0), NonLower1Cells6count)
NONLower1Cells7 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[7, *] GE 0.0), NonLower1Cells7count)
NONLower1Cells8 = WHERE((WAE[12, *] GT 19L) AND (NewGridXY[8, *] GE 0.0), NonLower1Cells8count)
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
Upper1Cells0 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[0, *] GE 0.0), Upper1Cells0count)
Upper1Cells1 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[1, *] GE 0.0), Upper1Cells1count)
Upper1Cells2 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[2, *] GE 0.0), Upper1Cells2count)
Upper1Cells3 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[3, *] GE 0.0), Upper1Cells3count)
Upper1Cells4 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[4, *] GE 0.0), Upper1Cells4count)
Upper1Cells5 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[5, *] GE 0.0), Upper1Cells5count)
Upper1Cells6 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[6, *] GE 0.0), Upper1Cells6count)
Upper1Cells7 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[7, *] GE 0.0), Upper1Cells7count)
Upper1Cells8 = WHERE((WAE[12, *] GE 2L) AND (NewGridXY[8, *] GE 0.0), Upper1Cells8count)
IF Upper1Cells0count GT 0. THEN LocHV[36, Upper1Cells0] = LocHV[0, Upper1Cells0]-1L;
IF Upper1Cells1count GT 0. THEN LocHV[37, Upper1Cells1] = LocHV[1, Upper1Cells1]-1L;
IF Upper1Cells2count GT 0. THEN LocHV[38, Upper1Cells2] = LocHV[2, Upper1Cells2]-1L;
IF Upper1Cells3count GT 0. THEN LocHV[39, Upper1Cells3] = LocHV[3, Upper1Cells3]-1L;
IF Upper1Cells4count GT 0. THEN LocHV[40, Upper1Cells4] = LocHV[4, Upper1Cells4]-1L;
IF Upper1Cells5count GT 0. THEN LocHV[41, Upper1Cells5] = LocHV[5, Upper1Cells5]-1L;
IF Upper1Cells6count GT 0. THEN LocHV[42, Upper1Cells6] = LocHV[6, Upper1Cells6]-1L;
IF Upper1Cells7count GT 0. THEN LocHV[43, Upper1Cells7] = LocHV[7, Upper1Cells7]-1L;
IF Upper1Cells8count GT 0. THEN LocHV[44, Upper1Cells8] = LocHV[8, Upper1Cells8]-1L;
NONUpper1Cells0 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[0, *] GE 0.0), NonUpper1Cells0count)
NONUpper1Cells1 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[1, *] GE 0.0), NonUpper1Cells1count)
NONUpper1Cells2 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[2, *] GE 0.0), NonUpper1Cells2count)
NONUpper1Cells3 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[3, *] GE 0.0), NonUpper1Cells3count)
NONUpper1Cells4 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[4, *] GE 0.0), NonUpper1Cells4count)
NONUpper1Cells5 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[5, *] GE 0.0), NonUpper1Cells5count)
NONUpper1Cells6 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[6, *] GE 0.0), NonUpper1Cells6count)
NONUpper1Cells7 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[7, *] GE 0.0), NonUpper1Cells7count)
NONUpper1Cells8 = WHERE((WAE[12, *] LT 2L) AND (NewGridXY[8, *] GE 0.0), NonUpper1Cells8count)
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
Upper2Cells0 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[0, *] GE 0.0), Upper2Cells0count)
Upper2Cells1 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[1, *] GE 0.0), Upper2Cells1count)
Upper2Cells2 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[2, *] GE 0.0), Upper2Cells2count)
Upper2Cells3 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[3, *] GE 0.0), Upper2Cells3count)
Upper2Cells4 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[4, *] GE 0.0), Upper2Cells4count)
Upper2Cells5 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[5, *] GE 0.0), Upper2Cells5count)
Upper2Cells6 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[6, *] GE 0.0), Upper2Cells6count)
Upper2Cells7 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[7, *] GE 0.0), Upper2Cells7count)
Upper2Cells8 = WHERE((WAE[12, *] GE 3L) AND (NewGridXY[8, *] GE 0.0), Upper2Cells8count)
IF Upper2Cells0count GT 0. THEN LocHV[45, Upper2Cells0] = LocHV[0, Upper2Cells0]-2L;
IF Upper2Cells1count GT 0. THEN LocHV[46, Upper2Cells1] = LocHV[1, Upper2Cells1]-2L;
IF Upper2Cells2count GT 0. THEN LocHV[47, Upper2Cells2] = LocHV[2, Upper2Cells2]-2L;
IF Upper2Cells3count GT 0. THEN LocHV[48, Upper2Cells3] = LocHV[3, Upper2Cells3]-2L;
IF Upper2Cells4count GT 0. THEN LocHV[49, Upper2Cells4] = LocHV[4, Upper2Cells4]-2L;
IF Upper2Cells5count GT 0. THEN LocHV[50, Upper2Cells5] = LocHV[5, Upper2Cells5]-2L;
IF Upper2Cells6count GT 0. THEN LocHV[51, Upper2Cells6] = LocHV[6, Upper2Cells6]-2L;
IF Upper2Cells7count GT 0. THEN LocHV[52, Upper2Cells7] = LocHV[7, Upper2Cells7]-2L;
IF Upper2Cells8count GT 0. THEN LocHV[53, Upper2Cells8] = LocHV[8, Upper2Cells8]-2L;
NONUpper2Cells0 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[0, *] GE 0.0), NonUpper2Cells0count)
NONUpper2Cells1 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[1, *] GE 0.0), NonUpper2Cells1count)
NONUpper2Cells2 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[2, *] GE 0.0), NonUpper2Cells2count)
NONUpper2Cells3 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[3, *] GE 0.0), NonUpper2Cells3count)
NONUpper2Cells4 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[4, *] GE 0.0), NonUpper2Cells4count)
NONUpper2Cells5 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[5, *] GE 0.0), NonUpper2Cells5count)
NONUpper2Cells6 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[6, *] GE 0.0), NonUpper2Cells6count)
NONUpper2Cells7 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[7, *] GE 0.0), NonUpper2Cells7count)
NONUpper2Cells8 = WHERE((WAE[12, *] LT 3L) AND (NewGridXY[8, *] GE 0.0), NonUpper2Cells8count)
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
Upper3Cells0 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[0, *] GE 0.0), Upper3Cells0count)
Upper3Cells1 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[1, *] GE 0.0), Upper3Cells1count)
Upper3Cells2 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[2, *] GE 0.0), Upper3Cells2count)
Upper3Cells3 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[3, *] GE 0.0), Upper3Cells3count)
Upper3Cells4 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[4, *] GE 0.0), Upper3Cells4count)
Upper3Cells5 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[5, *] GE 0.0), Upper3Cells5count)
Upper3Cells6 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[6, *] GE 0.0), Upper3Cells6count)
Upper3Cells7 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[7, *] GE 0.0), Upper3Cells7count)
Upper3Cells8 = WHERE((WAE[12, *] GE 4L) AND (NewGridXY[8, *] GE 0.0), Upper3Cells8count)
IF Upper3Cells0count GT 0. THEN LocHV[54, Upper3Cells0] = LocHV[0, Upper3Cells0]-3L;
IF Upper3Cells1count GT 0. THEN LocHV[55, Upper3Cells1] = LocHV[1, Upper3Cells1]-3L;
IF Upper3Cells2count GT 0. THEN LocHV[56, Upper3Cells2] = LocHV[2, Upper3Cells2]-3L;
IF Upper3Cells3count GT 0. THEN LocHV[57, Upper3Cells3] = LocHV[3, Upper3Cells3]-3L;
IF Upper3Cells4count GT 0. THEN LocHV[58, Upper3Cells4] = LocHV[4, Upper3Cells4]-3L;
IF Upper3Cells5count GT 0. THEN LocHV[59, Upper3Cells5] = LocHV[5, Upper3Cells5]-3L;
IF Upper3Cells6count GT 0. THEN LocHV[60, Upper3Cells6] = LocHV[6, Upper3Cells6]-3L;
IF Upper3Cells7count GT 0. THEN LocHV[61, Upper3Cells7] = LocHV[7, Upper3Cells7]-3L;
IF Upper3Cells8count GT 0. THEN LocHV[62, Upper3Cells8] = LocHV[8, Upper3Cells8]-3L;
NONUpper3Cells0 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[0, *] GE 0.0), NonUpper3Cells0count)
NONUpper3Cells1 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[1, *] GE 0.0), NonUpper3Cells1count)
NONUpper3Cells2 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[2, *] GE 0.0), NonUpper3Cells2count)
NONUpper3Cells3 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[3, *] GE 0.0), NonUpper3Cells3count)
NONUpper3Cells4 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[4, *] GE 0.0), NonUpper3Cells4count)
NONUpper3Cells5 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[5, *] GE 0.0), NonUpper3Cells5count)
NONUpper3Cells6 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[6, *] GE 0.0), NonUpper3Cells6count)
NONUpper3Cells7 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[7, *] GE 0.0), NonUpper3Cells7count)
NONUpper3Cells8 = WHERE((WAE[12, *] LT 4L) AND (NewGridXY[8, *] GE 0.0), NonUpper3Cells8count)
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
EnvironHV = FLTARR(180L, nWAE)

;ADJUSTING DAILY LIGHT INTENSITY
IF ((iHour LE 4L) OR (iHour GT 20L)) THEN newinput[11, *]= .5; night time light intensity
;NZNewGridXY0 - 1
;NZNewGridXY1 - 2
;NZNewGridXY2 - 3
;NZNewGridXY3 - 4
;NZNewGridXY4 - 5
;NZNewGridXY5 - 6
;NZNewGridXY6 - 7 
;NZNewGridXY7 - 8
;NZNewGridXY8 - 9

; Environmental conditions in 1
;EnvironHV[0:5, *] = newinput[5:10, LocHV[0, *]]; x3zoopl, bentho, temp, DO
;EnvironHV[6, *] = 0.0; invasive species
;EnvironHV[7, *] = 0.0; fish

; Environmental conditions in (2)
EnvironHV[8:13, NZNewGridXY1] = newinput[5:10, LocHV[1, NZNewGridXY1]]
EnvironHV[11, NZNewGridXY1] = TotBenBio[LocHV[1, NZNewGridXY1]]
EnvironHV[14, NZNewGridXY1] = 0.0; invasive species
EnvironHV[15, NZNewGridXY1] = newinput[11, LocHV[1, NZNewGridXY1]]; light
; Grid cell size for fish arrays, 4000000*(Grid2D[3, LocHV[1, *]]/20L) * 1000.
EnvironHV[124, NZNewGridXY1] = FISHPREY[3, LocHV[1, NZNewGridXY1]] / (4000000*(Grid2D[3, LocHV[1, NZNewGridXY1]]/20.) * 1000.); YEP
EnvironHV[125, NZNewGridXY1] = FISHPREY[7, LocHV[1, NZNewGridXY1]] / (4000000*(Grid2D[3, LocHV[1, NZNewGridXY1]]/20.) * 1000.); EMS
EnvironHV[126, NZNewGridXY1] = FISHPREY[11, LocHV[1, NZNewGridXY1]] / (4000000*(Grid2D[3, LocHV[1, NZNewGridXY1]]/20.) * 1000.); RAS
EnvironHV[127, NZNewGridXY1] = FISHPREY[15, LocHV[1, NZNewGridXY1]] / (4000000*(Grid2D[3, LocHV[1, NZNewGridXY1]]/20.) * 1000.); ROG
EnvironHV[168, NZNewGridXY1] = FISHPREY[19, LocHV[1, NZNewGridXY1]] / (4000000*(Grid2D[3, LocHV[1, NZNewGridXY1]]/20.) * 1000.); WAE
; Environmental conditions in 3
;EnvironHV[14:19, *] = newinput[5:10, LocHV[2, *]]
;EnvironHV[20, *] = 0.0; invasive species
;EnvironHV[21, *] = 0.0; fish

; Environmental conditions in (4)
EnvironHV[22:27, NZNewGridXY3] = newinput[5:10, LocHV[3, NZNewGridXY3]]
EnvironHV[25, NZNewGridXY3] = TotBenBio[LocHV[3, NZNewGridXY3]]
EnvironHV[28, NZNewGridXY3] = 0.0; invasive species
EnvironHV[29, NZNewGridXY3] = newinput[11, LocHV[3, NZNewGridXY3]]; light
EnvironHV[128, NZNewGridXY3] = FISHPREY[3, LocHV[3, NZNewGridXY3]] / (4000000*(Grid2D[3, LocHV[3, NZNewGridXY3]]/20.) * 1000.); YEP
EnvironHV[129, NZNewGridXY3] = FISHPREY[7, LocHV[3, NZNewGridXY3]] / (4000000*(Grid2D[3, LocHV[3, NZNewGridXY3]]/20.) * 1000.); EMS
EnvironHV[130, NZNewGridXY3] = FISHPREY[11, LocHV[3, NZNewGridXY3]] / (4000000*(Grid2D[3, LocHV[3, NZNewGridXY3]]/20.) * 1000.); RAS
EnvironHV[131, NZNewGridXY3] = FISHPREY[15, LocHV[3, NZNewGridXY3]] / (4000000*(Grid2D[3, LocHV[3, NZNewGridXY3]]/20.) * 1000.); ROG
EnvironHV[169, NZNewGridXY3] = FISHPREY[19, LocHV[3, NZNewGridXY3]] / (4000000*(Grid2D[3, LocHV[3, NZNewGridXY3]]/20.) * 1000.); WAE

; Environmental conditions in (5)
EnvironHV[30:35, NZNewGridXY4] = newinput[5:10, LocHV[4, NZNewGridXY4]]; 
EnvironHV[33, NZNewGridXY4] = TotBenBio[LocHV[4, NZNewGridXY4]]
EnvironHV[36, NZNewGridXY4] = 0.0; invasive species
EnvironHV[37, NZNewGridXY4] = newinput[11, LocHV[4, NZNewGridXY4]]; light
EnvironHV[132, NZNewGridXY4] = FISHPREY[3, LocHV[4, NZNewGridXY4]] / (4000000*(Grid2D[3, LocHV[4, NZNewGridXY4]]/20.) * 1000.); YEP
EnvironHV[133, NZNewGridXY4] = FISHPREY[7, LocHV[4, NZNewGridXY4]] / (4000000*(Grid2D[3, LocHV[4, NZNewGridXY4]]/20.) * 1000.); EMS
EnvironHV[134, NZNewGridXY4] = FISHPREY[11, LocHV[4, NZNewGridXY4]] / (4000000*(Grid2D[3, LocHV[4, NZNewGridXY4]]/20.) * 1000.); RAS
EnvironHV[135, NZNewGridXY4] = FISHPREY[15, LocHV[4, NZNewGridXY4]] / (4000000*(Grid2D[3, LocHV[4, NZNewGridXY4]]/20.) * 1000.); ROG
EnvironHV[170, NZNewGridXY4] = FISHPREY[19, LocHV[4, NZNewGridXY4]]/ (4000000*(Grid2D[3, LocHV[4, NZNewGridXY4]]/20.) * 1000.); WAE

; Environmental conditions in 6
;EnvironHV[38:43, *] = newinput[5:10, LocHV[5, *]]
;EnvironHV[44, *] = 0.0; invasive species
;EnvironHV[45, *] = 0.0; fish

; Environmental conditions in (7)
EnvironHV[46:51, NZNewGridXY6] = newinput[5:10, LocHV[6, NZNewGridXY6]]
EnvironHV[49, NZNewGridXY6] = TotBenBio[LocHV[6, NZNewGridXY6]]
EnvironHV[52, NZNewGridXY6] = 0.0; invasive species
EnvironHV[53, NZNewGridXY6] = newinput[11, LocHV[6, NZNewGridXY6]]; light

EnvironHV[136, NZNewGridXY6] = FISHPREY[3, LocHV[6, NZNewGridXY6]] / (4000000*(Grid2D[3, LocHV[6, NZNewGridXY6]]/20.) * 1000.); YEP
EnvironHV[137, NZNewGridXY6] = FISHPREY[7, LocHV[6, NZNewGridXY6]] / (4000000*(Grid2D[3, LocHV[6, NZNewGridXY6]]/20.) * 1000.); EMS
EnvironHV[138, NZNewGridXY6] = FISHPREY[11, LocHV[6, NZNewGridXY6]] / (4000000*(Grid2D[3, LocHV[6, NZNewGridXY6]]/20.) * 1000.); RAS
EnvironHV[139, NZNewGridXY6] = FISHPREY[15, LocHV[6, NZNewGridXY6]] / (4000000*(Grid2D[3, LocHV[6, NZNewGridXY6]]/20.) * 1000.); ROG
EnvironHV[171, NZNewGridXY6] = FISHPREY[19, LocHV[6, NZNewGridXY6]]/ (4000000*(Grid2D[3, LocHV[6, NZNewGridXY6]]/20.) * 1000.); ROG

; Environmental conditions in 8
;EnvironHV[54:59, *] = newinput[5:10, LocHV[7, *]]; 
;EnvironHV[60, *] = 0.0; invasive species
;EnvironHV[61, *] = 0.0; fish

; Environmental conditions in (X or 9) = the current cell
EnvironHV[62:67, NZNewGridXY8] = newinput[5:10, LocHV[8, NZNewGridXY8]]
EnvironHV[65, NZNewGridXY8] = TotBenBio[LocHV[8, NZNewGridXY8]]
EnvironHV[68, NZNewGridXY8] = 0.0; invasive species
EnvironHV[69, NZNewGridXY8] = newinput[11, LocHV[8, NZNewGridXY8]]; light
EnvironHV[140, NZNewGridXY8] = FISHPREY[3, LocHV[8, NZNewGridXY8]] / (4000000*(Grid2D[3, LocHV[8, NZNewGridXY8]]/20.) * 1000.); YEP
EnvironHV[141, NZNewGridXY8] = FISHPREY[7, LocHV[8, NZNewGridXY8]] / (4000000*(Grid2D[3, LocHV[8, NZNewGridXY8]]/20.) * 1000.); EMS
EnvironHV[142, NZNewGridXY8] = FISHPREY[11, LocHV[8, NZNewGridXY8]] / (4000000*(Grid2D[3, LocHV[8, NZNewGridXY8]]/20.) * 1000.); RAS
EnvironHV[143, NZNewGridXY8] = FISHPREY[15, LocHV[8, NZNewGridXY8]] / (4000000*(Grid2D[3, LocHV[8, NZNewGridXY8]]/20.) * 1000.); ROG
EnvironHV[172, NZNewGridXY8] = FISHPREY[19, LocHV[8, NZNewGridXY8]]/ (4000000*(Grid2D[3, LocHV[8, NZNewGridXY8]]/20.) * 1000.); WAE

; Environmental conditions for potential vertical movement
;LocHV# for vertical movement = 17, 26, 35, 44, 53, 62
; -3 downward
NNLocHV17 = WHERE((LocHV[17, *] GE 0.0), NNLocHV17count, complement = NLocHV17, ncomplement = NLocHV17count);
IF (NNLocHV17count GT 0.0) THEN BEGIN
EnvironHV[77:82, NNLocHV17] = newinput[5:10, LocHV[17, NNLocHV17]];
EnvironHV[80, NNLocHV17] = TotBenBio[LocHV[17, NNLocHV17]]
EnvironHV[83, NNLocHV17] = 0.0; invasive species
EnvironHV[84, NNLocHV17] = newinput[11, LocHV[17, NNLocHV17]]; light
EnvironHV[144, NNLocHV17] = FISHPREY[3, LocHV[17, NNLocHV17]] / (4000000*(Grid2D[3, LocHV[17, NNLocHV17]]/20.) * 1000.); YEP
EnvironHV[145, NNLocHV17] = FISHPREY[7, LocHV[17, NNLocHV17]] / (4000000*(Grid2D[3, LocHV[17, NNLocHV17]]/20.) * 1000.); EMS
EnvironHV[146, NNLocHV17] = FISHPREY[11, LocHV[17, NNLocHV17]] / (4000000*(Grid2D[3, LocHV[17, NNLocHV17]]/20.) * 1000.); RAS
EnvironHV[147, NNLocHV17] = FISHPREY[15, LocHV[17, NNLocHV17]] / (4000000*(Grid2D[3, LocHV[17, NNLocHV17]]/20.) * 1000.); ROG
EnvironHV[173, NNLocHV17] = FISHPREY[19, LocHV[17, NNLocHV17]]/ (4000000*(Grid2D[3, LocHV[17, NNLocHV17]]/20.) * 1000.); WAE
ENDIF
; -2
NNLocHV26 = WHERE((LocHV[26, *] GE 0.0), NNLocHV26count, complement = NLocHV26, ncomplement = NLocHV26count);
IF (NNLocHV26count GT 0.0) THEN BEGIN
EnvironHV[85:90, NNLocHV26] = newinput[5:10, LocHV[26, NNLocHV26]];
EnvironHV[88, NNLocHV26] = TotBenBio[LocHV[26, NNLocHV26]]
EnvironHV[91, NNLocHV26] = 0.0; invasive species
EnvironHV[92, NNLocHV26] = newinput[11, LocHV[26, NNLocHV26]]; light
EnvironHV[148, NNLocHV26] = FISHPREY[3, LocHV[26, NNLocHV26]] / (4000000*(Grid2D[3, LocHV[26, NNLocHV26]]/20.) * 1000.); YEP
EnvironHV[149, NNLocHV26] = FISHPREY[7, LocHV[26, NNLocHV26]] / (4000000*(Grid2D[3, LocHV[26, NNLocHV26]]/20.) * 1000.); EMS
EnvironHV[150, NNLocHV26] = FISHPREY[11, LocHV[26, NNLocHV26]] / (4000000*(Grid2D[3, LocHV[26, NNLocHV26]]/20.) * 1000.); RAS
EnvironHV[151, NNLocHV26] = FISHPREY[15, LocHV[26, NNLocHV26]] / (4000000*(Grid2D[3, LocHV[26, NNLocHV26]]/20.) * 1000.); ROG
EnvironHV[174, NNLocHV26] = FISHPREY[19, LocHV[26, NNLocHV26]]/ (4000000*(Grid2D[3, LocHV[26, NNLocHV26]]/20.) * 1000.); WAE
ENDIF
; -1
NNLocHV35 = WHERE((LocHV[35, *] GE 0.0), NNLocHV35count, complement = NLocHV35, ncomplement = NLocHV35count);
IF (NNLocHV35count GT 0.0) THEN BEGIN
EnvironHV[92:97, NNLocHV35] = newinput[5:10, LocHV[35, NNLocHV35]];
EnvironHV[95, NNLocHV35] = TotBenBio[LocHV[35, NNLocHV35]]
EnvironHV[98, NNLocHV35] = 0.0; invasive species
EnvironHV[99, NNLocHV35] = newinput[11, LocHV[35, NNLocHV35]]; light
EnvironHV[152, NNLocHV35] = FISHPREY[3, LocHV[35, NNLocHV35]] / (4000000*(Grid2D[3, LocHV[35, NNLocHV35]]/20.) * 1000.); YEP
EnvironHV[153, NNLocHV35] = FISHPREY[7, LocHV[35, NNLocHV35]] / (4000000*(Grid2D[3, LocHV[35, NNLocHV35]]/20.) * 1000.); EMS
EnvironHV[154, NNLocHV35] = FISHPREY[11, LocHV[35, NNLocHV35]] / (4000000*(Grid2D[3, LocHV[35, NNLocHV35]]/20.) * 1000.); RAS
EnvironHV[155, NNLocHV35] = FISHPREY[15, LocHV[35, NNLocHV35]] / (4000000*(Grid2D[3, LocHV[35, NNLocHV35]]/20.) * 1000.); ROG
EnvironHV[175, NNLocHV35] = FISHPREY[19, LocHV[35, NNLocHV35]]/ (4000000*(Grid2D[3, LocHV[35, NNLocHV35]]/20.) * 1000.); WAE
ENDIF
; +1 upward
NNLocHV44 = WHERE((LocHV[44, *] GE 0.0), NNLocHV44count, complement = NLocHV44, ncomplement = NLocHV44count);
IF (NNLocHV44count GT 0.0) THEN BEGIN
EnvironHV[100:105, NNLocHV44] = newinput[5:10, LocHV[44, NNLocHV44]];
EnvironHV[103, NNLocHV44] = TotBenBio[LocHV[44, NNLocHV44]]
EnvironHV[106, NNLocHV44] = 0.0; invasive species
EnvironHV[107, NNLocHV44] = newinput[11, LocHV[44, NNLocHV44]]; light
EnvironHV[156, NNLocHV44] = FISHPREY[3, LocHV[44, NNLocHV44]] / (4000000*(Grid2D[3, LocHV[44, NNLocHV44]]/20.) * 1000.); YEP
EnvironHV[157, NNLocHV44] = FISHPREY[7, LocHV[44, NNLocHV44]] / (4000000*(Grid2D[3, LocHV[44, NNLocHV44]]/20.) * 1000.); EMS
EnvironHV[158, NNLocHV44] = FISHPREY[11, LocHV[44, NNLocHV44]] / (4000000*(Grid2D[3, LocHV[44, NNLocHV44]]/20.) * 1000.); RAS
EnvironHV[159, NNLocHV44] = FISHPREY[15, LocHV[44, NNLocHV44]] / (4000000*(Grid2D[3, LocHV[44, NNLocHV44]]/20.) * 1000.); ROG
EnvironHV[176, NNLocHV44] = FISHPREY[19, LocHV[44, NNLocHV44]]/ (4000000*(Grid2D[3, LocHV[44, NNLocHV44]]/20.) * 1000.); WAE
ENDIF

; +2
NNLocHV53 = WHERE((LocHV[53, *] GE 0.0), NNLocHV53count, complement = NLocHV53, ncomplement = NLocHV53count);
IF (NNLocHV53count GT 0.0) THEN BEGIN
EnvironHV[108:113, NNLocHV53] = newinput[5:10, LocHV[53, NNLocHV53]];
EnvironHV[111, NNLocHV53] = TotBenBio[LocHV[53, NNLocHV53]]
EnvironHV[114, NNLocHV53] = 0.0; invasive species
EnvironHV[115, NNLocHV53] = newinput[11, LocHV[53, NNLocHV53]]; light
EnvironHV[160, NNLocHV53] = FISHPREY[3, LocHV[53, NNLocHV53]] / (4000000*(Grid2D[3, LocHV[53, NNLocHV53]]/20.) * 1000.); YEP
EnvironHV[161, NNLocHV53] = FISHPREY[7, LocHV[53, NNLocHV53]] / (4000000*(Grid2D[3, LocHV[53, NNLocHV53]]/20.) * 1000.); EMS
EnvironHV[162, NNLocHV53] = FISHPREY[11, LocHV[53, NNLocHV53]] / (4000000*(Grid2D[3, LocHV[53, NNLocHV53]]/20.) * 1000.); RAS
EnvironHV[163, NNLocHV53] = FISHPREY[15, LocHV[53, NNLocHV53]] / (4000000*(Grid2D[3, LocHV[53, NNLocHV53]]/20.) * 1000.); ROG
EnvironHV[177, NNLocHV53] = FISHPREY[19, LocHV[53, NNLocHV53]]/ (4000000*(Grid2D[3, LocHV[53, NNLocHV53]]/20.) * 1000.); WAE
ENDIF
; +3
NNLocHV62 = WHERE((LocHV[62, *] GE 0.0), NNLocHV62count, complement = NLocHV62, ncomplement = NLocHV62count);
IF (NNLocHV62count GT 0.0) THEN BEGIN
EnvironHV[116:121, NNLocHV62] = newinput[5:10, LocHV[62, NNLocHV62]];
EnvironHV[119, NNLocHV62] = TotBenBio[LocHV[62, NNLocHV62]]
EnvironHV[122, NNLocHV62] = 0.0; invasive species
EnvironHV[123, NNLocHV62] = newinput[11, LocHV[62, NNLocHV62]]; light
EnvironHV[164, NNLocHV62] = FISHPREY[3, LocHV[62, NNLocHV62]] / (4000000*(Grid2D[3, LocHV[62, NNLocHV62]]/20.) * 1000.); YEP
EnvironHV[165, NNLocHV62] = FISHPREY[7, LocHV[62, NNLocHV62]] / (4000000*(Grid2D[3, LocHV[62, NNLocHV62]]/20.) * 1000.); EMS
EnvironHV[166, NNLocHV62] = FISHPREY[11, LocHV[62, NNLocHV62]] / (4000000*(Grid2D[3, LocHV[62, NNLocHV62]]/20.) * 1000.); RAS
EnvironHV[167, NNLocHV62] = FISHPREY[15, LocHV[62, NNLocHV62]] / (4000000*(Grid2D[3, LocHV[62, NNLocHV62]]/20.) * 1000.); ROG
EnvironHV[178, NNLocHV62] = FISHPREY[19, LocHV[62, NNLocHV62]]/ (4000000*(Grid2D[3, LocHV[62, NNLocHV62]]/20.) * 1000.); WAE
ENDIF

; Assess habitat quality of neighbouring cells
DOf1 = FLTARR(9+6, nWAE)
DOf2 = FLTARR(9+6, nWAE)
DOf3 = FLTARR(9+6, nWAE)
DOf = FLTARR(9+6, nWAE)
Tf = FLTARR(9+6, nWAE)

; DO
DOacclim = WAEacclDO(WAE[29, *], WAE[28, *], WAE[20, *], WAE[27, *], WAE[26, *], WAE[19, *], ts, WAE[1, *], WAE[2, *], nWAE, WAE[63, *]); MOVEMENT PARAMETER 
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
CA = FLTARR(nWAE)
CB = FLTARR(nWAE)
CQ = FLTARR(nWAE)
CTM = FLTARR(nWAE)
CTO = FLTARR(nWAE)
;values are for larval 
TL = WHERE(WAE[1, *] LE 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CA[TL] = 0.45
  CB[TL] = -0.27
  CQ[TL] = 2.3
  CTM[TL] = 28.0
  CTO[TL] = 25.0
ENDIF; ELSE BEGIN
;values are for juvenile and adult walleye
IF (TLLcount GT 0.0) THEN BEGIN 
  CA[TLL] = 0.25
  CB[TLL] = -0.27
  CQ[TLL] = 2.3
  CTM[TLL] = 28.0
  CTO[TLL] = 22.0
ENDIF

;V_C1 = (CTM - EnvironHV[4, *]) / (CTM - CTO)
V_C2 = (CTM - EnvironHV[12, *]) / (CTM - CTO)
;V_C3 = (CTM - EnvironHV[18, *]) / (CTM - CTO)
V_C4 = (CTM - EnvironHV[26, *]) / (CTM - CTO)
V_C5 = (CTM - EnvironHV[34, *]) / (CTM - CTO)
;V_C6 = (CTM - EnvironHV[42, *]) / (CTM - CTO)
V_C7 = (CTM - EnvironHV[50, *]) / (CTM - CTO)
;V_C8 = (CTM - EnvironHV[58, *]) / (CTM - CTO)
V_C9 = (CTM - EnvironHV[66, *]) / (CTM - CTO)
V_C10 = (CTM - EnvironHV[81, *]) / (CTM - CTO)
V_C11 = (CTM - EnvironHV[89, *]) / (CTM - CTO)
V_C12 = (CTM - EnvironHV[96, *]) / (CTM - CTO)
V_C13 = (CTM - EnvironHV[104, *]) / (CTM - CTO)
V_C14 = (CTM - EnvironHV[112, *]) / (CTM - CTO)
V_C15 = (CTM - EnvironHV[120, *]) / (CTM - CTO)

Z_C = ALOG(CQ) * (CTM - CTO)
Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0

;Tf[0, *] = V_C1^X_C * EXP(X_C * (1.0 - V_C1))
Tf[1, *] = V_C2^X_C * EXP(X_C * (1.0 - V_C2))
;Tf[2, *] = V_C3^X_C * EXP(X_C * (1.0 - V_C3))
Tf[3, *] = V_C4^X_C * EXP(X_C * (1.0 - V_C4))
Tf[4, *] = V_C5^X_C * EXP(X_C * (1.0 - V_C5))
;Tf[5, *] = V_C6^X_C * EXP(X_C * (1.0 - V_C6))
Tf[6, *] = V_C7^X_C * EXP(X_C * (1.0 - V_C7))
;Tf[7, *] = V_C8^X_C * EXP(X_C * (1.0 - V_C8))
Tf[8, *] = V_C9^X_C * EXP(X_C * (1.0 - V_C9))
Tf[9, *] = V_C10^X_C * EXP(X_C * (1.0 - V_C10))
Tf[10, *] = V_C11^X_C * EXP(X_C * (1.0 - V_C11))
Tf[11, *] = V_C12^X_C * EXP(X_C * (1.0 - V_C12))
Tf[12, *] = V_C13^X_C * EXP(X_C * (1.0 - V_C13))
Tf[13, *] = V_C14^X_C * EXP(X_C * (1.0 - V_C14))
Tf[14, *] = V_C15^X_C * EXP(X_C * (1.0 - V_C15))
;PRINT, 'Tf'
;PRINT, Tf

; Light
litfac = FLTARR(15, nWAE); a multiplication factor to include the effect of light intensity
t1 = FLTARR(15, nWAE)
t2 = FLTARR(15, nWAE)
;***litfac for walleye using "flicker frequency" from Ali & Ryder***.
la = 0.0183877D
lb = 0.39361465D
lc = 0.0040855314D
ld = -1.7306173D
;print, '69',transpose(EnvironHV[69, *])
;print, '84',transpose(EnvironHV[84, *]); -3 down
;print,'92', transpose(EnvironHV[92, *]); -2
;print, '99',transpose(EnvironHV[99, *]); -1
;print, '107',transpose(EnvironHV[107, *]); +1
;print, '115',transpose(EnvironHV[115, *]); +2
;print,'123', transpose(EnvironHV[123, *]); +3

;t1[0, *] = EXP(-1 * lb * (EnvironHV[15, *]/100. - ld))
t1[1, *] = EXP(-1. * lb * (EnvironHV[15, *]/100. - ld))
;t1[2, *] = EXP(-1 * lb * (EnvironHV[15, *]/100. - ld))
t1[3, *] = EXP(-1. * lb * (EnvironHV[29, *]/100. - ld))
t1[4, *] = EXP(-1. * lb * (EnvironHV[37, *]/100. - ld))
;t1[5, *] = EXP(-1 * lb * (EnvironHV[15, *]/100. - ld))
t1[6, *] = EXP(-1. * lb * (EnvironHV[53, *]/100. - ld))
;t1[7, *] = EXP(-1 * lb * (EnvironHV[15, *]/100. - ld))
t1[8, *] = EXP(-1. * lb * (EnvironHV[69, *]/100. - ld))

t1[9, *] = EXP(-1. * lb * (EnvironHV[84, *]/100. - ld))
t1[10, *] = EXP(-1. * lb * (EnvironHV[92, *]/100. - ld))
t1[11, *] = EXP(-1. * lb * (EnvironHV[99, *]/100. - ld))
t1[12, *] = EXP(-1. * lb * (EnvironHV[107, *]/100. - ld))
t1[13, *] = EXP(-1. * lb * (EnvironHV[115, *]/100. - ld))
t1[14, *] = EXP(-1. * lb * (EnvironHV[123, *]/100. - ld))
 
;t2[0, *] = EXP(-1. * lc * (EnvironHV[15, *] - ld))
t2[1, *] = EXP(-1. * lc * (EnvironHV[15, *]/100. - ld))
;t2[2, *] = EXP(-1. * lc * (EnvironHV[15, *] - ld))
t2[3, *] = EXP(-1. * lc * (EnvironHV[29, *]/100. - ld))
t2[4, *] = EXP(-1. * lc * (EnvironHV[37, *]/100. - ld))
;t2[5, *] = EXP(-1. * lc * (EnvironHV[15, *] - ld))
t2[6, *] = EXP(-1. * lc * (EnvironHV[53, *]/100. - ld))
;t2[7, *] = EXP(-1 * lc * (EnvironHV[15, *] - ld))
t2[8, *] = EXP(-1. * lc * (EnvironHV[69, *]/100. - ld))

t2[9, *] = EXP(-1. * lc * (EnvironHV[84, *]/100. - ld))
t2[10, *] = EXP(-1. * lc * (EnvironHV[92, *]/100. - ld))
t2[11, *] = EXP(-1. * lc * (EnvironHV[99, *]/100. - ld))
t2[12, *] = EXP(-1. * lc * (EnvironHV[107, *]/100. - ld))
t2[13, *] = EXP(-1. * lc * (EnvironHV[115, *]/100. - ld))
t2[14, *] = EXP(-1. * lc * (EnvironHV[123, *]/100. - ld))

t3 = lc - lb
;litfac[0, *] = ((la + lb) * (t1[0, *] - t2[0, *])) / t3
litfac[1, *] = (((la + lb) * (t1[1, *] - t2[1, *])) / t3)
;litfac[2, *] = ((la + lb) * (t1[2, *] - t2[2, *])) / t3
litfac[3, *] = (((la + lb) * (t1[3, *] - t2[3, *])) / t3)
litfac[4, *] = (((la + lb) * (t1[4, *] - t2[4, *])) / t3)
;litfac[5, *] = ((la + lb) * (t1[5, *] - t2[5, *])) / t3
litfac[6, *] = (((la + lb) * (t1[6, *] - t2[6, *])) / t3)
;litfac[7, *] = ((la + lb) * (t1[7, *] - t2[7, *])) / t3
litfac[8, *] = (((la + lb) * (t1[8, *] - t2[8, *])) / t3)

litfac[9, *] = (((la + lb) * (t1[9, *] - t2[9, *])) / t3)
litfac[10, *] = (((la + lb) * (t1[10, *] - t2[10, *])) / t3)
litfac[11, *] = (((la + lb) * (t1[11, *] - t2[11, *])) / t3)
litfac[12, *] = (((la + lb) * (t1[12, *] - t2[12, *])) / t3)
litfac[13, *] = (((la + lb) * (t1[13, *] - t2[13, *])) / t3)
litfac[14, *] = (((la + lb) * (t1[14, *] - t2[14, *])) / t3)
;PRINT, 'Light intensity (lux)'
;PRINT, TRANSPOSE(newinput[11, 0:77499*24:77500])
;PRINT, TRANSPOSE(newinput[11, *])
;PRINT, N_ELEMENTS(NEWINPUT[11, *])
;PRINT, 'Light multiplication factor'
;PRINT, TRANSPOSE(litfac)

; Determine temperature-, DO-, and light- based neighboring habitat quality with a random component
EnvironHVDO = FLTARR(15, nWAE)
EnvironHVT = FLTARR(15, nWAE)
EnvironHVL = FLTARR(15, nWAE)
;EnvironHVDO[0, *] = DOUBLE(DOf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[1, *] = DOUBLE(DOf[1, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVDO[2, *] = DOUBLE(DOf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[3, *] = DOUBLE(DOf[3, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[4, *] = DOUBLE(DOf[4, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVDO[5, *] = DOUBLE(DOf[5, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[6, *] = DOUBLE(DOf[6, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVDO[7, *] = DOUBLE(DOf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVDO[8, *] = DOUBLE(DOf[8, *] * RANDOMU(seed, nWAE, /DOUBLE))

EnvironHVDO[9, *] = DOUBLE(DOf[9, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[10, *] = DOUBLE(DOf[10, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[11, *] = DOUBLE(DOf[11, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[12, *] = DOUBLE(DOf[12, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[13, *] = DOUBLE(DOf[13, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVDO[14, *] = DOUBLE(DOf[14, *] * RANDOMU(seed, nWAE, /DOUBLE))
;PRINT, 'EnvironHVDO[*, *]'
;PRINT, TRANSPOSE(EnvironHVDO[*, 0:9]); DO-based habitat index with a random component

;EnvironHVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[1, *] = DOUBLE(Tf[1, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[3, *] = DOUBLE(Tf[3, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVT[5, *] = DOUBLE(Tf[5, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[6, *] = DOUBLE(Tf[6, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVT[7, *] = DOUBLE(Tf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVT[8, *] = DOUBLE(Tf[8, *] * RANDOMU(seed, nWAE, /DOUBLE))

EnvironHVT[9, *] = DOUBLE(Tf[9, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[10, *] = DOUBLE(Tf[10, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[11, *] = DOUBLE(Tf[11, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[12, *] = DOUBLE(Tf[12, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[13, *] = DOUBLE(Tf[13, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVT[14, *] = DOUBLE(Tf[14, *] * RANDOMU(seed, nWAE, /DOUBLE))
;PRINT, 'EnvironHVT[*, *]'
;PRINT, TRANSPOSE(EnvironHVT[*, 0:9]); Temp-based habitat index with a random component

;EnvironHVT[0, *] = DOUBLE(Tf[0, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVL[1, *] = DOUBLE(litfac[1, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVT[2, *] = DOUBLE(Tf[2, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVL[3, *] = DOUBLE(litfac[3, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[4, *] = DOUBLE(Tf[4, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVL[5, *] = DOUBLE(litfac[5, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[6, *] = DOUBLE(litfac[6, *] * RANDOMU(seed, nWAE, /DOUBLE))
;EnvironHVT[7, *] = DOUBLE(Tf[7, *] * RANDOMU(seed, nYP, /DOUBLE))
EnvironHVL[8, *] = DOUBLE(litfac[8, *] * RANDOMU(seed, nWAE, /DOUBLE))

EnvironHVL[9, *] = DOUBLE(litfac[9, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[10, *] = DOUBLE(litfac[10, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[11, *] = DOUBLE(litfac[11, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[12, *] = DOUBLE(litfac[12, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[13, *] = DOUBLE(litfac[13, *] * RANDOMU(seed, nWAE, /DOUBLE))
EnvironHVL[14, *] = DOUBLE(litfac[14, *] * RANDOMU(seed, nWAE, /DOUBLE))
;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component
;PRINT, 'EnvironHVDO'
;PRINT, EnvironHVDO
;PRINT, 'EnvironHVT'
;PRINT, EnvironHVT
;PRINT, 'EnvironHVL'
;PRINT, EnvironHVL

; Determine prey-based habitat quality
; Determines a prey length for each prey type (m) in the model
;prey length 
m = 10; the number of prey types 
PL = FLTARR(m, nWAE)
PL[0, *] = RANDOMU(seed, nWAE)*(MAX(0.2) - MIN(0.1)) + MIN(0.1); length for microzooplankton, rotifer in mm from Letcher et al. 2006
PL[1, *] = RANDOMU(seed, nWAE)*(MAX(1.) - MIN(0.5)) + MIN(0.5); length for small mesozooplankton, copepod in mm from Letcher et al. 2006 
PL[2, *] = RANDOMU(seed, nWAE)*(MAX(1.5) - MIN(1.0)) + MIN(1.0); length for large mesozooplankton, cladocerans in mm (1.0 - 1.5) 
PL[3, *] = RANDOMU(seed, nWAE)*(MAX(20.) - MIN(1.5)) + MIN(1.5); length for chironmoid in mm based on the field data from IFYLE 2005
PL[4, *] = RANDOMU(seed, nWAE)*(MAX(15.) - MIN(1.0)) + MIN(1.0); length for invasive species in mm
;PL[5, *] = FISHPREY[1, *]; length for yellow perch in mm 
;PL[6, *] = FISHPREY[5, *]; length for emerald shiner in mm 
;PL[7, *] = FISHPREY[9, *]; length for rainbow smelt in mm 
;PL[8, *] = FISHPREY[13, *]; length for round goby in mm 
;PL[9, *] = FISHPREY[17, *]; length for WALLEYE in mm 

; prey weight
PW = FLTARR(m, nWAE); weight of each prey type
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
dens = FLTARR(m*(9+6), nWAE)
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
  
; Invasive species (0 for now)
;dens[36,*] = EnvironHV[6, *] / Pw[4]
dens[37,*] = EnvironHV[14, *] / Pw[4, *]
;dens[38,*] = EnvironHV[20, *] / Pw[4]
dens[39,*] = EnvironHV[28, *] / Pw[4, *]
dens[40,*] = EnvironHV[36, *] / Pw[4, *]
;dens[41,*] = EnvironHV[44, *] / Pw[4]
dens[42,*] = EnvironHV[52, *] / Pw[4, *]
;dens[43,*] = EnvironHV[60, *] / Pw[4]
dens[44,*] = EnvironHV[68, *] / Pw[4, *]

dens[78,*] = EnvironHV[83, *] / Pw[4, *]
dens[79,*] = EnvironHV[91, *] / Pw[4, *]
dens[80,*] = EnvironHV[98, *] / Pw[4, *]
dens[81,*] = EnvironHV[106, *] / Pw[4, *]
dens[82,*] = EnvironHV[114, *] / Pw[4, *]
dens[83,*] = EnvironHV[122, *] / Pw[4, *]
  
; Fish prey 
; yellow perch
;dens[45,*] = EnvironHV[7, *] / Pw[5]         
pbio5b = WHERE(EnvironHV[124, *] GT 0.0 AND FISHPREY[2, LocHV[1, *]] GT 0.0, pbio5bcount, complement = pbio5bc, ncomplement = pbio5bccount)
IF pbio5bcount GT 0.0 THEN dens[46, pbio5b] = EnvironHV[124, pbio5b] / FISHPREY[2, LocHV[1, pbio5b]] ELSE dens[46, pbio5bc] = 0.0; for yellow perch
;dens[47,*] = EnvironHV[21, *] / Pw[5]
pbio5d = WHERE(EnvironHV[128, *] GT 0.0 AND FISHPREY[2, LocHV[3, *]] GT 0.0, pbio5dcount, complement = pbio5dc, ncomplement = pbio5dccount)
IF pbio5dcount GT 0.0 THEN dens[48, pbio5d] = EnvironHV[128, pbio5d] / FISHPREY[2, LocHV[3, pbio5d]] ELSE dens[48, pbio5dc] = 0.0; for yellow perch
pbio5e = WHERE(EnvironHV[132, *] GT 0.0 AND FISHPREY[2, LocHV[4, *]] GT 0.0, pbio5ecount, complement = pbio5ec, ncomplement = pbio5eccount)
IF pbio5ecount GT 0.0 THEN dens[49, pbio5e] = EnvironHV[132, pbio5e] / FISHPREY[2, LocHV[4, pbio5e]] ELSE dens[49, pbio5ec] = 0.0; for yellow perch
;dens[50,*] = EnvironHV[45, *] / Pw[5]
pbio5g = WHERE(EnvironHV[136, *] GT 0.0 AND FISHPREY[2, LocHV[6, *]] GT 0.0, pbio5gcount, complement = pbio5gc, ncomplement = pbio5gccount)
IF pbio5gcount GT 0.0 THEN dens[51, pbio5g] = EnvironHV[136, pbio5g] / FISHPREY[2, LocHV[6, pbio5g]] ELSE dens[51, pbio5gc] = 0.0; for yellow perch
;dens[52,*] = EnvironHV[61, *] / Pw[5]
pbio5i = WHERE(EnvironHV[140, *] GT 0.0 AND FISHPREY[2, LocHV[8, *]] GT 0.0, pbio5icount, complement = pbio5ic, ncomplement = pbio5iccount)
IF pbio5icount GT 0.0 THEN dens[53, pbio5i] = EnvironHV[140, pbio5i] / FISHPREY[2, LocHV[8, pbio5i]] ELSE dens[53, pbio5ic] = 0.0; for yellow perch

pbio5j = WHERE(EnvironHV[144, *] GT 0.0 AND FISHPREY[2, LocHV[17, *]] GT 0.0, pbio5jcount, complement = pbio5jc, ncomplement = pbio5jccount)
IF pbio5jcount GT 0.0 THEN dens[84, pbio5j] = EnvironHV[144, pbio5j] / FISHPREY[2, LocHV[17, pbio5j]] ELSE dens[84, pbio5jc] = 0.0; for yellow perch
pbio5k = WHERE(EnvironHV[148, *] GT 0.0 AND FISHPREY[2, LocHV[26, *]] GT 0.0, pbio5kcount, complement = pbio5kc, ncomplement = pbio5kccount)
IF pbio5kcount GT 0.0 THEN dens[85, pbio5k] = EnvironHV[148, pbio5k] / FISHPREY[2, LocHV[26, pbio5k]] ELSE dens[85, pbio5kc] = 0.0; for yellow perch
pbio5l = WHERE(EnvironHV[152, *] GT 0.0 AND FISHPREY[2, LocHV[35, *]] GT 0.0, pbio5lcount, complement = pbio5lc, ncomplement = pbio5lccount)
IF pbio5lcount GT 0.0 THEN dens[86, pbio5l] = EnvironHV[152, pbio5l] / FISHPREY[2, LocHV[35, pbio5l]] ELSE dens[86, pbio5lc] = 0.0; for yellow perch
pbio5o = WHERE(EnvironHV[156, *] GT 0.0 AND FISHPREY[2, LocHV[44, *]] GT 0.0, pbio5ocount, complement = pbio5oc, ncomplement = pbio5occount)
IF pbio5ocount GT 0.0 THEN dens[87, pbio5o] = EnvironHV[156, pbio5o] / FISHPREY[2, LocHV[44, pbio5o]] ELSE dens[87, pbio5oc] = 0.0; for yellow perch
pbio5p = WHERE(EnvironHV[160, *] GT 0.0 AND FISHPREY[2, LocHV[53, *]] GT 0.0, pbio5pcount, complement = pbio5pc, ncomplement = pbio5pccount)
IF pbio5pcount GT 0.0 THEN dens[88, pbio5p] = EnvironHV[160, pbio5p] / FISHPREY[2, LocHV[53, pbio5p]] ELSE dens[88, pbio5pc] = 0.0; for yellow perch
pbio5q = WHERE(EnvironHV[164, *] GT 0.0 AND FISHPREY[2, LocHV[62, *]] GT 0.0, pbio5qcount, complement = pbio5qc, ncomplement = pbio5qccount)
IF pbio5qcount GT 0.0 THEN dens[89, pbio5q] = EnvironHV[164, pbio5q] / FISHPREY[2, LocHV[62, pbio5q]] ELSE dens[89, pbio5qc] = 0.0; for yellow perch

; emerald shienr 
;dens[45,*] = EnvironHV[7, *] / Pw[5]
pbio6b = WHERE(EnvironHV[125, *] GT 0.0 AND FISHPREY[6, LocHV[1, *]] GT 0.0, pbio6bcount, complement = pbio6bc, ncomplement = pbio6bccount)
IF pbio6bcount GT 0.0 THEN dens[90, pbio6b] = EnvironHV[125, pbio6b] / FISHPREY[6, LocHV[1, pbio6b]] ELSE dens[90, pbio6bc] = 0.0; for yellow perch
;dens[47,*] = EnvironHV[21, *] / Pw[5]
pbio6d = WHERE(EnvironHV[129, *] GT 0.0 AND FISHPREY[6, LocHV[3, *]] GT 0.0, pbio6dcount, complement = pbio6dc, ncomplement = pbio6dccount)
IF pbio6dcount GT 0.0 THEN dens[91, pbio6d] = EnvironHV[129, pbio6d] / FISHPREY[6, LocHV[3, pbio6d]] ELSE dens[91, pbio6dc] = 0.0; for yellow perch
pbio6e = WHERE(EnvironHV[133, *] GT 0.0 AND FISHPREY[6, LocHV[4, *]] GT 0.0, pbio6ecount, complement = pbio6ec, ncomplement = pbio6eccount)
IF pbio6ecount GT 0.0 THEN dens[92, pbio6e] = EnvironHV[133, pbio6e] / FISHPREY[6, LocHV[4, pbio6e]] ELSE dens[92, pbio6ec] = 0.0; for yellow perch
;dens[50,*] = EnvironHV[45, *] / Pw[5]
pbio6g = WHERE(EnvironHV[137, *] GT 0.0 AND FISHPREY[6, LocHV[6, *]] GT 0.0, pbio6gcount, complement = pbio6gc, ncomplement = pbio6gccount)
IF pbio6gcount GT 0.0 THEN dens[93, pbio6g] = EnvironHV[137, pbio6g] / FISHPREY[6, LocHV[6, pbio6g]] ELSE dens[93, pbio6gc] = 0.0; for yellow perch
;dens[52,*] = EnvironHV[61, *] / Pw[5]
pbio6i = WHERE(EnvironHV[141, *] GT 0.0 AND FISHPREY[6, LocHV[8, *]] GT 0.0, pbio6icount, complement = pbio6ic, ncomplement = pbio6iccount)
IF pbio6icount GT 0.0 THEN dens[94, pbio6i] = EnvironHV[141, pbio6i] / FISHPREY[6, LocHV[8, pbio6i]] ELSE dens[94, pbio6ic] = 0.0; for yellow perch
pbio6j = WHERE(EnvironHV[145, *] GT 0.0 AND FISHPREY[6, LocHV[17, *]] GT 0.0, pbio6jcount, complement = pbio6jc, ncomplement = pbio6jccount)
IF pbio6jcount GT 0.0 THEN dens[95, pbio6j] = EnvironHV[145, pbio6j] / FISHPREY[6, LocHV[17, pbio6j]] ELSE dens[95, pbio6jc] = 0.0; for yellow perch
pbio6k = WHERE(EnvironHV[149, *] GT 0.0 AND FISHPREY[6, LocHV[26, *]] GT 0.0, pbio6kcount, complement = pbio6kc, ncomplement = pbio6kccount)
IF pbio6kcount GT 0.0 THEN dens[96, pbio6k] = EnvironHV[149, pbio6k] / FISHPREY[6, LocHV[26, pbio6k]] ELSE dens[96, pbio6kc] = 0.0; for yellow perch
pbio6l = WHERE(EnvironHV[153, *] GT 0.0 AND FISHPREY[6, LocHV[35, *]] GT 0.0, pbio6lcount, complement = pbio6lc, ncomplement = pbio6lccount)
IF pbio6lcount GT 0.0 THEN dens[97, pbio6l] = EnvironHV[153, pbio6l] / FISHPREY[6, LocHV[35, pbio6l]] ELSE dens[97, pbio6lc] = 0.0; for yellow perch
pbio6o = WHERE(EnvironHV[157, *] GT 0.0 AND FISHPREY[6, LocHV[44, *]] GT 0.0, pbio6ocount, complement = pbio6oc, ncomplement = pbio6occount)
IF pbio6ocount GT 0.0 THEN dens[98, pbio6o] = EnvironHV[157, pbio6o] / FISHPREY[6, LocHV[44, pbio6o]] ELSE dens[98, pbio6oc] = 0.0; for yellow perch
pbio6p = WHERE(EnvironHV[161, *] GT 0.0 AND FISHPREY[6, LocHV[53, *]] GT 0.0, pbio6pcount, complement = pbio6pc, ncomplement = pbio6pccount)
IF pbio6pcount GT 0.0 THEN dens[99, pbio6p] = EnvironHV[161, pbio6p] / FISHPREY[6, LocHV[53, pbio6p]] ELSE dens[99, pbio6pc] = 0.0; for yellow perch
pbio6q = WHERE(EnvironHV[165, *] GT 0.0 AND FISHPREY[6, LocHV[62, *]] GT 0.0, pbio6qcount, complement = pbio6qc, ncomplement = pbio6qccount)
IF pbio6qcount GT 0.0 THEN dens[100, pbio6q] = EnvironHV[165, pbio6q] / FISHPREY[6, LocHV[62, pbio6q]] ELSE dens[100, pbio6qc] = 0.0; for yellow perch

; rainbow smelt
;dens[45,*] = EnvironHV[7, *] / Pw[5]
pbio7b = WHERE(EnvironHV[126, *] GT 0.0 AND FISHPREY[10, LocHV[1, *]] GT 0.0, pbio7bcount, complement = pbio7bc, ncomplement = pbio7bccount)
IF pbio7bcount GT 0.0 THEN dens[101, pbio7b] = EnvironHV[126, pbio7b] / FISHPREY[10, LocHV[1, pbio7b]] ELSE dens[101, pbio7bc] = 0.0; for yellow perch
;dens[47,*] = EnvironHV[21, *] / Pw[5]
pbio7d = WHERE(EnvironHV[130, *] GT 0.0 AND FISHPREY[10, LocHV[3, *]] GT 0.0, pbio7dcount, complement = pbio7dc, ncomplement = pbio7dccount)
IF pbio7dcount GT 0.0 THEN dens[102, pbio7d] = EnvironHV[130, pbio7d] / FISHPREY[10, LocHV[3, pbio7d]] ELSE dens[102, pbio7dc] = 0.0; for yellow perch
pbio7e = WHERE(EnvironHV[134, *] GT 0.0 AND FISHPREY[10, LocHV[4, *]], pbio7ecount, complement = pbio7ec, ncomplement = pbio7eccount)
IF pbio7ecount GT 0.0 THEN dens[103, pbio7e] = EnvironHV[134, pbio7e] / FISHPREY[10, LocHV[4, pbio7e]] ELSE dens[103, pbio7ec] = 0.0; for yellow perch
;dens[50,*] = EnvironHV[45, *] / Pw[5]
pbio7g = WHERE(EnvironHV[138, *] GT 0.0 AND FISHPREY[10, LocHV[6, *]] GT 0.0, pbio7gcount, complement = pbio7gc, ncomplement = pbio7gccount)
IF pbio7gcount GT 0.0 THEN dens[104, pbio7g] = EnvironHV[138, pbio7g] / FISHPREY[10, LocHV[6, pbio7g]] ELSE dens[104, pbio7gc] = 0.0; for yellow perch
;dens[52,*] = EnvironHV[61, *] / Pw[5]
pbio7i = WHERE(EnvironHV[142, *] GT 0.0 AND FISHPREY[10, LocHV[8, *]] GT 0.0, pbio7icount, complement = pbio7ic, ncomplement = pbio7iccount)
IF pbio7icount GT 0.0 THEN dens[105, pbio7i] = EnvironHV[142, pbio7i] / FISHPREY[10, LocHV[8, pbio7i]] ELSE dens[105, pbio7ic] = 0.0; for yellow perch
pbio7j = WHERE(EnvironHV[146, *] GT 0.0 AND FISHPREY[10, LocHV[17, *]] GT 0.0, pbio7jcount, complement = pbio7jc, ncomplement = pbio7jccount)
IF pbio7jcount GT 0.0 THEN dens[106, pbio7j] = EnvironHV[146, pbio7j] / FISHPREY[10, LocHV[17, pbio7j]] ELSE dens[106, pbio7jc] = 0.0; for yellow perch
pbio7k = WHERE(EnvironHV[150, *] GT 0.0 AND FISHPREY[10, LocHV[26, *]] GT 0.0, pbio7kcount, complement = pbio7kc, ncomplement = pbio7kccount)
IF pbio7kcount GT 0.0 THEN dens[107, pbio7k] = EnvironHV[150, pbio7k] / FISHPREY[10, LocHV[26, pbio7k]] ELSE dens[107, pbio7kc] = 0.0; for yellow perch
pbio7l = WHERE(EnvironHV[154, *] GT 0.0 AND FISHPREY[10, LocHV[35, *]] GT 0.0, pbio7lcount, complement = pbio7lc, ncomplement = pbio7lccount)
IF pbio7lcount GT 0.0 THEN dens[108, pbio7l] = EnvironHV[154, pbio7l] / FISHPREY[10, LocHV[35, pbio7l]] ELSE dens[108, pbio7lc] = 0.0; for yellow perch
pbio7o = WHERE(EnvironHV[158, *] GT 0.0 AND FISHPREY[10, LocHV[44, *]] GT 0.0, pbio7ocount, complement = pbio7oc, ncomplement = pbio7occount)
IF pbio7ocount GT 0.0 THEN dens[109, pbio7o] = EnvironHV[158, pbio7o] / FISHPREY[10, LocHV[44, pbio7o]] ELSE dens[109, pbio7oc] = 0.0; for yellow perch
pbio7p = WHERE(EnvironHV[162, *] GT 0.0 AND FISHPREY[10, LocHV[53, *]] GT 0.0, pbio7pcount, complement = pbio7pc, ncomplement = pbio7pccount)
IF pbio7pcount GT 0.0 THEN dens[110, pbio7p] = EnvironHV[162, pbio7p] / FISHPREY[10, LocHV[53, pbio7p]] ELSE dens[110, pbio7pc] = 0.0; for yellow perch
pbio7q = WHERE(EnvironHV[166, *] GT 0.0 AND FISHPREY[10, LocHV[62, *]] GT 0.0, pbio7qcount, complement = pbio7qc, ncomplement = pbio7qccount)
IF pbio7qcount GT 0.0 THEN dens[111, pbio7q] = EnvironHV[166, pbio7q] / FISHPREY[10, LocHV[62, pbio7q]] ELSE dens[111, pbio7qc] = 0.0; for yellow perch

; round goby
;dens[45,*] = EnvironHV[7, *] / Pw[5]
pbio8b = WHERE(EnvironHV[127, *] GT 0.0 AND FISHPREY[14, LocHV[1, *]] GT 0.0, pbio8bcount, complement = pbio8bc, ncomplement = pbio8bccount)
IF pbio8bcount GT 0.0 THEN dens[112, pbio8b] = EnvironHV[127, pbio8b] / FISHPREY[14, LocHV[1, pbio8b]] ELSE dens[112, pbio8bc] = 0.0; for yellow perch
;dens[47,*] = EnvironHV[21, *] / Pw[5]
pbio8d = WHERE(EnvironHV[131, *] GT 0.0 AND FISHPREY[14, LocHV[3, *]] GT 0.0, pbio8dcount, complement = pbio8dc, ncomplement = pbio8dccount)
IF pbio8dcount GT 0.0 THEN dens[113, pbio8d] = EnvironHV[131, pbio8d] / FISHPREY[14, LocHV[3, pbio8d]] ELSE dens[113, pbio8dc] = 0.0; for yellow perch
pbio8e = WHERE(EnvironHV[135, *] GT 0.0 AND FISHPREY[14, LocHV[4, *]] GT 0.0, pbio8ecount, complement = pbio8ec, ncomplement = pbio8eccount)
IF pbio8ecount GT 0.0 THEN dens[114, pbio8e] = EnvironHV[135, pbio8e] / FISHPREY[14, LocHV[4, pbio8e]] ELSE dens[114, pbio8ec] = 0.0; for yellow perch
;dens[50,*] = EnvironHV[45, *] / Pw[5]
pbio8g = WHERE(EnvironHV[139, *] GT 0.0 AND FISHPREY[14, LocHV[6, *]] GT 0.0, pbio8gcount, complement = pbio8gc, ncomplement = pbio8gccount)
IF pbio8gcount GT 0.0 THEN dens[115, pbio8g] = EnvironHV[139, pbio8g] / FISHPREY[14, LocHV[6, pbio8g]] ELSE dens[115, pbio8gc] = 0.0; for yellow perch
;dens[52,*] = EnvironHV[61, *] / Pw[5]
pbio8i = WHERE(EnvironHV[143, *] GT 0.0 AND FISHPREY[14, LocHV[8, *]] GT 0.0, pbio8icount, complement = pbio8ic, ncomplement = pbio8iccount)
IF pbio8icount GT 0.0 THEN dens[116, pbio8i] = EnvironHV[143, pbio8i] / FISHPREY[14, LocHV[8, pbio8i]] ELSE dens[116, pbio8ic] = 0.0; for yellow perch
pbio8j = WHERE(EnvironHV[147, *] GT 0.0 AND FISHPREY[14, LocHV[17, *]] GT 0.0, pbio8jcount, complement = pbio8jc, ncomplement = pbio8jccount)
IF pbio8jcount GT 0.0 THEN dens[117, pbio8j] = EnvironHV[147, pbio8j] / FISHPREY[14, LocHV[17, pbio8j]] ELSE dens[117, pbio8jc] = 0.0; for yellow perch
pbio8k = WHERE(EnvironHV[151, *] GT 0.0 AND FISHPREY[14, LocHV[26, *]] GT 0.0, pbio8kcount, complement = pbio8kc, ncomplement = pbio8kccount)
IF pbio8kcount GT 0.0 THEN dens[118, pbio8k] = EnvironHV[151, pbio8k] / FISHPREY[14, LocHV[26, pbio8k]] ELSE dens[118, pbio8kc] = 0.0; for yellow perch
pbio8l = WHERE(EnvironHV[155, *] GT 0.0 AND FISHPREY[14, LocHV[35, *]] GT 0.0, pbio8lcount, complement = pbio8lc, ncomplement = pbio8lccount)
IF pbio8lcount GT 0.0 THEN dens[119, pbio8l] = EnvironHV[155, pbio8l] / FISHPREY[14, LocHV[35, pbio8l]] ELSE dens[119, pbio8lc] = 0.0; for yellow perch
pbio8o = WHERE(EnvironHV[159, *] GT 0.0 AND FISHPREY[14, LocHV[44, *]] GT 0.0, pbio8ocount, complement = pbio8oc, ncomplement = pbio8occount)
IF pbio8ocount GT 0.0 THEN dens[120, pbio8o] = EnvironHV[159, pbio8o] / FISHPREY[14, LocHV[44, pbio8o]] ELSE dens[120, pbio8oc] = 0.0; for yellow perch
pbio8p = WHERE(EnvironHV[163, *] GT 0.0 AND FISHPREY[14, LocHV[53, *]] GT 0.0, pbio8pcount, complement = pbio8pc, ncomplement = pbio8pccount)
IF pbio8pcount GT 0.0 THEN dens[121, pbio8p] = EnvironHV[163, pbio8p] / FISHPREY[14, LocHV[53, pbio8p]] ELSE dens[121, pbio8pc] = 0.0; for yellow perch
pbio8q = WHERE(EnvironHV[167, *] GT 0.0 AND FISHPREY[14, LocHV[62, *]] GT 0.0, pbio8qcount, complement = pbio8qc, ncomplement = pbio8qccount)
IF pbio8qcount GT 0.0 THEN dens[122, pbio8q] = EnvironHV[167, pbio8q] / FISHPREY[14, LocHV[62, pbio8q]] ELSE dens[122, pbio8qc] = 0.0; for yellow perch

; WALLEYE
;dens[45,*] = EnvironHV[7, *] / Pw[5]
pbio9b = WHERE(EnvironHV[168, *] GT 0.0 AND FISHPREY[18, LocHV[1, *]], pbio9bcount, complement = pbio9bc, ncomplement = pbio9bccount)
IF pbio9bcount GT 0.0 THEN dens[123, pbio9b] = EnvironHV[168, pbio9b] / FISHPREY[18, LocHV[1, pbio9b]] ELSE dens[123, pbio9bc] = 0.0; for yellow perch
;dens[47,*] = EnvironHV[21, *] / Pw[5]
pbio9d = WHERE(EnvironHV[169, *] GT 0.0 AND FISHPREY[18, LocHV[3, *]], pbio9dcount, complement = pbio9dc, ncomplement = pbio9dccount)
IF pbio9dcount GT 0.0 THEN dens[124, pbio9d] = EnvironHV[169, pbio9d] / FISHPREY[18, LocHV[3, pbio9d]] ELSE dens[124, pbio9dc] = 0.0; for yellow perch
pbio9e = WHERE(EnvironHV[170, *] GT 0.0 AND FISHPREY[18, LocHV[4, *]], pbio9ecount, complement = pbio9ec, ncomplement = pbio9eccount)
IF pbio9ecount GT 0.0 THEN dens[125, pbio9e] = EnvironHV[170, pbio9e] / FISHPREY[18, LocHV[4, pbio9e]] ELSE dens[125, pbio9ec] = 0.0; for yellow perch
;dens[50,*] = EnvironHV[45, *] / Pw[5]
pbio9g = WHERE(EnvironHV[171, *] GT 0.0 AND FISHPREY[18, LocHV[6, *]], pbio9gcount, complement = pbio9gc, ncomplement = pbio9gccount)
IF pbio9gcount GT 0.0 THEN dens[126, pbio9g] = EnvironHV[171, pbio9g] / FISHPREY[18, LocHV[6, pbio9g]] ELSE dens[126, pbio9gc] = 0.0; for yellow perch
;dens[52,*] = EnvironHV[61, *] / Pw[5]
pbio9i = WHERE(EnvironHV[172, *] GT 0.0 AND FISHPREY[18, LocHV[8, *]], pbio9icount, complement = pbio9ic, ncomplement = pbio9iccount)
IF pbio9icount GT 0.0 THEN dens[127, pbio9i] = EnvironHV[172, pbio9i] / FISHPREY[18, LocHV[8, pbio9i]] ELSE dens[127, pbio9ic] = 0.0; for yellow perch
pbio9j = WHERE(EnvironHV[173, *] GT 0.0 AND FISHPREY[18, LocHV[17, *]], pbio9jcount, complement = pbio9jc, ncomplement = pbio9jccount)
IF pbio9jcount GT 0.0 THEN dens[128, pbio9j] = EnvironHV[173, pbio9j] / FISHPREY[18, LocHV[17, pbio9j]] ELSE dens[128, pbio9jc] = 0.0; for yellow perch
pbio9k = WHERE(EnvironHV[174, *] GT 0.0 AND FISHPREY[18, LocHV[26, *]], pbio9kcount, complement = pbio9kc, ncomplement = pbio9kccount)
IF pbio9kcount GT 0.0 THEN dens[129, pbio9k] = EnvironHV[174, pbio9k] / FISHPREY[18, LocHV[26, pbio9k]] ELSE dens[129, pbio9kc] = 0.0; for yellow perch
pbio9l = WHERE(EnvironHV[175, *] GT 0.0 AND FISHPREY[18, LocHV[35, *]], pbio9lcount, complement = pbio9lc, ncomplement = pbio9lccount)
IF pbio9lcount GT 0.0 THEN dens[130, pbio9l] = EnvironHV[175, pbio9l] / FISHPREY[18, LocHV[35, pbio9l]] ELSE dens[130, pbio9lc] = 0.0; for yellow perch
pbio9o = WHERE(EnvironHV[176, *] GT 0.0 AND FISHPREY[18, LocHV[44, *]], pbio9ocount, complement = pbio9oc, ncomplement = pbio9occount)
IF pbio9ocount GT 0.0 THEN dens[131, pbio9o] = EnvironHV[176, pbio9o] / FISHPREY[18, LocHV[44, pbio9o]] ELSE dens[131, pbio9oc] = 0.0; for yellow perch
pbio9p = WHERE(EnvironHV[177, *] GT 0.0 AND FISHPREY[18, LocHV[53, *]], pbio9pcount, complement = pbio9pc, ncomplement = pbio9pccount)
IF pbio9pcount GT 0.0 THEN dens[132, pbio9p] = EnvironHV[177, pbio9p] / FISHPREY[18, LocHV[53, pbio9p]] ELSE dens[132, pbio9pc] = 0.0; for yellow perch
pbio9q = WHERE(EnvironHV[178, *] GT 0.0 AND FISHPREY[18, LocHV[62, *]], pbio9qcount, complement = pbio9qc, ncomplement = pbio9qccount)
IF pbio9qcount GT 0.0 THEN dens[133, pbio9q] = EnvironHV[178, pbio9q] / FISHPREY[18, LocHV[62, pbio9q]] ELSE dens[133, pbio9qc] = 0.0; for yellow perch
;PRINT, 'DENS'
;PRINT, DENS

; Calculate Chesson's alpha for each prey type; YP[1, *]
Calpha = FLTARR(60, nWAE)
Calpha[0, *] = 193499 * WAE[1, *]^(-7.64); for rotifers
Calpha[1, *] = 0.272 * ALOG(WAE[1, *]) - 0.3834; for calanoids
Calpha[2, *] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * WAE[1, *]))^(1.0 / 0.031) ; for cladocerans

PL3 = WHERE((PL[3] / WAE[1, *]) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
IF (pl3count GT 0.0) THEN Calpha[3, PL3] = ABS(0.50 - 1.75 * (PL[3, PL3] / WAE[1, PL3]))
IF (pl3ccount GT 0.0) THEN Calpha[3, PL3c] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 

Length60 = WHERE(WAE[1, *] GT 60.0, Length60count, complement = Length60c, ncomplement = Length60ccount)

IF (Length60count GT 0.0) THEN Calpha[4, Length60] = 0.001; for bythotrephes by Rainbow smelt from Barnhisel and Harvey
IF (Length60ccount GT 0.0) THEN Calpha[4, Length60c] = 0.


Length80 = WHERE((WAE[1, *] GT 80.0), Length80count, complement = Length80c, ncomplement = Length80ccount)
 
PL5A = WHERE(((FISHPREY[1, LocHV[1, *]] / WAE[1, *]) LT 0.2), PL5Acount, complement = PL5Ac, ncomplement = PL5Account)
PL5Aa = WHERE(((FISHPREY[1, LocHV[1, *]] / WAE[1, *]) GE 0.2), PL5Aacount, complement = PL5Aac, ncomplement = PL5Aaccount)
IF (Length80count GT 0.0)  AND (PL5Acount GT 0.0) THEN Calpha[5, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Acount GT 0.0) THEN Calpha[5, PL5A] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Aacount GT 0.0) THEN Calpha[5, PL5Aa] = 0.00 ; for YEP 

PL5B = WHERE(((FISHPREY[1, LocHV[3, *]] / WAE[1, *]) LT 0.2), PL5Bcount, complement = PL5Bc, ncomplement = PL5Bccount)
PL5Ba = WHERE(((FISHPREY[1, LocHV[3, *]] / WAE[1, *]) GE 0.2), PL5Bacount, complement = PL5Bac, ncomplement = PL5Baccount)
IF (Length80count GT 0.0) AND (PL5Bcount GT 0.0) THEN Calpha[6, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Bcount GT 0.0) THEN Calpha[6, PL5B] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Bacount GT 0.0) THEN Calpha[6, PL5Ba] = 0.00 ; for YEP

PL5C = WHERE(((FISHPREY[1, LocHV[4, *]] / WAE[1, *]) LT 0.2), PL5Ccount, complement = PL5Cc, ncomplement = PL5Cccount)
PL5Ca = WHERE(((FISHPREY[1, LocHV[4, *]] / WAE[1, *]) GE 0.2), PL5Cacount, complement = PL5Cac, ncomplement = PL5Caccount)
IF (Length80count GT 0.0) AND (PL5Ccount GT 0.0) THEN Calpha[7, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Ccount GT 0.0) THEN Calpha[7, PL5C] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Cacount GT 0.0) THEN Calpha[7, PL5Ca] = 0.00 ; for YEP

PL5D = WHERE(((FISHPREY[1, LocHV[6, *]] / WAE[1, *]) LT 0.2), PL5Dcount, complement = PL5Dc, ncomplement = PL5Dccount)
PL5Da = WHERE(((FISHPREY[1, LocHV[6, *]] / WAE[1, *]) GE 0.2), PL5Dacount, complement = PL5Dac, ncomplement = PL5Daccount)
IF (Length80count GT 0.0) AND (PL5Dcount GT 0.0) THEN Calpha[8, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Dcount GT 0.0) THEN Calpha[8, PL5D] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Dacount GT 0.0) THEN Calpha[8, PL5Da] = 0.00 ; for YEP

PL5E = WHERE(((FISHPREY[1, LocHV[8, *]] / WAE[1, *]) LT 0.2), PL5Ecount, complement = PL5Ec, ncomplement = PL5Eccount)
PL5Ea = WHERE(((FISHPREY[1, LocHV[8, *]] / WAE[1, *]) GE 0.2), PL5Eacount, complement = PL5Eac, ncomplement = PL5Eaccount)
IF (Length80count GT 0.0) AND (PL5Ecount GT 0.0) THEN Calpha[9, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Ecount GT 0.0) THEN Calpha[9, PL5E] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Eacount GT 0.0) THEN Calpha[9, PL5Ea] = 0.00 ; for YEP

PL5F = WHERE(((FISHPREY[1, LocHV[17, *]] / WAE[1, *]) LT 0.2), PL5Fcount, complement = PL5Fc, ncomplement = PL5Fccount)
PL5Fa = WHERE(((FISHPREY[1, LocHV[17, *]] / WAE[1, *]) GE 0.2), PL5Facount, complement = PL5Fac, ncomplement = PL5Faccount)
IF (Length80count GT 0.0) AND (PL5Fcount GT 0.0) THEN Calpha[10, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Fcount GT 0.0) THEN Calpha[10, PL5F] = 0.25 
IF (Length80ccount GT 0.0) AND (PL5Facount GT 0.0) THEN Calpha[10, PL5Fa] = 0.00 ; for YEP

PL5G = WHERE(((FISHPREY[1, LocHV[26, *]] / WAE[1, *]) LT 0.2), PL5Gcount, complement = PL5Gc, ncomplement = PL5Gccount)
PL5Ga = WHERE(((FISHPREY[1, LocHV[26, *]] / WAE[1, *]) GE 0.2), PL5Gacount, complement = PL5Gac, ncomplement = PL5Gaccount)
IF (Length80count GT 0.0) AND (PL5Gcount GT 0.0) THEN Calpha[11, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Gcount GT 0.0) THEN Calpha[11, PL5G] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Gacount GT 0.0) THEN Calpha[11, PL5Ga] = 0.00 ; for YEP

PL5H = WHERE(((FISHPREY[1, LocHV[35, *]] / WAE[1, *]) LT 0.2), PL5Hcount, complement = PL5Hc, ncomplement = PL5Hccount)
PL5Ha = WHERE(((FISHPREY[1, LocHV[35, *]] / WAE[1, *]) GE 0.2), PL5Hacount, complement = PL5Hac, ncomplement = PL5Haccount)
IF (Length80count GT 0.0) AND (PL5Hcount GT 0.0) THEN Calpha[12, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Hcount GT 0.0) THEN Calpha[12, PL5H] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Hacount GT 0.0) THEN Calpha[12, PL5Ha] = 0.00 ; for YEP

PL5I = WHERE(((FISHPREY[1, LocHV[44, *]] / WAE[1, *]) LT 0.2), PL5Icount, complement = PL5Ic, ncomplement = PL5Iccount)
PL5Ia = WHERE(((FISHPREY[1, LocHV[44, *]] / WAE[1, *]) GE 0.2), PL5Iacount, complement = PL5Iac, ncomplement = PL5Iaccount)
IF (Length80count GT 0.0) AND (PL5Icount GT 0.0) THEN Calpha[13, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Icount GT 0.0) THEN Calpha[13, PL5I] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Iacount GT 0.0) THEN Calpha[13, PL5Ia] = 0.00 ; for YEP

PL5J = WHERE(((FISHPREY[1, LocHV[53, *]] / WAE[1, *]) LT 0.2), PL5Jcount, complement = PL5Jc, ncomplement = PL5Jccount)
PL5Ja = WHERE(((FISHPREY[1, LocHV[53, *]] / WAE[1, *]) GE 0.2), PL5Jacount, complement = PL5Jac, ncomplement = PL5Jaccount)
IF (Length80count GT 0.0) AND (PL5Jcount GT 0.0) THEN Calpha[14, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Jcount GT 0.0) THEN Calpha[14, PL5J] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Jacount GT 0.0) THEN Calpha[14, PL5Ja] = 0.00 ; for YEP

PL5K = WHERE(((FISHPREY[1, LocHV[62, *]] / WAE[1, *]) LT 0.2), PL5Kcount, complement = PL5Kc, ncomplement = PL5Kccount)
PL5Ka = WHERE(((FISHPREY[1, LocHV[62, *]] / WAE[1, *]) GE 0.2), PL5Kacount, complement = PL5Kac, ncomplement = PL5Kaccount)
IF (Length80count GT 0.0) AND (PL5Kcount GT 0.0) THEN Calpha[15, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL5Kcount GT 0.0) THEN Calpha[15, PL5K] = 0.25
IF (Length80ccount GT 0.0) AND (PL5Kacount GT 0.0) THEN Calpha[15, PL5Ka] = 0.00 ; for YEP

  
PL6A = WHERE(((FISHPREY[5, LocHV[1, *]] / WAE[1, *]) LT 0.2), PL6Acount, complement = PL6Ac, ncomplement = PL6Account)
PL6Aa = WHERE(((FISHPREY[5, LocHV[1, *]] / WAE[1, *]) GE 0.2), PL6Aacount, complement = PL6Aac, ncomplement = PL6Aaccount)
IF (Length80count GT 0.0) AND (PL6Acount GT 0.0) THEN Calpha[16, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Acount GT 0.0) THEN Calpha[16, PL5A] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Aacount GT 0.0) THEN Calpha[16, PL5Aa] = 0.00 ; for 

PL6B = WHERE(((FISHPREY[5, LocHV[3, *]] / WAE[1, *]) LT 0.2), PL6Bcount, complement = PL6Bc, ncomplement = PL6Bccount)
PL6Ba = WHERE(((FISHPREY[5, LocHV[3, *]] / WAE[1, *]) GE 0.2), PL6Bacount, complement = PL6Bac, ncomplement = PL6Baccount)
IF (Length80count GT 0.0) AND (PL6Bcount GT 0.0) THEN Calpha[17, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Bcount GT 0.0) THEN Calpha[17, PL6B] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Bacount GT 0.0) THEN Calpha[17, PL6Ba] = 0.00 ; for 

PL6C = WHERE(((FISHPREY[5, LocHV[4, *]] / WAE[1, *]) LT 0.2), PL6Ccount, complement = PL6Cc, ncomplement = PL6Cccount)
PL6Ca = WHERE(((FISHPREY[5, LocHV[4, *]] / WAE[1, *]) GE 0.2), PL6Cacount, complement = PL6Cac, ncomplement = PL6Caccount)
IF (Length80count GT 0.0) AND (PL6Ccount GT 0.0) THEN Calpha[18, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Ccount GT 0.0) THEN Calpha[18, PL6C] = 0.25 
IF (Length80ccount GT 0.0) AND (PL6Cacount GT 0.0) THEN Calpha[18, PL6Ca] = 0.00 ; for 

PL6D = WHERE(((FISHPREY[5, LocHV[6, *]] / WAE[1, *]) LT 0.2), PL6Dcount, complement = PL6Dc, ncomplement = PL6Dccount)
PL6Da = WHERE(((FISHPREY[5, LocHV[6, *]] / WAE[1, *]) GE 0.2), PL6Dacount, complement = PL6Dac, ncomplement = PL6Daccount)
IF (Length80count GT 0.0) AND (PL6Dcount GT 0.0) THEN Calpha[19, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL6Dcount GT 0.0) THEN Calpha[19, PL6D] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Dacount GT 0.0) THEN Calpha[19, PL6Da] = 0.00 ; for 

PL6E = WHERE(((FISHPREY[5, LocHV[8, *]] / WAE[1, *]) LT 0.2), PL6Ecount, complement = PL6Ec, ncomplement = PL6Eccount)
PL6Ea = WHERE(((FISHPREY[5, LocHV[8, *]] / WAE[1, *]) GE 0.2), PL6Eacount, complement = PL6Eac, ncomplement = PL6Eaccount)
IF (Length80count GT 0.0) AND (PL6Ecount GT 0.0) THEN Calpha[20, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Ecount GT 0.0) THEN Calpha[20, PL6E] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Eacount GT 0.0) THEN Calpha[20, PL6Ea] = 0.00 ; for 

PL6F = WHERE(((FISHPREY[5, LocHV[17, *]] / WAE[1, *]) LT 0.2), PL6Fcount, complement = PL6Fc, ncomplement = PL6Fccount)
PL6Fa = WHERE(((FISHPREY[5, LocHV[17, *]] / WAE[1, *]) GE 0.2), PL6Facount, complement = PL6Fac, ncomplement = PL6Faccount)
IF (Length80count GT 0.0) AND (PL6Fcount GT 0.0) THEN Calpha[21, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Fcount GT 0.0) THEN Calpha[21, PL6F] = 0.25 
IF (Length80ccount GT 0.0) AND (PL6Facount GT 0.0) THEN Calpha[21, PL6Fa] = 0.00 ; for 

PL6G = WHERE(((FISHPREY[5, LocHV[26, *]] / WAE[1, *]) LT 0.2), PL6Gcount, complement = PL6Gc, ncomplement = PL6Gccount)
PL6Ga = WHERE(((FISHPREY[5, LocHV[26, *]] / WAE[1, *]) GE 0.2), PL6Gacount, complement = PL6Gac, ncomplement = PL6Gaccount)
IF (Length80count GT 0.0) AND (PL6Gcount GT 0.0) THEN Calpha[22, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL6Gcount GT 0.0) THEN Calpha[22, PL6G] = 0.25 
IF (Length80ccount GT 0.0) AND (PL6Gacount GT 0.0) THEN Calpha[22, PL6Ga] = 0.00 ; for 

PL6H = WHERE(((FISHPREY[5, LocHV[35, *]] / WAE[1, *]) LT 0.2), PL6Hcount, complement = PL6Hc, ncomplement = PL6Hccount)
PL6Ha = WHERE(((FISHPREY[5, LocHV[35, *]] / WAE[1, *]) GE 0.2), PL6Hacount, complement = PL6Hac, ncomplement = PL6Haccount)
IF (Length80count GT 0.0) AND (PL6Hcount GT 0.0) THEN Calpha[23, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Hcount GT 0.0) THEN Calpha[23, PL6H] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Hacount GT 0.0) THEN Calpha[23, PL6Ha] = 0.00 ; for

PL6I = WHERE(((FISHPREY[5, LocHV[44, *]] / WAE[1, *]) LT 0.2), PL6Icount, complement = PL6Ic, ncomplement = PL6Iccount)
PL6Ia = WHERE(((FISHPREY[5, LocHV[44, *]] / WAE[1, *]) GE 0.2), PL6Iacount, complement = PL6Iac, ncomplement = PL6Iaccount)
IF (Length80count GT 0.0) AND (PL6Icount GT 0.0) THEN Calpha[24, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Icount GT 0.0) THEN Calpha[24, PL6I] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Iacount GT 0.0) THEN Calpha[24, PL6Ia] = 0.00 ; for

PL6J = WHERE(((FISHPREY[5, LocHV[53, *]] / WAE[1, *]) LT 0.2), PL6Jcount, complement = PL6Jc, ncomplement = PL6Jccount)
PL6Ja = WHERE(((FISHPREY[5, LocHV[53, *]] / WAE[1, *]) GE 0.2), PL6Jacount, complement = PL6Jac, ncomplement = PL6Jaccount)
IF (Length80count GT 0.0) AND (PL6Jcount GT 0.0) THEN Calpha[25, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL6Jcount GT 0.0) THEN Calpha[25, PL6J] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Jacount GT 0.0) THEN Calpha[25, PL6Ja] = 0.00 ; for 

PL6K = WHERE(((FISHPREY[5, LocHV[62, *]] / WAE[1, *]) LT 0.2), PL6Kcount, complement = PL6Kc, ncomplement = PL6Kccount)
PL6Ka = WHERE(((FISHPREY[5, LocHV[62, *]] / WAE[1, *]) GE 0.2), PL6Kacount, complement = PL6Kac, ncomplement = PL6Kaccount)
IF (Length80count GT 0.0) AND (PL6Kcount GT 0.0) THEN Calpha[26, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL6Kcount GT 0.0) THEN Calpha[26, PL6K] = 0.25
IF (Length80ccount GT 0.0) AND (PL6Kacount GT 0.0) THEN Calpha[26, PL6Ka] = 0.00 ; for 


PL7A = WHERE(((FISHPREY[9, LocHV[1, *]] / WAE[1, *]) LT 0.2), PL7Acount, complement = PL7Ac, ncomplement = PL7Account)
PL7Aa = WHERE(((FISHPREY[9, LocHV[1, *]] / WAE[1, *]) GE 0.2), PL7Aacount, complement = PL7Aac, ncomplement = PL7Aaccount)
IF (Length80count GT 0.0) AND (PL7Acount GT 0.0) THEN Calpha[27, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Acount GT 0.0) THEN Calpha[27, PL7A] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Aacount GT 0.0) THEN Calpha[27, PL7Aa] = 0.00 ; for RAS

PL7B = WHERE(((FISHPREY[9, LocHV[3, *]] / WAE[1, *]) LT 0.2), PL7Bcount, complement = PL7Bc, ncomplement = PL7Bccount)
PL7Ba = WHERE(((FISHPREY[9, LocHV[3, *]] / WAE[1, *]) GE 0.2), PL7Bacount, complement = PL7Bac, ncomplement = PL7Baccount)
IF (Length80count GT 0.0) AND (PL7Bcount GT 0.0) THEN Calpha[28, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Bcount GT 0.0) THEN Calpha[28, PL7B] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Bacount GT 0.0) THEN Calpha[28, PL7Ba] = 0.00 ; for 

PL7C = WHERE(((FISHPREY[9, LocHV[4, *]] / WAE[1, *]) LT 0.2), PL7Ccount, complement = PL7Cc, ncomplement = PL7Cccount)
PL7Ca = WHERE(((FISHPREY[9, LocHV[4, *]] / WAE[1, *]) GE 0.2), PL7Cacount, complement = PL7Cac, ncomplement = PL7Caccount)
IF (Length80count GT 0.0) AND (PL7Ccount GT 0.0) THEN Calpha[29, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL7Ccount GT 0.0) THEN Calpha[29, PL7C] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Cacount GT 0.0) THEN Calpha[29, PL7Ca] = 0.00 ; for 

PL7D = WHERE(((FISHPREY[9, LocHV[6, *]] / WAE[1, *]) LT 0.2), PL7Dcount, complement = PL7Dc, ncomplement = PL7Dccount)
PL7Da = WHERE(((FISHPREY[9, LocHV[6, *]] / WAE[1, *]) GE 0.2), PL7Dacount, complement = PL7Dac, ncomplement = PL7Daccount)
IF (Length80count GT 0.0) AND (PL7Dcount GT 0.0) THEN Calpha[30, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL7Dcount GT 0.0) THEN Calpha[30, PL7D] = 0.25 
IF (Length80ccount GT 0.0) AND (PL7Dacount GT 0.0) THEN Calpha[30, PL7Da] = 0.00 ; for 

PL7E = WHERE(((FISHPREY[9, LocHV[8, *]] / WAE[1, *]) LT 0.2), PL7Ecount, complement = PL7Ec, ncomplement = PL7Eccount)
PL5Ea = WHERE(((FISHPREY[9, LocHV[8, *]] / WAE[1, *]) GE 0.2), PL7Eacount, complement = PL7Eac, ncomplement = PL7Eaccount)
IF (Length80count GT 0.0) AND (PL7Ecount GT 0.0) THEN Calpha[31, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Ecount GT 0.0) THEN Calpha[31, PL7E] = 0.25 
IF (Length80ccount GT 0.0) AND (PL7Eacount GT 0.0) THEN Calpha[31, PL7Ea] = 0.00 ; for 

PL7F = WHERE(((FISHPREY[9, LocHV[17, *]] / WAE[1, *]) LT 0.2), PL7Fcount, complement = PL7Fc, ncomplement = PL7Fccount)
PL7Fa = WHERE(((FISHPREY[9, LocHV[17, *]] / WAE[1, *]) GE 0.2), PL7Facount, complement = PL7Fac, ncomplement = PL7Faccount)
IF (Length80count GT 0.0) AND (PL7Fcount GT 0.0) THEN Calpha[32, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Fcount GT 0.0) THEN Calpha[32, PL7F] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Facount GT 0.0) THEN Calpha[32, PL7Fa] = 0.00 ; for 

PL7G = WHERE(((FISHPREY[9, LocHV[26, *]] / WAE[1, *]) LT 0.2), PL7Gcount, complement = PL7Gc, ncomplement = PL7Gccount)
PL7Ga = WHERE(((FISHPREY[9, LocHV[26, *]] / WAE[1, *]) GT 0.2), PL7Gacount, complement = PL7Gac, ncomplement = PL7Gaccount)
IF (Length80count GT 0.0) AND (PL7Gcount GT 0.0) THEN Calpha[33, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL7Gcount GT 0.0) THEN Calpha[33, PL7G] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Gacount GT 0.0) THEN Calpha[33, PL7Ga] = 0.00 ; for 

PL7H = WHERE(((FISHPREY[9, LocHV[35, *]] / WAE[1, *]) LT 0.2), PL7Hcount, complement = PL7Hc, ncomplement = PL7Hccount)
PL7Ha = WHERE(((FISHPREY[9, LocHV[35, *]] / WAE[1, *]) GE 0.2), PL7Hacount, complement = PL7Hac, ncomplement = PL7Haccount)
IF (Length80count GT 0.0) AND (PL7Hcount GT 0.0) THEN Calpha[34, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL7Hcount GT 0.0) THEN Calpha[34, PL7H] = 0.25 
IF (Length80ccount GT 0.0) AND (PL7Hacount GT 0.0) THEN Calpha[34, PL7Ha] = 0.00 ; for 

PL7I = WHERE(((FISHPREY[9, LocHV[44, *]] / WAE[1, *]) LT 0.2), PL7Icount, complement = PL7Ic, ncomplement = PL7Iccount)
PL7Ia = WHERE(((FISHPREY[9, LocHV[44, *]] / WAE[1, *]) GE 0.2), PL7Iacount, complement = PL7Iac, ncomplement = PL7Iaccount)
IF (Length80count GT 0.0) AND (PL7Icount GT 0.0) THEN Calpha[35, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL7Icount GT 0.0) THEN Calpha[35, PL7I] = 0.25 
IF (Length80ccount GT 0.0) AND (PL7Iacount GT 0.0) THEN Calpha[35, PL7Ia] = 0.00 ; for 

PL7J = WHERE(((FISHPREY[9, LocHV[53, *]] / WAE[1, *]) LT 0.2), PL7Jcount, complement = PL7Jc, ncomplement = PL7Jccount)
PL7Ja = WHERE(((FISHPREY[9, LocHV[53, *]] / WAE[1, *]) GE 0.2), PL7Jacount, complement = PL7Jac, ncomplement = PL7Jaccount)
IF (Length80count GT 0.0) AND (PL7Jcount GT 0.0) THEN Calpha[36, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Jcount GT 0.0) THEN Calpha[36, PL7J] = 0.25
IF (Length80ccount GT 0.0) AND (PL7Jacount GT 0.0) THEN Calpha[36, PL7Ja] = 0.00 ; for 

PL7K = WHERE(((FISHPREY[9, LocHV[62, *]] / WAE[1, *]) LT 0.2), PL7Kcount, complement = PL7Kc, ncomplement = PL7Kccount)
PL7Ka = WHERE(((FISHPREY[9, LocHV[62, *]] / WAE[1, *]) GE 0.2), PL7Kacount, complement = PL7Kac, ncomplement = PL7Kaccount)
IF (Length80count GT 0.0) AND (PL7Kcount GT 0.0) THEN Calpha[37, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL7Kcount GT 0.0) THEN Calpha[37, PL7K] = 0.25 
IF (Length80ccount GT 0.0) AND (PL7Kacount GT 0.0) THEN Calpha[37, PL7Ka] = 0.00 ; for 


PL8A = WHERE(((FISHPREY[13, LocHV[1, *]] / WAE[1, *]) LT 0.2), PL8Acount, complement = PL8Ac, ncomplement = PL8Account)
PL8Aa = WHERE(((FISHPREY[13, LocHV[1, *]] / WAE[1, *]) GE 0.2), PL8Aacount, complement = PL8Aac, ncomplement = PL8Aaccount)
IF (Length80count GT 0.0) AND (PL8Acount GT 0.0) THEN Calpha[38, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Acount GT 0.0) THEN Calpha[38, PL8A] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Aacount GT 0.0) THEN Calpha[38, PL8Aa] = 0.00 ; for YEP FISHPREY[1, LocHV[1, *]]

PL8B = WHERE(((FISHPREY[13, LocHV[3, *]] / WAE[1, *]) LT 0.2), PL8Bcount, complement = PL8Bc, ncomplement = PL8Bccount)
PL8Ba = WHERE(((FISHPREY[13, LocHV[3, *]] / WAE[1, *]) GE 0.2), PL8Bacount, complement = PL8Bac, ncomplement = PL8Baccount)
IF (Length80count GT 0.0) AND (PL8Bcount GT 0.0) THEN Calpha[39, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Bcount GT 0.0) THEN Calpha[39, PL8B] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Bacount GT 0.0) THEN Calpha[39, PL8Ba] = 0.00 ; for YEP

PL8C = WHERE(((FISHPREY[13, LocHV[4, *]] / WAE[1, *]) LT 0.2), PL8Ccount, complement = PL8Cc, ncomplement = PL8Cccount)
PL8Ca = WHERE(((FISHPREY[13, LocHV[4, *]] / WAE[1, *]) GE 0.2), PL8Cacount, complement = PL8Cac, ncomplement = PL8Caccount)
IF (Length80count GT 0.0) AND (PL8Ccount GT 0.0) THEN Calpha[40, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL8Ccount GT 0.0) THEN Calpha[40, PL8C] = 0.25 
IF (Length80ccount GT 0.0) AND (PL8Cacount GT 0.0) THEN Calpha[40, PL8Ca] = 0.00 ; for YEP

PL8D = WHERE(((FISHPREY[13, LocHV[6, *]] / WAE[1, *]) LT 0.2), PL8Dcount, complement = PL8Dc, ncomplement = PL8Dccount)
PL8Da = WHERE(((FISHPREY[13, LocHV[6, *]] / WAE[1, *]) GE 0.2), PL8Dacount, complement = PL8Dac, ncomplement = PL8Daccount)
IF (Length80count GT 0.0) AND (PL8Dcount GT 0.0) THEN Calpha[41, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL8Dcount GT 0.0) THEN Calpha[41, PL8D] = 0.25 
IF (Length80ccount GT 0.0) AND (PL8Dacount GT 0.0) THEN Calpha[41, PL8Da] = 0.00 ; for YEP

PL8E = WHERE(((FISHPREY[13, LocHV[8, *]] / WAE[1, *]) LT 0.2), PL8Ecount, complement = PL8Ec, ncomplement = PL8Eccount)
PL8Ea = WHERE(((FISHPREY[13, LocHV[8, *]] / WAE[1, *]) GE 0.2), PL8Eacount, complement = PL8Eac, ncomplement = PL8Eaccount)
IF (Length80count GT 0.0) AND (PL8Ecount GT 0.0) THEN Calpha[42, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL8Ecount GT 0.0) THEN Calpha[42, PL8E] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Eacount GT 0.0) THEN Calpha[42, PL8Ea] = 0.00 ; for YEP

PL8F = WHERE(((FISHPREY[13, LocHV[17, *]] / WAE[1, *]) LT 0.2), PL8Fcount, complement = PL8Fc, ncomplement = PL8Fccount)
PL8Fa = WHERE(((FISHPREY[13, LocHV[17, *]] / WAE[1, *]) GE 0.2), PL8Facount, complement = PL8Fac, ncomplement = PL8Faccount)
IF (Length80count GT 0.0) AND (PL8Fcount GT 0.0) THEN Calpha[43, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Fcount GT 0.0) THEN Calpha[43, PL8F] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Facount GT 0.0) THEN Calpha[43, PL8Fa] = 0.00 ; for YEP

PL8G = WHERE(((FISHPREY[13, LocHV[26, *]] / WAE[1, *]) LT 0.2) AND (WAE[1, *] LE 80.0), PL8Gcount, complement = PL8Gc, ncomplement = PL8Gccount)
PL8Ga = WHERE(((FISHPREY[13, LocHV[26, *]] / WAE[1, *]) GE 0.2) AND (WAE[1, *] LE 80.0), PL8Gacount, complement = PL8Gac, ncomplement = PL8Gaccount)
IF (Length80count GT 0.0) AND (PL8Gcount GT 0.0) THEN Calpha[44, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL8Gcount GT 0.0) THEN Calpha[44, PL8G] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Gacount GT 0.0) THEN Calpha[44, PL8Ga] = 0.00 ; for YEP

PL8H = WHERE(((FISHPREY[13, LocHV[35, *]] / WAE[1, *]) LT 0.2), PL8Hcount, complement = PL8Hc, ncomplement = PL8Hccount)
PL8Ha = WHERE(((FISHPREY[13, LocHV[35, *]] / WAE[1, *]) GE 0.2), PL8Hacount, complement = PL8Hac, ncomplement = PL8Haccount)
IF (Length80count GT 0.0) AND (PL8Hcount GT 0.0) THEN Calpha[45, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Hcount GT 0.0) THEN Calpha[45, PL8H] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Hacount GT 0.0) THEN Calpha[45, PL8Ha] = 0.00 ; for YEP

PL8I = WHERE(((FISHPREY[13, LocHV[44, *]] / WAE[1, *]) LT 0.2), PL8Icount, complement = PL8Ic, ncomplement = PL8Iccount)
PL8Ia = WHERE(((FISHPREY[13, LocHV[44, *]] / WAE[1, *]) GE 0.2), PL8Iacount, complement = PL8Iac, ncomplement = PL8Iaccount)
IF (Length80count GT 0.0) AND (PL8Icount GT 0.0)  THEN Calpha[46, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Icount GT 0.0) THEN Calpha[46, PL8I] = 0.25 
IF (Length80ccount GT 0.0) AND (PL8Iacount GT 0.0) THEN Calpha[46, PL8Ia] = 0.00 ; for YEP

PL8J = WHERE(((FISHPREY[13, LocHV[53, *]] / WAE[1, *]) LT 0.2), PL8Jcount, complement = PL8Jc, ncomplement = PL8Jccount)
PL8Ja = WHERE(((FISHPREY[13, LocHV[53, *]] / WAE[1, *]) GE 0.2), PL8Jacount, complement = PL8Jac, ncomplement = PL8Jaccount)
IF (Length80count GT 0.0) AND (PL8Jcount GT 0.0) THEN Calpha[47, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL8Jcount GT 0.0) THEN Calpha[47, PL8J] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Jacount GT 0.0) THEN Calpha[47, PL8Ja] = 0.00 ; for YEP

PL8K = WHERE(((FISHPREY[13, LocHV[62, *]] / WAE[1, *]) LT 0.2), PL8Kcount, complement = PL8Kc, ncomplement = PL8Kccount)
PL8Ka = WHERE(((FISHPREY[13, LocHV[62, *]] / WAE[1, *]) GE 0.2), PL8Kacount, complement = PL8Kac, ncomplement = PL8Kaccount)
IF (Length80count GT 0.0) AND (PL8Kcount GT 0.0) THEN Calpha[48, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL8Kcount GT 0.0) THEN Calpha[48, PL8K] = 0.25
IF (Length80ccount GT 0.0) AND (PL8Kacount GT 0.0) THEN Calpha[48, PL8Ka] = 0.00 ; for YEP


PL9A = WHERE(((FISHPREY[17, LocHV[1, *]] / WAE[1, *]) LT 0.2), PL9Acount, complement = PL9Ac, ncomplement = PL9Account)
PL9Aa = WHERE(((FISHPREY[17, LocHV[1, *]] / WAE[1, *]) GE 0.2), PL9Aacount, complement = PL9Aac, ncomplement = PL9Aaccount)
IF (Length80count GT 0.0)AND (PL9Acount GT 0.0) THEN Calpha[49, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Acount GT 0.0) THEN Calpha[49, PL9A] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Aacount GT 0.0) THEN Calpha[49, PL9Aa] = 0.00 ; for WAE

PL9B = WHERE(((FISHPREY[17, LocHV[3, *]] / WAE[1, *]) LT 0.2), PL9Bcount, complement = PL9Bc, ncomplement = PL9Bccount)
PL9Ba = WHERE(((FISHPREY[17, LocHV[3, *]] / WAE[1, *]) GE 0.2), PL9Bacount, complement = PL9Bac, ncomplement = PL9Baccount)
IF (Length80count GT 0.0) AND (PL9Bcount GT 0.0) THEN Calpha[50, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Bcount GT 0.0) THEN Calpha[50, PL9B] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Bacount GT 0.0) THEN Calpha[50, PL9Ba] = 0.00 ; for

PL9C = WHERE(((FISHPREY[17, LocHV[4, *]] / WAE[1, *]) LT 0.2), PL9Ccount, complement = PL9Cc, ncomplement = PL9Cccount)
PL9Ca = WHERE(((FISHPREY[17, LocHV[4, *]] / WAE[1, *]) GE 0.2), PL9Cacount, complement = PL9Cac, ncomplement = PL9Caccount)
IF (Length80count GT 0.0) AND (PL9Ccount GT 0.0) THEN Calpha[51, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL9Ccount GT 0.0) THEN Calpha[51, PL9C] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Cacount GT 0.0) THEN Calpha[51, PL9Ca] = 0.00 ; for 

PL9D = WHERE(((FISHPREY[17, LocHV[6, *]] / WAE[1, *]) LT 0.2), PL9Dcount, complement = PL9Dc, ncomplement = PL9Dccount)
PL9Da = WHERE(((FISHPREY[17, LocHV[6, *]] / WAE[1, *]) GE 0.2), PL9Dacount, complement = PL9Dac, ncomplement = PL9Daccount)
IF (Length80count GT 0.0) AND (PL9Dcount GT 0.0) THEN Calpha[52, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL9Dcount GT 0.0) THEN Calpha[52, PL9D] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Dacount GT 0.0) THEN Calpha[52, PL9Da] = 0.00 ; for 

PL9E = WHERE(((FISHPREY[17, LocHV[8, *]] / WAE[1, *]) LT 0.2), PL9Ecount, complement = PL9Ec, ncomplement = PL9Eccount)
PL9Ea = WHERE(((FISHPREY[17, LocHV[8, *]] / WAE[1, *]) GE 0.2), PL9Eacount, complement = PL9Eac, ncomplement = PL9Eaccount)
IF (Length80count GT 0.0) AND (PL9Ecount GT 0.0) THEN Calpha[53, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL9Ecount GT 0.0) THEN Calpha[53, PL9E] = 0.25 
IF (Length80ccount GT 0.0) AND (PL9Eacount GT 0.0) THEN Calpha[53, PL9Ea] = 0.00 ; for 

PL9F = WHERE(((FISHPREY[17, LocHV[17, *]] / WAE[1, *]) LT 0.2), PL9Fcount, complement = PL9Fc, ncomplement = PL9Fccount)
PL9Fa = WHERE(((FISHPREY[17, LocHV[17, *]] / WAE[1, *]) GE 0.2), PL9Facount, complement = PL9Fac, ncomplement = PL9Faccount)
IF (Length80count GT 0.0) AND (PL9Fcount GT 0.0) THEN Calpha[54, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Fcount GT 0.0) THEN Calpha[54, PL9F] = 0.25 
IF (Length80ccount GT 0.0) AND (PL9Facount GT 0.0) THEN Calpha[54, PL9Fa] = 0.00 ; for 

PL9G = WHERE(((FISHPREY[17, LocHV[26, *]] / WAE[1, *]) LT 0.2), PL9Gcount, complement = PL9Gc, ncomplement = PL9Gccount)
PL9Ga = WHERE(((FISHPREY[17, LocHV[26, *]] / WAE[1, *]) GE 0.2), PL9Gacount, complement = PL9Gac, ncomplement = PL9Gaccount)
IF (Length80count GT 0.0) AND (PL8Kcount GT 0.0) THEN Calpha[55, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Gcount GT 0.0) THEN Calpha[55, PL9G] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Gacount GT 0.0) THEN Calpha[55, PL9Ga] = 0.00 ; for 

PL9H = WHERE(((FISHPREY[17, LocHV[35, *]] / WAE[1, *]) LT 0.2), PL9Hcount, complement = PL9Hc, ncomplement = PL9Hccount)
PL9Ha = WHERE(((FISHPREY[17, LocHV[35, *]] / WAE[1, *]) GE 0.2), PL9Hacount, complement = PL9Hac, ncomplement = PL9Haccount)
IF (Length80count GT 0.0) AND (PL9Hcount GT 0.0) THEN Calpha[56, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Hcount GT 0.0) THEN Calpha[56, PL9H] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Hacount GT 0.0) THEN Calpha[56, PL9Ha] = 0.00 ; for 

PL9I = WHERE(((FISHPREY[17, LocHV[44, *]] / WAE[1, *]) LT 0.2), PL9Icount, complement = PL9Ic, ncomplement = PL9Iccount)
PL9Ia = WHERE(((FISHPREY[17, LocHV[44, *]] / WAE[1, *]) GE 0.2), PL9Iacount, complement = PL9Iac, ncomplement = PL9Iaccount)
IF (Length80count GT 0.0) AND (PL9Icount GT 0.0) THEN Calpha[57, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL9Icount GT 0.0) THEN Calpha[57, PL9I] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Iacount GT 0.0) THEN Calpha[57, PL9Ia] = 0.00 ; for 

PL9J = WHERE(((FISHPREY[17, LocHV[53, *]] / WAE[1, *]) LT 0.2), PL9Jcount, complement = PL9Jc, ncomplement = PL9Jccount)
PL9Ja = WHERE(((FISHPREY[17, LocHV[53, *]] / WAE[1, *]) GE 0.2), PL9Jacount, complement = PL9Jac, ncomplement = PL9Jaccount)
IF (Length80count GT 0.0) AND (PL9Jcount GT 0.0) THEN Calpha[58, Length80] = 0.5 
IF (Length80ccount GT 0.0) AND (PL9Jcount GT 0.0) THEN Calpha[58, PL9J] = 0.25
IF (Length80ccount GT 0.0) AND (PL9Jacount GT 0.0) THEN Calpha[58, PL9Ja] = 0.00 ; for 

PL9K = WHERE(((FISHPREY[17, LocHV[62, *]] / WAE[1, *]) LT 0.2), PL9Kcount, complement = PL9Kc, ncomplement = PL9Kccount)
PL9Ka = WHERE(((FISHPREY[17, LocHV[62, *]] / WAE[1, *]) GE 0.2), PL9Kacount, complement = PL9Kac, ncomplement = PL9Kaccount)
IF (Length80count GT 0.0) AND (PL9Kcount GT 0.0) THEN Calpha[59, Length80] = 0.5
IF (Length80ccount GT 0.0) AND (PL9Kcount GT 0.0) THEN Calpha[59, PL9K] = 0.25 
IF (Length80ccount GT 0.0) AND (PL9Kacount GT 0.0) THEN Calpha[59, PL9Ka] = 0.00 ; for 
;PRINT, 'Calpha'
;PRINT, Calpha

; Calculate attack probability using chesson's alpha = capture efficiency
TOT = FLTARR(9+6, nWAE); total number of all prey atacked and captured
t = FLTARR(m*(9+6), nWAE); total number of each prey atacked and captured
; microzooplankton
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
; small mesozooplankton
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
; large mesozooplanton
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
; benthos
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
; invasive species
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
; yellow perch
;t[45,*] = (Calpha[5,*] * dens[45,*])
t[46,*] = (Calpha[5,*] * dens[46,*])
;t[47,*] = (Calpha[5,*] * dens[47,*])
t[48,*] = (Calpha[6,*] * dens[48,*])
t[49,*] = (Calpha[7,*] * dens[49,*])
;t[50,*] = (Calpha[5,*] * dens[50,*])
t[51,*] = (Calpha[8,*] * dens[51,*])
;t[52,*] = (Calpha[5,*] * dens[52,*])
t[53,*] = (Calpha[9,*] * dens[53,*])
t[84,*] = (Calpha[10,*] * dens[84,*])
t[85,*] = (Calpha[11,*] * dens[85,*])
t[86,*] = (Calpha[12,*] * dens[86,*])
t[87,*] = (Calpha[13,*] * dens[87,*])
t[88,*] = (Calpha[14,*] * dens[88,*])
t[89,*] = (Calpha[15,*] * dens[89,*])
; emerald shiner
;t[45,*] = (Calpha[5,*] * dens[45,*])
t[90,*] = (Calpha[16,*] * dens[90,*])
;t[47,*] = (Calpha[5,*] * dens[47,*])
t[91,*] = (Calpha[17,*] * dens[91,*])
t[92,*] = (Calpha[18,*] * dens[92,*])
;t[50,*] = (Calpha[5,*] * dens[50,*])
t[93,*] = (Calpha[19,*] * dens[93,*])
;t[52,*] = (Calpha[5,*] * dens[52,*])
t[94,*] = (Calpha[20,*] * dens[94,*])
t[95,*] = (Calpha[21,*] * dens[95,*])
t[96,*] = (Calpha[22,*] * dens[96,*])
t[97,*] = (Calpha[23,*] * dens[97,*])
t[98,*] = (Calpha[24,*] * dens[98,*])
t[99,*] = (Calpha[25,*] * dens[99,*])
t[100,*] = (Calpha[26,*] * dens[100,*])
; rainbow smelt
;t[45,*] = (Calpha[5,*] * dens[45,*])
t[101,*] = (Calpha[27,*] * dens[101,*])
;t[47,*] = (Calpha[5,*] * dens[47,*])
t[102,*] = (Calpha[28,*] * dens[102,*])
t[103,*] = (Calpha[29,*] * dens[103,*])
;t[50,*] = (Calpha[5,*] * dens[50,*])
t[104,*] = (Calpha[30,*] * dens[104,*])
;t[52,*] = (Calpha[5,*] * dens[52,*])
t[105,*] = (Calpha[31,*] * dens[105,*])
t[106,*] = (Calpha[32,*] * dens[106,*])
t[107,*] = (Calpha[33,*] * dens[107,*])
t[108,*] = (Calpha[34,*] * dens[108,*])
t[109,*] = (Calpha[35,*] * dens[109,*])
t[110,*] = (Calpha[36,*] * dens[110,*])
t[111,*] = (Calpha[37,*] * dens[111,*])
; round goby
;t[45,*] = (Calpha[5,*] * dens[45,*])
t[112,*] = (Calpha[38,*] * dens[112,*])
;t[47,*] = (Calpha[5,*] * dens[47,*])
t[113,*] = (Calpha[39,*] * dens[113,*])
t[114,*] = (Calpha[40,*] * dens[114,*])
;t[50,*] = (Calpha[5,*] * dens[50,*])
t[115,*] = (Calpha[41,*] * dens[115,*])
;t[52,*] = (Calpha[5,*] * dens[52,*])
t[116,*] = (Calpha[42,*] * dens[116,*])
t[117,*] = (Calpha[43,*] * dens[117,*])
t[118,*] = (Calpha[44,*] * dens[118,*])
t[119,*] = (Calpha[45,*] * dens[119,*])
t[120,*] = (Calpha[46,*] * dens[120,*])
t[121,*] = (Calpha[47,*] * dens[121,*])
t[122,*] = (Calpha[48,*] * dens[122,*])
; WALLEYE
;t[45,*] = (Calpha[5,*] * dens[45,*])
t[123,*] = (Calpha[49,*] * dens[123,*])
;t[47,*] = (Calpha[5,*] * dens[47,*])
t[124,*] = (Calpha[50,*] * dens[124,*])
t[125,*] = (Calpha[51,*] * dens[125,*])
;t[50,*] = (Calpha[5,*] * dens[50,*])
t[126,*] = (Calpha[52,*] * dens[126,*])
;t[52,*] = (Calpha[5,*] * dens[52,*])
t[127,*] = (Calpha[53,*] * dens[127,*])
t[128,*] = (Calpha[54,*] * dens[128,*])
t[129,*] = (Calpha[55,*] * dens[129,*])
t[130,*] = (Calpha[56,*] * dens[130,*])
t[131,*] = (Calpha[57,*] * dens[131,*])
t[132,*] = (Calpha[58,*] * dens[132,*])
t[133,*] = (Calpha[59,*] * dens[133,*])

;TOT[0, *] = t[0,*] + t[9,*] + t[18,*] + t[27,*] + t[36,*] + t[45,*]
TOT[1, *] = t[1,*] + t[10,*] + t[19,*] + t[28,*] + t[37,*] + t[46,*] + t[90,*] + t[101,*] + t[112,*] + t[123,*]
;TOT[2, *] = t[2,*] + t[11,*] + t[20,*] + t[29,*] + t[38,*] + t[47,*]
TOT[3, *] = t[3,*] + t[12,*] + t[21,*] + t[30,*] + t[39,*] + t[48,*] + t[91,*] + t[102,*] + t[113,*] + t[124,*]
TOT[4, *] = t[4,*] + t[13,*] + t[22,*] + t[31,*] + t[40,*] + t[49,*] + t[92,*] + t[103,*] + t[114,*] + t[125,*]
;TOT[5, *] = t[5,*] + t[14,*] + t[23,*] + t[32,*] + t[41,*] + t[50,*]
TOT[6, *] = t[6,*] + t[15,*] + t[24,*] + t[33,*] + t[42,*] + t[51,*] + t[93,*] + t[104,*] + t[115,*] + t[126,*]
;TOT[7, *] = t[7,*] + t[16,*] + t[25,*] + t[34,*] + t[43,*] + t[52,*]

TOT[8, *] = t[8,*] + t[17,*] + t[26,*] + t[35,*] + t[44,*] + t[53,*] + t[94,*] + t[105,*] + t[116,*] + t[127,*]

TOT[9, *] = t[54,*] + t[60,*] + t[66,*] + t[72,*] + t[78,*] + t[84,*] + t[95,*] + t[106,*] + t[117,*] + t[128,*]
TOT[10, *] = t[55,*] + t[61,*] + t[67,*] + t[73,*] + t[79,*] + t[85,*] + t[96,*] + t[107,*] + t[118,*] + t[129,*]
TOT[11, *] = t[56,*] + t[62,*] + t[68,*] + t[74,*] + t[80,*] + t[86,*] + t[97,*] + t[108,*] + t[119,*] + t[130,*]
TOT[12, *] = t[57,*] + t[63,*] + t[69,*] + t[75,*] + t[81,*] + t[87,*] + t[98,*] + t[109,*] + t[120,*] + t[131,*]
TOT[13, *] = t[58,*] + t[64,*] + t[70,*] + t[76,*] + t[82,*] + t[88,*] + t[99,*] + t[110,*] + t[121,*] + t[132,*]
TOT[14, *] = t[59,*] + t[65,*] + t[71,*] + t[77,*] + t[83,*] + t[89,*] + t[100,*] + t[111,*] + t[122,*] + t[133,*]
;PRINT, 'TOT'
;PRINT, TOT

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
preyTOT = FLTARR(nWAE)
preyTOT2 = FLTARR(9, nWAE)
; For vertical movement
preyTOT3 = FLTARR(nWAE)
preyTOT4 = FLTARR(7, nWAE)

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

;FOR ivvv = 0L, nWAE - 1L DO BEGIN
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
EnvironHVprey = FLTARR(9+7, nWAE)
; For horizontal movement
;EnvironHVprey[0, *] = (TOT[0, *] / preyTOT2[0, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[1, *] = (TOT[1, *] / preyTOT2[1, *]) * RANDOMU(seed, nWAE, /DOUBLE)
;EnvironHVprey[2, *] = (TOT[2, *] / preyTOT2[2, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[3, *] = (TOT[3, *] / preyTOT2[3, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[4, *] = (TOT[4, *] / preyTOT2[4, *]) * RANDOMU(seed, nWAE, /DOUBLE)
;EnvironHVprey[5, *] = (TOT[5, *] / preyTOT2[5, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[6, *] = (TOT[6, *] / preyTOT2[6, *]) * RANDOMU(seed, nWAE, /DOUBLE)
;EnvironHVprey[7, *] = (TOT[7, *] / preyTOT2[7, *]) * RANDOMU(seed, nYP, /DOUBLE)
EnvironHVprey[8, *] = (TOT[8, *] / preyTOT2[8, *]) * RANDOMU(seed, nWAE, /DOUBLE)
; For vertical movement
EnvironHVprey[9, *] = (TOT[9, *] / preyTOT4[1, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[10, *] = (TOT[10, *] / preyTOT4[2, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[11, *] = (TOT[11, *] / preyTOT4[3, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[12, *] = (TOT[12, *] / preyTOT4[4, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[13, *] = (TOT[13, *] / preyTOT4[5, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[14, *] = (TOT[14, *] / preyTOT4[6, *]) * RANDOMU(seed, nWAE, /DOUBLE)
EnvironHVprey[15, *] = (TOT[8, *] / preyTOT4[0, *]) * RANDOMU(seed, nWAE, /DOUBLE)
;PRINT, 'EnvironHVprey'
;PRINT, EnvironHVprey

EnvironHVSum = FLTARR(9+7, nWAE)
;;EnvironHVSum[0, *] = DOUBLE((EnvironHVDO[0, *] * EnvironHVT[0, *] * EnvironHVprey[0, *])^(1.0/3.0))
;EnvironHVSum[1, *] = DOUBLE((EnvironHVDO[1, *] * EnvironHVT[1, *] * EnvironHVprey[1, *])^(1.0/3.0))
;;EnvironHVSum[2, *] = DOUBLE((EnvironHVDO[2, *] * EnvironHVT[2, *] * EnvironHVprey[2, *])^(1.0/3.0))
;EnvironHVSum[3, *] = DOUBLE((EnvironHVDO[3, *] * EnvironHVT[3, *] * EnvironHVprey[3, *])^(1.0/3.0))
;EnvironHVSum[4, *] = DOUBLE((EnvironHVDO[4, *] * EnvironHVT[4, *] * EnvironHVprey[4, *])^(1.0/3.0))
;;EnvironHVSum[5, *] = DOUBLE((EnvironHVDO[5, *] * EnvironHVT[5, *] * EnvironHVprey[5, *])^(1.0/3.0))
;EnvironHVSum[6, *] = DOUBLE((EnvironHVDO[6, *] * EnvironHVT[6, *] * EnvironHVprey[6, *])^(1.0/3.0))
;;EnvironHVSum[7, *] = DOUBLE((EnvironHVDO[7, *] * EnvironHVT[7, *] * EnvironHVprey[7, *])^(1.0/3.0))
;EnvironHVSum[8, *] = DOUBLE((EnvironHVDO[8, *] * EnvironHVT[8, *] * EnvironHVprey[8, *])^(1.0/3.0))

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
Gutfull2 = (100.- (WAE[60, *] < 100.0))/100.; < (1./3.); * RANDOMU(seed, nWAE, /DOUBLE)
Gutfull = (1. - Gutfull2)/2.
;print, 'gutfull', transpose(gutfull)
;print, 'gutfull2', transpose(gutfull2)
;EnvironHVDO[1, *]^ * EnvironHVT[1, *] ^ * EnvironHVprey[1, *]^
EnvironHVSum[1, *] = DOUBLE(EnvironHVDO[1, *]^gutfull * EnvironHVT[1, *]^gutfull * EnvironHVprey[1, *]^gutfull2)
EnvironHVSum[3, *] = DOUBLE(EnvironHVDO[3, *]^gutfull * EnvironHVT[3, *]^gutfull * EnvironHVprey[3, *]^gutfull2)
EnvironHVSum[4, *] = DOUBLE(EnvironHVDO[4, *]^gutfull * EnvironHVT[4, *]^gutfull * EnvironHVprey[4, *]^gutfull2)
EnvironHVSum[6, *] = DOUBLE(EnvironHVDO[6, *]^gutfull * EnvironHVT[6, *]^gutfull * EnvironHVprey[6, *]^gutfull2)
EnvironHVSum[8, *] = DOUBLE(EnvironHVDO[8, *]^gutfull * EnvironHVT[8, *]^gutfull * EnvironHVprey[8, *]^gutfull2)
; WITHOUT LIGHT EFFECT
;EnvironHVSum[9, *] = DOUBLE(EnvironHVDO[9, *]^gutfull * EnvironHVT[9, *]^gutfull * EnvironHVprey[9, *]^gutfull2)
;EnvironHVSum[10, *] = DOUBLE(EnvironHVDO[10, *]^gutfull * EnvironHVT[10, *]^gutfull * EnvironHVprey[10, *]^gutfull2)
;EnvironHVSum[11, *] = DOUBLE(EnvironHVDO[11, *]^gutfull * EnvironHVT[11, *]^gutfull * EnvironHVprey[11, *]^gutfull2)
;EnvironHVSum[12, *] = DOUBLE(EnvironHVDO[12, *]^gutfull * EnvironHVT[12, *]^gutfull * EnvironHVprey[12, *]^gutfull2)
;EnvironHVSum[13, *] = DOUBLE(EnvironHVDO[13, *]^gutfull * EnvironHVT[13, *]^gutfull * EnvironHVprey[13, *]^gutfull2)
;EnvironHVSum[14, *] = DOUBLE(EnvironHVDO[14, *]^gutfull * EnvironHVT[14, *]^gutfull * EnvironHVprey[14, *]^gutfull2)
;EnvironHVSum[15, *] = DOUBLE(EnvironHVDO[8, *]^gutfull * EnvironHVT[8, *]^gutfull * EnvironHVprey[15, *]^gutfull2)

; WITH LIGHT EFFECT ON VERTICAL MOVEMENT
;Gutfull3 = (1. - Gutfull2)/3.
;EnvironHVSum[9, *] = DOUBLE(EnvironHVDO[9, *]^gutfull3 * EnvironHVT[9, *]^gutfull3 * EnvironHVL[9, *]^gutfull3 * EnvironHVprey[9, *]^gutfull2)
;EnvironHVSum[10, *] = DOUBLE(EnvironHVDO[10, *]^gutfull3 * EnvironHVT[10, *]^gutfull3 * EnvironHVL[10, *]^gutfull3 * EnvironHVprey[10, *]^gutfull2)
;EnvironHVSum[11, *] = DOUBLE(EnvironHVDO[11, *]^gutfull3 * EnvironHVT[11, *]^gutfull3 * EnvironHVL[11, *]^gutfull3 * EnvironHVprey[11, *]^gutfull2)
;EnvironHVSum[12, *] = DOUBLE(EnvironHVDO[12, *]^gutfull3 * EnvironHVT[12, *]^gutfull3 * EnvironHVL[12, *]^gutfull3 * EnvironHVprey[12, *]^gutfull2)
;EnvironHVSum[13, *] = DOUBLE(EnvironHVDO[13, *]^gutfull3 * EnvironHVT[13, *]^gutfull3 * EnvironHVL[13, *]^gutfull3 * EnvironHVprey[13, *]^gutfull2)
;EnvironHVSum[14, *] = DOUBLE(EnvironHVDO[14, *]^gutfull3 * EnvironHVT[14, *]^gutfull3 * EnvironHVL[14, *]^gutfull3 * EnvironHVprey[14, *]^gutfull2)
;EnvironHVSum[15, *] = DOUBLE(EnvironHVDO[8, *]^gutfull3 * EnvironHVT[8, *]^gutfull3 * EnvironHVL[8, *]^gutfull3 * EnvironHVprey[15, *]^gutfull2)

Gutfull4 = (1. - EnvironHVDO[9, *]);DO
Gutfull5 = (1. - EnvironHVDO[10, *])
Gutfull6 = (1. - EnvironHVDO[11, *])
Gutfull7 = (1. - EnvironHVDO[12, *])
Gutfull8 = (1. - EnvironHVDO[13, *])
Gutfull9 = (1. - EnvironHVDO[14, *])
Gutfull10 = (1. - EnvironHVDO[8, *])

Gutfull11 = (1. - Gutfull4) * (1 - EnvironHVL[9, *]); Light
Gutfull12 = (1. - Gutfull5) * (1 - EnvironHVL[10, *])
Gutfull13 = (1. - Gutfull6) * (1 - EnvironHVL[11, *])
Gutfull14 = (1. - Gutfull7) * (1 - EnvironHVL[12, *])
Gutfull15 = (1. - Gutfull8) * (1 - EnvironHVL[13, *])
Gutfull16 = (1. - Gutfull9) * (1 - EnvironHVL[14, *])
Gutfull17 = (1. - Gutfull10) * (1 - EnvironHVL[8, *])

Gutfull18 = (1 - Gutfull4 - Gutfull11)*(Gutfull2); prey
Gutfull19 = (1 - Gutfull5 - Gutfull12)*(Gutfull2)
Gutfull20 = (1 - Gutfull6 - Gutfull13)*(Gutfull2)
Gutfull21 = (1 - Gutfull7 - Gutfull14)*(Gutfull2)
Gutfull22 = (1 - Gutfull8 - Gutfull15)*(Gutfull2)
Gutfull23 = (1 - Gutfull9 - Gutfull16)*(Gutfull2)
Gutfull24 = (1 - Gutfull10 - Gutfull17)*(Gutfull2)

Gutfull25 = (1 - Gutfull4 - Gutfull11 - Gutfull18); temperature
Gutfull26 = (1 - Gutfull5 - Gutfull12 - Gutfull19)
Gutfull27 = (1 - Gutfull6 - Gutfull13 - Gutfull20)
Gutfull28 = (1 - Gutfull7 - Gutfull14 - Gutfull21)
Gutfull29 = (1 - Gutfull8 - Gutfull15 - Gutfull22)
Gutfull30 = (1 - Gutfull9 - Gutfull16 - Gutfull23)
Gutfull31 = (1 - Gutfull10 - Gutfull17 - Gutfull24)

EnvironHVSum[9, *] = DOUBLE(EnvironHVDO[9, *]^gutfull4 * EnvironHVT[9, *]^gutfull25 * EnvironHVL[9, *]^gutfull11 * EnvironHVprey[9, *]^gutfull18)
EnvironHVSum[10, *] = DOUBLE(EnvironHVDO[10, *]^gutfull5 * EnvironHVT[10, *]^gutfull26 * EnvironHVL[10, *]^gutfull12 * EnvironHVprey[10, *]^gutfull19)
EnvironHVSum[11, *] = DOUBLE(EnvironHVDO[11, *]^gutfull6 * EnvironHVT[11, *]^gutfull27 * EnvironHVL[11, *]^gutfull13 * EnvironHVprey[11, *]^gutfull20)
EnvironHVSum[12, *] = DOUBLE(EnvironHVDO[12, *]^gutfull7 * EnvironHVT[12, *]^gutfull28 * EnvironHVL[12, *]^gutfull14 * EnvironHVprey[12, *]^gutfull21)
EnvironHVSum[13, *] = DOUBLE(EnvironHVDO[13, *]^gutfull8 * EnvironHVT[13, *]^gutfull29 * EnvironHVL[13, *]^gutfull15 * EnvironHVprey[13, *]^gutfull22)
EnvironHVSum[14, *] = DOUBLE(EnvironHVDO[14, *]^gutfull9 * EnvironHVT[14, *]^gutfull30 * EnvironHVL[14, *]^gutfull16 * EnvironHVprey[14, *]^gutfull23)
EnvironHVSum[15, *] = DOUBLE(EnvironHVDO[8, *]^gutfull10 * EnvironHVT[8, *]^gutfull31 * EnvironHVL[8, *]^gutfull17 * EnvironHVprey[15, *]^gutfull24)

; LIGHT EFFECT ONLY FOR VERTICAL MOVEMENT
;EnvironHVSum[9, *] = DOUBLE(EnvironHVL[9, *])
;EnvironHVSum[10, *] = DOUBLE(EnvironHVL[10, *])
;EnvironHVSum[11, *] = DOUBLE(EnvironHVL[11, *])
;EnvironHVSum[12, *] = DOUBLE(EnvironHVL[12, *])
;EnvironHVSum[13, *] = DOUBLE(EnvironHVL[13, *])
;EnvironHVSum[14, *] = DOUBLE(EnvironHVL[14, *])
;EnvironHVSum[15, *] = DOUBLE(EnvironHVL[8, *])

;PRINT, 'GUT FULLNESS',YP[60, *]
;PRINT, 'ENVIRONHVSUM'
;PRINT, ENVIRONHVSUM


; Movement in x-dimension -> cells 4 & 5
; Movement in y-dimension -> cells 2 & 7
; fish could also end up in cells 1, 3, 6, and 8, depending on the within-cell locations
; If the current cell is best among neiboring cells, fish will move within the cell randomly.
; Movement in x-dimension
xMove = FLTARR(nWAE)
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
;PRINT, 'xMove'
;PRINT, xMove

; Movement in y-dimension
yMove = FLTARR(nWAE)
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
zMove = FLTARR(nWAE)
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

;zMovePos = FLTARR(nWAE)
;zMoveNeg = FLTARR(nWAE)
;zMoveNon = FLTARR(nWAE)
;FOR iv = 0L, nWAE - 1L DO BEGIN
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
;PRINT, 'zMove'
;PRINT, zMove

;*******Determine the movement orientation****************************************************
  ; For now, each cell is assumed to have gradients between the current and neiboring cells
  ; fish are able to detect gradients within a cetain range... 

; Horizontal movement
HorOriAng = FLTARR(nWAE)
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
VerOriAng = FLTARR(nWAE)
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
; Calculate fish swimming speed, S, in body s/sec
;PRINT, 'Length'
;PRINT, Length
SS = FLTARR(nWAE)
S = FLTARR(nWAE)
L = WHERE(WAE[1, *] LT 20.0, Lcount, complement = LL, ncomplement = LLcount)
IF (Lcount GT 0.0) THEN $
S[L] = 3.0227 * ALOG(WAE[1, L]) - 4.6273; for walleye <20mm, Houde, 1969 
 ;SS equation based on data from Houde 1969 in body lengths/sec
IF (LLcount GT 0.0) THEN $
S[LL] = 1000 * (0.263 + 0.72 * WAE[1, LL] + 0.012 * WAE[26, LL]); for walleye >20mm; Peake et al., 2000
; Converts SS into mm/s
IF (Lcount GT 0.0) THEN SS[L] = S[L] * WAE[1, L]
IF (LLcount GT 0.0) THEN SS[LL] = S[LL]
;PRINT, 'S =', S
;PRINT, 'Swimming speed (mm/s)'
;PRINT, SS
;PRINT, 'Swimming speed in x-dimension (mm/s)'
;PRINT, SS*COS(HorOriAng) * SIN(VerOriAng)
;PRINT, 'Swimming speed in y-dimension (mm/s)'
;PRINT, SS*SIN(HorOriAng) * SIN(VerOriAng)
;PRINT, 'Swimming speed in Z-dimension (mm/s)'
;PRINT, SS*COS(VerOriAng)
;PRINT, 'Water currents (mm/s) xyz'
;PRINT, newinput[12:15, WAE[14, *]]

; Calculate realized swimming speed (mm/s) in xyz-dimensions
MoveSpeed = FLTARR(5, nWAE)
MoveSpeed[0, *] = SS*COS(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nWAE, /DOUBLE) + newinput[12, WAE[14, *]]; with a random comopnent
MoveSpeed[1, *] = SS*SIN(HorOriAng) * SIN(VerOriAng) * RANDOMU(seed, nWAE, /DOUBLE) + newinput[13, WAE[14, *]];
IF (Lcount GT 0.0) THEN MoveSpeed[2, L] = SS[L] * COS(VerOriAng[L]) * RANDOMU(seed, Lcount, /DOUBLE)+ newinput[14, WAE[14, L]]; VERTICAL DIRECTION
IF (LLcount GT 0.0) THEN MoveSpeed[2, LL] = SS[LL]/(ts*1000.) * COS(VerOriAng[LL]) * RANDOMU(seed, LLcount, /DOUBLE)+ newinput[14, WAE[14, LL]]; VERTICAL DIRECTION
MoveSpeed[3, *] = (MoveSpeed[0, *]^2 + MoveSpeed[1, *]^2)^0.5;  actual swimming speed, HORIZONTAL DIRECTION FOR NOW

; NEED TO CHECK IF RESULTANT SWIMMING SPEED DOES NOT EXCEED MAXIMUM ACCETABLE SPEED*****
MoveSpeed[4, *] = (0.102*(WAE[1, *]/39.10/EXP(0.330)) + 30.3) * 10.0
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
xNewLocWithinCell = FLTARR(nWAE)
yNewLocWithinCell = FLTARR(nWAE)
zNewLocWithinCell = FLTARR(nWAE)
VerSize = FLTARR(nWAE)
VerSize[*] = (Grid2D[3, WAE[13, *]] / 20.)*1000.; in mm
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
  IF zMoveOut11count GT 0.0 THEN WAE[14, zMoveOut11] = LocHV[54, zMoveOut11];zMove[zMoveOut1] = 14
  IF zMoveOut12count GT 0.0 THEN WAE[14, zMoveOut12] = LocHV[54, zMoveOut12];zMove[zMoveOut2] = 14
  IF zMoveOut13count GT 0.0 THEN WAE[14, zMoveOut13] = LocHV[45, zMoveOut13];zMove[zMoveOut3] = 13
  IF zMoveOut14count GT 0.0 THEN WAE[14, zMoveOut14] = LocHV[36, zMoveOut14];zMove[zMoveOut4] = 12
  IF zMoveOut15count GT 0.0 THEN WAE[14, zMoveOut15] = LocHV[0, zMoveOut15];zMove[zMoveOut5] = 15
  IF zMoveOut16count GT 0.0 THEN WAE[14, zMoveOut16] = LocHV[27, zMoveOut16];zMove[zMoveOut6] = 11
  IF zMoveOut17count GT 0.0 THEN WAE[14, zMoveOut17] = LocHV[18, zMoveOut17];zMove[zMoveOut7] = 10
  IF zMoveOut18count GT 0.0 THEN WAE[14, zMoveOut18] = LocHV[9, zMoveOut18];zMove[zMoveOut8] = 9
  IF zMoveOut19count GT 0.0 THEN WAE[14, zMoveOut19] = LocHV[9, zMoveOut19];zMove[zMoveOut9] = 9 -> fix it below
;ENDIF
;PRINT,'xyMoveOut1', xyMoveOut1
;IF xyMoveOut2count GT 0.0 THEN BEGIN; XYloc = 2
  IF zMoveOut21count GT 0.0 THEN WAE[14, zMoveOut21] = LocHV[55, zMoveOut21];zMove[zMoveOut1] = 9
  IF zMoveOut22count GT 0.0 THEN WAE[14, zMoveOut22] = LocHV[55, zMoveOut22];zMove[zMoveOut2] = 9
  IF zMoveOut23count GT 0.0 THEN WAE[14, zMoveOut23] = LocHV[46, zMoveOut23];zMove[zMoveOut3] = 10
  IF zMoveOut24count GT 0.0 THEN WAE[14, zMoveOut24] = LocHV[37, zMoveOut24];zMove[zMoveOut4] = 11
  IF zMoveOut25count GT 0.0 THEN WAE[14, zMoveOut25] = LocHV[1, zMoveOut25];zMove[zMoveOut5] = 15
  IF zMoveOut26count GT 0.0 THEN WAE[14, zMoveOut26] = LocHV[28, zMoveOut26];zMove[zMoveOut6] = 12
  IF zMoveOut27count GT 0.0 THEN WAE[14, zMoveOut27] = LocHV[19, zMoveOut27];zMove[zMoveOut7] = 13
  IF zMoveOut28count GT 0.0 THEN WAE[14, zMoveOut28] = LocHV[10, zMoveOut28];zMove[zMoveOut8] = 14
  IF zMoveOut29count GT 0.0 THEN WAE[14, zMoveOut29] = LocHV[10, zMoveOut29];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut2', xyMoveOut2
;IF xyMoveOut3count GT 0.0 THEN BEGIN; XYloc = 3
  IF zMoveOut31count GT 0.0 THEN WAE[14, zMoveOut31] = LocHV[56, zMoveOut31];zMove[zMoveOut1] = 9
  IF zMoveOut32count GT 0.0 THEN WAE[14, zMoveOut32] = LocHV[56, zMoveOut32];zMove[zMoveOut2] = 9
  IF zMoveOut33count GT 0.0 THEN WAE[14, zMoveOut33] = LocHV[47, zMoveOut33];zMove[zMoveOut3] = 10
  IF zMoveOut34count GT 0.0 THEN WAE[14, zMoveOut34] = LocHV[38, zMoveOut34];zMove[zMoveOut4] = 11
  IF zMoveOut35count GT 0.0 THEN WAE[14, zMoveOut35] = LocHV[2, zMoveOut35];zMove[zMoveOut5] = 15
  IF zMoveOut36count GT 0.0 THEN WAE[14, zMoveOut36] = LocHV[29, zMoveOut36];zMove[zMoveOut6] = 12
  IF zMoveOut37count GT 0.0 THEN WAE[14, zMoveOut37] = LocHV[20, zMoveOut37];zMove[zMoveOut7] = 13
  IF zMoveOut38count GT 0.0 THEN WAE[14, zMoveOut38] = LocHV[11, zMoveOut38];zMove[zMoveOut8] = 14
  IF zMoveOut39count GT 0.0 THEN WAE[14, zMoveOut39] = LocHV[11, zMoveOut39];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut3', xyMoveOut3
;IF xyMoveOut4count GT 0.0 THEN BEGIN; XYloc = 4
  IF zMoveOut41count GT 0.0 THEN WAE[14, zMoveOut41] = LocHV[57, zMoveOut41];zMove[zMoveOut1] = 9
  IF zMoveOut42count GT 0.0 THEN WAE[14, zMoveOut42] = LocHV[57, zMoveOut42];zMove[zMoveOut2] = 9
  IF zMoveOut43count GT 0.0 THEN WAE[14, zMoveOut43] = LocHV[48, zMoveOut43];zMove[zMoveOut3] = 10
  IF zMoveOut44count GT 0.0 THEN WAE[14, zMoveOut44] = LocHV[39, zMoveOut44];zMove[zMoveOut4] = 11
  IF zMoveOut45count GT 0.0 THEN WAE[14, zMoveOut45] = LocHV[3, zMoveOut45];zMove[zMoveOut5] = 15
  IF zMoveOut46count GT 0.0 THEN WAE[14, zMoveOut46] = LocHV[30, zMoveOut46];zMove[zMoveOut6] = 12
  IF zMoveOut47count GT 0.0 THEN WAE[14, zMoveOut47] = LocHV[21, zMoveOut47];zMove[zMoveOut7] = 13
  IF zMoveOut48count GT 0.0 THEN WAE[14, zMoveOut48] = LocHV[12, zMoveOut48];zMove[zMoveOut8] = 14
  IF zMoveOut49count GT 0.0 THEN WAE[14, zMoveOut49] = LocHV[12, zMoveOut49];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut4', xyMoveOut4
;IF xyMoveOut5count GT 0.0 THEN BEGIN; XYloc = 5
  IF zMoveOut51count GT 0.0 THEN WAE[14, zMoveOut51] = LocHV[58, zMoveOut51];zMove[zMoveOut1] = 9
  IF zMoveOut52count GT 0.0 THEN WAE[14, zMoveOut52] = LocHV[58, zMoveOut52];zMove[zMoveOut2] = 9
  IF zMoveOut53count GT 0.0 THEN WAE[14, zMoveOut53] = LocHV[49, zMoveOut53];zMove[zMoveOut3] = 10
  IF zMoveOut54count GT 0.0 THEN WAE[14, zMoveOut54] = LocHV[40, zMoveOut54];zMove[zMoveOut4] = 11
  IF zMoveOut55count GT 0.0 THEN WAE[14, zMoveOut55] = LocHV[4, zMoveOut55];zMove[zMoveOut5] = 15
  IF zMoveOut56count GT 0.0 THEN WAE[14, zMoveOut56] = LocHV[31, zMoveOut56];zMove[zMoveOut6] = 12
  IF zMoveOut57count GT 0.0 THEN WAE[14, zMoveOut57] = LocHV[22, zMoveOut57];zMove[zMoveOut7] = 13
  IF zMoveOut58count GT 0.0 THEN WAE[14, zMoveOut58] = LocHV[13, zMoveOut58];zMove[zMoveOut8] = 14
  IF zMoveOut59count GT 0.0 THEN WAE[14, zMoveOut59] = LocHV[13, zMoveOut59];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut5', xyMoveOut5
;IF xyMoveOut6count GT 0.0 THEN BEGIN; XYloc = 6
  IF zMoveOut61count GT 0.0 THEN WAE[14, zMoveOut61] = LocHV[59, zMoveOut61];zMove[zMoveOut1] = 9
  IF zMoveOut62count GT 0.0 THEN WAE[14, zMoveOut62] = LocHV[59, zMoveOut62];zMove[zMoveOut2] = 9
  IF zMoveOut63count GT 0.0 THEN WAE[14, zMoveOut63] = LocHV[50, zMoveOut63];zMove[zMoveOut3] = 10
  IF zMoveOut64count GT 0.0 THEN WAE[14, zMoveOut64] = LocHV[41, zMoveOut64];zMove[zMoveOut4] = 11
  IF zMoveOut65count GT 0.0 THEN WAE[14, zMoveOut65] = LocHV[5, zMoveOut65];zMove[zMoveOut5] = 15
  IF zMoveOut66count GT 0.0 THEN WAE[14, zMoveOut66] = LocHV[32, zMoveOut66];zMove[zMoveOut6] = 12
  IF zMoveOut67count GT 0.0 THEN WAE[14, zMoveOut67] = LocHV[23, zMoveOut67];zMove[zMoveOut7] = 13
  IF zMoveOut68count GT 0.0 THEN WAE[14, zMoveOut68] = LocHV[14, zMoveOut68];zMove[zMoveOut8] = 14
  IF zMoveOut69count GT 0.0 THEN WAE[14, zMoveOut69] = LocHV[14, zMoveOut69];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut6', xyMoveOut6
;IF xyMoveOut7count GT 0.0 THEN BEGIN; XYloc = 7
  IF zMoveOut71count GT 0.0 THEN WAE[14, zMoveOut71] = LocHV[60, zMoveOut71];zMove[zMoveOut1] = 9
  IF zMoveOut72count GT 0.0 THEN WAE[14, zMoveOut72] = LocHV[60, zMoveOut72];zMove[zMoveOut2] = 9
  IF zMoveOut73count GT 0.0 THEN WAE[14, zMoveOut73] = LocHV[51, zMoveOut73];zMove[zMoveOut3] = 10
  IF zMoveOut74count GT 0.0 THEN WAE[14, zMoveOut74] = LocHV[42, zMoveOut74];zMove[zMoveOut4] = 11
  IF zMoveOut75count GT 0.0 THEN WAE[14, zMoveOut75] = LocHV[6, zMoveOut75];zMove[zMoveOut5] = 15
  IF zMoveOut76count GT 0.0 THEN WAE[14, zMoveOut76] = LocHV[33, zMoveOut76];zMove[zMoveOut6] = 12
  IF zMoveOut77count GT 0.0 THEN WAE[14, zMoveOut77] = LocHV[24, zMoveOut77];zMove[zMoveOut7] = 13
  IF zMoveOut78count GT 0.0 THEN WAE[14, zMoveOut78] = LocHV[15, zMoveOut78];zMove[zMoveOut8] = 14
  IF zMoveOut79count GT 0.0 THEN WAE[14, zMoveOut79] = LocHV[15, zMoveOut79];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut7', xyMoveOut7
;IF xyMoveOut8count GT 0.0 THEN BEGIN; XYloc = 8
  IF zMoveOut81count GT 0.0 THEN WAE[14, zMoveOut81] = LocHV[61, zMoveOut81];zMove[zMoveOut1] = 9
  IF zMoveOut82count GT 0.0 THEN WAE[14, zMoveOut82] = LocHV[61, zMoveOut82];zMove[zMoveOut2] = 9
  IF zMoveOut83count GT 0.0 THEN WAE[14, zMoveOut83] = LocHV[52, zMoveOut83];zMove[zMoveOut3] = 10
  IF zMoveOut84count GT 0.0 THEN WAE[14, zMoveOut84] = LocHV[43, zMoveOut84];zMove[zMoveOut4] = 11
  IF zMoveOut85count GT 0.0 THEN WAE[14, zMoveOut85] = LocHV[7, zMoveOut85];zMove[zMoveOut5] = 15
  IF zMoveOut86count GT 0.0 THEN WAE[14, zMoveOut86] = LocHV[34, zMoveOut86];zMove[zMoveOut6] = 12
  IF zMoveOut87count GT 0.0 THEN WAE[14, zMoveOut87] = LocHV[25, zMoveOut87];zMove[zMoveOut7] = 13
  IF zMoveOut88count GT 0.0 THEN WAE[14, zMoveOut88] = LocHV[16, zMoveOut88];zMove[zMoveOut8] = 14
  IF zMoveOut89count GT 0.0 THEN WAE[14, zMoveOut89] = LocHV[16, zMoveOut89];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut8', xyMoveOut8
;IF xyMoveOut9count GT 0.0 THEN BEGIN; XYloc = 9
  IF zMoveOut91count GT 0.0 THEN WAE[14, zMoveOut91] = LocHV[62, zMoveOut91];zMove[zMoveOut1] = 9
  IF zMoveOut92count GT 0.0 THEN WAE[14, zMoveOut92] = LocHV[62, zMoveOut92];zMove[zMoveOut2] = 9
  IF zMoveOut93count GT 0.0 THEN WAE[14, zMoveOut93] = LocHV[53, zMoveOut93];zMove[zMoveOut3] = 10
  IF zMoveOut94count GT 0.0 THEN WAE[14, zMoveOut94] = LocHV[44, zMoveOut94];zMove[zMoveOut4] = 11
  IF zMoveOut95count GT 0.0 THEN WAE[14, zMoveOut95] = LocHV[8, zMoveOut95];zMove[zMoveOut6] = 12
  IF zMoveOut96count GT 0.0 THEN WAE[14, zMoveOut96] = LocHV[35, zMoveOut96];zMove[zMoveOut6] = 12
  IF zMoveOut97count GT 0.0 THEN WAE[14, zMoveOut97] = LocHV[26, zMoveOut97];zMove[zMoveOut7] = 13
  IF zMoveOut98count GT 0.0 THEN WAE[14, zMoveOut98] = LocHV[17, zMoveOut98];zMove[zMoveOut8] = 14
  IF zMoveOut99count GT 0.0 THEN WAE[14, zMoveOut99] = LocHV[17, zMoveOut99];zMove[zMoveOut9] = 14
;ENDIF
;PRINT,'xyMoveOut9', xyMoveOut9
;  PRINT, 'YP[13, *]'
;  PRINT, TRANSPOSE(YP[13, *])
;PRINT, 'NewGrid 3D ID with vertical movement'
;PRINT, TRANSPOSE(WAE[14, *])
;PRINT, 'NewInput[2, WAE[14, *]]', transpose(NewInput[2, WAE[14, *]])
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
; Movement in negative z-dimension
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
NewFishEnviron = FLTARR(20, nWAE)
NewFishEnviron[0:15, *] = NewInput[*, WAE[14, *]];YP[14, *] New 3D gridcell ID
NewFishEnviron[8, *] = TotBenBio[WAE[14, *]];YP[14, *] New TotBenBio
NewFishEnviron[16, *] = xNewLocWithinCell; New within-cell location in x-dimension in new cell
NewFishEnviron[17, *] = yNewLocWithinCell; New within-cell location in y-dimension in new cell
NewFishEnviron[18, *] = zNewLocWithinCell; New within-cell location in z-dimension in new cell
;PRINT, NewFishEnviron
;PRINT, TRANSPOSE(NewFishEnviron[0, *])

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
PRINT, 'Walleye Movement Ends Here'
RETURN, NewFishEnviron; TURN OFF WHEN TESTING
END