FUNCTION WAEFishPredArray1DMove, YP, WAE, nGridcell
; Create a fish array for potential predators

PRINT, 'WAEFishPredArray1DMove BEGINS HERE'
tstart = SYSTIME(/seconds)

FishPred = FLTARR(10L, nGridcell)
FISHCellIDcount = FLTARR(2L, nGridcell)

; NUMBER OF SUPERINDIVIDUALS, LENGTH, WEIGHT, TOTAL ABUNDANCE AND BIOMASS IN EACH CELL

;; YELLOW PERCH
;FOR ID = 0L, nGridcell-1L DO BEGIN
;  YEPmultiSI = WHERE((WAE[14, *] EQ ID) AND (YP[14, *] EQ ID), YEPmultiSIcount); 
; 
;  IF YEPmultiSIcount GT 0 THEN BEGIN 
;    YEPmultiSIpred = WHERE(YP[1, YEPmultiSI] GE 150., YEPmultiSIpredcount);
;
;    IF YEPmultiSIpredcount GT 0 THEN BEGIN
;;;      ; RANDOMLY CHOOSE 1 SI FOR FORAGING
;;      m = 1
;;      n = multiSIpreycount
;;      ;im = findgen(n)+1 ; input array
;;      im = multiSI[multiSIprey]
;;      IF n GT 0 THEN arr = RANDOMU(seed, n)
;;      ind = SORT(arr)
;;      PreyFishID = im[ind[0:m-1]]
;;      ;print, ind[0:m-1]
;;      ;print, im[ind[0:m-1]] ; m random elements from im -> randomly selected SI's length
;;      FISHCOMARRAY[0, multiSI[ID2]] = YP[0, PreyFishID]; ABUNDANCE
;      FishPred[0, ID] = MEAN(YP[1, YEPmultiSI[YEPmultiSIpred]]); LENGTH
;      FishPred[1, ID] = MEAN(YP[2, YEPmultiSI[YEPmultiSIpred]]); WEIGHT
;      
;    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
;      FISHCellIDcount[0, ID] = n_elements(YEPmultiSI[YEPmultiSIpred]); NUMBER OF SIs
;      FishPred[3, ID] = TOTAL(YP[0, YEPmultiSI[YEPmultiSIpred]]); ABUNDANCE
;      FishPred[4, ID] = TOTAL(YP[2, YEPmultiSI[YEPmultiSIpred]] * YP[0, YEPmultiSI[YEPmultiSIpred]]); BIOMASS
;    ENDIF 
;  ENDIF  
;ENDFOR


; Walleye
FOR ID = 0L, nGridcell-1L DO BEGIN
  WAEmultiSI = WHERE((WAE[14, *] EQ ID), WAEmultiSIcount); 
 
  IF WAEmultiSIcount GT 0 THEN BEGIN 
    WAEmultiSIpred = WHERE(WAE[1, WAEmultiSI] GE 43., WAEmultiSIpredcount);

    IF WAEmultiSIpredcount GT 0 THEN BEGIN
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
      FishPred[5, ID] = MEAN(WAE[1, WAEmultiSI[WAEmultiSIpred]]); LENGTH
      FishPred[6, ID] = MEAN(WAE[2, WAEmultiSI[WAEmultiSIpred]]); WEIGHT
      
    ; DETERMINE TOTAL PREY FISH ABUNDANCE AND BIOMASS IN EACH CELL
      FISHCellIDcount[0, ID] = n_elements(WAEmultiSI[WAEmultiSIpred]); NUMBER OF SIs
      FishPred[7, ID] = TOTAL(WAE[0, WAEmultiSI[WAEmultiSIpred]]); ABUNDANCE
      FishPred[8, ID] = TOTAL(WAE[2, WAEmultiSI[WAEmultiSIpred]] * WAE[0, WAEmultiSI[WAEmultiSIpred]]); BIOMASS
    ENDIF 
  ENDIF  
ENDFOR


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'WAEFishPredArray1DMove ENDS HERE'
RETURN, FishPred
END