FUNCTION WAEFishPreyArray1DMove, YP, EMS, RAS, ROG, WAE, nGridcell
; Creat a fish array for potential prey

PRINT, 'WAEFishPreyArray1DMove BEGINS HERE'
tstart = SYSTIME(/seconds)

FISHPREY = FLTARR(40L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL

; YELLOW PERCH
FOR ID = 0L, nGridcell-1L DO BEGIN
  YEPmultiSI = WHERE((WAE[14, *] EQ ID) AND (YP[14, *] EQ ID), YEPmultiSIcount); 
 
  IF YEPmultiSIcount GT 0 THEN BEGIN 
    YEPmultiSIprey = WHERE(YP[6, YEPmultiSI] LE 1., YEPmultiSIpreycount);

    IF YEPmultiSIpreycount GT 0 THEN BEGIN
;;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = multiSIpreycount
;      ;im = findgen(n)+1 ; input array
;      im = multiSI[multiSIprey]
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHCOMARRAY[0, multiSI[ID2]] = YP[0, PreyFishID]; ABUNDANCE
      FISHPREY[1, ID] = MEAN(YP[1, YEPmultiSI[YEPmultiSIprey]]); LENGTH
      FISHPREY[2, ID] = MEAN(YP[2, YEPmultiSI[YEPmultiSIprey]]); WEIGHT
;      FISHCOMARRAY[3, multiSI[ID2]] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(YEPmultiSI[YEPmultiSIprey]); NUMBER OF SIs
      FISHPREY[4, ID] = TOTAL(YP[0, YEPmultiSI[YEPmultiSIprey]]); ABUNDANCE
      FISHPREY[5, ID] = TOTAL(YP[2, YEPmultiSI[YEPmultiSIprey]] * YP[0, YEPmultiSI[YEPmultiSIprey]]); BIOMASS
    ENDIF 
  ENDIF  
ENDFOR


; EMERALD SHINER
FOR ID = 0L, nGridcell-1L DO BEGIN
  EMSmultiSI = WHERE((WAE[14, *] EQ ID) AND (EMS[14, *] EQ ID), EMSmultiSIcount); 
  
  IF EMSmultiSIcount GT 0 THEN BEGIN  
    EMSmultiSIprey = WHERE(EMS[6, EMSmultiSI] LE 1., EMSmultiSIpreycount);

    IF EMSmultiSIpreycount GT 0 THEN BEGIN
;;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = multiSIpreycount
;      ;im = findgen(n)+1 ; input array
;      im = multiSI[multiSIprey]
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHCOMARRAY[6, multiSI[ID2]] = EMS[0, PreyFishID]; ABUNDANCE
      FISHPREY[7, ID] = MEAN(EMS[1, EMSmultiSI[EMSmultiSIprey]]); LENGTH
      FISHPREY[8, ID] = MEAN(EMS[2, EMSmultiSI[EMSmultiSIprey]]); WEIGHT
;      FISHCOMARRAY[9, multiSI[ID2]] = EMS[2, PreyFishID] * EMS[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[1, ID] = n_elements(EMSmultiSI[EMSmultiSIprey]); NUMBER OF SIs
      FISHPREY[10, ID] = TOTAL(EMS[0, EMSmultiSI[EMSmultiSIprey]]); ABUNDANCE
      FISHPREY[11, ID] = TOTAL(EMS[2, EMSmultiSI[EMSmultiSIprey]] * EMS[0, EMSmultiSI[EMSmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF  
ENDFOR

; RAINBOW SMELT
FOR ID = 0L, nGridcell-1L DO BEGIN
  RASmultiSI = WHERE((WAE[14, *] EQ ID) AND (RAS[14, *] EQ ID), RASmultiSIcount); 
  
  IF RASmultiSIcount GT 0 THEN BEGIN 
    RASmultiSIprey = WHERE(RAS[6, RASmultiSI] LE 1., RASmultiSIpreycount);

    IF RASmultiSIpreycount GT 0 THEN BEGIN
;;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = multiSIpreycount
;      ;im = findgen(n)+1 ; input array
;      im = multiSI[multiSIprey]
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHCOMARRAY[12, multiSI[ID2]] = RAS[0, PreyFishID]; ABUNDANCE
      FISHPREY[13, ID] = MEAN(RAS[1, RASmultiSI[RASmultiSIprey]]); LENGTH
      FISHPREY[14, ID] = MEAN(RAS[2, RASmultiSI[RASmultiSIprey]]); WEIGHT
;      FISHCOMARRAY[15, multiSI[ID2]] = RAS[2, PreyFishID] * RAS[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[2, ID] = n_elements(RASmultiSI[RASmultiSIprey]); NUMBER OF SIs
      FISHPREY[16, ID] = TOTAL(RAS[0, RASmultiSI[RASmultiSIprey]]); ABUNDANCE
      FISHPREY[17, ID] = TOTAL(RAS[2, RASmultiSI[RASmultiSIprey]] * RAS[0, RASmultiSI[RASmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF  
ENDFOR


;; ROUND GOBY
;FOR ID = 0L, nGridcell-1L DO BEGIN
;  multiSI = WHERE(ROG[14, *] EQ ID, multiSIcount)
;  
;  IF multiSIcount GT 0 THEN BEGIN
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH 
;    IF WAE[1, ID] LT 200. THEN multiSIprey = WHERE(ROG[1, multiSI] LE 1., multiSIpreycount);
;    IF WAE[1, ID] GE 200. THEN multiSIprey = WHERE(ROG[1, multiSI] LE 1., multiSIpreycount);
;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;  ENDFOR
;    IF multiSIpreycount GT 0 THEN BEGIN
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = multiSIpreycount
;      ;im = findgen(n)+1 ; input array
;      im = multiSI[multiSIprey]
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHCOMARRAY[18, multiSI[ID2]] = ROG[0, PreyFishID]; ABUNDANCE
;      FISHCOMARRAY[19, ID] = MEAN(ROG[1, multiSI[multiSIprey]]); LENGTH
;      FISHCOMARRAY[20, ID] = MEAN(ROG[2, multiSI[multiSIprey]]); WEIGHT
;      FISHCOMARRAY[21, multiSI[ID2]] = ROG[2, PreyFishID] * ROG[0, PreyFishID]; BIOMASS
;      
;    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCellIDcount[3, ID] = n_elements(multiSI); NUMBER OF SIs
;      FISHCOMARRAY[22, ID] = TOTAL(ROG[0, multiSI]); ABUNDANCE
;      FISHCOMARRAY[23, ID] = TOTAL(ROG[2, multiSI] * ROG[0, multiSI]); BIOMASS
;    ENDIF
;  ENDIF  
;ENDFOR

; WALLEYE
FOR ID = 0L, nGridcell-1L DO BEGIN
  WAEmultiSI = WHERE((WAE[14, *] EQ ID) AND (WAE[0, *] GT 0.), WAEmultiSIcount)
  
  IF WAEmultiSIcount GT 0 THEN BEGIN
    WAEmultiSIprey = WHERE(WAE[6, WAEmultiSI] LE 1., WAEmultiSIpreycount);
   
    IF WAEmultiSIpreycount GT 0 THEN BEGIN
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = multiSIpreycount
;      ;im = findgen(n)+1 ; input array
;      im = multiSI[multiSIprey]
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHCOMARRAY[24, multiSI[ID2]] = WAE[0, PreyFishID]; ABUNDANCE
      FISHPREY[25, ID] = MEAN(WAE[1, WAEmultiSI[WAEmultiSIprey]]); LENGTH
      FISHPREY[26, ID] = MEAN(WAE[2, WAEmultiSI[WAEmultiSIprey]]); WEIGHT
;      FISHCOMARRAY[27, multiSI[ID2]] = WAE[2, PreyFishID] * WAE[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[4, ID] = n_elements(WAEmultiSI[WAEmultiSIprey]); NUMBER OF SIs
      FISHPREY[28, ID] = TOTAL(WAE[0, WAEmultiSI[WAEmultiSIprey]]); ABUNDANCE
      FISHPREY[29, ID] = TOTAL(WAE[2, WAEmultiSI[WAEmultiSIprey]] * WAE[0, WAEmultiSI[WAEmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF  
ENDFOR

; NUMBER OF SUPERINDIVIDUALS
FISHPREY[30, *] = FISHCellIDcount[0, *];  the number of superindividuals
FISHPREY[31, *] = FISHCellIDcount[1, *];  the number of superindividuals
FISHPREY[32, *] = FISHCellIDcount[2, *];  the number of superindividuals
;FISHCOMARRAY[19, *] = FISHCellIDcount[3, *];  the number of superindividuals
FISHPREY[33, *] = FISHCellIDcount[4, *];  the number of superindividuals

FISHPREY[35, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
FISHPREY[36, *] = FISHPREY[0, *] + FISHPREY[6, *] + FISHPREY[12, *] + FISHPREY[18, *] + FISHPREY[24, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
FISHPREY[37, *] = FISHPREY[3, *] + FISHPREY[9, *] + FISHPREY[16, *] + FISHPREY[21, *] + FISHPREY[26, *]; TOTAL BIOMASS IN A CELL


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'WAEFishPreyArray1DMove ENDS HERE'
RETURN, FISHPREY
END