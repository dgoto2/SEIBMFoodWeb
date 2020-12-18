FUNCTION YEPFishArray1D, YP, EMS, RAS, ROG, WAE, nYP, nGridcell
; Creat a fish array for potential inter-/intra- specific competitions

PRINT, 'YEPFishArray1D BEGINS HERE'
tstart = SYSTIME(/seconds)

FISHCOMARRAY = FLTARR(40L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL
; YELLOW PERCH
FOR ID = 0L, nGridcell-1L DO BEGIN
  YEPmultiSI = WHERE((YP[14, *] EQ ID), YEPmultiSIcount); 
    
  IF YEPmultiSIcount GT 0. THEN BEGIN
;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
      m = 1
      n = YEPmultiSIcount
      ;im = findgen(n)+1 ; input array
      im = YEPmultiSI
      IF n GT 0 THEN arr = RANDOMU(seed, n)
      ind = SORT(arr)
      PreyFishID = im[ind[0:m-1]]
;      ;print, ind[0:m-1]
;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      FISHCOMARRAY[0, ID] = YP[0, PreyFishID]; ABUNDANCE
      FISHCOMARRAY[1, ID] = YP[1, PreyFishID]; LENGTH
      FISHCOMARRAY[2, ID] = YP[2, PreyFishID]; WEIGHT
      FISHCOMARRAY[3, ID] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(YEPmultiSI); NUMBER OF SIs
      FISHCOMARRAY[4, ID] = TOTAL(YP[0, YEPmultiSI]); ABUNDANCE
      FISHCOMARRAY[5, ID] = TOTAL(YP[2, YEPmultiSI] * YP[0, YEPmultiSI]); BIOMASS
  ENDIF 
ENDFOR

; EMERALD SHINER
FOR ID = 0L, nGridcell-1L DO BEGIN
  EMSmultiSI = WHERE((YP[14, *] EQ ID) AND (EMS[14, *] EQ ID), EMSmultiSIcount);     
  IF EMSmultiSIcount GT 0. THEN BEGIN
      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
      m = 1
      n = EMSmultiSIcount
      im = EMSmultiSI; input array
      IF n GT 0 THEN arr = RANDOMU(seed, n)
      ind = SORT(arr)
      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      FISHCOMARRAY[6, ID] = EMS[0, PreyFishID]; ABUNDANCE
      FISHCOMARRAY[7, ID] = EMS[1, PreyFishID]; LENGTH
      FISHCOMARRAY[8, ID] = EMS[2, PreyFishID]; WEIGHT
      FISHCOMARRAY[9, ID] = EMS[2, PreyFishID] * EMS[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[1, ID] = n_elements(EMSmultiSI); NUMBER OF SIs
      FISHCOMARRAY[10, ID] = TOTAL(EMS[0, EMSmultiSI]); ABUNDANCE
      FISHCOMARRAY[11, ID] = TOTAL(EMS[2, EMSmultiSI] * EMS[0, EMSmultiSI]); BIOMASS
  ENDIF
ENDFOR


; RAINBOW SMELT
FOR ID = 0L, nGridcell-1L DO BEGIN
  RASmultiSI = WHERE((YP[14, *] EQ ID) AND (RAS[14, *] EQ ID), RASmultiSIcount); 
  IF RASmultiSIcount GT 0. THEN BEGIN
      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
      m = 1
      n = RASmultiSIcount
      ;im = findgen(n)+1 ; input array
      im = RASmultiSI
      IF n GT 0 THEN arr = RANDOMU(seed, n)
      ind = SORT(arr)
      PreyFishID = im[ind[0:m-1]]
      ;print, ind[0:m-1]
      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
      FISHCOMARRAY[12, ID] = RAS[0, PreyFishID]; ABUNDANCE
      FISHCOMARRAY[13, ID] = RAS[1, PreyFishID]; LENGTH
      FISHCOMARRAY[14, ID] = RAS[2, PreyFishID]; WEIGHT
      FISHCOMARRAY[15, ID] = RAS[2, PreyFishID] * RAS[0, PreyFishID]; BIOMASS
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[2, RASmultiSI] = n_elements(RASmultiSI); NUMBER OF SIs
      FISHCOMARRAY[16, RASmultiSI] = TOTAL(RAS[0, RASmultiSI]); ABUNDANCE
      FISHCOMARRAY[17, RASmultiSI] = TOTAL(RAS[2, RASmultiSI] * RAS[0, RASmultiSI]); BIOMASS
  ENDIF
ENDFOR


;; ROUND GOBY
;FOR ID = 0L, nGridcell-1L DO BEGIN
;  multiSI = WHERE(ROG[14, *] EQ ID, multiSIcount)
; 
;  IF multiSIcount GT 0 THEN BEGIN  
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH 
;    multiSIprey = WHERE(ROG[1, multiSI] GT 0., multiSIpreycount);
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
;      FISHCOMARRAY[18, multiSI[ID2]] = ROG[0, PreyFishID]; ABUNDANCE
;      FISHCOMARRAY[19, multiSI[ID2]] = ROG[1, PreyFishID]; LENGTH
;      FISHCOMARRAY[20, multiSI[ID2]] = ROG[2, PreyFishID]; WEIGHT
;      FISHCOMARRAY[21, multiSI[ID2]] = ROG[2, PreyFishID] * ROG[0, PreyFishID]; BIOMASS
;      
;    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCellIDcount[3, multiSI[ID2]] = n_elements(multiSI[multiSIprey]); NUMBER OF SIs
;      FISHCOMARRAY[22, multiSI[ID2]] = TOTAL(ROG[0, multiSI[multiSIprey]]); ABUNDANCE
;      FISHCOMARRAY[23, multiSI[ID2]] = TOTAL(ROG[2, multiSI[multiSIprey]] * ROG[0, multiSI[multiSIprey]]); BIOMASS
;    ENDIF
;  ENDFOR
;  ENDIF
;ENDFOR

; WALLEYE
FOR ID = 0L, nGridcell-1L DO BEGIN
  WAEmultiSI = WHERE((YP[14, *] EQ ID) AND (WAE[14, *] EQ ID), WAEmultiSIcount); 
  IF WAEmultiSIcount GT 0. THEN BEGIN
    ; RANDOMLY CHOOSE 1 SI FOR FORAGING
    m = 1
    n = WAEmultiSIcount
    ;im = findgen(n)+1 ; input array
    im = WAEmultiSI
    IF n GT 0 THEN arr = RANDOMU(seed, n)
    ind = SORT(arr)
    PreyFishID = im[ind[0:m-1]]
    ;print, ind[0:m-1]
    ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
    FISHCOMARRAY[24,ID] = WAE[0, PreyFishID]; ABUNDANCE
    FISHCOMARRAY[25, ID] = WAE[1, PreyFishID]; LENGTH
    FISHCOMARRAY[26, ID] = WAE[2, PreyFishID]; WEIGHT
    FISHCOMARRAY[27, ID] = WAE[2, PreyFishID] * WAE[0, PreyFishID]; BIOMASS
    
  ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
    FISHCellIDcount[4, ID] = n_elements(WAEmultiSI); NUMBER OF SIs
    FISHCOMARRAY[28, ID] = TOTAL(WAE[0, WAEmultiSI]); ABUNDANCE
    FISHCOMARRAY[29, ID] = TOTAL(WAE[2, WAEmultiSI] * WAE[0, WAEmultiSI]); BIOMASS
  ENDIF
ENDFOR


; NUMBER OF SUPERINDIVIDUALS
FISHCOMARRAY[30, *] = FISHCellIDcount[0, *];  the number of superindividuals
FISHCOMARRAY[31, *] = FISHCellIDcount[1, *];  the number of superindividuals
FISHCOMARRAY[32, *] = FISHCellIDcount[2, *];  the number of superindividuals
;FISHCOMARRAY[19, *] = FISHCellIDcount[3, *];  the number of superindividuals
FISHCOMARRAY[33, *] = FISHCellIDcount[4, *];  the number of superindividuals

FISHCOMARRAY[35, *] = TOTAL(FISHCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
FISHCOMARRAY[36, *] = FISHCOMARRAY[0, *] + FISHCOMARRAY[6, *] + FISHCOMARRAY[12, *] + FISHCOMARRAY[18, *] + FISHCOMARRAY[24, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
FISHCOMARRAY[37, *] = FISHCOMARRAY[3, *] + FISHCOMARRAY[9, *] + FISHCOMARRAY[16, *] + FISHCOMARRAY[21, *] + FISHCOMARRAY[26, *]; TOTAL BIOMASS IN A CELL


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'YEPFishArray1D ENDS HERE'
RETURN, FISHCOMARRAY
END