FUNCTION ROGresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, DOcritR, nROG, Oxydebt
; function to determine respiration for ROUND GOBY

;-----parameters required for the bioenergtics subroutine (From Hanson 1997)--------------
;PRO ROGresp, Tamb, TacclR, Weight, length, ts, DOa, DOacclR, nROG
;respiration
;Weight = [0.0028, 0.0037, 0.028]
;TacclR = [20.0, 19.0, 15.0]
;ts = 6; in min
;DoacclSAT = 50.0; in %
;Tamb = [10.4, 20.8, 10.7]
;DOacclR = [2.4, 4.8, 7.7]
;DOa = [7.5, 9.6, 6.4]
;nWAE = 3
;length = [15.0, 21.0, 32.0] 
;------------------------------------------------------------------------------------------

PRINT, 'ROGresp Begins Here'
OxyCal = 13560.
;--DO function-----------------------------------------------------------------------------
; DO function parametner values from Niklitschek and Secor 2009
crm = 1.0; +-0.26 DO response shape parameter
drm = 0.75; +- 0.097 constant for reaction rate at lowest DOsat
grm = 0.27;+-0.051 constant for DOCrm
DO1 = 25.0 ;in %  lowest tested DOsat
; DO function from Atalntic Sturgeon by Niklitschek and Secor 2009
;DOCrm = 100 * (1.0 - grm * exp(-TempFunc))
;KO1rm = 1 - drm * exp(TempFunc - 1)
;SLrm = (KO1rm - 1.0) / (0.01 * (DOCrm - DO1))^crm
;IF DOacclSAT lt DOCrm THEN fDOrm = 1.0 - SLrm * (DOCrm - DOacclSAT)^crm ELSE fDOrm = 1.0

;PRINT, 'DOa =', DOa, 'DOacclR =', DOacclR

fDOrm2 = FLTARR(nROG)
DOr = WHERE(DOacclR LE DOcritR, DOrcount, complement = DOrc, ncomplement = DOrccount)
;IF DOa lt DOacclR 
IF (DOrcount GT 0.0) THEN fDOrm2[DOr] = 1.0 / (1.0 + EXP(-2.1972 * (DOacclR[DOr] + (4. - DOcritR[DOr])) + 6.5916))
IF (DOrccount GT 0.0) THEN fDOrm2[DOrc] = 1.0
;PRINT, 'fDOrm2 =', fDOrm2
;--------------------------------------------------------------------------------------------


; NEED swimming speed-based activity cost---------


;parameters required for the bioenergtics subroutine (From Madon and Culver 1993)
;values for respiration vary depending on size (Rose et al. 1999)
;therefore, need to determine length first and assign parameter values based on length
; Parameter values
TempFunc = FLTARR(nROG)
Resp = FLTARR(nROG)
V = FLTARR(nROG)
;TL = WHERE(length LT 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
;IF (TLcount GT 0.0) THEN BEGIN
; from the Wisconsin Bioenergetics Manual
RA = 0.00094; number of g of O2 consumed by a 1g fish at RTO
RB = -0.157; slope of the allometric mass function for standard metabolism
RQ = 0.061; Q10 = the rate whoch the function increases over relatively low water temperature
; NEED TO FIND RTO AND RTM FOR SMELT****THE FOLLOWING IS CTO AND CTM
RTO = 0.; optimum water temperature for respiration = respiration is highest
RTM = 0.0; maximum (lethal) water temperature for respiration
ACT = 2.; 1.6; RANDOMU(seed, nROG) * (MAX(2.8) - MIN(1.4)) + MIN(1.4); from WBM
BACT = 0.0
RTL = 0.
RK1 = 0.
RK4 = 0.
;Temp function
VEL = FLTARR(nROG)
VELtemp = WHERE(TacclR LT RTL, VELtempcount, complement = VELtemp2, ncomplement = VELtemp2count)
;IF Temp LT RTL
IF (VELtempcount GT 0.0) THEN VEL[VELtemp] = RK1 * weight[VELtemp]^RT4
;IF Temp GE RTL
IF (VELtemp2count GT 0.0) THEN VEL[VELtemp2] = ACT * RK1 * weight[VELtemp2]^RK4 * EXP(BACT * TacclR[VELtemp2])

TempFunc = EXP(RQ * TacclR)
ACTIVITY = ACT; EXP(RTO * VEL)
;V = (RTM - TacclR) / (RTM - RTO); temp = acclimatized temp 
;natRQ = ALOG(RQ)
;Z = natRQ * (RTM - RTO)
;Y = natRQ * (RTM - RTO + 2.0)
;X = ((Z)^2.0 * (1.0 + (1.0 + 40.0 / (Y))^0.5)^2.0) / 400.0
;TempFunc = V^X * EXP(X * (1.0 - V))
;PRINT, 'TempFunc'
;PRINT, TempFunc
;PRINT, 'ACTIVITY'
;PRINT, ACTIVITY
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


;Q10 effect from Neill et al., 2004
;Q10 effect (based on cownose rays) from Neer et al. 2007
 KQ10 = RQ; 2.33; Q10 value
 Tstress = Tamb - TacclR
 Q10func = KQ10^(Tstress/10.)
;PRINT, 'Q10func=', Q10func


Resp = RA * Weight^RB * TempFunc * fDOrm2 * ACTIVITY * OxyCal * Q10func ;units are J/g/d
;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
O2debt = RA * Weight^RB * TempFunc * (1. - fDOrm2) * Q10func * ACTIVITY * OxyCal

;IF (TLLcount GT 0.0) THEN BEGIN 
;;values are for adult walleye > 43mm (Rose et al. 1999)
;;For juvenile and adult walleye from the Wisconsin Bioenergetics Manual
;RA = 0.00261; number of g of O2 consumed by a 1g fish at RTO
;RB = -0.15; slope of the allometric mass function for standard metabolism
;RQ = 2.1; Q10 = the rate which the function increases over relatively low water temperature
;RTO = 27.0; optimum water temperature for respiration = respiration is highest
;RTM = 32.0; maximum (lethal) water temperature for respiration
;ACT = 2.0; multiplication factor

;;Temp function
;V[TLL] = (RTM - TacclR[TLL]) / (RTM - RTO); temp = acclimatized temp 
;natRQ = ALOG(RQ)
;Z = natRQ * (RTM - RTO)
;Y = natRQ * (RTM - RTO + 2.0)
;x = (Z^2.0 * (1.0 + (1.0 + 40.0 / Y)^0.5)^2.0) / 400.0
;TempFunc[TLL] = V[TLL]^X * EXP(X * (1.0 - V[TLL]))
;Resp[TLL] = RA * Weight[TLL]^RB * TempFunc[TLL] * fDOrm2[TLL] * Act * OxyCal * Q10func ;units are J/g/d
;;Resp = RA * W^RB * TempFunc * Act * OxyCal ;units are J/g/d without DO function
;ENDIF

;PRINT, 'Resp (J/g/d)'
;PRINT, Resp
;PRINT, 'TempFunc'
;PRINT, TempFunc
;PRINT, 'fDOrm2'
;PRINT, fDOrm2

Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight) ;puts units in terms of a J/6 min time interval
;PRINT, 'Resp (J/g)'
;PRINT, TRANSPOSE(Resp)

O2paied = FLTARR(nROG)
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

Respiration = FLTARR(3, nROG)
Respiration[0, *] = Resp
Respiration[1, *] = O2debt; new O2 debt
Respiration[2, *] = Oxydebt; total O2 debtPRINT, Respiration;


Resp = TRANSPOSE(Resp / 24.0 / 60.0 * ts * Weight) ;puts units in terms of a J/6 min time interval
;PRINT, 'Resp (J/g/ts)'
;PRINT, TRANSPOSE(Resp)
PRINT, 'ROGresp Ends Here'

RETURN, Respiration; TURN OFF WHEN TESTING
END