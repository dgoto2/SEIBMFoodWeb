FUNCTION YEPstcap, weight, nYP
;function to determine stomach capacity

PRINT, 'YEPstcap Begins Here'

;---FOR TESTING FORAGING----------------------------------
;nYP = 50L
;Weight = fltarr(nYP)
;YP = YPinitial()
;weight = YP[1, *]
;--------------------------------------------------------------

Stcap = FLTARR(nYP)
Stcap = 0.0511 * Weight; Arend
;PRINT, 'stcap'
;PRINT, TRANSPOSE(stcap)

PRINT, 'YEPstcap Ends Here'
RETURN, Stcap
END
