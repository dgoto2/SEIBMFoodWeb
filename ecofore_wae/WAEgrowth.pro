FUNCTION WAEgrowth, length, weight, stor, struc, WAEcmx, consumption, WAEres, Temp, nWAE, ts, iday, ihour, iTime
; Function to determine growth of YOY walleye in both storage and structure tissue

;***TEST ONLY; TURN OFF when running with the full model**********************************************************************
;PRO WAEgrowth, length, weight, stor, struc, WAEcmx, consumption, WAEres, Temp, nWAE, ts, iday, ihour, iTime
;iDay = 243L
;iHour = 22
;iTime = 5
;ts = 15;
;nWAE = 100000L
;
;; INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE 
;NpopYP = 103540000D + 78843333D + 122247000D + 3257000D + 23600000D + 1645000D + 8300000D; number of YEP individuals
;NpopWAE = 6960000D + 30129000D + 150000D + 8138000D + 553000D + 2430000D + 1028000D ; number of WAE individuals
;NpopRAS = 36683333D + 63653333D; number of RAS individuals
;NpopEMS = 446761667D + 432036667D; number of EMS individuals
;NpopROG = 201138333D + 260038333D; number of ROG individuals
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
;WAE = WAEinitial(NpopWAE, nWAE, TotBenBio, NewInput)
;length = WAE[1, *]; in mm
;Weight = WAE[2, *]; g
;stor = WAE[3, *]; g
;struc = WAE[4, *]; g
;Temp = WAE[26, *]; acclimated temperature
;WAEcmx = WAEcmax(weight, length, nWAE, temp); Cmax in g 
;
;LIGHT = WAE[21, *]; acclimated temperature
;TotCday = WAE[9, *]; total consumption in last 24 hours -> the previous time step?
;PreStom = WAE[7, *] ; stomcah weight from the previous time step 
;TotC0 = WAE[49, *]; total amount of microzooplankton consumed over the last 24 hours in g
;TotC1 = WAE[50, *]; total amount of small mesozooplankton consumed over the last 24 hours in g
;TotC2 = WAE[51, *]; total amount of large mesozooplankton consumed over the last 24 hours in g
;TotC3 = WAE[52, *]; total amount of chironomids consumed over the last 24 hours in g
;TotC4 = WAE[53, *]; total amount of invasive species consumed over the last 24 hours in g
;TotC5 = WAE[54, *]; total amount of yellow perch consumed over the last 24 hours in g
;TotC6 = WAE[55, *]; total amount of emerald shiner consumed over the last 24 hours in g
;TotC7 = WAE[56, *]; total amount of rainbow smelt consumed over the last 24 hours in g
;TotC8 = WAE[57, *]; total amount of round goby consumed over the last 24 hours in g
;TotC9 = WAE[58, *]; total amount of WALLEYE consumed over the last 24 hours in g
;
;Stcap = WAEstcap(length, nWAE); [0.24, 0.24]; maximum stocmach capacity
;CAftDig0 = WAE[30, *];[0.0001, 0.0000001]
;CAftDig1 = WAE[31, *];[0.0001, 0.00000001]
;CAftDig2 = WAE[32, *];[0.0001, 0.00000001]
;CAftDig3 = WAE[33, *];[0.00001, 0.0000001]
;CAftDig4 = WAE[34, *];[0.00001, 0.0000001]
;CAftDig5 = WAE[35, *];[0.00001, 0.0000001]
;CAftDig6 = WAE[45, *];[0.00001, 0.0000001]
;CAftDig7 = WAE[46, *];[0.00001, 0.0000001]
;CAftDig8 = WAE[47, *];[0.00001, 0.0000001]
;CAftDig9 = WAE[48, *];[0.00001, 0.0000001]
;
;TacclR = WAE[27, *]
;TacclC = WAE[26, *]
;Tamb = WAE[19, *]
;DOa = WAE[20, *]
;DOacclR = WAE[29, *]
;DOacclC = WAE[28, *]
;DOacclim = WAEacclDO(DOacclR, DOacclC, DOa, TacclR, TacclC, Tamb, ts, length, weight, nWAE)
;DOcritR = DOacclim[4, *]
;DOcritC = DOacclim[5, *]
;WAEres = WAEresp(Tamb, TacclC, Weight, Length, ts, DOa, DOacclR, DOcritR, nWAE)
;
;;********************************************************
;; Creat a fish prey array for potential predators 
;YEPFISHPREY = FLTARR(5L, nGridcell)
;RASFISHPREY = FLTARR(5L, nGridcell)
;EMSFISHPREY = FLTARR(5L, nGridcell)
;ROGFISHPREY = FLTARR(5L, nGridcell)
;WAEFISHPREY = FLTARR(5L, nGridcell)
;nYP = 80000L
;nEMS = 80000L;
;nRAS = 80000L;
;nROG = 80000L;
;YP = YEPinitial(NpopYP, nYP, TotBenBio, NewInput)
;EMS = EMSinitial(NpopEMS, nEMS, TotBenBio, NewInput)
;RAS = RASinitial(NpopRAS, nRAS, TotBenBio, NewInput)
;ROG = ROGinitial(NpopROG, nROG, TotBenBio, NewInput)
;
;; yellow perch as prey
;YEPFISHPREY[0, YP[14, *]] = YP[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;YEPFISHPREY[1, YP[14, *]] = YP[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;YEPFISHPREY[2, YP[14, *]] = YP[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;YEPFISHPREY[3, YP[14, *]] = YP[2, *] * YP[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; emrald shiner as prey
;EMSFISHPREY[0, EMS[14, *]] = EMS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;EMSFISHPREY[1, EMS[14, *]] = EMS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;EMSFISHPREY[2, EMS[14, *]] = EMS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;EMSFISHPREY[3, EMS[14, *]] = EMS[2, *] * EMS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; rainbow smelt as prey
;RASFISHPREY[0, RAS[14, *]] = RAS[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;RASFISHPREY[1, RAS[14, *]] = RAS[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;RASFISHPREY[2, RAS[14, *]] = RAS[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;RASFISHPREY[3, RAS[14, *]] = RAS[2, *] * RAS[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; round goby as prey
;ROGFISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;ROGFISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;ROGFISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;ROGFISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;; walleye as prey
;WAEFISHPREY[0, WAE[14, *]] = WAE[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;WAEFISHPREY[1, WAE[14, *]] = WAE[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;WAEFISHPREY[2, WAE[14, *]] = WAE[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;WAEFISHPREY[3, WAE[14, *]] = WAE[2, *] * WAE[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;
;GridcellSize = 4000000000D*Grid2D[3, WAE[13, *]]/20L; grid cell size (L)
;
;WAEpbio = FLTARR(25, nWAE);  g/L or g/m2
;; density dependence is already incorporated for invertebrate prey
;WAEpbio[0,*] = WAE[15, *]*1L;/ (WAE[0, *] * WAE[2, *]); zooplankton and benthos 
;WAEpbio[1,*] = WAE[16, *]*1L;/ (WAE[0, *] * WAE[2, *]); zooplankton and benthos 
;WAEpbio[2,*] = WAE[17, *]*1L;/ (WAE[0, *] * WAE[2, *]); zooplankton and benthos 
;WAEpbio[3,*] = WAE[18, *]*1L;/ (WAE[0, *] * WAE[2, *]); zooplankton and benthos 
;WAEpbio[4,*] = 0.0;/ (WAE[0, *] * WAE[2, *]); for invasive species 
;
;WAEpbio[5, *] = YEPFISHPREY[0, WAE[14, *]] / GridcellSize; yellow perch abundance
;WAEpbio[6, *] = YEPFISHPREY[1, WAE[14, *]]; length
;WAEpbio[7, *] = YEPFISHPREY[2, WAE[14, *]]; weight
;WAEpbio[8, *] = YEPFISHPREY[3, WAE[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *]); biomass       
;WAEpbio[9, *] = EMSFISHPREY[0, WAE[14, *]]/ GridcellSize; emerald shiner abundance
;WAEpbio[10, *] = EMSFISHPREY[1, WAE[14, *]] 
;WAEpbio[11, *] = EMSFISHPREY[2, WAE[14, *]]
;WAEpbio[12, *] = EMSFISHPREY[3, WAE[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *])
;WAEpbio[13, *] = RASFISHPREY[0, WAE[14, *]] / GridcellSize ; rainbow smelt abundance
;WAEpbio[14, *] = RASFISHPREY[1, WAE[14, *]] 
;WAEpbio[15, *] = RASFISHPREY[2, WAE[14, *]]
;WAEpbio[16, *] = RASFISHPREY[3, WAE[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *])
;WAEpbio[17, *] = ROGFISHPREY[0, WAE[14, *]] / GridcellSize ; round goby abundance
;WAEpbio[18, *] = ROGFISHPREY[1, WAE[14, *]] 
;WAEpbio[19, *] = ROGFISHPREY[2, WAE[14, *]]
;WAEpbio[20, *] = ROGFISHPREY[3, WAE[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *])
;WAEpbio[21, *] = WAEFISHPREY[0, WAE[14, *]] / GridcellSize; walleye abundance
;WAEpbio[22, *] = WAEFISHPREY[1, WAE[14, *]] 
;WAEpbio[23, *] = WAEFISHPREY[2, WAE[14, *]]
;WAEpbio[24, *] = WAEFISHPREY[3, WAE[14, *]] / GridcellSize; / (WAE[0, *] * WAE[2, *])
;;PRINT, 'WAEpbio'
;;PRINT, WAEpbio; FORAGE PARAMETER
;
;CONSUMPTION = WAEforage(iHour, Length, Temp, Light, WAEpbio, WAEcmx, PreStom, CAftDig0, CAftDig1, CAftDig2, CAftDig3, CAftDig4, CAftDig5, $
;CAftDig6, CAftDig7, CAftDig8, CAftDig9, StCap, TotCday, TotC0, TotC1, TotC2, TotC3, TotC4, TotC5, TotC6, TotC7, TotC8, TotC9, $
;ts, nWAE, DOa, DOacclC, DOcritC, WAE, Grid2D)
;******************************************************************************************************************************

PRINT, 'WAEgrowth Begins Here'
tstart = SYSTIME(/seconds)

m = 10; a number of prey types
; energy density of the prey (j/g wet)
EDprey = FLTARR(m, nWAE)
EDprey[0, *] = 1674.0 ;j/g- rotifers assumed value from Hewett and Stewart 1989
EDprey[1, *] = RANDOMU(seed, nWAE)*(MAX(3684.) - MIN(1900.)) + MIN(1900.);2792.0 ;j/g- copepoda 1900-3684
EDprey[2, *] = RANDOMU(seed, nWAE)*(MAX(2746.) - MIN(2281.)) + MIN(2281.);2513.5 ;j/g- cladocera 2281-2746
EDprey[3, *] = RANDOMU(seed, nWAE)*(MAX(2478.) - MIN(1047.)) + MIN(1047.);1762.5 ;j/g- chironomidae 1047-2478
EDprey[4, *] = 1674.0 ;j/g- bythotrephe 1674 Lantry and Stewart 1993
EDprey[5, *] = RANDOMU(seed, nWAE)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[6, *] = RANDOMU(seed, nWAE)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[7, *] = RANDOMU(seed, nWAE)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[8, *] = RANDOMU(seed, nWAE)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[9, *] = RANDOMU(seed, nWAE)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
;PRINT, 'Prey energy density (J)'
;PRINT, EDprey

; energy values assigned for storage and structure in J/g for walleye
stor_energy = 8000.0
struc_energy = 2000.0
frac = stor_energy / (stor_energy + struc_energy); fraction to storage = 0.8

Optrho = (0.1298 * ALOG(length) - 0.0853);+rhos ;(based on energy data from Hanson 1997$
                                    ;and seasonal genetic component from rho function
Opt_wt = Optrho * Weight ;determines optimal weight allocated as storage
percent_stor = Optrho * frac
percent_struc = (1.0 - optrho) * (1.0 - frac)


; Convert the amount of consumed prey to energy
ConsJ = FLTARR(m, nWAE) ;joules of prey consumed per time step
ConsJ[0, *] = consumption[0, *] * EDprey[0, *] ;converts consumption to J/6min
ConsJ[1, *] = consumption[1, *] * EDprey[1, *] ;converts consumption to J/6min
ConsJ[2, *] = consumption[2, *] * EDprey[2, *] ;converts consumption to J/6min
ConsJ[3, *] = consumption[3, *] * EDprey[3, *] ;converts consumption to J/6min
ConsJ[4, *] = consumption[4, *] * EDprey[4, *] ;converts consumption to J/6min
ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/6min
ConsJ[6, *] = consumption[6, *] * EDprey[6, *] ;converts consumption to J/6min
ConsJ[7, *] = consumption[7, *] * EDprey[7, *] ;converts consumption to J/6min
ConsJ[8, *] = consumption[8, *] * EDprey[8, *] ;converts consumption to J/6min
ConsJ[9, *] = consumption[9, *] * EDprey[9, *] ;converts consumption to J/6min

ConsJtot = FLTARR(nWAE)
ConsJtot = (consJ[0,*] + consJ[1,*] + consJ[2,*] + consJ[3,*] + consJ[4,*] $
           + consJ[5,*] + consJ[6,*] + consJ[7,*] + consJ[8,*] + consJ[9,*])
ConsJtot = TRANSPOSE(consJtot)

; parameter values for energy loss
FA = FLTARR(nWAE)
UA = FLTARR(nWAE)
SDA = FLTARR(nWAE)
alength = FLTARR(nWAE)
bLength = FLTARR(nWAE)
Eges = FLTARR(nWAE)
Exc = FLTARR(nWAE)
;S = FLTARR(nWAE)
; Larvae and Juvenile----------------------------------------------------------------------------------
TL = WHERE(length LT 43.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  PRINT, 'Number of fish <43mm =', TLcount 
  ;values are for larval 
  ; egestion 
  FA[TL] = 0.25
  ; Excretion
  UA[TL] = 0.05
  ; Specific dynamic action
  SDA[TL] = 0.1
  alength[TL] = 49.0; W-L parameters from Rose et al. 1999
  bLength[TL] = 0.31; W-L parameters
  Eges[TL] = FA[TL] * ((ConsJtot[TL])) ;calculate egestion -> Make temp-dependent function??? 
  Exc[TL] = UA[TL] * (ConsJtot[TL] - Eges[TL]) ;calculate excretion
ENDIF 
;-----------------------------------------------------------------------------------------------------

; Adult------------------------------------------------------------------------------------------------
IF (TLLcount GT 0.0) THEN BEGIN 
  Pvalue = (consumption[0, TLL] + consumption[1, TLL] + consumption[2, TLL] + consumption[3, TLL]+ consumption[4, TLL] $
  + consumption[5, TLL] + consumption[6, TLL] + consumption[7, TLL] + consumption[8, TLL]+ consumption[9, TLL]) / WAEcmx[TLL] * ts / 24.0 / 60.0 
  PRINT, 'Number of fish > 43mm =', TLLcount
  ;values are for juvenile and adult walleye
  ; egestion 
  FA[TLL] = 0.158
  FB = -0.222
  FG = 0.631
  ; excretion
  UA[TLL] = 0.0253
  UB = 0.58
  UG = -0.229
  ; specific dynamic action
  SDA[TLL] = 0.172
  alength[TLL] = 49.0; W-L parameters from Rose et al. 1999
  bLength[TLL] = 0.3; W-L parameters
  Eges[TLL] = FA[TLL] * Temp[TLL]^FB * EXP(FG * Pvalue[TLL]) * ((ConsJtot[TLL])) ;calculate egestion -> Make temp-dependent function 
  Exc[TLL] = UA[TLL] * Temp[TLL]^FB * EXP(FG * Pvalue[TLL]) * (ConsJtot[TLL] - Eges[TLL]) ;calculate excretion
ENDIF
;-----------------------------------------------------------------------------------------------------

S = SDA * (ConsJtot - Eges) ;calculation SDA
Energy_loss = TRANSPOSE(WAEres) + Eges + Exc + S ;determine total energy lost in J/ts
Energy_gained = (ConsJtot) ;energy consumed in J/ts
energy_change = (energy_gained - energy_loss) ;energy available for growth J/ts

pot_stor =  stor + (energy_change / stor_energy) 

Nstor = FLTARR(nWAE)
Nstruc = FLTARR(nWAE)
Nstr = FLTARR(nWAE)
Nstrc = FLTARR(nWAE)
nLength = FLTARR(nWAE)
New_Stor = FLTARR(nWAE)
New_Struc = FLTARR(nWAE)
New_Weight = FLTARR(nWAE)
Pot_Length = FLTARR(nWAE)
New_Length = FLTARR(nWAE)
; Determine change in growth with constraint on proportional weight
EC = WHERE(energy_change GT 0.0, ECcount, complement = ECc, ncomplement = ECccount); ec = + energy gain
IF(ECcount GT 0.0) THEN BEGIN; WHEN THERE IS +ENERGY GAIN
  A = WHERE(stor GT opt_wt, Acount, complement = AA, ncomplement = AAcount)
    IF (Acount GT 0.0) THEN BEGIN; IF storage_weight is greater than optimal storage weight
      ; add to storage and structural tissue
      Nstor[A] = stor[A] + (percent_stor[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / stor_energy)
      Nstruc[A] = struc[A] + (percent_struc[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / struc_energy)
    ENDIF    
    IF (AAcount GT 0.0) THEN BEGIN; IF storage weight is less than optimal storage weight
        B = WHERE(Pot_stor LT opt_wt, Bcount, complement = BB, ncomplement = BBcount)
        IF(bcount GT 0.0) THEN BEGIN; IF potential storage is less than optimal storage
            nstr[B] = pot_stor[B]
            nstrc[B] = struc[B]
        ENDIF
        IF (BBcount GT 0.0) THEN BEGIN; IF the potential storage is greater than optimal storage
            nstr[BB] = stor[BB] + (percent_stor[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/stor_energy)
            nstrc[BB] = struc[BB] + (percent_struc[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/struc_energy)
        ENDIF
        nstor[AA] = nstr[AA]
        nstruc[AA] = nstrc[AA]
     ENDIF
 new_stor[EC] = nstor[EC]
 new_struc[EC] = nstruc[EC]
 new_weight[EC] = nstor[EC] + nstruc[EC]
ENDIF
IF(ECccount GT 0.0) THEN BEGIN; WHEN THERE IS -ENERGY GAIN
; ecc = -energy gain
   new_stor[ecc] = pot_stor[ecc]
   storNZ = WHERE(new_stor GT 0.,storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
   IF storZcount GT 0. THEN new_stor[storZ] = 0.
   new_struc[ecc] = struc[ecc]
   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
ENDIF

; Determine time-step growth in length
G = WHERE(new_struc GT struc, gcount, complement = GG, ncomplement = GGcount)
IF (Gcount GT 0.0) THEN BEGIN
;***********CHECK THE FOLLOWING FUNCTION (New_weight OR new_struc)****************************************
   Pot_length[G] = 59.761 * (New_struc[G]^0.3401);aLength * (New_weight[g]^bLength); weight-length equation from Rose et al. 1999 
   PL = WHERE(pot_length GT length, plcount, complement = PPL, ncomplement = PPLcount)
   IF(PLcount GT 0.0) THEN nlength[PL] = pot_length[PL]
   IF(PPLcount GT 0.0) THEN nlength[PPL] = length[PPL]
   new_length[G] = nlength[G]
ENDIF
IF (GGcount GT 0.0) THEN new_length[GG] = length[GG]

;PRINT, 'Digested prey (g)'
;PRINT, consumption[0:9, *]
;PRINT, 'Prey-specific energy intake (ConJ, J)'
;PRINT, ConsJ
;PRINT, 'Total energy intake (J)'
;PRINT, consJtot
;
;PRINT, 'Optrho'
;PRINT, TRANSPOSE(Optrho)
;PRINT, 'Opt_wt'
;PRINT, TRANSPOSE(Opt_wt)
;PRINT, 'percent_stor'
;PRINT, TRANSPOSE(percent_stor)
;PRINT, 'percent_struc'
;PRINT, TRANSPOSE(percent_struc)
;PRINT, 'energy_gained'
;PRINT, (energy_gained)
;PRINT, 'Respiration'
;PRINT, TRANSPOSE(WAEres)
;PRINT, 'Respiration%'
;energyNZ = where(energy_gained >0.)
;PRINT, (WAEres[energyNZ])/energy_gained[energyNZ]

;PRINT, 'Egestion'
;PRINT, Eges
;PRINT, 'Excretion'
;PRINT, Exc
;PRINT, 'SDA'
;PRINT, S
;PRINT, 'energy_loss'
;PRINT, (energy_loss)

;PRINT, 'energy_change'
;PRINT, (energy_change)
;PRINT, 'LENGTH'
;PRINT, TRANSPOSE(LENGTH)
;PRINT, 'WAE[1:4, *]'
;PRINT, WAE[1:4, *]
;PRINT, 'pot_stor'
;PRINT, TRANSPOSE(pot_stor)
;;PRINT, 'PROPORTIONAL CHNAGE IN ENERGY',(energy_change / stor_energy) 
;PRINT, 'new_stor'
;PRINT, new_stor

;PRINT, 'struc'
;PRINT, transpose(struc)
;PRINT, 'new_struc'
;PRINT, new_struc
;PRINT, 'new_weight'
;PRINT, new_weight 
;PRINT, 'new_length'
;PRINT, new_length
;PRINT, 'growth_length'
;PRINT, new_length - transpose(length)
;PRINT, 'growth_weight'
;PRINT, new_weight - transpose(weight)

;PRINT, NpopYP 
;PRINT, NpopWAE 
;PRINT, NpopRAS
;PRINT, NpopEMS 
;PRINT, NpopROG

GrowthAttribute = FLTARR(6, nWAE)
GrowthAttribute[0, *] = new_weight
GrowthAttribute[1, *] = new_length
GrowthAttribute[2, *] = new_struc
GrowthAttribute[3, *] = new_stor
GrowthAttribute[4, *] = new_length - transpose(length)
GrowthAttribute[5, *] = new_weight - transpose(weight)
;PRINT, GrowthAttribute 

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'WAEgrowth Ends Here for DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
RETURN, GrowthAttribute; TUEN OFF WHEN TESTING
END