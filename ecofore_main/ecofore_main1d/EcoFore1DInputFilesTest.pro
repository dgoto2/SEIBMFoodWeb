 
; Time steps of simulations
ts = 10L ;minutes in a time step
td = (60L/ts)*24L ; number of time steps in a day

; Total number of superindividuals in each cohort
nYP = 5000L ; number of YEP superindividuals(SIs)
nWAE = 5000L; number of WAE SIs
nRAS = 5000L; number of RAS SIs
nEMS = 5000L; number of EMS SIs
nROG = 5000L; number of ROG SIs

; INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE; 50,000,000
NpopYP = (103540000D + 78843333D + 122247000D + 3257000D + 23600000D + 1645000D + 8300000D)*2. / 10.; number of YEP individuals
NpopWAE = (10710000D + 6960000D + 30129000D + 150000D + 8138000D + 553000D + 2430000D + 1028000D)*2. /10. ; number of WAE individuals
NpopRAS = (36683333D + 63653333D)*3. / 10.; number of RAS individuals
NpopEMS = (446761667D + 432036667D)*3. / 10. ; number of EMS individuals
NpopROG = (201138333D + 260038333D)*3. / 10.; number of ROG individuals
;PRINT, NpopYP 
;PRINT, NpopWAE 
;PRINT, NpopRAS
;PRINT, NpopEMS 
;PRINT, NpopROG

n1D = 8832L; starts on Apr-15 and ends on Oct-15
n1DLight = 26496L
nVerLay = 48L
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

FOR iYEAR = 2005L, 2005L DO BEGIN;(Change iday values in other sub routines)*************YEARLY LOOP***************************************************************
  PRINT, 'YEAR', iYEAR; the year 
  ;counter =  iDay - 182L + 1L;*****FOR OUTPUT FILES (DOY)**************** 
  ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)********************
  ;PRINT, 'Counter', counter
  tstart2 = SYSTIME(/seconds)
  
  FOR iDay = 105L, 288L DO BEGIN;************************************DAILY LOOP***************************************************************
  ; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IFYLE data  
  ; Initial total benthic biomasss in May
  ;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
  IF iDAY EQ 105L THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
    BottomCell = WHERE(DEPTHlayer[0:47] EQ 47L, BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
    IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)

    ; Read a daily environmental input
     Envir1d = EcoFore1DInputFiles(iYear, iDay, TotBenBio) 
     LightEnvir1d = EcoFore1DLightInputFiles(iYear) 
  ENDIF ELSE TotBenBio = TotBenBio
;    PRINT, 'TotBenBio'
;    PRINT, TotBenBio[0:47]
    
     ; Call only a daily input from a yearly input read from the file
     iDayPointer = iDay - 105L; First DOY for the simulation
     Envir1d2 = Envir1d[*, 48L * iDayPointer : 48L * iDayPointer + 47L]; 48 vertical layers
     ;PRINT, 'Daily Input'
     ;PRINT,  (Envir1d2)
     
     ; Update total benthic biomass every day 
     TotBenBio = TotBenBio + Envir1d2[8, *]; DONE ONLY ONCE AT THE BEGINNING OF THE DAY
    PRINT,  'YEAR', Envir1d2[2, 0], '     MONTH', Envir1d2[0, 0], '     DAY', Envir1d2[1, 0]
    
    FOR i10Minute = 0L, 143L DO BEGIN;************************************MINUTE LOOP***************************************************************
      ; Call only a dayly input from a yearly input read from the file
       i10MinutePointer = i10Minute + 144L*(iDay-105L)
       LightEnvir1d2 = LightEnvir1d[*, i10MinutePointer]; 48 vertical layers
       PRINT,  'YEAR', Envir1d2[2, 0], '   MONTH', Envir1d2[0, 0], '   DAY', Envir1d2[1, 0], $ 
               '   HOUR', LightEnvir1d2[2, *], '   MINUITE', LightEnvir1d2[3, *]
       ;PRINT, '10minute Surface Light Input'
       ;PRINT,  LightEnvir1d2
       
       ; to convedret langely to lux
       Light =  331.69 * EXP(-1.* Envir1d2[11, *] * Envir1d2[3, *]) ## LightEnvir1d2[4, *]
;       PRINT, '10minute Light Input'
;       PRINT,  TRANSPOSE(Light)  
        ;Light2 = (Light/175000000000.)> 0.; conevert from lux to mylux

        ;***Redistribution of zooplankton******************************      
        ; light function -> NEED LAKE ERIE ZOOPLANKTON FUNCTION USING IFYLE DATA
        gzLight = EXP(-0.5^((ALOG10(Light > 0.5)-((-6.86))/0.56)^2.))*RANDOMU(seed, nVerLay, /DOUBLE)
        TEMP = Envir1d2[9, *]
        ; Temperture function -> NEED LAKE ERIE ZOOPLANKTON FUNCTION USING IFYLE DATA
        fMODzTemp = EXP(-0.5^((DOUBLE(ALOG(TEMP > 0.00001))-(ALOG(6.07))/0.2314)^2.))*RANDOMU(seed, nVerLay, /DOUBLE)
        ; the model is for mysid, from Boscarino et al., 2007
        ;PRINT, "gzLight", gzLight[0L : 7499L]
;        PRINT, 'Dayly Zooplankton Input'
;        PRINT,  TRANSPOSE(Envir1d2[5, *])
       
          ; Calculate cumulative zooplankton biomass for each vertical layer
          zoopl1 = TOTAL(Envir1d2[5, *])
          zoopl2 = TOTAL(Envir1d2[6, *])
          zoopl3 = TOTAL(Envir1d2[7, *])
          ; the probability of finding zooplankton at depth z, given all available depths
          TotalLightTemp = TOTAL(fMODzTemp * gzLight)
          Pz = fMODzTemp * gzLight/TotalLightTemp 
          ;PRINT, 'TotalLightTemp'
          ;PRINT,  (TotalLightTemp)
;          PRINT, 'New Daily Zooplankton probability'
;          PRINT,  TRANSPOSE(Pz)
          ; Redistribute zooplankton based on light and DO
          zoopl1 = Pz*zoopl1 / 0.08 * ((.161) * 1.0/ 1000.0 / 1.0)
          zoopl2 = Pz*zoopl2 / 0.08 * ((.587) * 1.0/ 1000.0 / 1.0)
          zoopl3 = Pz*zoopl3 / 0.08 * ((.248) * 1.0/ 1000.0 / 1.0)
;          PRINT, 'New Daily Zooplankton Input'
;          PRINT,  TRANSPOSE(zoopl1)
;          PRINT,  TRANSPOSE(zoopl2)
;          PRINT,  TRANSPOSE(zoopl3)
;       PRINT, 'Dayly Input'
;       PRINT,  Envir1d2  
;       PRINT, 'TotBenBio'
;       PRINT, TotBenBio
       
       Envir1D3[4, *] = INDGEN(nVerLay)
       Envir1D3[5, *] = zoopl1; microzooplankton, g/L
       Envir1D3[6, *] = zoopl2 ; mid-size zooplankton; NOT YET g/L
       Envir1D3[7, *] = zoopl3; large-bodied zooplankton; NOT YET g/L
       Envir1D3[8, *] = TotBenBio
       Envir1D3[9:10, *] = Envir1D2[9:10, *]; TEMP & O2
       Envir1D3[11, *] = Light
       Envir1D3[15, *] = Envir1D2[3, *]; GRID CELL ID
       ;PRINT, 'New Daily Input'
       ;PRINT,  Envir1d3[*, 0:100]
       
     ;Initialize IBM for each species -> DO IT ONLY ONCE at the bebinning of simulations
     IF ((iYear EQ 2005L) AND (iDay EQ 105L) AND (i10Minute EQ 0L)) THEN BEGIN; iday = DOY-1
       YP = YEPinitial(NpopYP, nYP, Envir1D3[8, *], envir1d3, nVerLay)  
       WAE = WAEinitial(NpopWAE, nWAE, Envir1D3[8, *], envir1d3, nVerLay)  
       RAS = RASinitial(NpopRAS, nRAS, Envir1D3[8, *], envir1d3, nVerLay)  
       EMS = EMSinitial(NpopEMS, nEMS, Envir1D3[8, *], envir1d3, nVerLay)  
       ROG = ROGinitial(NpopROG, nROG, Envir1D3[8, *], envir1d3, nVerLay)  
     ENDIF
;     PRINT, 'RAS[1, 0:100]'
;     PRINT, transpose(RAS[1, 0:100])
;     PRINT, 'EMS[1, 0:100]'
;     PRINT, transpose(EMS[1, 0:100])
     
       PreyFish = FishArray1D(YP, EMS, RAS, ROG, WAE, nYP, nEMS, nRAS, nROG, nWAE, nVerLay)

       YEPMoveV = YEPMove1DV(ts, LightEnvir1d2[2, *], YP, nYP, Envir1D3, PreyFish, YP[41, *], YP[63, *])
       ;WAEMoveV = WAEMove1DV(ts, LightEnvir1d2[2, *], WAE, nWAE, Envir1D3, PreyFish, WAE[41, *], WAE[63, *])
       ;EMSMoveV = EMSMove1DV(ts, LightEnvir1d2[2, *], EMS, nEMS, Envir1D3, PreyFish, EMS[41, *], EMS[63, *])
       ;RASMoveV = RASMove1DV(ts, LightEnvir1d2[2, *], RAS, nRAS, Envir1D3, PreyFish, RAS[41, *], RAS[63, *])
       ;ROGMoveV = ROGMove1DV(ts, LightEnvir1d2[2, *], ROG, nROG, Envir1D3, PreyFish, ROG[41, *], ROG[63, *])      
       ;PRINT, 'VERTICAL LOCATION'
       ;PRINT, TRANSPOSE(YP[14, 0:50])
       ;PRINT, TRANSPOSE(WAE[14, 0:50])
       ;PRINT, TRANSPOSE(EMS[14, 0:50])
       ;PRINT, TRANSPOSE(RAS[14, 0:50])
       ;PRINT, TRANSPOSE(ROG[14, 0:50])

       
     ENDFOR  
  ENDFOR
ENDFOR
; PRINT, 'New Daily Input'
; PRINT,  Envir1d3
END