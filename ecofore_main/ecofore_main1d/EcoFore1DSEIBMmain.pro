PRO EcoFore1DSEIBMmain; *Lake Erie Spatially Explicit 1D Indiviudal-Based Models for walleye (WAE), 
; yellow perch (YEP), Ranbow Smelt (RAS), Round Goby (ROG), and Emerald Shiner (EMS).
; *Retrospective simulations using input data are calibrated for 1987-2005.


;*****Complete population and community structure for simulations*********
; In Lake Erie (from Great Lakes Fishery Commission Report for 2005),
; 7 age classes for yellow perch: 0, 1, 2, 3, 4, 5, and 6+.
; 8 age classes for walleye: 0, 1, 2, 3, 4, 5, 6, and 7+
; 2 age classes for rainbow smelt: 0 and 1+
; 2 age classes for emerald shiner: 0 and 1+
; 2 age classes for round goby: 0 and 1+***No goby in the 1D model for now
;*************************************************************************


; Time steps of simulations
ts = 10L ; minutes in a time step (***Also adjust vertcal swimming speeds)
td = (60L/ts)*24L ; number of time steps in a day


; Total number of superindividuals in each cohort
nYP = 5000L ; number of YEP superindividuals(SIs)
nWAE = 5000L; number of WAE SIs
nRAS = 5000L; number of RAS SIs
nEMS = 5000L; number of EMS SIs
nROG = 5000L; number of ROG SIs


; INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE -> Initial population structure is the same for all years
;Average population size and age structure of 1987 to 2005 from the Great Lakes Fishery Commision
; In the 1D model, the modeled area is 1/10 the central basin (the deep area with depth >22m)
NpopYP = (63100113D + 63094688D + 42385526D + 27474684D + 14546579D + 6125632D + 5148263D) / 10.; number of YEP individuals
NpopWAE = (43802588D + 20273400D + 20487075D + 13402057D + 8288478D + 6357357D + 4085837D + 6654389D) / 70. ; number of WAE individuals
NpopRAS = (936417969D + 315245781D) * 2. ; / 10.; number of RAS individuals
NpopEMS = (359701719D + 244105625D) * 2.; / 10. ; number of EMS individuals
;NpopROG = (201138333D + 260038333D) / 10.; number of ROG individuals
;PRINT, NpopYP 
;PRINT, NpopWAE 
;PRINT, NpopRAS
;PRINT, NpopEMS 
;PRINT, NpopROG


n1D = 12000L; 9216L; 8832L; starts on Apr-15 and ends on Nov-15 in the input files
n1DLight = 30984L; light inputs are already subdaily
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

gzLight = FLTARR(nVerLay)
posGZL = FLTARR(nVerLay)
STDgzLight = FLTARR(nVerLay)
fMODzTemp = FLTARR(nVerLay)
TotalLightTemp = FLTARR(nVerLay)
PzS = FLTARR(nVerLay)
PzM = FLTARR(nVerLay)
PzL = FLTARR(nVerLay)

YPpbio = FLTARR(45, nYP)
WAEpbio = FLTARR(45, nWAE)
RASpbio = FLTARR(35, nRAS)
EMSpbio = FLTARR(35, nEMS)
;ROGpbio = FLTARR(35, nROG)

YEPPreyEaten = FLTARR(5, 5000L)
WAEPreyEaten = FLTARR(5, 5000L)

;; Daily fractional development toward hatching
;yDV = FLTARR(nYP) ; determines when individual yellow perch hatch
;wDV = FLTARR(nWAE) ; determines when individual walleye hatch
;rDV = FLTARR(nRAS) ; determines when individual rainbow smelt hatch
;wDV = FLTARR(nEMS) ; determines when individual emerald shiner hatch
;roDV = FLTARR(nROG) ; determines when individual round goby hatch


;; Daily fractional development toward 1st feeding
;yDVy = FLTARR(nYP) ; determines when individual yellow perch feed
;wDVy = FLTARR(nWAE) ; determines when individual walleye feed
;rDVy = FLTARR(nRAS) ; determines when individual rainbow smelt feed 
;wDVy = FLTARR(nEMS) ; determines when individual emerald shiner feed
;roDVy = FLTARR(nROG) ; determines when individual round goby feed


YPeaten = FLTARR(9, nYP) ; number of prey consumed as determined by the foraging subroutine
WAEeaten = FLTARR(10, nWAE) ; number of prey consumed as determined by the foraging subroutine
RASeaten = FLTARR(6, nRAS) ; number of prey consumed as determined by the foraging subroutine
EMSeaten = FLTARR(6, nEMS) ; number of prey consumed as determined by the foraging subroutine
;ROGeaten = FLTARR(6, nROG) ; number of prey consumed as determined by the foraging subroutine


;**The number of days in each month, DOY = iday + 1L***********************************
;IF (DOY GE 1L) AND (DOY LE 31L) January 1-31 (31d)
;IF (DOY GE 32L) AND (DOY LE 59L) February 1-28 (28d) 
;IF (DOY GE 60L) AND (DOY LE 90L) March 1-31 (31d)
;IF (DOY GE 91L) AND (DOY LE 120L) April 1-30 (30d)
;IF (DOY GE 121L) AND (DOY LE 151L) May 1-31 (31d)
;IF (DOY GE 152L) AND (DOY LE 181L) June 1-30 (30d)
;IF (DOY GE 182L) AND (DOY LE 212L) July 1-31 (31d)
;IF (DOY GE 213L) AND (DOY LE 243L) August 1-31 (31d)
;IF (DOY GE 244L) AND (DOY LE 273L) September 1-30 (30d)
;IF (DOY GE 274L) AND (DOY LE 304L) October 1-31 (31d)
;IF (DOY GE 305L) AND (DOY LE 334L) November 1-30 (30d)
;IF (DOY GE 335L) AND (DOY LE 365L) December 1-31 (31d)   
;***********************************************************************************************

; Output timings, adjusted for seasonal differences in light
; Midday and Midnight are not included, because they do not change seasonally
go_out_morn_hr = lonarr(164)
go_out_morn_hr[0:41] = 7L
go_out_morn_hr[42:124] = 8L
go_out_morn_hr[125:163] = 9L
go_out_morn_min = lonarr(164)
go_out_morn_min[0:13] = 30L
go_out_morn_min[14:27] = 40L
go_out_morn_min[28:41] = 50L
go_out_morn_min[42:55] = 0L
go_out_morn_min[56:69] = 10L
go_out_morn_min[70:83] = 20L
go_out_morn_min[84:97] = 30L
go_out_morn_min[98:111] = 40L
go_out_morn_min[112:124] = 50L
go_out_morn_min[125:137] = 0L
go_out_morn_min[138:150] = 10L
go_out_morn_min[151:163] = 20L
go_out_aft_hr = lonarr(164)
go_out_aft_hr[0:32] = 19L
go_out_aft_hr[33:98] = 18L
go_out_aft_hr[99:163] = 17L
go_out_aft_min = lonarr(164)
go_out_aft_min[0:10] = 20L
go_out_aft_min[11:21] = 10L
go_out_aft_min[22:32] = 0L
go_out_aft_min[33:43] = 50L
go_out_aft_min[44:54] = 40L
go_out_aft_min[55:65] = 30L
go_out_aft_min[66:76] = 20L
go_out_aft_min[77:87] = 10L
go_out_aft_min[88:98] = 0L
go_out_aft_min[99:109] = 50L
go_out_aft_min[110:120] = 40L
go_out_aft_min[121:131] = 30L
go_out_aft_min[132:142] = 20L
go_out_aft_min[143:153] = 10L
go_out_aft_min[154:163] = 0L
    
tstart1 = SYSTIME(/seconds)


FOR iYEAR = 2004L, 2004L DO BEGIN;*************INTER-ANNUAL LOOP***************************************************************
  PRINT, 'YEAR', iYEAR; the year of simulations
  tstart2 = SYSTIME(/seconds)
  
  ;***************************
  ;Hypoxia effect
  Hypoxia = 'ON'
  ;Density dependence effect
  DensityDependence = 'ON'
  ;Replicate #
  Rep = '2004_1D_ONE'
  ;***************************
  
  
  IntDay = 152L; initial day of simulation 
  FinDay = 315L; final day of simulation 
;  
;  IntDay = 153L; initial day of simulation in
;  FinDay = 289L; final day of simulation in

  
  FOR iDay = IntDay, FinDay DO BEGIN;************************************INTRA-ANNUAL LOOP***************************************************************
  counter =  iDay - IntDay;*****FOR OUTPUT FILES (DOY)**************** DOY152 = June 1st in 2005, which needs to be adjusted for other years
  ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)********************
  ;PRINT, 'Counter', counter
 
 
  ; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IFYLE data  
  ; Initial total benthic biomasss in May OR June
  ;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
  IF iDAY EQ IntDay THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
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
  iDayPointer = iDay - 105L
  ; First DOY for the simulation - DOY105 =~April 15 (the fisrt day in the input files), DOY152 = ~June 1
  
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
  
  IF DONZcount GT 0. THEN GrowthRate[dcnz] = 0.1021 * ALOG(CARBON[dcnz]*1000.) + 0.6422; /d
  
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
  PRINT,  'YEAR', Envir1d2[2, 0], '     MONTH', Envir1d2[0, 0], '     DAY', Envir1d2[1, 0]
    
    
  FOR i10Minute = 0L, 143L DO BEGIN;************************************DAILY LOOP***************************************************************
    ; Call only a dayly input from a yearly input read from the file
     i10MinutePointer = i10Minute + 144L*(iDay-105L)
     LightEnvir1d2 = LightEnvir1d[*, i10MinutePointer]; 48 vertical layers
    
     PRINT,  'YEAR', Envir1d2[2, 0], '   MONTH', Envir1d2[0, 0], '   DAY', Envir1d2[1, 0], $ 
             '   HOUR', FLOOR(i10Minute*10/60), '   MINUITE', LightEnvir1d2[3, *]
     ;PRINT, '10minute Surface Light Input'
     ;PRINT,  LightEnvir1d2
         
    tstart4 = SYSTIME(/seconds)
    
         
    ; To convedret langely to lux
    Light =  331.69 * EXP(-1.* Envir1d2[11, *] * Envir1d2[3, *]) ## LightEnvir1d2[4, *]
;   PRINT, '10minute Light Input'
;   PRINT,  TRANSPOSE(Light)  
    ;Light2 = (Light/175000000000.)> 0.; conevert from lux to mylux
  
           
    ;***Redistribution of zooplankton******************************      
    ; Light function 
    HighLight = WHERE(Light GT 1E-14, HightLightcount, complement = LowLight, ncomplement = Lowlightcount)
    IF HightLightcount GT 0. THEN gzLight[HighLight] = (-0.5*((ALOG10(Light[HighLight])-(-27.53))/0.76)^2.)
    IF Lowlightcount GT 0. THEN gzLight[LowLight] = 0.1
    posGZL = gzLight + 975.
    STDgzLight = posGZL / max(posGZL)
    
    ; Temp function     
    TEMP = Envir1d2[9, *]
    fMODzTemp = (EXP(-0.5*(((ALOG(TEMP > 0.00001))-ALOG(17.))/0.5)^2.)) + 0.05
    STDfMODzTemp = fMODzTemp/max(fMODzTemp)
        
    ; DO function
    Oxygen = Envir1d2[10, *]
    ;DOcrit = 4.
    ;fzDO = 1.0 / (1.0 + EXP(-2.1972 * (Oxygen + (4. - 1.1*DOcrit)) + 6.5916))
    DOcrit = 3.
    fzDO = 1.0 / (1.0 + EXP(-0.7 * (Oxygen + (4. - 1.1*DOcrit)) + 2.5))
    STDfzDO = fzDO/max(fzDO)
     
    ; Calculate cumulative zooplankton biomass for each vertical layer
    zoopl1 = TOTAL(Envir1d2[5, *])
    zoopl2 = TOTAL(Envir1d2[6, *])
    zoopl3 = TOTAL(Envir1d2[7, *])
     
    ; the probability of finding zooplankton at depth z, given all available depths
    TotalLightTempDOL = TOTAL(STDfMODzTemp * STDgzLight * STDfzDO)
    PzL = (STDfMODzTemp * STDgzLight * STDfzDO) /TotalLightTempDOL
    PzS[*,0] = 1./nVerLay
    PzLS = PzL + PzS
    PzM = ((PzLS) / 2.)
    PzM = PzM /total(PzM)
     
    ; Redistribute zooplankton based on light and temperature and DO
    zoopl1 = PzS*zoopl1 / 0.08 * ((.161) * 1.0/ 1000.0 / 1.0)
    zoopl2 = PzM*zoopl2 / 0.08 * ((.587) * 1.0/ 1000.0 / 1.0)
    zoopl3 = PzL*zoopl3 / 0.08 * ((.248) * 1.0/ 1000.0 / 1.0)
;          PRINT, 'New Daily Zooplankton Input'
;          PRINT,  TRANSPOSE(zoopl1)
;          PRINT,  TRANSPOSE(zoopl2)
;          PRINT,  TRANSPOSE(zoopl3)
;       PRINT, 'Dayly Input'
;       PRINT,  Envir1d2  
;       PRINT, 'TotBenBio'
;       PRINT, TotBenBio
   
   
   Envir1D3[4, *] = INDGEN(nVerLay); vertical layer ID
   Envir1D3[5, *] = zoopl1; microzooplankton, g/L
   Envir1D3[6, *] = zoopl2 ; mid-size zooplankton; NOT YET g/L
   Envir1D3[7, *] = zoopl3; large-bodied zooplankton; NOT YET g/L
   Envir1D3[8, *] = TotBenBio; g/m2
   Envir1D3[9:10, *] = Envir1D2[9:10, *]; TEMP & O2
   Envir1D3[11, *] = Light
   Envir1D3[15, *] = Envir1D2[3, *];
   ;PRINT, 'New Daily Input'
   ;PRINT,  Envir1d3[*, 0:100]
 
 
   ; Initialize IBM for each species -> ONLY ONCE A YEAR at the bebinning of simulations
   IF ((iDay EQ IntDay) AND (i10Minute EQ 0L)) THEN BEGIN; iday = DOY-1; DOY152 = ~June 1st
     YP = YEPinitial(NpopYP, nYP, Envir1D3[8, *], envir1d3, nVerLay)  
     WAE = WAEinitial1D(NpopWAE, nWAE, Envir1D3[8, *], envir1d3, nVerLay)  
     RAS = RASinitial(NpopRAS, nRAS, Envir1D3[8, *], envir1d3, nVerLay)  
     EMS = EMSinitial(NpopEMS, nEMS, Envir1D3[8, *], envir1d3, nVerLay)  
     ;ROG = ROGinitial(NpopROG, nROG, Envir1D3[8, *], envir1d3, nVerLay)  
   ENDIF     
;     PRINT, 'RAS[1, 0:100]'
;     PRINT, transpose(RAS[1, 0:300])
;     PRINT, 'RAS[2, 0:100]'
;     PRINT, transpose(RAS[2, 0:300])
;     PRINT, 'EMS[1, 0:100]'
;     PRINT, transpose(EMS[1, 0:300])
;     PRINT, 'EMS[2, 0:100]'
;     PRINT, transpose(EMS[2, 0:300])
;     PRINT, 'ROG[1, 0:100]'
;     PRINT, transpose(ROG[1, 0:300])
;     PRINT, 'ROG[2, 0:100]'
;     PRINT, transpose(ROG[2, 0:300]) 
    
     
    ;***THE FOLLOWING SUBROUTEINES ARE ACTIVATED ONLY FOR HACHING********************************************
    ;cy2 = 0L
    ;IF (iHour EQ 0) THEN BEGIN; only do once a day
      ; Egg develpment -> hatching occurs when DV > 1.0
      ; YPLhatch = YPhatch(yDV, YP[25,*], YP[19,*], YP[20,*], nYP) ;track development of yellow perch eggs
      ; WLhatch = WAEhatch(wDV,temp, wae[11,*],nw) ;track development of walleye eggs 
      ; YPLhatch = YPhatch(yDV, Tamb, YP[11,*], DOa, nYP) ;track development of yellow perch eggs
      ; PRINT, 'YPhatch =', YPLhatch
    ;ENDIF
    
    ; Check if hatching occurs
     ;Ycheck = WHERE(YPLhatch GT 1.0, cy, complement = checkcyy, ncomplement = ccy)
     ;Wcheck = where(wlhatch gt 1.0, cw, complement = checkcww, ncomplement = ccw)
     ;PRINT, 'Hatching Check =', cy, ccy
  
    ;IF cy GT 0.0 THEN BEGIN
      ; Larval develpment to 1st feeding -> 1st feeding occurs when DVy > 1.0
      ; YP1stfeed = YEP1stfeed(yDVy, yp[20,*], nYP) ;track development of yellow perch eggs
      ; YP1stfeed = YEP1stfeed(yDVy, DOa, nYP) ;track development of yellow perch eggs
      ; WLhatch = WAEhatch(wDV,temp, wae[11,*],nw) ;track development of walleye eggs 
      ;'pbio='
      ; PRINT,'YP1stfeed =', YP1stfeed
  
      ; Check if feeding occurs
      ;Ycheck2 = WHERE(YP1stfeed GT 1.0, cy2, complement = checkcyy2, ncomplement = ccy2)
      ;Wcheck = where(wlhatch gt 1.0, cw, complement = checkcww, ncomplement = ccw)
      ;PRINT,'1st Feeding Check =', cy2, ccy2
      ;*****************************************************************************************************
    
    
;      FOR iTime = 0L, 60L/ts - 1L DO BEGIN;********************************TIME STEP LOOP**********************************************************
      ; runs 60L/ts times in an hour
      ; only run through if individual has hatched
;        PRINT, 'DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
        
  
   ; Update time information for outputs
    YP[42, *] = IDAY; DOY
    YP[43, *] = FLOOR(i10Minute*10/60); hour
    YP[44, *] = LightEnvir1d2[3, *]; minutes        
    WAE[42, *] = IDAY; day
    WAE[43, *] = FLOOR(i10Minute*10/60); hour
    WAE[44, *] = LightEnvir1d2[3, *]; minutes      
    RAS[42, *] = IDAY; day
    RAS[43, *] = FLOOR(i10Minute*10/60); hour
    RAS[44, *] = LightEnvir1d2[3, *]; minutes      
    EMS[42, *] = IDAY; day
    EMS[43, *] = FLOOR(i10Minute*10/60); hour
    EMS[44, *] = LightEnvir1d2[3, *]; minutes      
    ;ROG[42, *] = IDAY; day
    ;ROG[43, *] = FLOOR(i10Minute*10/60); hour
    ;ROG[44, *] = LightEnvir1d2[3, *]; minutes


   ;IF (ccy2 GT 0) THEN BEGIN ; updates environment of YP that haven't fed
   ; IF (itime EQ 0) THEN BEGIN ;only update once an hour
   ;  FOR jjj = 0, nyp - 1 DO BEGIN
   ;    yolk = WHERE(envir3d[4,*] EQ yp[14,jjj], count)
        ;YP[10 : 24, jjj] = envir3d[*, yolk]
        ;print, 'update yp envir of yolk-sac fry
        ;IF cy GT 0.0 THEN BEGIN
        ;ENDIF
   ;   ENDFOR
   ;  ENDIF
   ; ENDIF   
  
   ; IF (cy2 GT 0.0) THEN BEGIN
   
       
   ;********************************************************
 ; Vertical movement 
   ; Prey fish array for movement (use mean length and weight)    
   YEPPreyFishMove = YEPFishPreyArray1DMove(YP, EMS, RAS, ROG, WAE, nVerLay)
   WAEPreyFishMove = WAEFishPreyArray1DMove(YP, EMS, RAS, ROG, WAE, nVerLay)
   YEPPredFishMove = YEPFishPredArray1DMove(YP, WAE, nVerLay)
   WAEPredFishMove = WAEFishPredArray1DMove(YP, WAE, nVerLay)   
   EMSPredFishMove = EMSFishPredArray1DMove(YP, WAE, EMS, nVerLay)
   RASPredFishMove = RASFishPredArray1DMove(YP, WAE, RAS, nVerLay)   
   ForageFishCompMove = ForageFishArray1DMove(YP, EMS, RAS, ROG, WAE, nVerLay)
   ;PRINT, PreyFish
         
   tsvm = ts/1.; FOR SHORTER TIME STEP FOR VERTICAL MOVEMENT
   FOR i2Minute = 0L, 0L DO BEGIN;************************************i?MINUTE LOOP*****************       
     YPMoveV = YEPMove1DV(tsvm, LightEnvir1d2[2, *], YP, nYP, Envir1D3, YEPPreyFishMove, YEPPredFishMove, YP[41, *], YP[63, *])
     WEMoveV = WAEMove1DV(tsvm, LightEnvir1d2[2, *], WAE, nWAE, Envir1D3, WAEPreyFishMove, WAEPredFishMove, WAE[41, *], WAE[63, *])
     ESMoveV = EMSMove1DV(tsvm, LightEnvir1d2[2, *], EMS, nEMS, Envir1D3, ForageFishCompMove, EMSPredFishMove, EMS[41, *], EMS[63, *])
     RSMoveV = RASMove1DV(tsvm, LightEnvir1d2[2, *], RAS, nRAS, Envir1D3, ForageFishCompMove, RASPredFishMove, RAS[41, *], RAS[63, *])
     ;RGMoveV = ROGMove1DV(tsvm, LightEnvir1d2[2, *], ROG, nROG, Envir1D3, ForageFishComp, ROG[41, *], ROG[63, *])
   ENDFOR
          
   ; Update fish locations and environmental conditions
   YP[10:24, *] = YPmoveV[0:14, *]      
   WAE[10:24, *] = WEmoveV[0:14, *]   
   RAS[10:24, *] = RSmoveV[0:14, *]         
   EMS[10:24, *] = ESmoveV[0:14, *]    
  ;ROG[10:24, *] = RGmoveV[0:14, *]
    
   ; Update within-cell locations
   YP[41, *] = YPmoveV[16, *]       
   WAE[41, *] = WEmoveV[16, *]
   RAS[41, *] = RSmoveV[16, *]     
   EMS[41, *] = ESmoveV[16, *]    
   ;ROG[41, *] = RGmoveV[16, *]


   ; Estimate acclimation effects on foraging and bioenergetics
   ; Temperature acclimation
   YacclT = YEPacclT(YP[26, *], YP[27, *], YP[19, *], ts, YP[1, *], nYP) ; determine temperature acclimations for yellow perch
   WacclT = WAEacclT(WAE[26, *], WAE[27, *], WAE[19, *], ts, WAE[1, *], nWAE) ; determine temperature acclimations for walleye
   RacclT = RASacclT(RAS[26, *], RAS[27, *], RAS[19, *], ts, RAS[1, *], nRAS) ; determine temperature acclimations for rainbow smelt
   EacclT = EMSacclT(EMS[26, *], EMS[27, *], EMS[19, *], ts, EMS[1, *], nEMS) ; determine temperature acclimations for emerald shiner
   ;ROacclT = ROGacclT(ROG[26, *], ROG[27, *], ROG[19, *], ts, nROG) ; determine temperature acclimations for round goby

   ; Update fish acclimated temperature 
   YP[26, *] = YacclT[0, *] ;updates YEP temp acclimation for C
   YP[27, *] = YacclT[1, *] ;updates YEP temp acclimation for R
   WAE[26, *] = WacclT[0, *] ;updates WAE temp acclimation for C
   WAE[27, *] = WacclT[1, *] ;updates WAE temp acclimation for R
   RAS[26, *] = RacclT[0, *] ;updates RAS temp acclimation for C
   RAS[27, *] = RacclT[1, *] ;updates RAS temp acclimation for R
   EMS[26, *] = EacclT[0, *] ;updates EMS temp acclimation for C
   EMS[27, *] = EacclT[1, *] ;updates EMS temp acclimation for R
   ;ROG[26, *] = ROacclT[0, *] ;updates ROG temp acclimation for C
   ;ROG[27, *] = ROacclT[1, *] ;updates ROG temp acclimation for R
  
  
   ; DO acclimation
   YacclDO = YEPacclDO(YP[28, *], YP[29, *], YP[20, *], YP[26, *], YP[27, *], YP[19, *], ts, YP[1, *], YP[2, *], nYP, YP[63, *]) 
   WacclDO = WAEacclDO(WAE[28, *], WAE[29, *], WAE[20, *], WAE[26, *], WAE[27, *], WAE[19, *], ts, WAE[1, *], WAE[2, *], nWAE, WAE[63, *]) 
   RacclDO = RASacclDO(RAS[28, *], RAS[29, *], RAS[20, *], RAS[26, *], RAS[27, *], RAS[19, *], ts, RAS[1, *], RAS[2, *], nRAS, RAS[63, *]) 
   EacclDO = EMSacclDO(EMS[28, *], EMS[29, *], EMS[20, *], EMS[26, *], EMS[27, *], EMS[19, *], ts, EMS[1, *], EMS[2, *], nEMS, EMS[63, *]) 
   ;ROacclDO = ROGacclDO(ROG[28, *], ROG[29, *], ROG[20, *], ROG[26, *], ROG[27, *], ROG[19, *], ts, ROG[1, *], ROG[2, *], nROG, ROG[63, *])                   
  
   ; Update fish acclimated DO
   YP[28, *] = YacclDO[0, *] ;updates YEP DO acclimation for C
   YP[29, *] = YacclDO[1, *] ;updates YEP DO acclimation for R  
   WAE[28, *] = WacclDO[0, *] ;updates WAE DO acclimation for C
   WAE[29, *] = WacclDO[1, *] ;updates WAE  DO acclimation for R 
   RAS[28, *] = RacclDO[0, *] ;updates RAS DO acclimation for C
   RAS[29, *] = RacclDO[1, *] ;updates RAS DO acclimation for R 
   EMS[28, *] = EacclDO[0, *] ;updates EMS DO acclimation for C
   EMS[29, *] = EacclDO[1, *] ;updates EMS DO acclimation for R 
   ;ROG[28, *] = ROacclDO[0, *] ;updates ROG DO acclimation for C
   ;ROG[29, *] = ROacclDO[1, *] ;updates ROG DO acclimation for R 
  
   ; Update fish DO stress
   ;YP[36, *] = YacclDO[2, *] ;updates YEP DO acclimation for C
   YP[36, *] = YacclDO[3, *] ;updates YEP DO acclimation for C
   ;WAE[36, *] = WacclDO[2, *] ;updates WAE DO acclimation for C
   WAE[36, *] = WacclDO[3, *] ;updates YEP DO acclimation for C
   ;RAS[36, *] = RacclDO[2, *] ;updates RAS DO acclimation for C
   RAS[36, *] = RacclDO[3, *] ;updates YEP DO acclimation for C
   ;EMS[36, *] = EacclDO[2, *] ;updates EMS DO acclimation for C
   EMS[36, *] = EacclDO[3, *] ;updates YEP DO acclimation for C
   ;ROG[36, *] = ROacclDO[2, *] ;updates ROG DO acclimation for C
   ;ROG[36, *] = ROacclDO[3, *] ;updates YEP DO acclimation for C
 
  
   ;***Foraging / consumption*********************************************************
   ; Determine Cmax ->> tempearture-dependent Cmax is updated every time step
   YPcmx = YEPcmax(YP[2, *], YP[1, *], nYP, YP[26, *]); sets limit for how much a YP can eat in a 24 hr period
   WAEcmx = WAEcmax(WAE[2, *],WAE[1,*], nWAE, WAE[26, *]); sets limit for how much WAE can eat in a 24 hr period
   RAScmx = RAScmax(RAS[2, *], RAS[1, *], nRAS, RAS[26, *]); sets limit for how much a RAS can eat in a 24 hr period
   EMScmx = EMScmax(EMS[2, *], EMS[1,*], nEMS, EMS[26, *]); sets limit for how much EMS can eat in a 24 hr period
   ;ROGcmx = ROGcmax(ROG[2, *], ROG[1, *], nROG, ROG[26, *]); sets limit for how much a ROG can eat in a 24 hr period
   
   
   ; Determine stomach capacity
   YstomCap = YEPstcap(YP[2, *], nYP) ; stomach capacity for yellow perch
   WstomCap = WAEstcap(WAE[1,*], nWAE) ; stomach capacity for walleye
   RstomCap = RASstcap(RAS[2,*], nRAS) ; stomach capacity for rainbow smelt
   EstomCap = EMSstcap(EMS[2,*], nEMS) ; stomach capacity for emerald shiner
   ;ROstomCap = ROGstcap(ROG[2,*], nROG) ; stomach capacity for round goby
  
   ; Update size-based stomach capacity
   YP[8, *] = YstomCap[*] ;updates YEP stomach capacity (g)       
   WAE[8, *] = WstomCap[*] ;updates WAE stomach capacity (g)
   RAS[8, *] = RstomCap[*] ;updates RAS stomach capacity (g)
   EMS[8, *] = EstomCap[*] ;updates EMS stomach capacity (g)
   ;ROG[8, *] = ROstomCap[*] ;updates ROG stomach capacity (g)


   ; Prey availability to determine encounter rates
   ;******Biomass needs to be incoporated in to density dependence effects**************** 
   ;********************************************************
   ; Creat a fish prey array for potential predators        
   ;PreyFish = FishArray1D(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nVerLay)
   YEPPreyFishForage = YEPFishPreyArray1D(YP, EMS, RAS, ROG, WAE, nYP, nVerLay); Array for prey fish
   WAEPreyFishForage = WAEFishPreyArray1D(YP, EMS, RAS, ROG, WAE, nWAE, nVerLay)
   
   ; Fish array for intra-/inter- specific interactions
   YEPFishComp = YEPFishArray1D(YP, EMS, RAS, ROG, WAE, nYP, nVerLay)
   WAEFishComp = WAEFishArray1D(YP, EMS, RAS, ROG, WAE, nWAE, nVerLay)
   EMSForageFishComp = EMSForageFishArray1D(YP, EMS, RAS, ROG, WAE, nEMS, nVerLay)
   RASForageFishComp = RASForageFishArray1D(YP, EMS, RAS, ROG, WAE, nRAS, nVerLay)
   
   ;PRINT, PreyFish
   ;********************************************************


   ; Prey & competitor biomass (g/L or g/m2 or g/m3)
   ; prey & competitor for yellow perch
   YPGridcellSize = 15500. * 1000000. * .5 / 10.; grid cell size (in m3)
   YPbiomN0 = WHERE((YP[0, *]*YP[2, *] NE 0.), YPbiomN0count)
   IF YPbiomN0count GT 0. THEN BEGIN
      YPpbio[0, YPbiomN0] = YP[15, YPbiomN0]; zooplankton 
      YPpbio[1, YPbiomN0] = YP[16, YPbiomN0]; zooplankton 
      YPpbio[2, YPbiomN0] = YP[17, YPbiomN0]; zooplankton 
      YPpbio[3, YPbiomN0] = YP[18, YPbiomN0]; bentho
      YPpbio[4, YPbiomN0] = 0.0 * 1L; invasive species
      
      ; One potential prey fish SI is randomly chosen by prey/predator size ratio for foraging in each time step
      YPpbio[5, YPbiomN0] = YEPPreyFishForage[0, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; yellow perch abundance
      YPpbio[6, YPbiomN0] = YEPPreyFishForage[1, YP[14, YPbiomN0]]; length
      YPpbio[7, YPbiomN0] = YEPPreyFishForage[2, YP[14, YPbiomN0]]; weight
      YPpbio[8, YPbiomN0] = YEPPreyFishForage[3, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; biomass       
      
      YPpbio[9, YPbiomN0] = YEPPreyFishForage[6, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; emerald shiner abundance
      YPpbio[10, YPbiomN0] = YEPPreyFishForage[7, YP[14, YPbiomN0]]
      YPpbio[11, YPbiomN0] = YEPPreyFishForage[8, YP[14, YPbiomN0]]
      YPpbio[12, YPbiomN0] = YEPPreyFishForage[9, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; 
      
      YPpbio[13, YPbiomN0] = YEPPreyFishForage[12, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; rainbow smelt abundance
      YPpbio[14, YPbiomN0] = YEPPreyFishForage[13, YP[14, YPbiomN0]]
      YPpbio[15, YPbiomN0] = YEPPreyFishForage[14, YP[14, YPbiomN0]]
      YPpbio[16, YPbiomN0] = YEPPreyFishForage[15, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]];
      
;      YPpbio[17, YP[14, YPbiomN0]] = YEPPreyFishForage[18, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; round goby abundance
;      YPpbio[18, YP[14, YPbiomN0]] = YEPPreyFishForage[19, YP[14, YPbiomN0]] 
;      YPpbio[19, YP[14, YPbiomN0]] = YEPPreyFishForage[20, YP[14, YPbiomN0]]
;      YPpbio[20, YP[14, YPbiomN0]] = YEPPreyFishForage[23, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; biomass
      
      YPpbio[21, YPbiomN0] = YEPPreyFishForage[24, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; walleye abundance
      YPpbio[22, YPbiomN0] = YEPPreyFishForage[25, YP[14, YPbiomN0]] 
      YPpbio[23, YPbiomN0] = YEPPreyFishForage[26, YP[14, YPbiomN0]]
      YPpbio[24, YPbiomN0] = YEPPreyFishForage[27, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; biomass
      
      ; Total fish abundance and biomass for intra-/inter- specific interactions
      YPpbio[25, YPbiomN0] = YEPFishComp[4, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; yellow perch abundance
      YPpbio[26, YPbiomN0] = YEPFishComp[10, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; emerald shiner
      YPpbio[27, YPbiomN0] = YEPFishComp[16, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; rainbow smelt
      ;YPpbio[28, YP[14, YPbiomN0]] = YEPFishComp[22, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; round goby
      YPpbio[29, YPbiomN0] = YEPFishComp[28, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; walleye
      
      YPpbio[30, YPbiomN0] = YEPFishComp[5, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; yellow perch biomass
      YPpbio[31, YPbiomN0] = YEPFishComp[11, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; emerald shienr
      YPpbio[32, YPbiomN0] = YEPFishComp[17, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; rainbow smelt
      ;YPpbio[33, YP[14, YPbiomN0]] = YEPFishComp[23, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; round goby
      YPpbio[34, YPbiomN0] = YEPFishComp[29, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; walleye
      
      ; Total forage fish abundance and biomass
      YPpbio[35, YPbiomN0] = YEPPreyFishForage[4, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; yellow perch abundance
      YPpbio[36, YPbiomN0] = YEPPreyFishForage[10, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; emerald shiner
      YPpbio[37, YPbiomN0] = YEPPreyFishForage[16, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; rainbow smelt
      ;YPpbio[38, YP[14, YPbiomN0]] = YEPPreyFishForage[22, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; round goby
      YPpbio[39, YPbiomN0] = YEPPreyFishForage[28, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; walleye
      
      YPpbio[40, YPbiomN0] = YEPPreyFishForage[5, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; yellow perch biomass
      YPpbio[41, YPbiomN0] = YEPPreyFishForage[11, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; emerald shienr
      YPpbio[42, YPbiomN0] = YEPPreyFishForage[17, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; rainbow smelt
      ;YPpbio[43, YP[14, YbiomN0]] = YEPPreyFishForage[23, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; round goby
      YPpbio[44, YPbiomN0] = YEPPreyFishForage[29, YP[14, YPbiomN0]] / YPGridcellSize[YP[14, YPbiomN0]]; walleye     
    ENDIF
    ;PRINT, 'YPPBIO', YPPBIO
    
    
    ; prey & competitor for walleye      
    WAEGridcellSize = 15500. * 1000000. * .5 / 10.; grid cell size (in m3)
    WAEbiomN0 = where((WAE[0, *]*WAE[2, *] NE 0.), WAEbiomN0count)
    IF WAEbiomN0count GT 0. THEN BEGIN
      WAEpbio[0, WAEbiomN0] = WAE[15, WAEbiomN0]; zooplankton 
      WAEpbio[1, WAEbiomN0] = WAE[16, WAEbiomN0]; zooplankton
      WAEpbio[2, WAEbiomN0] = WAE[17, WAEbiomN0]; zooplankton
      WAEpbio[3, WAEbiomN0] = WAE[18, WAEbiomN0]; bentho
      WAEpbio[4, WAEbiomN0] = 0.0 * 1L; invasive species
      
      WAEpbio[5, WAEbiomN0] = WAEPreyFishForage[0, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; yellow perch abundance
      WAEpbio[6, WAEbiomN0] = WAEPreyFishForage[1, WAE[14,  WAEbiomN0]]; length
      WAEpbio[7, WAEbiomN0] = WAEPreyFishForage[2, WAE[14,  WAEbiomN0]]; weight
      WAEpbio[8, WAEbiomN0] = WAEPreyFishForage[3, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; biomass       
      
      WAEpbio[9, WAEbiomN0] = WAEPreyFishForage[6, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; emerald shiner abundance
      WAEpbio[10, WAEbiomN0] = WAEPreyFishForage[7, WAE[14,  WAEbiomN0]]  
      WAEpbio[11, WAEbiomN0] = WAEPreyFishForage[8, WAE[14,  WAEbiomN0]]
      WAEpbio[12, WAEbiomN0] = WAEPreyFishForage[9, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; 
      
      WAEpbio[13, WAEbiomN0] = WAEPreyFishForage[12, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; rainbow smelt abundance
      WAEpbio[14, WAEbiomN0] = WAEPreyFishForage[13, WAE[14,  WAEbiomN0]] 
      WAEpbio[15, WAEbiomN0] = WAEPreyFishForage[14, WAE[14,  WAEbiomN0]]
      WAEpbio[16, WAEbiomN0] = WAEPreyFishForage[15, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]];
      
;      WAEpbio[17, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[22, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; round goby abundance
;      WAEpbio[18, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[19, WAE[14,  WAEbiomN0]] 
;      WAEpbio[19, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[20, WAE[14,  WAEbiomN0]]
;      WAEpbio[20, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[23, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; 
      
      WAEpbio[21, WAEbiomN0] = WAEPreyFishForage[24, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; walleye abundance
      WAEpbio[22, WAEbiomN0] = WAEPreyFishForage[25, WAE[14,  WAEbiomN0]] 
      WAEpbio[23, WAEbiomN0] = WAEPreyFishForage[26, WAE[14,  WAEbiomN0]]
      WAEpbio[24, WAEbiomN0] = WAEPreyFishForage[27, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]];
      
      ; Total fish abundance and biomass for intra-/inter- specific interactions
      WAEpbio[25, WAEbiomN0] = WAEFishComp[4, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; yellow perch abundance
      WAEpbio[26, WAEbiomN0] = WAEFishComp[10, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; emerald shiner
      WAEpbio[27, WAEbiomN0] = WAEFishComp[16, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; rainbow smelt
      ;WAEpbio[28, ] = WAEFishComp[22, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; round goby
      WAEpbio[29, WAEbiomN0] = WAEFishComp[28, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; walleye
      
      WAEpbio[30, WAEbiomN0] = WAEFishComp[5, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; yellow perch biomass
      WAEpbio[31, WAEbiomN0] = WAEFishComp[11, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; emerald shienr
      WAEpbio[32, WAEbiomN0] = WAEFishComp[17, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; rainbow smelt
      ;WAEpbio[33, WAE[14,  WAEbiomN0]] = WAEFishComp[23, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; round goby
      WAEpbio[34, WAEbiomN0] = WAEFishComp[29, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; walleye
      
      ; Total forage fish abundance and biomass
      WAEpbio[35, WAEbiomN0] = WAEPreyFishForage[4, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; yellow perch abundance
      WAEpbio[36, WAEbiomN0] = WAEPreyFishForage[10, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; emerald shiner
      WAEpbio[37, WAEbiomN0] = WAEPreyFishForage[16, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; rainbow smelt
      ;WAEpbio[38, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[22, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; round goby
      WAEpbio[39, WAEbiomN0] = WAEPreyFishForage[28, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; walleye
      
      WAEpbio[40, WAEbiomN0] = WAEPreyFishForage[5, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; yellow perch biomass
      WAEpbio[41, WAEbiomN0] = WAEPreyFishForage[11, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; emerald shienr
      WAEpbio[42, WAEbiomN0] = WAEPreyFishForage[17, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; rainbow smelt
      ;WAEpbio[43, WAE[14,  WAEbiomN0]] = WAEPreyFishForage[23, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; round goby
      WAEpbio[44, WAEbiomN0] = WAEPreyFishForage[29, WAE[14,  WAEbiomN0]] / WAEGridcellSize[WAE[14,  WAEbiomN0]]; walleye
    ENDIF    
     ; PRINT, 'WAEPBIO', WAEPBIO
    
    
    ;******No fish prey for smelt, shiner, and goby for now*******************************************************
    ; Prey & competitor for rainbow smelt
    RASGridcellSize = 15500. * 1000000. * .5 / 10.; grid cell size (in m3)
    RASbiomN0 = where((RAS[0, *]*RAS[2, *] NE 0.), RASbiomN0count)
    IF RASbiomN0count GT 0. THEN BEGIN
      RASpbio[0, RASbiomN0] = RAS[15, RASbiomN0]; zooplankton 
      RASpbio[1, RASbiomN0] = RAS[16, RASbiomN0]; zooplankton
      RASpbio[2, RASbiomN0] = RAS[17, RASbiomN0]; zooplankton 
      RASpbio[3, RASbiomN0] = RAS[18, RASbiomN0]; bentho     
      RASpbio[4, RASbiomN0] = 0.0 * 1L; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); invaisve species
      

      RASpbio[5, RASbiomN0] = RASForageFishComp[0, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; yellow perch abundance
      RASpbio[6, RASbiomN0] = RASForageFishComp[1, RAS[14, RASbiomN0]]; length
      RASpbio[7, RASbiomN0] = RASForageFishComp[2, RAS[14, RASbiomN0]]; weight
      RASpbio[8, RASbiomN0] = RASForageFishComp[3, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; 
      
      RASpbio[9, RASbiomN0] = RASForageFishComp[6, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; emerald shiner abundance
      RASpbio[10, RASbiomN0] = RASForageFishComp[7, RAS[14, RASbiomN0]]
      RASpbio[11, RASbiomN0] = RASForageFishComp[8, RAS[14, RASbiomN0]]
      RASpbio[12, RASbiomN0] = RASForageFishComp[9, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; 
      
      RASpbio[13, RASbiomN0] = RASForageFishComp[12, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; rainbow smelt abundance
      RASpbio[14, RASbiomN0] = RASForageFishComp[13, RAS[14, RASbiomN0]]
      RASpbio[15, RASbiomN0] = RASForageFishComp[14, RAS[14, RASbiomN0]]
      RASpbio[16, RASbiomN0] = RASForageFishComp[15, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; 
;      
;      RASpbio[17, RASbiomN0] = PreyFish[15, RAS[14, RASbiomN0]]] / RASGridcellSize[RAS[14, RASbiomN0]]; round goby abundance
;      RASpbio[18, RASbiomN0] = PreyFish[16, RAS[14, RASbiomN0]]] 
;      RASpbio[19, RASbiomN0] = PreyFish[17, RAS[14, RASbiomN0]]]
;      RASpbio[20, RASbiomN0] = PreyFish[18, RAS[14, RASbiomN0]]] / RASGridcellSize[RAS[14, RASbiomN0]]; 
      
      RASpbio[21, RASbiomN0] = RASForageFishComp[24, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; WALLEYE abundance
      RASpbio[22, RASbiomN0] = RASForageFishComp[25, RAS[14, RASbiomN0]] 
      RASpbio[23, RASbiomN0] = RASForageFishComp[26, RAS[14, RASbiomN0]]
      RASpbio[24, RASbiomN0] = RASForageFishComp[27, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; 
       
      ; Total fish abundance and biomass for intra-/inter- specific interactions
      RASpbio[25, RASbiomN0] = RASForageFishComp[4, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; yellow perch abundance
      RASpbio[26, RASbiomN0] = RASForageFishComp[10, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; emerald shiner
      RASpbio[27, RASbiomN0] = RASForageFishComp[16, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; rainbow smelt
      ;RASpbio[28, RASbiomN0] = RASForageFishComp[22, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; round goby
      RASpbio[29, RASbiomN0] = RASForageFishComp[28, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; walleye
      
      RASpbio[30, RASbiomN0] = RASForageFishComp[5, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; yellow eprch biomass
      RASpbio[31, RASbiomN0] = RASForageFishComp[11, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; emerald shiner
      RASpbio[32, RASbiomN0] = RASForageFishComp[17, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; rainbow smelt
      ;RASpbio[33, RASbiomN0] = RASForageFishComp[23, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; round goby
      RASpbio[34, RASbiomN0] = RASForageFishComp[29, RAS[14, RASbiomN0]] / RASGridcellSize[RAS[14, RASbiomN0]]; walleye

   ENDIF
   ;PRINT, 'RASPBIO', RASPBIO
   
   
   ; prey & competitor for emerald shiner
   EMSGridcellSize = 15500. * 1000000. * .5 / 10.; grid cell size (in m3)
   EMSbiomN0 = where((EMS[0, *]*EMS[2, *] NE 0.), EMSbiomN0count)
   IF EMSbiomN0count GT 0. THEN BEGIN
     EMSpbio[0, EMSbiomN0] = EMS[15, EMSbiomN0]; zooplankton 
     EMSpbio[1, EMSbiomN0] = EMS[16, EMSbiomN0]; zooplankton
     EMSpbio[2, EMSbiomN0] = EMS[17, EMSbiomN0]; zooplankton 
     EMSpbio[3, EMSbiomN0] = EMS[18, EMSbiomN0]; bentho
     EMSpbio[4, EMSbiomN0] = 0.0 * 1.;  / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); invasive species


      EMSpbio[5, EMSbiomN0] = EMSForageFishComp[0, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; yellow perch abundance
      EMSpbio[6, EMSbiomN0] = EMSForageFishComp[1, EMS[14, EMSbiomN0]]; length
      EMSpbio[7, EMSbiomN0] = EMSForageFishComp[2, EMS[14, EMSbiomN0]]; weight
      EMSpbio[8, EMSbiomN0] = EMSForageFishComp[3, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]];  biomass       
      
      EMSpbio[9, EMSbiomN0] = EMSForageFishComp[6, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; emerald shiner abundance
      EMSpbio[10, EMSbiomN0] = EMSForageFishComp[7, EMS[14, EMSbiomN0]]
      EMSpbio[11, EMSbiomN0] = EMSForageFishComp[8, EMS[14, EMSbiomN0]]
      EMSpbio[12, EMSbiomN0] = EMSForageFishComp[9, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; biomass
      
      EMSpbio[13, EMSbiomN0] = EMSForageFishComp[12, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; rainbow smelt abundance
      EMSpbio[14, EMSbiomN0] = EMSForageFishComp[13, EMS[14, EMSbiomN0]]
      EMSpbio[15, EMSbiomN0] = EMSForageFishComp[14, EMS[14, EMSbiomN0]]
      EMSpbio[16, EMSbiomN0] = EMSForageFishComp[15, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; biomass
      
;      EMSpbio[17, EMSbiomN0] = EMSForageFishComp[15, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; round goby abundance
;      EMSpbio[18, EMSbiomN0] = EMSForageFishComp[16, EMS[14, EMSbiomN0]] 
;      EMSpbio[19, EMSbiomN0] = EMSForageFishComp[17, EMS[14, EMSbiomN0]]
;      EMSpbio[20, EMSbiomN0] = EMSForageFishComp[18, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; biomass
      
      EMSpbio[21, EMSbiomN0] = EMSForageFishComp[24, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; WALLEYE abundance
      EMSpbio[22, EMSbiomN0] = EMSForageFishComp[25, EMS[14, EMSbiomN0]] 
      EMSpbio[23, EMSbiomN0] = EMSForageFishComp[26, EMS[14, EMSbiomN0]]
      EMSpbio[24, EMSbiomN0] = EMSForageFishComp[27, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; biomass
      
      ; Total fish abundance and biomass for intra-/inter- specific interactions
      EMSpbio[25, EMSbiomN0] = EMSForageFishComp[4, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; yellow perch abundance
      EMSpbio[26, EMSbiomN0] = EMSForageFishComp[10, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; emerald shiner
      EMSpbio[27, EMSbiomN0] = EMSForageFishComp[16, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; rainbow smelt
      ;EMSpbio[28, EMSbiomN0] = EMSForageFishComp[22, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; round goby
      EMSpbio[29, EMSbiomN0] = EMSForageFishComp[28, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; walleye
      
      EMSpbio[30, EMSbiomN0] = EMSForageFishComp[5, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; yellow eprch biomass
      EMSpbio[31, EMSbiomN0] = EMSForageFishComp[11, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; emerald shiner
      EMSpbio[32, EMSbiomN0] = EMSForageFishComp[17, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; rainbow smelt
      ;EMSpbio[33, EMSbiomN0] = EMSForageFishComp[23, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; round goby
      EMSpbio[34, EMSbiomN0] = EMSForageFishComp[29, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMS[14, EMSbiomN0]]; walleye  
   ENDIF
   ;PRINT, 'EMSPBIO', EMSPBIO


;        ; prey & competitor for round goby
;        ROGGridcellSize = 15500. * 1000000. * .5 / 10.; grid cell size (in m3)
;        ROGbiomN0 = where((ROG[0, *]*ROG[2, *] NE 0.), ROGbiomN0count)
;        IF ROGbiomN0count GT 0. THEN BEGIN
;          ROGpbio[0, ROGbiomN0] = ROG[15, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
;          ROGpbio[1, ROGbiomN0] = ROG[16, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
;          ROGpbio[2, ROGbiomN0] = ROG[17, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
;          ROGpbio[3, ROGbiomN0] = ROG[18, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); bentho
;          ROGpbio[4, ROGbiomN0] = 0.0 * 1L; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); invasive species
;          ROGpbio[5, ROGbiomN0] = 0.0;/ (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); fish
;          
;          ROGpbio[5, ROGbiomN0] = PreyFish[0, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; yellow perch abundance
;          ROGpbio[6, ROGbiomN0] = PreyFish[1, ROG[14, ROGbiomN0]]; length
;          ROGpbio[7, ROGbiomN0] = PreyFish[2, ROG[14, ROGbiomN0]]; weight
;          ROGpbio[8, ROGbiomN0] = PreyFish[3, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); biomass       
;          ROGpbio[9, ROGbiomN0] = PreyFish[5, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; emerald shiner abundance
;          ROGpbio[10, ROGbiomN0] = PreyFish[6, ROG[14, ROGbiomN0]]
;          ROGpbio[11, ROGbiomN0] = PreyFish[7, ROG[14, ROGbiomN0]]
;          ROGpbio[12, ROGbiomN0] = PreyFish[8, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]) 
;          ROGpbio[13, ROGbiomN0] = PreyFish[10, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; rainbow smelt abundance
;          ROGpbio[14, ROGbiomN0] = PreyFish[11, ROG[14, ROGbiomN0]]
;          ROGpbio[15, ROGbiomN0] = PreyFish[12, ROG[14, ROGbiomN0]]
;          ROGpbio[16, ROGbiomN0] = PreyFish[13, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0])
;          ROGpbio[17, ROGbiomN0] = PreyFish[15, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby abundance
;          ROGpbio[18, ROGbiomN0] = PreyFish[16, ROG[14, ROGbiomN0]] 
;          ROGpbio[19, ROGbiomN0] = PreyFish[17, ROG[14, ROGbiomN0]]
;          ROGpbio[20, ROGbiomN0] = PreyFish[18, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0])
;          ROGpbio[21, ROGbiomN0] = PreyFish[20, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby abundance
;          ROGpbio[22, ROGbiomN0] = PreyFish[21, ROG[14, ROGbiomN0]] 
;          ROGpbio[23, ROGbiomN0] = PreyFish[22, ROG[14, ROGbiomN0]]
;          ROGpbio[24, ROGbiomN0] = PreyFish[23, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, YPbiomN0])
;
;          ; Total fish abundance and biomass for intra-/inter- specific interactions
;          ROGpbio[25, ROGbiomN0] = ForageFishComp[4, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; yellow perch abundance
;          ROGpbio[26, ROGbiomN0] = ForageFishComp[10, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; emerald shiner
;          ROGpbio[27, ROGbiomN0] = ForageFishComp[16, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; rainbow smelt
;          ROGpbio[28, ROGbiomN0] = ForageFishComp[22, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby
;          ROGpbio[29, ROGbiomN0] = ForageFishComp[28, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; walleye
;          
;          ROGpbio[30, ROGbiomN0] = ForageFishComp[5, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; yellow eprch biomass
;          ROGpbio[31, ROGbiomN0] = ForageFishComp[11, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; emerald shiner
;          ROGpbio[32, ROGbiomN0] = ForageFishComp[17, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; rainbow smelt
;          ROGpbio[33, ROGbiomN0] = ForageFishComp[23, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby
;          ROGpbio[34, ROGbiomN0] = ForageFishComp[29, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; walleye              
;       ENDIF
      
       
   ;**********************************************************************************************************
    ; Determine consumption rates        
    YPenc = YEPforage1D(FLOOR(i10Minute*10/60), YP[1, *], YP[26, *], YP[21, *], YPpbio, YPcmx, YP[7, *], YP[30, *], YP[31, *], YP[32, *], $ 
    YP[33, *], YP[34, *], YP[35, *], YP[45, *], YP[46, *], YP[47, *], YP[8, *], YP[9, *], YP[48, *], YP[49, *], YP[50, *], $
    YP[51, *], YP[52, *], YP[53, *], YP[54, *], YP[55, *], YP[56, *], ts, nYP, YP[20, *], YP[28, *], YacclDO[5, *], YP, $
    Envir1D3[10, *], TotBenBio) 
    
    WAEenc = WAEforage(FLOOR(i10Minute*10/60), WAE[1, *], WAE[26, *], WAE[21, *], WAEpbio, WAEcmx, WAE[7, *], WAE[30, *], WAE[31, *], $
    WAE[32, *], WAE[33, *], WAE[34, *], WAE[35, *], WAE[45, *], WAE[46, *], WAE[47, *], WAE[48, *], WAE[8, *], WAE[9, *], $
    WAE[49, *], WAE[50, *], WAE[51, *],WAE[52, *],WAE[53, *],WAE[54, *],WAE[55, *],WAE[56, *],WAE[57, *], WAE[58, *], ts, $
    nWAE, WAE[20, *], WAE[28, *], WacclDO[5, *], WAE) 
    
    RASenc = RASforage(FLOOR(i10Minute*10/60), RAS[1, *], RAS[26, *], RAS[21, *], RASpbio, RAScmx, RAS[7, *], RAS[30, *], $
    RAS[31, *], RAS[32, *], RAS[33, *], RAS[34, *], RAS[35, *], RAS[8, *], RAS[9, *], RAS[48, *], RAS[49, *], RAS[50, *], $
    RAS[51, *], RAS[52, *], RAS[53, *],ts, nRAS, RAS[20, *], RAS[28, *], RacclDO[5, *], RAS) 
    
    EMSenc = EMSforage(FLOOR(i10Minute*10/60), EMS[1, *], EMS[26, *], EMS[21, *], EMSpbio, EMScmx, EMS[7, *], EMS[30, *], $
    EMS[31, *], EMS[32, *], EMS[33, *], EMS[34, *], EMS[35, *], EMS[8, *], EMS[9, *], EMS[48, *], EMS[49, *], EMS[50, *], $
    EMS[51, *], EMS[52, *], EMS[53, *], ts, nEMS, EMS[20, *], EMS[28, *], EacclDO[5, *], EMS) 
    
    ;ROGenc = ROGforage(FLOOR(i10Minute*10/60), ROG[1, *], ROG[26, *], ROG[21, *], ROGpbio, ROGcmx, ROG[7, *], ROG[30, *], $
    ;ROG[31, *], ROG[32, *], ROG[33, *], ROG[34, *], ROG[35, *], ROG[8, *], ROG[9, *], ROG[48, *], ROG[49, *], ROG[50, *], $
    ;ROG[51, *], ROG[52, *], ROG[53, *], ts, nROG, ROG[20, *], ROG[28, *], ROacclDO[5, *], ROG) 
    
    ; Update stomach contents
    YPeaten[0:8, *] = YPenc[0:8, *]; the amount of digeseted 9 prey items used for growth subroutine
    YP[7, *] = YPenc[9, *]; updates yep stomach weight (g)
    YP[60, *] = YPenc[49, *]; gut fullness (%)
    
    YP[9, *] = YPenc[10, *] ;updates yep cumulative total consumption per day (g)
    YP[48, *] = YPenc[29, *] ; total amount of microzooplankton consumed over the last 24 hours in g
    YP[49, *] = YPenc[30, *] ; total amount of small mesozooplankton consumed over the last 24 hours in g
    YP[50, *] = YPenc[31, *] ; total amount of large mesozooplankton consumed over the last 24 hours in g
    YP[51, *] = YPenc[32, *] ; total amount of chironomids consumed over the last 24 hours in g
    YP[52, *] = YPenc[33, *] ; total amount of invasive species consumed over the last 24 hours in g
    YP[53, *] = YPenc[34, *] ; total amount of yellow perch consumed over the last 24 hours in g
    YP[54, *] = YPenc[35, *] ; total amount of emerald shiner consumed over the last 24 hours in g
    YP[55, *] = YPenc[36, *] ; total amount of rainbow smelt consumed over the last 24 hours in g
    YP[56, *] = YPenc[37, *] ; total amount of round goby consumed over the last 24 hours in g
    
    YP[30, *] = YPenc[11, *]; undigested rotifers in the stomach
    YP[31, *] = YPenc[12, *]; undigested copopods in the stomach
    YP[32, *] = YPenc[13, *]; undigested cladocerans in the stomach
    YP[33, *] = YPenc[14, *]; undigested chironomids in the stomach
    YP[34, *] = YPenc[15, *]; undigested invasive species in the stomach       
    YP[35, *] = YPenc[16, *]; undigested yellow perch in the stomach
    YP[45, *] = YPenc[17, *]; undigested emerald shiner in the stomach
    YP[46, *] = YPenc[18, *]; undigested rainbow smelt in the stomach
    YP[47, *] = YPenc[19, *]; undigested round goby in the stomach
    
    
    WAEeaten[0:9, *] = WAEenc[0:9, *]; the amount of digeseted 10 prey items used for growth subroutine
    WAE[7, *] = WAEenc[10, *]; updates WAE stomach weight (g)  
    WAE[60, *] = WAEenc[54, *]; gut fullness (%)
      
    WAE[9, *] = WAEenc[11, *] ;updates WAE cumulative total consumption per day (g)
    WAE[49, *] = WAEenc[32, *]; total amount of microzooplankton consumed over the last 24 hours in g
    WAE[50, *] = WAEenc[33, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
    WAE[51, *] = WAEenc[34, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
    WAE[52, *] = WAEenc[35, *]; total amount of chironomids consumed over the last 24 hours in g
    WAE[53, *] = WAEenc[36, *]; total amount of invasive species consumed over the last 24 hours in g
    WAE[54, *] = WAEenc[37, *]; total amount of yellow perch consumed over the last 24 hours in g
    WAE[55, *] = WAEenc[38, *]; total amount of emerald shiner consumed over the last 24 hours in g
    WAE[56, *] = WAEenc[39, *]; total amount of rainbow smelt consumed over the last 24 hours in g
    WAE[57, *] = WAEenc[40, *]; total amount of round goby consumed over the last 24 hours in g
    WAE[58, *] = WAEenc[41, *]; total amount of walleye consumed over the last 24 hours in g
    
    WAE[30, *] = WAEenc[12, *]; undigested rotifers in the stomach
    WAE[31, *] = WAEenc[13, *]; undigested copopods in the stomach
    WAE[32, *] = WAEenc[14, *]; undigested cladocerans in the stomach
    WAE[33, *] = WAEenc[15, *]; undigested chironomids in the stomach
    WAE[34, *] = WAEenc[16, *]; undigested invasive species in the stomach
    WAE[35, *] = WAEenc[17, *]; undigested yellow perch in the stomach       
    WAE[45, *] = WAEenc[18, *]; undigested emerald shiner in the stomach
    WAE[46, *] = WAEenc[19, *]; undigested rainbow smelt in the stomach
    WAE[47, *] = WAEenc[20, *]; undigested round goby in the stomach
    WAE[48, *] = WAEenc[21, *]; undigested walleye in the stomach
    
    
    RASeaten[0:5, *] = RASenc[0:5, *]; the amount of digeseted 10 prey items used for growth subroutine
    RAS[7, *] = RASenc[9, *]; updates yep stomach weight (g) 
    RAS[60, *] = RASenc[49, *]; gut fullness (%)
       
    RAS[9, *] = RASenc[10, *] ;updates yep cumulative total consumption per day (g)
    RAS[48, *] = RASenc[29, *]; total amount of microzooplankton consumed over the last 24 hours in g
    RAS[49, *] = RASenc[30, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
    RAS[50, *] = RASenc[31, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
    RAS[51, *] = RASenc[32, *]; total amount of chironomids consumed over the last 24 hours in g
    RAS[52, *] = RASenc[33, *]; total amount of invasive species consumed over the last 24 hours in g
    RAS[53, *] = RASenc[34, *]; total amount of yellow perch consumed over the last 24 hours in g
    
    RAS[30, *] = RASenc[11, *]; undigested rotifers in the stomach
    RAS[31, *] = RASenc[12, *]; undigested copopods in the stomach
    RAS[32, *] = RASenc[13, *]; undigested cladocerans in the stomach
    RAS[33, *] = RASenc[14, *]; undigested chironomids in the stomach
    RAS[34, *] = RASenc[15, *]; undigested invasive species in the stomach
    RAS[35, *] = RASenc[16, *]; undigested fish in the stomach       
    
    
    EMSeaten[0:5, *] = EMSenc[0:5, *]; the amount of digeseted 10 prey items used for growth subroutine
    EMS[7, *] = EMSenc[9, *]; updates yep stomach weight (g)    
    EMS[60, *] = EMSenc[49, *]; gut fullness (%)
    
    EMS[9, *] = EMSenc[10, *]; updates yep cumulative total consumption per day (g)
    EMS[48, *] = EMSenc[29, *]; total amount of microzooplankton consumed over the last 24 hours in g
    EMS[49, *] = EMSenc[30, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
    EMS[50, *] = EMSenc[31, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
    EMS[51, *] = EMSenc[32, *]; total amount of chironomids consumed over the last 24 hours in g
    EMS[52, *] = EMSenc[33, *]; total amount of invasive species consumed over the last 24 hours in g
    EMS[53, *] = EMSenc[34, *]; total amount of yellow perch consumed over the last 24 hours in g
    
    EMS[30, *] = EMSenc[11, *]; undigested rotifers in the stomach
    EMS[31, *] = EMSenc[12, *]; undigested copopods in the stomach
    EMS[32, *] = EMSenc[13, *]; undigested cladocerans in the stomach
    EMS[33, *] = EMSenc[14, *]; undigested chironomids in the stomach
    EMS[34, *] = EMSenc[15, *]; undigested invasive species in the stomach
    EMS[35, *] = EMSenc[16, *]; undigested fish in the stomach       


;        ROGeaten[0:5, *] = ROGenc[0:5, *]; the amount of digeseted 10 prey items used for growth subroutine
;        ROG[7, *] = ROGenc[9, *]; updates yep stomach weight (g)  
;        ROG[60, *] = ROGenc[49, *]; gut fullness (%)
;
;        ROG[9, *] = ROGenc[10, *] ;updates yep cumulative total consumption per day (g)
;        ROG[48, *] = ROGenc[29, *]; total amount of microzooplankton consumed over the last 24 hours in g
;        ROG[49, *] = ROGenc[30, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
;        ROG[50, *] = ROGenc[31, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
;        ROG[51, *] = ROGenc[32, *]; total amount of chironomids consumed over the last 24 hours in g
;        ROG[52, *] = ROGenc[33, *]; total amount of invasive species consumed over the last 24 hours in g
;        ROG[53, *] = ROGenc[34, *]; total amount of yellow perch consumed over the last 24 hours in g
;        
;        ROG[30, *] = ROGenc[11, *]; undigested rotifers in the stomach
;        ROG[31, *] = ROGenc[12, *]; undigested copopods in the stomach
;        ROG[32, *] = ROGenc[13, *]; undigested cladocerans in the stomach
;        ROG[33, *] = ROGenc[14, *]; undigested chironomids in the stomach
;        ROG[34, *] = ROGenc[15, *]; undigested invasive species in the stomach
;        ROG[35, *] = ROGenc[16, *]; undigested fish in the stomach  


     WAEDeadPrey = WAEFishDeadPreyArray1D(WAEenc, WAE, nWAE, nVerLay)
     YEPDeadPrey = YEPFishDeadPreyArray1D(YPenc, YP, nYEP, nVerLay)
     
     ; YELLOW PERCH
     ;YEPprey = WHERE(YP[6, *] LE 1., YEPpreycount)
     YEPPreyEaten[0, *] = YEPDeadPrey[4, YP[14,  *]] 
     YEPPreyEaten[1, *] = YEPDeadPrey[10, EMS[14,  *]]; emerald shiner
     YEPPreyEaten[2, *] = YEPDeadPrey[16, RAS[14,  *]]; rainbow smelt
     ;WAEPreyEaten[3, *] = WAEDeadPrey[22, ROG[14,  *]]
     ;WAEprey = WHERE(WAE[6, *] LE 1., WAEpreycount)
     YEPPreyEaten[4, *] = YEPDeadPrey[28, WAE[14,  *]]
     
     ; WALLEYE
     ;YEPprey = WHERE(YP[6, *] LE 1., YEPpreycount)
     ;WAEPreyEaten[0, YEPprey] = WAEDeadPrey[4, YP[14,  YEPprey]] 
     WAEPreyEaten[0, *] = WAEDeadPrey[4, YP[14,  *]] 
     WAEPreyEaten[1, *] = WAEDeadPrey[10, EMS[14,  *]]; emerald shiner
     WAEPreyEaten[2, *] = WAEDeadPrey[16, RAS[14,  *]]; rainbow smelt
     ;WAEPreyEaten[3, *] = WAEDeadPrey[22, ROG[14,  *]]
     ;WAEprey = WHERE(WAE[6, *] LE 1., WAEpreycount)
     ;WAEPreyEaten[4, WAEprey] = WAEDeadPrey[28, WAE[14,  WAEprey]]
     WAEPreyEaten[4, *] = WAEDeadPrey[28, WAE[14,  *]]
     ;PRINT, 'WAEPreyEaten'
     ;PRINT, WAEPreyEaten[*, 0:199]
     
     PRINT, 'YELLOW PERCH' 
     PRINT, YEPDeadPrey[4, *] 
     PRINT, 'EMERALD SHINER' 
     PRINT, YEPDeadPrey[10, *]
     PRINT, 'RAINBOW SMELT' 
     PRINT, YEPDeadPrey[16, *]
;     PRINT, 'WALLEYE' 
;     PRINT, YEPDeadPrey[28, *]
     
     PRINT, 'YELLOW PERCH' 
     PRINT, WAEDeadPrey[4, *] 
     PRINT, 'EMERALD SHINER' 
     PRINT, WAEDeadPrey[10, *]
     PRINT, 'RAINBOW SMELT' 
     PRINT, WAEDeadPrey[16, *]
     PRINT, 'WALLEYE' 
     PRINT, WAEDeadPrey[28, *]
     
     ; YELLOW PERCH                 
     YP[0, YEPPreyFishForage[38, *]] = YP[0, YEPPreyFishForage[38, *]] - YEPDeadPrey[4, *] 
     EMS[0, YEPPreyFishForage[39, *]] = EMS[0, YEPPreyFishForage[39, *]] - YEPDeadPrey[10, *] 
     RAS[0, YEPPreyFishForage[40, *]] = RAS[0, YEPPreyFishForage[40, *]] - YEPDeadPrey[16, *] 
     ;WAE[0, YEPPreyFishForage[42, *]] = WAE[0, YEPPreyFishForage[42, *]] - YEPDeadPrey[28, *]                 
                   
     ; WALLEYE                               
     YP[0, WAEPreyFishForage[38, *]] = YP[0, WAEPreyFishForage[38, *]] - WAEDeadPrey[4, *] 
     EMS[0, WAEPreyFishForage[39, *]] = EMS[0, WAEPreyFishForage[39, *]] - WAEDeadPrey[10, *] 
     RAS[0, WAEPreyFishForage[40, *]] = RAS[0, WAEPreyFishForage[40, *]] - WAEDeadPrey[16, *] 
     WAE[0, WAEPreyFishForage[42, *]] = WAE[0, WAEPreyFishForage[42, *]] - WAEDeadPrey[28, *] 
        
       
    ; Respiration/Routine metabolism 
    YPres = YEPresp1D(YP[19, *], YP[27, *], YP[2, *], YP[1, *], ts, YP[20, *], YP[29, *], YacclDO[4, *], nYP, YP[63, *]) ; determine respiration for yellow perch 
    WAEres = WAEresp(WAE[19, *], WAE[27, *], WAE[2, *], WAE[1, *], ts, WAE[20, *], WAE[29, *], WacclDO[4, *], nWAE, WAE[63, *]); determine respiration for 
    RASres = RASresp(RAS[19, *], RAS[27, *], RAS[2, *], RAS[1, *], ts, RAS[20, *], RAS[29, *], RacclDO[4, *], nRAS, RAS[63, *]); determine respiration for 
    EMSres = EMSresp(EMS[19, *], EMS[27, *], EMS[2, *], EMS[1, *], ts, EMS[20, *], EMS[29, *], EacclDO[4, *], nEMS, EMS[63, *]); determine respiration for 
    ;ROGres = ROGresp(ROG[19, *], ROG[27, *], ROG[2, *], ROG[1, *], ts, ROG[20, *], ROG[29, *], ROacclDO[4, *], nROG, ROG[63, *]); determine respiration for     
;       PRINT, 'RASres[0, *]'
;       PRINT, TRANSPOSE(RASres[0, 0:100])
;       PRINT, 'EMSres[0, *]'
;       PRINT, TRANSPOSE(EMSres[0, 0:100])
;       PRINT, 'ROGres[0, *]'
;       PRINT, TRANSPOSE(ROGres[0, 0:100])
   
   ; Update cumulative daily respiration rates
    YP[59, *] = YP[59, *] + YPres[0, *]; RESPIRATION RATE
    WAE[59, *] = WAE[59, *] + WAEres[0, *]; RESPIRATION RATE
    RAS[59, *] = RAS[59, *] + RASres[0, *]; RESPIRATION RATE
    EMS[59, *] = EMS[59, *] + EMSres[0, *]; RESPIRATION RATE
    ;ROG[59, *] = ROG[59, *] + ROGres[0, *]; RESPIRATION RATE
    
    ; O2 debt from hypoxia exposure
    YP[63, *] = YPres[2, *]; 
    WAE[63, *] = WAEres[2, *];
    RAS[63, *] = RASres[2, *]; 
    EMS[63, *] = EMSres[2, *]; 
    ;ROG[63, *] = ROGres[2, *]; 
    
;       PRINT, 'RASenc[0:5, *]'
;       PRINT, total(RASenc[0:5, 0:100],1)
;       PRINT, 'EMSenc[0:5, *]'
;       PRINT, total(EMSenc[0:5, 0:100],1)
;       PRINT, 'ROGenc[0:5, *]'
;       PRINT, total(ROGenc[0:5, 0:100],1)
;       PRINT, 'RASeaten[0:5, *]'
;       PRINT, total(RASeaten[0:5, 0:100],1)
;       PRINT, 'EMSeaten[0:5, *]'
;       PRINT, total(EMSeaten[0:5, 0:100],1)
;       PRINT, 'ROGeaten[0:5, *]'
;       PRINT, total(ROGeaten[0:5, 0:100],1)

      
    ; Growth
    YPgro = YEPgrowth(YP[1, *], YP[2, *], YP[3, *], YP[4, *], YPcmx, YPeaten, YPres[0, *], YP[26, *], nYP, ts, Envir1D2[1, 0]-1L, FLOOR(i10Minute*10/60)-1L, (LightEnvir1d2[3, *])/TS)
    WAEgro = WAEgrowth1D(WAE[1, *], WAE[2, *], WAE[3, *], WAE[4, *], WAEcmx, WAEeaten, WAEres[0, *], WAE[26, *], nWAE, ts, Envir1D2[1, 0]-1L, FLOOR(i10Minute*10/60)-1L, (LightEnvir1d2[3, *])/TS)
    RASgro = RASgrowth(RAS[1, *], RAS[2, *], RAS[3, *], RAS[4, *], RAScmx, RASeaten, RASres[0, *], RAS[26, *], nRAS, ts, Envir1D2[1, 0]-1L, FLOOR(i10Minute*10/60)-1L, (LightEnvir1d2[3, *])/TS)
    EMSgro = EMSgrowth(EMS[1, *], EMS[2, *], EMS[3, *], EMS[4, *], EMScmx, EMSeaten, EMSres[0, *], EMS[26, *], nEMS, ts, Envir1D2[1, 0]-1L, FLOOR(i10Minute*10/60)-1L, (LightEnvir1d2[3, *])/TS)
    ;ROGgro = ROGgrowth(ROG[1, *], ROG[2, *], ROG[3, *], ROG[4, *], ROGcmx, ROGeaten, ROGres[0, *], ROG[26, *], nROG, ts, Envir1D2[1, 0]-1L, FLOOR(i10Minute*10/60)-1L, (LightEnvir1d2[3, *])/TS)

    ; Update body size
    YP[1, *] = YPgro[1, *] ;updates yep length (mm)
    YP[2, *] = YPgro[0, *] ;updates yep weight (g)
    YP[3, *] = YPgro[3, *] ;updates yep storage weight (g)   
    YP[4, *] = YPgro[2, *] ;updates yep structure weight (g)
    YP[61, *] = YP[61, *] + YPgro[4, *] ;updates YEP cumulative growth in length (mm)   
    YP[62, *] = YP[62, *] + YPgro[5, *] ;updates YEP cumulataive growth in weight (g)
  
    WAE[1,*] = WAEgro[1,*] ;updates WAE length (mm)
    WAE[2,*] = WAEgro[0,*] ;updates WAE weight (g)
    WAE[3,*] = WAEgro[3,*] ;updates WAE storage weight (g)
    WAE[4,*] = WAEgro[2,*] ;updates WAE Structure weight (g)
    WAE[61, *] = WAE[61, *] + WAEgro[4, *] ;updates WAE cumulative growth in length (mm)   
    WAE[62, *] = WAE[62, *] + WAEgro[5, *] ;updates WAE cumulataive growth in weight (g)
 
    RAS[1, *] = RASgro[1, *] ;updates RAS length (mm)
    RAS[2, *] = RASgro[0, *] ;updates RAS weight (g)
    RAS[3, *] = RASgro[3, *] ;updates RAS storage weight (g)   
    RAS[4, *] = RASgro[2, *] ;updates RAS structure weight (g)
    RAS[61, *] = RAS[61, *] + RASgro[4, *] ;updates RAS cumulative growth in length (mm)   
    RAS[62, *] = RAS[62, *] + RASgro[5, *] ;updates RAS cumulataive growth in weight (g)
    
    EMS[1, *] = EMSgro[1, *] ;updates EMS length (mm)
    EMS[2, *] = EMSgro[0, *] ;updates EMS weight (g)
    EMS[3, *] = EMSgro[3, *] ;updates EMS storage weight (g)   
    EMS[4, *] = EMSgro[2, *] ;updates EMS structure weight (g)
    EMS[61, *] = EMS[61, *] + EMSgro[4, *] ;updates EMS cumulative growth in length (mm)   
    EMS[62, *] = EMS[62, *] + EMSgro[5, *] ;updates EMS cumulataive growth in weight (g)
    
;        ROG[1, *] = ROGgro[1, *] ;updates ROG length (mm)
;        ROG[2, *] = ROGgro[0, *] ;updates ROG weight (g)
;        ROG[3, *] = ROGgro[3, *] ;updates ROG storage weight (g)   
;        ROG[4, *] = ROGgro[2, *] ;updates ROG structure weight (g)
;        ROG[61, *] = ROG[61, *] + ROGgro[4, *] ;updates ROG cumulative growth in length (mm)   
;        ROG[62, *] = ROG[62, *] + ROGgro[5, *] ;updates ROG cumulataive growth in weight (g)

       
   ; Total mortality = predation + starvation + suffocation
    YEPlost = YEPmort(YP[1, *], YP[3, *], YP[4, *], YP[0, *], nYP, td, ts, YP[20, *], YP[29, *], YacclDO[2, *], YP[21, *]); mortality of yellow perch
    WAElost = WAEmort(WAE[1, *], WAE[3, *], WAE[4, *], WAE[0, *], nWAE, td, ts, WAE[20, *], WAE[29, *], WacclDO[2, *], WAE[21, *]); mortality of yellow perch
    RASlost = RASmort(RAS[1, *], RAS[3, *], RAS[4, *], RAS[0, *], nRAS, td, ts, RAS[20, *], RAS[29, *], RacclDO[2, *], RAS[21, *]); mortality of yellow perch
    EMSlost = EMSmort(EMS[1, *], EMS[3, *], EMS[4, *], EMS[0, *], nEMS, td, ts, EMS[20, *], EMS[29, *], EacclDO[2, *], EMS[21, *]); mortality of yellow perch
    ;ROGlost = ROGmort(ROG[1, *], ROG[3, *], ROG[4, *], ROG[0, *], nROG, td, ts, ROG[20, *], ROG[29, *], ROacclDO[2, *], ROG[21, *]); mortality of yellow perch

    ; Update numbers of individuals in superindividuals
    ; Remove individuals from predation (0), starvation (1), and suffocation (2)
    YP[36, *] = YEPlost[3, *]
    YP[64, *] = YP[64, *] + YEPlost[0, *] + YEPPreyEaten[0, *] + WAEPreyEaten[0, *]; predation; NEED TO ADJUST FOR CANIBALISM

    YP[65, *] = YP[65, *] + YEPlost[1, *]; starvation
    YP[66, *] = YP[66, *] + YEPlost[2, *]; suffocation
    YP[0, *] = YP[0, *] - YEPlost[0, *] - YEPlost[1, *] - YEPlost[2, *]
    
    WAE[36, *] = WAElost[3, *]
    WAE[64, *] = WAE[64, *] + WAElost[0, *] + WAEPreyEaten[4, *]; NEED TO ADJUST FOR CANIBALISM
    
    WAE[65, *] = WAE[65, *] + WAElost[1, *]
    WAE[66, *] = WAE[66, *] + WAElost[2, *]
    WAE[0, *] = WAE[0, *] - WAElost[0, *] - WAElost[1, *] - WAElost[2, *]
    
    RAS[36, *] = RASlost[3, *]
    RAS[64, *] = RAS[64, *] + RASlost[0, *]+ YEPPreyEaten[2, *] + WAEPreyEaten[2, *]
    RAS[65, *] = RAS[65, *] + RASlost[1, *]
    RAS[66, *] = RAS[66, *] + RASlost[2, *]
    RAS[0, *] = RAS[0, *] - RASlost[0, *] - RASlost[1, *] - RASlost[2, *]
    
    EMS[36, *] = EMSlost[3, *]
    EMS[64, *] = EMS[64, *] + EMSlost[0, *]+ YEPPreyEaten[1, *] + WAEPreyEaten[1, *]
    EMS[65, *] = EMS[65, *] + EMSlost[1, *]
    EMS[66, *] = EMS[66, *] + EMSlost[2, *]
    EMS[0, *] = EMS[0, *] - EMSlost[0, *] - EMSlost[1, *] - EMSlost[2, *]
    
;        ROG[36, *] = ROGlost[3, *]
;        ROG[64, *] = ROG[64, *] + ROGlost[0, *]; + WAEenc[52, *] + YPenc[48, *]
;        ROG[65, *] = ROG[65, *] + ROGlost[1, *]
;        ROG[66, *] = ROG[66, *] + ROGlost[2, *]
;        ROG[0, *] = ROG[0, *] - ROGlost[0, *] - ROGlost[1, *] - ROGlost[2, *]


    ; Spawning for mature adults (it occurs only once a year???)
    ; YPspawn =
    ; WEspawn =
    ; ESspawn =
    ; RSspawn =       
    ; RGspawn =

    ;ENDIF
       
        
      ;***the following is for simulations with hatching only****************************************************
      ; For yellow perch that have not hatched
      ;IF (ccy GT 0) THEN BEGIN ; updates environment of YP that haven't hatched
       ; IF (itime EQ 0) THEN BEGIN ; only update once an hour
        ;  FOR jj = 0, nYP - 1 DO BEGIN;--------------------------------------------------------
         ;   egg = WHERE(envir3d[4,*] EQ YP[14, jj], count)
          ;  YP[10 : 24, jj] = envir3d[*, egg]
            ;print, 'update yp envir of eggs
 
        ;Update size info for yellow perch that have NOT hatched
        ;YP[1,checkcyy] = YP[1,checkcyy] + YPgro[1,checkcyy] ;updates yep length (mm)
        ;YP[2,checkcyy] = YP[2,checkcyy] + YPgro[0,checkcyy] ;updates yep weight (g)
        ;YP[3,checkcyy] = YP[3,checkcyy] + YPgro[3,checkcyy] ;updates yep storage weight (g)
        ;YP[4,checkcyy] = YP[4,checkcyy] + YPgro[2,checkcyy] ;updates yep structure weight (g)
     
        ;Update numbers of individuals for yellow perch
        
        ;YP[0,checkcyy] = YP[0,checkcyy] - YPlost[0,checkcyy] - YPlost[1,checkcyy] ;remove individuals from predation and starvation   
       ;   ENDFOR;*******************************************************************************
       ; ENDIF
      ;ENDIF
      ;*********************************************************************************************************
          

   ; Create output files (seasonal time frame)
    IF (FLOOR(i10Minute*10/60) EQ go_out_morn_hr[iDay-152L]) AND (LightEnvir1d2[3, *] EQ go_out_morn_min[iDay-152L]) THEN BEGIN
      Time='_Morning_'
      OutputFiles = EcoFore1DSEIBMOutputFiles(counter, nYP, nEMS, nRAS, nROG, nWAE, nVerLay, YP, EMS, RAS, ROG, WAE, Hypoxia, DensityDependence, Time, Rep, Envir1D3)
    ENDIF
     
    IF (FLOOR(i10Minute*10/60) EQ 13L) AND (LightEnvir1d2[3, *] EQ 20L) THEN BEGIN
      Time='_Midday_'
      OutputFiles = EcoFore1DSEIBMOutputFiles(counter, nYP, nEMS, nRAS, nROG, nWAE, nVerLay, YP, EMS, RAS, ROG, WAE, Hypoxia, DensityDependence, Time, Rep, Envir1D3)
    ENDIF
     
    IF (FLOOR(i10Minute*10/60) EQ go_out_aft_hr[iDay-152L]) AND (LightEnvir1d2[3, *] EQ go_out_aft_min[iDay-152L]) THEN BEGIN
      Time='_Afternoon_'
      OutputFiles = EcoFore1DSEIBMOutputFiles(counter, nYP, nEMS, nRAS, nROG, nWAE, nVerLay, YP, EMS, RAS, ROG, WAE, Hypoxia, DensityDependence, Time, Rep, Envir1D3)
    ENDIF
     
    IF (FLOOR(i10Minute*10/60) EQ 1L) AND (LightEnvir1d2[3, *] EQ 50L) THEN BEGIN
      Time='_Midnight_'
      OutputFiles = EcoFore1DSEIBMOutputFiles(counter, nYP, nEMS, nRAS, nROG, nWAE, nVerLay, YP, EMS, RAS, ROG, WAE, Hypoxia, DensityDependence, Time, Rep, Envir1D3)
    ENDIF   
    ;*************************************************************************************
     
      
    t_elapsed = systime(/seconds) - tstart4
    PRINT, 'Elapesed time (seconds) in a time step loop:', t_elapsed  
    PRINT, 'Elapesed time (minutes) in a time step loop:', t_elapsed/60.
   ENDFOR;**************************************************END OF EACH TIME STEP***************************************************
   ;PRINT, 'Water Tempearture and Haching Temperature',YP[19,*], YP[25,*]
   ;ENDIF  
  
  
  ; Reset cumulative daily consumption AND RESPIRATION AND DAILY GROWTH AND daily mortality for the next day
  YP[9, *] = 0.0 ; updates YEP cumulative daily total consumption (g) FOR THE NEXT DAY
  YP[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
  YP[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
  YP[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
  YP[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
  YP[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
  YP[53, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
  YP[54, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
  YP[55, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
  YP[56, *] = 0.0; total amount of round goby consumed over the last 24 hours in g
  
  YP[59, *] = 0.0; RESPIRATION
  
  YP[61, *] = 0. ;updates yep cumulative growth in length (mm)   
  YP[62, *] = 0. ;updates yep cumulataive growth in weight (g)
  
  YP[36, *] = 0.; daily hypoxia stress
  YP[64, *] = 0.; daily predation
  YP[65, *] = 0.; daily starvation
  YP[66, *] = 0.; daily suffocation
  
  
  WAE[9, *] = 0.0 ; updates WAE cumulative daily total consumption (g) FOR THE NEXT DAY
  WAE[49, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
  WAE[50, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
  WAE[51, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
  WAE[52, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
  WAE[53, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
  WAE[54, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
  WAE[55, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
  WAE[56, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
  WAE[57, *] = 0.0; total amount of round goby consumed over the last 24 hours in g
  WAE[58, *] = 0.0; total amount of walleye consumed over the last 24 hours in g
  
  WAE[59, *] = 0.0; RESPIRATION
  
  WAE[61, *] = 0. ;updates yep cumulative growth in length (mm)   
  WAE[62, *] = 0. ;updates yep cumulataive growth in weight (g)
  
  WAE[36, *] = 0.; daily hypoxia stress
  WAE[64, *] = 0.; daily predation
  WAE[65, *] = 0.; daily starvation
  WAE[66, *] = 0.; daily suffocation
  
  
  RAS[9, *] = 0.0 ; updates RAS cumulative daily total consumption (g) FOR THE NEXT DAY
  RAS[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
  RAS[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
  RAS[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
  RAS[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
  RAS[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
  RAS[53, *] = 0.0; total amount of fish consumed over the last 24 hours in g
  
  RAS[59, *] = 0.0; RESPIRATION
  
  RAS[61, *] = 0. ;updates yep cumulative growth in length (mm)   
  RAS[62, *] = 0. ;updates yep cumulataive growth in weight (g)
  
  RAS[36, *] = 0.; daily hypoxia stress
  RAS[64, *] = 0.; daily predation
  RAS[65, *] = 0.; daily starvation
  RAS[66, *] = 0.; daily suffocation
  
  
  EMS[9, *] = 0.0 ; updates EMS cumulative daily total consumption (g) FOR THE NEXT DAY
  EMS[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
  EMS[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
  EMS[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
  EMS[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
  EMS[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
  EMS[53, *] = 0.0; total amount of fish consumed over the last 24 hours in g
  
  EMS[59, *] = 0.0; RESPIRATION
  
  EMS[61, *] = 0. ;updates yep cumulative growth in length (mm)   
  EMS[62, *] = 0. ;updates yep cumulataive growth in weight (g)
  
  EMS[36, *] = 0.; daily hypoxia stress
  EMS[64, *] = 0.; daily predation
  EMS[65, *] = 0.; daily starvation
  EMS[66, *] = 0.; daily suffocation
  
  
;  ROG[9, *] = 0.0 ; updates ROG cumulative daily total consumption (g) FOR THE NEXT DAY
;  ROG[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
;  ROG[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
;  ROG[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
;  ROG[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
;  ROG[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
;  ROG[53, *] = 0.0; total amount of fish consumed over the last 24 hours in g

;  ROG[59, *] = 0.0; RESPIRATION

;  ROG[61, *] = 0. ;updates yep cumulative growth in length (mm)   
;  ROG[62, *] = 0. ;updates yep cumulataive growth in weight (g)

;  ROG[36, *] = 0.; daily hypoxia stress
;  ROG[64, *] = 0.; daily predation
;  ROG[65, *] = 0.; daily starvation
;  ROG[66, *] = 0.; daily suffocation
 
 
  ;*****NEED TO CHANGE INITIAL TOTAL NUMBER OF POPULATIONS****
  ; YEP 
  YEPAgeProp = FLTARR(7)
  YEPAgeProp[0] = 0.284; 
  YEPAgeProp[1] = 0.284; 
  YEPAgeProp[2] = 0.191; 
  YEPAgeProp[3] = 0.124; 
  YEPAgeProp[4] = 0.066; 
  YEPAgeProp[5] = 0.028; 
  YEPAgeProp[6] = 0.023;
  YEPAge0 = WHERE(YP[6, *] EQ 0L, YEPAge0count)
  YEPAge1 = WHERE(YP[6, *] EQ 1L, YEPAge1count)
  YEPAge2 = WHERE(YP[6, *] EQ 2L, YEPAge2count)
  YEPAge3 = WHERE(YP[6, *] EQ 3L, YEPAge3count)
  YEPAge4 = WHERE(YP[6, *] EQ 4L, YEPAge4count)
  YEPAge5 = WHERE(YP[6, *] EQ 5L, YEPAge5count)
  YEPAge6 = WHERE(YP[6, *] EQ 6L, YEPAge6count)
  ; WAE
  WAEAgeProp = FLTARR(8)
  WAEAgeProp[0] = 0.355; 
  WAEAgeProp[1] = 0.164; 
  WAEAgeProp[2] = 0.166; 
  WAEAgeProp[3] = 0.109; 
  WAEAgeProp[4] = 0.067; 
  WAEAgeProp[5] = 0.052; 
  WAEAgeProp[6] = 0.033; 
  WAEAgeProp[7] = 0.054; 
  WAEAge0 = WHERE(WAE[6, *] EQ 0L, WAEAge0count)
  WAEAge1 = WHERE(WAE[6, *] EQ 1L, WAEAge1count)
  WAEAge2 = WHERE(WAE[6, *] EQ 2L, WAEAge2count)
  WAEAge3 = WHERE(WAE[6, *] EQ 3L, WAEAge3count)
  WAEAge4 = WHERE(WAE[6, *] EQ 4L, WAEAge4count)
  WAEAge5 = WHERE(WAE[6, *] EQ 5L, WAEAge5count)
  WAEAge6 = WHERE(WAE[6, *] EQ 6L, WAEAge6count)
  WAEAge7 = WHERE(WAE[6, *] EQ 7L, WAEAge7count)
  ; RAS
  RASAgeProp = FLTARR(2)
  RASAgeProp[0] = 0.748; 
  RASAgeProp[1] = 0.252; 
  RASAge0 = WHERE(RAS[6, *] EQ 0L, RASAge0count)
  RASAge1 = WHERE(RAS[6, *] EQ 1L, RASAge1count)
  ; EMS
  EMSAgeProp = FLTARR(2)
  EMSAgeProp[0] = 0.596; 
  EMSAgeProp[1] = 0.404; 
  EMSAge0 = WHERE(EMS[6, *] EQ 0L, EMSAge0count)
  EMSAge1 = WHERE(EMS[6, *] EQ 1L, EMSAge1count)

  ;*****NEED TO CHANGE INITIAL TOTAL NUMBER OF POPULATIONS****
  PRINT, 'Total number of surviving YEP individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,*])
  PRINT, 'Total biomass of surviving YEP individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,*]*YP[2,*])
  PRINT, '% surviving YEP individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,*])/(NpopYP);
  IF YEPAge0count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge0])
    PRINT, 'Total biomass of surviving YEP Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge0]*YP[2,YEPAge0])
    PRINT, '% surviving YEP Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge0])/(NpopYP*YEPAgeProp[0]);
  ENDIF
  IF YEPAge1count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge1])
    PRINT, 'Total biomass of surviving YEP Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge1]*YP[2,YEPAge1])
    PRINT, '% surviving YEP Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge1])/(NpopYP*YEPAgeProp[1]);
  ENDIF
  IF YEPAge2count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge2])
    PRINT, 'Total biomass of surviving YEP Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge2]*YP[2,YEPAge2])
    PRINT, '% surviving YEP Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge2])/(NpopYP*YEPAgeProp[2]);
  ENDIF
  IF YEPAge3count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge3])
    PRINT, 'Total biomass of surviving YEP Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge3]*YP[2,YEPAge3])
    PRINT, '% surviving YEP Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge3])/(NpopYP*YEPAgeProp[3]);
  ENDIF
  IF YEPAge4count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge4])
    PRINT, 'Total biomass of surviving YEP Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge4]*YP[2,YEPAge4])
    PRINT, '% surviving YEP Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge4])/(NpopYP*YEPAgeProp[4]);
  ENDIF
  IF YEPAge5count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge5])
    PRINT, 'Total biomass of surviving YEP Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge5]*YP[2,YEPAge5])
    PRINT, '% surviving YEP Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge5])/(NpopYP*YEPAgeProp[5]);
  ENDIF
  IF YEPAge6count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving YEP Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge6])
    PRINT, 'Total biomass of surviving YEP Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge6]*YP[2,YEPAge6])
    PRINT, '% surviving YEP Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,YEPAge6])/(NpopYP*YEPAgeProp[6]);
  ENDIF
  
  PRINT, 'Total number of surviving WAE individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,*])
  PRINT, 'Total biomass of surviving WAE individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,*]*WAE[2,*])  
  PRINT, '% surviving WAE individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,*])/(NpopWAE);
  IF WAEAge0count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge0])
    PRINT, 'Total biomass of surviving WAE Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge0]*WAE[2,WAEAge0])
    PRINT, '% surviving WAE Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge0])/(NpopWAE*WAEAgeProp[0]);
  ENDIF
  IF WAEAge1count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge1])
    PRINT, 'Total biomass of surviving WAE Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge1]*WAE[2,WAEAge1])
    PRINT, '% surviving WAE Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge1])/(NpopWAE*WAEAgeProp[1]);
  ENDIF
  IF WAEAge2count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge2])
    PRINT, 'Total biomass of surviving WAE Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge2]*WAE[2,WAEAge2])
    PRINT, '% surviving WAE Age 2 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge2])/(NpopWAE*WAEAgeProp[2]);
  ENDIF
  IF WAEAge3count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge3])
    PRINT, 'Total biomass of surviving WAE Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge3]*WAE[2,WAEAge3])
    PRINT, '% surviving WAE Age 3 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge3])/(NpopWAE*WAEAgeProp[3]);
  ENDIF
  IF WAEAge4count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge4])
    PRINT, 'Total biomass of surviving WAE Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge4]*WAE[2,WAEAge4])
    PRINT, '% surviving WAE Age 4 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge4])/(NpopWAE*WAEAgeProp[4]);
  ENDIF
  IF WAEAge5count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge5])
    PRINT, 'Total biomass of surviving WAE Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge5]*WAE[2,WAEAge5])
    PRINT, '% surviving WAE Age 5 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge5])/(NpopWAE*WAEAgeProp[5]);
  ENDIF
  IF WAEAge6count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge6])
    PRINT, 'Total biomass of surviving WAE Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge6]*WAE[2,WAEAge6])
    PRINT, '% surviving WAE Age 6 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge6])/(NpopWAE*WAEAgeProp[6]);
  ENDIF
  IF WAEAge7count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving WAE Age 7 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge7])
    PRINT, 'Total biomass of surviving WAE Age 7 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge7]*WAE[2,WAEAge7])
    PRINT, '% surviving WAE Age 7 individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,WAEAge7])/(NpopWAE*WAEAgeProp[7]);
  ENDIF
  
  PRINT, 'Total number of surviving RAS individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,*])
  PRINT, 'Total biomass of surviving RAS individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,*]*RAS[2,*])
  PRINT, '% surviving RAS individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,*])/(NpopRAS);
  IF RASAge0count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving RAS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge0])
    PRINT, 'Total biomass of surviving RAS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge0]*RAS[2,RASAge0])
    PRINT, '% surviving RAS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge0])/(NpopRAS*RASAgeProp[0]);
  ENDIF
  IF RASAge1count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving RAS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge1])
    PRINT, 'Total biomass of surviving RAS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge1]*RAS[2,RASAge1])
    PRINT, '% surviving RAS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,RASAge1])/(NpopRAS*RASAgeProp[1]);
  ENDIF
  
  PRINT, 'Total number of surviving EMS individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,*])
  PRINT, 'Total biomass of surviving EMS individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,*]*EMS[2,*]) 
  PRINT, '% surviving EMS individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,*])/(NpopEMS);
  IF EMSAge0count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving EMS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge0])
    PRINT, 'Total biomass of surviving EMS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge0]*EMS[2,EMSAge0])
    PRINT, '% surviving EMS Age 0 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge0])/(NpopEMS*EMSAgeProp[0]);
  ENDIF
  IF EMSAge1count GT 0. THEN BEGIN
    PRINT, 'Total number of surviving EMS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge1])
    PRINT, 'Total biomass of surviving EMS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge1]*EMS[2,EMSAge1])
    PRINT, '% surviving EMS Age 1 individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,EMSAge1])/(NpopEMS*EMSAgeProp[1]);
  ENDIF
  
;  PRINT, 'Total number of surviving ROG individuals at the end of DAY', iday + 1, '     =', TOTAL(ROG[0,*])
;  PRINT, '% surviving ROG individuals at the end of DAY', iday + 1, '     =', TOTAL(ROG[0,*])/(NpopROG);
     

    t_elapsed = systime(/seconds) - tstart3
    PRINT, 'Elapesed time (seconds) in a DAILY loop:', t_elapsed  
    PRINT, 'Elapesed time (minutes) in a DAILY loop:', t_elapsed/60.
  ENDFOR;****************************************************END OF A DAILY LOOP***********************************************************************
 
  ;yDV = YPLhatch; updates YEP cumulative daily egg develpment FOR THE NEXT DAY
  ; IF cy GT 0.0 THEN yDVy = YP1stfeed; updates YEP cumulative daily yolk-sac larvae FOR THE NEXT DAY
   
 
  t_elapsed = systime(/seconds) - tstart2
  PRINT, 'Elapesed time (seconds) in a YEARLY loop:', t_elapsed  
  PRINT, 'Elapesed time (minutes) in a YEARLY loop:', t_elapsed/60.
ENDFOR;*******************************************************END OF A YEARLY LOOP*******************************************************************
;PRINT, 'State variables for yellow perch (YP)'
;PRINT, YP
;PRINT, 'State variables for walleye (WAE)'
;PRINT, WAE
;PRINT, 'State variables for rainbow smelt (RAS)'
;PRINT, RAS
;PRINT, 'State variables for emerald shiner(EMS)'
;PRINT, EMS
;PRINT, 'State variables for round goby (ROG)'
;PRINT, ROG


t_elapsed = systime(/seconds) - tstart1
PRINT, 'Elapesed time (seconds) for all simulations:', t_elapsed 
PRINT, 'Elapesed time (minutes) for all simulations:', t_elapsed/60. 
PRINT, 'END OF ALL SIMULATIONS'
END