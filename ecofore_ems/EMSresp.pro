FUNCTION EMSresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, DOcritR, nEMS, Oxydebt
; function to determine respiration for EMERALD SHINER

PRINT, 'EMSresp Begins Here'

fDOrm2 = FLTARR(nEMS)
DOr = WHERE(DOacclR LE DOcritR, DOrcount, complement = DOrc, ncomplement = DOrccount)
IF (DOrcount GT 0.0) THEN fDOrm2[DOr] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclR[DOr] + (4. - DOcritR[DOr])) + 6.5916))
IF (DOrccount GT 0.0) THEN fDOrm2[DOrc] = 1.0
;PRINT, 'fDOrm2 =', fDOrm2


; Parameter values
; For RA, calibrate using values between 0.006 (Gauthier and Boisclair, 1997, CJFAS) and 0.0122 (Arend etal., 2010)
; values in fish bionergetics manual was overestimated
RA = 0.0078; 0.0122; 0.0247; number of g of O2 consumed by a 1g fish at RTO
RB = -0.1205; -0.2; slope of the allometric mass function for standard metabolism
RQ = 2.1; 2.35; 1.535; Q10 = the rate whoch the function increases over relatively low water temperature
RTO = 29. ; 41.6; optimum water temperature for respiration = respiration is highest
RTM = 32.; 44.6; maximum (lethal) water temperature for respiration
ACT = 3.7

;Temp function
TempFunc = FLTARR(nEMS)
Resp = FLTARR(nEMS)
V = FLTARR(nEMS)
V = (RTM - TacclR) / (RTM - RTO); temp = acclimatized temp 
natRQ = ALOG(RQ)
Z = natRQ * (RTM - RTO)
Y = natRQ * (RTM - RTO + 2.0)
x = (Z^2.0 * (1.0 + (1.0 + 40.0 / Y)^0.5)^2.0) / 400.0
TempFunc = V^X * EXP(X * (1.0 - V))


;Q10 effect (based on cownose rays) from Neer et al. 2007
 KQ10 = RQ; Q10 value = RQ
 Tstress = Tamb - TacclR
 Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func=', Q10func


OxyCal = 13560.
Resp = RA * Weight^RB * TempFunc * fDOrm2 * Act * OxyCal * Q10func ;units are J/g/d
;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
;PRINT, 'Resp (J/g/d) =', Resp
;PRINT, 'TempFunc =', TempFunc
;PRINT, 'fDOrm2 =', fDOrm2
Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight) ;puts units in terms of a J/ time step
;PRINT, 'Resp (J/g/ts)'
;PRINT, TRANSPOSE(Resp)


; If fish accumulate O2 debt, they need to pay over time by increasing metabolism
O2paied = FLTARR(nEMS)
NZOxydebt = WHERE(Oxydebt GT 0., NZOxydebtcount, complement = ZOxydebt, ncomplement = ZOxydebtcount)
IF NZOxydebtcount GT 0. THEN O2paied[NZOxydebt] = Resp[NZOxydebt] * 0.154
IF ZOxydebtcount GT 0. THEN  O2paied[ZOxydebt] = 0.

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

Oxydebt = Oxydebt + O2debt - O2paied
;PRINT, 'OXYDEBT'
;PRINT, TRANSPOSE(OXYDEBT)


Respiration = FLTARR(3, nEMS)
Respiration[0, *] = Resp
Respiration[1, *] = O2debt; new O2 debt
Respiration[2, *] = Oxydebt; total O2 debt
;PRINT, Respiration;

PRINT, 'EMSresp Ends Here'
RETURN, Respiration; TURN OFF WHEN TESTING
END