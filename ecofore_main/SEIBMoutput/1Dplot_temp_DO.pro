; 1Dplot_temp_DO.pro
; makes contour plots of light and dissolved oxygen for 1D EcoFore model
; TM Sesterhenn, February 2012


;--------------------------------------------------------
;
; change the two year variables
;
; AND YOU MUST COMPILE COLORBAR.PRO BEFORE THIS WILL WORK
;
;--------------------------------------------------------


start_time = systime(/seconds)

; which year? use two digits, then four digits!!
year = '05'
longyear = '2005'

; where are the files containing data?
drive  = 'C:\'
dir    = 'Users\tsesterh\IDLWorkspace1D\LakeErieWaterQuality1DModelOutput1987-2005\'
infile = '1DHypoxiaOutput'+year+'.csv' 

if year eq '87' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '88' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12431.  ; how large the file is
endif
if year eq '89' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '90' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '91' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '92' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12431.  ; how large the file is
endif
if year eq '93' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '94' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '95' then begin
  nDays    = 137.  ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '96' then begin
  nDays    = 137.  ; how many days the model ran
  endhere = 12431.  ; how large the file is
endif
if year eq '97' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '98' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '99' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '00' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12431.  ; how large the file is
endif
if year eq '01' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '02' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '03' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
if year eq '04' then begin
  nDays   = 137.    ; how many days the model ran
  endhere = 12431.  ; how large the file is
endif
if year eq '05' then begin
  nDays    = 137.  ; how many days the model ran
  endhere = 12479.  ; how large the file is
endif
depthY = indgen(48)
daysX  = indgen(nDays)

; get data
openr, lun, drive+dir+infile, /get_lun
DOandT = fltarr(10,endhere)
readf, lun, DOandT  ; import entire file contents into IDL
free_lun, lun
; data gotten

; get DO values
DOvalues  = DOandT[4,2256:(2256+(nDays*48))]  ; starts at June 1, ends in mid-October
DOplotter = fltarr(nDays,48)

; get T values
Tvalues  = DOandT[7,2256:(2256+(nDays*48))]
Tplotter = fltarr(nDays,48)

; put values into plot format
for ddd = 0,nDays-1 do begin
  DOplotter[ddd,*] = DOvalues[0,(48*ddd):((48*ddd)+47)]
  Tplotter[ddd,*]  = Tvalues[0,(48*ddd):((48*ddd)+47)]
endfor


device,decomposed=0  ; use 24-bit color
loadct, 39  ; rainbow + white color table

levelsDO = (findgen(60)/59)*12

levelsT = (findgen(60)/59)*30


; plot DO
window,0,xsize=700,ysize=500
contour,DOplotter,daysX,depthY,levels=levelsDO,yrange=[47,0],/fill,title='DO (mg L!U-1!N), '+longyear,$
        background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[0,30,60,90,120],$
        xtickname=['Jun','Jul','Aug','Sep','Oct'],color=0,xminor=1,xticks=4,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=6,maxrange=12,ncolors=255,minor=2,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','2','4','6','8','10','12'],/right,/vertical

; plot temperature
window,1,xsize=700,ysize=500
contour,Tplotter,daysX,depthY,levels=levelsT,yrange=[47,0],/fill,title='Temperature (!Uo!NC), '+longyear,$
        background=[255],xstyle=1,ystyle=1,yminor=1,ytickv=[40,30,20,10,0],$
        ytickname=['20','15','10','5','0'],ytitle='Depth (m)',xtickv=[0,30,60,90,120],$
        xtickname=['Jun','Jul','Aug','Sep','Oct'],color=0,xminor=1,xticks=4,$
        xmargin=[10,15],ymargin=[4,4]
colorbar,bottom=0,color=0,divisions=6,maxrange=30,ncolors=255,minor=2,position=[0.89,0.08,0.94,0.92],$
         ticknames=['0','5','10','15','20','25','30'],/right,/vertical
        
; this is how you save things: write_png,'YEAR_DO/temp.png',tvrd(/true)
; it saves the highest-numbered open graphics window
; saves to same directory where workspace is located


end_time = systime(/seconds)
print,'Figures took ',(end_time-start_time),' seconds to produce.'

end