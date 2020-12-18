FUNCTION RASresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, DOcritR, nRAS, Oxydebt
; function to determine respiration for RAINBIOW SMELT

PRINT, 'RASresp Begins Here'

;IF DOa is less than DOacclR
fDOrm2 = FLTARR(nRAS)
DOr = WHERE(DOacclR LE DOcritR, DOrcount, complement = DOrc, ncomplement = DOrccount)
IF (DOrcount GT 0.0) THEN fDOrm2[DOr] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclR[DOr] + (4. - DOcritR[DOr])) + 6.5916))
IF (DOrccount GT 0.0) THEN fDOrm2[DOrc] = 1.0
;PRINT, 'fDOrm2 =', fDOrm2;


; Parameter values
; from the Wisconsin Bioenergetics Manual
RA = 0.0027; number of g of O2 consumed by a 1g fish at RTO
RB = -0.216; slope of the allometric mass function for standard metabolism
RQ = 0.036; Q10 = the rate that the function increases over relatively low water temperature

; Temperature function
TempFunc = FLTARR(nRAS)
RTO = 0.; optimum water temperature for respiration = respiration is highest
RTM = 0.; maximum (lethal) water temperature for respiration

ACT = FLTARR(nRAS)
TL = WHERE(LENGTH LT 20., TLcount)
IF (TLcount GT 0.0) THEN ACT[TL] = 2.2
; values are for juvenile
TLL = WHERE((LENGTH GE 20.) AND (LENGTH LT 80.), TLLcount)
IF (TLLcount GT 0.0) THEN ACT[TLL] = 3.
; values are for adult 
TLLL = WHERE((LENGTH GE 80.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN ACT[TLLL] = 1.5

BACT = 0.
RTL = 0.
RK1 = 0.
RK4 = 0.
VEL = FLTARR(nRAS)
VELtemp = WHERE(TacclR LT RTL, VELtempcount, complement = VELtemp2, ncomplement = VELtemp2count)
;IF Temp LT RTL
IF (VELtempcount GT 0.0) THEN VEL[VELtemp] = RK1 * weight[VELtemp]^RT4
;IF Temp GE RTL
IF (VELtemp2count GT 0.0) THEN VEL[VELtemp2] = ACT * RK1 * weight[VELtemp2]^RK4 * EXP(BACT * TacclR[VELtemp2])

TempFunc = EXP(RQ * TacclR)
ACTIVITY = ACT; EXP(RTO * VEL); changed to a constant multiplier 
;PRINT, 'TempFunc'
;PRINT, TempFunc
;PRINT, 'ACTIVITY'
;PRINT, ACTIVITY[0:100]
;PRINT, 'VEL'
;PRINT, VEL
;PRINT, 'V'
;PRINT, V
;PRINT, 'Z'
;PRINT, Z
;PRINT, 'Y'
;PRINT, Y
;PRINT, 'X'
;PRINT, X


;Q10 effect from Neer et al. 2007
 KQ10 = 1.14; RQ; 2.33; Q10 value
 Tstress = Tamb - TacclR
 Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func=', Q10func


Resp = FLTARR(nRAS)
OxyCal = 13560.
Resp = RA * Weight^RB * TempFunc * fDOrm2 * ACTIVITY * OxyCal * Q10func ;units are J/g/d
;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
;PRINT, 'Resp (J/g/d)'
;PRINT, Resp
;PRINT, 'fDOrm2'
;PRINT, fDOrm2
Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight); J/time step
;PRINT, 'Resp (J/ts)'
;PRINT, TRANSPOSE(Resp)


; if cumulative O2 debt is more than 0, determine O2 debt paid
O2paied = FLTARR(nRAS)
NZOxydebt = WHERE(Oxydebt GT 0., NZOxydebtcount, complement = ZOxydebt, ncomplement = ZOxydebtcount)
IF NZOxydebtcount GT 0. THEN O2paied[NZOxydebt] = Resp[NZOxydebt] * 0.154 
IF ZOxydebtcount GT 0. THEN  O2paied[ZOxydebt] = 0.

RealO2paied = WHERE(O2paied GT Oxydebt, RealO2paiedcount, complement = MoreOxydebt, ncomplement = MoreOxydebtcount)
IF RealO2paiedcount GT 0. THEN O2paied[RealO2paied] = Oxydebt[RealO2paied] 
IF MoreOxydebtcount GT 0. THEN  O2paied[MoreOxydebt] = O2paied[MoreOxydebt]
;PRINT, 'O2Paied'
;PRINT, O2Paied

Resp = Resp + O2paied


; if fish are in hypoxic water, determine new O2 debt per time step
O2debt = RA * Weight^RB * TempFunc * (1. - fDOrm2) * Q10func * Act * OxyCal
O2debt = TRANSPOSE(O2debt / 24.0 / 60.0 * ts * Weight)
;PRINT, 'O2DEBT'
;PRINT, TRANSPOSE(O2DEBT)


; determine cumulative O2 debt
Oxydebt = Oxydebt + O2DEBT - O2paied
;PRINT, 'OXYDEBT'
;PRINT, TRANSPOSE(OXYDEBT)


Respiration = FLTARR(3, nRAS)
Respiration[0, *] = Resp
Respiration[1, *] = O2debt; new O2 debt
Respiration[2, *] = Oxydebt; total O2 debt
;PRINT, Respiration;

PRINT, 'RASresp Ends Here'
RETURN, Respiration
END