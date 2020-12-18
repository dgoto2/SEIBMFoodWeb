; chapter 4

;specifying colors on an 8-bit display
;tvlct, 0,255,0,180;
;data=loaddata(1)
;plot,data, color=180

;specifying decomposed colors on a 24-bit dislay
;plot, data, color=65535L

;plot,data,color='00ffff'xl, background='464646'xl
;xyouts,.5,.95,align=.5,/normal, 'plot title', color='00ff00'xl


;plot, data, color=color24([255,255,0])


;********************skip some color secitons*********************************


;;creating your own axis annotations
;curve=loaddata(1)
;;loadct,5
;;plot, curve
;;plot, curve,xticks=10,xminor=2
;;plot, curve, xtickformat='(i3.3)'
;;plot, curve, xtickformat='(f6.2)'
;labels = ['mon','tue','wed','thu','fri','sat']
;plot, curve, xtickname=labels
;plot, curve,xtickformat='(A1)'
;
;window, xsize=500, ysize=350
;startdate = julday(1,1,1991)
;enddate = julday(6,23,1995)
;numticks=5
;sizecurve = n_elements(curve)
;steps = findgen(sizecurve)/(sizecurve-1)
;dates =startdate +(enddate+1 -startdate)*steps
;!P.charsize =0.8
;;plot, dates, curve, xtickformat='date',xstyle=1, xticks=numticks, position=[.15,.15,.85,.95]
;
;;to tilt date on x label
;plot, dates, curve, xtickformat='(a1)', xstyle=1,xticks=numticks, xtick_get=tickvalues, position=[.15,.15,.85,.95]
;ypos =replicate(!y.window[0] -0.04,numticks+1)
;xpos = !x.window[0]+(!x.window[1] - !x.window[0])*findgen(numticks+1)/numticks
;for j=0, numticks do xyouts, xpos[j], ypos[j], date(0,j,tickvalues[j]), alignment=0., orientation=-45,/normal


;;handling missing date in IDL
;data = loaddata(2)
;!p.charsize=1.0; graphics system variable
;baddata =data
;baddata[*,30:32]=!values.f_nan
;surface, baddata
;
;; setting min and max values to ignore
;window, xsize=500, ysize=375
;!p.multi = [0,2,1,0,1]
;values = findgen(10)*150+100
;label=replicate(1,10)
;contour, data, levels=values,/follow,c_labels=label
;contour,data,levels=values,/follow,c_labels=label,min_value=400,max_value=1000
;!p.multi=0


;***********************skip some sections here**************************************


; animating data in idl-> use XInterAnimate -> this needs to be used 3 times

;head =loaddata(8)
;xinteranimate,set=[80,100,57], /showload; there are 57 frames
;for j=0,56 do xinteranimate, frame=j, image=head[*,*,j]
;xinteranimate


;xinteranimate, set=[256,320,57],/showload
;yellow=getcolor('yellow',!d.table_size-2)
;loadct,3, ncolors=!d.TABLE_SIZE-2
;for j=0,56 do begin
;tvimage, bytscl(head[*,*,j],top=!d.TABLE_SIZE-3)
;xyouts,0.1,0.1,/normal, strtrim(j,2), color=yellow
;endfor
;xinteranimate, 50


data=loaddata(14)
lon=data[0,*]
lat=data[1,*]
value=data[2,*]

loadct,0
tvlct,[70,255,0],[70,255,255], [70,0,0],1
window, xsize=400,ysize=400
plot,lon,lat,/ynozero,/nodata,background=1
plots,lon,lat,psym=5,color=2,symsize=1.5

triangulate, lon, lat, angles

for j=0,69 do begin t =[angles[*,j], angles[0,j]] & $
plots, lon[t], lat[t], color=3 & endfor

latmax=50.
latmin=20.
lonmax=-70.
lonmin=-130.
mapbounds=[lonmin,latmin, lonmax,latmax]
mapspacing=[.5,.25]
griddata=trigrid(lon,lat,value,angles,mapspacing, mapbounds, missing=min(value),xgrid=gridlon, ygrid=gridlat)
contour, griddata, gridlon, gridlat,/follow,nlevels=10,xstyle=1, background=1, color=2


;*****************************************************
; the following creates lake erie central basin grid---> use example 6 in "ex grid"
Grid2D = GridCells2D()
lon=TRANSPOSE(Grid2D[0,*])
lat=TRANSPOSE(Grid2D[1,*])
DEPTH=TRANSPOSE(Grid2D[3,*])

;scaled = BYTSCL(value, TOP = !D.TABLE_SIZE - 4) + 1B
;DEVICE, DECOMPOSED = 0
;LOADCT, 38

DEVICE, DECOMPOSED=0

LOADCT, 0
TVLCT, [70,255,0], [70,255,255], [70,0,0], 1
WINDOW, xsize=1250,ysize=1000
PLOT, lon, lat, /ynozero, /nodata, background = 5, TITLE = 'Lake Erie Central Basin', $
 CharSize=1.3,xstyle=4,ystyle=4,zstyle=4;

PLOTS, lon, lat, psym = SYM(5), color = 2, symsize = 1.65 ;, sym_filled=1,SYM_FILL_COLOR=0

;box_x_coords = lat gt 50; adding a box in the plot to emphasize
;box_y_coords = lat gt 100
;polyfill, box_x_coords, box_y_coords, color=4, /normal
;plots, lon[box_x_coords], lat[box_y_coords], psym = SYM(5), color = 3, symsize = 1.65 ,/normal

index = where(depth gt 20., indexcount); marker symbols
if indexcount gt 0. then plots, lon[index], lat[index], psym=SYM(5), color=3, symsize=1.65


;; Create data representing the sine wave
;theory = SIN(2.0*FINDGEN(200)*!PI/25.0)*EXP(-0.02*FINDGEN(200))

;; Create the plot
;iplot = PLOT(lon, lat, /scatter, "b4S-", TITLE="Lake Erie Central Basin")
;
;; Set some properties
;plot.SYM_INCREMENT=10
;plot.SYM_COLOR="blue"
;plot.SYM_FILLED=1
;plot.SYM_FILL_COLOR=0


; Now display the data values with respect to the color table.
;FOR i = 0L, (N_ELEMENTS(lon) - 1) DO PLOTS, lon[i], lat[i], PSYM = 6, SYMSIZE = 1.52, COLOR = scaled[i]


;polyfill, lon,lat, /fill, color=175,/device


loadct,2
zcolors = bytscl(depth, top=!d.table_size-1)
for j=0,3874 do polyfillv, Grid2D[0, j], Grid2D[1, j], /fill, color=zcolors(j), /device

;*******************************************************





















end