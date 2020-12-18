FUNCTION RASinitial, Npop, nRAS, TotBenBio, NewInput, nGridcell
;this function initializes the data for RASINBOW SMELT

PRINT, 'RASinitial Starts Here'
RAS = FLTARR(70, nRAS)
; Set the number of individuals in EACH superindividual
; below statement is required to make an even distribution of ages between 0-1
; randomly assign ages 0-6 based on a uniform distribution
SEX = ROUND(RANDOMU(seed, nRAS)) ;randomly assign sex
AGE = ROUND(RANDOMU(seed, nRAS) * (MAX(1) - MIN(0)) + MIN(0))
RAS[5, *] = SEX ; MALE = 0 AND FEMALE = 1
RAS[6, *] = AGE ; holds age


; determine the number of SIs at age and the total number of indvids represented by age
AgeProp = FLTARR(8)
; The following is based on average values of Lake Erie field data between 87 and 05
AgeProp[0] = 0.748; 0.366;0.503
AgeProp[1] = 0.252; 0.634; 0.171
;AgeProp[2] = 0.145
;AgeProp[3] = 0.122
;AgeProp[4] = 0.042
;AgeProp[5] = 0.013
;AgeProp[6] = 0.0032
;AgeProp[7] = 0.0008
;PRINT, TOTAL(AGEPROP[*])
no_inds = FLTARR(nRAS)
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

RAS[0, *] = no_inds

; Lake Erie surface area = ~25745km2 
; central basin = 3875*4km2 = ~15500km2
; 1 ha = 0.01km2
; => 1550000ha (1 ha = 0.01km2)
; In 2005, 23.7/ha RAS -> 36683333D
;          41.1/ha RAS -> 63653333D      


;*****NEED LAKE ERIE AGE-SPECIFIC LENGTHS**********
; von bertalanffy params for rainbow smelt
; from Xi and ....
Linf = FLTARR(nRAS)
K = FLTARR(nRAS)
t0 = FLTARR(nRAS)
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

LENGTH = FLTARR(nRAS)
Length[*] = Linf * (1 - EXP(-k * (AGE[*] - t0)))
LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN Length[LAG0] = RANDOMU(seed, LAG0count) * (MAX(6.) - MIN(5.9)) + MIN(5.9)
RAS[1, *] = length; in mm
;print, min(length)
;print, max(length)


; Assining weight, storage weight, structural weight
opt_rho = FLTARR(nRAS)
RAS[4, *] = 0.045*0.00001 * (RAS[1, *])^(2.8403*1.2) ; structural weight (PERCH)
opt_rho[*] = (1.01 * 0.0912 * ALOG(RAS[1, *]) + 0.128 * 1.1) ; optrho (PERCH)

; Don't allow opt_rho to drop below 0.3
cho = WHERE(opt_rho LT 0.2, count)
IF count GT 0 THEN opt_rho[cho] = 0.2
;print, min(opt_rho)
RAS[2, *] = (RAS[4, *] / (1 - opt_rho[*])); total weight
RAS[3, *] = RAS[2, *] - RAS[4, *] ; storage weight

RAS[61, *] = 0.0; daily cumulative growth in length
RAS[62, *] = 0.0; daily cumulative growth in weight


RAS[7, *] = 0.0 ; holds stomach content weight in g
RAS[60, *] =0.0; GUT FULLNESS IN %

RAS[8, *] = 0.0 ; holds maximum stomach capacity in g
RAS[9, *] = 0.0 ; holds total amount consumed over the last 24 hours in g
RAS[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
RAS[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
RAS[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
RAS[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
RAS[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
RAS[53, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
;YP[54, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
;YP[55, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
;YP[56, *] = 0.0; total amount of round goby consumed over the last 24 hours in g


; Assigning hatch cell or initial location of fish
; Haching occurs in nearshore areas with depth < 15mm
;Whatloc = WHERE(Grid2D[4, 0L : 3794L] LT 15.0)
Rhat = WHERE(newinput[10, 0L : nGridcell-1L] GT 4.0 AND newinput[9, 0L : nGridcell-1L] LE 26.0, count) 
;PRINT, 'count', count

;HatLoc = FLTARR(nRAS)
HatLoc = ROUND(RANDOMU(seed, nRAS) * (count - 1L))
; random number for all  SIs ranging from 0-# cells
;PRINT, 'HatLoc', HatLoc
Renvir = newinput[*, Rhat[HatLoc]]


; Environment for each YOY SI
RAS[10 : 14, *] = Renvir[0 : 4, *]; 15 arrays from NewInputFiles
;10 = Fishenvir[0,*]= Xl ;assigning each 3d cell a unique id???
;11 = Fishenvir[1,*]= yl
;12 = Fishenvir[2,*]= zl
;13 = Fishenvir[3,*]= GridIDxy; horizontal grid ID 
;14 = Fishenvir[4,*]= GridNo; unique 3D ID


RAS[37, *] = 0.0; total distance moved within each cell in ts ->should be reset when fish move to the new cell

; Within-cell proportional coordinates from movements
RAS[39, *] = 0.0; Within-cell coordinate for x
RAS[40, *] = 0.0; Within-cell coordinate for y
RAS[41, *] = 0.0; Within-cell coordinate for z


;YP[15 : 18, *] = Yenvir[5 : 8, *]/YP[0, *]
RAS[38, *] = Renvir[15, *]; settling carbon, g/m2 

RAS[15, *] = Renvir[5, *];/RAS[0, *];15 = Fishenvir[5,*]= microzooplankton
RAS[16, *] = Renvir[6, *];/RAS[0, *];16 = Fishenvir[6,*]= mid-sized mesozooplankton
RAS[17, *] = Renvir[7, *];/RAS[0, *];17 = Fishenvir[7,*]= large mesozooplankton
RAS[18, *] = TotBenBio[HatLoc];/RAS[0, *];18 = Fishenvir[8,*]= chironomids


RAS[19 : 24, *] = Renvir[9 : 14, *]
;19 = Fishenvir[9,*]= temperature
;20 = Fishenvir[10,*]= DO
;21 = Fishenvir[11,*]= light
;22 = Fishenvir[12,*]= current i
;23 = Fishenvir[13,*]= current j
;24 = Fishenvir[14,*]= current w


; Assining a hatch temp
ahd = 11.0 * RANDOMU(seed, nRAS)
h = WHERE(ahd LT 7.0, hcount)
IF (hcount GT 0) THEN ahd[h] = 7.0
RAS[25, *] = ahd


; Acclimation
RAS[26, *] = RAS[19, *]; temperature the fish is acclimatized for consumption
RAS[27, *] = RAS[19, *]; temperature the fish is acclimatized for respiration
 
RAS[28, *] = RAS[20, *]; DOa ;DO the fish is acclimatized for consumption
RAS[29, *] = RAS[20, *]; DOa ;DO the fish is acclimatized for respiration 
 

RAS[30, *] = 0.0; undigested rotifers in the stomach
RAS[31, *] = 0.0; undigested copopods in the stomach
RAS[32, *] = 0.0; undigested cladocerans in the stomach
RAS[33, *] = 0.0; undigested chironomids in the stomach
RAS[34, *] = 0.0; undigested bythotrephes in the stomach
RAS[35, *] = 0.0; undigested fish in the stomach


RAS[36, *] = 0.0; cumulative probability for suffocation mortality
RAS[64, *] = 0.0; background predation mortality 
RAS[65, *] = 0.0; starvation mortality
RAS[66, *] = 0.0; background suffocation mortality


RAS[59, *] = 0.0; RESPIRATION RATE
RAS[63, *] = 0.0; O2 debt


RAS[68, *] = 0.0; month
RAS[42, *] = 0.0; day
RAS[43, *] = 0.0; hour
RAS[44, *] = 0.0; minutes

RAS[67, *] = FINDGEN(nRAS)+1L; Fish SI ID
;PRINT, 'RAS'
;PRINT, RAS


PRINT, 'RASinitial Ends Here'
RETURN, RAS; TURN OFF WHEN TESTING
END