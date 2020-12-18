FUNCTION WAEresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, DOcritR, nWAE, Oxydebt
; function to determine respiration for walleye

PRINT, 'WAEresp Begins Here'


fDOrm2 = FLTARR(nWAE)
DOr = WHERE(DOcritR GE DOacclR, DOrcount, complement = DOrc, ncomplement = DOrccount)
;IF DOa lt DOacclR 
IF (DOrcount GT 0.0) THEN fDOrm2[DOr] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclR[DOr] + (4. - DOcritR[DOr])) + 6.5916))
IF (DOrccount GT 0.0) THEN fDOrm2[DOrc] = 1.0
;PRINT, 'fDOrm2'
;PRINT, fDOrm2

; NEED swimming speed-based activity cost---------

;parameters required for the bioenergtics subroutine (From Madon and Culver 1993)
;values for respiration vary depending on size (Rose et al. 1999)

; Parameter values
RA = FLTARR(nWAE) 
RB = FLTARR(nWAE)
RQ = FLTARR(nWAE)
RTO = FLTARR(nWAE)
RTM = FLTARR(nWAE)
ACT = FLTARR(nWAE)
V = FLTARR(nWAE)

TL = WHERE(length LT 43., TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ;For Larval walleye less than 43mm (Rose et al. 1999) from the Wisconsin Bioenergetics Manual
  RA[TL] = 0.0056; 0.0138; number of g of O2 consumed by a 1g fish at RTO
  RB[TL] = -0.22; slope of the allometric mass function for standard metabolism
  RQ[TL] = 2.1; Q10 = the rate whoch the function increases over relatively low water temperature
  RTO[TL] = 27.0; optimum water temperature for respiration = respiration is highest
  RTM[TL] = 32.0; maximum (lethal) water temperature for respiration
  ACT[TL] = 3.2 
ENDIF
IF (TLLcount GT 0.0) THEN BEGIN 
  ;values are for walleye > 43mm (Rose et al. 1999)
  ;For juvenile and adult walleye from the Wisconsin Bioenergetics Manual
  RA[TLL] = 0.00261; number of g of O2 consumed by a 1g fish at RTO
  RB[TLL] = -0.15; slope of the allometric mass function for standard metabolism
  RQ[TLL] = 2.1; Q10 = the rate which the function increases over relatively low water temperature
  RTO[TLL] = 27.0; optimum water temperature for respiration = respiration is highest
  RTM[TLL] = 32.0; maximum (lethal) water temperature for respiration
  ACT[TLL] = 4.8; multiplication factor
ENDIF

V = (RTM - TacclR) / (RTM - RTO); temp = acclimatized temp 
natRQ = ALOG(RQ)
Z = natRQ * (RTM - RTO)
Y = natRQ * (RTM - RTO + 2.0)
X= (Z^2.0 * (1.0 + (1.0 + 40.0 / Y)^0.5)^2.0) / 400.0
TempFunc = V^X * EXP(X * (1.0 - V))
;PRINT, 'TempFunc'
;PRINT, TempFunc


;Q10 effect (based on cownose rays) from Neer et al. 2007
 KQ10 = RQ; Q10 value
 Tstress = Tamb - TacclR
 Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func'
;PRINT, Q10func


OxyCal = 13560.
Resp = RA * Weight^RB * TempFunc * fDOrm2 * Act * OxyCal * Q10func ; J/g/d
;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight) ;puts units in terms of a J/time step
;PRINT, 'Resp (J/g)'
;PRINT, TRANSPOSE(Resp)


; If fish accumulate O2 debt, they need to pay over time by increasing metabolism
O2paied = FLTARR(nWAE)
NZOxydebt = WHERE(Oxydebt GT 0., NZOxydebtcount, complement = ZOxydebt, ncomplement = ZOxydebtcount)
IF NZOxydebtcount GT 0. THEN O2paied[NZOxydebt] = Resp[NZOxydebt] * 0.154
IF ZOxydebtcount GT 0. THEN O2paied[ZOxydebt] = 0.

; check if O2 paid is below the O2 debt (Oxydebt = cummulative O2 debt)
RealO2paied = WHERE(O2paied GT Oxydebt, RealO2paiedcount, complement = MoreOxydebt, ncomplement = MoreOxydebtcount)
IF RealO2paiedcount GT 0. THEN O2paied[RealO2paied] = Oxydebt[RealO2paied]
IF MoreOxydebtcount GT 0. THEN O2paied[MoreOxydebt] = O2paied[MoreOxydebt]
;PRINT, 'O2Paied'
;PRINT, O2Paied

Resp = Resp + O2paied

; O2 debt when fish are in hypoxia water -> for acute exposure, fish are assumed to adjust their respiration
O2debt = RA * Weight^RB * TempFunc * (1. - fDOrm2) * Q10func * Act * OxyCal
O2debt = TRANSPOSE(O2debt / 24.0 / 60.0 * ts * Weight)
;PRINT, 'O2DEBT'
;PRINT, TRANSPOSE(O2DEBT)

Oxydebt = Oxydebt + O2DEBT - O2paied
;PRINT, 'OXYDEBT'
;PRINT, TRANSPOSE(OXYDEBT)


Respiration = FLTARR(3, nWAE)
Respiration[0, *] = Resp
Respiration[1, *] = O2debt; new O2 debt
Respiration[2, *] = Oxydebt; total O2 debt
;PRINT, Respiration;

PRINT, 'WAEresp Ends Here'
RETURN, Respiration; TURN OFF WHEN TESTING
END