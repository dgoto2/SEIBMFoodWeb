FUNCTION RASacclDO, DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, length, weight, nRAS, Oxydebt
; Dissolved oxygen acclimation (mg/l) for RAINBOW SMELT

PRINT, 'Rainbow Smelt DO Acclimation Begins Here'

; Parameter values
CTO = FLTARR(nRAS)
CTM = FLTARR(nRAS)
ACT = FLTARR(nRAS)
TL = WHERE(LENGTH LT 20., TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  CTO[TL] = 16.0; = CTO for YOY from the Wisconsin model parameters
  CTM[TL] = 21.0
  ACT[TL] = 2.2
ENDIF 
; values are for juvenile
TLL = WHERE((LENGTH GE 20.) AND (length LT 80.), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  CTO[TLL] = 14.0; = CTO 
  CTM[TLL] = 18.; 16.0
  ACT[TLL] = 3.
ENDIF
; values are for adult 
TLLL = WHERE((LENGTH GE 80.), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  CTO[TLLL] = 10.0; = CTO 
  CTM[TLLL] = 14.; 12.0
  ACT[TLLL] = 1.5
ENDIF

PredED = 3349.0; 
OxyCal = 13560.;

; Determine the critical DO level based on the fish’s acclimitized temperature
; DO accimation parameter values
DOint = 0.01; DO intercept
Tinfl = RANDOMU(seed, nRAS) * (MAX(CTM) - MIN(CTO)) + MIN(CTO);
Hill = 0.2; Hill parameter
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
respR = RASresp(Tamb, TacclR, Weight, length, ts, DOa, DOaccl0R, DOcritR, nRAS, Oxydebt); With acclimation temp for respiration
respC = RASresp(Tamb, TacclC, Weight, length, ts, DOa, DOaccl0C, DOcritC, nRAS, Oxydebt); With acclimation temp for consumption
;DO acclimation rate is a standard metabolic rate
racclR = respR[0, *] / Act / OxyCal / Weight * 1000.; in mg/L/TS
racclC = respC[0, *] / Act / OxyCal / Weight * 1000.


; Calculate DOaccl for respiration
DOacclR = FLTARR(nRAS)
DOacR1 = WHERE((DOa LE DOcritR) AND (DOa LE minDOacclR), DOacR1count); ambient DO level is less minDOaccl
IF (DOacR1count GT 0.0) THEN DOacclR[DOacR1] = minDOacclR[DOacR1]; 
DOacR2 = WHERE((DOa LE DOcritR) AND (DOa GT minDOacclR), DOacR2count); ambient DO level is between minDOaccl and DOcrit
IF (DOacR2count GT 0.0) THEN DOacclR[DOacR2] = DOa[DOacR2] + (DOaccl0R[DOacR2] - DOa[DOacR2]) * EXP(-racclR[DOacR2]);DOacclR[DOacR2];
DOacR3 = WHERE((DOa GT DOcritR), DOacR3count); ambient DO is greater than DOcrit
IF (DOacR3count GT 0.0) THEN DOacclR[DOacR3] = DOa[DOacR3]

; Calculate DOaccl for consumption
DOacclC = FLTARR(nRAS)
DOacC1 = WHERE((DOa LE DOcritC) AND (DOa LE minDOacclC), DOacC1count);
IF (DOacC1count GT 0.0)THEN DOacclC[DOacC1] = minDOacclC[DOacC1]; 
DOacC2 = WHERE((DOa LE DOcritC) AND (DOa GT minDOacclC), DOacC2count);
IF (DOacC2count GT 0.0)THEN DOacclC[DOacC2] = DOa[DOacC2] + (DOaccl0C[DOacC2] - DOa[DOacC2]) * EXP(-racclC[DOacC2]);DOacclC[DOacC2]; 
DOacC3 = WHERE((DOa GT DOcritC), DOacC3count);
IF (DOacC3count GT 0.0)THEN DOacclC[DOacC3] = DOa[DOacC3] 


; Calculate DO stress for respiration
DOstressR = FLTARR(nRAS)
DOacR4 = WHERE((DOa LE DOcritR) AND (DOa LT DOacclR), DOacR4count, complement = DOacR4c, ncomplement = DOacR4ccount)
IF (DOacR4count GT 0.0)THEN DOstressR[DOacR4] = DOa[DOacR4] - DOacclR[DOacR4] 
IF (DOacR4ccount GT 0.0)THEN DOstressR[DOacR4c] = 0.0

; Calculate DO stress for consumption
DOstressC = FLTARR(nRAS)
DOacC4 = WHERE((DOa LE DOcritC) AND (DOa LT DOacclC), DOacC4count, complement = DOacC4c, ncomplement = DOacC4ccount)
IF (DOacC4count GT 0.0)THEN DOstressC[DOacC4] = DOa[DOacC4] - DOacclC[DOacC4] 
IF (DOacC4ccount GT 0.0)THEN DOstressC[DOacC4c] = 0.0
;PRINT, 'Tstress '
;PRINT, TstressR, TstressC
;PRINT, 'DOcrit =', DOcritR, DOcritC
;PRINT, 'minDOaccl =', minDOacclR, minDOacclC
;PRINT, 'TacclR =', TacclR, 'TacclC =', TacclC


DOacclimation = FLTARR(11, nRAS)
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

PRINT, 'Rainbow Smelt DO Acclimation Ends Here'
RETURN, DOacclimation; TURN OFF WHEN TESTING
END