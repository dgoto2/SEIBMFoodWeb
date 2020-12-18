FUNCTION YEPinitial, Npop, nYP, TotBenBio, NewInput, nGridcell
; this function initializes yellow perch IBM

PRINT, 'YEPinitial Begins Here'
tstart = SYSTIME(/seconds)

YP = FLTARR(70, nYP)
; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-6
; set the number of individuals within an age category to frequency dist from Lake Erie field data
; randomly assign ages 0-6 based on a uniform distribution
SEX = ROUND(RANDOMU(seed, nYP)) ;randomly assign sex
AGE = ROUND(RANDOMU(seed, nYP) * (MAX(6) - MIN(0)) + MIN(0))
YP[5, *] = SEX ; MALE = 0 AND FEMALE = 1
YP[6, *] = AGE ; holds age


; determine the number of SIs at age and the total number of individuals represented by age
AgeProp = FLTARR(8)
; The following is based on average values of Lake Erie field data between 87 and 05
AgeProp[0] = 0.284; 0.303; 0.503
AgeProp[1] = 0.284; 0.231; 0.171
AgeProp[2] = 0.191; 0.358; 0.145
AgeProp[3] = 0.124; 0.0095; 0.122
AgeProp[4] = 0.066; 0.069; 0.042
AgeProp[5] = 0.028; 0.0048; 0.013
AgeProp[6] = 0.023; 0.0243; 0.0032
;AgeProp[7] = 0.
;PRINT, TOTAL(AGEPROP[*])

no_inds = FLTARR(nYP)
y0 = WHERE(age EQ 0, y0count)
IF y0count GT 0. THEN no_inds[y0] = round(Npop * AgeProp[0])/y0count
y1 = WHERE(age eq 1, y1count)
IF y1count GT 0. THEN no_inds[y1] = round(Npop * AgeProp[1])/y1count
y2 = WHERE(age eq 2, y2count)
IF y2count GT 0. THEN no_inds[y2] = round(Npop * AgeProp[2])/y2count
y3 = WHERE(age eq 3, y3count)
IF y3count GT 0. THEN no_inds[y3] = round(Npop * AgeProp[3])/y3count 
y4 = WHERE(age eq 4, y4count)
IF y4count GT 0. THEN no_inds[y4] = round(Npop * AgeProp[4])/y4count
y5 = WHERE(age eq 5, y5count)
IF y5count GT 0. THEN no_inds[y5] = round(Npop * AgeProp[5])/y5count
y6 = WHERE(age eq 6, y6count)
IF y6count GT 0. THEN no_inds[y6] = round(Npop * AgeProp[6])/y6count
;y7 = WHERE(age eq 7, y7count)
;IF y7count GT 0. THEN no_inds[y7] = round(Npop * AgeProp[7])/y7count

YP[0, *] = no_inds;

; Lake Erie surface area = ~25745km2 
; central basin = 3875*4km2 = ~15500km2
; 1 ha = 0.01km2
; => 1550000ha (1 ha = 0.01km2)
; In 2005, 66.8/ha YOY -> 103540000D
;          50.7/ha YAO -> 78843333D   
;                 Age2 -> 122247000D           
;                 Age3 -> 3257000D
;                 Age4 -> 23600000D
;                 Age5 -> 1645000D
;                 Age6 -> 8300000D
          

;*****NEED LAKE ERIE AGE-SPECIFIC LENGTHS**********
; von bertalanffy params trawl data
; from Jackson et al. 2008 Fisheries Management and Ecology vol 15 pp107-118
Linf = FLTARR(nYP)
K = FLTARR(nYP)
t0 = FLTARR(nYP)

Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF malecount GT 0. THEN BEGIN
  ; males
  Linf[male] = 272.0
  K[male] = 0.184
  t0[male] = -2.45
ENDIF

IF femalecount GT 0. THEN BEGIN
  ; females
  Linf[female] = 307.0
  K[female] = 0.333
  t0[female] = 0.031
ENDIF

  LENGTH = FLTARR(nYP)
  Length[*] = Linf * (1 - EXP(-k * (AGE[*] - t0)))
  LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN Length[LAG0] = RANDOMU(seed, LAG0count) * (MAX(10.5) - MIN(9.5)) + MIN(9.5)
;IntLength = 19.6; initial length at the beginning of simulations
;length = IntLength + RANDOMN(seed, p) * (0.2/6.6)*IntLength
; random haching mean length 6.6 mm with SD 0.2 from Rose et al. 1999
YP[1, *] = Length; in mm


; Assining weight, storage weight, structural weight
opt_rho = FLTARR(nYP)
YP[4, *] = 0.00001 * (YP[1, *])^2.8403 ; structural weight
opt_rho[*] = (1.2*0.0912 * ALOG((YP[1, *])) + 0.128*1.2) ; optrho
;print, min(opt_rho)

; Don't allow opt_rho to drop below 0.3
cho = WHERE(opt_rho LT 0.3, count)
IF count GT 0 THEN opt_rho[cho] = 0.3
YP[2, *] = (YP[4, *] / (1 - opt_rho[*])); total weight
YP[3, *] = YP[2, *] - YP[4, *]; storage weight

YP[61, *] = 0.0; daily cumulative growth in length
YP[62, *] = 0.0; daily cumulative growth in weight


YP[7, *] = 0.0 ; holds stomach content weight in g
YP[60, *] = 0.0; gut fullness in %

YP[8, *] = 0.0 ; holds maximum stomach capacity in g
YP[9, *] = 0.0 ; holds total amount of food consumed over the last 24 hours in g
YP[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
YP[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
YP[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
YP[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
YP[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
YP[53, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
YP[54, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
YP[55, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
YP[56, *] = 0.0; total amount of round goby consumed over the last 24 hours in g


;***Assigning hatch cell or initial location of fish***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
; Haching occurs in nearshore areas with depth < 15m
Yhat = WHERE(newinput[10, 0L : nGridcell-1L] GT 4.0 AND newinput[9, 0L : nGridcell-1L] LE 29.0, count) 
; cells that can be used as hatching cells for yellow perch
;PRINT, 'Yhat', Yhat
;PRINT, 'count', count

;HatLoc = FLTARR(nYP)
HatLoc = ROUND(RANDOMU(seed, nYP) * (count - 1L))
; random number for all YEP SIs ranging from 0-# cells with depths
;PRINT, 'HatLoc', HatLoc

Yenvir = newinput[*, Yhat[HatLoc]]; x, y location based on depths
;PRINT, 'Yenvir', Yenvir


; Environment for each SI
YP[10 : 14, *] = Yenvir[0 : 4, *]; 15 arrays from NewInputFiles
;10 = Fishenvir[0,*]= Xl
;11 = Fishenvir[1,*]= yl
;12 = Fishenvir[2,*]= zl
;13 = Fishenvir[3,*]= GridIDxy; horizontal grid ID 
;14 = Fishenvir[4,*]= GridNo; unique 3D ID

; Within-cell proportional coordinates from movements
;->should be reset when fish move to the new cell
YP[37, *] = 0.0; total distance moved within each cell in ts -> may be used to estimate movement-based activity cost

YP[39, *] = 0.0; Within-cell coordinate for x
YP[40, *] = 0.0; Within-cell coordinate for y
YP[41, *] = 0.0; Within-cell coordinate for z


;YP[15 : 18, *] = Yenvir[5 : 8, *]/YP[0, *]
YP[38, *] = Yenvir[15, *]; settling carbon, g/m2; *****NEED TO CHANGE INPUTFILES******

YP[15, *] = Yenvir[5, *]; / (YP[2, *] * YP[0, *]);15 = Fishenvir[5,*]= microzooplankton
YP[16, *] = Yenvir[6, *]; / (YP[2, *] * YP[0, *]);16 = Fishenvir[6,*]= mid-sized mesozooplankton
YP[17, *] = Yenvir[7, *]; / (YP[2, *] * YP[0, *]);17 = Fishenvir[7,*]= large mesozooplankton
YP[18, *] = TotBenBio[HatLoc]; / (YP[2, *] * YP[0, *]);18 = Fishenvir[8,*]= chironomids


YP[19 : 24, *] = Yenvir[9 : 14, *]
;19 = Fishenvir[9,*]= temperature
;20 = Fishenvir[10,*]= DO
;21 = Fishenvir[11,*]= light
;22 = Fishenvir[12,*]= current i
;23 = Fishenvir[13,*]= current j
;24 = Fishenvir[14,*]= current w


;***Assining hatch temp***-> ONLY WHEN RUNNING SIMULATIONS FOR A WHOLE YEAR******
ahd = 11.0 * RANDOMU(seed, nYP)
h = WHERE(ahd LT 7.0, hcount)
IF (hcount GT 0) THEN ahd[h] = 7.0
YP[25,*] = ahd


; Acclimation
YP[26, *] = YP[19, *]; temperature the fish is acclimatized for consumption
YP[27, *] = YP[19, *]; temperature the fish is acclimatized for respiration
 
YP[28, *] = YP[20, *]; DO the fish is acclimatized for consumption
YP[29, *] = YP[20, *]; DO the fish is acclimatized for respiration 
 

YP[30, *] = 0.0; undigested rotifers in the stomach
YP[31, *] = 0.0; undigested copopods in the stomach
YP[32, *] = 0.0; undigested cladocerans in the stomach
YP[33, *] = 0.0; undigested chironomids in the stomach
YP[34, *] = 0.0; undigested bythotrephes in the stomach
YP[35, *] = 0.0; undigested yellow perch in the stomach
YP[45, *] = 0.0; undigested emerald shiner in the stomach
YP[46, *] = 0.0; undigested rainbow smelt in the stomach
YP[47, *] = 0.0; undigested round goby in the stomach


YP[36, *] = 0.0; cumulative probability for suffocation mortality
YP[64, *] = 0.0; background predation mortality 
YP[65, *] = 0.0; starvation mortality
YP[66, *] = 0.0; background suffocation mortality


YP[59, *] = 0.0; RESPIRATION RATE
YP[63, *] = 0.0; O2 debt

YP[68, *] = 0.0; month
YP[42, *] = 0.0; day
YP[43, *] = 0.0; hour
YP[44, *] = 0.0; minutes

YP[67, *] = FINDGEN(nYP)+1L; Fish SI ID

;PRINT, 'YP'
;PRINT, YP[10:18, *]
;PRINT, TOTAL(YP[0,*])

t_elapsed = systime(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'YEPinitial Ends Here'
RETURN, YP; TURN OFF WHEN TESTING
END