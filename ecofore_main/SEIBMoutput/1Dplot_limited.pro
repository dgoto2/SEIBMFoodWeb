; 1Dplot_limited.pro
; makes one-year line graphs of a single response for 1-4 species in 1D SE Lake Erie EcoFore model
; TM Sesterhenn, February 2012

start_time = systime(/seconds)

; which year?
year = '1996'

; is hypoxia effect 'ON' or 'OFF'?
HH = 'ON'

; is density-dependence 'ON' or 'OFF'?
DD = 'ON'

; input title for all figures
fig_title = year+': Hypoxia '+HH+', Density Dependence '+DD

; where are the files containing data?
drive = 'C:\'
dir   = 'Users\tsesterh\1D_hind_output\'+year+'_HH_'+HH+'_DD_'+DD+'\'

; how many taxa?
taxa = 1

response = 14  ; the response variable to be plotted
resp_2   = 'biomass'  ; 'biomass' or 'weight'
; population is collected every time for weighting purposes (the 0 index during data compilation)
; 1  = length, 2  = weight or biomass, 14 = depth

; taxa: 'YEP' = yellow perch, 'WAE' = walleye, 'EMS' = emerald shiner, 'RAS' = rainbow smelt
tax1 = 'WAE'
tax2 = 'YEP'
tax3 = 'RAS'
tax4 = 'EMS'

;--------------------------------------------------------------------------------------------------------
; from here down it should run just fine by itself with no changes needed (except maybe figure stuff)
;--------------------------------------------------------------------------------------------------------

;; set up filenames
;if taxa eq 1 then begin
;  outfile = year+'_'+tax1+'_'+'Hypox'+HH+'_'+make
;endif
;if taxa eq 2 then begin
;  outfile = year+'_'+tax1+'_'+tax2+'_'+'Hypox'+HH+'_'+make
;endif

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

axisdays   = indgen(nDays) + startday  ; makes array for x-axis on figures


;------------------------------------------------------------------BEGIN TAXON #1
morn_data1   = fltarr(nDays,5000)
morn_popn1   = fltarr(nDays,5000)
mid_data1    = fltarr(nDays,5000)
mid_popn1    = fltarr(nDays,5000)
aft_data1    = fltarr(nDays,5000)
aft_popn1    = fltarr(nDays,5000)
nght_data1   = fltarr(nDays,5000)
nght_popn1   = fltarr(nDays,5000)
allday_data1 = fltarr(nDays,20000)
allday_popn1 = fltarr(nDays,20000)

; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax1+')!'
    ; compile names of data files for this taxon, for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_5.csv'
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
        morn_popn1[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        morn_data1[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn1[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        morn_data1[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn1[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        morn_data1[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn1[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        morn_data1[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        morn_popn1[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        morn_data1[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax1+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_5.csv'
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
        mid_popn1[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        mid_data1[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn1[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        mid_data1[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn1[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        mid_data1[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn1[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        mid_data1[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        mid_popn1[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        mid_data1[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax1+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_5.csv'
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
        aft_popn1[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        aft_data1[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn1[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        aft_data1[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn1[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        aft_data1[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn1[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        aft_data1[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        aft_popn1[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        aft_data1[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax1+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_5.csv'
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
        nght_popn1[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        nght_data1[daycount,0.:4999.] = data1[ response, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn1[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        nght_data1[daycount,0.:4999.] = data2[ response, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn1[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        nght_data1[daycount,0.:4999.] = data3[ response, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn1[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        nght_data1[daycount,0.:4999.] = data4[ response, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        nght_popn1[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        nght_data1[daycount,0.:4999.] = data5[ response, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
endfor;---------------------------------------------------------------------------------------TIMING END

allday_data1 = [ [morn_data1],[mid_data1],[aft_data1],[nght_data1] ] ; puts all timings together
allday_popn1 = [ [morn_popn1],[mid_popn1],[aft_popn1],[nght_popn1] ]

; initialize arrays to hold plotting data
tot_morn_popn1   = fltarr(nDays)
tot_mid_popn1    = fltarr(nDays)
tot_aft_popn1    = fltarr(nDays)
tot_nght_popn1   = fltarr(nDays)
tot_allday_popn1 = fltarr(nDays)
W_resp_morn1     = fltarr(nDays,5000)
W_resp_mid1      = fltarr(nDays,5000)
W_resp_aft1      = fltarr(nDays,5000)
W_resp_nght1     = fltarr(nDays,5000)
W_resp_allday1   = fltarr(nDays,20000)
avg_resp_morn1   = fltarr(nDays)
avg_resp_mid1    = fltarr(nDays)
avg_resp_aft1    = fltarr(nDays)
avg_resp_nght1   = fltarr(nDays)
avg_resp_allday1 = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_morn_popn1[a]   = total(morn_popn1[a,*])    ; these get the total population size for their
  tot_mid_popn1[a]    = total(mid_popn1[a,*])     ; respective time periods
  tot_aft_popn1[a]    = total(aft_popn1[a,*])
  tot_nght_popn1[a]   = total(nght_popn1[a,*])
  tot_allday_popn1[a] = total(allday_popn1[a,*])
  
  if response eq 1 || response eq 2 then begin 
    for r = 0,4999 do begin  ; total up the response variable to calculate 'W'eighted averages
      W_resp_morn1[a,r]   = morn_data1[a,r]   * morn_popn1[a,r]
      W_resp_mid1[a,r]    = mid_data1[a,r]    * mid_popn1[a,r]
      W_resp_aft1[a,r]    = aft_data1[a,r]    * aft_popn1[a,r]
      W_resp_nght1[a,r]   = nght_data1[a,r]   * nght_popn1[a,r]
      W_resp_allday1[a,r] = allday_data1[a,r] * allday_popn1[a,r] 
    endfor
    for r = 5000,19999 do begin  ; continue all day compilation
      W_resp_allday1[a,r] = allday_data1[a,r] * allday_popn1[a,r]
    endfor
    avg_resp_morn1[a]   = ( total(W_resp_morn1[a,*]) )   / tot_morn_popn1[a]
    avg_resp_mid1[a]    = ( total(W_resp_mid1[a,*]) )    / tot_mid_popn1[a]
    avg_resp_aft1[a]    = ( total(W_resp_aft1[a,*]) )    / tot_aft_popn1[a]
    avg_resp_nght1[a]   = ( total(W_resp_nght1[a,*]) )   / tot_nght_popn1[a]
    avg_resp_allday1[a] = ( total(W_resp_allday1[a,*]) ) / tot_allday_popn1[a]
  endif
  
  if response eq 2 then begin
    biomass_morn1   = avg_resp_morn1   * tot_morn_popn1
    biomass_mid1    = avg_resp_mid1    * tot_mid_popn1
    biomass_aft1    = avg_resp_aft1    * tot_aft_popn1
    biomass_nght1   = avg_resp_nght1   * tot_nght_popn1
    biomass_allday1 = avg_resp_allday1 * tot_allday_popn1
  endif
  
  if response eq 14 then begin
    for r = 0,4999 do begin  ; total up depth response to calculate weighted average
      W_resp_morn1[a,r]   = (morn_data1[a,r]+1)   * morn_popn1[a,r]
      W_resp_mid1[a,r]    = (mid_data1[a,r]+1)    * mid_popn1[a,r]
      W_resp_aft1[a,r]    = (aft_data1[a,r]+1)    * aft_popn1[a,r]
      W_resp_nght1[a,r]   = (nght_data1[a,r]+1)   * nght_popn1[a,r]
      W_resp_allday1[a,r] = (allday_data1[a,r]+1) * allday_popn1[a,r]
    endfor
    for r = 5000,19999 do begin  ; continue all day compilation
      W_resp_allday1[a,r] = (allday_data1[a,r]+1) * allday_popn1[a,r]
    endfor
    avg_resp_morn1[a]   = ( ( total(W_resp_morn1[a,*]) )   / tot_morn_popn1[a] ) /2   ; /2 because
    avg_resp_mid1[a]    = ( ( total(W_resp_mid1[a,*]) )    / tot_mid_popn1[a] ) /2    ; 2 cells per
    avg_resp_aft1[a]    = ( ( total(W_resp_aft1[a,*]) )    / tot_aft_popn1[a] ) /2    ; meter
    avg_resp_nght1[a]   = ( ( total(W_resp_nght1[a,*]) )   / (tot_nght_popn1[a]) ) /2   ; (makes #cells
    avg_resp_allday1[a] = ( ( total(W_resp_allday1[a,*]) ) / tot_allday_popn1[a] ) /2 ; into meters)
  endif
  
endfor

;-------------------------------------------------------------------END TAXON #1


;------------------------------------------------------------------BEGIN TAXON #2
if taxa ge 2 then begin

; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax2+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_5.csv'
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
        total_popn2[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax2+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_5.csv'
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
        total_popn2[daycount,5000.:9999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax2+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_5.csv'
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
        total_popn2[daycount,10000.:14999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax2+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_5.csv'
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
        total_popn2[daycount,15000.:19999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
  end_midnight = SYSTIME(/seconds)
  
endfor;---------------------------------------------------------------------------------------TIMING END


tot_popn2    = fltarr(nDays)
wghted_leng2 = fltarr(nDays,20000)
wghted_wght2 = fltarr(nDays,20000)
wghted_dpth2 = fltarr(nDays,20000)
avg_leng2    = fltarr(nDays)
avg_wght2    = fltarr(nDays)
avg_dpth2    = fltarr(nDays)
biomass2     = fltarr(nDays)

for a = 0,nDays-1 do begin
  tot_popn2[a] = total(total_popn2[a,*])
  
  for r = 0,19999 do begin ; total up things for calculating weighted averages
    wghted_leng2[a,r] = total_leng2[a,r] * total_popn2[a,r]
    wghted_wght2[a,r] = total_wght2[a,r] * total_popn2[a,r]
    wghted_dpth2[a,r] = (total_dpth2[a,r]+1) * total_popn2[a,r] ; plus 1 because index starts at 0
  endfor
  
  avg_leng2[a] = ( total(wghted_leng2[a,*]) ) / tot_popn2[a]  ; weighted avg length
  avg_wght2[a] = ( total(wghted_wght2[a,*]) ) / tot_popn2[a]  ; weighted avg total weight
  avg_dpth2[a] = ( ( total(wghted_dpth2[a,*]) ) / tot_popn2[a] ) /2 ; weighted avg depth
                                       ; /2 because 2 cells per meter
  
endfor

biomass2 = avg_wght2 * tot_popn2

endif
;-------------------------------------------------------------------END TAXON #2

;------------------------------------------------------------------BEGIN TAXON #3
if taxa ge 3 then begin

; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax3+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_5.csv'
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
        total_popn3[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax3+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_5.csv'
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
        total_popn3[daycount,5000.:9999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax3+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_5.csv'
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
        total_popn3[daycount,10000.:14999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax3+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_5.csv'
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
        total_popn3[daycount,15000.:19999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
  end_midnight = SYSTIME(/seconds)
  
endfor;---------------------------------------------------------------------------------------TIMING END


tot_popn3    = fltarr(nDays)
wghted_leng3 = fltarr(nDays,20000)
wghted_wght3 = fltarr(nDays,20000)
wghted_dpth3 = fltarr(nDays,20000)
avg_leng3    = fltarr(nDays)
avg_wght3    = fltarr(nDays)
avg_dpth3    = fltarr(nDays)
biomass3     = fltarr(nDays)

for a = 0,nDays-1 do begin
  tot_popn3[a] = total(total_popn3[a,*])
  
  for r = 0,19999 do begin ; total up things for calculating weighted averages
    wghted_leng3[a,r] = total_leng3[a,r] * total_popn3[a,r]
    wghted_wght3[a,r] = total_wght3[a,r] * total_popn3[a,r]
    wghted_dpth3[a,r] = (total_dpth3[a,r]+1) * total_popn3[a,r] ; plus 1 because index starts at 0
  endfor
  
  avg_leng3[a] = ( total(wghted_leng3[a,*]) ) / tot_popn3[a]  ; weighted avg length
  avg_wght3[a] = ( total(wghted_wght3[a,*]) ) / tot_popn3[a]  ; weighted avg total weight
  avg_dpth3[a] = ( ( total(wghted_dpth3[a,*]) ) / tot_popn3[a] ) /2 ; weighted avg depth
                                       ; /2 because 2 cells per meter
  
endfor

biomass3 = avg_wght3 * tot_popn3

endif
;-------------------------------------------------------------------END TAXON #3


;------------------------------------------------------------------BEGIN TAXON #4
if taxa ge 4 then begin

; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time+' ('+tax4+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_5.csv'
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
        total_popn4[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time+' ('+tax4+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_5.csv'
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
        total_popn4[daycount,5000.:9999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time+' ('+tax4+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_5.csv'
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
        total_popn4[daycount,10000.:14999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time+' ('+tax4+')!'
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_5.csv'
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
        total_popn4[daycount,15000.:19999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
  end_midnight = SYSTIME(/seconds)
  
endfor;---------------------------------------------------------------------------------------TIMING END


tot_popn4    = fltarr(nDays)
wghted_leng4 = fltarr(nDays,20000)
wghted_wght4 = fltarr(nDays,20000)
wghted_dpth4 = fltarr(nDays,20000)
avg_leng4    = fltarr(nDays)
avg_wght4    = fltarr(nDays)
avg_dpth4    = fltarr(nDays)
biomass4     = fltarr(nDays)

for a = 0,nDays-1 do begin
  tot_popn4[a] = total(total_popn4[a,*])
  
  for r = 0,19999 do begin ; total up things for calculating weighted averages
    wghted_leng4[a,r] = total_leng4[a,r] * total_popn4[a,r]
    wghted_wght4[a,r] = total_wght4[a,r] * total_popn4[a,r]
    wghted_dpth4[a,r] = (total_dpth4[a,r]+1) * total_popn4[a,r] ; plus 1 because index starts at 0
  endfor
  
  avg_leng4[a] = ( total(wghted_leng4[a,*]) ) / tot_popn4[a]  ; weighted avg length
  avg_wght4[a] = ( total(wghted_wght4[a,*]) ) / tot_popn4[a]  ; weighted avg total weight
  avg_dpth4[a] = ( ( total(wghted_dpth4[a,*]) ) / tot_popn4[a] ) /2 ; weighted avg depth
                                       ; /2 because 2 cells per meter
  
endfor

biomass4 = avg_wght4 * tot_popn4

endif
;-------------------------------------------------------------------END TAXON #4



;---------------------------------------------------------------------------------------------------
; end data organization, begin plotting
; comment out any taxa that are not wanted on each figure

; WAE=dark khaki, YEP=goldenrod, RAS=hot pink, EMS=lime green
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit

; total population size
t1p = plot(axisdays, tot_morn_popn1/1000000, 'medium orchid', thick=3, name=tax1, xtitle='Time', $
      ytitle='Population Size (millions of fish)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[10,10000], /ylog)
t2p = plot(axisdays, tot_mid_popn1/1000000, 'orange red', thick=3, name=tax2, /overplot)
t3p = plot(axisdays, tot_aft_popn1/1000000, 'gold', thick=3, name=tax3, /overplot)
t4p = plot(axisdays, tot_nght_popn1/1000000, 'midnight blue', thick=3, name=tax4, /overplot)
t5p = plot(axisdays, tot_allday_popn1/1000000, 'forest green', thick=3, name=tax4, /overplot)
Lp  = legend(target=[t1p,t2p,t3p,t4p,t5p], position=[0.72,0.85], shadow=0)

if response eq 1 then begin
; length
t1L = plot(axisdays, avg_leng1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Average Fish Length', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[0,300])
t2L = plot(axisdays, avg_leng2, 'goldenrod', thick=3, name=tax2, /overplot)
t3L = plot(axisdays, avg_leng3, 'hot pink', thick=3, name=tax3, /overplot)
t4L = plot(axisdays, avg_leng4, 'lime green', thick=3, name=tax4, /overplot)
LL  = legend(target=[t1L,t2L,t3L,t4L], position=[0.18,0.87], shadow=0)
endif

if response eq 2 then begin
if resp_2 eq 'weight' then begin
; weight
t1w = plot(axisdays, avg_wght1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Average Fish Weight', xrange=[startday,(startday+nDays-1)], title=fig_title+'!CWeight', $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[0.1,1000], /ylog)
t2w = plot(axisdays, avg_wght2, 'goldenrod', thick=3, name=tax2, /overplot)
t3w = plot(axisdays, avg_wght3, 'hot pink', thick=3, name=tax3, /overplot)
t4w = plot(axisdays, avg_wght4, 'lime green', thick=3, name=tax4, /overplot)
Lw  = legend(target=[t1w,t2w,t3w,t4w], position=[0.72,0.29], shadow=0)
endif
if resp_2 eq 'biomass' then begin
; biomass
t1b = plot(axisdays, biomass_morn1, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Biomass', xrange=[startday,(startday+nDays-1)], title=fig_title+'!CBiomass', $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], /ylog);, yrange=[100000000,100000000000])
t2b = plot(axisdays, biomass_mid1, 'orange red', thick=3, name='Midday', /overplot)
t3b = plot(axisdays, biomass_aft1, 'gold', thick=3, name='Afternoon', /overplot)
t4b = plot(axisdays, biomass_nght1, 'midnight blue', thick=3, name='Night', /overplot)
t5b = plot(axisdays, biomass_allday1, 'forest green', thick=3, name='Entire Day', /overplot)
Lb  = legend(target=[t1b,t2b,t3b,t4b,t5b], position=[0.18,0.87], shadow=0)
endif
endif

if response eq 14 then begin
; depth
t1d = plot(axisdays, avg_resp_morn1, 'medium orchid', thick=3, name='Morning', xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=5, /data, xtickv=[152,182,212,242,272], xtickname=['Jun','Jul','Aug','Sep','Oct'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
t2d = plot(axisdays, avg_resp_mid1, 'orange red', thick=3, name='Midday', /overplot)
t3d = plot(axisdays, avg_resp_aft1, 'gold', thick=3, name='Afternoon', /overplot)
t4d = plot(axisdays, avg_resp_nght1, 'midnight blue', thick=3, name='Night', /overplot)
t5d = plot(axisdays, avg_resp_allday1, 'forest green', thick=3, name='Entire Day', /overplot)
Ld  = legend(target=[t1d,t2d,t3d,t4d,t5d], position=[0.18,0.88], shadow=0)
endif


end_time = systime(/seconds)
thismany = string((end_time - start_time)/60)
print,'Your figure took '+thismany+' minutes to produce.'

end