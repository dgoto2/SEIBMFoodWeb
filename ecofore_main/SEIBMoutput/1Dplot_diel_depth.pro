; 1Dplot_diel_depth.pro
; makes one-year line graph of average depth for one species in 1D SE Lake Erie EcoFore model
; TM Sesterhenn, February 2012

start_time = systime(/seconds)

; which year?
year = '1996'

; is hypoxia effect 'ON' or 'OFF'?
HH = 'ON'

; is density-dependence 'ON' or 'OFF'?
DD = 'ON'

; where are the files containing data?
drive = 'E:\'
dir   = 'Purdue\1Doutput_2-27\1996-1_HH_on_DD_on\'

response = 14  ; depth

; taxa: 'YEP' = yellow perch, 'WAE' = walleye, 'EMS' = emerald shiner, 'RAS' = rainbow smelt
tax = 'EMS'

; input title for all figures
fig_title = year+': Hypoxia '+HH+', Density Dependence '+DD+', '+tax

;--------------------------------------------------------------------------------------------------------
; from here down it should run just fine by itself with no changes needed (except maybe figure stuff)
;--------------------------------------------------------------------------------------------------------


; set up days depending on year
;--------------------------------------------------------------make conditional for all years later!!!
if year eq '1987' then begin
  nDays    = 137.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif
if year eq '1995' then begin
  nDays    = 137.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif
if year eq '1996' then begin
  nDays    = 137.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif
if year eq '2005' then begin
  nDays    = 137.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif

axisdays    = indgen(nDays) + startday  ; makes array for x-axis on figures
morn_data   = fltarr(nDays,5000)
morn_popn   = fltarr(nDays,5000)
mid_data    = fltarr(nDays,5000)
mid_popn    = fltarr(nDays,5000)
aft_data    = fltarr(nDays,5000)
aft_popn    = fltarr(nDays,5000)
nght_data   = fltarr(nDays,5000)
nght_popn   = fltarr(nDays,5000)
allday_data = fltarr(nDays,20000)
allday_popn = fltarr(nDays,20000)

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
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 5 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 5 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 5 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,85000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 5 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        morn_data[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        morn_data[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        morn_data[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        morn_data[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        morn_data[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
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
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 5 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 5 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 5 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,85000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 5 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        mid_data[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        mid_data[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        mid_data[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        mid_data[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        mid_data[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
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
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 5 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 5 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 5 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,85000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 5 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        aft_data[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        aft_data[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        aft_data[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        aft_data[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        aft_data[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
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
    openr, lun, file1, /get_lun
    data1 = fltarr(70,150000)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 5 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(70,150000)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 5 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(70,150000)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 5 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(70,150000)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(70,85000)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 5 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        nght_data[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        nght_data[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        nght_data[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        nght_data[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        nght_data[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
endfor;---------------------------------------------------------------------------------------TIMING END

allday_data = [ [morn_data],[mid_data],[aft_data],[nght_data] ] ; puts all timings together
allday_popn = [ [morn_popn],[mid_popn],[aft_popn],[nght_popn] ]

; initialize arrays to hold plotting data
tot_morn_popn   = fltarr(nDays)
tot_mid_popn    = fltarr(nDays)
tot_aft_popn    = fltarr(nDays)
tot_nght_popn   = fltarr(nDays)
tot_allday_popn = fltarr(nDays)
W_resp_morn     = fltarr(nDays,5000)
W_resp_mid      = fltarr(nDays,5000)
W_resp_aft      = fltarr(nDays,5000)
W_resp_nght     = fltarr(nDays,5000)
W_resp_allday   = fltarr(nDays,20000)
avg_resp_morn   = fltarr(nDays)
avg_resp_mid    = fltarr(nDays)
avg_resp_aft    = fltarr(nDays)
avg_resp_nght   = fltarr(nDays)
avg_resp_allday = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_morn_popn[a]   = total(morn_popn[a,*])    ; these get the total population size for their
  tot_mid_popn[a]    = total(mid_popn[a,*])     ; respective time periods
  tot_aft_popn[a]    = total(aft_popn[a,*])
  tot_nght_popn[a]   = total(nght_popn[a,*])
  tot_allday_popn[a] = total(allday_popn[a,*])
  
  for r = 0,4999 do begin  ; total up depth response to calculate weighted average
    W_resp_morn[a,r]   = (morn_data[a,r]+1)   * morn_popn[a,r]
    W_resp_mid[a,r]    = (mid_data[a,r]+1)    * mid_popn[a,r]
    W_resp_aft[a,r]    = (aft_data[a,r]+1)    * aft_popn[a,r]
    W_resp_nght[a,r]   = (nght_data[a,r]+1)   * nght_popn[a,r]
    W_resp_allday[a,r] = (allday_data[a,r]+1) * allday_popn[a,r]
  endfor
  for r = 5000,19999 do begin  ; continue all day compilation
    W_resp_allday[a,r] = (allday_data[a,r]+1) * allday_popn[a,r]
  endfor
  avg_resp_morn[a]   = ( ( total(W_resp_morn[a,*]) )   / tot_morn_popn[a] ) /2   ; /2 because
  avg_resp_mid[a]    = ( ( total(W_resp_mid[a,*]) )    / tot_mid_popn[a] ) /2    ; 2 cells per
  avg_resp_aft[a]    = ( ( total(W_resp_aft[a,*]) )    / tot_aft_popn[a] ) /2    ; meter
  avg_resp_nght[a]   = ( ( total(W_resp_nght[a,*]) )   / (tot_nght_popn[a]) ) /2   ; (makes #cells
  avg_resp_allday[a] = ( ( total(W_resp_allday[a,*]) ) / tot_allday_popn[a] ) /2 ; into meters)
endfor



;---------------------------------------------------------------------------------------------------
; end data organization, begin plotting
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit


; plot average depth at different times of day
t1d = plot(axisdays, avg_resp_morn, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
t2d = plot(axisdays, avg_resp_mid, 'orange red', thick=3, name='Midday', /overplot)
t3d = plot(axisdays, avg_resp_aft, 'gold', thick=3, name='Afternoon', /overplot)
t4d = plot(axisdays, avg_resp_nght, 'midnight blue', thick=3, name='Night', /overplot)
;t5d = plot(axisdays, avg_resp_allday, 'forest green', thick=3, name='Entire Day', /overplot)
;Ld  = legend(target=[t1d,t2d,t3d,t4d,t5d], position=[0.18,0.88], shadow=0)
Ld  = legend(target=[t1d,t2d,t3d,t4d], position=[0.18,0.88], shadow=0)


end_time = systime(/seconds)
thismany = string((end_time - start_time)/60)
print,'Your figure took '+thismany+' minutes to produce.'

end