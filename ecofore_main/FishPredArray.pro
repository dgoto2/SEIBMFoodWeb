FUNCTION FishPredArray, YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell
;
;***********TEST ONLY****************************************************************************************
;PRO FishArray
;ihour = 15L; 
;Grid3D = GridCells3D()
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell) 
;BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;Grid2D = GridCells2D(); FORAGE PARAMETER
;NewInput = EcoForeInputfiles()
;NewInput = NewInput[*, 77500L * ihour : 77500L * ihour + 77499L]
;TotBenBio = TotBenBio + NewInput[8, *]
;
;nYP = 100000L
;nEMS = 100000L;
;nRAS = 100000L;
;nROG = 100000L;
;nWAE = 100000L;
;NpopYP = 50000000L
;NpopEMS = 50000000L
;NpopRAS = 50000000L
;NpopROG = 50000000L
;NpopWAE = 50000000L
;YP = YEPinitial(NpopYP, nYP, TotBenBio, NewInput); FISHARRY PARAMETER
;EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, NewInput); FISHARRY PARAMETER
;RAS = RASinitial(NpopRAS, nRAS, TotBenBio, NewInput); FISHARRY PARAMETER
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput); FISHARRY PARAMETER
;WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, NewInput); FISHARRY PARAMETER
;******************************************************************************************************************************

PRINT, 'FISHPRED BEGINS HERE'
tstart = SYSTIME(/seconds)

; Creat a fish prey array for potential predators 
nGridcell = 77500L
FISHPRED = FLTARR(28L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)
FISHPRED[0, YP[14, *]] = YP[0, *]; ABUNDANCE
FISHPRED[5, EMS[14, *]] = EMS[0, *]; ABUNDANCE
FISHPRED[10, RAS[14, *]] = RAS[0, *]; ABUNDANCE
FISHPRED[15, ROG[14, *]] = ROG[0, *]; ABUNDANCE
FISHPRED[20, WAE[14, *]] = WAE[0, *]; ABUNDANCE

;PRINT, 'YP[14, *]', YP[14, *]

; NUMBER OF SUPERINDIVIDUALS, LENGTH, AND WEIGHT
FOR ID = 0L, nYP-1L DO BEGIN
;PRINT, 'YP[14, ID]', YP[14, ID]
  FISHCellIDcount[0, YP[14, ID]] = FISHCellIDcount[0, YP[14, ID]] + (YP[0, ID] GT 0.); NUMBER OF SIs
  IF FISHPRED[1, YP[14, ID]] EQ 0. THEN BEGIN; WHEN THE CELL IS EMPTY...
    FISHPRED[1, YP[14, ID]] = YP[1, ID]; LENGTH
    FISHPRED[2, YP[14, ID]] = YP[2, ID]; WEIGHT
  ENDIF
  IF FISHPRED[1, YP[14, ID]] GT 0. THEN BEGIN; WHEN OTHER SIs ARE ALREADY IN THE CELL...
    IF (FISHPRED[1, YP[14, ID]] GT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS LARGER...
      FISHPRED[1, YP[14, ID]] = FISHPRED[1, YP[14, ID]]
      FISHPRED[2, YP[14, ID]] = FISHPRED[2, YP[14, ID]]
    ENDIF
    IF (FISHPRED[1, YP[14, ID]] LT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS SMALLER...
      FISHPRED[1, YP[14, ID]] = YP[1, ID]
      FISHPRED[2, YP[14, ID]] = YP[2, ID]  
    ENDIF
  ENDIF
ENDFOR
FOR ID = 0L, nEMS-1L DO BEGIN
  FISHCellIDcount[1, EMS[14, ID]] = FISHCellIDcount[1, EMS[14, ID]] + (EMS[0, ID] GT 0.) 
  IF FISHPRED[6, EMS[14, ID]] EQ 0. THEN BEGIN 
    FISHPRED[6, EMS[14, ID]] = EMS[1, ID];
    FISHPRED[7, EMS[14, ID]] = EMS[2, ID];
  ENDIF
  IF FISHPRED[6, EMS[14, ID]] GT 0. THEN BEGIN
    IF (FISHPRED[1, EMS[14, ID]] GT EMS[1, ID]) THEN BEGIN
      FISHPRED[6, EMS[14, ID]] = FISHPRED[6, EMS[14, ID]]
      FISHPRED[7, EMS[14, ID]] = FISHPRED[7, EMS[14, ID]]
   ENDIF
    IF (FISHPRED[6, EMS[14, ID]] LT EMS[1, ID]) THEN BEGIN
      FISHPRED[6, EMS[14, ID]] = EMS[1, ID]
      FISHPRED[7, EMS[14, ID]] = EMS[2, ID]  
    ENDIF
  ENDIF
ENDFOR
FOR ID = 0L, nRAS-1L DO BEGIN
  FISHCellIDcount[2, RAS[14, ID]] = FISHCellIDcount[2, RAS[14, ID]] + (RAS[0, ID] GT 0.) 
  IF FISHPRED[11, RAS[14, ID]] EQ 0. THEN BEGIN 
    FISHPRED[11, RAS[14, ID]] = RAS[1, ID];
    FISHPRED[12, RAS[14, ID]] = RAS[2, ID];
  ENDIF
  IF FISHPRED[11, RAS[14, ID]] GT 0. THEN BEGIN
    IF (FISHPRED[11, RAS[14, ID]] GT RAS[1, ID]) THEN BEGIN
      FISHPRED[11, RAS[14, ID]] = FISHPRED[11, RAS[14, ID]]
      FISHPRED[12, RAS[14, ID]] = FISHPRED[12, RAS[14, ID]]  
    ENDIF
    IF (FISHPRED[11, RAS[14, ID]] LT RAS[1, ID]) THEN BEGIN
      FISHPRED[11, RAS[14, ID]] = RAS[1, ID]
      FISHPRED[12, RAS[14, ID]] = RAS[2, ID]
    ENDIF
  ENDIF
ENDFOR
FOR ID = 0L, nROG-1L DO BEGIN
  FISHCellIDcount[3, ROG[14, ID]] = FISHCellIDcount[3, ROG[14, ID]] + (ROG[0, ID] GT 0.) 
  IF FISHPRED[16, ROG[14, ID]] EQ 0. THEN BEGIN 
    FISHPRED[16, ROG[14, ID]] = ROG[1, ID];
    FISHPRED[17, ROG[14, ID]] = ROG[2, ID];
  ENDIF
  IF FISHPRED[16, ROG[14, ID]] GT 0. THEN BEGIN
    IF (FISHPRED[16, ROG[14, ID]] GT ROG[1, ID]) THEN BEGIN
      FISHPRED[16, ROG[14, ID]] = FISHPRED[16, ROG[14, ID]]
      FISHPRED[17, ROG[14, ID]] = FISHPRED[17, ROG[14, ID]]
    ENDIF
    IF (FISHPRED[16, ROG[14, ID]] LT ROG[1, ID]) THEN BEGIN
      FISHPRED[16, ROG[14, ID]] = ROG[1, ID]
      FISHPRED[17, ROG[14, ID]] = ROG[2, ID]
    ENDIF   
  ENDIF
ENDFOR
FOR ID = 0L, nWAE-1L DO BEGIN
  FISHCellIDcount[4, WAE[14, ID]] = FISHCellIDcount[4, WAE[14, ID]] + (WAE[0, ID] GT 0.) 
  IF FISHPRED[21, WAE[14, ID]] EQ 0. THEN BEGIN 
    FISHPRED[21, WAE[14, ID]] = WAE[1, ID];
    FISHPRED[22, WAE[14, ID]] = WAE[2, ID];
  ENDIF
  IF FISHPRED[21, WAE[14, ID]] GT 0. THEN BEGIN
    IF (FISHPRED[21, WAE[14, ID]] GT WAE[1, ID]) THEN BEGIN
      FISHPRED[21, WAE[14, ID]] = FISHPRED[21, WAE[14, ID]]
      FISHPRED[22, WAE[14, ID]] = FISHPRED[22, WAE[14, ID]]
    ENDIF
    IF (FISHPRED[21, WAE[14, ID]] LT WAE[1, ID]) THEN BEGIN
      FISHPRED[21, WAE[14, ID]] = WAE[1, ID]
      FISHPRED[22, WAE[14, ID]] = WAE[2, ID]
    ENDIF   
  ENDIF
ENDFOR

; TOTAL ABUNDANCE AND BIOMASS
FISHPRED[0, YP[14, *]] = FISHPRED[0, YP[14, *]] * FISHCellIDcount[0, YP[14, *]]; TOTAL ABUNDANCE
FISHPRED[3, YP[14, *]] = YP[2, *] * FISHPRED[0, YP[14, *]]; TOTAL BIOMASS
FISHPRED[5, EMS[14, *]] = FISHPRED[5, EMS[14, *]] * FISHCellIDcount[1, EMS[14, *]]; 
FISHPRED[8, EMS[14, *]] = EMS[2, *]*FISHPRED[5, EMS[14, *]]; 
FISHPRED[10, RAS[14, *]] = FISHPRED[10, RAS[14, *]] * FISHCellIDcount[2, RAS[14, *]]; 
FISHPRED[13, RAS[14, *]] = RAS[2, *]*FISHPRED[10, RAS[14, *]]; 
FISHPRED[15, ROG[14, *]] = FISHPRED[15, ROG[14, *]] * FISHCellIDcount[3, ROG[14, *]]; 
FISHPRED[18, ROG[14, *]] = ROG[2, *] * FISHPRED[15, ROG[14, *]]; 
FISHPRED[20, WAE[14, *]] = FISHPRED[20, WAE[14, *]] * FISHCellIDcount[4, WAE[14, *]]; 
FISHPRED[23, WAE[14, *]] = WAE[2, *] * FISHPRED[20, WAE[14, *]];

; NUMBER OF SUPERINDIVIDUALS
FISHPRED[4, YP[14, *]] = FISHCellIDcount[0, YP[14, *]];  the number of superindividuals
FISHPRED[9, EMS[14, *]] = FISHCellIDcount[1, EMS[14, *]];  the number of superindividuals
FISHPRED[14, RAS[14, *]] = FISHCellIDcount[2, RAS[14, *]];  the number of superindividuals
FISHPRED[19, ROG[14, *]] = FISHCellIDcount[3, ROG[14, *]];  the number of superindividuals
FISHPRED[24, WAE[14, *]] = FISHCellIDcount[4, WAE[14, *]];  the number of superindividuals

FISHPRED[25, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
FISHPRED[26, *] = FISHPRED[0, *] + FISHPRED[5, *] + FISHPRED[10, *] + FISHPRED[15, *] + FISHPRED[20, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
FISHPRED[27, *] = FISHPRED[3, *] + FISHPRED[8, *] + FISHPRED[13, *] + FISHPRED[18, *] + FISHPRED[23, *]; TOTAL BIOMASS IN A CELL

;***********STILL NEED TO HANDLE LENGTH AND WEIGHT FOR DIFFERENT SUPERINDIVIDUALS IN THE SAME CELL*********************
;YEPMultiSI = WHERE(FISH3DCellIDcount[0, YP[14, *]] GT 1., YEPMultiSIcount,complement = YEPOneSI, ncomplement = YEPOneSIcount)
;FISHPREY2[1, YP[14, *]] = YP[1, *]

;PRINT, MAX(TRANSPOSE(FISHPRED[4, *]))
;YEPSI = WHERE(FISHPRED[4, WAE[14, *]] GT 0., YEPSICOUNT)
;IF YEPSICOUNT GT 0. THEN YEPLENGTH SORT(YP[14, *]); SORT PROVIDES ORDERED SUBSCRIPTS FOR ALL ELEMENTS IN AN ARRAY.
; FOR ID = 0L, nWAE DO BEGIN 
; YEPSIloc = WHERE(WAE[14, ID] EQ YP[14, *], YEPPREYSICOUNT)
; IF YEPPREYSICOUNT GT 0. THEN WAEprey[ID] = YP[14, YEPSIloc]

;PRINT, FISHPRED
;PRINT, FISH3DCellIDcount;[*, *] = 0.

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'FISHPRED ENDS HERE'
RETURN, FISHPRED
END