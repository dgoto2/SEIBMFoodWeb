FUNCTION FISH2DArray

;PRO FISH2DArray; TURN OFF WHEN RUNNING A FULL MODEL
; To create horizontal 2D output arrays

PRINT, 'FISH 2D OUTPUT Files Begins Here'
tstart = systime(/seconds)

DOM = 15L; day 1 of simulations
counter = (DOM - 1L) 
;PRINT, 'Counter', counter

nYP = 50000L
nWAE = 50000L;
nEMS = 50000L;
nRAS = 50000L;
nROG = 50000L;

SI = 50000L; NUMBER OF SUPERINDIVIDUALS
pointer = SI * counter; 1st line to read in 

pointer1 = nYP * counter; 1st line to read in
pointer2 = nWAE * counter; 1st line to read in
pointer3 = nEMS * counter; 1st line to read in
pointer4 = nRAS * counter; 1st line to read in
pointer5 = nROG * counter; 1st line to read in

file1 =FILEPATH('HH_ON_DD_ON_Day__Rep_ONE_IDLoutputYEP_6.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
file2 = FILEPATH('HH_ON_DD_ON_Night__Rep_TWO_IDLoutputWAE_1.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
file3 = FILEPATH('HH_ON_DD_ON_Day__Rep_ONE_IDLoutputEMS_1.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
file4 = FILEPATH('HH_ON_DD_ON_Day__Rep_ONE_IDLoutputRAS_5.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
file5 = FILEPATH('HH_ON_DD_ON_Night__Rep_TWO_IDLoutputROG_1.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')

;FISHPREY = FISHARRAY()
; Number of state variables = 70
InputArray1 = FLTARR(70L, nYP)
InputArraY2 = FLTARR(70L, nWAE)
InputArray3 = FLTARR(70L, nEMS)
InputArray4 = FLTARR(70L, nRAS)
InputArray5 = FLTARR(70L, nROG)

;; YELLOW PERCH
;OPENR, lun, file1, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray1
;FREE_LUN, lun
;YP=InputArray1

; WALLEYE
OPENR, lun, file2, /GET_LUN
;POINT_LUN, lun, pointer; return to the previous stored location
SKIP_LUN, lun, pointer,/LINES
READF, lun, InputArray2
FREE_LUN, lun
WAE=InputArray2


; EMERALD SHINER
;OPENR, lun, file3, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray3
;FREE_LUN, lun
;EMS=InputArray3


;; RAINBOW SMELT
;OPENR, lun, file4, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray4
;FREE_LUN, lun
;RAS=InputArray4


;; ROUND GOBY
;OPENR, lun, file5, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray5
;FREE_LUN, lun
;ROG=InputArray5


nGridcell = 77500L
FISH2Dpre = (FLTARR(5, nGridcell))
FISH2D = (FLTARR(5, 3875L))
;PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
;Zplkn = FLTARR(20); 1 = top layer; 20 = bottom layer

PreyFish = FLTARR(5L, nGridcell)
;FISHCellIDcount = FLTARR(5L, nGridcell)

; ARRAYS FOR ABUNDANCE
;PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;PreyFish[1, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;PreyFish[2, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;PreyFish[3, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;PreyFish[4, WAE[14, *]] = WAE[0, *]; ABUNDANCE

; ARRAYS FOR BIOMASS
;PreyFish[0, YP[14, *]] = YP[0, *]*YP[2, *]; BIOMASS
;PreyFish[1, EMS[14, *]] = EMS[0, *]*EMS[2, *]; BIOMASS
;PreyFish[2, RAS[14, *]] = RAS[0, *]*RAS[2, *]; BIOMASS
;PreyFish[3, ROG[14, *]] = ROG[0, *]*ROG[2, *]; BIOMASS
PreyFish[4, WAE[14, *]] = WAE[0, *]*WAE[2, *]; BIOMASS


jv = 19L
FOR iv = 0L, nGridcell - 1L DO BEGIN
  ; Calculate cumulative biomass for each horizontal cell
  FISH2Dpre[0, iv] = TOTAL(PreyFish[0, iv : jv])
  FISH2Dpre[1, iv] = TOTAL(PreyFish[1, iv : jv])
  FISH2Dpre[2, iv] = TOTAL(PreyFish[2, iv : jv])
  FISH2Dpre[3, iv] = TOTAL(PreyFish[3, iv : jv])
  FISH2Dpre[4, iv] = TOTAL(PreyFish[4, iv : jv])
 
  iv = jv
  jv = jv + 20L
ENDFOR

;FISH2Dloc1 = WHERE(FISH2Dpre[0, *] GT 0., FISH2Dloc1count)
;PRINT, FISH2Dloc1

;FISH2Dloc1B = WHERE(FISH2Dpre[0, FISH2Dloc1] GT 0., FISH2Dloc1Bcount)
;PRINT, FISH2Dloc1B

; YELLOW PERCH
;FISH2D[0, *] = FISH2Dpre[0, 0:77499L:20L]
;PRINT, TRANSPOSE(FISH2D[0, *])

; EMERALD SHINER
;FISH2D[1, *] = FISH2Dpre[1, 0:77499L:20L]
;PRINT, TRANSPOSE(FISH2D[1, *])

; RAINBOW SMELT
;FISH2D[2, *] = FISH2Dpre[2, 0:77499L:20L]
;PRINT, TRANSPOSE(FISH2D[2, *])

; ROUND GOBY
;FISH2D[3, *] = FISH2Dpre[3, 0:77499L:20L]
;PRINT, TRANSPOSE(FISH2D[3, *])

;WALLEYE
FISH2D[4, *] = FISH2Dpre[4, 0:77499L:20L]
PRINT, TRANSPOSE(FISH2D[4, *])

;PRINT, 'ORIGINAL', TRANSPOSE(PREYFISH[0, 0:5000L])
;PRINT, 'BIG', TRANSPOSE(FISH2Dpre[0, 0:100L])
;PRINT, 'SMALL', TRANSPOSE(FISH2D[0, 0:500L])
t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading FISH 2D OUTPUT Files Ends Here'

RETURN, FISH2D
END