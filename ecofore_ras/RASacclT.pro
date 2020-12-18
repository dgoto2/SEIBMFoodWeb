FUNCTION RASacclT, TacclC, TacclR, Tamb, ts, length, nRAS
;this function determines the acclimation temperature for RAINBOW SMELT

PRINT, 'RASacclT Begins Here'

; Parameter values
;For YOY from the Wisconsin Bioenergetics Model manual
ToptC = FLTARR(nRAS)
ToptR = FLTARR(nRAS)
Tacclmax = FLTARR(nRAS)
TL = WHERE(length LT 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ToptC[TL] = 16.0; = CTO for YOY from the Wisconsin model parameters
  ToptR[TL] = 16.0; = NO RTO
  Tacclmax[TL] = 26.; 
ENDIF 
;values are for juvenile
TLL = WHERE((length GE 20.0 ) AND (length LT 80.0 ), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  ToptC[TLL] = 14.0; = CTO 
  ToptR[TLL] = 14.0; = NO RTO 
  Tacclmax[TLL] = 20.; 18.; 
ENDIF
;values are for adult 
TLLL = WHERE((length GE 80.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  ToptC[TLLL] = 10.0; = CTO 
  ToptR[TLLL] = 10.0; = NO RTO 
  Tacclmax[TLLL] = 20.; 18.; 
ENDIF


; Calculate the acclimation rate (based on bluegill by Hagar, 1978) for consumption
rateC = FLTARR(nRAS)
TambLC = WHERE(Tamb LT TacclC, TambLCcount, complement = TambLCL, ncomplement = TambLCLcount)
IF (TambLCcount GT 0.0) THEN BEGIN ;ambient temp less than acclimation
  rateC[TambLC] = 10.0^(0.41597 - 0.01704 * TacclC[TambLC] + 0.04320 * Tamb[TambLC] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0; in min
  ;rateC = 3.32*W^0.536 from Stevens and Sttuerlin (1976). in min
  ; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
ENDIF  

;ambient temp greater than acclimation
  ;check if amb and acclimation are greater than maximum temp
  TambCH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclC), TambCHcount)
  TambHCH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclC), TambHCHcount)
  IF (TambCHcount GT 0.0) THEN rateC[TambCH] = 0.0
  IF (TambHCHcount GT 0.0) THEN rateC[TambHCH] = (EXP(-2.15 + (TacclC[TambHCH] - Tamb[TambHCH]) $
                                                        / ToptC[TambHCH] - (((ToptC[TambHCH] - Tamb[TambHCH]) / 8.5)^2.0))) / 60.0


; determine acclimation temperature 
TacclC = Tamb + (TacclC - Tamb) * EXP(-rateC * ts)


; calculate the acclimation rate (based on bluegill by Hagar, 1978) for respiration 
rateR = FLTARR(nRAS)
TambLR = WHERE(Tamb LT TacclR, TambRLcount, complement = TambLRL, ncomplement = TambLRLcount)
IF (TambRLcount GT 0.0) THEN BEGIN ;ambient temp less than acclimation
  rateR[TambLR] = 10.0^(0.41597 - 0.01704 * TacclR[TambLR] + 0.04320 * Tamb[TambLR] - 0.08376 * (ALOG10(1.0 + 1.0))) / 24.0 / 60.0
; for pinfish from Reber and Bennett (2007). Journal of Fish Biology
ENDIF  

;ambient temp greater than acclimation
  ;check if amb and acclimation are greater than maximum temp
  TambRH = WHERE((Tamb GE Tacclmax) AND (Tamb GE TacclR), TambRHcount)
  TambHRH = WHERE((Tamb LT Tacclmax) AND (Tamb GE TacclR), TambHRHcount)
  IF (TambRHcount GT 0.0) THEN rateR[TambRH] = 0.0
  IF (TambHRHcount GT 0.0) THEN rateR[TambHRH] = (EXP(-2.15 + (TacclR[TambHRH] - Tamb[TambHRH]) $
                                                       / ToptR[TambHRH] - (((ToptR[TambHRH] - Tamb[TambHRH]) / 8.5)^2.0))) / 60.0
                                                       
; determine acclimation temperature 
TacclR = Tamb + (TacclR - Tamb) * EXP(-rateR * ts)
;PRINT, 'rateC =', rateC 
;PRINT, 'rateR =', rateR

Tacclimation = FLTARR(2, nRAS)
Tacclimation[0,*] = TacclC
Tacclimation[1,*] = TacclR
;PRINT, 'TacclC, TacclR =', Tacclimation

PRINT, 'RASacclT Ends Here'
RETURN, Tacclimation
END