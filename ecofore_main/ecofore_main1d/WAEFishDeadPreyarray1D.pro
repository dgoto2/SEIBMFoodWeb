FUNCTION WAEFishDeadPreyArray1D, WAEenc, WAE, nWAE, nGridcell
; Creat a fish prey array eaten by walleye

PRINT, 'WAEFishDeadPreyArray1D BEGINS HERE'
tstart = SYSTIME(/seconds)

;PRINT, nGridcell
FISHPREY = FLTARR(40L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL

; YELLOW PERCH
FOR ID = 0L, nGridcell-1L DO BEGIN
 WAEmultiSI = WHERE((WAE[14, *] EQ ID), WAEmultiSIcount); 
; PRINT, 'WAEmultiSI'
; PRINT, WAEmultiSI
  IF WAEmultiSIcount GT 0. THEN BEGIN
    YEPmultiSIprey = WHERE(WAEenc[49, WAEmultiSI] GT 0., YEPmultiSIpreycount);
;    PRINT, 'WAEmultiSI[YEPmultiSIprey]'
;    PRINT, WAEmultiSI[YEPmultiSIprey]
          
    IF YEPmultiSIpreycount GT 0 THEN BEGIN
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = YEPmultiSIpreycount
;      im = YEPmultiSI[YEPmultiSIprey]; input array
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      ;FISHPREY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
      ;FISHPREY[1, ID] = YP[1, PreyFishID]; LENGTH
      ;FISHPREY[2, ID] = YP[2, PreyFishID]; WEIGHT
      ;FISHPREY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(WAEmultiSI[YEPmultiSIprey]); NUMBER OF SIs
      FISHPREY[4, ID] = ROUND(TOTAL(WAEenc[49, WAEmultiSI[YEPmultiSIprey]])/n_elements(WAEmultiSI[YEPmultiSIprey])); ABUNDANCE
      ;FISHPREY[5, ID] = TOTAL(YP[2, YEPmultiSI[YEPmultiSIprey]] * YP[0, YEPmultiSI[YEPmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF
ENDFOR
;PRINT, 'yellow perch'
;PRINT, (FISHPREY[4, *])

; EMERALD SHINER
FOR ID = 0L, nGridcell-1L DO BEGIN
    WAEmultiSI = WHERE((WAE[14, *] EQ ID), WAEultiSIcount); 
    IF WAEmultiSIcount GT 0. THEN BEGIN
      EMSmultiSIprey = WHERE(WAEenc[50, WAEmultiSI] GT 0., EMSmultiSIpreycount);
      
      IF EMSmultiSIpreycount GT 0 THEN BEGIN
;        ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;        m = 1
;        n = EMSmultiSIpreycount
;        ;im = findgen(n)+1 ; input array
;        im = EMSmultiSI[EMSmultiSIprey]
;        IF n GT 0 THEN arr = RANDOMU(seed, n)
;        ind = SORT(arr)
;        PreyFishID = im[ind[0:m-1]]
;        ;print, ind[0:m-1]
;        ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;        FISHPREY[6, ID] = EMS[0, PreyFishID]; ABUNDANCE
;        FISHPREY[7, ID] = EMS[1, PreyFishID]; LENGTH
;        FISHPREY[8, ID] = EMS[2, PreyFishID]; WEIGHT
;        FISHPREY[9, ID] = EMS[2, PreyFishID] * EMS[0, PreyFishID]; BIOMASS
        
      ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
        FISHCellIDcount[1, ID] = n_elements(WAEmultiSI[EMSmultiSIprey]); NUMBER OF SIs
        FISHPREY[10, ID] = ROUND(TOTAL(WAEenc[50, WAEmultiSI[EMSmultiSIprey]])/n_elements(WAEmultiSI[EMSmultiSIprey])); ABUNDANCE
        ;FISHPREY[11, ID] = TOTAL(EMS[2, EMSmultiSI[EMSmultiSIprey]] * EMS[0, EMSmultiSI[EMSmultiSIprey]]); BIOMASS
      ENDIF
  ENDIF
ENDFOR
;PRINT, 'emerald shiner'
;PRINT, (FISHPREY[10, *])

; RAINBOW SMELT
FOR ID = 0L, nGridcell-1L DO BEGIN
  WAEmultiSI = WHERE((WAE[14, *] EQ ID), WAEmultiSIcount); 
  
  IF WAEmultiSIcount GT 0. THEN BEGIN
    RASmultiSIprey = WHERE(WAEenc[51, WAEmultiSI] GT 0., RASmultiSIpreycount);
  
    IF RASmultiSIpreycount GT 0 THEN BEGIN
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;      m = 1
;      n = RASmultiSIpreycount
;      ;im = findgen(n)+1 
;      im = RASmultiSI[RASmultiSIprey]; input array
;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;      ind = SORT(arr)
;      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;      FISHPREY[12, ID] = RAS[0, PreyFishID]; ABUNDANCE
;      FISHPREY[13, ID] = RAS[1, PreyFishID]; LENGTH
;      FISHPREY[14, ID] = RAS[2, PreyFishID]; WEIGHT
;      FISHPREY[15, ID] = RAS[2, PreyFishID] * RAS[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[2, ID] = n_elements(WAEmultiSI[RASmultiSIprey]); NUMBER OF SIs
      FISHPREY[16, ID] = ROUND(TOTAL(WAEenc[51, WAEmultiSI[RASmultiSIprey]])/n_elements(WAEmultiSI[RASmultiSIprey])); ABUNDANCE
      ;FISHPREY[17, ID] = TOTAL(RAS[2, RASmultiSI[RASmultiSIprey]] * RAS[0, RASmultiSI[RASmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF
ENDFOR
;PRINT, 'rainbow smelt'
;PRINT, (FISHPREY[16, *])

;; ROUND GOBY
;FOR ID = 0L, nGridcell-1L DO BEGIN
;  multiSI = WHERE(ROG[14, *] EQ ID, multiSIcount)
;  
;  IF multiSIcount GT 0 THEN BEGIN  
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH BY GAPE SIZE
;    IF WAE[1, multiSI[ID2]] LT 200. THEN multiSIprey = WHERE(ROG[1, multiSI] LT (0.6*WAE[1, multiSI[ID2]]), multiSIpreycount);
;    IF WAE[1, multiSI[ID2]] GE 200. THEN multiSIprey = WHERE(ROG[1, multiSI] LT (0.4*WAE[1, multiSI[ID2]]), multiSIpreycount);

;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;    
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
;      FISHPREY[18, multiSI[ID2]] = ROG[0, PreyFishID]; ABUNDANCE
;      FISHPREY[19, multiSI[ID2]] = ROG[1, PreyFishID]; LENGTH
;      FISHPREY[20, multiSI[ID2]] = ROG[2, PreyFishID]; WEIGHT
;      FISHPREY[21, multiSI[ID2]] = ROG[2, PreyFishID] * ROG[0, PreyFishID]; BIOMASS
;      
;    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCellIDcount[3, multiSI[ID2]] = n_elements(multiSI[multiSIprey]); NUMBER OF SIs
;      FISHPREY[22, multiSI[ID2]] = TOTAL(ROG[0, multiSI[multiSIprey]]); ABUNDANCE
;      FISHPREY[23, multiSI[ID2]] = TOTAL(ROG[2, multiSI[multiSIprey]] * ROG[0, multiSI[multiSIprey]]); BIOMASS
;    ENDIF
;  ENDFOR
;  ENDIF
;ENDFOR

; WALLEYE
FOR ID = 0L, nGridcell-1L DO BEGIN
    WAEmultiSI = WHERE((WAE[14, *] EQ ID), WAEmultiSIcount); 

    IF WAEmultiSIcount GT 0. THEN BEGIN
      WAEmultiSIprey = WHERE((WAEenc[53, WAEmultiSI] GT 0.), WAEmultiSIpreycount);
    
      IF WAEmultiSIpreycount GT 0 THEN BEGIN
;        ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;        m = 1
;        n = WAEmultiSIpreycount
;        ;im = findgen(n)+1 ; input array
;        im = WAEmultiSI[WAEmultiSIprey]
;        IF n GT 0 THEN arr = RANDOMU(seed, n)
;        ind = SORT(arr)
;        PreyFishID = im[ind[0:m-1]]
;        ;print, ind[0:m-1]
;        ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;        FISHPREY[24, ID] = WAE[0, PreyFishID]; ABUNDANCE
;        FISHPREY[25, ID] = WAE[1, PreyFishID]; LENGTH
;        FISHPREY[26, ID] = WAE[2, PreyFishID]; WEIGHT
;        FISHPREY[27, ID] = WAE[2, PreyFishID] * WAE[0, PreyFishID]; BIOMASS
        
      ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
        FISHCellIDcount[4, ID] = n_elements(WAEmultiSI[WAEmultiSIprey]); NUMBER OF SIs
        FISHPREY[28, ID] = ROUND(TOTAL(WAEenc[53, WAEmultiSI[WAEmultiSIprey]])/n_elements(WAEmultiSI[WAEmultiSIprey])); ABUNDANCE
        ;FISHPREY[29, ID] = TOTAL(WAE[2, WAEmultiSI[WAEmultiSIprey]] * WAE[0, WAEmultiSI[WAEmultiSIprey]]); BIOMASS
      ENDIF
  ENDIF
ENDFOR
;PRINT, 'walleye'
;PRINT, (FISHPREY[28, *])

; NUMBER OF SUPERINDIVIDUALS
;FISHPREY[30, *] = FISHCellIDcount[0, *];  the number of superindividuals
;FISHPREY[31, *] = FISHCellIDcount[1, *];  the number of superindividuals
;FISHPREY[32, *] = FISHCellIDcount[2, *];  the number of superindividuals
;;FISHPREY[19, *] = FISHCellIDcount[3, *];  the number of superindividuals
;FISHPREY[33, *] = FISHCellIDcount[4, *];  the number of superindividuals
;;PRINT, 'YEP SI'
;;PRINT, TRANSPOSE(FISHPREY[4, YP[14, *]])
;
;FISHPREY[35, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
;FISHPREY[36, *] = FISHPREY[0, *] + FISHPREY[6, *] + FISHPREY[12, *] + FISHPREY[18, *] + FISHPREY[24, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
;FISHPREY[37, *] = FISHPREY[3, *] + FISHPREY[9, *] + FISHPREY[16, *] + FISHPREY[21, *] + FISHPREY[26, *]; TOTAL BIOMASS IN A CELL


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'WAEFishDeadPreyArray1D ENDS HERE'
RETURN, FISHPREY
END