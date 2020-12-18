
iyear = 1987L
iday = 152L
n1D = 8832L; starts on Apr-15 and ends on Oct-15 in the input files
n1DLight = 26496L; light inputs are already subdaily
nVerLay = 48L; the number of vertical layers
TotBenBio = FLTARR(nVerLay)
Depthlayer =  INDGEN(nVerLay)
;DEPTHlayer = Depthlayer # REPLICATE(1., n1D/48)
Envir1D2 = FLTARR(12L, n1D)
LightEnvir1D2 = FLTARR(5L, n1DLight)
Envir1D3 = FLTARR(16L, nVerLay)
zoopl = FLTARR(nVerLay)
gzLight = FLTARR(nVerLay)
fMODzTemp = FLTARR(nVerLay)
TotalLightTemp = FLTARR(nVerLay)
Pz = FLTARR(nVerLay)
GrowthRate = FLTARR(nVerLay); for daily inputs
GrowRateHabitat = FLTARR(nVerLay)
Prod = FLTARR(nVerLay)

  IF iDAY EQ 152L THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
    BottomCell = WHERE(DEPTHlayer[0:47] EQ 47L, BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
    IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
    ; Read a daily environmental input
     Envir1d = EcoFore1DInputFiles(iYear, iDay, TotBenBio) 
     LightEnvir1d = EcoFore1DLightInputFiles(iYear) 
  ENDIF ELSE TotBenBio = TotBenBio
;    PRINT, 'TotBenBio'
;    PRINT, TotBenBio[0:47]
  
    tstart3 = SYSTIME(/seconds)
  
    ; Call only a daily input from a yearly input read from the file
    iDayPointer = iDay - 105L; First DOY for the simulation - DOY105 =~April 15 (the fisrt day in the input files), DOY152 = ~June 1
    Envir1D2 = Envir1D[*, 48L * iDayPointer : 48L * iDayPointer + 47L]; 48 vertical layers
    ;PRINT, 'Daily Input'
    ;PRINT,  (Envir1d2)
   
    ; Update total benthic biomass every day 
    ; Re-assign benthic carbon inputs
    CARBON = Envir1D2[4, *]
    IF BottomCellcount GT 0. THEN CARBON[BottomCell] = CARBON[BottomCell] 
    IF NonBottomCellcount GT 0. THEN CARBON[NonBottomCell] = 0.      
    ; Carbon-based daily grwoth rate function from Goedkoope et al. 2007, CJFAS, vol 64, pp.425-
    DCNZ = WHERE(CARBON GT 0., DONZcount, complement = DCZ, ncomplement = DCZcount); ONLY WHEN DC IS POSITIVE...
    ;IF DONZcount GT 0. THEN GrowthRate[DCNZ] = 0.1021 * ALOG(CARBON[DCNZ]*1000.) + 0.6422; /d
    GrowthRate[dcnz] = 0.1021 * ALOG(CARBON[dcnz]*1000.) + 0.6422; /d
    
    ; Carbon-based benthic habitat quality is determined daily 
    GrowRateHabitat = 1.;GrowthRate/MAX(GrowthRate) 
    ; Calculate production in g/d 
    r = 0.0175; r is the growth rate (/d)
    p = 0.25; p a term that accounts for the variation that occurs in benthic macros-> should be temp-dependent (determined by DOY?)
    ;q = FLTARR(n);q is a habitat quality value ranges from 0.1-1
    ;q = RANDOMU(seed, n) + 0.1
    ;qtb = WHERE(q GT 1.0, qtbcount, complement = qtbc, ncomplement = qtbccount)
    ;IF qtbcount GT 0.0 THEN q[qtb] = 1.0 
    
    Bmax = 6.679; MAX(TotBenBio); 1500000.; Bmax = the maximum production; 6 g/m^2 or 1500000 g/km^2    
    IF BottomCellcount GT 0. THEN Prod[BottomCell] = r * (1.0 + p * SIN((2.0 * !Pi * iDAY) / 365.0)) $
                                           * (1 - (TotBenBio[BottomCell]/(GrowRateHabitat[BottomCell] * Bmax))) * TotBenBio[BottomCell] 
    IF NonBottomCellcount GT 0. THEN Prod[NonBottomCell] = 0.
    ;PRINT, 'Chironomid production'
    ;PRINT, Prod[BottomCell];[0:47]

    TotBenBio = TotBenBio + Envir1d2[8, *]; DONE ONLY ONCE AT THE BEGINNING OF THE DAY
   

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

YP = YEPinitial(NpopYP, nYP, TotBenBio, envir1d3, nVerLay)  
WAE = WAEinitial1D(NpopWAE, nWAE, TotBenBio, envir1d3, nVerLay)  
RAS = RASinitial(NpopRAS, nRAS, TotBenBio, envir1d3, nVerLay)  
EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, envir1d3, nVerLay)  

;******************************************************************************************************************************
PRINT, TRANSPOSE(YP[14, *])
;FOR I=0,10 DO PreyFish = FishArray1D(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nVerLay)
                               
;PreyFish = FishArray1D(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nVerLay)
;PRINT, PreyFish

END