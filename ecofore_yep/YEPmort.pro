FUNCTION YEPmort, length, stor, struc, no_inds, nYP, td, ts, DOa, DOacclR, DOstressR, LIGHT
;this function determines daily and overwinter mortality of YELLOW PERCH

PRINT, 'YPmort Begins Here'

; Egg and yolk sac larva mortality


; Light-dependent size-based background predation mortality
;*****NEED TO INCORPORATE SPECIFIC PREDATION RATES FROM PREDATORS' FORAGING*********
; THE FOLLOWING SHOULD BE ADJUSTEC FOR ONLY BACKGROUND PREDATION
litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.

z = 0.4 * EXP(-(length) * 0.06) * LITFAC; High mort
;z = 0.4*EXP(-(length) * 0.08) *LITFAC;Low mort

v = WHERE(z LT 0.0, vcount)
IF (vcount GT 0.0) THEN z[v] = 0.0

Fishing = WHERE(length GE 178., Fidshingcount, complement = NoFishing, ncomplement = NoFishingcount); 7inch minimum size
IF (Fidshingcount GT 0.0) THEN Z[Fishing] = Z[Fishing] + (0.95)/365.; annual fishing rate for age 2+ USE AGE!!!!!

z = z / td 
p_pred = (1.0 - EXP(-Z))
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 


; Starvation mortality
optrho = (0.0912 * ALOG(length) + 0.128); based on energy data from Hanson 1997
op = WHERE(optrho LT 0.2, opcount)
IF (opcount GT 0.0) THEN optrho[op] = 0.2
p_starve = 0.1 + 0.4 * (optrho)
actrho = stor / (stor + struc)
;print, 'p_starve =', p_starve


; Suffocaiton mortality from accumulation of DOstress which is converted into MORTinc = proportion of population
PrMORT = FLTARR(nYP)
;DOstressR = DOa - DOacclR; FOR TEST ONLY
;DOstressR = YEPacclDO(DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, nYP)
MORTINC = FLTARR(nYP)
;PRINT, 'DOstressR =', DOstressR
DOs = WHERE(DOstressR LT -2.45, DOscount,complement = DOSC, ncomplement = DOSccount)
IF (DOscount GT 0.0) THEN MORTinc[DOS] = -0.023 * DOstressR[DOS] ELSE MORTinc[DOSC] = 0.0
PrMORT = MORTinc / 60.0 * ts; each time step for bluegill from Neil et al. 2004 
;PRINT, 'PrMort =', prmort


Pred = FLTARR(nYP)
Star = FLTARR(nYP)
Suff = FLTARR(nYP)
;determine actual number of individuals lost
FOR i = 0L, nYP - 1 DO BEGIN
  ; predation
  IF (no_inds[i] LT 1.0) THEN pred[i] = no_inds[i]
  IF (no_inds[i] GE 1.0) THEN begin
    IF (p_pred[i] LE 0.0) THEN begin
      pred[i] = 0.0
    ENDIF else begin
      pred[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_pred[i]],/double))
    ENDELSE
    
    ; starvation
    IF (actrho[i] LT p_starve[i]) THEN begin
      star[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], 0.3],/double))
    ENDIF else begin
      star[i] = 0.0
    ENDELSE
    
    ; suffocation
    IF (PrMORT[i] GT 0.0 AND PrMORT[i] LT 1.0) THEN begin
      suff[i] = (RANDOMN(seed, BINOMIAL=[no_inds[i], PrMORT[i]],/double))
    ENDIF else begin
      suff[i] = 0.0
    ENDELSE
  ENDIF
ENDFOR
;print, pred
;print, star  
;print, suff


;overwinter mortality component
;ranges based on mean fall length for YOY from Fielder et al. 2006, which ranged from 66.1 to 96.5
  ;if a eq 334.0 then begin
   ; if length(i) lt 40.0 then wint(i) = no_inds(i)
    ;if length(i) gt 120.0 then wint(i) = 0.0
    ;if length(i) ge 40.0 and length(i) le 120.0 then begin
     ; ;to use for baseline sims
     ; p_wint(i) = -172.67*(stor(i)/length(i))^2-3.0353*(stor(i)/length(i))+1.0258   
      ;;to use for more sever winters comment out when not in use
      ;;p_wint(i) = p_wint(i)+(0.05*p_wint(i))
      ;if p_wint(i) lt 0.0 then p_wint(i) =0.0
      ;if p_wint(i) gt 1.0 then p_wint(i) =1.0
      ;if no_inds(i) lt 1.0 then wint(i) = no_inds(i)
      ;if no_inds(i) ge 1.0 then wint(i) = (RANDOMN(seed, BINOMIAL=[no_inds(i),p_wint(i)],/double))
    ;endif
  ;endif  
  
      
TotMort = FLTARR(4,nYP)
TotMort[0,*] = ROUND(pred)
TotMort[1,*] = ROUND(star)
TotMort[2,*] = ROUND(suff)
TotMort[3,*] = PrMORT
;PRINT, 'TotMort'
;PRINT, TotMort

PRINT, 'YPmort Ends Here'
RETURN, TotMort
END