FUNCTION WAEmort, length, stor, struc, no_inds, nWAE, td, ts, DOa, DOacclR, DOstressR, LIGHT

PRINT, 'WAEmort Begins Here'

; Light-dependent size-based background predation mortality
litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.

z = 0.4 * EXP(-1.0*(length) * 0.06)*LITFAC; High mort
;z = 0.4 * EXP(-(length) * 0.08)  ;Low mort

v = WHERE(z LT 0.0, vcount)
IF (vcount GT 0.0) THEN z[v] = 0.0

Fishing = WHERE(length GE 381., Fidshingcount, complement = NoFishing, ncomplement = NoFishingcount); 15inch minimum size
IF (Fidshingcount GT 0.0) THEN Z[Fishing] = Z[Fishing] + (0.9)/365.; annual fishing rate for age 2+ USE AGE!!!!!

z = z / td
p_pred = (1.0 - EXP(-Z))
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 


; Starvation mortality
optrho = (0.1298 * ALOG(length) - 0.0853); based on energy data from Hanson 1997
op = WHERE(optrho LT 0.2, opcount)
IF (opcount GT 0.0) THEN optrho[op] = 0.2
p_starve = 0.1 + 0.4 * (optrho)
actrho = stor / (stor + struc)
;PRINT, 'p_starve =', p_starve


; Suffocaiton mortality from accumulation of DOstress which is converted into MORTinc = proportion of population
PrMORT = FLTARR(nWAE)
;DOstressR = DOa - DOacclR; FOR TEST ONLY
;DOstressR = YEPacclDO(DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, nYP)
MORTINC = FLTARR(nWAE)
;PRINT, 'DOstressR =', DOstressR
DOs = WHERE(DOstressR LT -2.45, DOscount,complement = DOSC, ncomplement = DOSccount)
IF (DOscount GT 0.0) THEN MORTinc[DOS] = -0.023 * DOstressR[DOS] ELSE MORTinc[DOSC] = 0.0
PrMORT = MORTinc / 60.0 * ts; each time step for bluegill from Neil et al. 2004 
;PRINT, 'PrMort =', prmort


; Determine the realized number of individuals lost
Pred = FLTARR(nWAE)
Star = FLTARR(nWAE)
Suff = FLTARR(nWAE)
FOR i = 0L, nWAE - 1 DO BEGIN
  ; predation
  IF (no_inds[i] LT 1.0) THEN pred[i] = no_inds[i]
  IF (no_inds[i] GE 1.0) THEN BEGIN
    IF (p_pred[i] LE 0.0) THEN BEGIN
      pred[i] = 0.0
    ENDIF ELSE BEGIN
      pred[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], p_pred[i]], /double))
    ENDELSE
    
    ; starvation
    IF (actrho[i] LT p_starve[i]) THEN BEGIN
      star[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], 0.2], /double))
    ENDIF ELSE BEGIN
      star[i] = 0.0
    ENDELSE
    
    ; suffocation
    IF (PrMORT[i] GT 0.0 AND PrMORT[i] LT 1.0) THEN BEGIN
      suff[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], PrMORT[i]], /double))
    ENDIF ELSE BEGIN
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


TotMort = FLTARR(4, nWAE)
TotMort[0,*] = ROUND(pred)
TotMort[1,*] = ROUND(star)
TotMort[2,*] = ROUND(suff)
TotMort[3,*] = PrMORT
;PRINT, 'TotMort'
;PRINT, TotMort

PRINT, 'WAEmort Ends Here'
RETURN, TotMort
END