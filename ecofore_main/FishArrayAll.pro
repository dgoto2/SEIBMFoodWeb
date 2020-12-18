FUNCTION FishArrayAll, YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell
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

PRINT, 'FISHPREY BEGINS HERE'
tstart = SYSTIME(/seconds)

; Creat a fish prey array for potential predators 
nGridcell = 77500L
FISHALL = FLTARR(28L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)
;FISHALL[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;FISHALL[5, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;FISHALL[10, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;FISHALL[15, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;FISHALL[20, WAE[14, *]] = WAE[0, *]; ABUNDANCE

;PRINT, 'YP[14, *]', YP[14, *]

; NUMBER OF SUPERINDIVIDUALS, TOTAL ABUNDANCE, AND BIOMASS IN EACH CELL
; YELLOW PERCH
FOR ID = 0L, nYP-1L DO BEGIN
;PRINT, 'YP[14, ID]', YP[14, ID]
  FISHCellIDcount[0, YP[14, ID]] = FISHCellIDcount[0, YP[14, ID]] + (YP[0, ID] GT 0.); NUMBER OF SIs
  FISHALL[0, YP[14, ID]] = FISHALL[0, YP[14, ID]] + YP[0, ID]; ABUNDANCE
  FISHALL[3, YP[14, ID]] = FISHALL[3, YP[14, ID]] + YP[2, ID] * FISHALL[0, YP[14, ID]]; BIOMASS

  MultiSI=where(YP[14, ID] EQ YP[14, *], MultiSIcount, complement=SingleSI, ncomplement=SingleSIcount)
  ;fishprey2=where(YP[1, ID] gt YP[14, MultiSI], fishprey2count, complement=nonfishprey2, ncomplement=nonfishprey2count)  
  IF MultiSIcount GT 1. THEN BEGIN
    ;print, MultiSI
  ;  if fishprey2count gt 0. then begin
      FISHALL[1, YP[14, ID]] = MIN(YP[1, MultiSI]); LENGTH
      FISHALL[2, YP[14, ID]] = MIN(YP[2, MultiSI]); WEIGHT
      ;PRINT, TRANSPOSE(YP[14, MultiSI])
      ;PRINT, TRANSPOSE(YP[1, MultiSI]); fish length
      ;PRINT, TRANSPOSE(YP[2, MultiSI]); fish weight
   ; endif
  ENDIF
;  IF FISHALL[1, YP[14, ID]] EQ 0. THEN BEGIN; WHEN THE CELL IS EMPTY...
;    FISHALL[1, YP[14, ID]] = YP[1, ID]; LENGTH
;    FISHALL[2, YP[14, ID]] = YP[2, ID]; WEIGHT
;  ENDIF
;  IF FISHALL[1, YP[14, ID]] GT 0. THEN BEGIN; WHEN OTHER SIs ARE ALREADY IN THE CELL...
;    IF (FISHALL[1, YP[14, ID]] GT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS LARGER...
;      FISHALL[1, YP[14, ID]] = YP[1, ID]
;      FISHALL[2, YP[14, ID]] = YP[2, ID]
;    ENDIF
;    IF (FISHALL[1, YP[14, ID]] LT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS SMALLER...
;      FISHALL[1, YP[14, ID]] = FISHALL[1, YP[14, ID]]
;      FISHALL[2, YP[14, ID]] = FISHALL[2, YP[14, ID]]   
;    ENDIF
;  ENDIF
ENDFOR
;fisharray=fltarr(2,77500L)
;for ncell=0L,77499L do begin
; fishprey=where(ncell eq YP[14, *], fishpreycount, complement=nonfishprey, ncomplement=nonfishpreycount)
;  ;fishprey2=where(YP[1, ID] gt YP[14, fishprey], fishprey2count, complement=nonfishprey2, ncomplement=nonfishprey2count)  
;  if fishpreycount gt 1. then begin
;    ;print, fishprey
;  ;  if fishprey2count gt 0. then begin
;      print, fishprey
;      print, transpose(fisharray[0, yp[14, fishprey]]); fish length
;      print, transpose(fisharray[1, yp[14, fishprey]]); fish weight
;   ; endif
;  endif
;endfor

; EMERALD SHINER
FOR ID = 0L, nEMS-1L DO BEGIN
  FISHCellIDcount[1, EMS[14, ID]] = FISHCellIDcount[1, EMS[14, ID]] + (EMS[0, ID] GT 0.) 
  FISHALL[5, EMS[14, ID]] = FISHALL[5, EMS[14, ID]] + EMS[0, ID]; ABUNDANCE
  FISHALL[8, EMS[14, ID]] = FISHALL[8, EMS[14, ID]] + EMS[2, ID] * FISHALL[5, EMS[14, ID]]; BIOMASS 
;  IF FISHALL[6, EMS[14, ID]] EQ 0. THEN BEGIN 
;    FISHALL[6, EMS[14, ID]] = EMS[1, ID];
;    FISHALL[7, EMS[14, ID]] = EMS[2, ID];
;  ENDIF
  
;  IF FISHALL[6, EMS[14, ID]] GT 0. THEN BEGIN
;    IF (FISHALL[1, EMS[14, ID]] GT EMS[1, ID]) THEN BEGIN
;      FISHALL[6, EMS[14, ID]] = EMS[1, ID]
;      FISHALL[7, EMS[14, ID]] = EMS[2, ID]
;   ENDIF
;    IF (FISHALL[6, EMS[14, ID]] LT EMS[1, ID]) THEN BEGIN
;      FISHALL[6, EMS[14, ID]] = FISHALL[6, EMS[14, ID]]
;      FISHALL[7, EMS[14, ID]] = FISHALL[7, EMS[14, ID]]   
;    ENDIF
;  ENDIF
ENDFOR
; RAINBOW SMELT
FOR ID = 0L, nRAS-1L DO BEGIN
  FISHCellIDcount[2, RAS[14, ID]] = FISHCellIDcount[2, RAS[14, ID]] + (RAS[0, ID] GT 0.)
  FISHALL[10, RAS[14, ID]] = FISHALL[10, RAS[14, ID]] + RAS[0, ID]; ABUNDANCE
  FISHALL[13, RAS[14, ID]] = FISHALL[13, RAS[14, ID]] + RAS[2, ID] * FISHALL[10, RAS[14, ID]]; BIOMASS
;  IF FISHALL[11, RAS[14, ID]] EQ 0. THEN BEGIN 
;    FISHALL[11, RAS[14, ID]] = RAS[1, ID];
;    FISHALL[12, RAS[14, ID]] = RAS[2, ID];
;  ENDIF
  
;  IF FISHALL[11, RAS[14, ID]] GT 0. THEN BEGIN
;    IF (FISHALL[11, RAS[14, ID]] GT RAS[1, ID]) THEN BEGIN
;      FISHALL[11, RAS[14, ID]] = RAS[1, ID]
;      FISHALL[12, RAS[14, ID]] = RAS[2, ID]
;    ENDIF
;    IF (FISHALL[11, RAS[14, ID]] LT RAS[1, ID]) THEN BEGIN
;      FISHALL[11, RAS[14, ID]] = FISHALL[11, RAS[14, ID]]
;      FISHALL[12, RAS[14, ID]] = FISHALL[12, RAS[14, ID]]   
;    ENDIF
;  ENDIF
ENDFOR
; ROUND GOBY
FOR ID = 0L, nROG-1L DO BEGIN
  FISHCellIDcount[3, ROG[14, ID]] = FISHCellIDcount[3, ROG[14, ID]] + (ROG[0, ID] GT 0.)
  FISHALL[15, ROG[14, ID]] = FISHALL[15, ROG[14, ID]] + ROG[0, ID]; ABUNDANCE
  FISHALL[18, ROG[14, ID]] = FISHALL[18, ROG[14, ID]] + ROG[2, ID] * FISHALL[15, ROG[14, ID]]; BIOMASS
;  IF FISHALL[16, ROG[14, ID]] EQ 0. THEN BEGIN 
;    FISHALL[16, ROG[14, ID]] = ROG[1, ID];
;    FISHALL[17, ROG[14, ID]] = ROG[2, ID];
;  ENDIF

;  IF FISHALL[16, ROG[14, ID]] GT 0. THEN BEGIN
;    IF (FISHALL[16, ROG[14, ID]] GT ROG[1, ID]) THEN BEGIN
;      FISHALL[16, ROG[14, ID]] = ROG[1, ID]
;      FISHALL[17, ROG[14, ID]] = ROG[2, ID]
;    ENDIF
;    IF (FISHALL[16, ROG[14, ID]] LT ROG[1, ID]) THEN BEGIN
;      FISHALL[16, ROG[14, ID]] = FISHALL[16, ROG[14, ID]]
;      FISHALL[17, ROG[14, ID]] = FISHALL[17, ROG[14, ID]]
;    ENDIF   
;  ENDIF
ENDFOR
; WALLEYE
FOR ID = 0L, nWAE-1L DO BEGIN
  FISHCellIDcount[4, WAE[14, ID]] = FISHCellIDcount[4, WAE[14, ID]] + (WAE[0, ID] GT 0.)
  FISHALL[20, WAE[14, ID]] = FISHALL[20, WAE[14, ID]] + WAE[0, ID]; ABUNDANCE
  FISHALL[23, WAE[14, ID]] = FISHALL[23, WAE[14, ID]] + WAE[2, ID] * FISHALL[20, WAE[14, ID]]; BIOMASS 
;  IF FISHALL[21, WAE[14, ID]] EQ 0. THEN BEGIN 
;    FISHALL[21, WAE[14, ID]] = WAE[1, ID];
;    FISHALL[22, WAE[14, ID]] = WAE[2, ID];
;  ENDIF

;  IF FISHALL[21, WAE[14, ID]] GT 0. THEN BEGIN
;    IF (FISHALL[21, WAE[14, ID]] GT WAE[1, ID]) THEN BEGIN
;      FISHALL[21, WAE[14, ID]] = WAE[1, ID]
;      FISHALL[22, WAE[14, ID]] = WAE[2, ID]
;    ENDIF
;    IF (FISHALL[21, WAE[14, ID]] LT WAE[1, ID]) THEN BEGIN
;      FISHALL[21, WAE[14, ID]] = FISHALL[21, WAE[14, ID]]
;      FISHALL[22, WAE[14, ID]] = FISHALL[22, WAE[14, ID]]
;    ENDIF   
;  ENDIF
ENDFOR

; TOTAL ABUNDANCE AND BIOMASS
;FISHALL[0, YP[14, *]] = FISHALL[0, YP[14, *]] * FISHCellIDcount[0, YP[14, *]]; TOTAL ABUNDANCE
;FISHALL[3, YP[14, *]] = YP[2, *] * FISHALL[0, YP[14, *]]; TOTAL BIOMASS
;FISHALL[5, EMS[14, *]] = FISHALL[5, EMS[14, *]] * FISHCellIDcount[1, EMS[14, *]]; 
;FISHALL[8, EMS[14, *]] = EMS[2, *]*FISHALL[5, EMS[14, *]]; 
;FISHALL[10, RAS[14, *]] = FISHALL[10, RAS[14, *]] * FISHCellIDcount[2, RAS[14, *]]; 
;FISHALL[13, RAS[14, *]] = RAS[2, *]*FISHALL[10, RAS[14, *]]; 
;FISHALL[15, ROG[14, *]] = FISHALL[15, ROG[14, *]] * FISHCellIDcount[3, ROG[14, *]]; 
;FISHALL[18, ROG[14, *]] = ROG[2, *] * FISHALL[15, ROG[14, *]]; 
;FISHALL[20, WAE[14, *]] = FISHALL[20, WAE[14, *]] * FISHCellIDcount[4, WAE[14, *]]; 
;FISHALL[23, WAE[14, *]] = WAE[2, *] * FISHALL[20, WAE[14, *]];

; NUMBER OF SUPERINDIVIDUALS
FISHALL[4, YP[14, *]] = FISHCellIDcount[0, YP[14, *]];  the number of superindividuals
FISHALL[9, EMS[14, *]] = FISHCellIDcount[1, EMS[14, *]];  the number of superindividuals
FISHALL[14, RAS[14, *]] = FISHCellIDcount[2, RAS[14, *]];  the number of superindividuals
FISHALL[19, ROG[14, *]] = FISHCellIDcount[3, ROG[14, *]];  the number of superindividuals
FISHALL[24, WAE[14, *]] = FISHCellIDcount[4, WAE[14, *]];  the number of superindividuals

FISHALL[25, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
FISHALL[26, *] = FISHALL[0, *] + FISHALL[5, *] + FISHALL[10, *] + FISHALL[15, *] + FISHALL[20, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
FISHALL[27, *] = FISHALL[3, *] + FISHALL[8, *] + FISHALL[13, *] + FISHALL[18, *] + FISHALL[23, *]; TOTAL BIOMASS IN A CELL

;***********STILL NEED TO HANDLE LENGTH AND WEIGHT FOR DIFFERENT SUPERINDIVIDUALS IN THE SAME CELL*********************
;YEPMultiSI = WHERE(FISH3DCellIDcount[0, YP[14, *]] GT 1., YEPMultiSIcount,complement = YEPOneSI, ncomplement = YEPOneSIcount)
;FISHPREY2[1, YP[14, *]] = YP[1, *]

;PRINT, MAX(TRANSPOSE(FISHALL[4, *]))
;YEPSI = WHERE(FISHALL[4, WAE[14, *]] GT 0., YEPSICOUNT)
;IF YEPSICOUNT GT 0. THEN YEPLENGTH SORT(YP[14, *]); SORT PROVIDES ORDERED SUBSCRIPTS FOR ALL ELEMENTS IN AN ARRAY.
; FOR ID = 0L, nWAE DO BEGIN 
; YEPSIloc = WHERE(WAE[14, ID] EQ YP[14, *], YEPPREYSICOUNT)
; IF YEPPREYSICOUNT GT 0. THEN WAEprey[ID] = YP[14, YEPSIloc]

PRINT, FISHALL
;PRINT, FISH3DCellIDcount;[*, *] = 0.

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'FISHALL ENDS HERE'
RETURN, FISHALL
END