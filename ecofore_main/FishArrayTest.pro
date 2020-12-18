
iday =181L
ihour = 15L; 
Grid3D = GridCells3D()
Grid2D2 = GridCells3D()
nGridcell = 77500L

TotBenBio = FLTARR(nGridcell) 
BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)

NewInput = EcoForeInputfiles(iday, TotBenBio, Grid3D)
NewInput = NewInput[*, 77500L * ihour : 77500L * ihour + 77499L]
TotBenBio = TotBenBio + NewInput[8, *]

nYP = 10000L
nEMS = 10000L;
nRAS = 10000L;
nROG = 10000L;
nWAE = 10000L;
NpopYP = 50000000L
NpopEMS = 50000000L
NpopRAS = 50000000L
NpopROG = 50000000L
NpopWAE = 50000000L
YP = YEPinitial(NpopYP, nYP, TotBenBio, NewInput); FISHARRY PARAMETER
EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, NewInput); FISHARRY PARAMETER
RAS = RASinitial(NpopRAS, nRAS, TotBenBio, NewInput); FISHARRY PARAMETER
ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput); FISHARRY PARAMETER
WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, NewInput); FISHARRY PARAMETER
;******************************************************************************************************************************
FOR I=0,10 DO PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
                               
;PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
;PRINT, PreyFish

END