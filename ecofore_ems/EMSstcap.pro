FUNCTION EMSstcap, Weight, nEMS
;function to determine stomach capacity

PRINT, 'EMSstcap Begins Here'

stcap = FLTARR(nEMS)
stcap = 0.051 * Weight; in mL = g for rainbow smelt by Lantry and Stuart. 
;PRINT, 'stcap '
;PRINT, stcap

PRINT, 'EMSstcap Ends Here'
RETURN, StCap
END