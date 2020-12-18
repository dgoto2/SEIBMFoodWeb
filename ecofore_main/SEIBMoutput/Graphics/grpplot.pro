pro grpplot, parm,menuparm,fishlen,fishwt,fishden,meantemp,lightarr,$
    depthvec,biodens,wc,grp,consrp,Gmax,cmax,consarrsp,resparr,rd,flagvec

; designed for GRPMAP26, J.A.Tyler 10 April 98

yrng=fltarr(2)
sz=size(fishlen)
nrpt=sz(1)
nstr=sz(2)

PLOTTOP:
print,''
print,''

print,'                2D plot menu '
print,''
print,'            1)  bioenergetics and lenght-weight '
print,'            2)  frequency histograms '
print,'            3)  fish length and density vs depth  '
print,'            4)  fish length and density vs temp  '
print,'            5)  RD vs Light intensity '
if(flagvec(0) lt 2) then print,'            6)  GRP vs prey biomass and temp'
print,''
print,'           99)  exit '

RESELECT:

read,'			enter plot menu selection : ',plotans1
wdelete,6
wdelete,7
wdelete,9

chrsz=1.5
case plotans1 of
  1 : begin		; bioenergetics vs. temp plots
	cmax2=cmax*(parm(35)/parm(29))
	yrng(0)=min(cmax2)
	if(min(resparr) LT yrng(0)) then yrng(0) = min(resparr)
	yrng(1)=max(cmax2)
	if(max(resparr) GT yrng(1)) then yrng(1) = max(resparr)
	window,6,xsize=350,ysize=350,title='Bioenergetics'
	plot,meantemp,cmax2,yrange=yrng,xtitle='TEMP',ytitle='g/(g d) of pred',$
		psym=1,charsize=chrsz
	xyouts,100,305,'CMAX',/device,charsize=chrsz

	oplot,meantemp,resparr,color=150,psym=4
	xyouts,100,290,'RESP',color=150,/device,charsize=chrsz
	window,7,xsize=350,ysize=350,title='Length - Weight'
	if(n_elements(where(fishlen gt 0)) gt 100) then tsym=3 else tsym=1
	plot,fishlen(wc),fishwt(wc),xtitle='LENGTH (mm)',ytitle='WEIGHT (g)',$
		psym=tsym,charsize=chrsz
      end
  2 : begin		; frequency histograms
	print,''
	print,'  Frequency histograms of:'
	print,'     fish length	'

	case flagvec(0) of
	 0:  print,'     GRP '
	 1:  print,'     Consumption Rate Potential '
	 2:  print,'     Maximum Growth  '
	endcase

	print,''
	read,'for length histogram, enter length intervals (mm) ',lenint
	fl1=where(biodens gt 0)
	lll=histogram(fishlen(fl1),binsize=lenint)
	tt1=n_elements(lll)
	lenax=indgen(fix(tt1))*lenint +fix(min(fishlen(fl1)))
	window,6,xsize=350,ysize=350,title='length frequency'
	plot,lenax,lll,xtitle='LENGTH (MM)',ytitle='FREQUENCY',$
		psym=10,charsize=chrsz
	print,''
	case flagvec(0) of
	 0 : begin
		print,'enter number of bins: '
		read,'for BIOMASS and GRP histograms: ',binum
		binint=((max(grp(fl1)))-min(grp(fl1)))/binum
		ggg=histogram(grp(fl1),binsize=binint)
		tt1=n_elements(ggg)
		ax=indgen(fix(tt1))*binint +(min(grp(fl1)))
		window,7,xsize=350,ysize=350,title='GRP frequency'
		plot,ax,ggg,xtitle='GRP (g/g/d)',ytitle='FREQUENCY',psym=10,$
		   charsize=chrsz
	     end
	 1 : begin
		print,'enter number of bins: '
		read,'for BIOMASS and Consumption Potential histograms: ',binum
		binint=(max(consrp)-min(consrp))/binum
		ggg=histogram(consrp(fl1),binsize=binint)
		tt1=n_elements(ggg)
		ax=indgen(fix(tt1))*binint +(min(consrp(fl1)))
		window,7,xsize=350,ysize=350,title='Cons Potential freq'
		plot,ax,ggg,xtitle='Cons Poten (g/d)',ytitle='FREQUENCY',psym=10,$
		   charsize=chrsz
	     end
	 2 : begin
		print,'enter number of bins: '
		read,'for BIOMASS and Maximum Growth histograms: ',binum
		binint=(max(Gmax)-min(Gmax))/binum
		ggg=histogram(Gmax(fl1),binsize=binint)
		tt1=n_elements(ggg)
		ax=indgen(fix(tt1))*binint +(min(Gmax(fl1)))
		window,7,xsize=350,ysize=350,title='Gmax freq'
		plot,ax,ggg,xtitle='Gmax potential (g/g/d)',ytitle='FREQUENCY',$
		   psym=10,charsize=chrsz
	     end
	endcase
	binint=((max(biodens(fl1)))-min(biodens(fl1)))/binum
	logbdens=alog10(biodens(fl1))
	bbb=histogram(logbdens,binsize=binint)
	tt1=n_elements(bbb)
	bdax=indgen(fix(tt1))*binint +(min(biodens(fl1)))
	window,9,xsize=350,ysize=350,title='Biomass Density frequency'
	xrng=fltarr(2)
	xrng(0)=0.001
	xrng(1)=10.0
	plot_OI,bdax,bbb,xtitle='Biomass density (g/m^3)',ytitle='FREQUENCY', $
	    psym=10,xrange=xrng,charsize=chrsz
      end	
  3 : begin		; fish length with depth
	deptharr=fishlen*0.
	mlenvec=depthvec*0.
	tlenvec=mlenvec
	fnumvec=depthvec*0.
	for i=0,nstr-1 do begin
		deptharr(*,i)=depthvec(i)
		ttvec1=fishlen(*,i)
		validlen=where(ttvec1 gt 0,nvalid)
		if(nvalid gt 0) then begin 
		   tlenvec(i) = total(ttvec1(validlen))
		   mlenvec(i)=tlenvec(i)/float(nvalid) 
		 endif else begin
		     tlenvec(i)=0.
		     mlenvec(i)=0.
	         endelse
		fnumvec(i)=nvalid
	endfor
	fl1=where(fishlen gt 0)
	yrng=fltarr(2)
	yrng(0)=max(deptharr(wc))+0.5
	yrng(1)=min(depthvec)-0.5
	;xrng=fltarr(2)
	if(n_elements(where(fishlen gt 0)) gt 100) then tsym=3 else tsym=1
	window,6,xsize=350,ysize=350,title='fishlen v depth'
	plot,fishlen(fl1),deptharr(fl1),ytitle='DEPTH (m)',xtitle='FISH LENGTH (mm)',$
		psym=tsym,yrange=yrng,charsize=chrsz
	window,7,xsize=350,ysize=350,title='mean fishlen v depth'
	plot,mlenvec,depthvec,ytitle='DEPTH (m)',xtitle='MEAN FISH LENGTH (mm)',$
		psym=2,yrange=yrng,charsize=chrsz
	window,9,xsize=350,ysize=350,title='fish number v depth'
	plot,fnumvec,depthvec,ytitle='DEPTH (m)',xtitle='FISH NUMBER',$
		psym=4,yrange=yrng,charsize=chrsz
	oplot,fnumvec,depthvec
      end
  4 : begin	; fish len vs. temp 
	fl1=where(fishlen gt 0)
	;read,' enter resolution of temperature range: ',tinc
	tinc=0.5
	tmn=fix(min(meantemp(wc))) 
	tmx=fix(max(meantemp(wc))) +1
	tbin=(tmx-tmn)/tinc
	tempvec=(indgen(tbin)*tinc)+tmn
	mlenvec=tempvec*0.
	fnumvec=tempvec*0
	for i = 0, tbin-2 do begin
	  xxx=where((meantemp(wc) ge tempvec(i)) and (meantemp(wc) lt tempvec(i+1)) $
		and (fishlen(wc) gt 0),xxn)
	  if(xxn gt 0) then mlenvec(i)=total(fishlen(xxx))/xxn $
	     else mlenvec(i)=0
	  fnumvec(i)=xxn
	endfor
	yrng=fltarr(2)
	yrng(0)=fix(min(fishlen(fl1)))
	yrng(1)=fix(max(fishlen(wc)))+2
	if(n_elements(where(fishlen gt 0)) gt 100) then tsym=3 else tsym=1
	window,6,xsize=350,ysize=350,title='fishlen v temp'
	plot,meantemp(fl1),fishlen(fl1),xtitle='TEMP',ytitle='FISH LENGTH (mm)',$
		psym=tsym,yrange=yrng,charsize=chrsz
	window,7,xsize=350,ysize=350,title='mean fishlen v temp 
	plot,tempvec,mlenvec,xtitle='TEMP',ytitle='MEAN FISH LENGTH (mm)',$
		psym=10,charsize=chrsz
	window,9,xsize=350,ysize=350,title='fish number v temp'
	plot,tempvec,fnumvec,xtitle='TEMP',ytitle='FISH NUMBER',$
		psym=10,charsize=chrsz
      end
  5 : begin		; RD vs light
	window,6,xsize=350,ysize=350,title='RD vs Lux'
	fl1=where(fishlen gt 0)
	if(n_elements(where(fishlen gt 0)) gt 100) then tsym=3 else tsym=4
	plot_OI,lightarr(fl1),rd(fl1),xtitle='LUX',ytitle='RD (mm)',psym=tsym,$
	   charsize=chrsz
      end
  6 : begin
	tmn=min(meantemp)
	tmx=max(meantemp)
	tstr=''
; set up temperature field
GETTEMP:
	print,''
	print,'range of temperatures in transect:  ',tmn,tmx
	read,' ENTER to use this range or enter a new MINIMUM: ',tstr
	if(tstr ne '') then begin
	   tmn=float(tstr)
	   if((tmn lt -3) or (tmn gt 40)) then goto, GETTEMP
	   read,'   enter new MAXIMUM of temperature range: ',tstr 
	   tmx=float(tstr)
	   if((tmx lt tmn) or (tmx gt 60)) then goto, GETTEMP
	endif
;	read,' enter increment of temperature field: ',tempinc
	tempinc=0.5
	tbin=fix((tmx-tmn)/tempinc) + 1

	bdmn=min(biodens(where(biodens gt 0)))
	bdmx=max(biodens)
	foodmn=.01
	foodmx=10.
GETFOOD:
	print,''
	print,'range of food biomass density in transect: ',bdmn,bdmx
	print,'DEFAULT food biomass density range for plot is:  ',foodmn,foodmx
	print,'food density will be plotted with a LOG axis'
	read,' ENTER to use this range or enter a new MINIMUM: ',tstr
	if(tstr ne '') then begin
	   foodmn=float(tstr)
	   read,'   enter new MAXIMUM of food biomass density range: ',tstr 
	   foodmx=float(tstr)
	endif
	;read,' enter increment of food field: ',foodinc
	flogmn=fix(alog10(foodmn)-0.5)
	flogmx=fix(alog10(foodmx)+0.5)

	fbin=fix((flogmx-flogmn)/0.1) + 1

	flogax=fltarr(tbin,fbin)
	tempax=fltarr(tbin,fbin)
	nularr=intarr(tbin,fbin)
	for i=0,tbin-1 do tempax(i,*)=tmn+(i*tempinc) 
	for i=0,fbin-1 do flogax(*,i)=flogmn+(i*0.1) 
	foodax=10^flogax

	tlenarr=nularr+fishlen
	CONSLIGHT20, menuparm,parm,tlenarr,nularr,foodax,tconsarr,trd
	tpredwt=nularr+menuparm(21)
	GRPCMAX1, tpredwt,parm,tempax,tcmax
	tfr=tconsarr
	tconsarr=tfr<tcmax
	tconsarr=tconsarr *(parm(35)/parm(29)) ; energy density conversion
	tP=tconsarr/tcmax
	tpp1=where(tP gt 1.0,tnp1)
	if(tnp1 gt 0) then tP(tpp1)=1.0
	tft=0
	tresparr=nularr
	GRPRESP1, tpredwt,parm,tempax,tresparr
	tegesarr=nularr & texcrarr=nularr & tsdaarr=nularr
	GRPEGEX1, parm,tempax,tconsarr,tP,tegesarr,texcrarr,tsdaarr
	tgrp=tconsarr -(tresparr+tegesarr+texcrarr+tsdaarr)

	read,' enter number of levels in contour plot ',tlevel
	ttmn=min(tgrp)
	ttmx=max(tgrp)
	ttm=moment(tgrp)
	print,''
	print,'plotted GRP:     mean      min       max '
	print,format='(15x,f8.5,2x,2(f8.5,2x))',ttm(0),ttmn,ttmx
	print,''

	window,6,xsize=400,ysize=400,title='GRP v Temp & Prey Biomass'
	contour,tgrp,tempax,flogax,xtitle='TEMP',ytitle='Log(Prey Biomass(g))',$
		charsize=chrsz,nlevels=tlevel,color=60


      goto, PLOTTOP
      end ; plotans=6
  99 : begin
	wdelete,6
	wdelete,7
	wdelete,9
      end
  else : begin
	  print,' no such option. '
	  print,''
	  goto,PLOTTOP
	 end
endcase

if (plotans1 lt 99) then goto, RESELECT


end
