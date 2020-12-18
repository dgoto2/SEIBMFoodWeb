FUNCTION ROGcmax, weight, length, nROG, temp
; function to determine cmax for ROUND GOBY

;---FOR TESTING FORAGING--------------------------------------------
;nROG = 50L
;Weight = FLTARR(nROG)
;length= FLTARR(nROG)
;ROG = ROGinitial(nROG, newinput)
;weight = ROG[1, *]
;length = ROG[2, *]
;-------------------------------------------------------------------------

PRINT, 'ROGcmax Begins Here'
; Parameters required for the bioenergtics subroutine (From Hanson 1997)-----
; Temperature-dependent function for C 
; Parameter values for energy loss
;values are for larval 
;  TL = WHERE(length LE 20.0, TLcount, complement = TLL, ncomplement = TLLcount)
;  IF (TLcount GT 0.0) THEN BEGIN
CK1 = 0.113
CK4 = 0.419
CQ = 5.594
CTM = 25.706
CTO = 24.648
CTL = 28.992
G1 = (1. / (CTO - CQ)) * ALOG((0.98 * (1.- CK1)) / (CK1 * 0.02))
G2 = (1. / (CTL - CTM)) * ALOG((0.98 * (1.- CK4)) / (CK4 * 0.02))
L1 = EXP(G1 * (Temp - CQ))
L2 = EXP(G2 * (CTL - Temp))
KA = (CK1 * L1) / (1. + CK1 * (L1 - 1.))
KB = (CK4 * L2) / (1. + CK4 * (L2 - 1.))
fT = KA * KB
;ENDIF; ELSE BEGIN
  ;values are for juvenile and adult
;  IF (TLLcount GT 0.0) THEN BEGIN 

;  ENDIF
;  PRINT, 'ft'
;  PRINT, ft

;TL = WHERE(length LE 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
;IF (TLcount GT 0.0) THEN BEGIN
;values are for larval walleye less than 43 mm
CA = 0.192 
CB = -0.256 
cmaxx = CA * weight^(CB) * fT
;ENDIF; ELSE BEGIN
;IF (TLLcount GT 0.0) THEN BEGIN 
;values are for larval walleye greater than 43mm + values are for adult walleye
;CA = 0.25
;CB = -0.27
;cmaxx[TLL] = CA * weight[TLL]^(CB)
;ENDIF

;cmaxx = CA * weight^CB
cmaxx = cmaxx * weight ; puts units into g/d
;PRINT, 'Cmax'
;PRINT, cmaxx ;units are g/d
;PRINT, 'CA =', CA, 'CB =', CB

PRINT, 'ROGcmax Ends Here'
RETURN,  cmaxx
END