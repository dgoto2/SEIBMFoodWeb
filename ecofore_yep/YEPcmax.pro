FUNCTION YEPcmax, weight, length, nYP, Temp
; function to determine Cmax

PRINT, 'YPcmax Begins Here'

; Parameters required for the bioenergtics subroutine (From Hanson 1997)
; Temperature-dependent function for C 
; Parameter values 
CA = FLTARR(nYP)
CB = FLTARR(nYP)
CQ = FLTARR(nYP)
CTM = FLTARR(nYP)
CTO = FLTARR(nYP)

;values are for larval yellow perch
TL = WHERE(length LE 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CA[TL] = 0.51
  CB[TL] = -0.42
  CQ[TL] = 2.3
  CTM[TL] = 32.0
  CTO[TL] = 29.0
ENDIF
;values are for juvenile yellow perch
TLL = WHERE((LENGTH GE 20.0 ) AND (length LT 100.0 ), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  CA[TLL] = 0.25
  CB[TLL] = -0.27
  CQ[TLL] = 2.3
  CTM[TLL] = 32.0
  CTO[TLL] = 29.0
ENDIF
;values are for adult yellow perch
TLLL = WHERE((LENGTH GE 100.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  CA[TLLL] = 0.25
  CB[TLLL] = -0.27
  CQ[TLLL] = 2.3
  CTM[TLLL] = 28.0
  CTO[TLLL] = 23.0
ENDIF

V_C = (CTM - Temp) / (CTM - CTO)
Z_C = ALOG(CQ) * (CTM - CTO)
Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0
fT = V_C^X_C * EXP(X_C * (1.0 - V_C))
;PRINT, 'fT'
;PRINT, fT

CA = FLTARR(nYP)
CB = FLTARR(nYP)
TL = WHERE(length LE 20.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ;values are for larval yellow perch
  CA[TL] = 0.51 
  CB[TL] = -0.42 
ENDIF
IF (TLLcount GT 0.0) THEN BEGIN 
  ;values are for juvenile and adult yellow perch
  CA[TLL] = 0.25
  CB[TLL] = -0.27
ENDIF

Cmaxx = CA * weight^(CB) * fT
Cmaxx = Cmaxx * weight ;  g/d
;PRINT, 'Cmax'
;PRINT, cmaxx ; units are g/d
;PRINT, 'CA', CA
;PRINT, 'CB', CB

PRINT, 'YPcmax Ends Here'
RETURN,  Cmaxx
END
