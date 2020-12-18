; Latest version: 05/29/09 15:30
; Developed by Kristi Arend, Purdue University
; Purpose: create gridded plot of color-coded GRP, consumption, etc. data by date and depth as a fish grows
;          overplot lines showing the minimum and maximum depths at which maxGRP occurs on each date
; Plotting based on Greg Lang code provided to K. Arend; file, "Greg_test.pro.pro"
;-------------------------------------------------------------------------------------------------------------------

; ENTER THE FOLLOWING INFORMATION

; enter the species you want to plot; 'YP'=yellow perch, 'RS'=rainbow smelt; 'RG'=round goby; 'ES'=emerald shiner
species='RS'

; enter if plotting GRP (0) or consumption (1)
rate_to_plot=0

; choose whether or not to activate the DO multiplier (effect on Cmax)
;  0 = no effect, 1 = effect on Cmax
oxyeffect=1

; set the ageclass you want to plot; YOY (YP,RS),juv (RS),adult (all spp)
ageclass='adult'

; set proportion of maximum consumption you want to plot
setp=0.50

; set if fish grows or not (0=no, 1=yes)
fishgrow=0

;-------------------------------------------------------------------------------------------------------------------
; THANK YOU; THE REST WILL TAKE CARE OF ITSELF (UNLESS YOU WANT TO CHANGE THE COLOR TABLE)

; loop through years to import data from all temp files
; specify years to loop through
years=['87','88','89','90','91','92','93','94','95','96','97',$
    '98','99','00','01','02','03','04','05']
    
;loop through years    
for k=0,18 do begin
  
  digits=years[k]

; set prow=doy*depths, pcol=doy
  prow=12432.
  pcol=259.

; create files to import
  ; round p value and turn into string for filename
  pround=round(setp*100)
  pval=string(pround)
  
  ; create species-specific filename labels
  GRPgrow=species+'_GRPgrow'
  DO_GRPgrow=species+'_DO_GRPgrow'
  Consgrow=species+'_Consgrow'
  DO_Consgrow=species+'_DO_Consgrow'
  Spsize=species+'size'
  DO_Spsize=species+'_DO_size'
  DepthMaxGRP=species+'_Depth maxGRP'
  DO_DepthMaxGRP=species+'_DO_Depth maxGRP'

  ; create filenames
  GRin=GRPgrow+digits+'_'+ageclass+'p'+pval+'.txt'
  GRin_DO=DO_GRPgrow+digits+'_'+ageclass+'p'+pval+'.txt'
  CRin=Consgrow+digits+'_'+ageclass+'p'+pval+'.txt'
  CRin_DO=DO_Consgrow+digits+'_'+ageclass+'p'+pval+'.txt'
  Spdepth=DepthMaxGRP+digits+'_'+ageclass+'p'+pval+'.txt'
  Spdepth_DO=DO_DepthMaxGRP+digits+'_'+ageclass+'p'+pval+'.txt'
  
  
; open files based on species, ageclass, chosen rate to plot, oxygen effects, and whether or not fish was allowed to grow
  ; specify name of Out files folder
  If species eq 'YP' then Outfiles='Out files' else $
  Outfiles=Species+'_Out files'
 
  if rate_to_plot eq 0 then begin
    if oxyeffect eq 0 then begin
      if fishgrow eq 0 then filename=filepath(GRin, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
        filename=filepath(GRin, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
        openr, lun, filename, /GET_LUN 
    endif else begin
      if fishgrow eq 0 then filename=filepath(GRin_DO, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
        filename=filepath(GRin_DO, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
        openr, lun, filename, /GET_LUN
    endelse  
    GRP=fltarr(1,prow)
    readf, lun, GRP
    free_lun, lun 
  endif else begin
    if oxyeffect eq 0 then begin
      if fishgrow eq 0 then filename=filepath(CRin, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
        filename=filepath(CRin, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
        openr, lun, filename, /GET_LUN 
    endif else begin
      if fishgrow eq 0 then filename=filepath(CRin_DO, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
        filename=filepath(CRin_DO, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
        openr, lun, filename, /GET_LUN
    endelse
    Consum=fltarr(1,prow)
    readf, lun, Consum
    free_lun, lun
  endelse

  ; import depths fish occupies at max GRP
  if oxyeffect eq 0 then begin
    if fishgrow eq 0 then filename=filepath(Spdepth, root_dir=['C:'],$
      subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
      filename=filepath(Spdepth, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
      openr, lun, filename, /GET_LUN 
  endif else begin
    if fishgrow eq 0 then filename=filepath(Spdepth_DO, root_dir=['C:'],$
      subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Nogrowth']) else $
      filename=filepath(Spdepth_DO, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Outfiles,'Growth'])
      openr, lun, filename, /GET_LUN
  endelse
  Spdepth=fltarr(2,pcol)
  readf, lun, Spdepth
  free_lun, lun

; import dates (DOY) shared by all years
filename=filepath('alldates.txt', root_dir=['C:'],subdir=['Documents and Settings','karend','My Documents','IDL','In files'])
openr, lun, filename, /GET_LUN
dates=fltarr(1,261)
readf, lun, dates
free_lun, lun

; create a vector of dates that repeats a series of each year's dates
newdates=dates[1:pcol]
pdates=fltarr(1,prow)
endindex=prow-48
lastcol=pcol-1
for i=0,endindex,pcol do begin
  pdates[i:i+lastcol]=newdates
endfor

; create vector of depths with each depth repeating within each series of dates
;  e.g., depth 0.25 occurs for all dates in the first series of days 91-364
newdepths=fltarr(1,prow)
depths=replicate(0.25,pcol)

for j=0,endindex,pcol do begin
  newdepths[j:j+lastcol]=depths
  depths=depths+0.50
endfor

; set param as either GRP or consumption rate  
param=fltarr(1,prow)
if rate_to_plot eq 0 then param=GRP else $
param=Consum

x=pdates
y=newdepths

; set to lowest and highest possible values, across years and conditions for each rate
if species eq 'YP' then begin
  if ageclass eq 'YOY' then begin
    if rate_to_plot eq 0 then begin
      minval=-.0215
      maxval=.0218
    endif else begin
      minval=0.0
      maxval=0.057
    endelse
  endif
endif else begin
  if ageclass eq 'YOY' then begin
    if rate_to_plot eq 0 then begin
      minval=-0.0215
      maxval=0.0218
    endif else begin
      minval=-0.0
      maxval=0.0905
    endelse
  endif
endelse

if species eq 'RS' then begin
  if ageclass eq 'juv' then begin
    if rate_to_plot eq 0 then begin
      minval=-.0215
      maxval=.0218
    endif else begin
      minval=0.0
      maxval=0.00725
    endelse
  endif
endif

if species eq 'YP' then begin  
  if ageclass eq 'adult' then begin
    if rate_to_plot eq 0 then begin
      minval=-0.0215
      maxval=0.0218
    endif else begin
      minval=0.0
      maxval=0.057
    endelse
  endif
endif else begin
  if species eq 'RS' then begin
    if ageclass eq 'adult' then begin
      if rate_to_plot eq 0 then begin
        minval=-.0215
      maxval=.0218
      endif else begin
        minval=-0.0
        maxval=0.0431
      endelse
    endif
  endif else begin
    if species eq 'RG' then begin
      if rate_to_plot eq 0 then begin
        minval=-0.0215
        maxval=0.0218
      endif else begin
        minval=0.0
        maxval=0.0375
      endelse
    endif else begin
      if species eq 'ES' then begin
        minval=-0.0215
        maxval=0.0218
      endif
    endelse
  endelse
endelse




; activate color, rainbow color table, background and line/text color, etc.
device, decomposed = 0
;activate color table (loadct); rainbow = 13, grayscale = 0
loadct, 13
stretch
tvlct, 255, 255, 255, 0
tvlct, 0, 0, 0, 255
!p.background=0
!p.color=255
!p.charsize=1.5
color2=255

; calculate x and y axis ranges (just < smallest x; just > largest x; = smallest and largest y)
xm1=min(x)-0.5
xm2=max(x)+.5
ym1=max(y)
ym2=min(y)

; create figure titles
GRtitle=ageclass+' '+digits+' '+'GRP: no DO effects '+'p'+pval
GRtitle_DO=ageclass+' '+digits+' '+'GRP: DO effects '+'p'+pval
CRtitle=ageclass+' '+digits+' '+'Consumption: no DO effects '+'p'+pval
CRtitle_DO=ageclass+' '+digits+' '+'Consumption: DO effects '+'p'+pval

; choose figure title based on chosen rate and oxygen effects
if rate_to_plot eq 0 then begin
  if oxyeffect eq 0 then figtitle=GRtitle else $
    figtitle=GRtitle_DO  
endif else begin
  if oxyeffect eq 0 then figtitle=CRtitle else $
    figtitle=CRtitle_DO
endelse

; create skeleton plot (i.e, axes), with x-axis and y-axis ranges set to just less than or greater than the smallest
;   and largest x and y values, respectively (xm1,xm2,ym1,ym2)
plot,x,y,xran=[xm1,xm2],yran=[ym1,ym2],/nodata,charsize=1.5,xstyle=1.,ystyle=1.,$
xtitle='Day of year',$
ytitle='Depth (m)',$
title=figtitle,color=color2,thick=1.5

; n is the number of color divisions
; maxval and minval represent the max and min values of ranges of values to be plotted as a color (on the x and y axis)
n=254
; del determines the range of values within each color division
del=(maxval-minval)/(n-1)

print,del
ntot=0
ic=0
col=1+indgen(n)

; define the symbol dimensions; want the symbol to be large enough (in x and y dimensions) to fill in the entire
;   cell for each x,y coordinate (so colors "meet" and you get a continuous color plot, without white space in between
;   the symbols/plotted values
x1=0.29
y1=1.3
usersym,[-x1+0.01,-x1+0.01,x1,x1],[-y1,y1,y1,-y1],/fill

; Only plots parameter values that fall within the range of color values
for i=minval,maxval,del do begin
   index=where(param gt i-del and param le i+del,nL)
   if index[0] ne -1 then begin
   L=index
   ; psym=8 sets symbol to user-defined (as defined above) and color to ic, which starts at the first value in the color
   ;    vector, but is replaced each subsequent value as determined below (ic=ic+1)
   plots,x(L),y(L),psym=8,color=col(ic),$
   ; define clip to specify the coordinates of the lower left and upper right corners of the
   ;    rectangle to use to specify the graphics output; to enable, must include noclip=0
   clip=[xm1+0.7,ym1,xm2,ym2+0.08],noclip=0
   endif
   ic=ic+1
endfor

;overplot points marking maxGRP to create lines on the color plot showing depth at maximum
;   GRP on any given day of year
oplot, x, Spdepth[1,*], linestyle=2
oplot, x, Spdepth[0,*],linestyle=0
;  legend, ['min depth','max depth'], /right_legend, linestyle=[2,0], charsize=1.2, box=0
  
; read and write plot as jpeg or tiff file

;create output file names
GRpic=digits+species+'_'+ageclass+'_p'+pval+'_GRPgrow.jpeg'
GRpic_DO=digits+species+'_'+ageclass+'_p'+pval+'_GRPgrow_DO.jpeg'
CRpic=digits+species+'_'+ageclass+'_p'+pval+'_Consgrow.jpeg'
CRpic_DO=digits+species+'_'+ageclass+'_p'+pval+'_Consgrow_DO.jpeg'

;read plot
device, decomposed=1
image = tvrd(true=1)
help, image
erase
tv, image, true=1
device, decomposed=0

;write file, based on chosen rate and oxygen effects
  ; specify name of Plots folder
  If species eq 'YP' then Plots='Plots' else $
  Plots=Species+'_Plots'
 
  help, image, depth
  
  if rate_to_plot eq 0 then begin
    if oxyeffect eq 0 then begin
      if fishgrow eq 0 then filename=filepath(GRpic, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Nogrowth']) else $
        filename=filepath(GRpic, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Growth'])
      write_jpeg, filename, image, true=1 
    endif else begin
      if fishgrow eq 0 then filename=filepath(GRpic_DO, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Nogrowth']) else $
        filename=filepath(GRpic_DO, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Growth'])
      write_jpeg, filename, image, true=1
    endelse  
  endif else begin
    if oxyeffect eq 0 then begin
      if fishgrow eq 0 then filename=filepath(CRpic, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Nogrowth']) else $
        filename=filepath(CRpic, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Growth'])
      write_jpeg, filename, image, true=1 
    endif else begin
      if fishgrow eq 0 then filename=filepath(CRpic_DO, root_dir=['C:'],$
        subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Nogrowth']) else $
        filename=filepath(CRpic_DO, root_dir=['C:'],$
          subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Growth'])
      write_jpeg, filename, image, true=1
    endelse
  endelse


; create a color key for the plots above
window, 1
zvals=fltarr(1,253)
colvals=intarr(1,253)

; create xaxis label
GRlabel='Growth rate potential (g/g/d)'
CRlabel='Consumption rate (g/g/d)'

if rate_to_plot eq 0 then xlabel = GRlabel else $
  xlabel = CRlabel

plot,x,y,xran=[minval,maxval],yran=[1.0,1.04],/nodata,charsize=1.5,xstyle=1,ystyle=1,$
xtitle=xlabel,color=color2,thick=2.5

x2=0
y2=20
usersym,[-x2,-x2,x2+1,x2+1],[-y2/y2,y2,y2,-y2/y2],/fill

for j=0,252 do begin
  zvals[j]=minval+j*del
  qvals=replicate(1.0,n_elements(zvals))
  colvals[j]=j+1
  plots, zvals[j], qvals[j], psym=8, color=colvals[j]
endfor

; read and write plot as jpeg or tiff file
;read
device, decomposed=1
image = tvrd(true=1)
help, image
erase
tv, image, true=1
device, decomposed=0

; create output filename
GRPgrow=species+'_GRPgrow_'
CRgrow=species+'_CRgrow_'
GRkey=GRPgrow+ageclass+'_p'+pval+'_ColKey.jpeg'
CRkey=CRgrow+ageclass+'_p'+pval+'_ColKey.jpeg'

;write file
help, image, depth
if rate_to_plot eq 0 then colorkey = GRkey else $
  colorkey = CRkey
if fishgrow eq 0 then filename=filepath(colorkey, root_dir=['C:'],$
  subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Nogrowth']) else $
  filename=filepath(colorkey, root_dir=['C:'],$
    subdir=['Documents and Settings','karend','My Documents','IDL',Plots,'Growth'])
write_jpeg, filename, image, true=1

endfor

end