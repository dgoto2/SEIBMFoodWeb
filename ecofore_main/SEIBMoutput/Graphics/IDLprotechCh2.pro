; Chapter 2

Grid2D = GridCells2D()
lon=Grid2D[0,*]
lat=Grid2D[1,*]
depth=Grid2D[3,*]


;curve=loaddata(1)
;time=findgen(101)*(6./100)
;
;;Customizing graphics plots**********************
;;plot, time, curve, linestyle=2
;
;
;;*****IF THERE IS NO PLOT, USE DECOMPOSITION****
;DEVICE, DECOMPOSED=0
;
;
;;; Drawing line plots in color****************** TvLCT
;tvlct, [70, 255, 0], [70, 255, 255], [70, 0, 0], 1
;;plot, time, curve, color=2, background = 1
;
;; if you want to change color in the line only.... 
;plot, time, curve, color=2, background = 1., /NODATA
;oplot, time, curve, color=3
;
;
;;if you don't want axis or change its style...
;plot, time, curve, xstyle=8, ystyle=8


;Creating surface plots
peak = loaddata(2)
;help,peak
;surface,peak,charsize=1.5

lat=findgen(41)*(24./40)+24;24 to 48
lon=findgen(41)*(50./40)-122;-122 to -72
;surface, peak,lon,lat,xtitle='longitude', ytitle='latitude', charsize=1.5

; Customizing surface plots
;xyouts, 0.5, 0.09, /normal, siz=2., align=0.5, 'mt.elbert'

; rotating suraface plots
;surface, peak, lon, lat, az=60, ax=35, charsize=1.5; default is 30 degrees


; adding color to a surface plot
;TvLCT, [70,255,0], [70,255,255], [70,0,0], 1
;device, decomposed=0
;surface, peak, color=2, background=1, bottom=3

; to draw axes in different color...
;surface, peak,color=3,/nodata; axes only
;surface, peak, /noerase, color=2, bottom=1, xstyle=4, ystyle=4, zstyle=4

;; draw the mesh lines of the surface in different colors representing a different data paprameter 
snow=loaddata(3)
;help,snow
;surface,snow
;
;loadCT,5; load the color scheme
;surface, peak, shades = bytscl(snow, top=!D.table_size-1); "shades" need to be in the same dimension as "z"
;;bytscl is used for scaling data
;surface, peak, shades=bytscl(peak,top=!D.table_size-1)


;MODIFYING THE APPEARANCE OF A SURFACE PLOT
;surface, peak, skirt=0
;surface, peak, skirt=500, az=60

;surface, peak,/horizontal

;surface, peak,/upper_only
;surface, peak,/lower_only

;surface, peak,xstyle=4,ystyle=4,zstyle=4;*****NO AXES*****

; Creating shaded surface plots
;shade_surf, peak

;shade_surf, peak, lon,lat,az=45,ax=30; rotate

; changing shade parameters
;set_shading, light=[1,0,0]; defaul light source is [0,0,1]
;shade_surf,peak

;loadct,3, ncolors=100, bottom=100
;set_shading, values=[100,199]
;shade_surf,peak

;loadct,5
;set_shading, light=[0,0,1], values=[0,!D.table_size-1]

; using another data set for the shaded values
;shade_surf,snow
;shade_surf,peak,shades=bytscl(snow,top=!d.table_size)

;shade_surf,peak,shades=bytscl(peak,top=!d.table_size)

;*****Draping the original original surface ON TOP OF the shaded surface********
;shade_surf,peak
;surface, peak,/noerase



; Creating countour plots
;peak = loaddata(2)
;help,peak
;CONTOUR, peak, charsize=1.5

lat=findgen(41)*(24./40)+24;24 to 48
lon=findgen(41)*(50./40)-122;-122 to -72
;contour, peak, lon, lat, xtitle='longitude',ytitle='latitude'

;print, min(lon), max(lon)
;print, min(lat), max(lat)

;TO SPECIFY THE RANGE IN AXES...
;contour, peak, lon, lat, xtitle='longitude',ytitle='latitude', xstyle=1, ystyle=1

;contour, peak, lon, lat, xtitle='longitude',ytitle='latitude', xstyle=1, ystyle=1, /follow
;/FOLLOW 


;selecting contour levels
;by default, 6 regularly spaced contour intervals (5 lines)

;contour, peak, lon, lat, xtitle='longitude',ytitle='latitude', xstyle=1, ystyle=1,/follow, nlevels=12
; idl gives only incomplete levels

;vals=[200,300,600,750,800,900,1200,1500]
;contour, peak, lon, lat, xtitle='longitude',ytitle='latitude', xstyle=1, ystyle=1,/follow, levels=vals

;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, levels=vals, c_labels=[1,0,1,0,0,1,1,0]; 1=label, 0=no label

;nlevels=12
;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, levels=vals, c_labels=replicate(1,nlevels)


; Modyfying a contour plot

;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, xtitle='longitude',ytitle='latitude', $
;charsize=1.5, title='studyarea 13f89', nlevels=10

;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, xtitle='longitude',ytitle='latitude', $
;charsize=1.5, title='studyarea 13f89', c_annotation=['low','middle','high'],levels=[200,500,800]

;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, nlevels=9,c_linestyle=[0,0,2]


;adding color to a contour plot
;tvlct, [70,255],[70,255],[70,0],1
;device, decomposed=0
;contour, peak, lon, lat, xstyle=1, ystyle=1,nlevels=10, color=2, background=1,/follow

; DIFFERENT COLORS FOR CONTOURS
;tvlct,0,255,0,3
;contour, peak, lon, lat, xstyle=1, ystyle=1,/follow, nlevels=10, color=2, background=1,c_colors=3

;tek_color; DIFFERENT COLORS FOR EACH LINE
;tvlct, [70,255],[70,255],[70,0],1
;contour, peak, lon, lat, xstyle=1, ystyle=1,nlevels=10, color=2, background=1,c_colors=indgen(10)+2,/follow

;contour, peak, lon, lat, xstyle=1, ystyle=1,nlevels=12, color=2, background=1,c_colors=[3,3,4],/follow


;creating a filled contour plot
;loadct,0
;loadct,4, ncolors=12, bottom=1
;contour, peak, lon, lat, xstyle=1, ystyle=1,/fill,nlevels=12,/follow,c_colors=indgen(12)+1, $
;background=!p.color,color=!p.background
; this code has a 'hole' in the middle

;step=(max(peak)-min(peak))/12.
;clevels=indgen(12)*step+min(peak)
;contour, peak, lon, lat, xstyle=1, ystyle=1,/fill,levels=clevels,/follow,c_colors=indgen(12)+1, background=!p.color,color=!p.background
; good idea to always define your own contour levels, especially when you have a color bar

;when plots have missing data or extends off the edge...
;contour, peak, lon, lat, xstyle=1, ystyle=1,/fill,levels=clevels,c_colors=indgen(12)+1, /cell_fill
;this is usefull when superimposing contour plot onto map

; when  cell filling damages plot axis....
;contour, peak, lon, lat, xstyle=1, ystyle=1,levels=clevels,/nodata,/noerase,/follow

;to put line on the contour plot...
;contour, peak, lon, lat, xstyle=1, ystyle=1, levels=clevels,/fill,c_colors=indgen(12)+1
;contour, peak, lon, lat, xstyle=1, ystyle=1, /follow, levels=clevels,/overplot


;adding texts with the xyouts command
curve=loaddata(1)
time=findgen(101)*(6./100)
;plot, time, curve, position=[0.15,0.15, 0.95, 0.85]
;xyouts,0.5,32,'results:experiment 35f3a', size=2.; adding texts



; Adding lines and symbols to graphical displays*************************************************

;window, xsize=500, ysize=400
;plot, time, curve
;xvalues = [0,6]
;yvalues = [15,15]
;plots, xvalues, yvalues, linestyl=2;  use PlotS for adding symbols or lines

;tvlct, [70,255,0],[70,255,250],[70,0,0],1
;plot, time, curve, background=1, color=2
;index = indgen(20)*5; adding marker symbols
;plots, time[index], curve[index], psym=4, color=3, symsize=2


;tvlct, [70,255,0],[70,255,250],[70,0,0],1
;device, decomposed=0
;plot, time, curve, background=1, color=2
;box_x_coords=[.4,.4,.6,.6,.4]; adding a box in the plot to emphasize
;box_y_coords=[.4,.6,.6,.4,.4]
;plots, box_x_coords, box_y_coords,color=3,/normal
;xyouts, .5,.3, 'critical zone', color=3, size=2, alignment=.5, /normal


;; Adding color to your graphical displays -> Polyfill****************************
;tvlct, 255,0,0,4
;erase, color=1
;polyfill, box_x_coords, box_y_coords, color=4, /normal
;plot, time, curve, background=1, color=2,/noerase
;plots, box_x_coords, box_y_coords,color=3,/normal
;xyouts, .5,.3, 'critical zone', color=3, size=2, alignment=.5, /normal

; To use color to represent another dimension property of a data set**********
; first, create some randomly-located x and y data
seed = -3l
x=randomu(seed, 30)
y=randomu(seed, 30)
z=randomu(seed, 30);(3*(x-0.5)^2)+5*((y-0.25)^2)*1000; a function of x and y

window, xsize=400, ysize=350
plot, x, y, psym=4, position=[.15,.15,.75,.95], xtitle='x locations', ytitle='y locations'

; to display the z data associated with each xy point pair as a circle
loadct,2
zcolors=bytscl(z,top=!d.table_size-1)

; to avoid non-circle points in a graph
coords=convert_coord(x,y,/data,/to_device)
x=coords(0,*)
y=coords(1,*)

for j=0,29 do polyfill, circle(x(j), y(j), 10), /fill, color=zcolors(j),/device

colorbar, position=[.85,.15,.9,.95], range=[min(z),max(z)],/vertical, format='(i5)', title='z values'











;window, xsize=600,ysize=600
;!p.MULTI=[0,2,2]
;x_lo=findgen(50)/4
;y_lo=findgen(50)/4
;z_lo=sin(!pi*x_lo)#sin(!pi*y_lo)*0
;plot, x_lo,y_lo














end
