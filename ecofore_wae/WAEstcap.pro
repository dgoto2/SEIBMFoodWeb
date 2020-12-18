FUNCTION WAEstcap, length, nWAE
;function to determine stomach capacity

PRINT, 'WAEstcap Begins Here'

stcap = FLTARR(nWAE)
stcap = 0.00000556 * length^2.56; in mL = g for adult walleye 
;from Knight and Marglef North American Journal of Fisheries Management 1982; 2: 413-414 
;PRINT, 'stcap =', stcap

PRINT, 'WAEstcap Ends Here'
RETURN, stcap
END