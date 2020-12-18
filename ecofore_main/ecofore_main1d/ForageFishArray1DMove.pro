FUNCTION ForageFishArray1DMove, YP, EMS, RAS, ROG, WAE, nGridcell
; Creat a fish array for potential COMPETITORS

PRINT, 'FishCompArray1DMove BEGINS HERE'
tstart = SYSTIME(/seconds)

FISHCOMARRAY = FLTARR(40L, nGridcell)
FISHCellIDcount = FLTARR(5L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL
; YELLOW PERCH
FOR ID = 0L, nGridcell-1L DO BEGIN
  YEPmultiSI = WHERE(YP[14, *] EQ ID, YEPmultiSIcount)

  IF YEPmultiSIcount GT 0 THEN BEGIN
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin;
;    multiSIprey = WHERE(YP[1, multiSI] GE (EMS[1, multiSI[ID2]]), multiSIpreycount)
;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;    
;    IF multiSIpreycount GT 0 THEN BEGIN
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
      FISHCOMARRAY[1, ID] = MEAN(YP[1, YEPmultiSI]); LENGTH
      FISHCOMARRAY[2, ID] = MEAN(YP[2, YEPmultiSI]); WEIGHT
;      FISHCOMARRAY[3, multiSI[ID2]] = YP[2, PreyFishID] * YP[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(YEPmultiSI); NUMBER OF SIs
      FISHCOMARRAY[4, ID] = TOTAL(YP[0, YEPmultiSI]); ABUNDANCE
      FISHCOMARRAY[5, ID] = TOTAL(YP[2, YEPmultiSI] * YP[0, YEPmultiSI]); BIOMASS
  ENDIF
ENDFOR

; EMERALD SHINER
FOR ID = 0L, nGridcell-1L DO BEGIN
  EMSmultiSI = WHERE(EMS[14, *] EQ ID, EMSmultiSIcount)
  
  IF EMSmultiSIcount GT 0 THEN BEGIN  
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH
;    multiSIprey = WHERE(EMS[1, multiSI] GE (0.2*YP[1, multiSI[ID2]]), multiSIpreycount);
;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;    
;    IF multiSIpreycount GT 0 THEN BEGIN
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
      FISHCOMARRAY[7, ID] = MEAN(EMS[1, EMSmultiSI]); LENGTH
      FISHCOMARRAY[8, ID] = MEAN(EMS[2, EMSmultiSI]); WEIGHT
;      FISHCOMARRAY[9, multiSI[ID2]] = EMS[2, PreyFishID] * EMS[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[1, ID] = n_elements(EMSmultiSI); NUMBER OF SIs
      FISHCOMARRAY[10, ID] = TOTAL(EMS[0, EMSmultiSI]); ABUNDANCE
      FISHCOMARRAY[11, ID] = TOTAL(EMS[2, EMSmultiSI] * EMS[0, EMSmultiSI]); BIOMASS
  ENDIF
ENDFOR

; RAINBOW SMELT
FOR ID = 0L, nGridcell-1L DO BEGIN
  RASmultiSI = WHERE(RAS[14, *] EQ ID, RASmultiSIcount)
  
  IF RASmultiSIcount GT 0 THEN BEGIN  
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH
;    multiSIprey = WHERE(RAS[1, multiSI] GE (0.2*YP[1, multiSI[ID2]]), multiSIpreycount);
;    ;IF multiSIprey2count gt 0 THEN print, multiSI[multiSIprey2]
;    
;    IF multiSIpreycount GT 0 THEN BEGIN
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
      FISHCOMARRAY[13, ID] = MEAN(RAS[1, RASmultiSI]); LENGTH
      FISHCOMARRAY[14, ID] = MEAN(RAS[2, RASmultiSI]); WEIGHT
;      FISHCOMARRAY[15, multiSI[ID2]] = RAS[2, PreyFishID] * RAS[0, PreyFishID]; BIOMASS
;      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[2, ID] = n_elements(RASmultiSI); NUMBER OF SIs
      FISHCOMARRAY[16, ID] = TOTAL(RAS[0, RASmultiSI]); ABUNDANCE
      FISHCOMARRAY[17, ID] = TOTAL(RAS[2, RASmultiSI] * RAS[0, RASmultiSI]); BIOMASS
  ENDIF
ENDFOR

;; ROUND GOBY
;FOR ID = 0L, nGridcell-1L DO BEGIN
;  multiSI = WHERE(ROG[14, *] EQ ID, multiSIcount)
;  
; IF multiSIcount GT 0 THEN BEGIN
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH 
;    multiSIprey = WHERE(ROG[1, multiSI] GE (0.2*YP[1, multiSI[ID2]]), multiSIpreycount);
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
;      FISHCellIDcount[3, ID] = n_elements(multiSI); NUMBER OF SIs
;      FISHCOMARRAY[22, ID] = TOTAL(ROG[0, multiSI]); ABUNDANCE
;      FISHCOMARRAY[23, ID] = TOTAL(ROG[2, multiSI] * ROG[0, multiSI]); BIOMASS
;    ENDIF
;  ENDFOR
; ENDIF 
;ENDFOR

; walleye
FOR ID = 0L, nGridcell-1L DO BEGIN
  WAEmultiSI = WHERE(WAE[14, *] EQ ID, WAEmultiSIcount)
  
  IF WAEmultiSIcount GT 0 THEN BEGIN  
;  FOR ID2 = 0L, N_ELEMENTS(multiSI)-1L do begin; LIMIT PREY FISH
;    multiSIprey = WHERE(WAE[1, multiSI] GE (0.2*YP[1, multiSI[ID2]]), multiSIpreycount);
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
;      FISHCOMARRAY[24, multiSI[ID2]] = WAE[0, PreyFishID]; ABUNDANCE
      FISHCOMARRAY[25, ID] = MEAN(WAE[1, WAEmultiSI]); LENGTH
      FISHCOMARRAY[26, ID] = MEAN(WAE[2, WAEmultiSI]); WEIGHT
;      FISHCOMARRAY[27, multiSI[ID2]] = WAE[2, PreyFishID] * WAE[0, PreyFishID]; BIOMASS
;      
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
PRINT, 'FishCompArray1DMove ENDS HERE'
RETURN, FISHCOMARRAY
END