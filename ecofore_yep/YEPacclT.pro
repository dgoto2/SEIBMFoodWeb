FUNCTION YEPacclT, TacclC, TacclR, Tamb, ts, length, nYP
;this function determines the acclimation temperature for yellow perch

PRINT, 'YEPacclT Begins Here'

; Parameter values
ToptC = FLTARR(nYP)
ToptR = FLTARR(nYP)

; For larval and juvenile yellow perch from the Wisconsin Bioenergetics Model manual
TL = WHERE(length LT 100.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ToptC[TL] = 29.0;  CTO 
  ToptR[TL] = 32.0;  RTO 
ENDIF

; For values are for adult yellow perch
IF (TLLcount GT 0.0) THEN BEGIN 
  ToptC[TLL] = 23.0; CTO 
  ToptR[TLL] = 28.0; RTO 
ENDIF
Tacclmax = 33.0; for yellow perch, Eaton et al. 1995. Fisheries. 20 (4)


; Calculate the acclimation rate (based on bluegill by Hagar, 1978) for consumption
rateC = FLTARR(nYP)
TambLC = WHERE(Tamb LT TacclC, TambLCcount, complement = TambLCL, ncomplement = TambLCLcount)
IF (TambLCcount GT 0.0) THEN BEGIN ; ambient temp less than acclimation
  rateC[TambLC] = 10.0^(0.41597 - 0.01704 * TacclC[TambLC] + 0.04320 * Tamb[TambLC] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0; in min
  ;rateC = 3.32*W^0.536 from Stevens and Sttuerlin (1976). in min
  ; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
  ;PRINT, 'TambLC', TambLC
ENDIF

; ambient temp greater than acclimation
    ;check if amb and acclimation are greater than maximum temp
  TambCH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclC), TambCHcount)
  TambHCH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclC), TambHCHcount)
  IF (TambCHcount GT 0.0) THEN rateC[TambCH] = 0.0; $ 
  IF (TambHCHcount GT 0.0) THEN rateC[TambHCH] = (EXP(-2.15 + (TacclC[TambHCH] - Tamb[TambHCH]) $
                                                / ToptC[TambHCH] - (((ToptC[TambHCH] - Tamb[TambHCH]) / 8.5)^2.0))) / 60.0
  ;PRINT, 'TambCH', TambCH 
  ;PRINT, 'TambHCH', TambHCH

; To determine acclimation temperature 
TacclC = Tamb + (TacclC - Tamb) * EXP(-rateC * ts)


; calculate the acclimation rate (based on bluegill by Hagar, 1978) for respiration 
rateR = FLTARR(nYP)
TambLR = WHERE(Tamb LT TacclR, TambRLcount, complement = TambLRL, ncomplement = TambLRLcount)
IF (TambRLcount GT 0.0) THEN BEGIN ;ambient temp less than acclimation
  rateR[TambLR] = 10.0^(0.41597 - 0.01704 * TacclR[TambLR] + 0.04320 * Tamb[TambLR] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0
; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
ENDIF

; ambient temp greater than acclimation
  ;check if amb and acclimation are greater than maximum temp
  TambRH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclR), TambRHcount)
  TambHRH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclR), TambHRHcount)
  IF (TambRHcount GT 0.0) THEN rateR[TambRH] = 0.0; $
  IF (TambHRHcount GT 0.0) THEN  rateR[TambHRH] = (EXP(-2.15 + (TacclR[TambHRH] - Tamb[TambHRH]) $
                                                 / ToptR[TambHRH] - (((ToptR[TambHRH] - Tamb[TambHRH]) / 8.5)^2.0))) / 60.0

; To determine acclimation temperature 
TacclR = Tamb + (TacclR - Tamb) * EXP(-rateR * ts)
;PRINT, 'rateC'
;PRINT, rateC 
;PRINT, 'rateR'
;PRINT, rateR
;PRINT, 'Tamb'
;PRINT, Tamb


Tacclimation = FLTARR(2, nYP)
Tacclimation[0,*] = TacclC
Tacclimation[1,*] = TacclR
;PRINT, 'TacclC, TacclR'
;PRINT, (Tacclimation)

PRINT, 'YEPacclT Ends Here'
RETURN, Tacclimation; TURN OFF WHEN TESTING
END