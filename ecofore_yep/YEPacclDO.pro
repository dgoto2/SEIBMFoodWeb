FUNCTION YEPacclDO, DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, length, weight, nYP, Oxydebt
; Dissolved oxygen acclimation (mg/l) for yellow perch

PRINT, 'YEPacclDO Begins Here'

; Parameter values from the Wisconsin Bioenergetics Model manual
; For Larval yellow perch 
ACT = FLTARR(nYP)
PredED = FLTARR(nYP)
CTO = FLTARR(nYP)
CTM = FLTARR(nYP)

TL = WHERE(length LE 20.0, TLcount)
IF (TLcount GT 0.0) THEN BEGIN
  ACT[TL] = 1.; 4.4
  PredED[TL] = 2512.0;
  CTO[TL] = 29.0
  CTM[TL] = 32.0
ENDIF
; values are for juvenile yellow perch
TLL = WHERE((LENGTH GE 20.) AND (length LT 100.), TLLcount)
IF (TLLcount GT 0.0) THEN BEGIN 
  ACT[TLL] = 1.6
  PredED[TLL] = 4186.0;
  CTO[TLL] = 29.0
  CTM[TLL] = 32.0
ENDIF
;values are for adult yellow perch
TLLL = WHERE((LENGTH GE 100.), TLLLcount)
IF (TLLLcount GT 0.0) THEN BEGIN 
  ACT[TLLL] = 1.6
  PredED[TLLL] = 4186.0;
  CTO[TLLL] = 23.0
  CTM[TLLL] = 28.0
ENDIF
OxyCal = 13560.0;

; Determine the critical DO level based on the fish’s acclimitized temperature
; DO accimation parameter values 
DOint = 0.8; DO intercept
Tinfl = RANDOMU(seed, nYP) * (MAX(CTM) - MIN(CTO)) + MIN(CTO); 28.0; inflection temp for bluegill
Hill = 3.0; Hill parameter
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
respR = YEPresp(Tamb, TacclR, Weight, length, ts, DOa, DOaccl0R, DOcritR, nYP, Oxydebt); With acclimation temp for respiration
respC = YEPresp(Tamb, TacclC, Weight, length, ts, DOa, DOaccl0C, DOcritC, nYP, Oxydebt); With acclimation temp for consumption
;DO acclimation rate is a standard metabolic rate
racclR = respR[0, *] / Act / OxyCal / Weight * 1000.; in mg/L/TS
racclC = respC[0, *] / Act / OxyCal / Weight * 1000.


; Calculate DOaccl with respiration tempearture
DOacclR = FLTARR(nYP)
DOacR1 = WHERE((DOa LE DOcritR) AND (DOa LE minDOacclR), DOacR1count); ambient DO level is less minDOaccl
IF (DOacR1count GT 0.0) THEN DOacclR[DOacR1] = minDOacclR[DOacR1]; 
DOacR2 = WHERE((DOa LE DOcritR) AND (DOa GT minDOacclR), DOacR2count); ambient DO level is between minDOaccl and DOcrit
IF (DOacR2count GT 0.0) THEN DOacclR[DOacR2] = DOa[DOacR2] + (DOaccl0R[DOacR2] - DOa[DOacR2]) * EXP(-racclR[DOacR2]);DOacclR[DOacR2];
DOacR3 = WHERE((DOa GT DOcritR), DOacR3count); ambient DO is greater than DOcrit
IF (DOacR3count GT 0.0) THEN DOacclR[DOacR3] = DOa[DOacR3]

; Calculate DOaccl for consumption temperature
DOacclC = FLTARR(nYP)
DOacC1 = WHERE((DOa LE DOcritC) AND (DOa LE minDOacclC), DOacC1count);
IF (DOacC1count GT 0.0)THEN DOacclC[DOacC1] = minDOacclC[DOacC1]; 
DOacC2 = WHERE((DOa LE DOcritC) AND (DOa GT minDOacclC), DOacC2count);
IF (DOacC2count GT 0.0)THEN DOacclC[DOacC2] = DOa[DOacC2] + (DOaccl0C[DOacC2] - DOa[DOacC2]) * EXP(-racclC[DOacC2]);DOacclC[DOacC2]; 
DOacC3 = WHERE((DOa GT DOcritC), DOacC3count);
IF (DOacC3count GT 0.0)THEN DOacclC[DOacC3] = DOa[DOacC3] 


; Calculate DO stress for respiration
DOstressR = FLTARR(nYP)
DOacR4 = WHERE((DOa LE DOcritR) AND (DOa LT DOacclR), DOacR4count, complement = DOacR4c, ncomplement = DOacR4ccount)
IF (DOacR4count GT 0.0) THEN DOstressR[DOacR4] = DOa[DOacR4] - DOacclR[DOacR4] 
IF (DOacR4ccount GT 0.0) THEN DOstressR[DOacR4c] = 0.0

; Calculate DO stress for consumption
DOstressC = FLTARR(nYP)
DOacC4 = WHERE((DOa LE DOcritC) AND (DOa LT DOacclC), DOacC4count, complement = DOacC4c, ncomplement = DOacC4ccount)
IF (DOacC4count GT 0.0) THEN DOstressC[DOacC4] = DOa[DOacC4] - DOacclC[DOacC4] 
IF (DOacC4ccount GT 0.0) THEN DOstressC[DOacC4c] = 0.0
;PRINT, 'Tstress '
;PRINT, TstressR, TstressC
;PRINT, 'DOcrit =', DOcritR, DOcritC
;PRINT, 'minDOaccl =', minDOacclR, minDOacclC
;PRINT, 'TacclR =', TacclR, 'TacclC =', TacclC


;*******************May need later***************************************************************************
;2.  How much the temperature-determined critical DO level can be adjusted by the ambient
; DO level (DOadj); i.e., an ambient DO level below the critical DO level can drive
; acclimation of the critical DO level to be slightly lower than based on temperature alone.
 
   ;IF (DOa GT DOcritT) THEN DOaccl0 = DOa ELSE $
   ;IF (DOa LT DOcritT) AND (DOa LT minDOaccl) THEN DOaccl0 = minDOaccl ELSE $
   ;IF (DOa LT DOcritT) AND (DOa GT minDOaccl) THEN DOaccl0 = DOa  
   ;print, DOaccl0
   ;Doaccl0 = fltarr(nYP)
   ;DOaccl0 = max(min(DOa, DOcritT), minDOaccl)

   ;DOadj=0.45*(DOa-DOcritT)ELSE DOadj=0.0; no acclimation
   ;fish weight effect???
   
;3.  The new minimum critical level of DO (DOcritDO), based on the ambient DO-adjusted DOcritT
; this is what is used to drive acclimation (similar to Ta for temperature acclimation)
  ;DOcritDO = DOcritT + DOadj
;Might need to add a statement that limits DOcritDO to being greater than or equal to 2.0 mg•L-1

;Ambient DO is less than LOC, respiration becomes DO-dependent-> swimming, digestion, and growth
  ;DOc = where((DOaccl0 GE minDOaccl) AND (DOaccl0 LE DOcritT), DOccount, complement = p, ncomplement = pcount)

;4.  Acclimated critical DO level of the fish -> Change DOaccl0 to DOa???
;5.  fDO will now be calculated based on DOcritaccl
  ;hypothetical fucntion based on the general concept of fish physiological processes in reponse to stress
  ;IF DOa LT DOcritaccl THEN fDO=1/(1+exp(-1.1972*DOcritaccl+6.5916)) ELSE fDO=1.0; from Luo et al. 2001
  ;
;6.  The stress the fish experiences (DOstress) by being at DOa < DOcritaccl
  ;IF DOa LT DOcritaccl THEN DOstress=(DOa-DOcritaccl)/DOcritaccl ELSE DOstress=0.0

;7.  Accumulation of stress over time (DOdose), as fish remains at DOa < DOcritaccl, 
  ;and loss of stress over time, after fish moves to DOa >= DOcritaccl
  ;IF DOa LT DOcritaccl THEN DOdose = DOdose - 0.1 * DOstress * ts; DOdose=DOdose(t-1) +0.1*DOstress(t)   
  ;IF (DOstress LT -2.3) THEN DOdose = DOdose - 0.025 * DOstress*60*ts ELSE 0
  ;each time step = 6min. for bluegill from Neil et al. 2004 
  ;IF DOdose LE -1.0 THEN DOdose = -1.0 
  ;IF DOa GE DOcritaccl THEN DOdose = DOdose - 0.09 * DOdose*ts; DOdose=DOdose(t-1)-0.09*(DOdose(t-1)) 

;8.  DO function for consumption/foraging (fDOdose) adjusted by DOdoes, ranges 0 -> 1
  ;fDOdose = fDO * (DOdose + 1.0)
;****************************************************************************************************************


DOacclimation = FLTARR(11, nYP)
DOacclimation[0, *] = DOacclR
DOacclimation[1, *] = DOacclC
DOacclimation[2, *] = DOstressR
DOacclimation[3, *] = DOstressC
DOacclimation[4, *] = DOcritR
DOacclimation[5, *] = DOcritC
DOacclimation[6, *] = minDOacclR
DOacclimation[7, *] = minDOacclC
DOacclimation[8, *] = DOa
DOacclimation[9, *] = DOaccl0R
DOacclimation[10, *] = DOaccl0C
;PRINT, 'DOacclimation'
;PRINT, DOacclimation

PRINT, 'YEPacclDO Ends Here'
RETURN, DOacclimation; TURN OFF WHEN TESTING
END