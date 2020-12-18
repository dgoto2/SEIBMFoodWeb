FUNCTION ROGinitial, Npop, nROG, TotBenBio, NewInput, nGridcell
;this function initializes the data for ROUND GOBY

;------------TEST ONLY-----------------------------------------------
;PRO ROGinitial, nROG, TotBenBio, newinput
;------------NEED for MOVE TEST--------
;nROG = 300L; the number of superindividuals
;Grid3D2 = GridCells3D()
;nGridcell = 77500L
;TotBenBio = FLTARR(nGridcell) 
;BottomCell = WHERE(Grid3D2[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
;IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
;newinput = EcoForeInputfiles()
;;ihour = 15L; hour 1 - 24
;;newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]
;TotBenBio = TotBenBio + NewInput[8, *]
;-------------------------------------------------------------

PRINT, 'ROGinitial Starts Here'
ROG = FLTARR(70, nROG)

; Set the number of individuals in EACH superindividual
;Npop = 50000000L; 50,000,000, INITIAL TOTAL NUMBER OF FISH POPUALTION IN CENTRAL LAKE ERIE 

; below statement is required to make an even distribution of ages between 0-6
; set the number of individuals within an age category to frequency dist from Fielder and Thomas 2006

; randomly assign ages 0-6 based on a uniform distribution
SEX = ROUND(RANDOMU(seed, nROG)) ;randomly assign sex
AGE = ROUND(RANDOMU(seed, nROG) * (MAX(1) - MIN(0)) + MIN(0))
ROG[5, *] = SEX ; MALE = 0 AND FEMALE = 1
ROG[6, *] = AGE ; holds age

; determine the number of SIs at age and the total number of indvids represented by age
;*****NEED LAKE ERIE AGE STRUCTURE DATA*********
AgeProp = FLTARR(8)
AgeProp[0] = 0.436
AgeProp[1] = 0.564; 0.171
;AgeProp[2] = 0.145
;AgeProp[3] = 0.122
;AgeProp[4] = 0.042
;AgeProp[5] = 0.013
;AgeProp[6] = 0.0032
;AgeProp[7] = 0.0008
;PRINT, TOTAL(AGEPROP[*])
no_inds = FLTARR(nROG)
y0 = WHERE(age EQ 0, y0count)
IF y0count GT 0. THEN no_inds[y0] = round(Npop * AgeProp[0])/y0count
y1 = WHERE(age eq 1, y1count)
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

; Determine the number of individuals in each superindividual
ROG[0, *] = no_inds; 28676 -> 2005 estimate of YOY yellow perch in central basin based on Ohio DNR, divided by nYP or p = 2000
; Lake Erie surface area = ~25745km2 
; central basin = 3875*4km2 = ~15500km2
; 1 ha = 0.01km2
; => 1550000ha (1 ha = 0.01km2)
; In 2005, 129.8/ha ROG -> 201138333D
;          167.8/ha ROG -> 260038333D

;*****NEED LAKE ERIE AGE-SPECIFIC LENGTHS**********
; von bertalanffy params FOR raound goby
; from Fishbase.org
Linf = FLTARR(nROG)
K = FLTARR(nROG)
t0 = FLTARR(nROG)
Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
IF malecount GT 0. THEN BEGIN
  ; males
  Linf[male] = 13.3
  K[male] = 0.350
  t0[male] = -0.21
ENDIF
IF femalecount GT 0. THEN BEGIN
  ; females
  Linf[female] = 21.9
  K[female] = 0.110
  t0[female] = -1.62
ENDIF
LENGTH = FLTARR(nROG)
Length[*] = Linf * (1 - EXP(-k * (AGE[*] - t0))) * 10.
LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN Length[LAG0] = RANDOMU(seed, LAG0count) * (MAX(6.5) - MIN(6.4)) + MIN(6.4); Hensler and Jude, JGLR 2007
ROG[1, *] = length; in mm
;print, min(length)
;print, max(length)

opt_rho = FLTARR(nROG)
ROG[4, *] = 0.19*0.00001 * (ROG[1, *])^2.8403*1.19 ; structural weight (PERCH)
opt_rho[*] = (1.1*0.0912 * ALOG((ROG[1, *])) + 0.128*0.9) ; optrho (PERCH)

; Don't allow opt_rho to drop below 0.3
cho = WHERE(opt_rho LT 0.3, count)
IF count GT 0 THEN opt_rho[cho] = 0.3
;print, min(opt_rho)
ROG[2, *] = (ROG[4, *] / (1 - opt_rho[*])); total weight
ROG[3, *] = ROG[2, *] - ROG[4, *] ; storage weight

ROG[7, *] = 0.0 ; holds stomach content weight in g
ROG[60, *] = 0.0; GUT FULLNESS IN %

ROG[61, *] = 0.0; daily cumulative growth in length
ROG[62, *] = 0.0; daily cumulative growth in weight

ROG[8, *] = 0.0 ; holds maximum stomach capacity in g
ROG[9, *] = 0.0 ; holds total amount consumed over the last 24 hours in g
ROG[48, *] = 0.0; total amount of microzooplankton consumed over the last 24 hours in g
ROG[49, *] = 0.0; total amount of small mesozooplankton consumed over the last 24 hours in g
ROG[50, *] = 0.0; total amount of large mesozooplankton consumed over the last 24 hours in g
ROG[51, *] = 0.0; total amount of chironomids consumed over the last 24 hours in g
ROG[52, *] = 0.0; total amount of invasive species consumed over the last 24 hours in g
ROG[53, *] = 0.0; total amount of yellow perch consumed over the last 24 hours in g
;YP[54, *] = 0.0; total amount of emerald shiner consumed over the last 24 hours in g
;YP[55, *] = 0.0; total amount of rainbow smelt consumed over the last 24 hours in g
;YP[56, *] = 0.0; total amount of round goby consumed over the last 24 hours in g

; Assigning hatch cell or initial location of fish
; Haching occurs in nearshore areas with depth < 15mm
;Whatloc = WHERE(Grid2D[4, 0L : 3794L] LT 15.0)
ROhat = WHERE(newinput[9, 0L : nGridcell-1L] GT 4.0 AND newinput[10, 0L : nGridcell-1L] LE 24.648, count) 
;Count = 77500L; FOR NOW
;cells that can be used as hatching cells for walleye
;PRINT, 'What', What
;PRINT, 'count', count
;HatLoc = FLTARR(nROG)
HatLoc = ROUND(RANDOMU(seed, nROG) * (count - 1L))
; random number for all WAE SIs ranging from 0-# cells with depths less than 3m
;PRINT, 'HatLoc', HatLoc
ROenvir = newinput[*, ROhat[HatLoc]]; x, y location based on depths less than 6m
;PRINT, 'Wenvir', Yenvir

; Environment for each YOY SI
ROG[10 : 14, *] = ROenvir[0 : 4, *]; 15 arrays from NewInputFiles
;10 = Fishenvir[0,*]= Xl ;assigning each 3d cell a unique id???
;11 = Fishenvir[1,*]= yl
;12 = Fishenvir[2,*]= zl
;13 = Fishenvir[3,*]= GridIDxy; horizontal grid ID 
;14 = Fishenvir[4,*]= GridNo; unique 3D ID

ROG[37, *] = 0.0; total distance moved within each cell in ts ->should be reset when fish move to the new cell

; Within-cell proportional coordinates from movements
ROG[39, *] = 0.0; Within-cell coordinate for x
ROG[40, *] = 0.0; Within-cell coordinate for y
ROG[41, *] = 0.0; Within-cell coordinate for z

;YP[15 : 18, *] = Yenvir[5 : 8, *]/YP[0, *]
;NEED TO INCORPORATE DENSITY-DEPENDENCE BY SUBTRACTING CONSUMED PREY BIOMASS FROM FORAGING
;; Use "/YP[0, *]" for food availability per individual within superindividuals to incorporate density-dependence
ROG[38, *] = ROenvir[15, *]; settling carbon, g/m2 

ROG[15, *] = ROenvir[5, *];/ROG[0, *];15 = Fishenvir[5,*]= microzooplankton
ROG[16, *] = ROenvir[6, *];/ROG[0, *];16 = Fishenvir[6,*]= mid-sized mesozooplankton
ROG[17, *] = ROenvir[7, *];/ROG[0, *];17 = Fishenvir[7,*]= large mesozooplankton
ROG[18, *] = TotBenBio[HatLoc];/ROG[0, *];18 = Fishenvir[8,*]= chironomids

ROG[19 : 24, *] = ROenvir[9 : 14, *]
;19 = Fishenvir[9,*]= temperature
;20 = Fishenvir[10,*]= DO
;21 = Fishenvir[11,*]= light
;22 = Fishenvir[12,*]= current i
;23 = Fishenvir[13,*]= current j
;24 = Fishenvir[14,*]= current w

; Assining a hatch temp
ahd = 11.0 * RANDOMU(seed, nROG)
h = WHERE(ahd LT 7.0, hcount)
IF (hcount GT 0) THEN ahd[h] = 7.
ROG[25, *] = ahd

; Acclimation
ROG[26, *] = ROG[19, *]; temperature the fish is acclimatized for consumption
ROG[27, *] = ROG[19, *]; temperature the fish is acclimatized for respiration
 
ROG[28, *] = ROG[20, *]; DOa ;DO the fish is acclimatized for consumption
ROG[29, *] = ROG[20, *]; DOa ;DO the fish is acclimatized for respiration 
 
ROG[30, *] = 0.0; undigested rotifers in the stomach
ROG[31, *] = 0.0; undigested copopods in the stomach
ROG[32, *] = 0.0; undigested cladocerans in the stomach
ROG[33, *] = 0.0; undigested chironomids in the stomach
ROG[34, *] = 0.0; undigested bythotrephes in the stomach
ROG[35, *] = 0.0; undigested fish in the stomach

ROG[36, *] = 0.0; cumulative probability for suffocation mortality
ROG[64, *] = 0.0; background predation mortality 
ROG[65, *] = 0.0; starvation mortality
ROG[66, *] = 0.0; background suffocation mortality

ROG[59, *] = 0.0; RESPIRATION RATE
ROG[63, *] = 0.0; O2 debt

ROG[68, *] = 0.0; month
ROG[42, *] = 0.0; day
ROG[43, *] = 0.0; hour
ROG[44, *] = 0.0; minutes

ROG[67, *] = FINDGEN(nROG)+1L; Fish SI ID
;PRINT, 'ROG'
;PRINT, ROG
;;********************************************************
;; Creat a fish prey array for potential predators 
;nGridcell = 77500L
;FISHPREY = FLTARR(5L, nGridcell)
;FISHPREY[0, ROG[14, *]] = ROG[0, *]; ARRAY FOR FISH PREY ABUNDANCE
;FISHPREY[1, ROG[14, *]] = ROG[1, *]; ARRAY FOR FISH PREY TOTAL LENGTH
;FISHPREY[2, ROG[14, *]] = ROG[2, *]; ARRAY FOR FISH PREY TOTAL WEIGHT
;FISHPREY[3, ROG[14, *]] = ROG[2, *] * ROG[0, *]; ARRAY FOR FISH PREY TOTAL BIOMASS
;FISHPREY[4, ROG[14, *]] = 1; TEST
;PRINT, 'FISH PREY ARRAY', FISHPREY 
;PRINT, 'TOTALfishprey2', TOTAL(FISHPREY[4, *]) 
;;********************************************************
PRINT, 'ROGinitial Ends Here'
RETURN, ROG
END