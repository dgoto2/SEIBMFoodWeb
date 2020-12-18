FUNCTION ROGmoveV, ROG, nROG, newinput, Grid3D, Grid2D, DOacclim, NewGridID2
; function determines movement in X,Y,Z direction for all ROUND GOBY
;----------------------TEST ONLY---------------------------------------------------------------------------
;PRO ROGmoveV, ROG, nROG, newinput, Grid3D, Grid2D, DOacclim, NewGridID2
;; NEED to change NewInputFiles, YPinitial, YEPacclT, YEPacclDO for testing
;nROG = 50L; number of SI
;ihour = 2L
;ROG = ROGinitial()
;newinput = newinputfiles()
;newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]
;Grid3D = GridCells3D()
;Grid2D = GridCells2D()
;DOacclim = ROGacclDO()
;NewGridID2 = ROG[13, *]
;----------------------------------------------------------------------------------------------------------

;  USE ARRAY_INDICES 
;***NEED stomach fullness component - a threshold value to determine trade of between survival and food intake
PRINT, 'ROG Vertical Movement Begins Here'
tstart = SYSTIME(/seconds)
; Randomly determine movement
; Probability of movement in Z has to be greater than in X and Y due to cell size
;PRINT, 'Inital X', WAE[10, *]
;PRINT, 'Inital Y', WAE[11, *]
;PRINT, 'Inital Z', WAE[12, *]
;PRINT, 'Inital Horizontal ID', WAE[13, *]
;PRINT, 'Inital 3D ID', WAE[14, *]
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

;--Vertical movement---------------------------------------------------------------------------------------------------------------------------------
NewCell = FLTARR(15, nROG)
NewLoc = FLTARR(nROG)
Ncell = FLTARR(15, nROG)
d = FLTARR(nROG)
; Random number for each YP SI for vertical movement -> FOR random movement only
;moveZ = ROUND(RANDOMU(seed, nWAE)); moveZ = 0 (move) or 1 (stay)

;-> NEED to incoporate environmental quality and current/swimming speed-based movement
; Estimate habitat index for all cells first?
; Optimal temperature for consumption = .. from wisconsin bioenergetics model
; Stressful/lethal tempeatuere =... get from literature
; Temperature-depednet critical DO level = ...from DO acclimation 
; IF fish >20mm, they prefer benthios to zooplankton

;Temp-DO-prey based component-------------------------------------------------------------------------------
;PRINT, 'New Grid ID =', NewGridID
;PRINT, 'DOcritC =', DOacclim[5, *]; DOcritC for consumption
;PRINT, 'minDOacclC =', DOacclim[7, *]; minDOacclC for consumption
;PRINT, 'Acclimated DO', YP[28, *]; acclimated DO for consumption
PRINT,'NewInput =', newinput[10, *]
;PRINT,'NewInput =', newinput[2, *]
;PRINT,'NewInput =', newinput[3, *]

EnvironV = FLTARR(16, nROG*20L)
NewGridID3D = FLTARR(20L)
NewGridID3D2 = FLTARR(nROG*20L)
;;newinput[3, NewGridID] = NewGridID
;;NewGridID3D =  newinput[4, NewGridID]

; Create an array with 3D grid cell ID after horizontal movement 
jv = 19L
;depth = INDGEN(20) + 1.0; 1 to 20
FOR evvv = 0L, nROG - 1L DO BEGIN
  FOR ev = 0L, nROG - 1L DO BEGIN;evv + 1L 
    NewGridID3D2[evvv : jv] = WHERE(NewGridID2[ev] EQ NewInput[3, 0L : *], NewLoccount2);
    evvv = jv + 1L
    jv = jv + 20L
    ;PRINT, 'NewGridID3D2 =', NewGridID3D2 
  ENDFOR
  ;PRINT, 'NewGridID3D2 =', NewGridID3D2 
ENDFOR
PRINT, 'NewGridID3D2 =', NewGridID3D2

EnvironV[0, *] = newinput[2, NewGridID3D2]; zl
EnvironV[1, *] = newinput[4, NewGridID3D2]; 3D GridCell ID
EnvironV[2:4, *] = newinput[5:7, NewGridID3D2]; zoopl
EnvironV[5, *] = newinput[8, NewGridID3D2]; bentho
EnvironV[6, *] = newinput[9, NewGridID3D2]; amb temp 
EnvironV[7, *] = newinput[10, NewGridID3D2]; ambDO
EnvironV[8, *] = 0.0; Bethotrephe
EnvironV[9, *] = 0.0; fish
EnvironV[1:7, *] = newinput[4:10, NewGridID3D2]; all
;PRINT, 'NewGridID2 =', NewGridID
;PRINT, 'EnvironVzl =', EnvironV[0, *]
;PRINT, 'EnvironVID =', EnvironV[1, *]
;PRINT, 'EnvironVZool =', EnvironV[2:4, *] 
;PRINT, 'EnvironVbentho =', EnvironV[5, *]
;PRINT, 'EnvironVTemp =', EnvironV[6, *]
;PRINT, 'EnvironVDO =', EnvironV[7, *]
;PRINT, 'EnvironVAll =', EnvironV[0:7, *]

LengthV = FLTARR(nROG*20L)
;depth = indgen(20); 1 = top layer; 20 = bottom layer
j = 19L
FOR ii = 0L, nROG*20L - 1L DO BEGIN
FOR iii = 0L, nROG - 1L DO BEGIN
LengthV[ii : j] = ROG[1, iii]
ii = j
j = j + 20L
ENDFOR
ENDFOR
;PRINT, 'LengthV =', LengthV

; Determine a prey length for each prey type (m) in the model
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

; Prey weight
  PW = FLTARR(m); weight of each prey type
  ; Assign weights to each prey type in g
  Pw[0] = 0.182 / 1000000.0; rotifers in g from Letcher 
  Pw[1] = 4.988 / 1000000.0; copepods in g from Letcher
  Pw[2] = 4.988 / 1000000.0; cladocerans in g MADE UP!!!
  Pw[3] = 0.001; chironomids in g MADE UP!!!!
  Pw[4] = 0.001; 60 / 1000000; bythotrephes in g, 500 to 700,~600ug dry = 6000 ug wet
  Pw[5] = 0.003; 42.9 / 1000000; fish in g MADE UP!!!
  ;PRINT, 'PW =', pw
  
; Convert prey biomass (g/L or m^2) into numbers/L or m^2
  dens = FLTARR(m, nROG*20L)
  dens[0,*] = EnvironV[2, *] / Pw[0]; for rotifer 
  dens[1,*] = EnvironV[3, *] / Pw[1]; for copepod
  dens[2,*] = EnvironV[4, *] / Pw[2]; for cladocerans
  pbio3 = WHERE(EnvironV[5, *] GT 0.0, pbio3count, complement = pbio3c, ncomplement = pbio3ccount)
  IF pbio3count GT 0.0 THEN dens[3, pbio3] = EnvironV[5, pbio3] / Pw[3] ELSE dens[3, pbio3c] = 0.0; numbers/m^2 for chironmoid
  dens[4,*] = EnvironV[8, *] / Pw[4]; for bythotrephes 
  dens[5,*] = EnvironV[9, *] / Pw[5]; for fish
  ;PRINT, 'Density =', dens

; Calculate Chesson's alpha for each prey type
  Calpha = FLTARR(m, nROG*20L)
  Calpha[0,*] = 193499 * lengthV^(-7.64); for rotifers
  Calpha[1,*] = 0.272 * ALOG(lengthV) - 0.3834; for calanoids
  Calpha[2,*] = 0.4 / (1.0 + ((0.4 / 0.09) - 1.0) * EXP(-13.0 * 0.031 * lengthV))^(1.0 / 0.031) ; for cladocerans
  PL3 = WHERE((PL[3] / lengthV) LE 0.20, pl3count, complement = pl3c, ncomplement = pl3ccount)
  IF (pl3count GT 0.0) THEN Calpha[3,*] = ABS(0.50 - 1.75 * (PL[3,*] / lengthV)) $
  ELSE Calpha[3,*] = 0.00 ;for benthic prey for flounder by Rose et al. 1996 
  Length4 = WHERE(lengthV GT 60.0, L4count, complement = L4c, ncomplement = L4ccount)
  IF (L4count GT 0.0) THEN Calpha[4,*] = 0.001 $; for bythotrephes CHANGE!!! with Rainbow smelt from Barnhisel and Harvey
  ELSE Calpha[4,*] = 0.00
  PL5a = WHERE((PL[5] / lengthV) LT 0.20, pl5acount, complement = pl5ac, ncomplement = pl5account)
  IF (pl5acount GT 0.0) THEN Calpha[5,*] = 0.25 $ ; NEED A FUNCTION, 0.5 - 1.75 * length $
  ELSE Calpha[5,*] = 0.00 ; for fish
  ;PRINT, 'Calpha =', Calpha

; Calculate attack probability using chesson's alpha = capture efficiency
  TOT = FLTARR(nROG*20L); total number of all prey atacked and captured
  t = FLTARR(m, nROG*20L); total number of each prey atacked and captured
      t[0,*] = (Calpha[0,*] * dens[0,*])
      t[1,*] = (Calpha[1,*] * dens[1,*])
      t[2,*] = (Calpha[2,*] * dens[2,*])
      t[3,*] = (Calpha[3,*] * dens[3,*])
      t[4,*] = (Calpha[4,*] * dens[4,*])
      t[5,*] = (Calpha[5,*] * dens[5,*])
      ;PRINT, 't =', t
      TOT[*] = t[0,*] + t[1,*] + t[2,*] + t[3,*] + t[4,*] + t[5,*]
      TOT0 = WHERE(TOT[*] EQ 0.0, TOT0count, complement = TOTN0, ncomplement = TOTN0count)
      IF TOT0count GT 0.0 THEN TOT[TOT0] = TOT[TOT0] + 10.0^(-20.0)
      
; Calculate cumulative prey biomass for each vertical layer 
preyTOT = FLTARR(nROG*20L)      
jv = 19L
FOR ivvv = 0L, nROG*20L - 1L DO BEGIN
preyTOT[ivvv] = TOTAL(TOT[ivvv : jv])
ivvv = jv
jv = jv + 20L
ENDFOR
;PRINT, 'preyTOT =', preyTOT

; Copy cumulative prey biomass to all vertical cells (20)
preyTOT2 = FLTARR(nROG*20L)
j = 19L
FOR iii = 0L, nROG*20L - 19L DO BEGIN
FOR iiii = 0L, nROG*20L - 1L DO BEGIN
preyTOT2[iii : j] = preyTOT[iiii]
iii = j + 1L
j = j + 20L
iiii = iiii + 19L
ENDFOR
ENDFOR
;PRINT, 'preyTOT2 =', preyTOT2
;PRINT, 'tot =', TOT

TOTprop = FLTARR(nROG*20L)
EnvironV[10, *] = TOT / preyTOT2
TOTprop = TOT / preyTOT2
;PRINT, 'TOTprop =', EnvironV[10, *]
;PRINT, 'TOTprop =', TOTprop
EnvironV10 = EnvironV[10, *] * RANDOMU(seed, nROG*20L, /DOUBLE)

DOf1 = FLTARR(nROG*20L)
DOf2 = FLTARR(nROG*20L)
DOf3 = FLTARR(nROG*20L)
DOf = FLTARR(20L)
Tf1 = FLTARR(nROG*20L)
Tf2 = FLTARR(nROG*20L)
Tf3 = FLTARR(nROG*20L)
Tf = FLTARR(20L)
CTO = 24.6
CTM = 25.7
jvv = 19L
darray = INDGEN(20)

;DOf4 = WHERE(EnvironV[7, *] LT DOacclim[7, *], DOf1count)
;IF DOf1count GT 0.0 THEN DOf[DOf4] = 5.0
;print, DOf[DOf4]
;DOF2 = FLTARR(nYP*20L)
;Tf2 = FLTARR(nRAS*20L)
;  DOfa = WHERE(EnvironV[7, *] LT DOacclim[7, *], DOfacount)
;  IF DOfacount GT 0.0 THEN BEGIN
;  DOf2[DOfa] = 0.0
;  ENDIF  
;  DOfb = WHERE((EnvironV[7, *] GE DOacclim[7, *]) AND (EnvironV[7, *] LE DOacclim[5, *]), DOfbcount)
;  IF DOfbcount GT 0.0 THEN BEGIN
;  DOf2[DOfb] = ((EnvironV[7, *] - DOacclim[7, *])/(DOacclim[5, *] - DOacclim[7, *]));*RANDOMU(seed, nYP)
;  ENDIF
;  DOfc = WHERE(EnvironV[7, *] GT DOacclim[5, *], DOfccount)
;  IF DOfccount GT 0.0 THEN BEGIN
;  DOf2[DOfc] = 1.0
;  ENDIF
  
; Temperature
  Tfa = WHERE(EnvironV[6, *] GE CTM, Tfacount)
  IF Tfacount GT 0.0 THEN BEGIN
  Tf2[Tfa] = 0.0
  ENDIF
  Tfb = WHERE((EnvironV[6, *] GT CTO) AND (EnvironV[6, *] LT CTM), Tfbcount)
  IF Tfbcount GT 0.0 THEN BEGIN
  Tf2[Tfb] = ((CTM - EnvironV[6, Tfb])/(CTM - CTO))
  ENDIF
  Tfc = WHERE(EnvironV[6, *] LE CTO, Tfccount)
  IF Tfccount GT 0.0 THEN BEGIN
  Tf2[Tfc] = 1.0
  ENDIF
  print, tf2
  
FOR dovvv = 0L, nROG - 1L DO BEGIN
  FOR dov = 0L, nROG - 1L DO BEGIN
    FOR dovv = 0, 19L DO BEGIN
;PRINT, 'EnvironV[7, dovv]', EnvironV[7, dovv]
;PRINT, 'DOacclim[7, dov]', DOacclim[7, dov]
;PRINT, 'DOacclim[5, dov]', DOacclim[5, dov]
  DOf1[dovv] = WHERE(EnvironV[7, dovv] LT DOacclim[7, dov], DOf1count)
  ;DOf1[dovvv : jvv] = WHERE(EnvironV[7, dov] LT DOacclim[7, dov], DOf1count)
  IF DOf1count GT 0.0 THEN BEGIN
  DOf[dovv] = 0.0
  ;DOf[DOf1] = 0.0;*RANDOMU(seed, nYP)
  ENDIF  
  ;PRINT, 'DOf1count', DOf1count
  ;PRINT, 'DOf[dovv]', DOf[dovv]
  DOf2[dovv] = WHERE((EnvironV[7, dovv] GE DOacclim[7, dov]) AND (EnvironV[7, dovv] LE DOacclim[5, dov]), DOf2count)
  ;DOf2[dovvv : jvv] = WHERE(EnvironV[7, dov] GE DOacclim[7, dov] AND EnvironV[7, dov] LE DOacclim[5, dov], DOf2count)
  IF DOf2count GT 0.0 THEN BEGIN
  DOf[dovv] = ((EnvironV[7, dovv] - DOacclim[7, dov])/(DOacclim[5, dov] - DOacclim[7, dov]));*RANDOMU(seed, nYP)
  ;DOf[DOf2] = ((EnvironV[7, dov] - DOacclim[7, dov])/(DOacclim[5, dov] - DOacclim[7, dov]));*RANDOMU(seed, nYP)
  ENDIF
  ;PRINT, 'DOf2count', DOf2count
  ;PRINT, 'DOf[dovv]', DOf[dovv]
  DOf3[dovv] = WHERE(EnvironV[7, dovv] GT DOacclim[5, dov], DOf3count)
  ;DOf3[dovvv : jvv] = WHERE(EnvironV[7, dov] GT DOacclim[5, dov], DOf3count)
  IF DOf3count GT 0.0 THEN BEGIN
  DOf[dovv] = 1.0
  ;DOf[DOf3] = 1.0;*RANDOMU(seed, nYP)
  ENDIF
  
  Tf1[dovv] = WHERE(EnvironV[6, dovv] GE CTM, Tf1count)
  IF Tf1count GT 0.0 THEN BEGIN
  Tf[dovv] = 0.0
  ENDIF
  Tf2[dovv] = WHERE((EnvironV[6, dovv] GT CTO) AND (EnvironV[6, dovv] LT CTM), Tf2count)
  IF Tf2count GT 0.0 THEN BEGIN
  Tf[dovv] = ((CTM - EnvironV[6, dovv])/(CTM - CTO))
  ENDIF
  Tf3[dovv] = WHERE(EnvironV[6, dovv] LE CTO, Tf3count)
  IF Tf3count GT 0.0 THEN BEGIN
  Tf[dovv] = 1.0
  ENDIF
  ;PRINT, 'DOf3count', DOf3count
  ;PRINT, 'DOf[dovv]', DOf[dovv]
  ;PRINT, 'DOf', DOf
  ENDFOR 
    ;DOf4[7, dovvv : jvv] = DOf[*]
    ;NewGridID3D2[evvv : jv] = WHERE((evv[*] + 1 EQ Grid3D[2, *] AND NewGridID[ev] EQ Grid3D[3, 0L : *]), NewLoccount2)
    EnvironV[8, dovvv : jvv] = DOf[*]
    EnvironV[9, dovvv : jvv] = Tf[*]
    dovvv = jvv + 1L
    jvv = jvv + 20L
    ;PRINT, 'DOf', DOf
  ENDFOR
  ;PRINT, 'DOf', DOf
ENDFOR

;PRINT, 'Environv[8:9, *]', Environv[8:9, *]; DO-based habitat index 
EnvironV8 = DOUBLE(EnvironV[8, *] * RANDOMU(seed, nROG*20L, /DOUBLE))
;PRINT, 'Environv[8, *]', EnvironV[8, *]; DO-based habitat index with a random component
EnvironV9 = DOUBLE(EnvironV[9, *] * RANDOMU(seed, nROG*20L, /DOUBLE))
;PRINT, 'Environv[9, *]', EnvironV[9, *]; Temp-based habitat index with a random component
;PRINT, 'EnvironV', EnvironV[0:8, *]


EnvironVSum = FLTARR(6, nROG*20L)
EnvironVSum[0, *] = DOUBLE((EnvironV8 * EnvironV9 * EnvironV10)^(1.0/3.0))
EnvironVSum[1, *] = (EnvironV8 * EnvironV9 * EnvironV10)
EnvironVSum[2, *] = EnvironV8; DO index
EnvironVSum[3, *] = EnvironV9; TEMP index
EnvironVSum[4, *] = EnvironV10; prey index
EnvironVSum[5, *] = NewInput[10, NewGridID3D2]; ambient DO
;PRINT, 'EnvironVSum', EnvironVSum; Temp&DO-based habitat index with a random component

EnvironVMax = FLTARR(nROG*20L)
EnvironVMax2 = FLTARR(nROG*20L)
EnvironVMax3 = FLTARR(nROG*20L)
jvvv = 19L
; Create array with highest habitat quality-based probability for fish
FOR iv = 0L, nROG*20L - 1L DO BEGIN
EnvironVMax[iv] = WHERE(MAX(EnvironVSum[0, iv : jvvv]) EQ EnvironVSum[0, *])
;PRINT, 'EnvironVmax =', EnvironVMax[iv]
EnvironVMax2[iv] = EnvironV[1, EnvironVMax[iv]];
;PRINT, 'EnvironV4max2 =', EnvironV4Max2[iv]
EnvironVMax3[iv] = EnvironV[0, EnvironVMax[iv]];
;PRINT, 'EnvironV4max3 =', environV4max3[iv]
iv = jvvv
jvvv = jvvv + 20L
ENDFOR
;PRINT, 'EnvironVMax2 =', EnvironVMax2; Grid cell ID with max DO-based probablity 
;PRINT, 'EnvironVMax3 =', EnvironVMax3; depth cell with max DO-based probablity 

DepthLoc = FLTARR(nROG)
DepthLoc2 = FLTARR(nROG)
jvvvv = 19L
FOR iv = 0L, nROG*20L - 1L DO BEGIN
  FOR ivv = 0L, nROG - 1L DO BEGIN 
DepthLoc[ivv] = MAX(EnvironVMax3[iv : jvvvv])
;depthloc[iv] = depthloc[iv] 
;PRINT, 'depthloc[ivv] =', depthloc[ivv]
;iv = iv + 20L
iv = jvvvv; + 20L
jvvvv = jvvvv + 20L
  ENDFOR
;depthloc2[ivv] = depthloc[ivv]
ENDFOR
;PRINT, 'DepthLoc =', DepthLoc

;--------------------------------------------------------------------------------------------------
;PRINT, 'Vertical movement indicator =', movez
;PRINT, 'Total # of moving fish', TOTAL(moveZ)

;*****************************************************************************************************
;; For random movement only
;m = WHERE(moveZ EQ 0L, mcount, complement = mm, ncomplement = mmcount); m = cells with staying fish
;;PRINT, 'Staying fish =', m
;;PRINT, 'Moving fish =', mm
;
;; fish does not move in the z direction
;IF mcount GT 0L THEN BEGIN; m = cells with staying fish
;;NewLoc1 = FLTARR(mcount)
;;Ncell1 = FLTARR(15, mcount)
;FOR ivv = 0L, nYP - 1L DO BEGIN
;IF (movez[ivv] EQ 0L) THEN BEGIN
;  ;NewLoc[ivv] = WHERE((NewGridID[ivv] EQ Grid3D[3, *]) AND (YP[12, ivv] EQ Grid3D[2, *]), NewLoccount1); Random
;  NewLoc[ivv] = WHERE((NewGridID2[ivv] EQ Grid3D[3, *]) AND (DepthLoc[ivv] EQ Grid3D[2, *]), NewLoccount1); DO-based habitat index with a random component
;  Ncell[*, ivv] = newinput[0 : 14, NewLoc[ivv]];envir of previous cells
;;newinput[3, m] = NewGridID[m] 
;;newinput[2, m] = YP[12, m]
;ENDIF
;ENDFOR
;;PRINT, 'Z location =', YP[12, m]
;;PRINT, 'Z location =', d[m]
;NewCell[*, m] = Ncell[*, m]
;;PRINT, 'New cell location of staying fish =', NewCell[0:4, m]
;ENDIF

;; for each moving fish
;IF mmcount GT 0L THEN BEGIN; mm = cells with moving fish
;;  NewLoc = FLTARR(mmcount)
;;  Ncell = FLTARR(16, mmcount); mmcount = number of moving fish
;FOR iv = 0L, nYP - 1L DO BEGIN
;    ;nd = WHERE(buffer[2, *] EQ NewGridID[i], dcount)
;    ;PRINT, 'NewGridID', nd
;    ;PRINT, '# of vertical cells =', dcount ;number of vertical cells eq dcount = alwasys 20
;IF (movez[iv] EQ 1L) THEN BEGIN; fish moves in the z direction
;    Dcount = 20.0; number of vertical layers
;    ;randomly select a depth
;    d[iv] = ROUND(RANDOMU(seed) * (Dcount)) ;random # between the number of depth cells for each SI -> NEED to incoporate swimming speed-based movement
;    reass2 = WHERE(d EQ 0L, recount2); reassigns values of 0 to 1
;  IF (recount2 GT 0L) THEN d[reass2] = 1L
;  ;PRINT, 'depthloc =', depthloc
;    ;NewLoc[iv] = WHERE((NewGridID[iv] EQ Grid3D[3, *]) AND (d[iv] EQ Grid3D[2, *]), NewLoccount); 3D ID Loc -Random
;    NewLoc[iv] = WHERE((NewGridID2[iv] EQ Grid3D[3, *]) AND (DepthLoc[iv] EQ Grid3D[2, *]), NewLoccount); 3D ID Loc - vertical DO-based habitat index with a random component
;    ;PRINT, 'NewLoc =', NewLoc
;    Ncell[*, iv] = newinput[0 : 14, NewLoc[iv]]; new envir cells with 3D ID
;    ;PRINT, 'Ncell =', Ncell  
;ENDIF
;ENDFOR
;  ;PRINT, 'New Z location =', d[mm]
;  NewCell[*, mm] = Ncell[*, mm]; mm = cells with moving fish
;ENDIF

;************************************************************************************************************

; For habitat quality-based----------------------------------------------------------------------------------
FOR iv = 0L, nROG - 1L DO BEGIN
 NewLoc[iv] = WHERE((NewGridID2[iv] EQ Grid3D[3, *]) AND (DepthLoc[iv] EQ Grid3D[2, *]), NewLoccount); 3D ID Loc - vertical DO-based habitat index with a random component
    ;PRINT, 'NewLoc =', NewLoc
 Ncell[*, iv] = newinput[0 : 14, NewLoc[iv]]; new envir cells with 3D ID
ENDFOR
NewCell[*, *] = Ncell[*, *]
;------------------------------------------------------------------------------------------------------------

;PRINT, 'DepthLoc =', DepthLoc
;PRINT, 'New cell location of moving fish =', NewCell[*, mm]
PRINT, 'New cell location-all =', NewCell
;PRINT, 'WAE =', WAE
;PRINT, NewInput[9:11, *]

;---Begin Output to a file----------------------------------------------
;OPENW, ounit,'YPmoveOut.txt', /GET_LUN, width = 100L
;PRINT, ounit
;FOR iw = 0L, nYP - 1L DO PRINTF, ounit, NewCell[*, iw];, FORMAT = "(15F10.7)"; FORMAT = column# F #digits before dicimal point . #digits after dcimal point
;FREE_LUN, ounit
;---End Output to a file------------------------------------------------

;***Creat an output file*********************************************************
;;counter =  iday - 182L; Same as the initial day of a daily loop 
;;PRINT, 'Counter', counter
;;PRINT, 'DAY', day
;PRINT, nYP; rows
;counter = 0L
;pointer = nYP * counter; 1st line to read in 
;data = NewCell
;; Set up variables.
;   filename = 'IDLoutput.csv';****the files should be in the same directory as the "IDLWorksapce80" default folder.****
;   s = Size(data, /Dimensions)
;   xsize = s[0]
;   lineWidth = 1600
;   comma = ","
;IF counter EQ 0L THEN BEGIN; 
;; Open the data file for writing.
;   OpenU, lun, filename, /Get_Lun, Width=lineWidth
;ENDIF
;IF counter GT 0L THEN BEGIN; 
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

t_elapsed = systime(/seconds) -tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, ' ROG Vertical Movement Ends Here'
;PRINT, 'WAE CHIROS', WAE[18, 0:99]
;PRINT, 'carbon =', newinput[15, *]
RETURN, NewCell; => YP[10 : 24, *] 
END