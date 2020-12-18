FUNCTION RASgrowth, length, weight, stor, struc, RAScmx, consumption, RASres, Temp, nRAS, ts, iday, ihour, iTime
; Function to determine growth in both storage and structure tissue

PRINT, 'RASgrowth Begins Here'

m = 6; a number of prey types

; energy density of the prey (j/g wet)
EDprey = FLTARR(m, nRAS)
EDprey[0, *] = 1674.0 ;j/g- rotifers assumed value from Hewett and Stewart 1989
EDprey[1, *] = RANDOMU(seed, nRAS)*(MAX(3684.) - MIN(1900.)) + MIN(1900.);2792.0 ;j/g- copepoda 1900-3684
EDprey[2, *] = RANDOMU(seed, nRAS)*(MAX(2746.) - MIN(2281.)) + MIN(2281.);2513.5 ;j/g- cladocera 2281-2746
EDprey[3, *] = RANDOMU(seed, nRAS)*(MAX(2478.) - MIN(1047.)) + MIN(1047.);1762.5 ;j/g- chironomidae 1047-2478
EDprey[4, *] = 1674.0 ;j/g- bythotrephe 1674 Lantry and Stewart 1993
EDprey[5, *] = RANDOMU(seed, nRAS)*(MAX(4596.) - MIN(2800.)) + MIN(2800.);3698.0 ;j/g- larval fish 2800-4596
;PRINT, 'RAS New Digested prey item (DigestedFood, g)'
;PRINT, total(consumption[0:5, 0:100],1)

;joules of prey consumed per time step
ConsJ = FLTARR(m, nRAS) 
ConsJ[0, *] = consumption[0, *] * EDprey[0, *] ;converts consumption to J/ts
ConsJ[1, *] = consumption[1, *] * EDprey[1, *] ;converts consumption to J/ts
ConsJ[2, *] = consumption[2, *] * EDprey[2, *] ;converts consumption to J/ts
ConsJ[3, *] = consumption[3, *] * EDprey[3, *] ;converts consumption to J/ts
ConsJ[4, *] = consumption[4, *] * EDprey[4, *] ;converts consumption to J/ts
ConsJ[5, *] = consumption[5, *] * EDprey[5, *] ;converts consumption to J/ts

consJtot = (consJ[0,*] + consJ[1,*] + consJ[2,*] + consJ[3,*] + consJ[4,*] + consJ[5,*])
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:200]
;consJtot = TRANSPOSE(consJtot)
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:500]


; parameter values for energy loss
; Larvae /juvinile/ adult
;values are for smelt
; egestion 
FA = 0.16
; Excretion
UA = 0.1
; Specific dynamic action
SDA = 0.175

Eges = FLTARR(nRAS)
Exc = FLTARR(nRAS)
S = FLTARR(nRAS)
Eges = FA * (ConsJtot) ;calculate egestion -> Make temp-dependent function??? 
Exc = UA * (ConsJtot - Eges) ;calculate excretion
S = SDA * (ConsJtot - Eges) ;calculation SDA

;PRINT, 'RAScmx =', RAScmx
;pvalue = (consumption[0,*] + consumption[1,*] + consumption[2,*] + consumption[3,*]+ consumption[4,*] $
;+ consumption[5,*]) / RAScmx / 24.0 / 60.0 * ts
;PRINT, 'pvalue =', pvalue


; determine growth
; energy values assigned for storage and structure in J/g
;stor_energy = 7500.0
;struc_energy = 1000.0
stor_energy = 8000.0
struc_energy = 2000.0
frac = stor_energy / (stor_energy + struc_energy); fraction to storage

optrho = 1.01 * 0.0912 * ALOG(length) + 0.128 * 0.9;+rhos ;(based on energy data from Hanson 1997$
;and seasonal genetic component from rho function
opt_wt = optrho * weight ;determines the percent weight that should be storage
percent_stor = Optrho * frac
percent_struc = (1.0 - optrho) * (1.0 - frac)

;PRINT, 'Respiration'
;PRINT, RASres[0:100]
Energy_loss = TRANSPOSE(RASres + Eges + Exc + S) ;determine total energy lost in J/6min
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:100]
Energy_gained = TRANSPOSE(ConsJtot) ;energy consumed in J/6min
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:500]
energy_change = (energy_gained - energy_loss) ;energy available for growth J/6min
pot_stor =  stor + (energy_change / stor_energy) 


; Hold all the amount of food consumed per time step and places it all in storage
nstor = FLTARR(nRAS)
nstruc = FLTARR(nRAS)
nstr = FLTARR(nRAS)
nstrc = FLTARR(nRAS)
nlength = FLTARR(nRAS)
new_stor = FLTARR(nRAS)
new_struc = FLTARR(nRAS)
New_weight = FLTARR(nRAS)
Pot_length = FLTARR(nRAS)
New_length = FLTARR(nRAS)

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

IF(ecccount GT 0.0) THEN BEGIN; ecc = energy loss
   ;individual loses 
   new_stor[ecc] = pot_stor[ecc]
   storNZ = WHERE(new_stor GT 0.,storNZcount, complement = storZ, ncomplement = storZcount)
   IF storNZcount GT 0. THEN new_stor[storNZ] = new_stor[storNZ]
   IF storZcount GT 0. THEN new_stor[storZ] = 0.
   new_struc[ecc] = struc[ecc]
   new_weight[ecc] = new_stor[ecc] + new_struc[ecc]
ENDIF


; Determine time-step growth in length
g = WHERE(new_struc GT struc, gcount, complement = gg, ncomplement = ggcount)
IF (gcount GT 0.0) THEN BEGIN
   Pot_length[g] = 1.18*59.761 * (New_struc[g]^0.3401*1.02) ; weight-length equation from Hartman and Margraf, 1992, TAFS
   pl = WHERE(pot_length[g] GT length[g], plcount, complement = ppl, ncomplement = pplcount)
   IF(plcount GT 0.0) THEN nlength[g[pl]] = pot_length[g[pl]]
   IF(pplcount GT 0.0) THEN nlength[g[ppl]] = length[g[ppl]]
   new_length[g] = nlength[g]
ENDIF

IF (ggcount GT 0.0) THEN new_length[gg] = length[gg]

;PRINT, 'consumption (g)'
;PRINT, consumption
;PRINT, 'ConsJ (J)'
;PRINT, ConsJ
;PRINT, 'consjtot (J)'
;PRINT, consJtot[0:200]

;PRINT, 'Respiration'
;PRINT, RASres
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

;PRINT, 'growth_length'
;PRINT, new_length - transpose(length)
;PRINT, 'growth_weight'
;PRINT, new_weight - transpose(weight)

GrowthAttribute = FLTARR(6, nRAS)
GrowthAttribute[0, *] = new_weight
GrowthAttribute[1, *] = new_length
GrowthAttribute[2, *] = new_struc
GrowthAttribute[3, *] = new_stor
GrowthAttribute[4, *] = new_length - transpose(length)
GrowthAttribute[5, *] = new_weight - transpose(weight)
;PRINT, GrowthAttribute 

PRINT, 'RASgrowth Ends Here for DAY', iday + 1L, '     HOUR', ihour + 1L, '     MINUTE', (iTime + 1L)*ts
RETURN, GrowthAttribute
END