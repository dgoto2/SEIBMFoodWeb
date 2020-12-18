;function determines how much digestion has occured during the time step
FUNCTION Wevac, T, ts, stom, nW
; determine the evacuation rate

;ts = 6.0 ;timestep
;T= 15.0
;stom = 0.1 ;stomach capacity in g

rate = -14.5+1.33*Temp-0.0329*Temp^2-0.0157*Temp * alog(weight); from walleye larvae
; from Johnston and Mathias, Journal of Fish Biology (1996) 49, 375–389

;lnrate = 0.114*T-4.58 ;rate in hours
;rate = exp(lnrate) ;rate in hours
rate = rate/60*ts ;converts rate to time step in min
;print, rate

nstom = fltarr(nYP) ;holds new value of stomach content after digestion

;remove g from stomach
st=where(stom gt 0.0, stcount, complement=t, ncomplement=tcount)
if (stcount gt 0.0) then nstom[st] = stom[st] - rate[st]
if (tcount gt 0.0) then nstom[t]=stom[t]
;if stom gt 0.0 then begin
;  nstom = stom - rate
;endif else nstom=stom

;print, nstom 
return, nstom
end


;function determines how much digestion has occured during the time step
FUNCTION YPevac, T, ts, stom, nYP
; determine the evacuation rate
;from Arend for L. Erie yellow perch
;ts = 6.0 ;timestep
;T= 15.0
;stom = 0.1 ;stomach capacity in g

;lnrate = 0.114*T-4.58 ;rate in hours ASK!! 
;rate = exp(lnrate) ;rate in hours

Rate = 0.0182*exp(0.14*Temp); for Eurasian perch from Persson, 1979  Freshwater Biology 9:99–104. 
rate = rate/60*ts ;converts rate to time step in min
;print, rate

nstom = fltarr(nYP) ;holds new value of stomach content after digestion

;remove g from stomach
st=where(stom GT 0.0, stcount, complement=t, ncomplement=tcount)
IF (stcount GT 0.0) THEN nstom[st] = stom[st] - rate[st]
IF (tcount GT 0.0) THEN nstom[t]=stom[t]
;if stom gt 0.0 then begin
;  nstom = stom - rate
;endif else nstom=stom

;print, nstom 
return, nstom
end