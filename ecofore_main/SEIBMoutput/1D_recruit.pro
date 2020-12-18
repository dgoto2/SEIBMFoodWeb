; 1D_recruit.pro
; Compiles and plots recruitment for the 1D EcoFore model.
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

;---------------------------------------------BEGIN EMS/RAS-----------------------------------------------
if tax eq 'EMS' || tax eq 'RAS' then begin

age0_popnNI     = fltarr(nDays,5000)  ; NI = night

; access data files
daycount = 0.

;----------------------------------------------------MIDNIGHT BEGIN
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
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) ;- (daycount-30.)*5000
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) ;- (daycount-60.)*5000
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) ;- (daycount-90.)*5000
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
      endif
      tot_age0_popn[daycount] = total(age0_popnNI[daycount,*])
    endfor;---------------------------------------------DAYS END

  
;for a = 0,nDays-1 do begin
;  tot_age0_popn[a] = total(age0_popnNI[a,*])
;endfor
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day


endif;--------------------END EMS/RAS-------------------------------------------------------------------



;---------------------------------------------BEGIN WAE-----------------------------------------------
if tax eq 'WAE' then begin


age0_popnNI     = fltarr(nDays,5000)  ; NI = night

; access data files
daycount = 0.

;----------------------------------------------------MIDNIGHT BEGIN
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
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
      endif
      tot_age0_popn[daycount] = total(age0_popnNI[daycount,*])
    endfor;---------------------------------------------DAYS END
  
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day


endif;--------------------END WAE-----------------------------------------------------------------------


;---------------------------------------------BEGIN YEP-----------------------------------------------
if tax eq 'YEP' then begin


age0_popnNI     = fltarr(nDays,5000)  ; NI = night

; access data files
daycount = 0.

;----------------------------------------------------MIDNIGHT BEGIN
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
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data2(6,((daycount-30.)*5000):((daycount-30.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data2[ 0, (age0here + (daycount-30.)*5000) ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data3(6,((daycount-60.)*5000):((daycount-60.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data3[ 0, (age0here + (daycount-60.)*5000) ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data4(6,((daycount-90.)*5000):((daycount-90.)*5000)+4999) eq 0) 
        age0_popnNI[daycount,age0here] = data4[ 0, (age0here + (daycount-90.)*5000) ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data5(6,((daycount-120.)*5000):((daycount-120.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data5[ 0, (age0here + (daycount-120.)*5000) ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        age0here = where(data6(6,((daycount-150.)*5000):((daycount-150.)*5000)+4999) eq 0) ;- (daycount-120.)*5000
        age0_popnNI[daycount,age0here] = data6[ 0, (age0here + (daycount-150.)*5000) ]
      endif
      tot_age0_popn[daycount] = total(age0_popnNI[daycount,*])
    endfor;---------------------------------------------DAYS END
  
all_age0_popn[*,ff] = tot_age0_popn  ; how many fish were alive at the end of each day

endif;--------------------END YEP-----------------------------------------------------------------------


endfor ;fish loop

; plot Age 0 population size (recruitment)
all_age0_popn = all_age0_popn /1000000
AzeroWAE = plot(axisdays, all_age0_popn[*,0], 'dark khaki', thick=3, name='Walleye', $
           xtitle='Month', ytitle='Number of Fish (millions)', xrange=[startday,(startday+nDays-1)], $
           title=year+': Hypoxia '+HH+', Density Dependence '+DD+', Age-0 Survival', $
           xticks=6, /data, xtickv=[152,182,212,242,272,302], $
           xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], xminor=0, xticklen=0, $
           margin=[0.15,0.1,0.1,0.1], yrange=[0.101,1000], /ylog)
AzeroYEP = plot(axisdays, all_age0_popn[*,1], 'goldenrod', thick=3, name='Yellow Perch', /overplot)
AzeroRAS = plot(axisdays, all_age0_popn[*,2], 'hot pink', thick=3, name='Rainbow Smelt', /overplot)
AzeroEMS = plot(axisdays, all_age0_popn[*,3], 'lime green', thick=3, name='Emerald Shiner', /overplot)
LegAge0  = legend(target=[AzeroWAE,AzeroYEP,AzeroRAS,AzeroEMS], position=[0.55,0.85], shadow=0)

end_time = systime(/seconds)
thismany = string((end_time - start_time)/60)
print,'Your figure took '+thismany+' minutes to produce.'

end