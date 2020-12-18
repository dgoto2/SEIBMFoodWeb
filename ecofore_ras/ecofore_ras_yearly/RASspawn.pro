PRO RASspawn
;yellow perch bionergetics modle with spawning and motality (30 years)

ni=1000; initial number of perch individuals
Wt=randomu(seed,ni)*(max(150)-min(50))+min(50); randomly assigned weights (g) between 50 and 150
Sex=round(randomu(x,ni)); 1=female, 0=male

i=30; 30 year simulation
for yr=1,i-1 do begin
   
   ii=365
   for JD=1,ii-1 do begin
   a=23.3
   b=49.9
   c=1.68
   JD0=237
   T0=1.78
   Temp=T0+a*exp(-0.5*(abs(JD-JD0)/b)^c); northern Lake Michigan water temperature using Gaussian distribution

;bioenergetics model for perch individuals
;parameter values of C, R, F, U for yellow perch
   RA=0.0108
   RB=-0.2
   ACT=1
   RTM=35
   RTO=32
   RQ=2.1
   FA=0.158
   UA=0.0233
   CA=0.25
   CB=-0.27
   CQ=2.3
   CTM=32
   CTO=29
   SDA=0.172
   
   ;consumption
   V_C=(CTM-Temp)/(CTM-CTO)
   Z_C=alog(CQ)*(CTM-CTO)
   Y_C=alog(CQ)*(CTM-CTO+2)
   X_C=(Z_C^2*((1+(1+40/Y_C)^0.5)^2))/400

   fT_C=V_C^X_C*exp(X_C*(1-V_C));temperature-dependent function for C
   Cmax=CA*Wt^CB
   pvalue=randomn(seed,ni)*0.1+0.7; diet=zebra mussels or diporeia mean p-value=0.7 with variance=0.1, 0<p<1
   FOR ii=0,99 do begin
   IF (pvalue[ii] LT 0) then pvalue = 0

   IF (pvalue[ii] GT 1) THEN pvalue = 1
  
   C=Cmax*pvalue*fT_C; g/g/d
   ENDIF
   ENDFOR
   
   ;metabolism
   V_R=(RTM-Temp)/(RTM-RTO)
   Z_R=alog(RQ)*(RTM-RTO)
   Y_R=alog(RQ)*(RTM-RTO+2)
   X_R=(Z_R^2*((1+(1+40/Y_R)^0.5)^2))/400

   fT_R=V_R^X_R*exp(X_R*(1-V_R));temperature-dependent function for R
   R=RA*Wt^RB*fT_R*ACT*3.1; oxicalorific coefficient=13560 J/g O2 -> 13560/4421=3.1 g prey/g O2 for diporea diet
   
   ;egestion and excretion
   F=FA*C
   U=UA*(C-F)
   S=SDA*(C-F)
   
   ;growth
   G=C-R-F-U-S
   PreyE=4429; energy desity of diporea (J/g)
   PredE=4186; energey density of yellow perch (J/g)  
   Wt=Wt+G*(PreyE/PredE)*Wt
  
   ;weight loss due to spawning
   if (JD eq 91) and (Wt[i] ge 250) then begin;JD=91->Apr-1 spawning event
   if (sex[i] eq 1) then begin; sex=1, females
   Wt=Wt-Wt*0.2; GSI=20%, weight loss for spawning
   endif
   endif else begin Wt=Wt
   endelse
   
   ;recruitment
   P=round(total(Wt[where(sex eq 1)] ge 250));number of perch spawners
   a=8.5; from walleye in Lake Erie, Madenjian et al. (1996)
   b=0.0085
   Re=round(P*a*exp((-b)*p)); number of recruits with Ricker spawner-recruitment model
   
   ;mortality
   N_dead=round(randomu(x,ni,BINOMIAL=[1,0.0005])); annual 20% mortality-> 0.2/365=0.0005 per day, 1=dead, 0=alive
   dead=where(N_dead eq 1, dead_fish)
   alive=where(N_dead eq 0, alive_fish)
   Wt=Wt[alive]  
   ni=1000-total(N_dead)

   endfor  

;adding new recruits 
   for yr=2, i-1 do begin
   if yr eq yr+1 then begin
   n2=Re; number of new individuals
   Wt_re=randomu(seed,n2)*(max(150)-min(50))+min(50); randomly assigned weights (g) between 50 and 150
   Sex_re=round(randomu(x,n2)); 1=female, 0=male
   
    for JD=92,ii-1 do begin
    ;consumption
    Cmax_re=CA*Wt_re^CB
    pvalue_re=randomn(seed,n2)*0.1+0.3; diet=chironomids mean p-value=0.3 with variance=0.1, 0<p<1
    FOR
    if (pvalue_re[n2-1] gt 0) then begin
    C_re=Cmax_re*pvalue_re*fT_C
    endif
    ENDFOR
   
    ;egestion and excretion
    F_re=FA*C_re
    U_re=UA*(C_re-F_re)
    S_re=SDA*(C_re-F_re)
   
    ;metabolism
    R_re=RA*Wt_re^RB*fT_R*ACT*3.1; oxicalorific coefficient=13560 J/g O2 -> 13560/2428=5.6 g prey/g O2 for diporea diet
   
    ;growth
    G_re=C_re-R_re-F_re-U_re-S_re
    PreyE=4429; energy desity of diporea (J/g)
    PredE=4186; energey density of yellow perch (J/g)  
    Wt_re=Wt_re+G_re*(PreyE/PredE)*Wt_re
   
    ;weight loss due to spawning
    if (JD eq 91) and (Wt_re[i] ge 250) then begin;JD=91=>Apr-1
    if (sex_re[i] eq 1) then begin; sex_re=1, females
    Wt_re=Wt_re[where(sex eq 1)]-Wt_re[where(sex eq 1)]*0.2; GSI=20%, weight loss for spawning
    endif
    endif else begin Wt_re=Wt_re
    endelse
   
    ;recruitment
    P_re=round(total(Wt_re[where(sex eq 1)] ge 250));number of perch spawners
    a=8.5; from walleye in Lake Erie,Madenjian et al. (1996)
    b=0.0085
    Re_re=round(P_re*a*exp((-b)*P_re)); number of recruits with Ricker spawner-recruitment model 
   
    ;mortality
    N_dead=round(randomu(x,Re,BINOMIAL=[1,0.0005])); annual 20% mortality-> 0.2/365=0.0005 per day, 1=dead, 0=alive
    dead=where(N_dead eq 1, dead_fish)
    alive=where(N_dead eq 0, alive_fish)
    Wt_re=Wt_re[alive] 
    
    endfor
    Wt=[Wt[*], Wt_re[*]]
    Re=Re+Re_re 
   endif
   endfor
   
;converting weight to lenghth, W=a*L^b   
Ln=exp((alog10(Wt)+5.39)/2.53);a=-5.39, b=3.23, length-weight relationship
    
endfor
print, Ln, Wt 
end