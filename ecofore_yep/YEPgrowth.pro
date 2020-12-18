FUNCTION YEPgrowth, length, weight, stor, struc, YPcmx, consumption, YEPres, Temp, nYP, ts, iday, ihour, iTime
;function to grow larval yellow perch in both storage and structure tissue

PRINT, 'YEPgrowth Begins Here'
tstart = SYSTIME(/seconds)

m = 9; a number of prey types
; energy density of the prey (j/g wet)
EDprey = FLTARR(m, nYP)
EDprey[0, *] = 1674.0 ;j/g- rotifers assumed value from Hewett and Stewart 1989
EDprey[1, *] = RANDOMU(seed, nYP)*(MAX(3684.) - MIN(1900.)) + MIN(1900.);2792.0 ;j/g- copepoda 1900-3684
EDprey[2, *] = RANDOMU(seed, nYP)*(MAX(2746.) - MIN(2281.)) + MIN(2281.);2513.5 ;j/g- cladocera 2281-2746
EDprey[3, *] = RANDOMU(seed, nYP)*(MAX(2478.) - MIN(1047.)) + MIN(1047.);1762.5 ;j/g- chironomidae 1047-2478
EDprey[4, *] = 1674.0 ;j/g- bythotrephe 1674 Lantry and Stewart 1993
EDprey[5, *] = RANDOMU(seed, nYP)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[6, *] = RANDOMU(seed, nYP)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[7, *] = RANDOMU(seed, nYP)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
EDprey[8, *] = RANDOMU(seed, nYP)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596


; joules of prey consumed per time step
ConsJ = FLTARR(m, nYP)
ConsJ[0, *] = consumption[0, *] * EDprey[0, *] ;converts consumption to J/ts
ConsJ[1, *] = consumption[1, *] * EDprey[1, *] ;converts consumption to J/ts
ConsJ[2, *] = consumption[2, *] * EDprey[2, *] ;converts consumption to J/ts
ConsJ[3, *] = consumption[3, *] * EDprey[3, *] ;converts consumption to J/ts
ConsJ[4, *] = consumption[4, *] * EDprey[4, *] ;converts consumption to J/ts
ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/ts
ConsJ[6, *] = consumption[6, *] * EDprey[6, *] ;converts consumption to J/ts
ConsJ[7, *] = consumption[7, *] * EDprey[7, *] ;converts consumption to J/ts
ConsJ[8, *] = consumption[8, *] * EDprey[8, *] ;converts consumption to J/ts

consJtot = FLTARR(nYP)
consJtot = (consJ[0,*] + consJ[1,*] + consJ[2,*] + consJ[3,*] + consJ[4,*] + consJ[5,*] $
            + consJ[6,*] + consJ[7,*] + consJ[8,*])
consJtot = TRANSPOSE(consJtot)


; parameter values for energy loss
FA = FLTARR(nYP)
UA = FLTARR(nYP)
SDA = FLTARR(nYP)
alength = FLTARR(nYP)
bLength = FLTARR(nYP)
Eges = FLTARR(nYP)
Exc = FLTARR(nYP)

; Larvae----------------------------------------------------------------------------------------------
TL = WHERE(length LT 20.0, TLcount, complement = TLL, ncomplement = TLLcount)
IF (TLcount GT 0.0) THEN BEGIN
  PRINT, 'Number of fish <20mm =', TLcount 
  ;values are for larval yellow perch
  ; egestion 
  FA[TL] = 0.15
  ; Excretion
  UA[TL] = 0.15
  ; Specific dynamic action
  SDA[TL] = 0.15
  ;alength[TL] = 45.9; W-L parameters from Rose et al. 1999
  ;bLength[TL] = 0.33; W-L parameters
  
  Eges[TL] = FA[TL] * ((ConsJtot[TL])) ;calculate egestion -> Make temp-dependent function??? 
  Exc[TL] = UA[TL] * (ConsJtot[TL] - Eges[TL]) ;calculate excretion
ENDIF 
;-----------------------------------------------------------------------------------------------------

; Juvenile and adult---------------------------------------------------------------------------------
IF (TLLcount GT 0.0) THEN BEGIN 
  pvalue = (consumption[0, TLL] + consumption[1, TLL] + consumption[2, TLL] + consumption[3, TLL]+ consumption[4, TLL] $
  + consumption[5, TLL] + consumption[6, TLL] + consumption[7, TLL] + consumption[8, TLL]) / YPcmx[TLL] * ts / 24.0 / 60.0 
  ;PRINT, 'pvalue'
  ;PRINT, pvalue
  PRINT, 'Number of fish >20mm =', TLLcount
  ;values are for juvenile and adult yellow perch
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
  ;alength[TLL] = 39.1; W-L parameters from Rose et al. 1999
  ;bLength[TLL] = 0.33; W-L parameters
  
  Eges[TLL] = FA[TLL] * Temp[TLL]^FB * EXP(FG * pvalue) * ((ConsJtot[TLL])) ;calculate egestion -> Make temp-dependent function 
  Exc[TLL] = UA[TLL] * Temp[TLL]^FB * EXP(FG * pvalue) * (ConsJtot[TLL] - Eges[TLL]) ;calculate excretion
ENDIF
;-----------------------------------------------------------------------------------------------------
S = SDA * (ConsJtot - Eges) ; SDA


; energy values assigned for storage and structure in J/g
stor_energy = 8000.0
struc_energy = 2000.0
frac = stor_energy / (stor_energy + struc_energy);fraction to storage energy

OptRho = (1.2*0.0912 * ALOG(length) + 0.128*1.2);+rhos ;(based on energy data from Hanson 1997$
;and seasonal genetic component from rho function)
Opt_Wt = OptRho * weight ;determines the percent weight that should be storage
percent_stor = OptRho * frac
percent_struc = (1.0 - OptRho) * (1.0 - frac)

Energy_loss = TRANSPOSE(YEPres + Eges + Exc + S) ;determine total energy lost in J/ts
Energy_gained = TRANSPOSE(ConsJtot) ;energy consumed in J/ts
energy_change = (energy_gained - energy_loss) ;energy available for growth J/ts
pot_stor =  stor + (energy_change / stor_energy) 


; Determine change in time-step growth with constraint on proportional weights
nstor = FLTARR(nYP)
nstruc = FLTARR(nYP)
nstr = FLTARR(nYP)
nstrc = FLTARR(nYP)
nlength = FLTARR(nYP)
new_stor = FLTARR(nYP)
new_struc = FLTARR(nYP)
New_weight = FLTARR(nYP)
Pot_length = FLTARR(nYP)
New_length = FLTARR(nYP)

ec = WHERE(energy_change GT 0.0, eccount, complement = ecc, ncomplement = ecccount); ec = + energy gain
IF(eccount GT 0.0) THEN BEGIN
  a = WHERE(stor GT opt_wt, acount, complement = aa, ncomplement = aacount)
    IF (acount GT 0.0) THEN BEGIN; if storage_weight is greater than optimal rho
            ;add to storage and structural tissue
            nstor[a] = stor[a] + (percent_stor[a] / (percent_stor[a] + percent_struc[a])) * (energy_change[a] / stor_energy[a])
            nstruc[a] = struc[a] + (percent_struc[a] / (percent_stor[a] + percent_struc[a])) * (energy_change[a] / struc_energy[a])
    ENDIF
    
    IF (aacount GT 0.0) THEN BEGIN; if storage weight is less than optimal storage weight
        b = WHERE(Pot_stor LT opt_wt, bcount, complement = bb, ncomplement = bbcount)
        IF(bcount GT 0.0) THEN BEGIN; if potential storage is less than optimal storage
            nstr[b] = pot_stor[b]
            nstrc[b] = struc[b]
        ENDIF
        
        IF (bbcount GT 0.0) THEN BEGIN; if the potential storage is greater than optimal storage
            nstr[bb] = stor[bb] + (percent_stor[bb] / (percent_stor[bb] + percent_struc[bb])) * (energy_change[bb]/stor_energy[bb])
            nstrc[bb] = struc[bb] + (percent_struc[bb] / (percent_stor[bb] + percent_struc[bb])) * (energy_change[bb]/struc_energy[bb])
        ENDIF
        
        nstor[aa] = nstr[aa]
        nstruc[aa] = nstrc[aa]
     ENDIF
     
     new_stor[ec] = nstor[ec]
     new_struc[ec] = nstruc[ec]
     new_weight[ec] = nstor[ec] + nstruc[ec]
ENDIF

IF(ecccount GT 0.0) THEN BEGIN; ecc = -energy gain
   ;individual loses ENERGY
   new_stor[ecc] = pot_stor[ecc]
   storNZ = WHERE(new_stor GT 0.,storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
   IF storZcount GT 0. THEN new_stor[storZ] = 0.
   new_struc[ecc] = struc[ecc]
   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
ENDIF


;Determine time-step growth in length
g = WHERE(New_Struc GT struc, gcount, complement = gg, ncomplement = ggcount)
IF (gcount GT 0.0) THEN BEGIN; when new structural weight is larger than the current weight...   
   Pot_length[g] =  58.089 * (New_Struc[g]^0.3521); aLength * (New_weight[g]^bLength); weight-length equation from Rose et al. 1999 
   pl = WHERE(pot_length[g] GT length[g], plcount, complement = ppl, ncomplement = pplcount)
   IF(plcount GT 0.0) THEN nlength[g[pl]] = pot_length[g[pl]]; if potential length is greater than the current length
   IF(pplcount GT 0.0) THEN nlength[g[ppl]] = length[g[ppl]]; if potential length is less than the current length
   new_length[g] = nlength[g]
ENDIF

IF (ggcount GT 0.0) THEN new_length[gg] = length[gg]; when new structural weight is less than the current weight...

;PRINT, 'Digested prey (g)'
;PRINT, consumption[0:8, *]
;PRINT, 'Energy consumption (ConJ, J)'
;PRINT, ConsJ
;PRINT, 'consjtot (J)'
;PRINT, consJtot
;PRINT, 'Opt_wt'
;PRINT, TRANSPOSE(Opt_wt)
;PRINT, 'percent_stor'
;PRINT, TRANSPOSE(percent_stor)
;PRINT, 'percent_struc'
;PRINT, TRANSPOSE(percent_struc)
;PRINT, 'Respiration'
;PRINT, TRANSPOSE(YEPres)
;PRINT, 'Egestion'
;PRINT, Eges
;PRINT, 'Excretion'
;PRINT, Exc
;PRINT, 'SDA'
;PRINT, S
;PRINT, 'energy_change'
;PRINT, TRANSPOSE(energy_change)
;PRINT, 'pot_stor'
;PRINT, TRANSPOSE(pot_stor)
;
;PRINT, 'new_stor'
;PRINT, new_stor
;PRINT, 'new_struc'
;PRINT, new_struc
;PRINT, 'new_weight'
;PRINT, new_weight 
;PRINT, 'new_length'
;PRINT, new_length
;PRINT, 'length'
;PRINT, TRANSPOSE(length)

;PRINT, 'OptRho'
;PRINT, TRANSPOSE(OptRho)
;
;PRINT, 'growth_length'
;PRINT, new_length - transpose(length)
;PRINT, 'growth_weight'
;PRINT, new_weight - transpose(weight)
;PRINT, 'growth_struc'
;PRINT, new_struc - transpose(struc)
;PRINT, 'growth_stor'
;PRINT, new_stor - transpose(stor)
;
;print, transpose(YPpbio[5, 0:100]); yellow perch abundance      
;print, transpose(YPpbio[9, 0:100]); emerald shiner abundance
;print, transpose(YPpbio[13, 0:100]); rainbow smelt abundance
;print, transpose(YPpbio[17, 0:100]); round goby abundance

GrowthAttribute = FLTARR(6, nYP)
GrowthAttribute[0, *] = new_weight
GrowthAttribute[1, *] = new_length
GrowthAttribute[2, *] = new_struc
GrowthAttribute[3, *] = new_stor
GrowthAttribute[4, *] = new_length - TRANSPOSE(length)
GrowthAttribute[5, *] = new_weight - TRANSPOSE(weight)
;PRINT, GrowthAttribute

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'YEPgrowth Ends Here for DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
RETURN, GrowthAttribute; TUEN OFF WHEN TESTING; TURN ON WHEN RUNNING A FULL MODEL
END