;function to determine feeding day
FUNCTION RAS1stfeed, DVy, DOa, nRAS

PRINT, 'RAS1stfeed Begins Here'
;develpment relationship from Rose et al. 1999
;YEPtemp = [15, 15, 15]
;T = 20.0
;DOa = [6, 5, 5]
;nYP = 3
;DVy = fltarr(nYP); daily fractional development toward feeding

;v = where((T GE YEPtemp) OR (DV GT 0.0), vcount, complement = vv, ncomplement = vvcount)
;FOR i = 0, 12 DO BEGIN
DVy = DVy + 0.333;  1.0/(145.7 + 2.56 * T[v] - 63.8 * alog(T[v]))
;IF vvcount GT 0.0 THEN DV[vv] = DV[vv]
PRINT, 'DV =', DVy

; DO effect on development
DOfunc = (0.6073 * alog(DOa) + 0.0165); based on scale carp
DVy = DVy*(DOfunc)

PRINT, 'DOfunc =', DOfunc
PRINT, 'DVy =', DVy
;ENDFOR
RETURN,  DVy

END