WAEdepths = fltarr(nDays,48)
YEPdepths = fltarr(nDays,48)
RASdepths = fltarr(nDays,48)
EMSdepths = fltarr(nDays,48)
depthY = findgen(48)
depth1 = 0.
depth2 = 0.
depth3 = 0.
depth4 = 0.

for ddd = 0,nDays-1 do begin
  for rr = 0,19999 do begin
    depth1 = total_dpth1[ddd,rr]
    WAEdepths[ddd,depth1] = WAEdepths[ddd,depth1] + total_popn1[ddd,rr]
    depth2 = total_dpth2[ddd,rr]
    YEPdepths[ddd,depth2] = YEPdepths[ddd,depth2] + total_popn2[ddd,rr]
    depth3 = total_dpth3[ddd,rr]
    RASdepths[ddd,depth3] = RASdepths[ddd,depth3] + total_popn3[ddd,rr]
    depth4 = total_dpth4[ddd,rr]
    EMSdepths[ddd,depth4] = EMSdepths[ddd,depth4] + total_popn4[ddd,rr]
  endfor
endfor

;levelsWAE = findgen(60)*findgen(60)*2500
;levelsYEP = findgen(60)*findgen(60)*500
;levelsRAS = findgen(60)*findgen(60)*10000
;levelsEMS = findgen(60)*findgen(60)*4500
levelsWAE = (findgen(60)^2)
levelsWAE = (levelsWAE/max(levelsWAE))*max(WAEdepths)
levelsYEP = (findgen(60)^2)
levelsYEP = (levelsYEP/max(levelsYEP))*max(YEPdepths)
levelsRAS = (findgen(60)^2)
levelsRAS = (levelsRAS/max(levelsRAS))*max(RASdepths)
levelsEMS = (findgen(60)^2)
levelsEMS = (levelsEMS/max(levelsEMS))*max(EMSdepths)


device,decomposed=0  ; use 24-bit color
loadct, 39  ; rainbow + white color table
window,0,xsize=700,ysize=500
contour,WAEdepths,axisdays,depthY,levels=levelsWAE,yrange=[47,0],/fill,$
       title='WAE Depth Distribution: '+year+', Hypoxia '+HH+', D.D. '+DD,$
       background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[152,182,212,242,272, 302],$
        xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'],color=0,xminor=1,xticks=5,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=4,maxrange=12,ncolors=255,minor=1,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','25%','50%','75%','max'],/right,/vertical
window,1,xsize=700,ysize=500
contour,YEPdepths,axisdays,depthY,levels=levelsYEP,yrange=[47,0],/fill,$
       title='YEP Depth Distribution: '+year+', Hypoxia '+HH+', D.D. '+DD,$
       background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[152,182,212,242,272, 302],$
        xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'],color=0,xminor=1,xticks=5,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=4,maxrange=12,ncolors=255,minor=1,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','25%','50%','75%','max'],/right,/vertical
window,2,xsize=700,ysize=500
contour,RASdepths,axisdays,depthY,levels=levelsRAS,yrange=[47,0],/fill,$
       title='RAS Depth Distribution: '+year+', Hypoxia '+HH+', D.D. '+DD,$
       background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[152,182,212,242,272,302],$
        xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'],color=0,xminor=1,xticks=5,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=4,maxrange=12,ncolors=255,minor=1,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','25%','50%','75%','max'],/right,/vertical
window,3,xsize=700,ysize=500
contour,EMSdepths,axisdays,depthY,levels=levelsEMS,yrange=[47,0],/fill,$
       title='EMS Depth Distribution: '+year+', Hypoxia '+HH+', D.D. '+DD,$
       background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[152,182,212,242,272,302],$
        xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'],color=0,xminor=1,xticks=5,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=4,maxrange=12,ncolors=255,minor=1,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','25%','50%','75%','max'],/right,/vertical
       
; this is how you save things: write_png,'filename.png',tvrd(/true)
; it saves the highest-numbered open graphics window
; saves to same directory where workspace is located

end