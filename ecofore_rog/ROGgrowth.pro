FUNCTION ROGgrowth, length, weight, stor, struc, ROGcmx, consumption, ROGres, Temp, nROG, ts, iday, ihour, iTime
; Function to determine growth in both storage and structure tissue for Round Goby

;***************************************************************************************************************************
;PRO ROGgrowth, length, weight, stor, struc, ROGcmx, consumption, ROGres, Temp, nROG, ts, iday, ihour, iTime
;iDay = 243
;iHour = 15
;iTime = 5
;ts = 6;
;nROG = 300
;
;Grid3D = GridCells3D()
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell) 
;BottomCell = WHERE(Grid3D[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;Grid2D = GridCells2D()
;NewInput = EcoForeInputfiles()
;NewInput = NewInput[*, 77500L * ihour : 77500L * ihour + 77499L]
;TotBenBio = TotBenBio + NewInput[8, *]
;
;; INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE 
;NpopYP = 103540000D + 78843333D + 122247000D + 3257000D + 23600000D + 1645000D + 8300000D; number of YEP individuals
;NpopWAE = 6960000D + 30129000D + 150000D + 8138000D + 553000D + 2430000D + 1028000D ; number of WAE individuals
;NpopRAS = 36683333D + 63653333D; number of RAS individuals
;NpopEMS = 446761667D + 432036667D; number of EMS individuals
;NpopROG = 201138333D + 260038333D; number of ROG individuals
;
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput)
;length = ROG[1, *]; in mm
;Weight = ROG[2, *]; g
;stor = ROG[3, *]; g
;struc = ROG[4, *]; g
;Temp = ROG[26, *]; acclimated temperature
;ROGcmx = ROGcmax(weight, length, nROG, TEMP); Cmax in g 
;
;Light = ROG[21, *]; acclimated temperature
;TotCday = ROG[9, *]; total consumption in last 24 hours -> the previous time step?
;PreStom = ROG[7, *] ; stomcah weight from the previous time step 
;TotC0 = ROG[48, *]; total amount of microzooplankton consumed over the last 24 hours in g
;TotC1 = ROG[49, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
;TotC2 = ROG[50, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
;TotC3 = ROG[51, *]; total amount of chironomids consumed over the last 24 hours in g
;TotC4 = ROG[52, *]; total amount of invasive species consumed over the last 24 hours in g
;TotC5 = ROG[53, *]; total amount of yellow perch consumed over the last 24 hours in g
;Stcap = ROGstcap(weight, nROG); [0.24, 0.24]; maximum stocmach capacity
;CAftDig0 = ROG[30, *];
;CAftDig1 = ROG[31, *];
;CAftDig2 = ROG[32, *];
;CAftDig3 = ROG[33, *];
;CAftDig4 = ROG[34, *];
;CAftDig5 = ROG[35, *];
;
;TacclR = ROG[27, *]
;TacclC = ROG[26, *]
;Tamb = ROG[19, *]
;DOa = ROG[20, *]
;DOacclR = ROG[29, *]
;DOacclC = ROG[28, *]
;DOacclim = ROGacclDO(DOacclR, DOacclC, DOa, TacclR, TacclC, Tamb, ts, length, weight, nROG)
;DOcritC = DOacclim[5, *]
;ROGres = ROGresp(Tamb, TacclC, Weight, Length, ts, DOa, DOacclC, DOcritC, nROG)
;
;;********************************************************
;; Creat a fish prey array for potential predators 
;nYP = 100000L
;nEMS = 100000L;
;nRAS = 100000L;
;;nROG = 100000L;
;nWAE = 100000L;
;YP = YEPinitial(NpopYP, nYP, TotBenBio, NewInput); FISHARRY PARAMETER
;EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, NewInput); FISHARRY PARAMETER
;RAS = RASinitial(NpopRAS, nRAS, TotBenBio, NewInput); FISHARRY PARAMETER
;;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput); FISHARRY PARAMETER
;WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, NewInput); FISHARRY PARAMETER
;
;nGridcell = 77500L
;FISHPREY = FLTARR(28L, nGridcell)
;FISH3DCellIDcount = FLTARR(5, nGridcell)
;FISHPREY[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;FISHPREY[5, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;FISHPREY[10, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;FISHPREY[15, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;FISHPREY[20, WAE[14, *]] = WAE[0, *]; ABUNDANCE
;
;; NUMBER OF SUPERINDIVIDUALS, LENGTH, AND WEIGHT
;FOR ID = 0L, nYP-1L DO BEGIN
;  FISH3DCellIDcount[0, YP[14, ID]] = FISH3DCellIDcount[0, YP[14, ID]] + (YP[0, ID] GT 0.); NUMBER OF SIs
;  IF FISHPREY[1, YP[14, ID]] EQ 0. THEN BEGIN; WHEN THE CELL IS EMPTY...
;    FISHPREY[1, YP[14, ID]] = YP[1, ID]; LENGTH
;    FISHPREY[2, YP[14, ID]] = YP[2, ID]; WEIGHT
;  ENDIF
;  IF FISHPREY[1, YP[14, ID]] GT 0. THEN BEGIN; WHEN OTHER SIs ARE ALREADY IN THE CELL...
;    IF (FISHPREY[1, YP[14, ID]] GT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS LARGER...
;      FISHPREY[1, YP[14, ID]] = YP[1, ID]
;      FISHPREY[2, YP[14, ID]] = YP[2, ID]
;    ENDIF
;    IF (FISHPREY[1, YP[14, ID]] LT YP[1, ID]) THEN BEGIN; WHEN NEW SI IS SMALLER...
;      FISHPREY[1, YP[14, ID]] = FISHPREY[1, YP[14, ID]]
;      FISHPREY[2, YP[14, ID]] = FISHPREY[2, YP[14, ID]]   
;    ENDIF
;  ENDIF
;ENDFOR
;FOR ID = 0L, nEMS-1L DO BEGIN
;  FISH3DCellIDcount[1, EMS[14, ID]] = FISH3DCellIDcount[1, EMS[14, ID]] + (EMS[0, ID] GT 0.) 
;  IF FISHPREY[6, EMS[14, ID]] EQ 0. THEN BEGIN 
;    FISHPREY[6, EMS[14, ID]] = EMS[1, ID];
;    FISHPREY[7, EMS[14, ID]] = EMS[2, ID];
;  ENDIF
;  IF FISHPREY[6, EMS[14, ID]] GT 0. THEN BEGIN
;    IF (FISHPREY[1, EMS[14, ID]] GT EMS[1, ID]) THEN BEGIN
;      FISHPREY[6, EMS[14, ID]] = EMS[1, ID]
;      FISHPREY[7, EMS[14, ID]] = EMS[2, ID]
;   ENDIF
;    IF (FISHPREY[6, EMS[14, ID]] LT EMS[1, ID]) THEN BEGIN
;      FISHPREY[6, EMS[14, ID]] = FISHPREY[6, EMS[14, ID]]
;      FISHPREY[7, EMS[14, ID]] = FISHPREY[7, EMS[14, ID]]   
;    ENDIF
;  ENDIF
;ENDFOR
;FOR ID = 0L, nRAS-1L DO BEGIN
;  FISH3DCellIDcount[2, RAS[14, ID]] = FISH3DCellIDcount[2, RAS[14, ID]] + (RAS[0, ID] GT 0.) 
;  IF FISHPREY[11, RAS[14, ID]] EQ 0. THEN BEGIN 
;    FISHPREY[11, RAS[14, ID]] = RAS[1, ID];
;    FISHPREY[12, RAS[14, ID]] = RAS[2, ID];
;  ENDIF
;  IF FISHPREY[11, RAS[14, ID]] GT 0. THEN BEGIN
;    IF (FISHPREY[11, RAS[14, ID]] GT RAS[1, ID]) THEN BEGIN
;      FISHPREY[11, RAS[14, ID]] = RAS[1, ID]
;      FISHPREY[12, RAS[14, ID]] = RAS[2, ID]
;    ENDIF
;    IF (FISHPREY[11, RAS[14, ID]] LT RAS[1, ID]) THEN BEGIN
;      FISHPREY[11, RAS[14, ID]] = FISHPREY[11, RAS[14, ID]]
;      FISHPREY[12, RAS[14, ID]] = FISHPREY[12, RAS[14, ID]]   
;    ENDIF
;  ENDIF
;ENDFOR
;FOR ID = 0L, nROG-1L DO BEGIN
;  FISH3DCellIDcount[3, ROG[14, ID]] = FISH3DCellIDcount[3, ROG[14, ID]] + (ROG[0, ID] GT 0.) 
;  IF FISHPREY[16, ROG[14, ID]] EQ 0. THEN BEGIN 
;    FISHPREY[16, ROG[14, ID]] = ROG[1, ID];
;    FISHPREY[17, ROG[14, ID]] = ROG[2, ID];
;  ENDIF
;  IF FISHPREY[16, ROG[14, ID]] GT 0. THEN BEGIN
;    IF (FISHPREY[16, ROG[14, ID]] GT ROG[1, ID]) THEN BEGIN
;      FISHPREY[16, ROG[14, ID]] = ROG[1, ID]
;      FISHPREY[17, ROG[14, ID]] = ROG[2, ID]
;    ENDIF
;    IF (FISHPREY[16, ROG[14, ID]] LT ROG[1, ID]) THEN BEGIN
;      FISHPREY[16, ROG[14, ID]] = FISHPREY[16, ROG[14, ID]]
;      FISHPREY[17, ROG[14, ID]] = FISHPREY[17, ROG[14, ID]]
;    ENDIF   
;  ENDIF
;ENDFOR
;FOR ID = 0L, nWAE-1L DO BEGIN
;  FISH3DCellIDcount[4, WAE[14, ID]] = FISH3DCellIDcount[4, WAE[14, ID]] + (WAE[0, ID] GT 0.) 
;  IF FISHPREY[21, WAE[14, ID]] EQ 0. THEN BEGIN 
;    FISHPREY[21, WAE[14, ID]] = WAE[1, ID];
;    FISHPREY[22, WAE[14, ID]] = WAE[2, ID];
;  ENDIF
;  IF FISHPREY[21, WAE[14, ID]] GT 0. THEN BEGIN
;    IF (FISHPREY[21, WAE[14, ID]] GT WAE[1, ID]) THEN BEGIN
;      FISHPREY[21, WAE[14, ID]] = WAE[1, ID]
;      FISHPREY[22, WAE[14, ID]] = WAE[2, ID]
;    ENDIF
;    IF (FISHPREY[21, WAE[14, ID]] LT WAE[1, ID]) THEN BEGIN
;      FISHPREY[21, WAE[14, ID]] = FISHPREY[21, WAE[14, ID]]
;      FISHPREY[22, WAE[14, ID]] = FISHPREY[22, WAE[14, ID]]
;    ENDIF   
;  ENDIF
;ENDFOR
;
;; TOTAL ABUNDANCE AND BIOMASS
;FISHPREY[0, YP[14, *]] = FISHPREY[0, YP[14, *]] * FISH3DCellIDcount[0, YP[14, *]]; TOTAL ABUNDANCE
;FISHPREY[3, YP[14, *]] = YP[2, *] * FISHPREY[0, YP[14, *]]; TOTAL BIOMASS
;FISHPREY[5, EMS[14, *]] = FISHPREY[5, EMS[14, *]] * FISH3DCellIDcount[1, EMS[14, *]]; 
;FISHPREY[8, EMS[14, *]] = EMS[2, *]*FISHPREY[5, EMS[14, *]]; 
;FISHPREY[10, RAS[14, *]] = FISHPREY[10, RAS[14, *]] * FISH3DCellIDcount[2, RAS[14, *]]; 
;FISHPREY[13, RAS[14, *]] = RAS[2, *]*FISHPREY[10, RAS[14, *]]; 
;FISHPREY[15, ROG[14, *]] = FISHPREY[15, ROG[14, *]] * FISH3DCellIDcount[3, ROG[14, *]]; 
;FISHPREY[18, ROG[14, *]] = ROG[2, *] * FISHPREY[15, ROG[14, *]]; 
;FISHPREY[20, WAE[14, *]] = FISHPREY[20, WAE[14, *]] * FISH3DCellIDcount[4, WAE[14, *]]; 
;FISHPREY[23, WAE[14, *]] = WAE[2, *] * FISHPREY[20, WAE[14, *]];
;
;; NUMBER OF SUPERINDIVIDUALS
;FISHPREY[4, YP[14, *]] = FISH3DCellIDcount[0, YP[14, *]];  the number of superindividuals
;FISHPREY[9, EMS[14, *]] = FISH3DCellIDcount[1, EMS[14, *]];  the number of superindividuals
;FISHPREY[14, RAS[14, *]] = FISH3DCellIDcount[2, RAS[14, *]];  the number of superindividuals
;FISHPREY[19, ROG[14, *]] = FISH3DCellIDcount[3, ROG[14, *]];  the number of superindividuals
;FISHPREY[24, WAE[14, *]] = FISH3DCellIDcount[4, WAE[14, *]];  the number of superindividuals
;FISHPREY[25, *] = TOTAL(FISH3DCellIDcount, 1); TOTAL NUMBER OF SUPERINDIVIDUALS IN A CELL
;FISHPREY[26, *] = FISHPREY[0, *] + FISHPREY[5, *] + FISHPREY[10, *] + FISHPREY[15, *] + FISHPREY[20, *]; TOTAL NUMBER OF INDIVIDUALS IN A CELL
;FISHPREY[27, *] = FISHPREY[3, *] + FISHPREY[8, *] + FISHPREY[13, *] + FISHPREY[18, *] + FISHPREY[23, *]; TOTAL BIOMASS IN A CELL
;
;
;GridcellSize = 4000000000D*Grid2D[3, ROG[13, *]]/20L; grid cell size (L)
;
;ROGpbio = FLTARR(25, nROG);  g/L or g/m2
;; density dependence is already incorporated for invertebrate prey
;ROGpbio[0,*] = ROG[15, *]*1L;/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[1,*] = ROG[16, *]*1L;/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[2,*] = ROG[17, *]*1L;/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[3,*] = ROG[18, *]*1L;/ (ROG[0, *] * ROG[2, *]); zooplankton and benthos 
;ROGpbio[4,*] = 0.0;/ (ROG[0, *] * ROG[2, *]); for invasive species 
;
;ROGpbio[5, *] = FISHPREY[0, ROG[14, *]]/ GridcellSize; yellow perch abundance
;ROGpbio[6, *] = FISHPREY[1, ROG[14, *]]; length
;ROGpbio[7, *] = FISHPREY[2, ROG[14, *]]; weight
;ROGpbio[8, *] = FISHPREY[3, ROG[14, *]]/ GridcellSize; / (ROG[0, *] * ROG[2, *]); biomass 
;
;ROGpbio[9, *] = FISHPREY[5, ROG[14, *]]/ GridcellSize; emerald shiner abundance
;ROGpbio[10, *] = FISHPREY[6, ROG[14, *]] 
;ROGpbio[11, *] = FISHPREY[7, ROG[14, *]]
;ROGpbio[12, *] = FISHPREY[8, ROG[14, *]]/ GridcellSize; /(YP[0, *] * YP[2, *]) 
;
;ROGpbio[13, *] = FISHPREY[10, ROG[14, *]]/ GridcellSize; rainbow smelt abundance
;ROGpbio[14, *] = FISHPREY[11, ROG[14, *]] 
;ROGpbio[15, *] = FISHPREY[12, ROG[14, *]]
;ROGpbio[16, *] = FISHPREY[13, ROG[14, *]]/ GridcellSize; /(YP[0, *] * YP[2, *])
;
;ROGpbio[17, *] = FISHPREY[15, ROG[14, *]]/ GridcellSize; round goby abundance
;ROGpbio[18, *] = FISHPREY[16, ROG[14, *]] 
;ROGpbio[19, *] = FISHPREY[17, ROG[14, *]]
;ROGpbio[20, *] = FISHPREY[18, ROG[14, *]]/ GridcellSize; /(YP[0, *] * YP[2, *])
;
;ROGpbio[21, *] = FISHPREY[20, ROG[14, *]] / GridcellSize; walleye abundance
;ROGpbio[22, *] = FISHPREY[21, ROG[14, *]] 
;ROGpbio[23, *] = FISHPREY[22, ROG[14, *]]
;ROGpbio[24, *] = FISHPREY[23, ROG[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *])
;
;CONSUMPTION = ROGforage(iHour, Length, Temp, Light, ROGpbio, ROGcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4,$
;CAftDig5, StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, ts, nROG, DOa, DOacclC, DOcritC, ROG, Grid2D)
;*******************************************************************************************************************************
PRINT, 'ROGgrowth Begins Here'

m = 6; a number of prey types
; energy values assigned for storage and structure in J/g for PERCH
stor_energy = 6500.0
struc_energy = 500.0
frac = stor_energy / (stor_energy + struc_energy); fraction to storage

; energy density of the prey (j/g wet)
EDprey = FLTARR(m, nROG)
EDprey[0, *] = 1674.0 ;j/g- rotifers assumed value from Hewett and Stewart 1989
EDprey[1, *] = RANDOMU(seed, nROG)*(MAX(3684.) - MIN(1900.)) + MIN(1900.);2792.0 ;j/g- copepoda 1900-3684
EDprey[2, *] = RANDOMU(seed, nROG)*(MAX(2746.) - MIN(2281.)) + MIN(2281.);2513.5 ;j/g- cladocera 2281-2746
EDprey[3, *] = RANDOMU(seed, nROG)*(MAX(2478.) - MIN(1047.)) + MIN(1047.);1762.5 ;j/g- chironomidae 1047-2478
EDprey[4, *] = 1674.0 ;j/g- bythotrephe 1674 Lantry and Stewart 1993
EDprey[5, *] = RANDOMU(seed, nROG)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596

optrho = (1.2*0.0912 * ALOG(length) + 0.128*0.9);+rhos ;(based on energy data from Hanson 1997 FOR PERCH$
;and seasonal genetic component from rho function
opt_wt = optrho * weight ;determines the percent weight that should be storage
percent_stor = Optrho * frac
percent_struc = (1.0 - optrho) * (1.0 - frac)

;PRINT, 'ROG New Digested prey item (DigestedFood, g)'
;PRINT, total(consumption[0:5, 0:100],1)
;determining growth
ConsJ = FLTARR(m, nROG) ;joules of prey consumed per time step
ConsJ[0, *] = consumption[0, *] * EDprey[0, *] ;converts consumption to J/6min
ConsJ[1, *] = consumption[1, *] * EDprey[1, *] ;converts consumption to J/6min
ConsJ[2, *] = consumption[2, *] * EDprey[2, *] ;converts consumption to J/6min
ConsJ[3, *] = consumption[3, *] * EDprey[3, *] ;converts consumption to J/6min
ConsJ[4, *] = consumption[4, *] * EDprey[4, *] ;converts consumption to J/6min
ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/6min

;PRINT, 'Respiration'
;PRINT, ROGres[0:100]
consJtot = FLTARR(nROG)
consJtot = (consJ[0,*] + consJ[1,*] + consJ[2,*] + consJ[3,*] + consJ[4,*] + consJ[5,*])
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:100]
consJtot = TRANSPOSE(consJtot)


; parameter values for energy loss
Eges = FLTARR(nROG)
Exc = FLTARR(nROG)
;S = FLTARR(nROG)
; Larvae and Juvenile----------------------------------------------------------------------------------------------
;TL = WHERE(length LT 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
;IF (TLcount GT 0.0) THEN BEGIN
;PRINT, 'Number of fish <43mm =', TLcount 
;values are for larval 
; egestion 
FA = 0.15
; Excretion
UA = 0.1
; Specific dynamic action
SDA = 0.175

Eges = FA * ((ConsJtot)) ;calculate egestion -> Make temp-dependent function??? 
Exc = UA * (ConsJtot - Eges) ;calculate excretion
S = SDA * (ConsJtot - Eges) ;calculation SDA

;NEED TO FIND INFORMATION FOR ROUND GOBY
alength = 49.0; W-L parameters from Rose et al. 1999
bLength = 0.31; W-L parameters
;ENDIF 
;-----------------------------------------------------------------------------------------------------
;PRINT, 'ROGcmx =', ROGcmx
;pvalue = (consumption[0,*] + consumption[1,*] + consumption[2,*] + consumption[3,*]+ consumption[4,*] $
;+ consumption[5,*]) / ROGcmx / 24.0 / 60.0 * ts
;PRINT, 'pvalue =', pvalue

; Adult------------------------------------------------------------------------------------------------
;IF (TLLcount GT 0.0) THEN BEGIN 
;PRINT, 'Number of fish > 43mm =', TLLcount
;;values are for juvenile and adult walleye
;; egestion 
;FA = 0.158
;FB = -0.222
;FG = 0.631
;; excretion
;UA = 0.0253
;UB = 0.58
;UG = -0.229
;; specific dynamic action
;SDA = 0.172
;Eges[TLL] = FA * Temp[TLL]^FB * EXP(FG * pvalue) * ((ConsJtot[TLL])) ;calculate egestion -> Make temp-dependent function 
;Exc[TLL] = UA * Temp[TLL]^FB * EXP(FG * pvalue) * (ConsJtot[TLL] - Eges[TLL]) ;calculate excretion
;S[TLL] = SDA * (ConsJtot[TLL] - Eges[TLL]) ;calculation SDA
;alength = 49.0; W-L parameters from Rose et al. 1999
;bLength = 0.3; W-L parameters
;ENDIF
;-----------------------------------------------------------------------------------------------------


Energy_loss = TRANSPOSE(ROGres + Eges + Exc + S) ;determine total energy lost in J/6min
Energy_gained = TRANSPOSE(ConsJtot) ;energy consumed in J/6min
energy_change = (energy_gained - energy_loss) ;energy available for growth J/6min
pot_stor =  stor + (energy_change / stor_energy) 


; Hold all the amount of food consumed per time step and places it all in storage
nstor = FLTARR(nROG)
nstruc = FLTARR(nROG)
nstr = FLTARR(nROG)
nstrc = FLTARR(nROG)
nlength = FLTARR(nROG)
new_stor = FLTARR(nROG)
new_struc = FLTARR(nROG)
New_weight = FLTARR(nROG)
Pot_length = FLTARR(nROG)
New_length = FLTARR(nROG)
; Determine change in time-step growth with constraint on proportional weight
ec = WHERE(energy_change GT 0.0, eccount, complement = ecc, ncomplement = ecccount); ec = + energy gain
IF(eccount GT 0.0) THEN BEGIN
  a = WHERE(stor GT opt_wt, acount, complement = aa, ncomplement = aacount)
    IF (acount GT 0.0) THEN BEGIN; if storage_weight is greater than optimal rho
    ; add to storage and structural tissue
    nstor[a] = stor[a] + (percent_stor[a] / (percent_stor[a] + percent_struc[a])) * (energy_change[a] / stor_energy[A])
    nstruc[a] = struc[a] + (percent_struc[a] / (percent_stor[a] + percent_struc[a])) * (energy_change[a] / struc_energy[A])
    ENDIF    
    IF (aacount GT 0.0) THEN BEGIN; if storage weight is less than optimal storage weight
        b = WHERE(Pot_stor LT opt_wt, bcount, complement = bb, ncomplement = bbcount)
        IF(bcount GT 0.0) THEN BEGIN; if potential storage is less than optimal storage
            nstr[b] = pot_stor[b]
            nstrc[b] = struc[b]
        ENDIF
        IF (bbcount GT 0.0) THEN BEGIN; if the potential storage is greater than optimal storage
            nstr[bb] = stor[bb] + (percent_stor[bb] / (percent_stor[bb] + percent_struc[bb])) * (energy_change[bb]/stor_energy[BB])
            nstrc[bb] = struc[bb] + (percent_struc[bb] / (percent_stor[bb] + percent_struc[bb])) * (energy_change[bb]/struc_energy[BB])
        ENDIF
        nstor[aa] = nstr[aa]
        nstruc[aa] = nstrc[aa]
     ENDIF
     new_stor[ec] = nstor[ec]
     new_struc[ec] = nstruc[ec]
     new_weight[ec] = nstor[ec] + nstruc[ec]
ENDIF
IF(ecccount GT 0.0) THEN BEGIN; ecc = -energy gain
   ;individual loses 
   new_stor[ecc] = pot_stor[ecc]
   storNZ = WHERE(new_stor GT 0.,storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
   IF storZcount GT 0. THEN new_stor[storZ] = 0.
   new_struc[ecc] = struc[ecc]
   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
ENDIF


; Determine time-step (= 6min) growth in length
g = WHERE(new_struc GT struc, gcount, complement = gg, ncomplement = ggcount)
IF (gcount GT 0.0) THEN BEGIN
;***********CHECK THE FOLLOWING FUNCTION (New_weight OR new_struc)****************************************
   Pot_length[g] = 1.4*59.761 * (New_struc[g]^0.3401*0.7) ; weight-length equation from Rose et al. 1999 
   pl = WHERE(pot_length GT length, plcount, complement = ppl, ncomplement = pplcount)
   IF(plcount GT 0.0) THEN nlength[pl] = pot_length[pl]
   IF(pplcount GT 0.0) THEN nlength[ppl] = length[ppl]
   new_length[g] = nlength[g]
ENDIF
IF (ggcount GT 0.0) THEN new_length[gg] = length[gg]


;PRINT, 'consumption (g)'
;PRINT, consumption
;PRINT, 'ConsJ (J)'
;PRINT, ConsJ
;PRINT, 'consjtot (J)'
;PRINT, consJtot
;PRINT, 'Respiration'
;PRINT, ROGres
;PRINT, 'Egestion'
;PRINT, Eges
;PRINT, 'Excretion'
;PRINT, Exc
;PRINT, 'SDA'
;PRINT, S
;PRINT, 'WEIGHT'
;PRINT, TRANSPOSE(WEIGHT)
;PRINT, 'LENGTH'
;PRINT, TRANSPOSE(LENGTH)

;PRINT, 'energy_change'
;PRINT, TRANSPOSE(energy_change)
;PRINT, 'pot_stor =', pot_stor
;PRINT, 'new_stor'
;PRINT, new_stor
;PRINT, 'new_struc'
;PRINT, new_struc
;PRINT, 'new_weight'
;PRINT, new_weight 
;PRINT, 'new_length'
;PRINT, new_length
;
;PRINT, 'growth_length'
;PRINT, new_length - transpose(length)
;PRINT, 'growth_weight'
;PRINT, new_weight - transpose(weight)


GrowthAttribute = FLTARR(6, nROG)
GrowthAttribute[0,*] = new_weight
GrowthAttribute[1,*] = new_length
GrowthAttribute[2,*] = new_struc
GrowthAttribute[3,*] = new_stor
GrowthAttribute[4, *] = new_length - transpose(length)
GrowthAttribute[5, *] = new_weight - transpose(weight)
;PRINT, GrowthAttribute

PRINT, 'ROGgrowth Ends Here for DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
RETURN, GrowthAttribute
END