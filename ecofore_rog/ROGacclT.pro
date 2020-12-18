FUNCTION ROGacclT, TacclC, TacclR, Tamb, ts, nROG
;this function determines the acclimation temperature for ROUND GOBY

PRINT, 'ROGacclT Begins Here'
;------TO BE USED FOR TESTING PURPOSES ONLY-..TURN OFF when function in use-------------
;---NEED for TESTING MOVE------------------
;nROG = 50L
;ts = 6L; with /60*ts
;ROG = ROGinitial(nROG, newinput)
;Length = ROG[1, *]
;------------------------------------------
;Tamb = fltarr(nWAE)
;Tamb = 20.0; temperature of the cell the individual is in
;TacclR = fltarr(nWAE)
;TacclC = fltarr(nWAE)
;TacclC = 29.0; acclimated temperature for consumption
;TacclR = 29.0; acclimated temperature for respiration

;NEED species-specific temperature preference/tolerance!!!!
;----------------------------------------------------------------------------------------

; Parameter values
;For Larval yellow perch from the Wisconsin Bioenergetics Model manual
;TL = WHERE(length LT 20.0, TLcount, complement = TLL, ncomplement = TLLcount)
;IF (TLcount GT 0.0) THEN BEGIN
ToptC = 24.648; = CTO from the Wisconsin model parameters
ToptR = 24.648; = CTO from the Wisconsin model parameters
;ENDIF 
;values are for juvenile and adult
;IF (TLLcount GT 0.0) THEN BEGIN 
;ToptC = 23.0; = CTO 
;ToptR = 28.0; = RTO 
;ENDIF
Tacclmax = 25.706; for ?????, Eaton et al. 1995. Fisheries. 20(4)

; Calculate the acclimation rate for consumption based on bluegill by Hagar (1978)
rateC = FLTARR(nROG)
TambLC = WHERE(Tamb LT TacclC, TambLCcount, complement = TambLCL, ncomplement = TambLCLcount)
IF (TambLCcount GT 0.0) THEN BEGIN ;ambient temp less than acclimation
  rateC[TambLC] = 10.0^(0.41597 - 0.01704 * TacclC[TambLC] + 0.04320 * Tamb[TambLC] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0; in min
  ;rateC = 3.32*W^0.536 from Stevens and Sttuerlin (1976). in min
  ; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
ENDIF; ELSE BEGIN 
;ambient temp greater than acclimation
  ;check if amb and acclimation are greater than maximum temp
  TambCH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclC), TambCHcount)
  TambHCH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclC), TambHCHcount)
  IF (TambCHcount GT 0.0) THEN rateC[TambCH] = 0.0
  ;IF (Tamb GT Tacclmax) AND (TacclC GT Tacclmax) THEN rateC = 0 $
  IF (TambHCHcount GT 0.0) THEN  rateC[TambHCH] = (EXP(-2.15 + (TacclC[TambHCH] - Tamb[TambHCH]) $
                                                        / ToptC[TambHCH] - (((ToptC[TambHCH] - Tamb[TambHCH]) / 8.5)^2.0))) / 60.0
;ENDELSE

;need to determine acclimation temperature 
;TacclCng=Tamb -(Tamb-Taccl)*exp(-rateC)-Taccl
;Taccl = Taccl + TacclCng*Tstep
TacclC = Tamb + (TacclC - Tamb) * EXP(-rateC * ts)

;calculate the acclimation rate for respiration on bluegill by Hagar (1978)
rateR = FLTARR(nROG)
TambLR = WHERE(Tamb LT TacclR, TambRLcount, complement = TambLRL, ncomplement = TambLRLcount)
IF (TambRLcount GT 0.0) THEN BEGIN ;ambient temp less than acclimation
  rateR[TambLR] = 10.0^(0.41597 - 0.01704 * TacclR[TambLR] + 0.04320 * Tamb[TambLR] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0
; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
ENDIF; ELSE BEGIN 
;ambient temp greater than acclimation
  ;check if amb and acclimation are greater than maximum temp
  TambRH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclR), TambRHcount)
  TambHRH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclR), TambHRHcount)
  IF (TambRHcount GT 0.0) THEN rateR[TambRH] = 0.0
  ;IF (Tamb GT Tacclmax) AND (TacclR GT Tacclmax) THEN rateR = 0 $
  IF (TambHRHcount GT 0.0) THEN rateR[TambHRH] = (EXP(-2.15 + (TacclR[TambHRH] - Tamb[TambHRH]) $
                                                        / ToptR[TambHRH] - (((ToptR[TambHRH] - Tamb[TambHRH]) / 8.5)^2.0))) / 60.0
;ENDELSE

; need to determine acclimation temperature 
;TacclCng=Tamb -(Tamb-Taccl)*exp(-rateR)-Taccl
;Taccl = Taccl + TacclCng*Tstep
TacclR = Tamb + (TacclR - Tamb) * EXP(-rateR * ts)
;PRINT, 'rateC =', rateC 
;PRINT, 'rateR =', rateR

Tacclimation = FLTARR(2, nROG)
Tacclimation[0, *] = TacclC
Tacclimation[1, *] = TacclR
;PRINT, 'TacclC, TacclR'
;PRINT, Tacclimation

PRINT, 'ROGacclT Ends Here'
RETURN, Tacclimation
END