FUNCTION WAEFishPreyArray1D, YP, EMS, RAS, ROG, WAE, nWAE, nGridcell
; Creat a fish prey array for potential predators 

PRINT, 'WAEFishPreyArray1D BEGINS HERE'
tstart = SYSTIME(/seconds)

FISHPREY = FLTARR(45L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL

; YELLOW PERCH
FOR ID = 0L, nGridcell-1L DO BEGIN
  YEPmultiSI = WHERE((WAE[14, *] EQ ID) AND (YP[14, *] EQ ID), YEPmultiSIcount); 
;  PRINT, 'YEPmultiSI'
;  PRINT, YEPmultiSI
    
  IF YEPmultiSIcount GT 0. THEN BEGIN
    YEPmultiSIprey = WHERE(YP[6, YEPmultiSI] LE 1., YEPmultiSIpreycount);
;    PRINT, 'YEPmultiSI[YEPmultiSIprey]'
;    PRINT, YEPmultiSI[YEPmultiSIprey]
          
    IF YEPmultiSIpreycount GT 0 THEN BEGIN
      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
      m = 1
      n = YEPmultiSIpreycount
      im = YEPmultiSI[YEPmultiSIprey]; input array
      IF n GT 0 THEN arr = RANDOMU(seed, n)
      ind = SORT(arr)
      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      FISHPREY[38, ID] = PreyFishID; prey fish SI ID 
      FISHPREY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
      FISHPREY[1, ID] = YP[1, PreyFishID]; LENGTH
      FISHPREY[2, ID] = YP[2, PreyFishID]; WEIGHT
      FISHPREY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(YEPmultiSI[YEPmultiSIprey]); NUMBER OF SIs
      FISHPREY[4, ID] = TOTAL(YP[0, YEPmultiSI[YEPmultiSIprey]]); ABUNDANCE
      FISHPREY[5, ID] = TOTAL(YP[2, YEPmultiSI[YEPmultiSIprey]] * YP[0, YEPmultiSI[YEPmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF
ENDFOR
PRINT, 'yellow perch'
PRINT, (FISHPREY[0:5, *])

; EMERALD SHINER
FOR ID = 0L, nGridcell-1L DO BEGIN
    EMSmultiSI = WHERE((WAE[14, *] EQ ID) AND (EMS[14, *] EQ ID), EMSmultiSIcount); 
;    PRINT, 'EMSmultiSI'
;    PRINT, EMSmultiSI

    IF EMSmultiSIcount GT 0. THEN BEGIN
    EMSmultiSIprey = WHERE(EMS[6, EMSmultiSI] LE 1., EMSmultiSIpreycount);
;    PRINT, 'EMSmultiSI[EMSmultiSIprey]'
;    PRINT, EMSmultiSI[EMSmultiSIprey]
      
      IF EMSmultiSIpreycount GT 0 THEN BEGIN
        ; RANDOMLY CHOOSE 1 SI FOR FORAGING
        m = 1
        n = EMSmultiSIpreycount
        ;im = findgen(n)+1 ; input array
        im = EMSmultiSI[EMSmultiSIprey]
        IF n GT 0 THEN arr = RANDOMU(seed, n)
        ind = SORT(arr)
        PreyFishID = im[ind[0:m-1]]
        ;print, ind[0:m-1]
        ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
        FISHPREY[39, ID] = PreyFishID; prey fish SI ID 
        FISHPREY[6, ID] = EMS[0, PreyFishID]; ABUNDANCE
        FISHPREY[7, ID] = EMS[1, PreyFishID]; LENGTH
        FISHPREY[8, ID] = EMS[2, PreyFishID]; WEIGHT
        FISHPREY[9, ID] = EMS[2, PreyFishID] * EMS[0, PreyFishID]; BIOMASS
        
      ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
        FISHCellIDcount[1, ID] = n_elements(EMSmultiSI[EMSmultiSIprey]); NUMBER OF SIs
        FISHPREY[10, ID] = TOTAL(EMS[0, EMSmultiSI[EMSmultiSIprey]]); ABUNDANCE
        FISHPREY[11, ID] = TOTAL(EMS[2, EMSmultiSI[EMSmultiSIprey]] * EMS[0, EMSmultiSI[EMSmultiSIprey]]); BIOMASS
      ENDIF
  ENDIF
ENDFOR
PRINT, 'emerald shiner'
PRINT, (FISHPREY[6:9, *])

; RAINBOW SMELT
FOR ID = 0L, nGridcell-1L DO BEGIN
  RASmultiSI = WHERE((WAE[14, *] EQ ID) AND (RAS[14, *] EQ ID), RASmultiSIcount); 
  
  IF RASmultiSIcount GT 0. THEN BEGIN
    RASmultiSIprey = WHERE(RAS[6, RASmultiSI] LE 1., RASmultiSIpreycount);
  
    IF RASmultiSIpreycount GT 0 THEN BEGIN
      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
      m = 1
      n = RASmultiSIpreycount
      ;im = findgen(n)+1 
      im = RASmultiSI[RASmultiSIprey]; input array
      IF n GT 0 THEN arr = RANDOMU(seed, n)
      ind = SORT(arr)
      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      FISHPREY[40, ID] = PreyFishID; prey fish SI ID 
      FISHPREY[12, ID] = RAS[0, PreyFishID]; ABUNDANCE
      FISHPREY[13, ID] = RAS[1, PreyFishID]; LENGTH
      FISHPREY[14, ID] = RAS[2, PreyFishID]; WEIGHT
      FISHPREY[15, ID] = RAS[2, PreyFishID] * RAS[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[2, ID] = n_elements(RASmultiSI[RASmultiSIprey]); NUMBER OF SIs
      FISHPREY[16, ID] = TOTAL(RAS[0, RASmultiSI[RASmultiSIprey]]); ABUNDANCE
      FISHPREY[17, ID] = TOTAL(RAS[2, RASmultiSI[RASmultiSIprey]] * RAS[0, RASmultiSI[RASmultiSIprey]]); BIOMASS
    ENDIF
  ENDIF
ENDFOR
PRINT, 'rainbow smelt'
PRINT, (FISHPREY[12:15, *])

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
;            FISHPREY[41, ID] = PreyFishID; prey fish SI ID 
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
    WAEmultiSIprey = WHERE(WAE[6, WAEmultiSI] LE 1., WAEmultiSIpreycount);
    
      IF WAEmultiSIpreycount GT 0 THEN BEGIN
        ; RANDOMLY CHOOSE 1 SI FOR FORAGING
        m = 1
        n = WAEmultiSIpreycount
        ;im = findgen(n)+1 ; input array
        im = WAEmultiSI[WAEmultiSIprey]
        IF n GT 0 THEN arr = RANDOMU(seed, n)
        ind = SORT(arr)
        PreyFishID = im[ind[0:m-1]]
        ;print, ind[0:m-1]
        ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
        FISHPREY[42, ID] = PreyFishID; prey fish SI ID 
        FISHPREY[24, ID] = WAE[0, PreyFishID]; ABUNDANCE
        FISHPREY[25, ID] = WAE[1, PreyFishID]; LENGTH
        FISHPREY[26, ID] = WAE[2, PreyFishID]; WEIGHT
        FISHPREY[27, ID] = WAE[2, PreyFishID] * WAE[0, PreyFishID]; BIOMASS
        
      ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
        FISHCellIDcount[4, ID] = n_elements(WAEmultiSI[WAEmultiSIprey]); NUMBER OF SIs
        FISHPREY[28, ID] = TOTAL(WAE[0, WAEmultiSI[WAEmultiSIprey]]); ABUNDANCE
        FISHPREY[29, ID] = TOTAL(WAE[2, WAEmultiSI[WAEmultiSIprey]] * WAE[0, WAEmultiSI[WAEmultiSIprey]]); BIOMASS
      ENDIF
  ENDIF
ENDFOR
PRINT, 'walleye'
PRINT, (FISHPREY[24:27, *])

; NUMBER OF SUPERINDIVIDUALS
FISHPREY[30, *] = FISHCellIDcount[0, *];  the number of superindividuals
FISHPREY[31, *] = FISHCellIDcount[1, *];  the number of superindividuals
FISHPREY[32, *] = FISHCellIDcount[2, *];  the number of superindividuals
;FISHPREY[19, *] = FISHCellIDcount[3, *];  the number of superindividuals
FISHPREY[33, *] = FISHCellIDcount[4, *];  the number of superindividuals
;PRINT, 'YEP SI'
;PRINT, TRANSPOSE(FISHPREY[4, YP[14, *]])

FISHPREY[35, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
FISHPREY[36, *] = FISHPREY[0, *] + FISHPREY[6, *] + FISHPREY[12, *] + FISHPREY[18, *] + FISHPREY[24, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
FISHPREY[37, *] = FISHPREY[3, *] + FISHPREY[9, *] + FISHPREY[16, *] + FISHPREY[21, *] + FISHPREY[26, *]; TOTAL BIOMASS IN A CELL


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'WAEFishPreyArray1D ENDS HERE'
RETURN, FISHPREY
END