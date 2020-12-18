FUNCTION WAEcmax, weight, length, nWAE, TEMP
; function to determine cmax for walleye

PRINT, 'WAEcmax Begins Here'

; Parameters required for the bioenergtics subroutine (From Hanson 1997)
; Temperature-dependent function for C 
; Parameter values for energy loss
CA = FLTARR(nWAE)
CB = FLTARR(nWAE)
CQ = FLTARR(nWAE)
CTM = FLTARR(nWAE)
CTO = FLTARR(nWAE)

; values are for larval 
TL = WHERE(length LE 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CA[TL] = 0.45
  CB[TL] = -0.27
  CQ[TL] = 2.3
  CTM[TL] = 28.0
  CTO[TL] = 25.0
ENDIF
;values are for juvenile and adult walleye
IF (TLLcount GT 0.0) THEN BEGIN 
  CA[TLL] = 0.25
  CB[TLL] = -0.27
  CQ[TLL] = 2.3
  CTM[TLL] = 28.0
  CTO[TLL] = 22.0
ENDIF

V_C = (CTM - Temp) / (CTM - CTO)
Z_C = ALOG(CQ) * (CTM - CTO)
Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0
fT = V_C^X_C * EXP(X_C * (1.0 - V_C))
;PRINT, 'ft'
;PRINT, ft

CA = FLTARR(nWAE)
CB = FLTARR(nWAE)
TL = WHERE(length LE 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ;values are for larval walleye less than 43 mm
  CA[TL] = 0.45 
  CB[TL] = -0.27 
ENDIF

IF (TLLcount GT 0.0) THEN BEGIN 
  ;values are for larval walleye greater than 43mm + values are for adult walleye
  CA[TLL] = 0.25
  CB[TLL] = -0.27
ENDIF

cmaxx = CA * weight^(CB) * fT
cmaxx = cmaxx * weight ; g/d
;PRINT, 'Cmax =', cmaxx ;units are g/d
;PRINT, 'CA =', CA, 'CB =', CB

PRINT, 'WAEcmax Ends Here'
RETURN,  cmaxx
END