FUNCTION ROGstcap, weight, nROG
;function to determine stomach capacity

PRINT, 'ROGstcap Begins Here'
stcap = FLTARR(nROG)
;length=; in mm
; NEED TO FIND A FUNCTION FOR GOBY*****************
stcap = 0.0511 * Weight; in mL = g 
;PRINT, 'stcap'
;print, stcap
PRINT, 'ROGstcap Ends Here'
RETURN, stcap
END