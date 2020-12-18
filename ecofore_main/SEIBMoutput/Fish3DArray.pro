;FUNCTION FISH3DArray
PRO FISH3DArray; TURN OFF WHEN RUNNING A FULL MODEL

PRINT, 'FISH OUTPUT Files Begins Here'
tstart = SYSTIME(/seconds)

DOM = 17L; day 1 of simulations
counter = (DOM - 1L)
;PRINT, 'Counter', counter

SI = 50000L; number of superindividuals
pointer = SI * counter; 1st line to read in 

nYP = 50000L; *20L
nWAE = 50000L; *20L;
nEMS = 50000L; *20L;
nRAS = 50000L; *20L;
nROG = 50000L; *20L;

file1 = FILEPATH('HH_ON_DD_ON_Day__Rep_ONE_IDLoutputYEP_6.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
file2 = FILEPATH('HH_OFF_DD_OFF_DAY__Rep_TWO_IDLoutputWAE_4.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')
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
;Cchiro = InputArray1[51, *]
;FishWeight = InputArray1[2, *]
;GrowthWeight = InputArray1[62, *]
;
;;yl = InputArray[1, *]
;;Temp = InputArray[2, *]
;;DOam = InputArray[3, *]
;;DC = InputArray[4, *]
;;Zoop = InputArray[5, *]
;;uw = InputArray[6, *]
;;vw = InputArray[7, *]
;;ww = InputArray[8, *]
;;Light = InputArray[9, *]
;FREE_LUN, lun
;YP=InputArray1
;
;; Yellow perch's benthic consumption rate
;FishWeightNZ = where(FishWeight GT 0., FishWeightNZcount)
;Cchiro[FishWeightNZ] = Cchiro[FishWeightNZ]/FishWeight[FishWeightNZ]
;CchiroNZ = where(Cchiro GT 0., CchiroNZcount)
;AveCchiro = mean(Cchiro[CchiroNZ], /DOUBLE, /NAN)
;;print, AveCchiro
;
;; DAILY GROWTH
;GrowthWeight[FishWeightNZ] = GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ]
;GrowthWeightNZ = where(GrowthWeight[FishWeightNZ] GT 0., GrowthWeightNZcount)
;AveGrowthWeightYEP = mean(GrowthWeight[GrowthWeightNZ], /DOUBLE, /NAN)
;print, AveGrowthWeightYEP


; WALLEYE
OPENR, lun, file2, /GET_LUN
;POINT_LUN, lun, pointer; return to the previous stored location
SKIP_LUN, lun, pointer,/LINES
READF, lun, InputArray2
Cras = InputArray2[56, *]
FishWeight = InputArray2[2, *]
GrowthWeight = InputArray2[62, *]
FREE_LUN, lun
WAE=InputArray2
;
;; walleye's rainow smelt consumption rate
;FishWeightNZ = where(FishWeight GT 0., FishWeightNZcount)
;Cras[FishWeightNZ] = Cras[FishWeightNZ]/FishWeight[FishWeightNZ]
;CrasNZ = where(Cras GT 0., CemsNZcount)
;AveCras = mean(Cras[CrasNZ], /DOUBLE, /NAN)
;;print, AveCras
;
;; Daily growth
;;GrowthWeight[FishWeightNZ] = GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ]
;GrowthWeightNZ = where(GrowthWeight[FishWeightNZ]/FishWeight[FishWeightNZ] GT 0., GrowthWeightNZcount)
;AveGrowthWeightWAE = mean(GrowthWeight[GrowthWeightNZ], /DOUBLE, /NAN)
;PRINT, AveGrowthWeightWAE


;; EMERALD SHINER
;OPENR, lun, file3, /GET_LUN
;;POINT_LUN, lun, pointer; return to the previous stored location
;SKIP_LUN, lun, pointer,/LINES
;READF, lun, InputArray3
;FREE_LUN, lun
;EMS=InputArray3


; RAINBOW SMELT
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

;ARRAYS FOR BIOMASS
;PreyFish[0, YP[14, *]] = YP[0, *]*YP[2, *]; BIOMASS
;PreyFish[1, EMS[14, *]] = EMS[0, *]*EMS[2, *]; BIOMASS
;PreyFish[2, RAS[14, *]] = RAS[0, *]*RAS[2, *]; BIOMASS
;PreyFish[3, ROG[14, *]] = ROG[0, *]*ROG[2, *]; BIOMASS
PreyFish[4, WAE[14, *]] = WAE[0, *]*WAE[2, *]; BIOMASS
PRINT, TOTAL(PreyFish[4, WAE[14, *]])


;PRINT, 'ORIGINAL', TRANSPOSE(PREYFISH[0, 0:5000L])
;PRINT, 'BIG', TRANSPOSE(FISH2Dpre[0, 0:100L])
;PRINT, 'SMALL', TRANSPOSE(FISH2D[0, 0:500L])
t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60. 
PRINT, 'Reading FISH 3D OUTPUT Files Ends Here'

;RETURN, PREYFISH; TURN OFF WHEN TESTING
END