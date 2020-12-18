FUNCTION EMScmax, weight, length, nEMS, temp
; function to determine cmax for EMERALD SHINER

PRINT, 'EMScmax Begins Here'
;parameters required for the bioenergtics subroutine (From Hanson 1997)

; Temperature-dependent function for C 
; Parameter values from Arend et al. 2010
CA = 0.254; 0.36; 
CB = -0.275; -0.31;
CQ = 2.25; 2.3;
CTO = 25.;26.;
CTM = 30.;29.;
V_C = (CTM - Temp) / (CTM - CTO)
Z_C = ALOG(CQ) * (CTM - CTO)
Y_C = ALOG(CQ) * (CTM - CTO + 2.0)
X_C = (Z_C^2.0 * ((1.0 + (1.0 + 40.0 / Y_C)^0.5)^2.0)) / 400.0
fT = V_C^X_C * EXP(X_C * (1.0 - V_C)) 
;PRINT, 'ft'
;PRINT, ft

cmaxx = CA * weight^(CB) * fT
cmaxx = cmaxx * weight ; g/d
;PRINT, 'Cmax =', cmaxx ; g/d
;PRINT, 'CA =', CA, 'CB =', CB

PRINT, 'EMScmax Ends Here'
RETURN,  cmaxx
END