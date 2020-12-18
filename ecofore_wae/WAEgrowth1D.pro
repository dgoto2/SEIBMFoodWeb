FUNCTION WAEgrowth1D, length, weight, stor, struc, WAEcmx, consumption, WAEres, Temp, nWAE, ts, iday, ihour, iTime
; Function to determine growth of walleye in both storage and structure tissue

PRINT, 'WAEgrowth1D Begins Here'
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


; Convert the amount of consumed prey to energy
ConsJ = FLTARR(m, nWAE) ;joules of prey consumed per time step
ConsJ[0, *] = consumption[0, *] * EDprey[0, *] ;converts consumption to J/ts
ConsJ[1, *] = consumption[1, *] * EDprey[1, *] ;converts consumption to J/ts
ConsJ[2, *] = consumption[2, *] * EDprey[2, *] ;converts consumption to J/ts
ConsJ[3, *] = consumption[3, *] * EDprey[3, *] ;converts consumption to J/ts
ConsJ[4, *] = consumption[4, *] * EDprey[4, *] ;converts consumption to J/ts
ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/ts
ConsJ[6, *] = consumption[6, *] * EDprey[6, *] ;converts consumption to J/ts
ConsJ[7, *] = consumption[7, *] * EDprey[7, *] ;converts consumption to J/ts
ConsJ[8, *] = consumption[8, *] * EDprey[8, *] ;converts consumption to J/ts
ConsJ[9, *] = consumption[9, *] * EDprey[9, *] ;converts consumption to J/ts

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
  ;alength[TL] = 49.0; W-L parameters from Rose et al. 1999
  ;bLength[TL] = 0.31; W-L parameters
  
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
;  alength[TLL] = 49.0; W-L parameters from Rose et al. 1999
;  bLength[TLL] = 0.3; W-L parameters

  Eges[TLL] = FA[TLL] * Temp[TLL]^FB * EXP(FG * Pvalue[TLL]) * ((ConsJtot[TLL])) ;calculate egestion -> Make temp-dependent function 
  Exc[TLL] = UA[TLL] * Temp[TLL]^FB * EXP(FG * Pvalue[TLL]) * (ConsJtot[TLL] - Eges[TLL]) ;calculate excretion
ENDIF
;-----------------------------------------------------------------------------------------------------
S = SDA * (ConsJtot - Eges) ;calculation SDA


; energy values assigned for storage and structure in J/g for walleye
stor_energy = 8000.0
struc_energy = 2000.0
frac = stor_energy / (stor_energy + struc_energy); fraction to storage = 0.8

Optrho = (1.*0.1298 * ALOG(length) - 0.0853/1.);+rhos ;(based on energy data from Hanson 1997$
                                    ;and seasonal genetic component from rho function
Opt_wt = Optrho * Weight ;determines optimal weight allocated as storage
percent_stor = Optrho * frac
percent_struc = (1.0 - optrho) * (1.0 - frac)

Energy_loss = TRANSPOSE(WAEres) + Eges + Exc + S ;determine total energy lost in J/ts
Energy_gained = (ConsJtot) ;energy consumed in J/ts
energy_change = (energy_gained - energy_loss) ;energy available for growth J/ts
pot_stor =  stor + (energy_change / stor_energy) 

; Determine change in growth with constraint on proportional weight
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

EC = WHERE(energy_change GT 0.0, ECcount, complement = ECc, ncomplement = ECccount); ec = energy gain
IF(ECcount GT 0.0) THEN BEGIN; WHEN THERE IS +ENERGY GAIN
  A = WHERE(stor GT opt_wt, Acount, complement = AA, ncomplement = AAcount)
    IF (Acount GT 0.0) THEN BEGIN; IF storage_weight is greater than optimal storage weight
      ; add to storage and structural tissue
      Nstor[A] = stor[A] + (percent_stor[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / stor_energy[A])
      Nstruc[A] = struc[A] + (percent_struc[A] / (percent_stor[A] + percent_struc[A])) * (energy_change[A] / struc_energy[A])
    ENDIF    
    
    IF (AAcount GT 0.0) THEN BEGIN; IF storage weight is less than optimal storage weight
        B = WHERE(Pot_stor LT opt_wt, Bcount, complement = BB, ncomplement = BBcount)
        IF(bcount GT 0.0) THEN BEGIN; IF potential storage is less than optimal storage
            nstr[B] = pot_stor[B]
            nstrc[B] = struc[B]
        ENDIF
        
        IF (BBcount GT 0.0) THEN BEGIN; IF the potential storage is greater than optimal storage
            nstr[BB] = stor[BB] + (percent_stor[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/stor_energy[BB])
            nstrc[BB] = struc[BB] + (percent_struc[BB] / (percent_stor[BB] + percent_struc[BB])) * (energy_change[BB]/struc_energy[BB])
        ENDIF
        
        nstor[AA] = nstr[AA]
        nstruc[AA] = nstrc[AA]
     ENDIF
     
 new_stor[EC] = nstor[EC]
 new_struc[EC] = nstruc[EC]
 new_weight[EC] = nstor[EC] + nstruc[EC]
ENDIF

IF(ECccount GT 0.0) THEN BEGIN; WHEN THERE IS ENERGY LOSS
; ecc = -energy gain
   new_stor[ecc] = pot_stor[ecc]
   storNZ = WHERE(new_stor GT 0., storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
   IF storZcount GT 0. THEN new_stor[storZ] = 0.
   new_struc[ecc] = struc[ecc]
   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
ENDIF

; Determine time-step growth in length
G = WHERE(new_struc GT struc, gcount, complement = GG, ncomplement = GGcount)
IF (Gcount GT 0.0) THEN BEGIN
   Pot_length[G] = 59.761 * (New_struc[G]^0.3401);aLength * (New_weight[g]^bLength); weight-length equation from Rose et al. 1999 
   pl = WHERE(pot_length[g] GT length[g], plcount, complement = ppl, ncomplement = pplcount)
   IF(plcount GT 0.0) THEN nlength[g[pl]] = pot_length[g[pl]]; if potential length is greater than the current length
   IF(pplcount GT 0.0) THEN nlength[g[ppl]] = length[g[ppl]]; if potential length is less than the current length
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
PRINT, 'WAEgrowth1D Ends Here for DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
RETURN, GrowthAttribute; TUEN OFF WHEN TESTING
END