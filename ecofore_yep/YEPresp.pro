FUNCTION YEPresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, DOcritR, nYP, Oxydebt
; Function to determine respiration

PRINT, 'YEPresp Begins Here'

tstart = SYSTIME(/seconds)

;>DO function
fDOrm2 = FLTARR(nYP)
DOr = WHERE((DOcritR GE DOacclR), DOrcount, complement = DOrc, ncomplement = DOrccount)
IF (DOrcount GT 0.0) THEN fDOrm2[DOr] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclR[DOr] + (4. - DOcritR[DOr])) + 6.5916)); $
;ELSE fDOrm2[DOrc] = 1.0
IF (DOrccount GT 0.0) THEN fDOrm2[DOrc] = 1.0
;PRINT, 'fDOrm2'
;PRINT, fDOrm2;

;Q10 effect (based on cownose rays) from Neer et al. 2007
KQ10 = 2.33; Q10 value
Tstress = Tamb - TacclR
Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func'
;PRINT, Q10func

; Parameter values
RA = FLTARR(nYP) 
RB = FLTARR(nYP)
RQ = FLTARR(nYP)
RTO = FLTARR(nYP)
RTM = FLTARR(nYP)
ACT = FLTARR(nYP)
TL = WHERE(length LT 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ;For Larval yellow perch from the Wisconsin Bioenergetics Manual
  RA[TL] = 0.0065; number of g of O2 consumed by a 1g fish at RTO
  RB[TL] = -0.2; slope of the allometric mass function for standard metabolism
  RQ[TL] = 2.1; Q10 = the rate whoch the function increases over relatively low water temperature
  RTO[TL] = 32.0; optimum water temperature for respiration = respiration is highest
  RTM[TL] = 35.0; maximum (lethal) water temperature for respiration
  ACT[TL] = 4.; from WBM, but this doesn't allow the fish to grow due to high resp costs 
ENDIF
;values are for juvenile yellow perch
TLL = WHERE((LENGTH GE 20.0 ) AND (length LT 100.0 ), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  ;values are for juvenile and adult yellow perch
  ;For juvenile and adult yellow perch from the Wisconsin Bioenergetics Manual
  RA[TLL] = 0.0108; number of g of O2 consumed by a 1g fish at RTO
  RB[TLL] = -0.2; slope of the allometric mass function for standard metabolism
  RQ[TLL] = 2.1; Q10 = the rate which the function increases over relatively low water temperature
  RTO[TLL] = 32.0; optimum water temperature for respiration = respiration is highest
  RTM[TLL] = 35.0; maximum (lethal) water temperature for respiration
  ACT[TLL] = 2.5; multiplication factor
ENDIF
;values are for adult yellow perch
TLLL = WHERE((LENGTH GE 100.0 ), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  ;values are for juvenile and adult yellow perch
  ;For juvenile and adult yellow perch from the Wisconsin Bioenergetics Manual
  RA[TLLL] = 0.0108; number of g of O2 consumed by a 1g fish at RTO
  RB[TLLL] = -0.2; slope of the allometric mass function for standard metabolism
  RQ[TLLL] = 2.1; Q10 = the rate which the function increases over relatively low water temperature
  RTO[TLLL] = 28.0; optimum water temperature for respiration = respiration is highest
  RTM[TLLL] = 33.0; maximum (lethal) water temperature for respiration
  ACT[TLLL] = 2.; multiplication factor
ENDIF

;Temp function
V = (RTM - TacclR) / (RTM - RTO); temp = acclimatized temp 
natRQ = ALOG(RQ)
Z = natRQ * (RTM - RTO)
Y = natRQ * (RTM - RTO + 2.0)
X= (Z^2.0 * (1.0 + (1.0 + 40.0 / Y)^0.5)^2.0) / 400.0
TempFunc = V^X * EXP(X * (1.0 - V))
;PRINT, 'TempFunc'
;PRINT, TempFunc

OxyCal = 13560.; J/g O2
Resp = RA * Weight^RB * TempFunc * fDOrm2 * Q10func * Act * OxyCal;units are J/g/d
;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
O2debt = RA * Weight^RB * TempFunc * (1. - fDOrm2) * Q10func * Act * OxyCal
;PRINT, 'Resp (J/g/d)'
;PRINT, Resp

Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight); + Oxydebt ; puts units in terms of a J/ts min time interval
;PRINT, 'Resp (J/ts)'
;PRINT, TRANSPOSE(Resp)

O2paied = FLTARR(nYP)
NZOxydebt = WHERE(Oxydebt GT 0., NZOxydebtcount, complement = ZOxydebt, ncomplement = ZOxydebtcount)
IF NZOxydebtcount GT 0. THEN O2paied[NZOxydebt] = Resp[NZOxydebt] * 0.154 
IF ZOxydebtcount GT 0. THEN O2paied[ZOxydebt] = 0.

RealO2paied = WHERE(O2paied GT Oxydebt, RealO2paiedcount, complement = MoreOxydebt, ncomplement = MoreOxydebtcount)
IF RealO2paiedcount GT 0. THEN O2paied[RealO2paied] = Oxydebt[RealO2paied] 
IF MoreOxydebtcount GT 0. THEN O2paied[MoreOxydebt] = O2paied[MoreOxydebt]
;PRINT, 'O2Paied'
;PRINT, O2Paied

Resp = Resp + O2paied

O2debt = TRANSPOSE(O2debt / 24.0 / 60.0 * ts * Weight)
;PRINT, 'O2DEBT'
;PRINT, TRANSPOSE(O2DEBT)

Oxydebt = Oxydebt + O2DEBT - O2paied
;PRINT, 'OXYDEBT'
;PRINT, TRANSPOSE(OXYDEBT)

Respiration = FLTARR(3, nYP)
Respiration[0, *] = Resp
Respiration[1, *] = O2debt; new O2 debt
Respiration[2, *] = Oxydebt; total O2 debtPRINT, Respiration;

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'YEPresp Ends Here'

RETURN, Respiration; TURN OFF WHEN TESTING
END