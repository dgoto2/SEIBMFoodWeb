; Plot the map of Lake Erie...Stil needs SOME work

WINDOW, TITLE='Lake Erie', Xsize = 1250, Ysize = 900
MAP_SET, 42.2, -81.2, /lambert, scale=0.9e6
position=[0, 0, 0.5, 1.0]
MAP_CONTINENTS, /HIRES, /COASTS
MAP_GRID, /BOX, CHARSIZE=1.5;, LATDEL=5, LONDEL=5

z=randomu(-100L,50,50)
for i=0,4 do z=smooth(z,15,/edge)
z=(z-min(z))*15000.+100.
x=findgen(50)-100.
y=findgen(50)+10.

map_set,42.2, -81.2,/lambert,scale=0.9e6
map_continents, /HIRES, /COASTS
map_grid
levels =[150,200,250,300,350,400,450,500]
c_labels=[0,1,0,1,0,1,0,1]
contour,z,x,y,levels=levels,c_labels=c_labels,/overplot

;MAP_SET, 20, 80, /ORTHOGRAPHIC, /ISOTROPIC;, /NONBORDER
;IMAGE = MAP_IMAGE(elev, x0,y0,xsize,ysize,latmin=-90,lonmin=-180,latmax=90,lonmax=180,compress=1,scale=0.05)
;tvscl,image,x0,yo,xsize=xsize,ysize=ysize
;color = !d.table_size-1
;map_continents, color=color
;map_grid, color=color
END