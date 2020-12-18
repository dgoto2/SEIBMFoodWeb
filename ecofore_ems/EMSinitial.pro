FUNCTION EMSinitial, Npop, nEMS, TotBenBio, NewInput, nGridcell
;this function initializes the data for EMERLAD SHINER

PRINT, 'EMSinitial Starts Here'

EMS = FLTARR(70, nEMS)
; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-1
; randomly assign ages 0-1 based on a uniform distribution
SEX = ROUND(RANDOMU(seed, nEMS)) ; randomly assign sex
AGE = ROUND(RANDOMU(seed, nEMS) * (MAX(1) - MIN(0)) + MIN(0))
EMS[5, *] = SEX ; MALE = 0 AND FEMALE = 1
EMS[6, *] = AGE ;


; determine the number of SIs at age and the total number of individuals represented by age
AgeProp = FLTARR(8)
; The following is based on average values of Lake Erie field data between 87 and 05
AgeProp[0] = 0.596; 0.508; 0.503
AgeProp[1] = 0.404; 0.492; 0.171
;AgeProp[2] = 0.145
;AgeProp[3] = 0.122
;AgeProp[4] = 0.042
;AgeProp[5] = 0.013
;AgeProp[6] = 0.0032
;AgeProp[7] = 0.0008
;PRINT, TOTAL(AGEPROP[*])

no_inds = FLTARR(nEMS)
y0 = WHERE(AGE EQ 0, y0count)
IF y0count GT 0. THEN no_inds[y0] = round(Npop * AgeProp[0])/y0count
y1 = WHERE(AGE EQ 1, y1count)
IF y1count GT 0. THEN no_inds[y1] = round(Npop * AgeProp[1])/y1count
;y2 = WHERE(age eq 2, y2count)
;IF y2count GT 0. THEN no_inds[y2] = round(Npop * AgeProp[2])/y2count
;y3 = WHERE(age eq 3, y3count)
;IF y3count GT 0. THEN no_inds[y3] = round(Npop * AgeProp[3])/y3count 
;y4 = WHERE(age eq 4, y4count)
;IF y4count GT 0. THEN no_inds[y4] = round(Npop * AgeProp[4])/y4count
;y5 = WHERE(age eq 5, y5count)
;IF y5count GT 0. THEN no_inds[y5] = round(Npop * AgeProp[5])/y5count
;y6 = WHERE(age eq 6, y6count)
;IF y6count GT 0. THEN no_inds[y6] = round(Npop * AgeProp[6])/y6count
;y7 = WHERE(age eq 7, y7count)
;IF y7count GT 0. THEN no_inds[y7] = round(Npop * AgeProp[7])/y7count

EMS[0, *] = no_inds;

; Lake Erie surface area = ~25745km2 
; central basin = 3875*4km2 = ~15500km2
; => 1550000ha (1 ha = 0.01km2)
; In 2005, 288.2/ha EMS YOY -> 446761667D
;          278.7/ha EMS YAO -> 432036667D


;*****NEED LAKE ERIE AGE-SPECIFIC LENGTHS**********
; von bertalanffy params FOR rainbow smelt from 
Linf = FLTARR(nEMS)
K = FLTARR(nEMS)
t0 = FLTARR(nEMS)
Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF malecount GT 0. THEN BEGIN
  ; males
  Linf[male] = 270.
  K[male] = 0.488
  t0[male] = 0.412
ENDIF

IF femalecount GT 0. THEN BEGIN
  ; females
  Linf[female] = 270.
  K[female] = 0.488
  t0[female] = 0.412
ENDIF

LENGTH = FLTARR(nEMS)
Length[*] = Linf * (1. - EXP(-k * (AGE[*] - t0)))
LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN Length[LAG0] = RANDOMU(seed, LAG0count) * (MAX(6.5) - MIN(6.4)) + MIN(6.4)
EMS[1, *] = length; in mm
;print, min(length)
;print, max(length)]


; Assining weight, storage weight, structural weight
opt_rho = FLTARR(nEMS)
EMS[4, *] = 0.045*0.00001 * (EMS[1, *])^(2.8403*1.2) ; structural weight
opt_rho[*] = (1.1 * 0.0912 * ALOG(EMS[1, *]) + 0.128 * 1.2) ; optrho
;print, min(opt_rho)

; Don't allow opt_rho to drop below 0.2
cho = WHERE(opt_rho LT 0.2, count)
IF count GT 0 THEN opt_rho[cho] = 0.2
;print, min(opt_rho)
EMS[2, *] = (EMS[4, *] / (1 - opt_rho[*])); total weight
EMS[3, *] = EMS[2, *] - EMS[4, *] ; storage weight

EMS[61, *] = 0.0; daily cumulative growth in length
EMS[62, *] = 0.0; daily cumulative growth in weight


EMS[7, *] = 0.0 ; holds stomach content weight in g
EMS[60, *] = 0.0; GUT FULLNESS IN %

EMS[8, *] = 0.0 ; holds maximum stomach capacity in g
EMS[9, *] = 0.0 ; holds total amount consumed over the last 24 hours in g
EMS[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
EMS[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
EMS[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
EMS[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
EMS[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
EMS[53, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
;YP[54, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
;YP[55, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
;YP[56, *] = 0.0; total amount of round goby consumed over the last 24 hours in g


; Assigning hatch cell or initial location of fish
; Haching occurs in nearshore areas with depth < 15mm
Ehat = WHERE(newinput[10, 0L : nGridcell-1L] GT 4.0 AND newinput[9, 0L : nGridcell-1L] LE 35.0, count) 
;PRINT, 'count', count

HatLoc = ROUND(RANDOMU(seed, nEMS) * (count - 1L))
; random number for all SIs ranging from 0-# cells
;PRINT, 'HatLoc', HatLoc

Eenvir = NewInput[*, Ehat[HatLoc]];


; Environment for each SI
EMS[10 : 14, *] = Eenvir[0 : 4, *]; 15 arrays from NewInputFiles
;10 = Fishenvir[0,*]= Xl ;assigning each 3D cell a unique id???
;11 = Fishenvir[1,*]= yl
;12 = Fishenvir[2,*]= zl
;13 = Fishenvir[3,*]= GridIDxy; horizontal grid ID 
;14 = Fishenvir[4,*]= GridNo; unique 3D (OR 1D) ID 

EMS[37, *] = 0.0; total distance moved within each cell in ts ->should be reset when fish move to the new cell

; Within-cell proportional coordinates from movements
EMS[39, *] = 0.0; Within-cell coordinate for x
EMS[40, *] = 0.0; Within-cell coordinate for y
EMS[41, *] = 0.0; Within-cell coordinate for z


EMS[38, *] = Eenvir[15, *]; settling carbon, g/m2 

EMS[15, *] = Eenvir[5, *];/EMS[0, *];15 = Fishenvir[5,*]= microzooplankton
EMS[16, *] = Eenvir[6, *];/EMS[0, *];16 = Fishenvir[6,*]= mid-sized mesozooplankton
EMS[17, *] = Eenvir[7, *];/EMS[0, *];17 = Fishenvir[7,*]= large mesozooplankton
EMS[18, *] = TotBenBio[HatLoc];/EMS[0, *];18 = Fishenvir[8,*]= chironomids


EMS[19 : 24, *] = Eenvir[9 : 14, *]
;19 = Fishenvir[9,*]= temperature
;20 = Fishenvir[10,*]= DO
;21 = Fishenvir[11,*]= light
;22 = Fishenvir[12,*]= current i
;23 = Fishenvir[13,*]= current j
;24 = Fishenvir[14,*]= current w


; Assining a hatch temp
ahd = 11.0 * RANDOMU(seed, nEMS)
h = WHERE(ahd LT 7.0, hcount)
IF (hcount GT 0) THEN ahd[h] = 7.0
EMS[25, *] = ahd


; Acclimation
EMS[26, *] = EMS[19, *]; temperature the fish is acclimatized for consumption
EMS[27, *] = EMS[19, *]; temperature the fish is acclimatized for respiration
 
EMS[28, *] = EMS[20, *]; DOa ;DO the fish is acclimatized for consumption
EMS[29, *] = EMS[20, *]; DOa ;DO the fish is acclimatized for respiration 
 

EMS[30, *] = 0.0; undigested rotifers in the stomach
EMS[31, *] = 0.0; undigested copopods in the stomach
EMS[32, *] = 0.0; undigested cladocerans in the stomach
EMS[33, *] = 0.0; undigested chironomids in the stomach
EMS[34, *] = 0.0; undigested bythotrephes in the stomach
EMS[35, *] = 0.0; undigested fish in the stomach


EMS[36, *] = 0.0; cumulative probability for suffocation mortality
EMS[64, *] = 0.0; background predation mortality 
EMS[65, *] = 0.0; starvation mortality
EMS[66, *] = 0.0; background suffocation mortality


EMS[59, *] = 0.0; Reapiration rate
EMS[63, *] = 0.0; O2 debt


EMS[68, *] = 0.0; month
EMS[42, *] = 0.0; day
EMS[43, *] = 0.0; hour
EMS[44, *] = 0.0; minutes

EMS[67, *] = FINDGEN(nEMS)+1L; Fish SI ID

;PRINT, 'EMS'
;PRINT, EMS[0: 14, *]

PRINT, 'EMSinitial Ends Here'
RETURN, EMS; TURN OFF WHEN TESTING
END