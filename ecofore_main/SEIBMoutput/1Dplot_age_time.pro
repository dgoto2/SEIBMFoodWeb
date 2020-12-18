; 1Dplot_age_time.pro
; makes one-year line graph of age-class and time-specific response of one species
; in 1D SE Lake Erie EcoFore model
; TM Sesterhenn, March 2012

start_time = systime(/seconds)

; which year?
year = '1996'

; is hypoxia effect 'ON' or 'OFF'?
HH = 'ON'

; is density-dependence 'ON' or 'OFF'?
DD = 'ON'

; where are the files containing data?
drive = 'E:\'
dir   = 'Purdue\1Doutput_3-1\1996_HH_on_DD_on_DOmodTIMEmod\'

response = 14  ; 14=depth, #=otherstuff

; taxa: 'YEP' = yellow perch, 'WAE' = walleye, 'EMS' = emerald shiner, 'RAS' = rainbow smelt
tax = 'YEP'

; figure title
fig_title = tax+', '+year+': Hypoxia '+HH+', Density Dependence '+DD

; do you want to plot one age by time ('age') or one species by age ('species')?
myplot = 'age'

;--------------------------------------------------------------------------------------------------------
; from here down it should run just fine by itself with no changes needed (except maybe figure stuff)
;--------------------------------------------------------------------------------------------------------

startday = 152  ; what day the model started on
nDays    = 164  ; number of days the model ran (until mid-November)
axisdays = indgen(nDays) + startday  ; makes array for x-axis on figures

fishes        = ['WAE','YEP','RAS','EMS']
tot_age0_popn = fltarr(nDays)
all_age0_popn = fltarr(nDays,4)  ; row0=WAE, row1=YEP, row2=RAS, row3=EMS

for ff = 0,3 do begin

tax = fishes[ff]

if tax eq 'WAE' then begin
  ageclasses = 8
endif
if tax eq 'YEP' then begin
  ageclasses = 7
endif
if tax eq 'RAS' then begin
  ageclasses = 2
endif
if tax eq 'EMS' then begin
  ageclasses = 2
endif

; set up days depending on year
;--------------------------------------------------------------make conditional for all years later!!!
;if year eq '1987' then begin
;  nDays    = 137.  ; how many days the model ran
;  startday = 152.  ; what day the model started on
;endif
;if year eq '1995' then begin
;  nDays    = 137.  ; how many days the model ran
;  startday = 152.  ; what day the model started on
;endif
;if year eq '1996' then begin
;  nDays    = 164.  ; how many days the model ran
;  startday = 152.  ; what day the model started on
;endif
;if year eq '2005' then begin
;  nDays    = 137.  ; how many days the model ran
;  startday = 152.  ; what day the model started on
;endif


;---------------------------------------------BEGIN EMS/RAS-----------------------------------------------
if tax eq 'EMS' || tax eq 'RAS' then begin

age0_popnMO     = fltarr(nDays,5000)  ; MO = morning
age0_dataMO     = fltarr(nDays,5000)
age1plus_popnMO = fltarr(nDays,5000)
age1plus_dataMO = fltarr(nDays,5000)
age0_popnMI     = fltarr(nDays,5000)  ; MI = midday
age0_dataMI     = fltarr(nDays,5000)
age1plus_popnMI = fltarr(nDays,5000)
age1plus_dataMI = fltarr(nDays,5000)
age0_popnAF     = fltarr(nDays,5000)  ; AF = afternoon
age0_dataAF     = fltarr(nDays,5000)
age1plus_popnAF = fltarr(nDays,5000)
age1plus_dataAF = fltarr(nDays,5000)
age0_popnNI     = fltarr(nDays,5000)  ; NI = night
age0_dataNI     = fltarr(nDays,5000)
age1plus_popnNI = fltarr(nDays,5000)
age1plus_dataNI = fltarr(nDays,5000)


; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) ;- daycount*5000
        age0_popnMO[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMO[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 0) ;- daycount*5000
        age1plus_popnMO[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1plus_dataMO[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) ;- (daycount-30.)*5000
        age0_popnMO[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMO[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 0) ;- (daycount-30.)*5000
        age1plus_popnMO[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1plus_dataMO[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) ;- (daycount-60.)*5000
        age0_popnMO[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMO[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 0) ;- (daycount-60.)*5000
        age1plus_popnMO[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1plus_dataMO[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) ;- (daycount-90.)*5000
        age0_popnMO[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMO[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 0) ;- (daycount-90.)*5000
        age1plus_popnMO[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1plus_dataMO[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMO[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnMO[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1plus_dataMO[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMO[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnMO[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1plus_dataMO[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) ;- daycount*5000
        age0_popnMI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 0) ;- daycount*5000
        age1plus_popnMI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1plus_dataMI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) ;- (daycount-30.)*5000
        age0_popnMI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 0) ;- (daycount-30.)*5000
        age1plus_popnMI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1plus_dataMI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) ;- (daycount-60.)*5000
        age0_popnMI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 0) ;- (daycount-60.)*5000
        age1plus_popnMI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1plus_dataMI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) ;- (daycount-90.)*5000
        age0_popnMI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 0) ;- (daycount-90.)*5000
        age1plus_popnMI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1plus_dataMI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnMI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1plus_dataMI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnMI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1plus_dataMI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) ;- daycount*5000
        age0_popnAF[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataAF[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 0) ;- daycount*5000
        age1plus_popnAF[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1plus_dataAF[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) ;- (daycount-30.)*5000
        age0_popnAF[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataAF[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 0) ;- (daycount-30.)*5000
        age1plus_popnAF[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1plus_dataAF[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) ;- (daycount-60.)*5000
        age0_popnAF[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataAF[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 0) ;- (daycount-60.)*5000
        age1plus_popnAF[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1plus_dataAF[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) ;- (daycount-90.)*5000
        age0_popnAF[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataAF[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 0) ;- (daycount-90.)*5000
        age1plus_popnAF[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1plus_dataAF[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataAF[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnAF[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1plus_dataAF[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataAF[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnAF[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1plus_dataAF[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) ;- daycount*5000
        age0_popnNI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataNI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 0) ;- daycount*5000
        age1plus_popnNI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1plus_dataNI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) ;- (daycount-30.)*5000
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataNI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 0) ;- (daycount-30.)*5000
        age1plus_popnNI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1plus_dataNI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) ;- (daycount-60.)*5000
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataNI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 0) ;- (daycount-60.)*5000
        age1plus_popnNI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1plus_dataNI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) ;- (daycount-90.)*5000
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataNI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 0) ;- (daycount-90.)*5000
        age1plus_popnNI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1plus_dataNI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataNI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnNI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1plus_dataNI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataNI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 0) ;- (daycount-120.)*5000
        age1plus_popnNI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1plus_dataNI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
endfor;---------------------------------------------------------------------------------------TIMING END

for a = 0,nDays-1 do begin
  tot_age0_popn[a] = total(age0_popnNI[a,*])
endfor
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day

if myplot eq 'species' then begin  ; plot all age classes of a species

age0_popn24     = [ [age0_popnMO],[age0_popnMI],[age0_popnAF],[age0_popnNI] ]  ; 24 = all day
age0_data24     = [ [age0_dataMO],[age0_dataMI],[age0_dataAF],[age0_dataNI] ]
age1plus_popn24 = [ [age1plus_popnMO],[age1plus_popnMI],[age1plus_popnAF],[age1plus_popnNI] ]
age1plus_data24 = [ [age1plus_dataMO],[age1plus_dataMI],[age1plus_dataAF],[age1plus_dataNI] ]

; initialize arrays to hold plotting data
tot_age0_popn = fltarr(nDays)
W_age0_dpth   = fltarr(nDays,20000)
avg_age0_dpth = fltarr(nDays)
tot_age1plus_popn = fltarr(nDays)
W_age1plus_dpth   = fltarr(nDays,20000)
avg_age1plus_dpth = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  ; get total population for each day for each age class
  tot_age0_popn[a] = total(age0_popn24[a,*])
  tot_age1plus_popn[a] = total(age1plus_popn24[a,*])
  
  for r = 0,19999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpth[a,r]     = (age0_data24[a,r]+1) * age0_popn24[a,r]
    W_age1plus_dpth[a,r] = (age1plus_data24[a,r]+1) * age1plus_popn24[a,r]
  endfor
  avg_age0_dpth[a]     = ( ( total(W_age0_dpth[a,*]) ) / tot_age0_popn[a] ) /2   ; /2 because
  avg_age1plus_dpth[a] = ( ( total(W_age1plus_dpth[a,*]) ) / tot_age1plus_popn[a] ) /2    ; 2 cells per meter
endfor

;check
days = findgen(nDays)
avg_all_dpth = fltarr(nDays)
avg_all_dpth[days] = (avg_age0_dpth[days]*tot_age0_popn[days] + $
                     avg_age1plus_dpth[days]*tot_age1plus_popn[days]) / $
                     (tot_age0_popn[days] + tot_age1plus_popn[days])

; plot EMS or RAS
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit

; plot average depth for different age classes

if tax eq 'EMS' then begin
a0d = plot(axisdays, avg_age0_dpth, 'dark green', thick=3, name='Age 0', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
a1d = plot(axisdays, avg_age1plus_dpth, 'lime green', thick=3, name='Age 1+', /overplot)
alld = plot(axisdays, avg_all_dpth, 'orange red', thick=3, name='All', linestyle=2, /overplot)
Ld  = legend(target=[a0d,a1d,alld], position=[0.18,0.88], shadow=0)  ; to include overall average depth
;Ld  = legend(target=[a0d,a1d], position=[0.18,0.88], shadow=0)  ; to exclude overall average depth
endif

if tax eq 'RAS' then begin
a0d = plot(axisdays, avg_age0_dpth, 'deep pink', thick=3, name='Age 0', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
a1d = plot(axisdays, avg_age1plus_dpth, 'hot pink', thick=3, name='Age 1+', /overplot)
alld = plot(axisdays, avg_all_dpth, 'blue', thick=3, name='All', linestyle=2, /overplot)
Ld  = legend(target=[a0d,a1d,alld], position=[0.18,0.88], shadow=0)  ; to include overall average depth
;Ld  = legend(target=[a0d,a1d], position=[0.18,0.88], shadow=0)  ; to exclude overall average depth
endif

endif

if myplot eq 'age' then begin  ; plots one age class by time

tot_age0_popnMO      = fltarr(nDays)
tot_age1plus_popnMO  = fltarr(nDays)
tot_age0_popnMI      = fltarr(nDays)
tot_age1plus_popnMI  = fltarr(nDays)
tot_age0_popnAF      = fltarr(nDays)
tot_age1plus_popnAF  = fltarr(nDays)
tot_age0_popnNI      = fltarr(nDays)
tot_age1plus_popnNI  = fltarr(nDays)
W_age0_dpthMO        = fltarr(nDays,5000)
W_age1plus_dpthMO    = fltarr(nDays,5000)
W_age0_dpthMI        = fltarr(nDays,5000)
W_age1plus_dpthMI    = fltarr(nDays,5000)
W_age0_dpthAF        = fltarr(nDays,5000)
W_age1plus_dpthAF    = fltarr(nDays,5000)
W_age0_dpthNI        = fltarr(nDays,5000)
W_age1plus_dpthNI    = fltarr(nDays,5000)
Wavg_age0_dpthMO     = fltarr(nDays)
Wavg_age1plus_dpthMO = fltarr(nDays)
Wavg_age0_dpthMI     = fltarr(nDays)
Wavg_age1plus_dpthMI = fltarr(nDays)
Wavg_age0_dpthAF     = fltarr(nDays)
Wavg_age1plus_dpthAF = fltarr(nDays)
Wavg_age0_dpthNI     = fltarr(nDays)
Wavg_age1plus_dpthNI = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_age0_popnMO[a]     = total(age0_popnMO[a,*])
  tot_age1plus_popnMO[a] = total(age1plus_popnMO[a,*])
  tot_age0_popnMI[a]     = total(age0_popnMI[a,*])
  tot_age1plus_popnMI[a] = total(age1plus_popnMI[a,*])
  tot_age0_popnAF[a]     = total(age0_popnAF[a,*])
  tot_age1plus_popnAF[a] = total(age1plus_popnAF[a,*])
  tot_age0_popnNI[a]     = total(age0_popnNI[a,*])
  tot_age1plus_popnNI[a] = total(age1plus_popnNI[a,*])
  for r = 0,4999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpthMO[a,r]   = (age0_dataMO[a,r]+1) * age0_popnMO[a,r]
    W_age1plus_dpthMO[a,r] = (age1plus_dataMO[a,r]+1) * age1plus_popnMO[a,r]
    W_age0_dpthMI[a,r]   = (age0_dataMI[a,r]+1) * age0_popnMI[a,r]
    W_age1plus_dpthMI[a,r] = (age1plus_dataMI[a,r]+1) * age1plus_popnMI[a,r]
    W_age0_dpthAF[a,r]   = (age0_dataAF[a,r]+1) * age0_popnAF[a,r]
    W_age1plus_dpthAF[a,r] = (age1plus_dataAF[a,r]+1) * age1plus_popnAF[a,r]
    W_age0_dpthNI[a,r]   = (age0_dataNI[a,r]+1) * age0_popnNI[a,r]
    W_age1plus_dpthNI[a,r] = (age1plus_dataNI[a,r]+1) * age1plus_popnNI[a,r]
  endfor
  Wavg_age0_dpthMO[a]     = ( ( total(W_age0_dpthMO[a,*]) ) / tot_age0_popnMO[a] ) /2  ; /2 because
  Wavg_age1plus_dpthMO[a] = ( ( total(W_age1plus_dpthMO[a,*]) ) / tot_age1plus_popnMO[a] ) /2  ; 2 cells/m
  Wavg_age0_dpthMI[a]     = ( ( total(W_age0_dpthMI[a,*]) ) / tot_age0_popnMI[a] ) /2
  Wavg_age1plus_dpthMI[a] = ( ( total(W_age1plus_dpthMI[a,*]) ) / tot_age1plus_popnMI[a] ) /2
  Wavg_age0_dpthAF[a]     = ( ( total(W_age0_dpthAF[a,*]) ) / tot_age0_popnAF[a] ) /2
  Wavg_age1plus_dpthAF[a] = ( ( total(W_age1plus_dpthAF[a,*]) ) / tot_age1plus_popnAF[a] ) /2
  Wavg_age0_dpthNI[a]     = ( ( total(W_age0_dpthNI[a,*]) ) / tot_age0_popnNI[a] ) /2
  Wavg_age1plus_dpthNI[a] = ( ( total(W_age1plus_dpthNI[a,*]) ) / tot_age1plus_popnNI[a] ) /2
endfor

for ageplot = 0,ageclasses-1 do begin

  if ageplot eq 0 then begin
    agetext  = 'Ageclass 0'
    MO_depth = Wavg_age0_dpthMO
    MI_depth = Wavg_age0_dpthMI
    AF_depth = Wavg_age0_dpthAF
    NI_depth = Wavg_age0_dpthNI
  endif
  if ageplot eq 1 then begin
    agetext  = 'Ageclass 1+'
    MO_depth = Wavg_age1plus_dpthMO
    MI_depth = Wavg_age1plus_dpthMI
    AF_depth = Wavg_age1plus_dpthAF
    NI_depth = Wavg_age1plus_dpthNI
  endif

dMO = plot(axisdays, MO_depth, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
dMI = plot(axisdays, MI_depth, 'orange red', thick=3, name='Midday', /overplot)
dAF = plot(axisdays, AF_depth, 'gold', thick=3, name='Afternoon', /overplot)
dNI = plot(axisdays, NI_depth, 'midnight blue', thick=3, name='Night', /overplot)
Ld  = legend(target=[dMO,dMI,dAF,dNI], position=[0.66,0.85], shadow=0)
dTxt= text(0.18,0.85,agetext,/current)

endfor

; to plot individuals:
; dIND = plot(axisdays,(age0_dataMO[*,4563]+1)/2,'lime',thick=1,/overplot)
;                 age class^ time^^   ^^^^individual number

endif


endif;--------------------END EMS/RAS-------------------------------------------------------------------



;---------------------------------------------BEGIN WAE-----------------------------------------------
if tax eq 'WAE' then begin

age0_popnMO     = fltarr(nDays,5000)  ; MO = morning
age0_dataMO     = fltarr(nDays,5000)
age1_popnMO     = fltarr(nDays,5000)
age1_dataMO     = fltarr(nDays,5000)
age2_popnMO     = fltarr(nDays,5000)
age2_dataMO     = fltarr(nDays,5000)
age3_popnMO     = fltarr(nDays,5000)
age3_dataMO     = fltarr(nDays,5000)
age4_popnMO     = fltarr(nDays,5000)
age4_dataMO     = fltarr(nDays,5000)
age5_popnMO     = fltarr(nDays,5000)
age5_dataMO     = fltarr(nDays,5000)
age6_popnMO     = fltarr(nDays,5000)
age6_dataMO     = fltarr(nDays,5000)
age7plus_popnMO = fltarr(nDays,5000)
age7plus_dataMO = fltarr(nDays,5000)
age0_popnMI     = fltarr(nDays,5000)  ; MI = midday
age0_dataMI     = fltarr(nDays,5000)
age1_popnMI     = fltarr(nDays,5000)
age1_dataMI     = fltarr(nDays,5000)
age2_popnMI     = fltarr(nDays,5000)
age2_dataMI     = fltarr(nDays,5000)
age3_popnMI     = fltarr(nDays,5000)
age3_dataMI     = fltarr(nDays,5000)
age4_popnMI     = fltarr(nDays,5000)
age4_dataMI     = fltarr(nDays,5000)
age5_popnMI     = fltarr(nDays,5000)
age5_dataMI     = fltarr(nDays,5000)
age6_popnMI     = fltarr(nDays,5000)
age6_dataMI     = fltarr(nDays,5000)
age7plus_popnMI = fltarr(nDays,5000)
age7plus_dataMI = fltarr(nDays,5000)
age0_popnAF     = fltarr(nDays,5000)  ; AF = afternoon
age0_dataAF     = fltarr(nDays,5000)
age1_popnAF     = fltarr(nDays,5000)
age1_dataAF     = fltarr(nDays,5000)
age2_popnAF     = fltarr(nDays,5000)
age2_dataAF     = fltarr(nDays,5000)
age3_popnAF     = fltarr(nDays,5000)
age3_dataAF     = fltarr(nDays,5000)
age4_popnAF     = fltarr(nDays,5000)
age4_dataAF     = fltarr(nDays,5000)
age5_popnAF     = fltarr(nDays,5000)
age5_dataAF     = fltarr(nDays,5000)
age6_popnAF     = fltarr(nDays,5000)
age6_dataAF     = fltarr(nDays,5000)
age7plus_popnAF = fltarr(nDays,5000)
age7plus_dataAF = fltarr(nDays,5000)
age0_popnNI     = fltarr(nDays,5000)  ; NI = night
age0_dataNI     = fltarr(nDays,5000)
age1_popnNI     = fltarr(nDays,5000)
age1_dataNI     = fltarr(nDays,5000)
age2_popnNI     = fltarr(nDays,5000)
age2_dataNI     = fltarr(nDays,5000)
age3_popnNI     = fltarr(nDays,5000)
age3_dataNI     = fltarr(nDays,5000)
age4_popnNI     = fltarr(nDays,5000)
age4_dataNI     = fltarr(nDays,5000)
age5_popnNI     = fltarr(nDays,5000)
age5_dataNI     = fltarr(nDays,5000)
age6_popnNI     = fltarr(nDays,5000)
age6_dataNI     = fltarr(nDays,5000)
age7plus_popnNI = fltarr(nDays,5000)
age7plus_dataNI = fltarr(nDays,5000)


; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMO[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataMO[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataMO[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataMO[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataMO[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataMO[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 6) 
        age6_popnMO[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6_dataMO[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
        age7here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data1[ 0, (age7here + daycount*5000) ]
        age7plus_dataMO[daycount,age7here] = data1[ response, (age7here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMO[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataMO[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataMO[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataMO[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataMO[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataMO[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 6) 
        age6_popnMO[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6_dataMO[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
        age7here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data2[ 0, (age7here + (daycount-30.)*5000) ]
        age7plus_dataMO[daycount,age7here] = data2[ response, (age7here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMO[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataMO[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataMO[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataMO[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataMO[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataMO[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 6) 
        age6_popnMO[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6_dataMO[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
        age7here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data3[ 0, (age7here + (daycount-60.)*5000) ]
        age7plus_dataMO[daycount,age7here] = data3[ response, (age7here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMO[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataMO[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataMO[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataMO[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataMO[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataMO[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 6) 
        age6_popnMO[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6_dataMO[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
        age7here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data4[ 0, (age7here + (daycount-90.)*5000) ]
        age7plus_dataMO[daycount,age7here] = data4[ response, (age7here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMO[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMO[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataMO[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMO[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataMO[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMO[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataMO[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMO[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataMO[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMO[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataMO[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnMO[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6_dataMO[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
        age7here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data5[ 0, (age7here + (daycount-120.)*5000) ]
        age7plus_dataMO[daycount,age7here] = data5[ response, (age7here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMO[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMO[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataMO[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMO[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataMO[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMO[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataMO[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMO[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataMO[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMO[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataMO[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnMO[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6_dataMO[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
        age7here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 6) 
        age7plus_popnMO[daycount,age7here] = data6[ 0, (age7here + (daycount-150.)*5000) ]
        age7plus_dataMO[daycount,age7here] = data6[ response, (age7here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataMI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataMI[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataMI[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataMI[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataMI[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 6) 
        age6_popnMI[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6_dataMI[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
        age7here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data1[ 0, (age7here + daycount*5000) ]
        age7plus_dataMI[daycount,age7here] = data1[ response, (age7here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataMI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataMI[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataMI[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataMI[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataMI[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 6) 
        age6_popnMI[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6_dataMI[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
        age7here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data2[ 0, (age7here + (daycount-30.)*5000) ]
        age7plus_dataMI[daycount,age7here] = data2[ response, (age7here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataMI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataMI[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataMI[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataMI[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataMI[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 6) 
        age6_popnMI[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6_dataMI[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
        age7here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data3[ 0, (age7here + (daycount-60.)*5000) ]
        age7plus_dataMI[daycount,age7here] = data3[ response, (age7here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataMI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataMI[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataMI[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataMI[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataMI[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 6) 
        age6_popnMI[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6_dataMI[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
        age7here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data4[ 0, (age7here + (daycount-90.)*5000) ]
        age7plus_dataMI[daycount,age7here] = data4[ response, (age7here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataMI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMI[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataMI[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMI[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataMI[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMI[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataMI[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMI[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataMI[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnMI[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6_dataMI[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
        age7here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data5[ 0, (age7here + (daycount-120.)*5000) ]
        age7plus_dataMI[daycount,age7here] = data5[ response, (age7here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataMI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMI[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataMI[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMI[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataMI[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMI[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataMI[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMI[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataMI[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnMI[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6_dataMI[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
        age7here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 6) 
        age7plus_popnMI[daycount,age7here] = data6[ 0, (age7here + (daycount-150.)*5000) ]
        age7plus_dataMI[daycount,age7here] = data6[ response, (age7here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataAF[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataAF[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataAF[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataAF[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataAF[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataAF[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 6) 
        age6_popnAF[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6_dataAF[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
        age7here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data1[ 0, (age7here + daycount*5000) ]
        age7plus_dataAF[daycount,age7here] = data1[ response, (age7here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataAF[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataAF[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataAF[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataAF[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataAF[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataAF[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 6) 
        age6_popnAF[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6_dataAF[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
        age7here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data2[ 0, (age7here + (daycount-30.)*5000) ]
        age7plus_dataAF[daycount,age7here] = data2[ response, (age7here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataAF[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataAF[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataAF[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataAF[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataAF[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataAF[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 6) 
        age6_popnAF[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6_dataAF[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
        age7here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data3[ 0, (age7here + (daycount-60.)*5000) ]
        age7plus_dataAF[daycount,age7here] = data3[ response, (age7here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataAF[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataAF[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataAF[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataAF[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataAF[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataAF[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 6) 
        age6_popnAF[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6_dataAF[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
        age7here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data4[ 0, (age7here + (daycount-90.)*5000) ]
        age7plus_dataAF[daycount,age7here] = data4[ response, (age7here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataAF[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnAF[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataAF[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnAF[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataAF[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnAF[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataAF[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnAF[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataAF[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnAF[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataAF[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnAF[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6_dataAF[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
        age7here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data5[ 0, (age7here + (daycount-120.)*5000) ]
        age7plus_dataAF[daycount,age7here] = data5[ response, (age7here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataAF[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnAF[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataAF[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnAF[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataAF[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnAF[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataAF[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnAF[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataAF[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnAF[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataAF[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnAF[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6_dataAF[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
        age7here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 6) 
        age7plus_popnAF[daycount,age7here] = data6[ 0, (age7here + (daycount-150.)*5000) ]
        age7plus_dataAF[daycount,age7here] = data6[ response, (age7here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataNI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataNI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataNI[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataNI[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataNI[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataNI[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 6) 
        age6_popnNI[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6_dataNI[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
        age7here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data1[ 0, (age7here + daycount*5000) ]
        age7plus_dataNI[daycount,age7here] = data1[ response, (age7here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataNI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataNI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataNI[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataNI[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataNI[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataNI[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 6) 
        age6_popnNI[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6_dataNI[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
        age7here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data2[ 0, (age7here + (daycount-30.)*5000) ]
        age7plus_dataNI[daycount,age7here] = data2[ response, (age7here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataNI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataNI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataNI[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataNI[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataNI[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataNI[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 6) 
        age6_popnNI[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6_dataNI[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
        age7here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data3[ 0, (age7here + (daycount-60.)*5000) ]
        age7plus_dataNI[daycount,age7here] = data3[ response, (age7here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataNI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataNI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataNI[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataNI[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataNI[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataNI[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 6) 
        age6_popnNI[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6_dataNI[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
        age7here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data4[ 0, (age7here + (daycount-90.)*5000) ]
        age7plus_dataNI[daycount,age7here] = data4[ response, (age7here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataNI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnNI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataNI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnNI[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataNI[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnNI[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataNI[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnNI[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataNI[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnNI[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataNI[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnNI[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6_dataNI[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
        age7here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data5[ 0, (age7here + (daycount-120.)*5000) ]
        age7plus_dataNI[daycount,age7here] = data5[ response, (age7here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataNI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnNI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataNI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnNI[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataNI[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnNI[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataNI[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnNI[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataNI[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnNI[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataNI[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 6) ;- (daycount-120.)*5000
        age6_popnNI[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6_dataNI[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
        age7here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 6) 
        age7plus_popnNI[daycount,age7here] = data6[ 0, (age7here + (daycount-150.)*5000) ]
        age7plus_dataNI[daycount,age7here] = data6[ response, (age7here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
endfor;---------------------------------------------------------------------------------------TIMING END

for a = 0,nDays-1 do begin
  tot_age0_popn[a] = total(age0_popnNI[a,*])
endfor
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day


if myplot eq 'species' then begin  ; plot all age classes of a species

age0_popn24     = [ [age0_popnMO],[age0_popnMI],[age0_popnAF],[age0_popnNI] ]  ; 24 = all day
age0_data24     = [ [age0_dataMO],[age0_dataMI],[age0_dataAF],[age0_dataNI] ]
age1_popn24     = [ [age1_popnMO],[age1_popnMI],[age1_popnAF],[age1_popnNI] ]
age1_data24     = [ [age1_dataMO],[age1_dataMI],[age1_dataAF],[age1_dataNI] ]
age2_popn24     = [ [age2_popnMO],[age2_popnMI],[age2_popnAF],[age2_popnNI] ]
age2_data24     = [ [age2_dataMO],[age2_dataMI],[age2_dataAF],[age2_dataNI] ]
age3_popn24     = [ [age3_popnMO],[age3_popnMI],[age3_popnAF],[age3_popnNI] ]
age3_data24     = [ [age3_dataMO],[age3_dataMI],[age3_dataAF],[age3_dataNI] ]
age4_popn24     = [ [age4_popnMO],[age4_popnMI],[age4_popnAF],[age4_popnNI] ]
age4_data24     = [ [age4_dataMO],[age4_dataMI],[age4_dataAF],[age4_dataNI] ]
age5_popn24     = [ [age5_popnMO],[age5_popnMI],[age5_popnAF],[age5_popnNI] ]
age5_data24     = [ [age5_dataMO],[age5_dataMI],[age5_dataAF],[age5_dataNI] ]
age6_popn24     = [ [age6_popnMO],[age6_popnMI],[age6_popnAF],[age6_popnNI] ]
age6_data24     = [ [age6_dataMO],[age6_dataMI],[age6_dataAF],[age6_dataNI] ]
age7plus_popn24 = [ [age7plus_popnMO],[age7plus_popnMI],[age7plus_popnAF],[age7plus_popnNI] ]
age7plus_data24 = [ [age7plus_dataMO],[age7plus_dataMI],[age7plus_dataAF],[age7plus_dataNI] ]

; initialize arrays to hold plotting data
tot_age0_popn = fltarr(nDays)
W_age0_dpth   = fltarr(nDays,20000)
avg_age0_dpth = fltarr(nDays)
tot_age1_popn = fltarr(nDays)
W_age1_dpth   = fltarr(nDays,20000)
avg_age1_dpth = fltarr(nDays)
tot_age2_popn = fltarr(nDays)
W_age2_dpth   = fltarr(nDays,20000)
avg_age2_dpth = fltarr(nDays)
tot_age3_popn = fltarr(nDays)
W_age3_dpth   = fltarr(nDays,20000)
avg_age3_dpth = fltarr(nDays)
tot_age4_popn = fltarr(nDays)
W_age4_dpth   = fltarr(nDays,20000)
avg_age4_dpth = fltarr(nDays)
tot_age5_popn = fltarr(nDays)
W_age5_dpth   = fltarr(nDays,20000)
avg_age5_dpth = fltarr(nDays)
tot_age6_popn = fltarr(nDays)
W_age6_dpth   = fltarr(nDays,20000)
avg_age6_dpth = fltarr(nDays)
tot_age7plus_popn = fltarr(nDays)
W_age7plus_dpth   = fltarr(nDays,20000)
avg_age7plus_dpth = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  ; get total population for each day for each age class
  tot_age0_popn[a] = total(age0_popn24[a,*])
  tot_age1_popn[a] = total(age1_popn24[a,*])
  tot_age2_popn[a] = total(age2_popn24[a,*])
  tot_age3_popn[a] = total(age3_popn24[a,*])
  tot_age4_popn[a] = total(age4_popn24[a,*])
  tot_age5_popn[a] = total(age5_popn24[a,*])
  tot_age6_popn[a] = total(age6_popn24[a,*])
  tot_age7plus_popn[a] = total(age7plus_popn24[a,*])
  
  for r = 0,19999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpth[a,r]     = (age0_data24[a,r]+1) * age0_popn24[a,r]
    W_age1_dpth[a,r]     = (age1_data24[a,r]+1) * age1_popn24[a,r]
    W_age2_dpth[a,r]     = (age2_data24[a,r]+1) * age2_popn24[a,r]
    W_age3_dpth[a,r]     = (age3_data24[a,r]+1) * age3_popn24[a,r]
    W_age4_dpth[a,r]     = (age4_data24[a,r]+1) * age4_popn24[a,r]
    W_age5_dpth[a,r]     = (age5_data24[a,r]+1) * age5_popn24[a,r]
    W_age6_dpth[a,r]     = (age6_data24[a,r]+1) * age6_popn24[a,r]
    W_age7plus_dpth[a,r] = (age7plus_data24[a,r]+1) * age7plus_popn24[a,r]
  endfor
  avg_age0_dpth[a]     = ( ( total(W_age0_dpth[a,*]) ) / tot_age0_popn[a] ) /2  ; /2 because
  avg_age1_dpth[a]     = ( ( total(W_age1_dpth[a,*]) ) / tot_age1_popn[a] ) /2  ; 2 cells per meter
  avg_age2_dpth[a]     = ( ( total(W_age2_dpth[a,*]) ) / tot_age2_popn[a] ) /2
  avg_age3_dpth[a]     = ( ( total(W_age3_dpth[a,*]) ) / tot_age3_popn[a] ) /2
  avg_age4_dpth[a]     = ( ( total(W_age4_dpth[a,*]) ) / tot_age4_popn[a] ) /2
  avg_age5_dpth[a]     = ( ( total(W_age5_dpth[a,*]) ) / tot_age5_popn[a] ) /2
  avg_age6_dpth[a]     = ( ( total(W_age6_dpth[a,*]) ) / tot_age6_popn[a] ) /2
  avg_age7plus_dpth[a] = ( ( total(W_age7plus_dpth[a,*]) ) / tot_age7plus_popn[a] ) /2    
endfor

;check
days = findgen(nDays)
avg_all_dpth = fltarr(nDays)
avg_all_dpth[days] = (avg_age0_dpth[days]*tot_age0_popn[days] + $
                      avg_age1_dpth[days]*tot_age1_popn[days] + $
                      avg_age2_dpth[days]*tot_age2_popn[days] + $
                      avg_age3_dpth[days]*tot_age3_popn[days] + $
                      avg_age4_dpth[days]*tot_age4_popn[days] + $
                      avg_age5_dpth[days]*tot_age5_popn[days] + $
                      avg_age6_dpth[days]*tot_age6_popn[days] + $
                      avg_age7plus_dpth[days]*tot_age7plus_popn[days]) / $
                     (tot_age0_popn[days] + tot_age1_popn[days] + $
                      tot_age2_popn[days] + tot_age3_popn[days] + $
                      tot_age4_popn[days] + tot_age5_popn[days] + $
                      tot_age6_popn[days] + tot_age7plus_popn[days])


; plot WAE
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit

; plot average depth for different size classes

a0d = plot(axisdays, avg_age0_dpth, 'navy', thick=3, name='Age 0', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
a1d = plot(axisdays, avg_age1_dpth, 'medium blue', thick=3, name='Age 1', /overplot)
a2d = plot(axisdays, avg_age2_dpth, 'blue', thick=3, name='Age 2', /overplot)
a3d = plot(axisdays, avg_age3_dpth, 'royal blue', thick=3, name='Age 3', /overplot)
a4d = plot(axisdays, avg_age4_dpth, 'maroon', thick=3, name='Age 4', /overplot)
a5d = plot(axisdays, avg_age5_dpth, 'firebrick', thick=3, name='Age 5', /overplot)
a6d = plot(axisdays, avg_age6_dpth, 'crimson', thick=3, name='Age 6', /overplot)
a7d = plot(axisdays, avg_age7plus_dpth, 'indian red', thick=3, name='Age 7+', /overplot)
alld = plot(axisdays, avg_all_dpth, 'lime green', thick=3, name='All', linestyle=2, /overplot)
Ld  = legend(target=[a0d,a1d,a2d,a3d,a4d,a5d,a6d,a7d,alld], position=[0.18,0.88], shadow=0)  ; to include overall average depth
;Ld  = legend(target=[a0d,a1d,a2d,a3d,a4d,a5d,a6d,a7d], position=[0.18,0.88], shadow=0)  ; to exclude overall average depth

endif

if myplot eq 'age' then begin  ; plots one age class by time

tot_age0_popnMO      = fltarr(nDays)
tot_age1_popnMO      = fltarr(nDays)
tot_age2_popnMO      = fltarr(nDays)
tot_age3_popnMO      = fltarr(nDays)
tot_age4_popnMO      = fltarr(nDays)
tot_age5_popnMO      = fltarr(nDays)
tot_age6_popnMO      = fltarr(nDays)
tot_age7plus_popnMO  = fltarr(nDays)
tot_age0_popnMI      = fltarr(nDays)
tot_age1_popnMI      = fltarr(nDays)
tot_age2_popnMI      = fltarr(nDays)
tot_age3_popnMI      = fltarr(nDays)
tot_age4_popnMI      = fltarr(nDays)
tot_age5_popnMI      = fltarr(nDays)
tot_age6_popnMI      = fltarr(nDays)
tot_age7plus_popnMI  = fltarr(nDays)
tot_age0_popnAF      = fltarr(nDays)
tot_age1_popnAF      = fltarr(nDays)
tot_age2_popnAF      = fltarr(nDays)
tot_age3_popnAF      = fltarr(nDays)
tot_age4_popnAF      = fltarr(nDays)
tot_age5_popnAF      = fltarr(nDays)
tot_age6_popnAF      = fltarr(nDays)
tot_age7plus_popnAF  = fltarr(nDays)
tot_age0_popnNI      = fltarr(nDays)
tot_age1_popnNI      = fltarr(nDays)
tot_age2_popnNI      = fltarr(nDays)
tot_age3_popnNI      = fltarr(nDays)
tot_age4_popnNI      = fltarr(nDays)
tot_age5_popnNI      = fltarr(nDays)
tot_age6_popnNI      = fltarr(nDays)
tot_age7plus_popnNI  = fltarr(nDays)
W_age0_dpthMO        = fltarr(nDays,5000)
W_age1_dpthMO        = fltarr(nDays,5000)
W_age2_dpthMO        = fltarr(nDays,5000)
W_age3_dpthMO        = fltarr(nDays,5000)
W_age4_dpthMO        = fltarr(nDays,5000)
W_age5_dpthMO        = fltarr(nDays,5000)
W_age6_dpthMO        = fltarr(nDays,5000)
W_age7plus_dpthMO    = fltarr(nDays,5000)
W_age0_dpthMI        = fltarr(nDays,5000)
W_age1_dpthMI        = fltarr(nDays,5000)
W_age2_dpthMI        = fltarr(nDays,5000)
W_age3_dpthMI        = fltarr(nDays,5000)
W_age4_dpthMI        = fltarr(nDays,5000)
W_age5_dpthMI        = fltarr(nDays,5000)
W_age6_dpthMI        = fltarr(nDays,5000)
W_age7plus_dpthMI    = fltarr(nDays,5000)
W_age0_dpthAF        = fltarr(nDays,5000)
W_age1_dpthAF        = fltarr(nDays,5000)
W_age2_dpthAF        = fltarr(nDays,5000)
W_age3_dpthAF        = fltarr(nDays,5000)
W_age4_dpthAF        = fltarr(nDays,5000)
W_age5_dpthAF        = fltarr(nDays,5000)
W_age6_dpthAF        = fltarr(nDays,5000)
W_age7plus_dpthAF    = fltarr(nDays,5000)
W_age0_dpthNI        = fltarr(nDays,5000)
W_age1_dpthNI        = fltarr(nDays,5000)
W_age2_dpthNI        = fltarr(nDays,5000)
W_age3_dpthNI        = fltarr(nDays,5000)
W_age4_dpthNI        = fltarr(nDays,5000)
W_age5_dpthNI        = fltarr(nDays,5000)
W_age6_dpthNI        = fltarr(nDays,5000)
W_age7plus_dpthNI    = fltarr(nDays,5000)
Wavg_age0_dpthMO     = fltarr(nDays)
Wavg_age1_dpthMO     = fltarr(nDays)
Wavg_age2_dpthMO     = fltarr(nDays)
Wavg_age3_dpthMO     = fltarr(nDays)
Wavg_age4_dpthMO     = fltarr(nDays)
Wavg_age5_dpthMO     = fltarr(nDays)
Wavg_age6_dpthMO     = fltarr(nDays)
Wavg_age7plus_dpthMO = fltarr(nDays)
Wavg_age0_dpthMI     = fltarr(nDays)
Wavg_age1_dpthMI     = fltarr(nDays)
Wavg_age2_dpthMI     = fltarr(nDays)
Wavg_age3_dpthMI     = fltarr(nDays)
Wavg_age4_dpthMI     = fltarr(nDays)
Wavg_age5_dpthMI     = fltarr(nDays)
Wavg_age6_dpthMI     = fltarr(nDays)
Wavg_age7plus_dpthMI = fltarr(nDays)
Wavg_age0_dpthAF     = fltarr(nDays)
Wavg_age1_dpthAF     = fltarr(nDays)
Wavg_age2_dpthAF     = fltarr(nDays)
Wavg_age3_dpthAF     = fltarr(nDays)
Wavg_age4_dpthAF     = fltarr(nDays)
Wavg_age5_dpthAF     = fltarr(nDays)
Wavg_age6_dpthAF     = fltarr(nDays)
Wavg_age7plus_dpthAF = fltarr(nDays)
Wavg_age0_dpthNI     = fltarr(nDays)
Wavg_age1_dpthNI     = fltarr(nDays)
Wavg_age2_dpthNI     = fltarr(nDays)
Wavg_age3_dpthNI     = fltarr(nDays)
Wavg_age4_dpthNI     = fltarr(nDays)
Wavg_age5_dpthNI     = fltarr(nDays)
Wavg_age6_dpthNI     = fltarr(nDays)
Wavg_age7plus_dpthNI = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_age0_popnMO[a]     = total(age0_popnMO[a,*])
  tot_age1_popnMO[a]     = total(age1_popnMO[a,*])
  tot_age2_popnMO[a]     = total(age2_popnMO[a,*])
  tot_age3_popnMO[a]     = total(age3_popnMO[a,*])
  tot_age4_popnMO[a]     = total(age4_popnMO[a,*])
  tot_age5_popnMO[a]     = total(age5_popnMO[a,*])
  tot_age6_popnMO[a]     = total(age6_popnMO[a,*])
  tot_age7plus_popnMO[a] = total(age7plus_popnMO[a,*])
  tot_age0_popnMI[a]     = total(age0_popnMI[a,*])
  tot_age1_popnMI[a]     = total(age1_popnMI[a,*])
  tot_age2_popnMI[a]     = total(age2_popnMI[a,*])
  tot_age3_popnMI[a]     = total(age3_popnMI[a,*])
  tot_age4_popnMI[a]     = total(age4_popnMI[a,*])
  tot_age5_popnMI[a]     = total(age5_popnMI[a,*])
  tot_age6_popnMI[a]     = total(age6_popnMI[a,*])
  tot_age7plus_popnMI[a] = total(age7plus_popnMI[a,*])
  tot_age0_popnAF[a]     = total(age0_popnAF[a,*])
  tot_age1_popnAF[a]     = total(age1_popnAF[a,*])
  tot_age2_popnAF[a]     = total(age2_popnAF[a,*])
  tot_age3_popnAF[a]     = total(age3_popnAF[a,*])
  tot_age4_popnAF[a]     = total(age4_popnAF[a,*])
  tot_age5_popnAF[a]     = total(age5_popnAF[a,*])
  tot_age6_popnAF[a]     = total(age6_popnAF[a,*])
  tot_age7plus_popnAF[a] = total(age7plus_popnAF[a,*])
  tot_age0_popnNI[a]     = total(age0_popnNI[a,*])
  tot_age1_popnNI[a]     = total(age1_popnNI[a,*])
  tot_age2_popnNI[a]     = total(age2_popnNI[a,*])
  tot_age3_popnNI[a]     = total(age3_popnNI[a,*])
  tot_age4_popnNI[a]     = total(age4_popnNI[a,*])
  tot_age5_popnNI[a]     = total(age5_popnNI[a,*])
  tot_age6_popnNI[a]     = total(age6_popnNI[a,*])
  tot_age7plus_popnNI[a] = total(age7plus_popnNI[a,*])
  for r = 0,4999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpthMO[a,r]   = (age0_dataMO[a,r]+1) * age0_popnMO[a,r]
    W_age1_dpthMO[a,r]   = (age1_dataMO[a,r]+1) * age1_popnMO[a,r]
    W_age2_dpthMO[a,r]   = (age2_dataMO[a,r]+1) * age2_popnMO[a,r]
    W_age3_dpthMO[a,r]   = (age3_dataMO[a,r]+1) * age3_popnMO[a,r]
    W_age4_dpthMO[a,r]   = (age4_dataMO[a,r]+1) * age4_popnMO[a,r]
    W_age5_dpthMO[a,r]   = (age5_dataMO[a,r]+1) * age5_popnMO[a,r]
    W_age6_dpthMO[a,r]   = (age6_dataMO[a,r]+1) * age6_popnMO[a,r]
    W_age7plus_dpthMO[a,r] = (age7plus_dataMO[a,r]+1) * age7plus_popnMO[a,r]
    W_age0_dpthMI[a,r]   = (age0_dataMI[a,r]+1) * age0_popnMI[a,r]
    W_age1_dpthMI[a,r]   = (age1_dataMI[a,r]+1) * age1_popnMI[a,r]
    W_age2_dpthMI[a,r]   = (age2_dataMI[a,r]+1) * age2_popnMI[a,r]
    W_age3_dpthMI[a,r]   = (age3_dataMI[a,r]+1) * age3_popnMI[a,r]
    W_age4_dpthMI[a,r]   = (age4_dataMI[a,r]+1) * age4_popnMI[a,r]
    W_age5_dpthMI[a,r]   = (age5_dataMI[a,r]+1) * age5_popnMI[a,r]
    W_age6_dpthMI[a,r]   = (age6_dataMI[a,r]+1) * age6_popnMI[a,r]
    W_age7plus_dpthMI[a,r] = (age7plus_dataMI[a,r]+1) * age7plus_popnMI[a,r]
    W_age0_dpthAF[a,r]   = (age0_dataAF[a,r]+1) * age0_popnAF[a,r]
    W_age1_dpthAF[a,r]   = (age1_dataAF[a,r]+1) * age1_popnAF[a,r]
    W_age2_dpthAF[a,r]   = (age2_dataAF[a,r]+1) * age2_popnAF[a,r]
    W_age3_dpthAF[a,r]   = (age3_dataAF[a,r]+1) * age3_popnAF[a,r]
    W_age4_dpthAF[a,r]   = (age4_dataAF[a,r]+1) * age4_popnAF[a,r]
    W_age5_dpthAF[a,r]   = (age5_dataAF[a,r]+1) * age5_popnAF[a,r]
    W_age6_dpthAF[a,r]   = (age6_dataAF[a,r]+1) * age6_popnAF[a,r]
    W_age7plus_dpthAF[a,r] = (age7plus_dataAF[a,r]+1) * age7plus_popnAF[a,r]
    W_age0_dpthNI[a,r]   = (age0_dataNI[a,r]+1) * age0_popnNI[a,r]
    W_age1_dpthNI[a,r]   = (age1_dataNI[a,r]+1) * age1_popnNI[a,r]
    W_age2_dpthNI[a,r]   = (age2_dataNI[a,r]+1) * age2_popnNI[a,r]
    W_age3_dpthNI[a,r]   = (age3_dataNI[a,r]+1) * age3_popnNI[a,r]
    W_age4_dpthNI[a,r]   = (age4_dataNI[a,r]+1) * age4_popnNI[a,r]
    W_age5_dpthNI[a,r]   = (age5_dataNI[a,r]+1) * age5_popnNI[a,r]
    W_age6_dpthNI[a,r]   = (age6_dataNI[a,r]+1) * age6_popnNI[a,r]
    W_age7plus_dpthNI[a,r] = (age7plus_dataNI[a,r]+1) * age7plus_popnNI[a,r]
  endfor
  Wavg_age0_dpthMO[a]     = ( ( total(W_age0_dpthMO[a,*]) ) / tot_age0_popnMO[a] ) /2  ; /2 because
  Wavg_age1_dpthMO[a]     = ( ( total(W_age1_dpthMO[a,*]) ) / tot_age1_popnMO[a] ) /2  ; 2 cells/m
  Wavg_age2_dpthMO[a]     = ( ( total(W_age2_dpthMO[a,*]) ) / tot_age2_popnMO[a] ) /2
  Wavg_age3_dpthMO[a]     = ( ( total(W_age3_dpthMO[a,*]) ) / tot_age3_popnMO[a] ) /2
  Wavg_age4_dpthMO[a]     = ( ( total(W_age4_dpthMO[a,*]) ) / tot_age4_popnMO[a] ) /2
  Wavg_age5_dpthMO[a]     = ( ( total(W_age5_dpthMO[a,*]) ) / tot_age5_popnMO[a] ) /2
  Wavg_age6_dpthMO[a]     = ( ( total(W_age6_dpthMO[a,*]) ) / tot_age6_popnMO[a] ) /2
  Wavg_age7plus_dpthMO[a] = ( ( total(W_age7plus_dpthMO[a,*]) ) / tot_age7plus_popnMO[a] ) /2  
  Wavg_age0_dpthMI[a]     = ( ( total(W_age0_dpthMI[a,*]) ) / tot_age0_popnMI[a] ) /2
  Wavg_age1_dpthMI[a]     = ( ( total(W_age1_dpthMI[a,*]) ) / tot_age1_popnMI[a] ) /2
  Wavg_age2_dpthMI[a]     = ( ( total(W_age2_dpthMI[a,*]) ) / tot_age2_popnMI[a] ) /2
  Wavg_age3_dpthMI[a]     = ( ( total(W_age3_dpthMI[a,*]) ) / tot_age3_popnMI[a] ) /2
  Wavg_age4_dpthMI[a]     = ( ( total(W_age4_dpthMI[a,*]) ) / tot_age4_popnMI[a] ) /2
  Wavg_age5_dpthMI[a]     = ( ( total(W_age5_dpthMI[a,*]) ) / tot_age5_popnMI[a] ) /2
  Wavg_age6_dpthMI[a]     = ( ( total(W_age6_dpthMI[a,*]) ) / tot_age6_popnMI[a] ) /2
  Wavg_age7plus_dpthMI[a] = ( ( total(W_age7plus_dpthMI[a,*]) ) / tot_age7plus_popnMI[a] ) /2
  Wavg_age0_dpthAF[a]     = ( ( total(W_age0_dpthAF[a,*]) ) / tot_age0_popnAF[a] ) /2
  Wavg_age1_dpthAF[a]     = ( ( total(W_age1_dpthAF[a,*]) ) / tot_age1_popnAF[a] ) /2
  Wavg_age2_dpthAF[a]     = ( ( total(W_age2_dpthAF[a,*]) ) / tot_age2_popnAF[a] ) /2
  Wavg_age3_dpthAF[a]     = ( ( total(W_age3_dpthAF[a,*]) ) / tot_age3_popnAF[a] ) /2
  Wavg_age4_dpthAF[a]     = ( ( total(W_age4_dpthAF[a,*]) ) / tot_age4_popnAF[a] ) /2
  Wavg_age5_dpthAF[a]     = ( ( total(W_age5_dpthAF[a,*]) ) / tot_age5_popnAF[a] ) /2
  Wavg_age6_dpthAF[a]     = ( ( total(W_age6_dpthAF[a,*]) ) / tot_age6_popnAF[a] ) /2
  Wavg_age7plus_dpthAF[a] = ( ( total(W_age7plus_dpthAF[a,*]) ) / tot_age7plus_popnAF[a] ) /2
  Wavg_age0_dpthNI[a]     = ( ( total(W_age0_dpthNI[a,*]) ) / tot_age0_popnNI[a] ) /2
  Wavg_age1_dpthNI[a]     = ( ( total(W_age1_dpthNI[a,*]) ) / tot_age1_popnNI[a] ) /2
  Wavg_age2_dpthNI[a]     = ( ( total(W_age2_dpthNI[a,*]) ) / tot_age2_popnNI[a] ) /2
  Wavg_age3_dpthNI[a]     = ( ( total(W_age3_dpthNI[a,*]) ) / tot_age3_popnNI[a] ) /2
  Wavg_age4_dpthNI[a]     = ( ( total(W_age4_dpthNI[a,*]) ) / tot_age4_popnNI[a] ) /2
  Wavg_age5_dpthNI[a]     = ( ( total(W_age5_dpthNI[a,*]) ) / tot_age5_popnNI[a] ) /2
  Wavg_age6_dpthNI[a]     = ( ( total(W_age6_dpthNI[a,*]) ) / tot_age6_popnNI[a] ) /2
  Wavg_age7plus_dpthNI[a] = ( ( total(W_age7plus_dpthNI[a,*]) ) / tot_age7plus_popnNI[a] ) /2
endfor

for ageplot = 0,ageclasses-1 do begin

  if ageplot eq 0 then begin
    agetext  = 'Ageclass 0'
    MO_depth = Wavg_age0_dpthMO
    MI_depth = Wavg_age0_dpthMI
    AF_depth = Wavg_age0_dpthAF
    NI_depth = Wavg_age0_dpthNI
  endif
  if ageplot eq 1 then begin
    agetext  = 'Ageclass 1'
    MO_depth = Wavg_age1_dpthMO
    MI_depth = Wavg_age1_dpthMI
    AF_depth = Wavg_age1_dpthAF
    NI_depth = Wavg_age1_dpthNI
  endif
  if ageplot eq 2 then begin
    agetext  = 'Ageclass 2'
    MO_depth = Wavg_age2_dpthMO
    MI_depth = Wavg_age2_dpthMI
    AF_depth = Wavg_age2_dpthAF
    NI_depth = Wavg_age2_dpthNI
  endif
  if ageplot eq 3 then begin
    agetext  = 'Ageclass 3'
    MO_depth = Wavg_age3_dpthMO
    MI_depth = Wavg_age3_dpthMI
    AF_depth = Wavg_age3_dpthAF
    NI_depth = Wavg_age3_dpthNI
  endif
  if ageplot eq 4 then begin
    agetext  = 'Ageclass 4'
    MO_depth = Wavg_age4_dpthMO
    MI_depth = Wavg_age4_dpthMI
    AF_depth = Wavg_age4_dpthAF
    NI_depth = Wavg_age4_dpthNI
  endif
  if ageplot eq 5 then begin
    agetext  = 'Ageclass 5'
    MO_depth = Wavg_age5_dpthMO
    MI_depth = Wavg_age5_dpthMI
    AF_depth = Wavg_age5_dpthAF
    NI_depth = Wavg_age5_dpthNI
  endif
  if ageplot eq 6 then begin
    agetext  = 'Ageclass 6'
    MO_depth = Wavg_age6_dpthMO
    MI_depth = Wavg_age6_dpthMI
    AF_depth = Wavg_age6_dpthAF
    NI_depth = Wavg_age6_dpthNI
  endif
  if ageplot eq 7 then begin
    agetext  = 'Ageclass 7+'
    MO_depth = Wavg_age7plus_dpthMO
    MI_depth = Wavg_age7plus_dpthMI
    AF_depth = Wavg_age7plus_dpthAF
    NI_depth = Wavg_age7plus_dpthNI
  endif
  

dMO = plot(axisdays, MO_depth, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
dMI = plot(axisdays, MI_depth, 'orange red', thick=3, name='Midday', /overplot)
dAF = plot(axisdays, AF_depth, 'gold', thick=3, name='Afternoon', /overplot)
dNI = plot(axisdays, NI_depth, 'midnight blue', thick=3, name='Night', /overplot)
Ld  = legend(target=[dMO,dMI,dAF,dNI], position=[0.66,0.85], shadow=0)
dTxt= text(0.18,0.85,agetext,/current)

endfor

; to plot individuals:
; dIND = plot(axisdays,(age0_dataMO[*,4563]+1)/2,'lime',thick=1,/overplot)
;                 age class^ time^^   ^^^^individual number
; To plot individuals for a specific age class, highlight the XX_depth segments for that age class
; and run them to make sure the correct data are plotted.

endif



endif;--------------------END WAE-----------------------------------------------------------------------


;---------------------------------------------BEGIN YEP-----------------------------------------------
if tax eq 'YEP' then begin

age0_popnMO     = fltarr(nDays,5000)  ; MO = morning
age0_dataMO     = fltarr(nDays,5000)
age1_popnMO     = fltarr(nDays,5000)
age1_dataMO     = fltarr(nDays,5000)
age2_popnMO     = fltarr(nDays,5000)
age2_dataMO     = fltarr(nDays,5000)
age3_popnMO     = fltarr(nDays,5000)
age3_dataMO     = fltarr(nDays,5000)
age4_popnMO     = fltarr(nDays,5000)
age4_dataMO     = fltarr(nDays,5000)
age5_popnMO     = fltarr(nDays,5000)
age5_dataMO     = fltarr(nDays,5000)
age6plus_popnMO = fltarr(nDays,5000)
age6plus_dataMO = fltarr(nDays,5000)
age0_popnMI     = fltarr(nDays,5000)  ; MI = midday
age0_dataMI     = fltarr(nDays,5000)
age1_popnMI     = fltarr(nDays,5000)
age1_dataMI     = fltarr(nDays,5000)
age2_popnMI     = fltarr(nDays,5000)
age2_dataMI     = fltarr(nDays,5000)
age3_popnMI     = fltarr(nDays,5000)
age3_dataMI     = fltarr(nDays,5000)
age4_popnMI     = fltarr(nDays,5000)
age4_dataMI     = fltarr(nDays,5000)
age5_popnMI     = fltarr(nDays,5000)
age5_dataMI     = fltarr(nDays,5000)
age6plus_popnMI = fltarr(nDays,5000)
age6plus_dataMI = fltarr(nDays,5000)
age0_popnAF     = fltarr(nDays,5000)  ; AF = afternoon
age0_dataAF     = fltarr(nDays,5000)
age1_popnAF     = fltarr(nDays,5000)
age1_dataAF     = fltarr(nDays,5000)
age2_popnAF     = fltarr(nDays,5000)
age2_dataAF     = fltarr(nDays,5000)
age3_popnAF     = fltarr(nDays,5000)
age3_dataAF     = fltarr(nDays,5000)
age4_popnAF     = fltarr(nDays,5000)
age4_dataAF     = fltarr(nDays,5000)
age5_popnAF     = fltarr(nDays,5000)
age5_dataAF     = fltarr(nDays,5000)
age6plus_popnAF = fltarr(nDays,5000)
age6plus_dataAF = fltarr(nDays,5000)
age0_popnNI     = fltarr(nDays,5000)  ; NI = night
age0_dataNI     = fltarr(nDays,5000)
age1_popnNI     = fltarr(nDays,5000)
age1_dataNI     = fltarr(nDays,5000)
age2_popnNI     = fltarr(nDays,5000)
age2_dataNI     = fltarr(nDays,5000)
age3_popnNI     = fltarr(nDays,5000)
age3_dataNI     = fltarr(nDays,5000)
age4_popnNI     = fltarr(nDays,5000)
age4_dataNI     = fltarr(nDays,5000)
age5_popnNI     = fltarr(nDays,5000)
age5_dataNI     = fltarr(nDays,5000)
age6plus_popnNI = fltarr(nDays,5000)
age6plus_dataNI = fltarr(nDays,5000)


; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMO[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataMO[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataMO[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataMO[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataMO[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataMO[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6plus_dataMO[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMO[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataMO[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataMO[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataMO[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataMO[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataMO[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6plus_dataMO[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMO[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataMO[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataMO[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataMO[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataMO[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataMO[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6plus_dataMO[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnMO[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMO[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnMO[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataMO[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnMO[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataMO[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnMO[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataMO[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnMO[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataMO[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnMO[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataMO[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6plus_dataMO[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMO[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMO[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataMO[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMO[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataMO[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMO[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataMO[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMO[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataMO[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMO[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataMO[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6plus_dataMO[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMO[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMO[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMO[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataMO[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMO[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataMO[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMO[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataMO[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMO[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataMO[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMO[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataMO[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 5) 
        age6plus_popnMO[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6plus_dataMO[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataMI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataMI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataMI[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataMI[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataMI[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataMI[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6plus_dataMI[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataMI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataMI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataMI[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataMI[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataMI[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataMI[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6plus_dataMI[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataMI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataMI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataMI[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataMI[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataMI[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataMI[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6plus_dataMI[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnMI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataMI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnMI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataMI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnMI[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataMI[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnMI[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataMI[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnMI[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataMI[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnMI[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataMI[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6plus_dataMI[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataMI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataMI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMI[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataMI[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMI[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataMI[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMI[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataMI[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMI[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataMI[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6plus_dataMI[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnMI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataMI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnMI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataMI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnMI[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataMI[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnMI[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataMI[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnMI[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataMI[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnMI[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataMI[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 5) 
        age6plus_popnMI[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6plus_dataMI[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataAF[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataAF[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataAF[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataAF[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataAF[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataAF[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6plus_dataAF[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataAF[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataAF[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataAF[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataAF[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataAF[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataAF[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6plus_dataAF[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataAF[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataAF[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataAF[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataAF[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataAF[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataAF[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6plus_dataAF[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnAF[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataAF[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnAF[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataAF[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnAF[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataAF[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnAF[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataAF[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnAF[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataAF[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnAF[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataAF[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6plus_dataAF[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataAF[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnAF[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataAF[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnAF[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataAF[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnAF[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataAF[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnAF[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataAF[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnAF[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataAF[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6plus_dataAF[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnAF[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataAF[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnAF[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataAF[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnAF[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataAF[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnAF[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataAF[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnAF[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataAF[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnAF[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataAF[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 5) 
        age6plus_popnAF[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6plus_dataAF[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax+'_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,150000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(70,70000)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data1[ 0, (age0here + daycount*5000) ]
        age0_dataNI[daycount,age0here] = data1[ response, (age0here + daycount*5000) ]
        age1here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data1[ 0, (age1here + daycount*5000) ]
        age1_dataNI[daycount,age1here] = data1[ response, (age1here + daycount*5000) ]
        age2here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data1[ 0, (age2here + daycount*5000) ]
        age2_dataNI[daycount,age2here] = data1[ response, (age2here + daycount*5000) ]
        age3here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data1[ 0, (age3here + daycount*5000) ]
        age3_dataNI[daycount,age3here] = data1[ response, (age3here + daycount*5000) ]
        age4here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data1[ 0, (age4here + daycount*5000) ]
        age4_dataNI[daycount,age4here] = data1[ response, (age4here + daycount*5000) ]
        age5here = where(data1(6,(daycount*5000):(daycount*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data1[ 0, (age5here + daycount*5000) ]
        age5_dataNI[daycount,age5here] = data1[ response, (age5here + daycount*5000) ]
        age6here = where(data1(6,(daycount*5000):(daycount*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data1[ 0, (age6here + daycount*5000) ]
        age6plus_dataNI[daycount,age6here] = data1[ response, (age6here + daycount*5000) ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
        age0_dataNI[daycount,age0here] = data2[ response, (age0here + (daycount-30.)*5000) ]
        age1here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data2[ 0, (age1here + (daycount-30.)*5000) ]
        age1_dataNI[daycount,age1here] = data2[ response, (age1here + (daycount-30.)*5000) ]
        age2here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data2[ 0, (age2here + (daycount-30.)*5000) ]
        age2_dataNI[daycount,age2here] = data2[ response, (age2here + (daycount-30.)*5000) ]
        age3here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data2[ 0, (age3here + (daycount-30.)*5000) ]
        age3_dataNI[daycount,age3here] = data2[ response, (age3here + (daycount-30.)*5000) ]
        age4here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data2[ 0, (age4here + (daycount-30.)*5000) ]
        age4_dataNI[daycount,age4here] = data2[ response, (age4here + (daycount-30.)*5000) ]
        age5here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data2[ 0, (age5here + (daycount-30.)*5000) ]
        age5_dataNI[daycount,age5here] = data2[ response, (age5here + (daycount-30.)*5000) ]
        age6here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data2[ 0, (age6here + (daycount-30.)*5000) ]
        age6plus_dataNI[daycount,age6here] = data2[ response, (age6here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
        age0_dataNI[daycount,age0here] = data3[ response, (age0here + (daycount-60.)*5000) ]
        age1here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data3[ 0, (age1here + (daycount-60.)*5000) ]
        age1_dataNI[daycount,age1here] = data3[ response, (age1here + (daycount-60.)*5000) ]
        age2here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data3[ 0, (age2here + (daycount-60.)*5000) ]
        age2_dataNI[daycount,age2here] = data3[ response, (age2here + (daycount-60.)*5000) ]
        age3here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data3[ 0, (age3here + (daycount-60.)*5000) ]
        age3_dataNI[daycount,age3here] = data3[ response, (age3here + (daycount-60.)*5000) ]
        age4here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data3[ 0, (age4here + (daycount-60.)*5000) ]
        age4_dataNI[daycount,age4here] = data3[ response, (age4here + (daycount-60.)*5000) ]
        age5here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data3[ 0, (age5here + (daycount-60.)*5000) ]
        age5_dataNI[daycount,age5here] = data3[ response, (age5here + (daycount-60.)*5000) ]
        age6here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data3[ 0, (age6here + (daycount-60.)*5000) ]
        age6plus_dataNI[daycount,age6here] = data3[ response, (age6here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
        age0_dataNI[daycount,age0here] = data4[ response, (age0here + (daycount-90.)*5000) ]
        age1here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 1) 
        age1_popnNI[daycount,age1here] = data4[ 0, (age1here + (daycount-90.)*5000) ]
        age1_dataNI[daycount,age1here] = data4[ response, (age1here + (daycount-90.)*5000) ]
        age2here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 2) 
        age2_popnNI[daycount,age2here] = data4[ 0, (age2here + (daycount-90.)*5000) ]
        age2_dataNI[daycount,age2here] = data4[ response, (age2here + (daycount-90.)*5000) ]
        age3here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 3) 
        age3_popnNI[daycount,age3here] = data4[ 0, (age3here + (daycount-90.)*5000) ]
        age3_dataNI[daycount,age3here] = data4[ response, (age3here + (daycount-90.)*5000) ]
        age4here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 4) 
        age4_popnNI[daycount,age4here] = data4[ 0, (age4here + (daycount-90.)*5000) ]
        age4_dataNI[daycount,age4here] = data4[ response, (age4here + (daycount-90.)*5000) ]
        age5here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 5) 
        age5_popnNI[daycount,age5here] = data4[ 0, (age5here + (daycount-90.)*5000) ]
        age5_dataNI[daycount,age5here] = data4[ response, (age5here + (daycount-90.)*5000) ]
        age6here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data4[ 0, (age6here + (daycount-90.)*5000) ]
        age6plus_dataNI[daycount,age6here] = data4[ response, (age6here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
        age0_dataNI[daycount,age0here] = data5[ response, (age0here + (daycount-120.)*5000) ]
        age1here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnNI[daycount,age1here] = data5[ 0, (age1here + (daycount-120.)*5000) ]
        age1_dataNI[daycount,age1here] = data5[ response, (age1here + (daycount-120.)*5000) ]
        age2here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnNI[daycount,age2here] = data5[ 0, (age2here + (daycount-120.)*5000) ]
        age2_dataNI[daycount,age2here] = data5[ response, (age2here + (daycount-120.)*5000) ]
        age3here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnNI[daycount,age3here] = data5[ 0, (age3here + (daycount-120.)*5000) ]
        age3_dataNI[daycount,age3here] = data5[ response, (age3here + (daycount-120.)*5000) ]
        age4here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnNI[daycount,age4here] = data5[ 0, (age4here + (daycount-120.)*5000) ]
        age4_dataNI[daycount,age4here] = data5[ response, (age4here + (daycount-120.)*5000) ]
        age5here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnNI[daycount,age5here] = data5[ 0, (age5here + (daycount-120.)*5000) ]
        age5_dataNI[daycount,age5here] = data5[ response, (age5here + (daycount-120.)*5000) ]
        age6here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data5[ 0, (age6here + (daycount-120.)*5000) ]
        age6plus_dataNI[daycount,age6here] = data5[ response, (age6here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
        age0_dataNI[daycount,age0here] = data6[ response, (age0here + (daycount-150.)*5000) ]
        age1here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 1) ;- (daycount-120.)*5000
        age1_popnNI[daycount,age1here] = data6[ 0, (age1here + (daycount-150.)*5000) ]
        age1_dataNI[daycount,age1here] = data6[ response, (age1here + (daycount-150.)*5000) ]
        age2here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 2) ;- (daycount-120.)*5000
        age2_popnNI[daycount,age2here] = data6[ 0, (age2here + (daycount-150.)*5000) ]
        age2_dataNI[daycount,age2here] = data6[ response, (age2here + (daycount-150.)*5000) ]
        age3here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 3) ;- (daycount-120.)*5000
        age3_popnNI[daycount,age3here] = data6[ 0, (age3here + (daycount-150.)*5000) ]
        age3_dataNI[daycount,age3here] = data6[ response, (age3here + (daycount-150.)*5000) ]
        age4here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 4) ;- (daycount-120.)*5000
        age4_popnNI[daycount,age4here] = data6[ 0, (age4here + (daycount-150.)*5000) ]
        age4_dataNI[daycount,age4here] = data6[ response, (age4here + (daycount-150.)*5000) ]
        age5here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 5) ;- (daycount-120.)*5000
        age5_popnNI[daycount,age5here] = data6[ 0, (age5here + (daycount-150.)*5000) ]
        age5_dataNI[daycount,age5here] = data6[ response, (age5here + (daycount-150.)*5000) ]
        age6here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) gt 5) 
        age6plus_popnNI[daycount,age6here] = data6[ 0, (age6here + (daycount-150.)*5000) ]
        age6plus_dataNI[daycount,age6here] = data6[ response, (age6here + (daycount-150.)*5000) ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
endfor;---------------------------------------------------------------------------------------TIMING END

for a = 0,nDays-1 do begin
  tot_age0_popn[a] = total(age0_popnNI[a,*])
endfor
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day

if myplot eq 'species' then begin  ; plot all age classes of a species

age0_popn24     = [ [age0_popnMO],[age0_popnMI],[age0_popnAF],[age0_popnNI] ]  ; 24 = all day
age0_data24     = [ [age0_dataMO],[age0_dataMI],[age0_dataAF],[age0_dataNI] ]
age1_popn24     = [ [age1_popnMO],[age1_popnMI],[age1_popnAF],[age1_popnNI] ]
age1_data24     = [ [age1_dataMO],[age1_dataMI],[age1_dataAF],[age1_dataNI] ]
age2_popn24     = [ [age2_popnMO],[age2_popnMI],[age2_popnAF],[age2_popnNI] ]
age2_data24     = [ [age2_dataMO],[age2_dataMI],[age2_dataAF],[age2_dataNI] ]
age3_popn24     = [ [age3_popnMO],[age3_popnMI],[age3_popnAF],[age3_popnNI] ]
age3_data24     = [ [age3_dataMO],[age3_dataMI],[age3_dataAF],[age3_dataNI] ]
age4_popn24     = [ [age4_popnMO],[age4_popnMI],[age4_popnAF],[age4_popnNI] ]
age4_data24     = [ [age4_dataMO],[age4_dataMI],[age4_dataAF],[age4_dataNI] ]
age5_popn24     = [ [age5_popnMO],[age5_popnMI],[age5_popnAF],[age5_popnNI] ]
age5_data24     = [ [age5_dataMO],[age5_dataMI],[age5_dataAF],[age5_dataNI] ]
age6plus_popn24 = [ [age6plus_popnMO],[age6plus_popnMI],[age6plus_popnAF],[age6plus_popnNI] ]
age6plus_data24 = [ [age6plus_dataMO],[age6plus_dataMI],[age6plus_dataAF],[age6plus_dataNI] ]

; initialize arrays to hold plotting data
tot_age0_popn = fltarr(nDays)
W_age0_dpth   = fltarr(nDays,20000)
avg_age0_dpth = fltarr(nDays)
tot_age1_popn = fltarr(nDays)
W_age1_dpth   = fltarr(nDays,20000)
avg_age1_dpth = fltarr(nDays)
tot_age2_popn = fltarr(nDays)
W_age2_dpth   = fltarr(nDays,20000)
avg_age2_dpth = fltarr(nDays)
tot_age3_popn = fltarr(nDays)
W_age3_dpth   = fltarr(nDays,20000)
avg_age3_dpth = fltarr(nDays)
tot_age4_popn = fltarr(nDays)
W_age4_dpth   = fltarr(nDays,20000)
avg_age4_dpth = fltarr(nDays)
tot_age5_popn = fltarr(nDays)
W_age5_dpth   = fltarr(nDays,20000)
avg_age5_dpth = fltarr(nDays)
tot_age6plus_popn = fltarr(nDays)
W_age6plus_dpth   = fltarr(nDays,20000)
avg_age6plus_dpth = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  ; get total population for each day for each age class
  tot_age0_popn[a] = total(age0_popn24[a,*])
  tot_age1_popn[a] = total(age1_popn24[a,*])
  tot_age2_popn[a] = total(age2_popn24[a,*])
  tot_age3_popn[a] = total(age3_popn24[a,*])
  tot_age4_popn[a] = total(age4_popn24[a,*])
  tot_age5_popn[a] = total(age5_popn24[a,*])
  tot_age6plus_popn[a] = total(age6plus_popn24[a,*])
  
  for r = 0,19999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpth[a,r]     = (age0_data24[a,r]+1) * age0_popn24[a,r]
    W_age1_dpth[a,r]     = (age1_data24[a,r]+1) * age1_popn24[a,r]
    W_age2_dpth[a,r]     = (age2_data24[a,r]+1) * age2_popn24[a,r]
    W_age3_dpth[a,r]     = (age3_data24[a,r]+1) * age3_popn24[a,r]
    W_age4_dpth[a,r]     = (age4_data24[a,r]+1) * age4_popn24[a,r]
    W_age5_dpth[a,r]     = (age5_data24[a,r]+1) * age5_popn24[a,r]
    W_age6plus_dpth[a,r] = (age6plus_data24[a,r]+1) * age6plus_popn24[a,r]
  endfor
  avg_age0_dpth[a]     = ( ( total(W_age0_dpth[a,*]) ) / tot_age0_popn[a] ) /2  ; /2 because
  avg_age1_dpth[a]     = ( ( total(W_age1_dpth[a,*]) ) / tot_age1_popn[a] ) /2  ; 2 cells per meter
  avg_age2_dpth[a]     = ( ( total(W_age2_dpth[a,*]) ) / tot_age2_popn[a] ) /2
  avg_age3_dpth[a]     = ( ( total(W_age3_dpth[a,*]) ) / tot_age3_popn[a] ) /2
  avg_age4_dpth[a]     = ( ( total(W_age4_dpth[a,*]) ) / tot_age4_popn[a] ) /2
  avg_age5_dpth[a]     = ( ( total(W_age5_dpth[a,*]) ) / tot_age5_popn[a] ) /2
  avg_age6plus_dpth[a] = ( ( total(W_age6plus_dpth[a,*]) ) / tot_age6plus_popn[a] ) /2    
endfor

;check
days = findgen(nDays)
avg_all_dpth = fltarr(nDays)
avg_all_dpth[days] = (avg_age0_dpth[days]*tot_age0_popn[days] + $
                      avg_age1_dpth[days]*tot_age1_popn[days] + $
                      avg_age2_dpth[days]*tot_age2_popn[days] + $
                      avg_age3_dpth[days]*tot_age3_popn[days] + $
                      avg_age4_dpth[days]*tot_age4_popn[days] + $
                      avg_age5_dpth[days]*tot_age5_popn[days] + $
                      avg_age6plus_dpth[days]*tot_age6plus_popn[days]) / $
                     (tot_age0_popn[days] + tot_age1_popn[days] + $
                      tot_age2_popn[days] + tot_age3_popn[days] + $
                      tot_age4_popn[days] + tot_age5_popn[days] + $
                      tot_age6plus_popn[days])


; plot YEP
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit

; plot average depth for different size classes

a0d = plot(axisdays, avg_age0_dpth, 'navy', thick=3, name='Age 0', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
a1d = plot(axisdays, avg_age1_dpth, 'medium blue', thick=3, name='Age 1', /overplot)
a2d = plot(axisdays, avg_age2_dpth, 'blue', thick=3, name='Age 2', /overplot)
a3d = plot(axisdays, avg_age3_dpth, 'royal blue', thick=3, name='Age 3', /overplot)
a4d = plot(axisdays, avg_age4_dpth, 'maroon', thick=3, name='Age 4', /overplot)
a5d = plot(axisdays, avg_age5_dpth, 'firebrick', thick=3, name='Age 5', /overplot)
a6d = plot(axisdays, avg_age6plus_dpth, 'crimson', thick=3, name='Age 6+', /overplot)
alld = plot(axisdays, avg_all_dpth, 'lime green', thick=3, name='All', linestyle=2, /overplot)
Ld  = legend(target=[a0d,a1d,a2d,a3d,a4d,a5d,a6d,alld], position=[0.18,0.88], shadow=0)  ; to include overall average depth
;Ld  = legend(target=[a0d,a1d,a2d,a3d,a4d,a5d,a6d], position=[0.18,0.88], shadow=0)  ; to exclude overall average depth

endif

if myplot eq 'age' then begin  ; plots one age class by time

tot_age0_popnMO      = fltarr(nDays)
tot_age1_popnMO      = fltarr(nDays)
tot_age2_popnMO      = fltarr(nDays)
tot_age3_popnMO      = fltarr(nDays)
tot_age4_popnMO      = fltarr(nDays)
tot_age5_popnMO      = fltarr(nDays)
tot_age6plus_popnMO  = fltarr(nDays)
tot_age0_popnMI      = fltarr(nDays)
tot_age1_popnMI      = fltarr(nDays)
tot_age2_popnMI      = fltarr(nDays)
tot_age3_popnMI      = fltarr(nDays)
tot_age4_popnMI      = fltarr(nDays)
tot_age5_popnMI      = fltarr(nDays)
tot_age6plus_popnMI  = fltarr(nDays)
tot_age0_popnAF      = fltarr(nDays)
tot_age1_popnAF      = fltarr(nDays)
tot_age2_popnAF      = fltarr(nDays)
tot_age3_popnAF      = fltarr(nDays)
tot_age4_popnAF      = fltarr(nDays)
tot_age5_popnAF      = fltarr(nDays)
tot_age6plus_popnAF  = fltarr(nDays)
tot_age0_popnNI      = fltarr(nDays)
tot_age1_popnNI      = fltarr(nDays)
tot_age2_popnNI      = fltarr(nDays)
tot_age3_popnNI      = fltarr(nDays)
tot_age4_popnNI      = fltarr(nDays)
tot_age5_popnNI      = fltarr(nDays)
tot_age6plus_popnNI  = fltarr(nDays)
W_age0_dpthMO        = fltarr(nDays,5000)
W_age1_dpthMO        = fltarr(nDays,5000)
W_age2_dpthMO        = fltarr(nDays,5000)
W_age3_dpthMO        = fltarr(nDays,5000)
W_age4_dpthMO        = fltarr(nDays,5000)
W_age5_dpthMO        = fltarr(nDays,5000)
W_age6plus_dpthMO    = fltarr(nDays,5000)
W_age0_dpthMI        = fltarr(nDays,5000)
W_age1_dpthMI        = fltarr(nDays,5000)
W_age2_dpthMI        = fltarr(nDays,5000)
W_age3_dpthMI        = fltarr(nDays,5000)
W_age4_dpthMI        = fltarr(nDays,5000)
W_age5_dpthMI        = fltarr(nDays,5000)
W_age6plus_dpthMI    = fltarr(nDays,5000)
W_age0_dpthAF        = fltarr(nDays,5000)
W_age1_dpthAF        = fltarr(nDays,5000)
W_age2_dpthAF        = fltarr(nDays,5000)
W_age3_dpthAF        = fltarr(nDays,5000)
W_age4_dpthAF        = fltarr(nDays,5000)
W_age5_dpthAF        = fltarr(nDays,5000)
W_age6plus_dpthAF    = fltarr(nDays,5000)
W_age0_dpthNI        = fltarr(nDays,5000)
W_age1_dpthNI        = fltarr(nDays,5000)
W_age2_dpthNI        = fltarr(nDays,5000)
W_age3_dpthNI        = fltarr(nDays,5000)
W_age4_dpthNI        = fltarr(nDays,5000)
W_age5_dpthNI        = fltarr(nDays,5000)
W_age6plus_dpthNI    = fltarr(nDays,5000)
Wavg_age0_dpthMO     = fltarr(nDays)
Wavg_age1_dpthMO     = fltarr(nDays)
Wavg_age2_dpthMO     = fltarr(nDays)
Wavg_age3_dpthMO     = fltarr(nDays)
Wavg_age4_dpthMO     = fltarr(nDays)
Wavg_age5_dpthMO     = fltarr(nDays)
Wavg_age6plus_dpthMO = fltarr(nDays)
Wavg_age0_dpthMI     = fltarr(nDays)
Wavg_age1_dpthMI     = fltarr(nDays)
Wavg_age2_dpthMI     = fltarr(nDays)
Wavg_age3_dpthMI     = fltarr(nDays)
Wavg_age4_dpthMI     = fltarr(nDays)
Wavg_age5_dpthMI     = fltarr(nDays)
Wavg_age6plus_dpthMI = fltarr(nDays)
Wavg_age0_dpthAF     = fltarr(nDays)
Wavg_age1_dpthAF     = fltarr(nDays)
Wavg_age2_dpthAF     = fltarr(nDays)
Wavg_age3_dpthAF     = fltarr(nDays)
Wavg_age4_dpthAF     = fltarr(nDays)
Wavg_age5_dpthAF     = fltarr(nDays)
Wavg_age6plus_dpthAF = fltarr(nDays)
Wavg_age0_dpthNI     = fltarr(nDays)
Wavg_age1_dpthNI     = fltarr(nDays)
Wavg_age2_dpthNI     = fltarr(nDays)
Wavg_age3_dpthNI     = fltarr(nDays)
Wavg_age4_dpthNI     = fltarr(nDays)
Wavg_age5_dpthNI     = fltarr(nDays)
Wavg_age6plus_dpthNI = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_age0_popnMO[a]     = total(age0_popnMO[a,*])
  tot_age1_popnMO[a]     = total(age1_popnMO[a,*])
  tot_age2_popnMO[a]     = total(age2_popnMO[a,*])
  tot_age3_popnMO[a]     = total(age3_popnMO[a,*])
  tot_age4_popnMO[a]     = total(age4_popnMO[a,*])
  tot_age5_popnMO[a]     = total(age5_popnMO[a,*])
  tot_age6plus_popnMO[a] = total(age6plus_popnMO[a,*])
  tot_age0_popnMI[a]     = total(age0_popnMI[a,*])
  tot_age1_popnMI[a]     = total(age1_popnMI[a,*])
  tot_age2_popnMI[a]     = total(age2_popnMI[a,*])
  tot_age3_popnMI[a]     = total(age3_popnMI[a,*])
  tot_age4_popnMI[a]     = total(age4_popnMI[a,*])
  tot_age5_popnMI[a]     = total(age5_popnMI[a,*])
  tot_age6plus_popnMI[a] = total(age6plus_popnMI[a,*])
  tot_age0_popnAF[a]     = total(age0_popnAF[a,*])
  tot_age1_popnAF[a]     = total(age1_popnAF[a,*])
  tot_age2_popnAF[a]     = total(age2_popnAF[a,*])
  tot_age3_popnAF[a]     = total(age3_popnAF[a,*])
  tot_age4_popnAF[a]     = total(age4_popnAF[a,*])
  tot_age5_popnAF[a]     = total(age5_popnAF[a,*])
  tot_age6plus_popnAF[a] = total(age6plus_popnAF[a,*])
  tot_age0_popnNI[a]     = total(age0_popnNI[a,*])
  tot_age1_popnNI[a]     = total(age1_popnNI[a,*])
  tot_age2_popnNI[a]     = total(age2_popnNI[a,*])
  tot_age3_popnNI[a]     = total(age3_popnNI[a,*])
  tot_age4_popnNI[a]     = total(age4_popnNI[a,*])
  tot_age5_popnNI[a]     = total(age5_popnNI[a,*])
  tot_age6plus_popnNI[a] = total(age6plus_popnNI[a,*])
  for r = 0,4999 do begin  ; total up depth response to calculate weighted average
    W_age0_dpthMO[a,r]   = (age0_dataMO[a,r]+1) * age0_popnMO[a,r]
    W_age1_dpthMO[a,r]   = (age1_dataMO[a,r]+1) * age1_popnMO[a,r]
    W_age2_dpthMO[a,r]   = (age2_dataMO[a,r]+1) * age2_popnMO[a,r]
    W_age3_dpthMO[a,r]   = (age3_dataMO[a,r]+1) * age3_popnMO[a,r]
    W_age4_dpthMO[a,r]   = (age4_dataMO[a,r]+1) * age4_popnMO[a,r]
    W_age5_dpthMO[a,r]   = (age5_dataMO[a,r]+1) * age5_popnMO[a,r]
    W_age6plus_dpthMO[a,r] = (age6plus_dataMO[a,r]+1) * age6plus_popnMO[a,r]
    W_age0_dpthMI[a,r]   = (age0_dataMI[a,r]+1) * age0_popnMI[a,r]
    W_age1_dpthMI[a,r]   = (age1_dataMI[a,r]+1) * age1_popnMI[a,r]
    W_age2_dpthMI[a,r]   = (age2_dataMI[a,r]+1) * age2_popnMI[a,r]
    W_age3_dpthMI[a,r]   = (age3_dataMI[a,r]+1) * age3_popnMI[a,r]
    W_age4_dpthMI[a,r]   = (age4_dataMI[a,r]+1) * age4_popnMI[a,r]
    W_age5_dpthMI[a,r]   = (age5_dataMI[a,r]+1) * age5_popnMI[a,r]
    W_age6plus_dpthMI[a,r] = (age6plus_dataMI[a,r]+1) * age6plus_popnMI[a,r]
    W_age0_dpthAF[a,r]   = (age0_dataAF[a,r]+1) * age0_popnAF[a,r]
    W_age1_dpthAF[a,r]   = (age1_dataAF[a,r]+1) * age1_popnAF[a,r]
    W_age2_dpthAF[a,r]   = (age2_dataAF[a,r]+1) * age2_popnAF[a,r]
    W_age3_dpthAF[a,r]   = (age3_dataAF[a,r]+1) * age3_popnAF[a,r]
    W_age4_dpthAF[a,r]   = (age4_dataAF[a,r]+1) * age4_popnAF[a,r]
    W_age5_dpthAF[a,r]   = (age5_dataAF[a,r]+1) * age5_popnAF[a,r]
    W_age6plus_dpthAF[a,r] = (age6plus_dataAF[a,r]+1) * age6plus_popnAF[a,r]
    W_age0_dpthNI[a,r]   = (age0_dataNI[a,r]+1) * age0_popnNI[a,r]
    W_age1_dpthNI[a,r]   = (age1_dataNI[a,r]+1) * age1_popnNI[a,r]
    W_age2_dpthNI[a,r]   = (age2_dataNI[a,r]+1) * age2_popnNI[a,r]
    W_age3_dpthNI[a,r]   = (age3_dataNI[a,r]+1) * age3_popnNI[a,r]
    W_age4_dpthNI[a,r]   = (age4_dataNI[a,r]+1) * age4_popnNI[a,r]
    W_age5_dpthNI[a,r]   = (age5_dataNI[a,r]+1) * age5_popnNI[a,r]
    W_age6plus_dpthNI[a,r] = (age6plus_dataNI[a,r]+1) * age6plus_popnNI[a,r]
  endfor
  Wavg_age0_dpthMO[a]     = ( ( total(W_age0_dpthMO[a,*]) ) / tot_age0_popnMO[a] ) /2  ; /2 because
  Wavg_age1_dpthMO[a]     = ( ( total(W_age1_dpthMO[a,*]) ) / tot_age1_popnMO[a] ) /2  ; 2 cells/m
  Wavg_age2_dpthMO[a]     = ( ( total(W_age2_dpthMO[a,*]) ) / tot_age2_popnMO[a] ) /2
  Wavg_age3_dpthMO[a]     = ( ( total(W_age3_dpthMO[a,*]) ) / tot_age3_popnMO[a] ) /2
  Wavg_age4_dpthMO[a]     = ( ( total(W_age4_dpthMO[a,*]) ) / tot_age4_popnMO[a] ) /2
  Wavg_age5_dpthMO[a]     = ( ( total(W_age5_dpthMO[a,*]) ) / tot_age5_popnMO[a] ) /2
  Wavg_age6plus_dpthMO[a] = ( ( total(W_age6plus_dpthMO[a,*]) ) / tot_age6plus_popnMO[a] ) /2  
  Wavg_age0_dpthMI[a]     = ( ( total(W_age0_dpthMI[a,*]) ) / tot_age0_popnMI[a] ) /2
  Wavg_age1_dpthMI[a]     = ( ( total(W_age1_dpthMI[a,*]) ) / tot_age1_popnMI[a] ) /2
  Wavg_age2_dpthMI[a]     = ( ( total(W_age2_dpthMI[a,*]) ) / tot_age2_popnMI[a] ) /2
  Wavg_age3_dpthMI[a]     = ( ( total(W_age3_dpthMI[a,*]) ) / tot_age3_popnMI[a] ) /2
  Wavg_age4_dpthMI[a]     = ( ( total(W_age4_dpthMI[a,*]) ) / tot_age4_popnMI[a] ) /2
  Wavg_age5_dpthMI[a]     = ( ( total(W_age5_dpthMI[a,*]) ) / tot_age5_popnMI[a] ) /2
  Wavg_age6plus_dpthMI[a] = ( ( total(W_age6plus_dpthMI[a,*]) ) / tot_age6plus_popnMI[a] ) /2
  Wavg_age0_dpthAF[a]     = ( ( total(W_age0_dpthAF[a,*]) ) / tot_age0_popnAF[a] ) /2
  Wavg_age1_dpthAF[a]     = ( ( total(W_age1_dpthAF[a,*]) ) / tot_age1_popnAF[a] ) /2
  Wavg_age2_dpthAF[a]     = ( ( total(W_age2_dpthAF[a,*]) ) / tot_age2_popnAF[a] ) /2
  Wavg_age3_dpthAF[a]     = ( ( total(W_age3_dpthAF[a,*]) ) / tot_age3_popnAF[a] ) /2
  Wavg_age4_dpthAF[a]     = ( ( total(W_age4_dpthAF[a,*]) ) / tot_age4_popnAF[a] ) /2
  Wavg_age5_dpthAF[a]     = ( ( total(W_age5_dpthAF[a,*]) ) / tot_age5_popnAF[a] ) /2
  Wavg_age6plus_dpthAF[a] = ( ( total(W_age6plus_dpthAF[a,*]) ) / tot_age6plus_popnAF[a] ) /2
  Wavg_age0_dpthNI[a]     = ( ( total(W_age0_dpthNI[a,*]) ) / tot_age0_popnNI[a] ) /2
  Wavg_age1_dpthNI[a]     = ( ( total(W_age1_dpthNI[a,*]) ) / tot_age1_popnNI[a] ) /2
  Wavg_age2_dpthNI[a]     = ( ( total(W_age2_dpthNI[a,*]) ) / tot_age2_popnNI[a] ) /2
  Wavg_age3_dpthNI[a]     = ( ( total(W_age3_dpthNI[a,*]) ) / tot_age3_popnNI[a] ) /2
  Wavg_age4_dpthNI[a]     = ( ( total(W_age4_dpthNI[a,*]) ) / tot_age4_popnNI[a] ) /2
  Wavg_age5_dpthNI[a]     = ( ( total(W_age5_dpthNI[a,*]) ) / tot_age5_popnNI[a] ) /2
  Wavg_age6plus_dpthNI[a] = ( ( total(W_age6plus_dpthNI[a,*]) ) / tot_age6plus_popnNI[a] ) /2
endfor

for ageplot = 0,ageclasses-1 do begin

  if ageplot eq 0 then begin
    agetext  = 'Ageclass 0'
    MO_depth = Wavg_age0_dpthMO
    MI_depth = Wavg_age0_dpthMI
    AF_depth = Wavg_age0_dpthAF
    NI_depth = Wavg_age0_dpthNI
  endif
  if ageplot eq 1 then begin
    agetext  = 'Ageclass 1'
    MO_depth = Wavg_age1_dpthMO
    MI_depth = Wavg_age1_dpthMI
    AF_depth = Wavg_age1_dpthAF
    NI_depth = Wavg_age1_dpthNI
  endif
  if ageplot eq 2 then begin
    agetext  = 'Ageclass 2'
    MO_depth = Wavg_age2_dpthMO
    MI_depth = Wavg_age2_dpthMI
    AF_depth = Wavg_age2_dpthAF
    NI_depth = Wavg_age2_dpthNI
  endif
  if ageplot eq 3 then begin
    agetext  = 'Ageclass 3'
    MO_depth = Wavg_age3_dpthMO
    MI_depth = Wavg_age3_dpthMI
    AF_depth = Wavg_age3_dpthAF
    NI_depth = Wavg_age3_dpthNI
  endif
  if ageplot eq 4 then begin
    agetext  = 'Ageclass 4'
    MO_depth = Wavg_age4_dpthMO
    MI_depth = Wavg_age4_dpthMI
    AF_depth = Wavg_age4_dpthAF
    NI_depth = Wavg_age4_dpthNI
  endif
  if ageplot eq 5 then begin
    agetext  = 'Ageclass 5'
    MO_depth = Wavg_age5_dpthMO
    MI_depth = Wavg_age5_dpthMI
    AF_depth = Wavg_age5_dpthAF
    NI_depth = Wavg_age5_dpthNI
  endif
  if ageplot eq 6 then begin
    agetext  = 'Ageclass 6+'
    MO_depth = Wavg_age6plus_dpthMO
    MI_depth = Wavg_age6plus_dpthMI
    AF_depth = Wavg_age6plus_dpthAF
    NI_depth = Wavg_age6plus_dpthNI
  endif
  

dMO = plot(axisdays, MO_depth, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
dMI = plot(axisdays, MI_depth, 'orange red', thick=3, name='Midday', /overplot)
dAF = plot(axisdays, AF_depth, 'gold', thick=3, name='Afternoon', /overplot)
dNI = plot(axisdays, NI_depth, 'midnight blue', thick=3, name='Night', /overplot)
Ld  = legend(target=[dMO,dMI,dAF,dNI], position=[0.66,0.85], shadow=0)
dTxt= text(0.18,0.85,agetext,/current)

endfor

; to plot individuals:
; dIND = plot(axisdays,(age0_dataMO[*,4563]+1)/2,'lime',thick=1,/overplot)
;                 age class^ time^^   ^^^^individual number
; To plot individuals for a specific age class, highlight the XX_depth segments for that age class
; and run them to make sure the correct data are plotted.

endif


endif;--------------------END YEP-----------------------------------------------------------------------

endfor ;fish loop
; plot Age 0 population size (recruitment)
all_age0_popn = all_age0_popn / 1000000
AzeroWAE = plot(axisdays, all_age0_popn[*,0], 'dark khaki', thick=3, name='Walleye', $
           xtitle='Month', ytitle='Number of Fish (millions)', xrange=[startday,(startday+nDays-1)], $
           title=year+': Hypoxia '+HH+', Density Dependence '+DD+', Recruitment', $
           xticks=6, /data, xtickv=[152,182,212,242,272,302], $
           xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], xminor=0, xticklen=0, $
           margin=[0.15,0.1,0.1,0.1], yrange=[0,500])
AzeroYEP = plot(axisdays, all_age0_popn[*,1], 'goldenrod', thick=3, name='Yellow Perch', /overplot)
AzeroRAS = plot(axisdays, all_age0_popn[*,1], 'hot pink', thick=3, name='Rainbow Smelt', /overplot)
AzeroEMS = plot(axisdays, all_age0_popn[*,1], 'lime green', thick=3, name='Emerald Shiner', /overplot)
LegAge0  = legend(target=[AzeroWAE,AzeroYEP,AzeroRAS,AzeroEMS], position=[0.55,0.85], shadow=0)

end_time = systime(/seconds)
thismany = string((end_time - start_time)/60)
print,'Your figure took '+thismany+' minutes to produce.'

end