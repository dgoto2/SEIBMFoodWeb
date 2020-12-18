FUNCTION WAEacclDO, DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, length, weight, nWAE, Oxydebt
; Dissolved oxygen acclimation (mg/l) for walleye

PRINT, 'WAEacclDO Begins Here'

; Parameter values from the Wisconsin Bioenergetics Model manual
ACT = FLTARR(nWAE)
PredED = FLTARR(nWAE)
CTO = FLTARR(nWAE)
CTM = FLTARR(nWAE)

;For larval and juvenile walleye 
TL = WHERE(length LT 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ACT[TL] = 3.2
  PredED[TL] = 3349.0
  CTO[TL] = 25.0
  CTM[TL] = 28.0
ENDIF 

;values are for adult walleye
IF (TLLcount GT 0.0) THEN BEGIN 
  ACT[TLL] = 4.8
  PredED[TLL] = 4283.0
  CTO[TLL] = 22.0
  CTM[TLL] = 28.0
ENDIF
OxyCal = 13560.0;


; Determine the critical DO level based on the fish’s acclimitized temperature
; DO accimation parameter values estimated through calibration
DOint = 0.01; 0.8; DO intercept
Tinfl = RANDOMU(seed, nWAE) * (MAX(CTM) - MIN(CTO)) + MIN(CTO); 28.(inflection temp for bluegill)
Hill = 2.; 1.5; Hill parameter
TratioR = TacclR / Tinfl
TratioC = TacclC / Tinfl
TstressR = Tamb - TacclR; 0 if acclimated to ambient temp
TstressC = Tamb - TacclC; 0 if acclimated to ambient temp

; Calculate acclimated temperature-dependent critical DO and minimal acclimation DO levels
DOcritR = (DOint + (TratioR^Hill / (1.0 + TratioR^Hill)) * (1.0 - 0.005 * TstressR^2.0) * 5.2) > 0.
DOcritC = (DOint + (TratioC^Hill / (1.0 + TratioR^Hill)) * (1.0 - 0.005 * TstressC^2.0) * 5.2) > 0.
minDOacclR = 0.45 * DOcritR
minDOacclC = 0.45 * DOcritC


; Calculate DO acclimation rates using respiration rates
respR = WAEresp(Tamb, TacclR, Weight, length, ts, DOa, DOaccl0R, DOcritR, nWAE, Oxydebt); with acclimation temp for respiration
respC = WAEresp(Tamb, TacclC, Weight, length, ts, DOa, DOaccl0C, DOcritC, nWAE, Oxydebt); with acclimation temp for consumption
;DO acclimation rate is a standard metabolic rate
racclR = respR[0, *] / Act / OxyCal / Weight * 1000.; in mg/L/TS
racclC = respC[0, *] / Act / OxyCal / Weight * 1000.


; Calculate DOaccl with respiration tempearture
DOacclR = FLTARR(nWAE)
DOacR1 = WHERE((DOa LE DOcritR) AND (DOa LE minDOacclR), DOacR1count); ambient DO level is less minDOaccl
IF (DOacR1count GT 0.0) THEN DOacclR[DOacR1] = minDOacclR[DOacR1]; 
DOacR2 = WHERE((DOa LE DOcritR) AND (DOa GT minDOacclR), DOacR2count); ambient DO level is between minDOaccl and DOcrit
IF (DOacR2count GT 0.0) THEN DOacclR[DOacR2] = DOa[DOacR2] + (DOaccl0R[DOacR2] - DOa[DOacR2]) * EXP(-racclR[DOacR2]);DOacclR[DOacR2];
DOacR3 = WHERE((DOa GT DOcritR), DOacR3count); ambient DO is greater than DOcrit
IF (DOacR3count GT 0.0) THEN DOacclR[DOacR3] = DOa[DOacR3]

; Calculate DOaccl with consumption temperature
DOacclC = FLTARR(nWAE)
DOacC1 = WHERE((DOa LE DOcritC) AND (DOa LE minDOacclC), DOacC1count);
IF (DOacC1count GT 0.0) THEN DOacclC[DOacC1] = minDOacclC[DOacC1]; 
DOacC2 = WHERE((DOa LE DOcritC) AND (DOa GT minDOacclC), DOacC2count);
IF (DOacC2count GT 0.0) THEN DOacclC[DOacC2] = DOa[DOacC2] + (DOaccl0C[DOacC2] - DOa[DOacC2]) * EXP(-racclC[DOacC2]);DOacclC[DOacC2]; 
DOacC3 = WHERE((DOa GT DOcritC), DOacC3count);
IF (DOacC3count GT 0.0) THEN DOacclC[DOacC3] = DOa[DOacC3] 


; Calculate DO stress for respiration
DOstressR = FLTARR(nWAE)
DOacR4 = WHERE((DOa LE DOcritR) AND (DOa LT DOacclR), DOacR4count, complement = DOacR4c, ncomplement = DOacR4ccount)
IF (DOacR4count GT 0.0) THEN DOstressR[DOacR4] = DOa[DOacR4] - DOacclR[DOacR4] 
IF (DOacR4ccount GT 0.0) THEN DOstressR[DOacR4c] = 0.0

; Calculate DO stress for consumption
DOstressC = FLTARR(nWAE)
DOacC4 = WHERE((DOa LE DOcritC) AND (DOa LT DOacclC), DOacC4count, complement = DOacC4c, ncomplement = DOacC4ccount)
IF (DOacC4count GT 0.0) THEN DOstressC[DOacC4] = DOa[DOacC4] - DOacclC[DOacC4]
IF (DOacC4ccount GT 0.0) THEN DOstressC[DOacC4c] = 0.0

;PRINT, 'Tstress '
;PRINT, TstressR, TstressC
;PRINT, 'DOcrit =', DOcritR, DOcritC
;PRINT, 'minDOaccl =', minDOacclR, minDOacclC
;PRINT, 'TacclR =', TacclR, 'TacclC =', TacclC


DOacclimation = FLTARR(11, nWAE)
DOacclimation[0,*] = DOacclR
DOacclimation[1,*] = DOacclC
DOacclimation[2,*] = DOstressR
DOacclimation[3,*] = DOstressC
DOacclimation[4,*] = DOcritR
DOacclimation[5,*] = DOcritC
DOacclimation[6,*] = minDOacclR
DOacclimation[7,*] = minDOacclC
DOacclimation[8,*] = DOa
DOacclimation[9,*] = DOaccl0R
DOacclimation[10,*] = DOaccl0C
;PRINT, 'DOacclimation'
;PRINT, DOacclimation

PRINT, 'WAEacclDO Ends Here'
RETURN, DOacclimation; TURN OFF WHEN TESTING
END