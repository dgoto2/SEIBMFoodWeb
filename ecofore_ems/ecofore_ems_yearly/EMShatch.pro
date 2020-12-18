;function to determine hatch day
FUNCTION waehatch, dv, T, wtemp, nw

;develpment relationship from Rose et al. 1999
wtemp = [7,8,11]
t = 10.0
nW = 3.0

DV = fltarr(nW)
v = where(t gt wtemp or dv gt 0.0, vcount, complement=vv, ncomplement=vvcount)
IF vcount GT 0.0 then begin
  DV[v] = DV[v] + 1 / (57.1 * EXP(-T[v] / 18.9) - 15.4)
endif
IF vvcount GT 0.0 then DV[vv] = DV[vv]

;PRINT, DV 
RETURN,  DV

END

;function to determine hatch day
FUNCTION YPhatch, DV, YEPtemp, T, DOa, nYP
;PRO YPhatch, DV, YEPtemp, T, DOa, nYP

PRINT, 'YPhatch Begins Here'
;develpment relationship from Rose et al. 1999
;YEPtemp = [15, 14, 13]
;T = 20.0
;nYP = 3
;DV = fltarr(nYP); daily fractional development toward hatching


v = where((T GE YEPtemp) OR (DV GT 0.0), vcount, complement = vv, ncomplement = vvcount)
;FOR i = 0, 150 DO BEGIN
IF vcount GT 0.0 THEN DV[v] = DV[v] + (1.0/(145.7 + 2.56 * T[v] - 63.8 * alog(T[v])))/24L
IF vvcount GT 0.0 THEN DV[vv] = DV[vv]
;PRINT, 'DV =', DV

; DO effect on egg development
;DOfuncHatch = (0.6073 * alog(DOa) + 0.0165); based on scale carp
;DV = DV*(DOfuncHatch)


;ENDFOR
;PRINT, 'DOfuncHatch =', DOfuncHatch, 'DV =', DV

;u = where(dv gt 0, ucount)
;if ucount gt 0 then dv[u]=1.1

PRINT, 'DV =', DV
RETURN,  DV

END
