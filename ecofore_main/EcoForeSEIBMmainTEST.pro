PRO EcoForeSEIBMmainTEST; *Lake Erie Spatially Explicit Indiviudal-Based Models for walleye (WAE), 
; yellow perch (YEP), Ranbow Smelt (RAS), Round Goby (ROG), and Emerald Shiner (EMS).
; *Retrospective simulations using input data are calibrated for 2005.
; 
;*****Complete population and community structure for simulations*********
; In Lake Erie (from Great Lakes Fishery Commission Report for 2005),
; 7 age classes for yellow perch: 0, 1, 2, 3, 4, 5, and 6+.
; 8 age classes for walleye: 0, 1, 2, 3, 4, 5, 6, and 7+
; 2 age classes for rainbow smelt: 0 and 1+
; 2 age classes for emerald shiner: 0 and 1+
; 2 age classes for round goby: 0 and 1+
;*************************************************************************

;*************************************************************************
;Hypoxia
Hypoxia = 'ON'
;Density dependence
DensityDependence = 'ON'
;Replicate
Rep = 'ONE'
;************************************************************************

; Time steps of simulations
ts = 15L ;minutes in a time step
td = (60L/ts)*24L ; number of time steps in a day

; Total number of superindividuals in each cohort
nYP = 50000L ; number of YEP superindividuals(SIs)
nWAE = 50000L; number of WAE SIs
nRAS = 50000L; number of RAS SIs
nEMS = 50000L; number of EMS SIs
nROG = 50000L; number of ROG SIs

; INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE; 50,000,000
NpopYP = 103540000D + 78843333D + 122247000D + 3257000D + 23600000D + 1645000D + 8300000D; number of YEP individuals
NpopWAE = 10710000D + 6960000D + 30129000D + 150000D + 8138000D + 553000D + 2430000D + 1028000D ; number of WAE individuals
NpopRAS = 36683333D + 63653333D; number of RAS individuals
NpopEMS = 446761667D + 432036667D; number of EMS individuals
NpopROG = 201138333D + 260038333D; number of ROG individuals
;PRINT, NpopYP 
;PRINT, NpopWAE 
;PRINT, NpopRAS
;PRINT, NpopEMS 
;PRINT, NpopROG

nGridcell = 77500L; the number of total grid cells
nEnvir3d = 77500*24L
TotBenBio = FLTARR(nGridcell)
Envir3d2 = FLTARR(16L, nGridcell)

;***************************************Spatial Component***********************************************
Grid3D2 =FLTARR(5L, nGridcell)
Grid2D2 = FLTARR(4L, 3875L)
Grid3D = GridCells3D()
Grid3D2 = Grid3D
;GrdCell3D[0, *] = xloc
;GrdCell3D[1, *] = yloc
;GrdCell3D[2, *] = zloc
;GrdCell3D[3, *] = GridID; for x and y
;GrdCell3D[4, *] = GridNo
Grid2D = GridCells2D()
Grid2D2 = Grid2D
;xyH[0, *] = xH
;xyH[1, *] = yH
;xyH[2, *] = xyID
;xyH[3, *] = Dpt
;********************************************************************************************************

PreyFish = FLTARR(28L, nGridcell)
;YEPPreyFish = FLTARR(5L, nGridcell)
;RASPreyFish = FLTARR(5L, nGridcell)
;EMSPreyFish = FLTARR(5L, nGridcell)
;ROGPreyFish = FLTARR(5L, nGridcell)
;WAEPreyFish = FLTARR(5L, nGridcell)
YPpbio = FLTARR(25, nYP)
WAEpbio = FLTARR(25, nWAE)
RASpbio = FLTARR(25, nRAS)
EMSpbio = FLTARR(25, nEMS)
ROGpbio = FLTARR(25, nROG)

; Daily fractional development toward hatching
yDV = FLTARR(nYP) ; determines when individual yellow perch hatch
wDV = FLTARR(nWAE) ; determines when individual walleye hatch
rDV = FLTARR(nRAS) ; determines when individual rainbow smelt hatch
wDV = FLTARR(nEMS) ; determines when individual emerald shiner hatch
roDV = FLTARR(nROG) ; determines when individual round goby hatch

; Daily fractional development toward 1st feeding
yDVy = FLTARR(nYP) ; determines when individual yellow perch feed
wDVy = FLTARR(nWAE) ; determines when individual walleye feed
rDVy = FLTARR(nRAS) ; determines when individual rainbow smelt feed 
wDVy = FLTARR(nEMS) ; determines when individual emerald shiner feed
roDVy = FLTARR(nROG) ; determines when individual round goby feed

;YPmoveHV = FLTARR(20, nYP) ; number of prey consumed as determined by the foraging subroutine
;WEmoveHV = FLTARR(20, nWAE) ; number of prey consumed as determined by the foraging subroutine
;RSmoveHV = FLTARR(20, nRAS) ; number of prey consumed as determined by the foraging subroutine
;ESmoveHV = FLTARR(20, nEMS) ; number of prey consumed as determined by the foraging subroutine
;RGmoveHV = FLTARR(20, nROG) ; number of prey consumed as determined by the foraging subroutine

YPeaten = FLTARR(9, nYP) ; number of prey consumed as determined by the foraging subroutine
WAEeaten = FLTARR(10, nWAE) ; number of prey consumed as determined by the foraging subroutine
RASeaten = FLTARR(6, nRAS) ; number of prey consumed as determined by the foraging subroutine
EMSeaten = FLTARR(6, nEMS) ; number of prey consumed as determined by the foraging subroutine
ROGeaten = FLTARR(6, nROG) ; number of prey consumed as determined by the foraging subroutine

;**The number of days in each month of 2005, DOY = iday + 1L***********************************
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
tstart1 = SYSTIME(/seconds)

FOR iDay = 182L - 1L, 273L - 1L DO BEGIN;(Change iday values in other sub routines)*************DAYLY LOOP***************************************************************
  PRINT, 'DAY', iday + 1L; day of the year 
  counter =  iDay - 182L + 1L;*****FOR OUTPUT FILES (DOY)**************** 
  ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)********************
  PRINT, 'Counter', counter
  tstart2 = SYSTIME(/seconds)
  
  ;update chiros on a daily basis
  ;chiros = Chironom(gc, ch, iday)
  ;update chiros
  ;ch = ch + chiro ; need to incorporate consumption by fish later
  
  ; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IfYLE data  
  ; Initial total benthic biomasss in May
  ;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
  IF iDAY EQ 181L THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
    BottomCell = WHERE(Grid3D2[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
    IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
  ENDIF ELSE TotBenBio = TotBenBio
  
  ; Read a daily environmental input
  Envir3d = EcoForeInputFiles(iday, TotBenBio, Grid3D2) 
  
  
  FOR iHour = 0L, 23L DO BEGIN;************************************HOURLY LOOP***************************************************************
    PRINT,  'DAY', iday + 1L, '     HOUR', ihour + 1L
    ;inputcounter =  ihour + 24L * (iday); inpucounter + 1
    ;PRINT, 'INPUT COUNTER', inputcounter

    tstart3 = SYSTIME(/seconds)
    
    ; Call only an hourly input from a daily input read from the file
     ; HourInput = [77500L * ihour : 77500L * ihour + 77499L]
     Envir3d2 = Envir3d[*, 77500L * ihour : 77500L * ihour + 77499L]
     ;PRINT, 'Hourly Input',  envir3d2
     
     ; Update total benthic biomass each day 
     IF iHOUR EQ 0L THEN TotBenBio = TotBenBio + Envir3d2[8, *]; DONE ONLY ONCE AT THE BEGINNING OF THE DAY
     
     ;**************NEED TO INCORPORATE DAY LIGHT HOURS FOR LIGHT INPUTS -> DURING THE NIGHT, LIGHT = 0.1LUX***********************
     
     ; Initialize IBM for each species -> DO IT ONLY ONCE at the bebinning of simulations
     IF ((iDay EQ 181L) AND (iHour EQ 0L)) THEN BEGIN
      YP = YEPinitial(NpopYP, nYP, TotBenBio, envir3d2)  
      WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, envir3d2)  
      RAS = RASinitial(NpopRAS, nRAS, TotBenBio, envir3d2)  
      EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, envir3d2)  
      ROG = ROGinitial(NpopROG, nROG, TotBenBio, envir3d2)  
     ENDIF

      
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
    
      FOR iTime = 0L, 60L/ts - 1L DO BEGIN;********************************TIME STEP LOOP**********************************************************
      ; runs 10 times as there are 6 minutes in an hour
      ; only run through if individual has hatched
        PRINT, 'DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
        tstart4 = SYSTIME(/seconds)
        YP[42, *] = iday; day
        YP[43, *] = ihour; hour
        YP[44, *] = (iTime + 1L)*ts; minutes
        WAE[42, *] = iday; day
        WAE[43, *] = ihour; hour
        WAE[44, *] = (iTime + 1L)*ts; minutes      
        RAS[42, *] = iday; day
        RAS[43, *] = ihour; hour
        RAS[44, *] = (iTime + 1L)*ts; minutes      
        EMS[42, *] = iday; day
        EMS[43, *] = ihour; hour
        EMS[44, *] = (iTime + 1L)*ts; minutes      
        ROG[42, *] = iday; day
        ROG[43, *] = ihour; hour
        ROG[44, *] = (iTime + 1L)*ts; minutes

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
        ; Creat a fish prey array for potential predators
        ; *****NEED TO ADJUST-> THE CURRENT SETUP DOESN'T TREAT INDIVIDUALS IN THE SAME CELL PROPERLY*********************** 
;        ; yellow perch as prey
;        PreyFish[0, YP[14, *]] = YP[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;        PreyFish[1, YP[14, *]] = YP[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;        PreyFish[2, YP[14, *]] = YP[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;        PreyFish[3, YP[14, *]] = YP[2, *] * YP[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;        ; emrald shiner as prey
;        PreyFish[5, EMS[14, *]] = EMS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;        PreyFish[6, EMS[14, *]] = EMS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;        PreyFish[7, EMS[14, *]] = EMS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;        PreyFish[8, EMS[14, *]] = EMS[2, *] * EMS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;        ; rainbow smelt as prey
;        PreyFish[10, RAS[14, *]] = RAS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;        PreyFish[11, RAS[14, *]] = RAS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;        PreyFish[12, RAS[14, *]] = RAS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;        PreyFish[13, RAS[14, *]] = RAS[2, *] * RAS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;        ; round goby as prey
;        PreyFish[15, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;        PreyFish[16, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;        PreyFish[17, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;        PreyFish[18, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;        ; walleye as prey
;        PreyFish[20, WAE[14, *]] = WAE[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;        PreyFish[21, WAE[14, *]] = WAE[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;        PreyFish[22, WAE[14, *]] = WAE[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;        PreyFish[23, WAE[14, *]] = WAE[2, *] * WAE[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS)
        
        
;        FISH3DCellIDcount = FLTARR(5, nGridcell)
;        PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;        PreyFish[5, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;        PreyFish[10, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;        PreyFish[15, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;        PreyFish[20, WAE[14, *]] = WAE[0, *]; ABUNDANCE
;        
;        ; NUMBER OF SUPERINDIVIDUALS, LENGTH, AND WEIGHT
;        FOR ID = 0L, nYP-1L DO BEGIN
;          FISH3DCellIDcount[0, YP[14, ID]] = FISH3DCellIDcount[0, YP[14, ID]] + (YP[0, ID] GT 0.); NUMBER OF SIs
;          IF PreyFish[1, YP[14, ID]] EQ 0. THEN BEGIN; WHEN THE CELL IS EMPTY...
;            PreyFish[1, YP[14, ID]] = YP[1, ID]; LENGTH
;            PreyFish[2, YP[14, ID]] = YP[2, ID]; WEIGHT
;          ENDIF
;          IF PreyFish[1, YP[14, ID]] GT 0. THEN BEGIN; WHEN OTHER SIs ARE ALREADY IN THE CELL...
;            IF (PreyFish[1, YP[14, ID]] GT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS LARGER...
;              PreyFish[1, YP[14, ID]] = YP[1, ID]
;              PreyFish[2, YP[14, ID]] = YP[2, ID]
;            ENDIF
;            IF (PreyFish[1, YP[14, ID]] LT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS SMALLER...
;              PreyFish[1, YP[14, ID]] = PreyFish[1, YP[14, ID]]
;              PreyFish[2, YP[14, ID]] = PreyFish[2, YP[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nEMS-1L DO BEGIN
;          FISH3DCellIDcount[1, EMS[14, ID]] = FISH3DCellIDcount[1, EMS[14, ID]] + (EMS[0, ID] GT 0.) 
;          IF PreyFish[6, EMS[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[6, EMS[14, ID]] = EMS[1, ID];
;            PreyFish[7, EMS[14, ID]] = EMS[2, ID];
;          ENDIF
;          IF PreyFish[6, EMS[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[1, EMS[14, ID]] GT EMS[1, ID]) THEN BEGIN
;              PreyFish[6, EMS[14, ID]] = EMS[1, ID]
;              PreyFish[7, EMS[14, ID]] = EMS[2, ID]
;           ENDIF
;            IF (PreyFish[6, EMS[14, ID]] LT EMS[1, ID]) THEN BEGIN
;              PreyFish[6, EMS[14, ID]] = PreyFish[6, EMS[14, ID]]
;              PreyFish[7, EMS[14, ID]] = PreyFish[7, EMS[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nRAS-1L DO BEGIN
;          FISH3DCellIDcount[2, RAS[14, ID]] = FISH3DCellIDcount[2, RAS[14, ID]] + (RAS[0, ID] GT 0.) 
;          IF PreyFish[11, RAS[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[11, RAS[14, ID]] = RAS[1, ID];
;            PreyFish[12, RAS[14, ID]] = RAS[2, ID];
;          ENDIF
;          IF PreyFish[11, RAS[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[11, RAS[14, ID]] GT RAS[1, ID]) THEN BEGIN
;              PreyFish[11, RAS[14, ID]] = RAS[1, ID]
;              PreyFish[12, RAS[14, ID]] = RAS[2, ID]
;            ENDIF
;            IF (PreyFish[11, RAS[14, ID]] LT RAS[1, ID]) THEN BEGIN
;              PreyFish[11, RAS[14, ID]] = PreyFish[11, RAS[14, ID]]
;              PreyFish[12, RAS[14, ID]] = PreyFish[12, RAS[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nROG-1L DO BEGIN
;          FISH3DCellIDcount[3, ROG[14, ID]] = FISH3DCellIDcount[3, ROG[14, ID]] + (ROG[0, ID] GT 0.) 
;          IF PreyFish[16, ROG[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[16, ROG[14, ID]] = ROG[1, ID];
;            PreyFish[17, ROG[14, ID]] = ROG[2, ID];
;          ENDIF
;          IF PreyFish[16, ROG[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[16, ROG[14, ID]] GT ROG[1, ID]) THEN BEGIN
;              PreyFish[16, ROG[14, ID]] = ROG[1, ID]
;              PreyFish[17, ROG[14, ID]] = ROG[2, ID]
;            ENDIF
;            IF (PreyFish[16, ROG[14, ID]] LT ROG[1, ID]) THEN BEGIN
;              PreyFish[16, ROG[14, ID]] = PreyFish[16, ROG[14, ID]]
;              PreyFish[17, ROG[14, ID]] = PreyFish[17, ROG[14, ID]]
;            ENDIF   
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nWAE-1L DO BEGIN
;          FISH3DCellIDcount[4, WAE[14, ID]] = FISH3DCellIDcount[4, WAE[14, ID]] + (WAE[0, ID] GT 0.) 
;          IF PreyFish[21, WAE[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[21, WAE[14, ID]] = WAE[1, ID];
;            PreyFish[22, WAE[14, ID]] = WAE[2, ID];
;          ENDIF
;          IF PreyFish[21, WAE[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[21, WAE[14, ID]] GT WAE[1, ID]) THEN BEGIN
;              PreyFish[21, WAE[14, ID]] = WAE[1, ID]
;              PreyFish[22, WAE[14, ID]] = WAE[2, ID]
;            ENDIF
;            IF (PreyFish[21, WAE[14, ID]] LT WAE[1, ID]) THEN BEGIN
;              PreyFish[21, WAE[14, ID]] = PreyFish[21, WAE[14, ID]]
;              PreyFish[22, WAE[14, ID]] = PreyFish[22, WAE[14, ID]]
;            ENDIF   
;          ENDIF
;        ENDFOR
;        
;        ; TOTAL ABUNDANCE AND BIOMASS
;        PreyFish[0, YP[14, *]] = PreyFish[0, YP[14, *]] * FISH3DCellIDcount[0, YP[14, *]]; TOTAL ABUNDANCE
;        PreyFish[3, YP[14, *]] = YP[2, *] * PreyFish[0, YP[14, *]]; TOTAL BIOMASS
;        PreyFish[5, EMS[14, *]] = PreyFish[5, EMS[14, *]] * FISH3DCellIDcount[1, EMS[14, *]]; 
;        PreyFish[8, EMS[14, *]] = EMS[2, *]*PreyFish[5, EMS[14, *]]; 
;        PreyFish[10, RAS[14, *]] = PreyFish[10, RAS[14, *]] * FISH3DCellIDcount[2, RAS[14, *]]; 
;        PreyFish[13, RAS[14, *]] = RAS[2, *]*PreyFish[10, RAS[14, *]]; 
;        PreyFish[15, ROG[14, *]] = PreyFish[15, ROG[14, *]] * FISH3DCellIDcount[3, ROG[14, *]]; 
;        PreyFish[18, ROG[14, *]] = ROG[2, *] * PreyFish[15, ROG[14, *]]; 
;        PreyFish[20, WAE[14, *]] = PreyFish[20, WAE[14, *]] * FISH3DCellIDcount[4, WAE[14, *]]; 
;        PreyFish[23, WAE[14, *]] = WAE[2, *] * PreyFish[20, WAE[14, *]];
;        
;        ; NUMBER OF SUPERINDIVIDUALS
;        PreyFish[4, YP[14, *]] = FISH3DCellIDcount[0, YP[14, *]];  the number of superindividuals
;        PreyFish[9, EMS[14, *]] = FISH3DCellIDcount[1, EMS[14, *]];  the number of superindividuals
;        PreyFish[14, RAS[14, *]] = FISH3DCellIDcount[2, RAS[14, *]];  the number of superindividuals
;        PreyFish[19, ROG[14, *]] = FISH3DCellIDcount[3, ROG[14, *]];  the number of superindividuals
;        PreyFish[24, WAE[14, *]] = FISH3DCellIDcount[4, WAE[14, *]];  the number of superindividuals
;        PreyFish[25, *] = TOTAL(FISH3DCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
;        PreyFish[26, *] = PreyFish[0, *] + PreyFish[5, *] + PreyFish[10, *] + PreyFish[15, *] + PreyFish[20, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
;        PreyFish[27, *] = PreyFish[3, *] + PreyFish[8, *] + PreyFish[13, *] + PreyFish[18, *] + PreyFish[23, *]; TOTAL BIOMASS IN A CELL
        
        PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
        ;PRINT, PreyFish
       ;********************************************************
       ; Horizontal AND vertical movement -> may need to move to the time step loop
       ;IF(iHour EQ 0L) AND (iTime EQ 0L)THEN BEGIN; only evaluate once a day
         ; YPmoveHV = YEPMoveHV(ts, YP, nYP, envir3d2, TotBenBio, PreyFish, Grid2D2, YP[39, *], YP[40, *], YP[41, *])
;          WEmoveHV = WAEMoveHV(ts, WAE, nWAE, envir3d2, TotBenBio, PreyFish, Grid2D2, WAE[39, *], WAE[40, *], WAE[41, *])
;                              
          RSmoveHV = RASMoveHV(ts, RAS, nRAS, envir3d2, TotBenBio, Grid2D2, RAS[39, *], RAS[40, *], RAS[41, *])
          ESmoveHV = EMSMoveHV(ts, EMS, nEMS, envir3d2, TotBenBio, Grid2D2, EMS[39, *], EMS[40, *], EMS[41, *])
          RGmoveHV = ROGMoveHV(ts, ROG, nROG, envir3d2, TotBenBio, Grid2D2, ROG[39, *], ROG[40, *], ROG[41, *])
;          
          ; Update fish locations and environmental conditions
       ;   YP[10:24, *] = YPmoveHV[0:14, *]
;          YP[10, *] = YPmoveHV[0, *]
;          YP[11, *] = YPmoveHV[1, *]
;          YP[12, *] = YPmoveHV[2, *]
;          YP[13, *] = YPmoveHV[3, *]
;          YP[14, *] = YPmoveHV[4, *]
;          YP[15, *] = YPmoveHV[5, *]
;          YP[16, *] = YPmoveHV[6, *]
;          YP[17, *] = YPmoveHV[7, *]
;          YP[18, *] = YPmoveHV[8, *]
;          YP[19, *] = YPmoveHV[9, *]
;          YP[20, *] = YPmoveHV[10, *]
;          YP[21, *] = YPmoveHV[11, *]
;          YP[22, *] = YPmoveHV[12, *]
;          YP[23, *] = YPmoveHV[13, *]
;          YP[24, *] = YPmoveHV[14, *]

;          WAE[10:24, *] = WEmoveHV[0:14, *]   
          RAS[10:24, *] = RSmoveHV[0:14, *]         
          EMS[10:24, *] = ESmoveHV[0:14, *]    
          ROG[10:24, *] = RGmoveHV[0:14, *]
;          
          ; Update within-cell locations
       ;   YP[39:41, *] = YPmoveHV[16:18, *]       
;          WAE[39:41, *] = WEmoveHV[16:18, *]
          RAS[39:41, *] = RSmoveHV[16:18, *]     
          EMS[39:41, *] = ESmoveHV[16:18, *]    
          ROG[39:41, *] = RGmoveHV[16:18, *]
       ;ENDIF        
       
        ; Estimate acclimation effects on foraging and bioenergetics
        ; Temperature acclimation
      ;  YacclT = YEPacclT(YP[26, *], YP[27, *], YP[19, *], ts, YP[1, *], nYP) ; determine temperature acclimations for yellow perch
;        WacclT = WAEacclT(WAE[26, *], WAE[27, *], WAE[19, *], ts, WAE[1, *], nWAE) ; determine temperature acclimations for walleye
        RacclT = RASacclT(RAS[26, *], RAS[27, *], RAS[19, *], ts, RAS[1, *], nRAS) ; determine temperature acclimations for rainbow smelt
        EacclT = EMSacclT(EMS[26, *], EMS[27, *], EMS[19, *], ts, EMS[1, *], nEMS) ; determine temperature acclimations for emerald shiner
      ROacclT = ROGacclT(ROG[26, *], ROG[27, *], ROG[19, *], ts, nROG) ; determine temperature acclimations for round goby
;       
;        ; Update fish acclimated temperature 
;        YP[26, *] = YacclT[0, *] ;updates YEP temp acclimation for C
;        YP[27, *] = YacclT[1, *] ;updates YEP temp acclimation for R
;        WAE[26, *] = WacclT[0, *] ;updates WAE temp acclimation for C
;        WAE[27, *] = WacclT[1, *] ;updates WAE temp acclimation for R
        RAS[26, *] = RacclT[0, *] ;updates RAS temp acclimation for C
        RAS[27, *] = RacclT[1, *] ;updates RAS temp acclimation for R
        EMS[26, *] = EacclT[0, *] ;updates EMS temp acclimation for C
        EMS[27, *] = EacclT[1, *] ;updates EMS temp acclimation for R
        ROG[26, *] = ROacclT[0, *] ;updates ROG temp acclimation for C
        ROG[27, *] = ROacclT[1, *] ;updates ROG temp acclimation for R
        
        ; DO acclimation  
        ;YacclDO = YEPacclDO(YP[28, *], YP[29, *], YP[20, *], YP[26, *], YP[27, *], YP[19, *], ts, YP[1, *], YP[2, *], nYP) 
;        WacclDO = WAEacclDO(WAE[28, *], WAE[29, *], WAE[20, *], WAE[26, *], WAE[27, *], WAE[19, *], ts, WAE[1, *], WAE[2, *], nWAE) 
        RacclDO = RASacclDO(RAS[28, *], RAS[29, *], RAS[20, *], RAS[26, *], RAS[27, *], RAS[19, *], ts, RAS[1, *], RAS[2, *], nRAS) 
        EacclDO = EMSacclDO(EMS[28, *], EMS[29, *], EMS[20, *], EMS[26, *], EMS[27, *], EMS[19, *], ts, EMS[1, *], EMS[2, *], nEMS) 
        ROacclDO = ROGacclDO(ROG[28, *], ROG[29, *], ROG[20, *], ROG[26, *], ROG[27, *], ROG[19, *], ts, ROG[1, *], ROG[2, *], nROG)                   
;        
        ; Update fish acclimated DO
;        YP[28, *] = YacclDO[0, *] ;updates YEP DO acclimation for C
;        YP[29, *] = YacclDO[1, *] ;updates YEP DO acclimation for R  
;        WAE[28, *] = WacclDO[0, *] ;updates WAE DO acclimation for C
;        WAE[29, *] = WacclDO[1, *] ;updates WAE  DO acclimation for R 
        RAS[28, *] = RacclDO[0, *] ;updates RAS DO acclimation for C
        RAS[29, *] = RacclDO[1, *] ;updates RAS DO acclimation for R 
        EMS[28, *] = EacclDO[0, *] ;updates EMS DO acclimation for C
        EMS[29, *] = EacclDO[1, *] ;updates EMS DO acclimation for R 
        ROG[28, *] = ROacclDO[0, *] ;updates ROG DO acclimation for C
        ROG[29, *] = ROacclDO[1, *] ;updates ROG DO acclimation for R 
;     
;        ; Update fish DO stress
;        YP[36, *] = YacclDO[2, *] ;updates YEP DO acclimation for C
;        YP[36, *] = YacclDO[3, *] ;updates YEP DO acclimation for C
;        ;WAE[36, *] = WacclDO[2, *] ;updates WAE DO acclimation for C
;        WAE[36, *] = WacclDO[3, *] ;updates YEP DO acclimation for C
        RAS[36, *] = RacclDO[2, *] ;updates RAS DO acclimation for C
        RAS[36, *] = RacclDO[3, *] ;updates YEP DO acclimation for C
        EMS[36, *] = EacclDO[2, *] ;updates EMS DO acclimation for C
        EMS[36, *] = EacclDO[3, *] ;updates YEP DO acclimation for C
        ROG[36, *] = ROacclDO[2, *] ;updates ROG DO acclimation for C
        ROG[36, *] = ROacclDO[3, *] ;updates YEP DO acclimation for C
        
        ;***Foraging / consumption*********************************************************
        ; Determine Cmax->> Cmax is updated every time step
     ;   YPcmx = YEPcmax(YP[2, *], YP[1, *], nYP, YP[26, *]); sets limit for how much a YP can eat in a 24 hr period
;        WAEcmx = WAEcmax(WAE[2, *],WAE[1,*], nWAE, WAE[26, *]); sets limit for how much WAE can eat in a 24 hr period
        RAScmx = RAScmax(RAS[2, *], RAS[1, *], nRAS, RAS[26, *]); sets limit for how much a RAS can eat in a 24 hr period
        EMScmx = EMScmax(EMS[2, *], EMS[1,*], nEMS, EMS[26, *]); sets limit for how much EMS can eat in a 24 hr period
        ROGcmx = ROGcmax(ROG[2, *], ROG[1, *], nROG, ROG[26, *]); sets limit for how much a ROG can eat in a 24 hr period
;          
        ; Determine stomach capacity
    ;    YstomCap = YEPstcap(YP[2, *], nYP) ; stomach capacity for yellow perch
;        WstomCap = WAEstcap(WAE[1,*], nWAE) ; stomach capacity for walleye
        RstomCap = RASstcap(RAS[2,*], nRAS) ; stomach capacity for rainbow smelt
        EstomCap = EMSstcap(EMS[2,*], nEMS) ; stomach capacity for emerald shiner
        ROstomCap = ROGstcap(ROG[2,*], nROG) ; stomach capacity for round goby
;        ; Update size-based stomach capacity
   ;     YP[8, *] = YstomCap[*] ;updates YEP stomach capacity (g)       
;        WAE[8, *] = WstomCap[*] ;updates WAE stomach capacity (g)
        RAS[8, *] = RstomCap[*] ;updates RAS stomach capacity (g)
        EMS[8, *] = EstomCap[*] ;updates EMS stomach capacity (g)
        ROG[8, *] = ROstomCap[*] ;updates ROG stomach capacity (g)
;    
        ; Prey availability to determine encounter rates for yellow perch
        ; Use "/(YP[0, *]* YP[2, *])" for food availability per individual within superindividuals to incorporate density-dependence
        ;******Biomass needs to be incoporated in to density dependence effects**************** 
        ;********************************************************
        ; Creat a fish prey array for potential predators
        ; *****NEED TO ADJUST-> THE CURRENT SETUP DOESN'T TREAT INDIVIDUALS IN THE SAME CELL PROPERLY*********************** 
;         ; yellow perch as prey
;          PreyFish[0, YP[14, *]] = YP[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;          PreyFish[1, YP[14, *]] = YP[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;          PreyFish[2, YP[14, *]] = YP[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;          PreyFish[3, YP[14, *]] = YP[2, *] * YP[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;          ; emrald shiner as prey
;          PreyFish[5, EMS[14, *]] = EMS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;          PreyFish[6, EMS[14, *]] = EMS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;          PreyFish[7, EMS[14, *]] = EMS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;          PreyFish[8, EMS[14, *]] = EMS[2, *] * EMS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;          ; rainbow smelt as prey
;          PreyFish[10, RAS[14, *]] = RAS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;          PreyFish[11, RAS[14, *]] = RAS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;          PreyFish[12, RAS[14, *]] = RAS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;          PreyFish[13, RAS[14, *]] = RAS[2, *] * RAS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;          ; round goby as prey
;          PreyFish[15, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;          PreyFish[16, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;          PreyFish[17, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;          PreyFish[18, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;          ; walleye as prey
;          PreyFish[20, WAE[14, *]] = WAE[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;          PreyFish[21, WAE[14, *]] = WAE[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;          PreyFish[22, WAE[14, *]] = WAE[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;          PreyFish[23, WAE[14, *]] = WAE[2, *] * WAE[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS)
        
        
;        FISH3DCellIDcount = FLTARR(5, nGridcell)
;        PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;        PreyFish[5, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;        PreyFish[10, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;        PreyFish[15, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;        PreyFish[20, WAE[14, *]] = WAE[0, *]; ABUNDANCE
;        
;        ; NUMBER OF SUPERINDIVIDUALS, LENGTH, AND WEIGHT
;        FOR ID = 0L, nYP-1L DO BEGIN
;          FISH3DCellIDcount[0, YP[14, ID]] = FISH3DCellIDcount[0, YP[14, ID]] + (YP[0, ID] GT 0.); NUMBER OF SIs
;          IF PreyFish[1, YP[14, ID]] EQ 0. THEN BEGIN; WHEN THE CELL IS EMPTY...
;            PreyFish[1, YP[14, ID]] = YP[1, ID]; LENGTH
;            PreyFish[2, YP[14, ID]] = YP[2, ID]; WEIGHT
;          ENDIF
;          IF PreyFish[1, YP[14, ID]] GT 0. THEN BEGIN; WHEN OTHER SIs ARE ALREADY IN THE CELL...
;            IF (PreyFish[1, YP[14, ID]] GT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS LARGER...
;              PreyFish[1, YP[14, ID]] = YP[1, ID]
;              PreyFish[2, YP[14, ID]] = YP[2, ID]
;            ENDIF
;            IF (PreyFish[1, YP[14, ID]] LT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS SMALLER...
;              PreyFish[1, YP[14, ID]] = PreyFish[1, YP[14, ID]]
;              PreyFish[2, YP[14, ID]] = PreyFish[2, YP[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nEMS-1L DO BEGIN
;          FISH3DCellIDcount[1, EMS[14, ID]] = FISH3DCellIDcount[1, EMS[14, ID]] + (EMS[0, ID] GT 0.) 
;          IF PreyFish[6, EMS[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[6, EMS[14, ID]] = EMS[1, ID];
;            PreyFish[7, EMS[14, ID]] = EMS[2, ID];
;          ENDIF
;          IF PreyFish[6, EMS[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[1, EMS[14, ID]] GT EMS[1, ID]) THEN BEGIN
;              PreyFish[6, EMS[14, ID]] = EMS[1, ID]
;              PreyFish[7, EMS[14, ID]] = EMS[2, ID]
;           ENDIF
;            IF (PreyFish[6, EMS[14, ID]] LT EMS[1, ID]) THEN BEGIN
;              PreyFish[6, EMS[14, ID]] = PreyFish[6, EMS[14, ID]]
;              PreyFish[7, EMS[14, ID]] = PreyFish[7, EMS[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nRAS-1L DO BEGIN
;          FISH3DCellIDcount[2, RAS[14, ID]] = FISH3DCellIDcount[2, RAS[14, ID]] + (RAS[0, ID] GT 0.) 
;          IF PreyFish[11, RAS[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[11, RAS[14, ID]] = RAS[1, ID];
;            PreyFish[12, RAS[14, ID]] = RAS[2, ID];
;          ENDIF
;          IF PreyFish[11, RAS[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[11, RAS[14, ID]] GT RAS[1, ID]) THEN BEGIN
;              PreyFish[11, RAS[14, ID]] = RAS[1, ID]
;              PreyFish[12, RAS[14, ID]] = RAS[2, ID]
;            ENDIF
;            IF (PreyFish[11, RAS[14, ID]] LT RAS[1, ID]) THEN BEGIN
;              PreyFish[11, RAS[14, ID]] = PreyFish[11, RAS[14, ID]]
;              PreyFish[12, RAS[14, ID]] = PreyFish[12, RAS[14, ID]]   
;            ENDIF
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nROG-1L DO BEGIN
;          FISH3DCellIDcount[3, ROG[14, ID]] = FISH3DCellIDcount[3, ROG[14, ID]] + (ROG[0, ID] GT 0.) 
;          IF PreyFish[16, ROG[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[16, ROG[14, ID]] = ROG[1, ID];
;            PreyFish[17, ROG[14, ID]] = ROG[2, ID];
;          ENDIF
;          IF PreyFish[16, ROG[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[16, ROG[14, ID]] GT ROG[1, ID]) THEN BEGIN
;              PreyFish[16, ROG[14, ID]] = ROG[1, ID]
;              PreyFish[17, ROG[14, ID]] = ROG[2, ID]
;            ENDIF
;            IF (PreyFish[16, ROG[14, ID]] LT ROG[1, ID]) THEN BEGIN
;              PreyFish[16, ROG[14, ID]] = PreyFish[16, ROG[14, ID]]
;              PreyFish[17, ROG[14, ID]] = PreyFish[17, ROG[14, ID]]
;            ENDIF   
;          ENDIF
;        ENDFOR
;        FOR ID = 0L, nWAE-1L DO BEGIN
;          FISH3DCellIDcount[4, WAE[14, ID]] = FISH3DCellIDcount[4, WAE[14, ID]] + (WAE[0, ID] GT 0.) 
;          IF PreyFish[21, WAE[14, ID]] EQ 0. THEN BEGIN 
;            PreyFish[21, WAE[14, ID]] = WAE[1, ID];
;            PreyFish[22, WAE[14, ID]] = WAE[2, ID];
;          ENDIF
;          IF PreyFish[21, WAE[14, ID]] GT 0. THEN BEGIN
;            IF (PreyFish[21, WAE[14, ID]] GT WAE[1, ID]) THEN BEGIN
;              PreyFish[21, WAE[14, ID]] = WAE[1, ID]
;              PreyFish[22, WAE[14, ID]] = WAE[2, ID]
;            ENDIF
;            IF (PreyFish[21, WAE[14, ID]] LT WAE[1, ID]) THEN BEGIN
;              PreyFish[21, WAE[14, ID]] = PreyFish[21, WAE[14, ID]]
;              PreyFish[22, WAE[14, ID]] = PreyFish[22, WAE[14, ID]]
;            ENDIF   
;          ENDIF
;        ENDFOR
        
;        ; TOTAL ABUNDANCE AND BIOMASS
;        PreyFish[0, YP[14, *]] = PreyFish[0, YP[14, *]] * FISH3DCellIDcount[0, YP[14, *]]; TOTAL ABUNDANCE
;        PreyFish[3, YP[14, *]] = YP[2, *] * PreyFish[0, YP[14, *]]; TOTAL BIOMASS
;        PreyFish[5, EMS[14, *]] = PreyFish[5, EMS[14, *]] * FISH3DCellIDcount[1, EMS[14, *]]; 
;        PreyFish[8, EMS[14, *]] = EMS[2, *]*PreyFish[5, EMS[14, *]]; 
;        PreyFish[10, RAS[14, *]] = PreyFish[10, RAS[14, *]] * FISH3DCellIDcount[2, RAS[14, *]]; 
;        PreyFish[13, RAS[14, *]] = RAS[2, *]*PreyFish[10, RAS[14, *]]; 
;        PreyFish[15, ROG[14, *]] = PreyFish[15, ROG[14, *]] * FISH3DCellIDcount[3, ROG[14, *]]; 
;        PreyFish[18, ROG[14, *]] = ROG[2, *] * PreyFish[15, ROG[14, *]]; 
;        PreyFish[20, WAE[14, *]] = PreyFish[20, WAE[14, *]] * FISH3DCellIDcount[4, WAE[14, *]]; 
;        PreyFish[23, WAE[14, *]] = WAE[2, *] * PreyFish[20, WAE[14, *]];
;        
;        ; NUMBER OF SUPERINDIVIDUALS
;        PreyFish[4, YP[14, *]] = FISH3DCellIDcount[0, YP[14, *]];  the number of superindividuals
;        PreyFish[9, EMS[14, *]] = FISH3DCellIDcount[1, EMS[14, *]];  the number of superindividuals
;        PreyFish[14, RAS[14, *]] = FISH3DCellIDcount[2, RAS[14, *]];  the number of superindividuals
;        PreyFish[19, ROG[14, *]] = FISH3DCellIDcount[3, ROG[14, *]];  the number of superindividuals
;        PreyFish[24, WAE[14, *]] = FISH3DCellIDcount[4, WAE[14, *]];  the number of superindividuals
;        PreyFish[25, *] = TOTAL(FISH3DCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
;        PreyFish[26, *] = PreyFish[0, *] + PreyFish[5, *] + PreyFish[10, *] + PreyFish[15, *] + PreyFish[20, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
;        PreyFish[27, *] = PreyFish[3, *] + PreyFish[8, *] + PreyFish[13, *] + PreyFish[18, *] + PreyFish[23, *]; TOTAL BIOMASS IN A CELL
        
        ;PRINT,'YP[14, *]',TRANSPOSE(YP[14, *])
        ;PRINT,'WAE[14, *]',TRANSPOSE(WAE[14, *])
        
        
        PreyFish = FishArray(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nGridcell)
        ;PRINT, PreyFish
        
       ;********************************************************
       ; Prey biomass (g/L or g/m2)
        ; prey for yellow perch
        YPGridcellSize = 4000000.*(Grid2D[3, YP[13, *]]/20.) * 1000.; grid cell size (L)
        YPbiomN0 = where((YP[0, *]*YP[2, *] NE 0.), YPbiomN0count)
        IF YPbiomN0count GT 0. THEN BEGIN
          YPpbio[0, YPbiomN0] = YP[15, YPbiomN0]; / (YP[0, YPbiomN0] * YP[2, YPbiomN0]); zooplankton 
          YPpbio[1, YPbiomN0] = YP[16, YPbiomN0]; / (YP[0, YPbiomN0] * YP[2, YPbiomN0]); zooplankton 
          YPpbio[2, YPbiomN0] = YP[17, YPbiomN0]; / (YP[0, YPbiomN0] * YP[2, YPbiomN0]); zooplankton 
          YPpbio[3, YPbiomN0] = YP[18, YPbiomN0]; / (YP[0, YPbiomN0] * YP[2, YPbiomN0]); bentho
          YPpbio[4, YPbiomN0] = 0.0 * 1L; /(YP[0, YPbiomN0] * YP[2, YPbiomN0]); invasive species
          YPpbio[5, YPbiomN0] = PreyFish[0, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; yellow perch abundance
          YPpbio[6, YPbiomN0] = PreyFish[1, YP[14, YPbiomN0]]; length
          YPpbio[7, YPbiomN0] = PreyFish[2, YP[14, YPbiomN0]]; weight
          YPpbio[8, YPbiomN0] = PreyFish[3, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; / (YP[0, YPbiomN0] * YP[2, YPbiomN0]); biomass       
          YPpbio[9, YPbiomN0] = PreyFish[5, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; emerald shiner abundance
          YPpbio[10, YPbiomN0] = PreyFish[6, YP[14, YPbiomN0]]
          YPpbio[11, YPbiomN0] = PreyFish[7, YP[14, YPbiomN0]]
          YPpbio[12, YPbiomN0] = PreyFish[8, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; /(YP[0, YPbiomN0] * YP[2, YPbiomN0]) 
          YPpbio[13, YPbiomN0] = PreyFish[10, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; rainbow smelt abundance
          YPpbio[14, YPbiomN0] = PreyFish[11, YP[14, YPbiomN0]]
          YPpbio[15, YPbiomN0] = PreyFish[12, YP[14, YPbiomN0]]
          YPpbio[16, YPbiomN0] = PreyFish[13, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; /(YP[0, YPbiomN0] * YP[2, YPbiomN0])
          YPpbio[17, YPbiomN0] = PreyFish[15, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; round goby abundance
          YPpbio[18, YPbiomN0] = PreyFish[16, YP[14, YPbiomN0]] 
          YPpbio[19, YPbiomN0] = PreyFish[17, YP[14, YPbiomN0]]
          YPpbio[20, YPbiomN0] = PreyFish[18, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; /(YP[0, YPbiomN0] * YP[2, YPbiomN0])
          YPpbio[21, YPbiomN0] = PreyFish[20, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; walleye abundance
          YPpbio[22, YPbiomN0] = PreyFish[21, YP[14, YPbiomN0]] 
          YPpbio[23, YPbiomN0] = PreyFish[22, YP[14, YPbiomN0]]
          YPpbio[24, YPbiomN0] = PreyFish[23, YP[14, YPbiomN0]] / YPGridcellSize[YPbiomN0]; /(YP[0, YPbiomN0] * YP[2, YPbiomN0])
        ENDIF
        ;PRINT, 'YPPBIO', YPPBIO
        
        ; prey for walleye      
        WAEGridcellSize = 4000000.*(Grid2D[3, WAE[13, *]]/20.) * 1000.; grid cell size (L)
        WAEbiomN0 = where((WAE[0, *]*WAE[2, *] NE 0.), WAEbiomN0count)
        IF WAEbiomN0count GT 0. THEN BEGIN
          WAEpbio[0, WAEbiomN0] = WAE[15, WAEbiomN0]; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); zooplankton 
          WAEpbio[1, WAEbiomN0] = WAE[16, WAEbiomN0]; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); zooplankton
          WAEpbio[2, WAEbiomN0] = WAE[17, WAEbiomN0]; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); zooplankton
          WAEpbio[3, WAEbiomN0] = WAE[18, WAEbiomN0]; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); bentho
          WAEpbio[4, WAEbiomN0] = 0.0 * 1L; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); invasive species
          WAEpbio[5, WAEbiomN0] = PreyFish[0, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; yellow perch abundance
          WAEpbio[6, WAEbiomN0] = PreyFish[1, WAE[14, WAEbiomN0]]; length
          WAEpbio[7, WAEbiomN0] = PreyFish[2, WAE[14, WAEbiomN0]]; weight
          WAEpbio[8, WAEbiomN0] = PreyFish[3, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; / (WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]); biomass       
          WAEpbio[9, WAEbiomN0] = PreyFish[5, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; emerald shiner abundance
          WAEpbio[10, WAEbiomN0] = PreyFish[6, WAE[14, WAEbiomN0]]  
          WAEpbio[11, WAEbiomN0] = PreyFish[7, WAE[14, WAEbiomN0]]
          WAEpbio[12, WAEbiomN0] = PreyFish[8, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; /(WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0]) 
          WAEpbio[13, WAEbiomN0] = PreyFish[10, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; rainbow smelt abundance
          WAEpbio[14, WAEbiomN0] = PreyFish[11, WAE[14, WAEbiomN0]] 
          WAEpbio[15, WAEbiomN0] = PreyFish[12, WAE[14, WAEbiomN0]]
          WAEpbio[16, WAEbiomN0] = PreyFish[13, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0];/(WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0])
          WAEpbio[17, WAEbiomN0] = PreyFish[15, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; round goby abundance
          WAEpbio[18, WAEbiomN0] = PreyFish[16, WAE[14, WAEbiomN0]] 
          WAEpbio[19, WAEbiomN0] = PreyFish[17, WAE[14, WAEbiomN0]]
          WAEpbio[20, WAEbiomN0] = PreyFish[18, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; /(WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0])
          WAEpbio[21, WAEbiomN0] = PreyFish[20, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; walleye abundance
          WAEpbio[22, WAEbiomN0] = PreyFish[21, WAE[14, WAEbiomN0]] 
          WAEpbio[23, WAEbiomN0] = PreyFish[22, WAE[14, WAEbiomN0]]
          WAEpbio[24, WAEbiomN0] = PreyFish[23, WAE[14, WAEbiomN0]] / WAEGridcellSize[WAEbiomN0]; /(WAE[0, WAEbiomN0] * WAE[2, WAEbiomN0])
        ENDIF    
         ; PRINT, 'WAEPBIO', WAEPBIO
        ;******No fish prey for smelt, shiner, and goby for now*******************************************************
        ; Prey for rainbow smelt
        RASGridcellSize = 4000000.*(Grid2D[3, RAS[13, *]]/20.) * 1000.; grid cell size (L)
        RASbiomN0 = where((RAS[0, *]*RAS[2, *] NE 0.), RASbiomN0count)
        IF RASbiomN0count GT 0. THEN BEGIN
          RASpbio[0, RASbiomN0] = RAS[15, RASbiomN0]; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); zooplankton 
          RASpbio[1, RASbiomN0] = RAS[16, RASbiomN0]; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); zooplankton
          RASpbio[2, RASbiomN0] = RAS[17, RASbiomN0]; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); zooplankton 
          RASpbio[3, RASbiomN0] = RAS[18, RASbiomN0]; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); bentho     
          RASpbio[4, RASbiomN0] = 0.0 * 1L; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); invaisve species
          
          RASpbio[5, RASbiomN0] = PreyFish[0, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; yellow perch abundance
          RASpbio[6, RASbiomN0] = PreyFish[1, RAS[14, RASbiomN0]]; length
          RASpbio[7, RASbiomN0] = PreyFish[2, RAS[14, RASbiomN0]]; weight
          RASpbio[8, RASbiomN0] = PreyFish[3, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; / (RAS[0, RASbiomN0] * RAS[2, RASbiomN0]); biomass       
          RASpbio[9, RASbiomN0] = PreyFish[5, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; emerald shiner abundance
          RASpbio[10, RASbiomN0] = PreyFish[6, RAS[14, RASbiomN0]]
          RASpbio[11, RASbiomN0] = PreyFish[7, RAS[14, RASbiomN0]]
          RASpbio[12, RASbiomN0] = PreyFish[8, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; /(RAS[0, RASbiomN0] * RAS[2, RASbiomN0]) 
          RASpbio[13, RASbiomN0] = PreyFish[10, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; rainbow smelt abundance
          RASpbio[14, RASbiomN0] = PreyFish[11, RAS[14, RASbiomN0]]
          RASpbio[15, RASbiomN0] = PreyFish[12, RAS[14, RASbiomN0]]
          RASpbio[16, RASbiomN0] = PreyFish[13, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; /(RAS[0, RASbiomN0] * RAS[2, RASbiomN0])
          RASpbio[17, RASbiomN0] = PreyFish[15, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; round goby abundance
          RASpbio[18, RASbiomN0] = PreyFish[16, RAS[14, RASbiomN0]] 
          RASpbio[19, RASbiomN0] = PreyFish[17, RAS[14, RASbiomN0]]
          RASpbio[20, RASbiomN0] = PreyFish[18, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; /(RAS[0, RASbiomN0] * RAS[2, RASbiomN0])
          RASpbio[21, RASbiomN0] = PreyFish[20, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; round goby abundance
          RASpbio[22, RASbiomN0] = PreyFish[21, RAS[14, RASbiomN0]] 
          RASpbio[23, RASbiomN0] = PreyFish[22, RAS[14, RASbiomN0]]
          RASpbio[24, RASbiomN0] = PreyFish[23, RAS[14, RASbiomN0]] / RASGridcellSize[RASbiomN0]; /(RAS[0, RASbiomN0] * RAS[2, YPbiomN0])
       ENDIF
         ;PRINT, 'RASPBIO', RASPBIO
        ; prey for emerald shiner
        EMSGridcellSize = 4000000.*(Grid2D[3, EMS[13, *]]/20.) * 1000.; grid cell size (L)
        EMSbiomN0 = where((EMS[0, *]*EMS[2, *] NE 0.), EMSbiomN0count)
        IF EMSbiomN0count GT 0. THEN BEGIN
          EMSpbio[0, EMSbiomN0] = EMS[15, EMSbiomN0]; / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); zooplankton 
          EMSpbio[1, EMSbiomN0] = EMS[16, EMSbiomN0]; / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); zooplankton
          EMSpbio[2, EMSbiomN0] = EMS[17, EMSbiomN0]; / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); zooplankton 
          EMSpbio[3, EMSbiomN0] = EMS[18, EMSbiomN0]; / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); bentho
          EMSpbio[4, EMSbiomN0] = 0.0 * 1L;  / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); invasive species
          
          EMSpbio[5, EMSbiomN0] = PreyFish[0, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; yellow perch abundance
          EMSpbio[6, EMSbiomN0] = PreyFish[1, EMS[14, EMSbiomN0]]; length
          EMSpbio[7, EMSbiomN0] = PreyFish[2, EMS[14, EMSbiomN0]]; weight
          EMSpbio[8, EMSbiomN0] = PreyFish[3, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; / (EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]); biomass       
          EMSpbio[9, EMSbiomN0] = PreyFish[5, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; emerald shiner abundance
          EMSpbio[10, EMSbiomN0] = PreyFish[6, EMS[14, EMSbiomN0]]
          EMSpbio[11, EMSbiomN0] = PreyFish[7, EMS[14, EMSbiomN0]]
          EMSpbio[12, EMSbiomN0] = PreyFish[8, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; /(EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0]) 
          EMSpbio[13, EMSbiomN0] = PreyFish[10, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; rainbow smelt abundance
          EMSpbio[14, EMSbiomN0] = PreyFish[11, EMS[14, EMSbiomN0]]
          EMSpbio[15, EMSbiomN0] = PreyFish[12, EMS[14, EMSbiomN0]]
          EMSpbio[16, EMSbiomN0] = PreyFish[13, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; /(EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0])
          EMSpbio[17, EMSbiomN0] = PreyFish[15, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; round goby abundance
          EMSpbio[18, EMSbiomN0] = PreyFish[16, EMS[14, EMSbiomN0]] 
          EMSpbio[19, EMSbiomN0] = PreyFish[17, EMS[14, EMSbiomN0]]
          EMSpbio[20, EMSbiomN0] = PreyFish[18, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; /(EMS[0, EMSbiomN0] * EMS[2, EMSbiomN0])
          EMSpbio[21, EMSbiomN0] = PreyFish[20, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; round goby abundance
          EMSpbio[22, EMSbiomN0] = PreyFish[21, EMS[14, EMSbiomN0]] 
          EMSpbio[23, EMSbiomN0] = PreyFish[22, EMS[14, EMSbiomN0]]
          EMSpbio[24, EMSbiomN0] = PreyFish[23, EMS[14, EMSbiomN0]] / EMSGridcellSize[EMSbiomN0]; /(EMS[0, EMSbiomN0] * EMS[2, YPbiomN0])
     ENDIF
       ;PRINT, 'EMSPBIO', EMSPBIO
        ; prey for round goby
        ROGGridcellSize = 4000000.*(Grid2D[3, ROG[13, *]]/20.) * 1000.; grid cell size (L)
        ROGbiomN0 = where((ROG[0, *]*ROG[2, *] NE 0.), ROGbiomN0count)
        IF ROGbiomN0count GT 0. THEN BEGIN
          ROGpbio[0, ROGbiomN0] = ROG[15, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
          ROGpbio[1, ROGbiomN0] = ROG[16, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
          ROGpbio[2, ROGbiomN0] = ROG[17, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); zooplankton 
          ROGpbio[3, ROGbiomN0] = ROG[18, ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); bentho
          ROGpbio[4, ROGbiomN0] = 0.0 * 1L; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); invasive species
          ROGpbio[5, ROGbiomN0] = 0.0;/ (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); fish
          
          ROGpbio[5, ROGbiomN0] = PreyFish[0, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; yellow perch abundance
          ROGpbio[6, ROGbiomN0] = PreyFish[1, ROG[14, ROGbiomN0]]; length
          ROGpbio[7, ROGbiomN0] = PreyFish[2, ROG[14, ROGbiomN0]]; weight
          ROGpbio[8, ROGbiomN0] = PreyFish[3, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; / (ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]); biomass       
          ROGpbio[9, ROGbiomN0] = PreyFish[5, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; emerald shiner abundance
          ROGpbio[10, ROGbiomN0] = PreyFish[6, ROG[14, ROGbiomN0]]
          ROGpbio[11, ROGbiomN0] = PreyFish[7, ROG[14, ROGbiomN0]]
          ROGpbio[12, ROGbiomN0] = PreyFish[8, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0]) 
          ROGpbio[13, ROGbiomN0] = PreyFish[10, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; rainbow smelt abundance
          ROGpbio[14, ROGbiomN0] = PreyFish[11, ROG[14, ROGbiomN0]]
          ROGpbio[15, ROGbiomN0] = PreyFish[12, ROG[14, ROGbiomN0]]
          ROGpbio[16, ROGbiomN0] = PreyFish[13, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0])
          ROGpbio[17, ROGbiomN0] = PreyFish[15, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby abundance
          ROGpbio[18, ROGbiomN0] = PreyFish[16, ROG[14, ROGbiomN0]] 
          ROGpbio[19, ROGbiomN0] = PreyFish[17, ROG[14, ROGbiomN0]]
          ROGpbio[20, ROGbiomN0] = PreyFish[18, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, ROGbiomN0])
          ROGpbio[21, ROGbiomN0] = PreyFish[20, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; round goby abundance
          ROGpbio[22, ROGbiomN0] = PreyFish[21, ROG[14, ROGbiomN0]] 
          ROGpbio[23, ROGbiomN0] = PreyFish[22, ROG[14, ROGbiomN0]]
          ROGpbio[24, ROGbiomN0] = PreyFish[23, ROG[14, ROGbiomN0]] / ROGGridcellSize[ROGbiomN0]; /(ROG[0, ROGbiomN0] * ROG[2, YPbiomN0])
       ENDIF
       ;PRINT, 'ROGPBIO', ROGPBIO
        ;**********************************************************************************************************
        ; Determine consumption rates
        ;IF ((iHour GE 4L) AND (iHour LE 20L)) THEN BEGIN; restrict foraging within only daylight hours 5am to 9pm
        
;        YPenc = YEPforage(ihour, YP[1, *], YP[26, *], YP[21, *], YPpbio, YPcmx, YP[7, *], YP[30, *], YP[31, *], YP[32, *], $ 
;        YP[33, *], YP[34, *], YP[35, *], YP[45, *], YP[46, *], YP[47, *], YP[8, *], YP[9, *], YP[48, *], YP[49, *], YP[50, *], $
;        YP[51, *], YP[52, *], YP[53, *], YP[54, *], YP[55, *], YP[56, *], ts, nYP, YP[20, *], YP[28, *], YacclDO[5, *], YP, $
;        Grid2D, Envir3d2[10, *], TotBenBio) 

;        WAEenc = WAEforage(ihour, WAE[1, *], WAE[26, *], WAE[21, *], WAEpbio, WAEcmx, WAE[7, *], WAE[30, *], WAE[31, *], $
;        WAE[32, *], WAE[33, *], WAE[34, *], WAE[35, *], WAE[45, *], WAE[46, *], WAE[47, *], WAE[48, *], WAE[8, *], WAE[9, *], $
;        WAE[49, *], WAE[50, *], WAE[51, *],WAE[52, *],WAE[53, *],WAE[54, *],WAE[55, *],WAE[56, *],WAE[57, *], WAE[58, *], ts, $
;        nWAE, WAE[20, *], WAE[28, *], WacclDO[5, *], WAE, Grid2D) 
;
        RASenc = RASforage(ihour, RAS[1, *], RAS[26, *], RAS[21, *], RASpbio, RAScmx, RAS[7, *], RAS[30, *], $
        RAS[31, *], RAS[32, *], RAS[33, *], RAS[34, *], RAS[35, *], RAS[8, *], RAS[9, *], RAS[48, *], RAS[49, *], RAS[50, *], $
        RAS[51, *], RAS[52, *], RAS[53, *],ts, nRAS, RAS[20, *], RAS[28, *], RacclDO[5, *], RAS, Grid2D) 
        
        EMSenc = EMSforage(ihour, EMS[1, *], EMS[26, *], EMS[21, *], EMSpbio, EMScmx, EMS[7, *], EMS[30, *], $
        EMS[31, *], EMS[32, *], EMS[33, *], EMS[34, *], EMS[35, *], EMS[8, *], EMS[9, *], EMS[48, *], EMS[49, *], EMS[50, *], $
        EMS[51, *], EMS[52, *], EMS[53, *], ts, nEMS, EMS[20, *], EMS[28, *], EacclDO[5, *], EMS, Grid2D) 
  
        ROGenc = ROGforage(ihour, ROG[1, *], ROG[26, *], ROG[21, *], ROGpbio, ROGcmx, ROG[7, *], ROG[30, *], $
        ROG[31, *], ROG[32, *], ROG[33, *], ROG[34, *], ROG[35, *], ROG[8, *], ROG[9, *], ROG[48, *], ROG[49, *], ROG[50, *], $
        ROG[51, *], ROG[52, *], ROG[53, *], ts, nROG, ROG[20, *], ROG[28, *], ROacclDO[5, *], ROG, Grid2D) 
;        
        ; Update stomach contents
     ;   YPeaten[0:8, *] = YPenc[0:8, *]; the amount of digeseted 9 prey items used for growth subroutine
;        YP[7, *] = YPenc[9, *]; updates yep stomach weight (g)
;        YP[60, *] = YPenc[49, *]; gut fullness (%)
;        
;        YP[9, *] = YPenc[10, *] ;updates yep cumulative total consumption per day (g)
;        YP[48, *] = YPenc[29, *] ; total amount of microzooplankton consumed over the last 24 hours in g
;        YP[49, *] = YPenc[30, *] ; total amount of small mesozooplankton consumed over the last 24 hours in g
;        YP[50, *] = YPenc[31, *] ; total amount of large mesozooplankton consumed over the last 24 hours in g
;        YP[51, *] = YPenc[32, *] ; total amount of chironomids consumed over the last 24 hours in g
;        YP[52, *] = YPenc[33, *] ; total amount of invasive species consumed over the last 24 hours in g
;        YP[53, *] = YPenc[34, *] ; total amount of yellow perch consumed over the last 24 hours in g
;        YP[54, *] = YPenc[35, *] ; total amount of emerald shiner consumed over the last 24 hours in g
;        YP[55, *] = YPenc[36, *] ; total amount of rainbow smelt consumed over the last 24 hours in g
;        YP[56, *] = YPenc[37, *] ; total amount of round goby consumed over the last 24 hours in g
;        
;        YP[30, *] = YPenc[11, *]; undigested rotifers in the stomach
;        YP[31, *] = YPenc[12, *]; undigested copopods in the stomach
;        YP[32, *] = YPenc[13, *]; undigested cladocerans in the stomach
;        YP[33, *] = YPenc[14, *]; undigested chironomids in the stomach
;        YP[34, *] = YPenc[15, *]; undigested invasive species in the stomach       
;        YP[35, *] = YPenc[16, *]; undigested yellow perch in the stomach
;        YP[45, *] = YPenc[17, *]; undigested emerald shiner in the stomach
;        YP[46, *] = YPenc[18, *]; undigested rainbow smelt in the stomach
;        YP[47, *] = YPenc[19, *]; undigested round goby in the stomach

;        WAEeaten[0:9, *] = WAEenc[0:9, *]; the amount of digeseted 10 prey items used for growth subroutine
;        WAE[7, *] = WAEenc[10, *]; updates WAE stomach weight (g)  
;        WAE[60, *] = WAEenc[54, *]; gut fullness (%)
;          
;        WAE[9, *] = WAEenc[11, *] ;updates WAE cumulative total consumption per day (g)
;        WAE[49, *] = WAEenc[32, *]; total amount of microzooplankton consumed over the last 24 hours in g
;        WAE[50, *] = WAEenc[33, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
;        WAE[51, *] = WAEenc[34, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
;        WAE[52, *] = WAEenc[35, *]; total amount of chironomids consumed over the last 24 hours in g
;        WAE[53, *] = WAEenc[36, *]; total amount of invasive species consumed over the last 24 hours in g
;        WAE[54, *] = WAEenc[37, *]; total amount of yellow perch consumed over the last 24 hours in g
;        WAE[55, *] = WAEenc[38, *]; total amount of emerald shiner consumed over the last 24 hours in g
;        WAE[56, *] = WAEenc[39, *]; total amount of rainbow smelt consumed over the last 24 hours in g
;        WAE[57, *] = WAEenc[40, *]; total amount of round goby consumed over the last 24 hours in g
;        WAE[58, *] = WAEenc[41, *]; total amount of walleye consumed over the last 24 hours in g
;        
;        WAE[30, *] = WAEenc[12, *]; undigested rotifers in the stomach
;        WAE[31, *] = WAEenc[13, *]; undigested copopods in the stomach
;        WAE[32, *] = WAEenc[14, *]; undigested cladocerans in the stomach
;        WAE[33, *] = WAEenc[15, *]; undigested chironomids in the stomach
;        WAE[34, *] = WAEenc[16, *]; undigested invasive species in the stomach
;        WAE[35, *] = WAEenc[17, *]; undigested yellow perch in the stomach       
;        WAE[45, *] = WAEenc[18, *]; undigested emerald shiner in the stomach
;        WAE[46, *] = WAEenc[19, *]; undigested rainbow smelt in the stomach
;        WAE[47, *] = WAEenc[20, *]; undigested round goby in the stomach
;        WAE[48, *] = WAEenc[21, *]; undigested walleye in the stomach
;        
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
;
        ROGeaten[0:5, *] = ROGenc[0:5, *]; the amount of digeseted 10 prey items used for growth subroutine
        ROG[7, *] = ROGenc[9, *]; updates yep stomach weight (g)  
        ROG[60, *] = ROGenc[49, *]; gut fullness (%)
          
        ROG[9, *] = ROGenc[10, *] ;updates yep cumulative total consumption per day (g)
        ROG[48, *] = ROGenc[29, *]; total amount of microzooplankton consumed over the last 24 hours in g
        ROG[49, *] = ROGenc[30, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
        ROG[50, *] = ROGenc[31, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
        ROG[51, *] = ROGenc[32, *]; total amount of chironomids consumed over the last 24 hours in g
        ROG[52, *] = ROGenc[33, *]; total amount of invasive species consumed over the last 24 hours in g
        ROG[53, *] = ROGenc[34, *]; total amount of yellow perch consumed over the last 24 hours in g
        
        ROG[30, *] = ROGenc[11, *]; undigested rotifers in the stomach
        ROG[31, *] = ROGenc[12, *]; undigested copopods in the stomach
        ROG[32, *] = ROGenc[13, *]; undigested cladocerans in the stomach
        ROG[33, *] = ROGenc[14, *]; undigested chironomids in the stomach
        ROG[34, *] = ROGenc[15, *]; undigested invasive species in the stomach
        ROG[35, *] = ROGenc[16, *]; undigested fish in the stomach  
             
        ;***the following is for simulations with hatching only****************************************************
        ;YP[15,Ycheck2] = YPenc[8,Ycheck2]; undigested rotifers in the stomach
        ;YP[16,Ycheck2] = YPenc[9,Ycheck2]; undigested copopods in the stomach
        ;YP[17,Ycheck2] = YPenc[10,Ycheck2]; undigested cladocerans in the stomach
        ;YP[18,Ycheck2] = YPenc[11,Ycheck2]; undigested chironomids in the stomach
        ;YP[19,Ycheck2] = YPenc[12,Ycheck2]; undigested bythotrephes in the stomach
        ;YP[20,Ycheck2] = YPenc[13,Ycheck2]; undigested fish in the stomach
        ;YP[8,Ycheck2] = YPenc[6,Ycheck2]; updates yep stomach weight (g)    
        ;YP[10,Ycheck2] = YPenc[6,Ycheck2] ;updates yep cumulative total consumption per day (g)
            
        ;Update info for yellow perch that have hatched
        ;IF cy GT 0.0 THEN BEGIN
       ;*********************************************************************************************************
       
        ; Respiration/Routine metabolism 
    ;    YPres = YEPresp(YP[19, *], YP[27, *], YP[2, *], YP[1, *], ts, YP[20, *], YP[29, *], YacclDO[4, *], nYP) ; determine respiration for yellow perch 
;        WAEres = WAEresp(WAE[19, *], WAE[27, *], WAE[2, *], WAE[1, *], ts, WAE[20, *], WAE[29, *],  WacclDO[4, *], nWAE); determine respiration for 
        RASres = RASresp(RAS[19, *], RAS[27, *], RAS[2, *], RAS[1, *], ts, RAS[20, *], RAS[29, *],  RacclDO[4, *], nRAS); determine respiration for 
        EMSres = EMSresp(EMS[19, *], EMS[27, *], EMS[2, *], EMS[1, *], ts, EMS[20, *], EMS[29, *],  EacclDO[4, *], nEMS); determine respiration for 
        ROGres = ROGresp(ROG[19, *], ROG[27, *], ROG[2, *], ROG[1, *], ts, ROG[20, *], ROG[29, *],  ROacclDO[4, *], nROG); determine respiration for     
;       
;       
    ;    YP[59, *] = YP[59, *] + YPres; RESPIRATION RATE
;        WAE[59, *] = WAE[59, *] + WAEres; RESPIRATION RATE
        RAS[59, *] = RAS[59, *] + RASres; RESPIRATION RATE
        EMS[59, *] = EMS[59, *] + EMSres; RESPIRATION RATE
        ROG[59, *] = ROG[59, *] + ROGres; RESPIRATION RATE
;       
        ; Total mortality = predation + starvation + suffocation
;        YEPlost = YEPmort(YP[1, *], YP[3, *], YP[4, *], YP[0, *], nYP, td, ts, YP[20, *], YP[29, *], YacclDO[2, *]); mortality of yellow perch
;        WAElost = WAEmort(WAE[1, *], WAE[3, *], WAE[4, *], WAE[0, *], nWAE, td, ts, WAE[20, *], WAE[29, *], WacclDO[2, *]); mortality of yellow perch
        RASlost = RASmort(RAS[1, *], RAS[3, *], RAS[4, *], RAS[0, *], nRAS, td, ts, RAS[20, *], RAS[29, *], RacclDO[2, *]); mortality of yellow perch
        EMSlost = EMSmort(EMS[1, *], EMS[3, *], EMS[4, *], EMS[0, *], nEMS, td, ts, EMS[20, *], EMS[29, *], EacclDO[2, *]); mortality of yellow perch
        ROGlost = ROGmort(ROG[1, *], ROG[3, *], ROG[4, *], ROG[0, *], nROG, td, ts, ROG[20, *], ROG[29, *], ROacclDO[2, *]); mortality of yellow perch

        ; Update numbers of individuals in superindividuals
        ; Remove individuals from predation (0), starvation (1), and suffocation (2)
        ;YP[36, *] = YEPlost[3, *]
;        YP[0, *] = YP[0, *] - YEPlost[0, *] - YEPlost[1, *] - YEPlost[2, *]
;        ;WAE[36, *] = WAElost[3, *]
;        WAE[0, *] = WAE[0, *] - WAElost[0, *] - WAElost[1, *] - WAElost[2, *]
        ;RAS[36, *] = RASlost[3, *]
        RAS[0, *] = RAS[0, *] - RASlost[0, *] - RASlost[1, *] - RASlost[2, *]
        ;EMS[36, *] = EMSlost[3, *]
        EMS[0, *] = EMS[0, *] - EMSlost[0, *] - EMSlost[1, *] - EMSlost[2, *]
;        ;ROG[36, *] = ROGlost[3, *]
        ROG[0, *] = ROG[0, *] - ROGlost[0, *] - ROGlost[1, *] - ROGlost[2, *]
;    
        ; Growth
;        YPgro = YEPgrowth(YP[1, *], YP[2, *], YP[3, *], YP[4, *], YPcmx, YPeaten, YPres, YP[26, *], nYP, ts, iday, ihour, iTime)
;        WAEgro = WAEgrowth(WAE[1, *], WAE[2, *], WAE[3, *], WAE[4, *], WAEcmx, WAEeaten, WAEres, WAE[26, *], nWAE, ts, iday, ihour, iTime)
        RASgro = RASgrowth(RAS[1, *], RAS[2, *], RAS[3, *], RAS[4, *], RAScmx, RASeaten, RASres, RAS[26, *], nRAS, ts, iday, ihour, iTime)
        EMSgro = EMSgrowth(EMS[1, *], EMS[2, *], EMS[3, *], EMS[4, *], EMScmx, EMSeaten, EMSres, EMS[26, *], nEMS, ts, iday, ihour, iTime)
        ROGgro = ROGgrowth(ROG[1, *], ROG[2, *], ROG[3, *], ROG[4, *], ROGcmx, ROGeaten, ROGres, ROG[26, *], nROG, ts, iday, ihour, iTime)

        ; Update FISH size
;        YP[1, *] = YPgro[1, *] ;updates yep length (mm)
;        YP[2, *] = YPgro[0, *] ;updates yep weight (g)
;        YP[3, *] = YPgro[3, *] ;updates yep storage weight (g)   
;        YP[4, *] = YPgro[2, *] ;updates yep structure weight (g)
;        YP[61, *] = YP[61, *] + YPgro[4, *] ;updates YEP cumulative growth in length (mm)   
;        YP[62, *] = YP[62, *] + YPgro[5, *] ;updates YEP cumulataive growth in weight (g)

;        WAE[1,*] = WAEgro[1,*] ;updates WAE length (mm)
;        WAE[2,*] = WAEgro[0,*] ;updates WAE weight (g)
;        WAE[3,*] = WAEgro[3,*] ;updates WAE storage weight (g)
;        WAE[4,*] = WAEgro[2,*] ;updates WAE Structure weight (g)
;        WAE[61, *] = WAE[61, *] + WAEgro[4, *] ;updates WAE cumulative growth in length (mm)   
;        WAE[62, *] = WAE[62, *] + WAEgro[5, *] ;updates WAE cumulataive growth in weight (g)
;     
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
;        
        ROG[1, *] = ROGgro[1, *] ;updates ROG length (mm)
        ROG[2, *] = ROGgro[0, *] ;updates ROG weight (g)
        ROG[3, *] = ROGgro[3, *] ;updates ROG storage weight (g)   
        ROG[4, *] = ROGgro[2, *] ;updates ROG structure weight (g)
        ROG[61, *] = ROG[61, *] + ROGgro[4, *] ;updates ROG cumulative growth in length (mm)   
        ROG[62, *] = ROG[62, *] + ROGgro[5, *] ;updates ROG cumulataive growth in weight (g)
       
       
       
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
      t_elapsed = systime(/seconds) - tstart4
      PRINT, 'Elapesed time (seconds) in a time step loop:', t_elapsed  
      PRINT, 'Elapesed time (minutes) in a time step loop:', t_elapsed/60.
    ENDFOR;**************************************************END OF EACH TIME STEP***************************************************
    ;PRINT, 'Water Tempearture and Haching Temperature',YP[19,*], YP[25,*]
  ;ENDIF  
    t_elapsed = systime(/seconds) - tstart3
    PRINT, 'Elapesed time (seconds) in an hour loop:', t_elapsed  
    PRINT, 'Elapesed time (minutes) in an hour loop:', t_elapsed/60.
  ENDFOR;****************************************************END OF A HOURLY LOOP***********************************************************************
  ;yDV = YPLhatch; updates YEP cumulative daily egg develpment FOR THE NEXT DAY
  ; IF cy GT 0.0 THEN yDVy = YP1stfeed; updates YEP cumulative daily yolk-sac larvae FOR THE NEXT DAY
   
  ;***Creat an output file for YEP*********************************************************
  ;counter =  iday - 182L; Same as the initial day of a daily loop 
  ;PRINT, 'Counter', counter
  ;PRINT, 'DAY', day
  PRINT, nYP; rowS
  pointer = nYP * counter; 1st line to read in 
  ;iDay = STRING(iDay)
  ;iHour = STRING(iHour)
  data = YP
  
  ; Set up variables.
  ;OutputYEP1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputYEP.csv'
  OutputYEP2='HH_'+Hypoxia+'_DD_'+DensityDependence+'_Rep_'+Rep+'_IDLoutputYEP.csv'
  filename1 = OutputYEP2
  ;filename2 = OutputYEP1
  
  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 1600
  comma = ","
  
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
   
  IF counter EQ 0L THEN BEGIN; 
  ; Open the data file for writing.
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer, /lines
    READF, lun
  ENDIF
  
  ; Write the data to the file.
  sData = StrTrim(data,2)
  sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  PrintF, lun, sData
  
  ; Close the file.
  Free_Lun, lun
  PRINT, '"Your YEP Output File is Ready"'
  ;****************************************************************************************
  ;***Creat an output file for WAE*********************************************************
  ;counter =  iday - 182L; Same as the initial day of a daily loop 
  ;PRINT, 'Counter', counter
  ;PRINT, 'DAY', day
  PRINT, nWAE; rowS
  pointer = nWAE * counter; 1st line to read in 
  data = WAE
  
  ; Set up variables.
  ;OutputWAE1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputWAE.csv'
  OutputWAE2='HH_'+Hypoxia+'_DD_'+DensityDependence+'_Rep_'+Rep+'_IDLoutputWAE.csv'
  filename1 = OutputWAE2
  ;filename2 = OutputWAE1
  
  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 1600
  comma = ","
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  ;
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
   
  IF counter EQ 0L THEN BEGIN; 
  ; Open the data file for writing.
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer, /lines
    READF, lun
  ENDIF
  
  ; Write the data to the file.
     sData = StrTrim(data,2)
     sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
     PrintF, lun, sData
  
  ; Close the file.
     Free_Lun, lun
  PRINT, '"Your WAE Output File is Ready"'
  ;****************************************************************************************
  ;***Creat an output file for RAS*********************************************************
  ;counter =  iday - 182L; Same as the initial day of a daily loop 
  ;PRINT, 'Counter', counter
  ;PRINT, 'DAY', day
  PRINT, nRAS; rowS
  pointer = nRAS * counter; 1st line to read in 
  data = RAS
  
  ; Set up variables.
  ;OutputRAS1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputRAS.csv'
  OutputRAS2='_HH_'+Hypoxia+'_DD_'+DensityDependence+'_Rep_'+Rep+'_IDLoutputRAS.csv'
  filename1 = OutputRAS2
  ;filename2 = OutputRAS1
  
  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 1600
  comma = ","
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
  
  IF counter EQ 0L THEN BEGIN; 
  ; Open the data file for writing.
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer, /lines
    READF, lun
  ENDIF
  ; Write the data to the file.
     sData = StrTrim(data,2)
     sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
     PrintF, lun, sData
     
  ; Close the file.
     Free_Lun, lun
  PRINT, '"Your RAS Output File is Ready"'
  ;****************************************************************************************
  ;***Creat an output file for EMS*********************************************************
  ;counter =  iday - 182L; Same as the initial day of a daily loop 
  ;PRINT, 'Counter', counter
  ;PRINT, 'DAY', day
  PRINT, nEMS; rowS
  pointer = nEMS * counter; 1st line to read in 
  data = EMS
  
  ; Set up variables.
  ;OutputEMS1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputEMS.csv'
  OutputEMS2='HH_'+Hypoxia+'_DD_'+DensityDependence+'-Rep_'+Rep+'_IDLoutputEMS.csv'
  filename1 = OutputEMS2
  ;filename2 = OutputEMS1
  
  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 1600
  comma = ","
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  ;
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
  
  IF counter EQ 0L THEN BEGIN; 
  ; Open the data file for writing.
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer, /lines
    READF, lun
  ENDIF
  
  ; Write the data to the file.
     sData = StrTrim(data,2)
     sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
     PrintF, lun, sData
     
  ; Close the file.
     Free_Lun, lun
  PRINT, '"Your EMS Output File is Ready"'
  ;****************************************************************************************
  ;***Creat an output file for ROG*********************************************************
  ;counter =  iday - 182L; Same as the initial day of a daily loop 
  ;PRINT, 'Counter', counter
  ;PRINT, 'DAY', day
  PRINT, nROG; rowS
  pointer = nROG * counter; 1st line to read in 
  data = ROG
  
  ; Set up variables.
  ;OutputROG1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputROG.csv'
  OutputROG2='HH_'+Hypoxia+'_DD_'+DensityDependence+'_Rep_'+Rep+'_IDLoutputROG.csv'
  filename1 = OutputROG2
  ;filename2 = OutputROG1
  
  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 1600
  comma = ","
  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
  ;
  ;; Write the data to the file.
  ;sData = StrTrim(data,2)
  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  ;PrintF, lun, sData
  ;Free_Lun, lun
  
  IF counter EQ 0L THEN BEGIN; 
  ; Open the data file for writing.
     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ENDIF
  IF counter GT 0L THEN BEGIN; 
    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
    SKIP_LUN, lun, pointer, /lines
    READF, lun
  ENDIF
  
  ; Write the data to the file.
     sData = StrTrim(data,2)
     sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
     PrintF, lun, sData
     
  ; Close the file.
     Free_Lun, lun
  PRINT, '"Your ROG Output File is Ready"'
  ;*************************************************************************************
  
  ; Reset cumulative daily consumption AND RESPIRATION AND DAILY GROWTH for the next day
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
  
  ROG[9, *] = 0.0 ; updates ROG cumulative daily total consumption (g) FOR THE NEXT DAY
  ROG[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
  ROG[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
  ROG[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
  ROG[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
  ROG[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
  ROG[53, *] = 0.0; total amount of fish consumed over the last 24 hours in g
  ROG[59, *] = 0.0; RESPIRATION
  ROG[61, *] = 0. ;updates yep cumulative growth in length (mm)   
  ROG[62, *] = 0. ;updates yep cumulataive growth in weight (g)
  
  ;*****NEED TO CHANGE INITIAL TOTAL NUMBER OF POPULATIONS****
  PRINT, 'Total number of surviving YEP individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,*])
  PRINT, '% surviving YEP individuals at the end of DAY', iday + 1, '     =', TOTAL(YP[0,*])/(NpopYP);
  PRINT, 'Total number of surviving WAE individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,*])
  PRINT, '% surviving WAE individuals at the end of DAY', iday + 1, '     =', TOTAL(WAE[0,*])/(NpopWAE);
  PRINT, 'Total number of surviving RAS individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,*])
  PRINT, '% surviving RAS individuals at the end of DAY', iday + 1, '     =', TOTAL(RAS[0,*])/(NpopRAS);
  PRINT, 'Total number of surviving EMS individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,*])
  PRINT, '% surviving EMS individuals at the end of DAY', iday + 1, '     =', TOTAL(EMS[0,*])/(NpopEMS);
  PRINT, 'Total number of surviving ROG individuals at the end of DAY', iday + 1, '     =', TOTAL(ROG[0,*])
  PRINT, '% surviving ROG individuals at the end of DAY', iday + 1, '     =', TOTAL(ROG[0,*])/(NpopROG);

  t_elapsed = systime(/seconds) - tstart2
  PRINT, 'Elapesed time (seconds) in a daily loop:', t_elapsed  
  PRINT, 'Elapesed time (minutes) in a daily loop:', t_elapsed/60.
ENDFOR;*******************************************************END OF A DAILY LOOP*******************************************************************
;PRINT, 'State variables for yellow perch (YP)'
;PRINT, YP
;PRINT, 'State variables for walleye (WAE)'
;PRINT, WAE
PRINT, 'State variables for rainbow smelt (RAS)'
PRINT, RAS
PRINT, 'State variables for emerald shiner(EMS)'
PRINT, EMS
;PRINT, 'State variables for round goby (ROG)'
;PRINT, ROG

t_elapsed = systime(/seconds) - tstart1
PRINT, 'Elapesed time (seconds) for all simulations:', t_elapsed 
PRINT, 'Elapesed time (minutes) for all simulations:', t_elapsed/60. 
PRINT, 'END OF ALL SIMULATIONS'
END