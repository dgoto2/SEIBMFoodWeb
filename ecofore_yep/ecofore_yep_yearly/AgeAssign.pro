PRO AGEASSIGN
;randomly assign ages 1-8 based on a uniform distribution
N = 10000; the number of superindividuals
POPAGE = FLTARR(9, N)
no_inds = FLTARR(N)
SEX = FLTARR(N)
LENGTH = FLTARR(N)
LOGWT = FLTARR(N)
WEIGHT = FLTARR(N)
rhoc = FLTARR(N)
stor = FLTARR(N)
struc = FLTARR(N)

sex = ROUND(RANDOMU(seed, n)) ;randomly assign sex
AGE = FLOOR(RANDOMU(seed, N)*(MAX(6)-MIN(0))+MIN(0))
;FOR i = 0L, n-1 DO BEGIN
; below statement is required to make an even distribution of ages between 1-8
;  IF age(i) EQ 9.0 THEN age(i) = 1.0
; set the number of individuals within an age category to frequency dist from Fielder and Thomas 2006
;ENDFOR
  ; determine the number of SIs at age and the total number of indvids represented by an age
    y0 = where(age EQ 0, count)
    x0 =count
    numberinds0 = round(50000000*0.303)
    noperSI0 = numberinds0/X0
    no_inds[y0] = noperSI0
    
    y1=where(age eq 1, count)
    x1 =count
    numberinds1 = round(50000000*0.271)
    noperSI1 = numberinds1/X1
    no_inds[y1] = noperSI1
    
    y2=where(age eq 2, count)
    x2 =count
    numberinds2 = round(50000000*0.245)
    noperSI2 = numberinds2/X2
    no_inds[y2] = noperSI2
    
    y3=where(age eq 3, count)
    x3 =count
    numberinds3 = round(50000000*0.122)
    noperSI3 = numberinds3/X3
    no_inds[y3] = noperSI3
    
    y4=where(age eq 4, count)
    x4 =count
    numberinds4 = round(50000000*0.042)
    noperSI4 = numberinds4/X4
    no_inds[y4] = noperSI4
    
    y5=where(age eq 5, count)
    x5 =count
    numberinds5 = round(50000000*0.013)
    noperSI5 = numberinds5/X5
    no_inds[y5] = noperSI5
    
    y6=where(age eq 6, count)
    x6 =count
    numberinds6 = round(50000000*0.0032)
    noperSI6 = numberinds6/X6
    no_inds[y6] = noperSI6
    
;    y7=where(age eq 7, count)
;    x7 =count
;    numberinds7 = round(50000000*0.0008)
;    noperSI7 = numberinds7/X7

;for i=0L, n-1 do begin    

;von bertalanffy params trawl data
;from Jackson et al. 2008 Fisheries Management and Ecology vol 15 pp107-118
Male = where(sex eq 0., malecount)
if malecount eq 0 then begin
;males
Linf = 272.0
K=0.184
to = -2.45
endif else begin
;females
Linf= 307.0
K=0.333
to=0.031
endelse
Length[*] = Linf*(1-EXP(-k*(AGE[*]-to)))

LAG0 = WHERE((AGE EQ 0), LAG0count)
IF(LAG0count GT 0.) THEN Length[LAG0] = 15.
;*****NEED AGE-SPECIFIC LENGTHS**********


;weight from Fielder and Thomas 2007 appendix 4
logwt[*] = 2.888*alog10(Length[*]) - 4.627
weight[*] = 10^(logwt[*]) 
rhoc[*] = 0.1026*alog(length[*]) + 0.1064 ;size-based component of rho

LGT200 = WHERE((length GT 200), LGT200count)
IF(LGT200count GT 0.) THEN BEGIN
rhoc[LGT200] = 0.6
stor[LGT200]=weight[LGT200]*rhoc[LGT200]
struc[LGT200]=weight[LGT200]-stor[LGT200]
ENDIF

POPAGE[0,*] = AGE
POPAGE[1,*] = no_inds
POPAGE[2,*] =SEX 
POPAGE[3,*] =LENGTH 
POPAGE[4,*] =LOGWT 
POPAGE[5,*] =WEIGHT 
POPAGE[6,*] =rhoc
POPAGE[7,*] =stor 
POPAGE[8,*] =struc 
PRINT, POPAGE

END