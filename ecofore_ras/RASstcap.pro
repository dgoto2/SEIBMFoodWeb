FUNCTION RASstcap, Weight, nRAS
;function to determine stomach capacity

PRINT, 'RASstcap Begins Here'

stcap = FLTARR(nRAS)
stcap = 0.029 * Weight; in mL = g for rainbow smelt by Lantry and Stuart. 
;PRINT, 'stcap'
;PRINT, stcap

PRINT, 'RASstcap Ends Here'
RETURN, stcap
END