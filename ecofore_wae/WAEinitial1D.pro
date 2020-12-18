FUNCTION WAEinitial1D, Npop, nWAE, TotBenBio, NewInput, nGridcell
;this function initializes the data for walleye

PRINT, 'WAEinitial1D Starts Here'


WAE = FLTARR(70, nWAE)
; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-7
; set the number of individuals within an age category to frequency dist from Lake Erie
; randomly assign ages 0-7 based on a uniform distribution
SEX = ROUND(RANDOMU(seed, nWAE)) ;randomly assign sex
AGE = ROUND(RANDOMU(seed, nWAE) * (MAX(7) - MIN(0)) + MIN(0))
WAE[5, *] = SEX; MALE = 0 AND FEMALE = 1
WAE[6, *] = AGE; age


; determine the number of SIs at age and the total number of individuals represented by age
AgeProp = FLTARR(8)
; The following is based on average values of Lake Erie field data between 87 and 05
AgeProp[0] = 0.355; 0.178; 0.503
AgeProp[1] = 0.164; 0.116; 0.171
AgeProp[2] = 0.166; 0.501; 0.145
AgeProp[3] = 0.109; 0.0025; 0.122
AgeProp[4] = 0.067; 0.135; 0.042
AgeProp[5] = 0.052; 0.0092; 0.013
AgeProp[6] = 0.033; 0.040; 0.0032
AgeProp[7] = 0.054; 0.017; 0.0008
;PRINT, TOTAL(AGEPROP[*])

no_inds = FLTARR(nWAE)
y0 = WHERE(age EQ 0, y0count)
IF y0count GT 0. THEN no_inds[y0] = round(Npop * AgeProp[0])/y0count
y1 = WHERE(age EQ 1, y1count)
IF y1count GT 0. THEN no_inds[y1] = round(Npop * AgeProp[1])/y1count
y2 = WHERE(age EQ 2, y2count)
IF y2count GT 0. THEN no_inds[y2] = round(Npop * AgeProp[2])/y2count
y3 = WHERE(age EQ 3, y3count)
IF y3count GT 0. THEN no_inds[y3] = round(Npop * AgeProp[3])/y3count 
y4 = WHERE(age EQ 4, y4count)
IF y4count GT 0. THEN no_inds[y4] = round(Npop * AgeProp[4])/y4count
y5 = WHERE(age EQ 5, y5count)
IF y5count GT 0. THEN no_inds[y5] = round(Npop * AgeProp[5])/y5count
y6 = WHERE(age EQ 6, y6count)
IF y6count GT 0. THEN no_inds[y6] = round(Npop * AgeProp[6])/y6count
y7 = WHERE(age EQ 7, y7count)
IF y7count GT 0. THEN no_inds[y7] = round(Npop * AgeProp[7])/y7count

WAE[0, *] = no_inds;

; Lake Erie surface area = ~25745km2 
; central basin = 3875*4km2 = ~15500km2
; 1 ha = 0.01km2
; => 1550000ha (1 ha = 0.01km2)
; In 2005,         YOY -> 10710000D
;                  YAO -> 6960000D   
;                 Age2 -> 30129000D           
;                 Age3 -> 150000D
;                 Age4 -> 8138000D
;                 Age5 -> 553000D
;                 Age6 -> 2430000D
;                 Age7+ -> 1028000D 

                
;*****NEED LAKE ERIE AGE-SPECIFIC LENGTHS**********
; von bertalanffy params
; from He et al. 2005 Journal of Fish Biology vol 66 pp1459-1470 for walleye
Linf = FLTARR(nWAE)
K = FLTARR(nWAE)
t0 = FLTARR(nWAE)

Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF malecount GT 0. THEN BEGIN
  ; males
  Linf[male] = 438.3; RANDOMU(seed, malecount) * (MAX(438.3) - MIN(424.8)) + MIN(424.8)
  K[male] = 0.426; RANDOMU(seed, malecount) * (MAX(0.426) - MIN(0.374)) + MIN(0.374)
  t0[male] = -0.107; RANDOMU(seed, malecount) * (MAX(-0.107) - MIN(-0.271)) + MIN(-0.271)
ENDIF

IF femalecount GT 0. THEN BEGIN
  ; females
  Linf[female] = 488.6; RANDOMU(seed, femalecount) * (MAX(488.6) - MIN(466.8)) + MIN(466.8)
  K[female] = 0.368; RANDOMU(seed, femalecount) * (MAX(0.368) - MIN(0.312)) + MIN(0.312)
  t0[female] = -0.162; RANDOMU(seed, femalecount) * (MAX(-0.162) - MIN(-0.366)) + MIN(-0.366)
ENDIF

LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN BEGIN
;Length[LAG0] = RANDOMU(seed, LAG0count) * (MAX(21.) - MIN(20.5)) + MIN(20.5)
  Linf[LAG0] = 488.6; RANDOMU(seed, femalecount) * (MAX(488.6) - MIN(466.8)) + MIN(466.8)
  K[LAG0] = 0.368; RANDOMU(seed, femalecount) * (MAX(0.368) - MIN(0.312)) + MIN(0.312)
  t0[LAG0] = -0.162; RANDOMU(seed, femalecount) * (MAX(-0.162) - MIN(-0.366)) + MIN(-0.366)
ENDIF
LENGTH = FLTARR(nWAE)
Length[*] = Linf[*] * (1 - EXP(-K[*] * (AGE[*] - t0[*])))

;IntLength = 250.; initial length at the beginning of simulations
; 50-60mm in June from Madenjian et al., 1991. Ecological Apllications. 1(3) 280-288.
;length = IntLength + RANDOMN(seed, nWAE) * (0.2/6.6)*IntLength
; random numbers with mean 9.0 and SD 0.2 from Rose et al. 1999
WAE[1, *] = Length; in mm
;print, min(length)
;print, max(length)


; Assining weight, storage weight, structural weight
opt_rho = FLTARR(nWAE)
WAE[4,*]= 0.000006 * (WAE[1, *])^2.9393; structural weight
opt_rho[*]=(1.*0.1298 * ALOG((WAE[1, *])) - 0.0853/1.); optrho
;print, min(opt_rho)

; Don't allow opt_rho to drop below 0.2
cho = WHERE(opt_rho LT 0.2, count)
IF count GT 0 THEN opt_rho[cho] = 0.2
WAE[2, *] = (WAE[4, *] / (1 - opt_rho[*])); total weight
WAE[3, *] = WAE[2, *] - WAE[4, *] ; storage weight

WAE[61, *] = 0.0; daily cumulative growth in length
WAE[62, *] = 0.0; daily cumulative growth in weight


WAE[7, *] = 0.0 ; holds stomach content weight in g
WAE[60, *] = 0.0; GUT FULLNESS(%)

WAE[8, *] = 0.0 ; holds maximum stomach capacity in g
WAE[9, *] = 0.0 ; holds total amount consumed over the last 24 hours in g
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


;***Assigning hatch cell or initial location of fish***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
; Haching occurs in nearshore areas with depth < 15m
What = WHERE(newinput[10, 0L : nGridcell-1L] GT 4.0 AND newinput[9, 0L : nGridcell-1L] LE 29.0, count) 
;cells that can be used as hatching cells for walleye
;PRINT, 'What', What
;PRINT, 'count', count

;HatLoc = FLTARR(nWAE)
HatLoc = ROUND(RANDOMU(seed, nWAE) * (count - 1L))
; random number for all WAE SIs ranging from 0-# cells with depths less than 3m
;PRINT, 'HatLoc', HatLoc

Wenvir = newinput[*, What[HatLoc]]; x, y location based on depths less than 6m
;PRINT, 'Wenvir', Wenvir


; Environment for each  SI
WAE[10 : 14, *] = Wenvir[0 : 4, *]; 15 arrays from NewInputFiles
;10 = Fishenvir[0,*]= Xl
;11 = Fishenvir[1,*]= yl
;12 = Fishenvir[2,*]= zl
;13 = Fishenvir[3,*]= GridIDxy; horizontal grid ID 
;14 = Fishenvir[4,*]= GridNo; unique 3D ID

; Within-cell proportional coordinates from movements
WAE[37, *] = 0.0; total distance moved within each cell in ts ->may be used to estimate movement-based activity cost

WAE[39, *] = 0.0; Within-cell coordinate for x
WAE[40, *] = 0.0; Within-cell coordinate for y
WAE[41, *] = 0.0; Within-cell coordinate for z


;WAE[15 : 18, *] = Wenvir[5 : 8, *]/WAE[0, *]
WAE[38, *] = Wenvir[15, *]; settling carbon, g/m2 

WAE[15, *] = Wenvir[5, *]; / (WAE[2, *] * WAE[0, *]);15 = Fishenvir[5,*]= microzooplankton
WAE[16, *] = Wenvir[6, *]; / (WAE[2, *] * WAE[0, *]);16 = Fishenvir[6,*]= mid-sized mesozooplankton
WAE[17, *] = Wenvir[7, *]; / (WAE[2, *] * WAE[0, *]);17 = Fishenvir[7,*]= large mesozooplankton
WAE[18, *] = TotBenBio[HatLoc]; / (WAE[2, *] * WAE[0, *]);18 = Fishenvir[8,*]= chironomids


WAE[19 : 24, *] = Wenvir[9 : 14, *]
;19 = Fishenvir[9,*]= temperature
;20 = Fishenvir[10,*]= DO
;21 = Fishenvir[11,*]= light
;22 = Fishenvir[12,*]= current i
;23 = Fishenvir[13,*]= current j
;24 = Fishenvir[14,*]= current w


;***Assining hatch temp***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
ahd = 11.0 * RANDOMU(seed, nWAE)
h = WHERE(ahd LT 7.0, hcount)
IF (hcount GT 0) THEN ahd[h] = 7.0
WAE[25, *] = ahd


; Acclimation
WAE[26, *] = WAE[19, *]; temperature the fish is acclimatized for consumption
WAE[27, *] = WAE[19, *]; temperature the fish is acclimatized for respiration
 
WAE[28, *] = WAE[20, *]; DOa ;DO the fish is acclimatized for consumption
WAE[29, *] = WAE[20, *]; DOa ;DO the fish is acclimatized for respiration 


WAE[30, *] = 0.0; undigested rotifers in the stomach
WAE[31, *] = 0.0; undigested copopods in the stomach
WAE[32, *] = 0.0; undigested cladocerans in the stomach
WAE[33, *] = 0.0; undigested chironomids in the stomach
WAE[34, *] = 0.0; undigested bythotrephes in the stomach
WAE[35, *] = 0.0; undigested yellow perch in the stomach
WAE[45, *] = 0.0; undigested emerald shiner in the stomach
WAE[46, *] = 0.0; undigested rainbow smelt in the stomach
WAE[47, *] = 0.0; undigested round goby in the stomach
WAE[48, *] = 0.0; undigested walleye in the stomach


WAE[36, *] = 0.0; cumulative probability for suffocation mortality
WAE[64, *] = 0.0; background predation mortality 
WAE[65, *] = 0.0; starvation mortality
WAE[66, *] = 0.0; suffocation mortality


WAE[59, *] = 0.0; RESPIRATION RATE
WAE[63, *] = 0.0; O2 debt


WAE[68, *] = 0.0; month
WAE[42, *] = 0.0; day
WAE[43, *] = 0.0; hour
WAE[44, *] = 0.0; minutes

WAE[67, *] = FINDGEN(nWAE)+1L; Fish SI ID
;PRINT, 'WAE'
;PRINT, WAE[0:6, *]

PRINT, 'WAEinitial1D Ends Here'
RETURN, WAE; TURN OFF WHEN TESTING
END