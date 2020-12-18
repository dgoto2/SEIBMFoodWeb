FUNCTION RAScmax, weight, length, nRAS, temp
; function to determine cmax for RAINBOW SMELT

PRINT, 'RAScmax Begins Here'

; Parameters required for the bioenergtics subroutine (From Hanson 1997)
; Temperature-dependent function for C 
; Parameter values  
;For Larval from the Wisconsin Bioenergetics Model manual
CTO = FLTARR(nRAS)
CTM = FLTARR(nRAS)
CTL = FLTARR(nRAS)
TL = WHERE(LENGTH LT 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CTO[TL] = 16.0; = CTO for larval from the Wisconsin model parameters
  CTM[TL] = 21.0; = NO RTO
  CTL[TL] = 26.
ENDIF 

;values are for juvenile
TLL = WHERE((LENGTH GE 20.0 ) AND (length LT 80.0 ), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  CTO[TLL] = 14.0; = CTO 
  CTM[TLL] = 18.; 16.0; = NO RTO 
  CTL[TLL] = 20.; 18. 
ENDIF

;values are for adult 
TLLL = WHERE((LENGTH GE 80.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  CTO[TLLL] = 10.0; = CTO 
  CTM[TLLL] = 14.; 12.0; = NO RTO 
  CTL[TLLL] = 20.; 18.
ENDIF

CK1 = 0.4
CK4 = 0.01
CQ = 3.
G1 = (1. / (CTO - CQ)) * ALOG((0.98 * (1.- CK1)) / (CK1 * 0.02))
G2 = (1. / (CTL - CTM)) * ALOG((0.98 * (1.- CK4)) / (CK4 * 0.02))
L1 = EXP(G1 * (Temp - CQ))
L2 = EXP(G2 * (CTL - Temp))
KA = (CK1 * L1) / (1. + CK1 * (L1 - 1.))
KB = (CK4 * L2) / (1. + CK4 * (L2 - 1.))
fT = KA * KB
; PRINT, 'ft'
; PRINT, ft


CA = 0.18
CB = -0.275 
Cmaxx = CA * weight^(CB) * fT
Cmaxx = Cmaxx * weight; g/d
;PRINT, 'Cmax =', cmaxx ; g/d
;PRINT, 'CA =', CA, 'CB =', CB

PRINT, 'RAScmax Ends Here'
RETURN,  Cmaxx
END