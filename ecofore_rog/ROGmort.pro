FUNCTION ROGmort, length, stor, struc, no_inds, nROG, td, ts, DOa, DOacclR, DOstressR, LIGHT

PRINT, 'ROGmort Begins Here'
;TO BE USED FOR TESTING PURPOSES ONLY
;no_inds = [10000, 2432, 4534, 232, 123, 1000000]
;nWAE = 6
;iday = 365.0
;stor = [8.0,32.0,25.0,23.0,41.0,9.0]
;struc = [20.0,35.0,34.0,24.0,41.0,12.0]
;length = [16.0,27.0,38.0,100.1,80.0,70.0]
;a = 187
;hatchday = [141,145,147,145,146,146]
;DOa = [2.5,2.0,2.1,1.9,2.0,2.8]
;DOacclR = [5.0,4.9,5.5,5.1,6.0,5.6]
;td = 240
;ts = 6
;Tamb = 23

; Egg and yolk sac larva mortality



; Size-based predation mortality
;z = 0.4 * EXP(-1.0*(length) * 0.06); High mort
z = 0.4*EXP(-(length) * 0.08) ;Low mort
z = z / td
v = WHERE(z LT 0.0, vcount)
IF (vcount GT 0.0) THEN z[v] = 0.0
litfac = (126.31 + (-113.6 * EXP(-1.0 * light))) / 126.31; Howick & O'Brien. 1983. Trans.Am.Fish.Soc.
p_pred = (1.0 - EXP(-Z))* LITFAC
;PRINT, 'z =', z
;PRINT, 'p_pred =', p_pred 

; Starvation mortality
optrho = (0.0912 * ALOG(length) + 0.128); based on energy data from Hanson 1997
op = WHERE(optrho LT 0.3, opcount)
IF (opcount GT 0.0) THEN optrho[op] = 0.3
p_starve = 0.1 + 0.4 * (optrho)
actrho = stor / (stor + struc)
;PRINT, 'p_starve =', p_starve

; Suffocaiton mortality from accumulation of DOstress which is converted into MORTinc = proportion of population
PrMORT = FLTARR(nROG)
;DOstressR = DOa - DOacclR; FOR TEST ONLY
;DOstressR = YEPacclDO(DOaccl0R, DOaccl0C, DOa, TacclR, TacclC, Tamb, ts, nYP)
MORTINC = FLTARR(nROG)
;PRINT, 'DOstressR =', DOstressR
DOs = WHERE(DOstressR LT -2.45, DOscount,complement = DOSC, ncomplement = DOSccount)
IF (DOscount GT 0.0) THEN MORTinc[DOS] = -0.023 * DOstressR[DOS] ELSE MORTinc[DOSC] = 0.0
PrMORT = (MORTinc - 0*PrMORT) / 60.0 * ts
;each time step = 6min. for bluegill from Neil et al. 2004 

;PRINT, 'PrMort =', prmort

Pred = FLTARR(nROG)
Star = FLTARR(nROG)
Suff = FLTARR(nROG)
; Determine the realized number of individuals lost
FOR i = 0L, nROG - 1 DO BEGIN
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
      star[i] = (RANDOMN(seed, BINOMIAL = [no_inds[i], 0.3], /double))
    ENDIF ELSE BEGIN
      star[i] = 0.0
    ENDELSE
    ; suffocation
    IF (PrMORT[i] GT 0.0 AND PrMORT[i] LT 1.0) THEN begin
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
    
 ;TotMort[2]=round(wint)
;print, actrho
;print, p_pred, p_starve, p_wint
;print, no_inds
;return, totmort
;print, totmort
;totmort [0,*]=pred
;totmort [3,*]=z   
      
TotMort = FLTARR(4, nROG)
TotMort[0,*] = ROUND(pred)
TotMort[1,*] = ROUND(star)
TotMort[2,*] = ROUND(suff)
TotMort[3,*] = PrMORT
;PRINT, 'TotMort'
;PRINT, TotMort

PRINT, 'ROGmort Ends Here'
RETURN, TotMort
END