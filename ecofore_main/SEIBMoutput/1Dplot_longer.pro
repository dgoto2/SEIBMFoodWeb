; 1Dplot_longer.pro
; makes one-year line graphs of responses in 1D SE Lake Erie EcoFore model
; TM Sesterhenn, March 2012

start_time = systime(/seconds)

; which year?
year = '1996'

; is hypoxia effect 'ON' or 'OFF'?
HH = 'ON'

; is density-dependence 'ON' or 'OFF'?
DD = 'ON'

; input title for all figures
fig_title = year+' (more fish): Hypoxia '+HH+', Density Dependence '+DD

; where are the files containing data?
;drive = 'C:\'
drive = 'E:\'
;dir   = 'Users\tsesterh\1D_hind_output\'+year+'_HH_'+HH+'_DD_'+DD+'_longer\'
dir   = 'Purdue\1Doutput_3-1\1996_HH_on_DD_on_DOmodTIMEmod\'

;; how many taxa?
;taxa = 4.

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
  nDays    = 164.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif
if year eq '2005' then begin
  nDays    = 137.  ; how many days the model ran
  startday = 152.  ; what day the model started on
endif

axisdays   = indgen(nDays) + startday  ; makes array for x-axis on figures
total_popn1 = fltarr(nDays,20000)      ; initializing of matrices to hold figure data
total_leng1 = fltarr(nDays,20000)      ; For each day, each superindividual (n=5000)...
total_wght1 = fltarr(nDays,20000)      ; ...at each time period (n=4)...
total_dpth1 = fltarr(nDays,20000)      ; ...is added to the matrix.
total_popn2 = fltarr(nDays,20000)      
total_leng2 = fltarr(nDays,20000)
total_wght2 = fltarr(nDays,20000)
total_dpth2 = fltarr(nDays,20000)
total_popn3 = fltarr(nDays,20000)
total_leng3 = fltarr(nDays,20000)
total_wght3 = fltarr(nDays,20000)
total_dpth3 = fltarr(nDays,20000)
total_popn4 = fltarr(nDays,20000)
total_leng4 = fltarr(nDays,20000)
total_wght4 = fltarr(nDays,20000)
total_dpth4 = fltarr(nDays,20000)


;------------------------------------------------------------------BEGIN TAXON #1

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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_6.csv'
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
        total_popn1[daycount,0.:4999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,0.:4999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,0.:4999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,0.:4999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,0.:4999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng1[daycount,0.:4999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght1[daycount,0.:4999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth1[daycount,0.:4999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_6.csv'
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
        total_popn1[daycount,5000.:9999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,5000.:9999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,5000.:9999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,5000.:9999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,5000.:9999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng1[daycount,5000.:9999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght1[daycount,5000.:9999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth1[daycount,5000.:9999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_6.csv'
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
        total_popn1[daycount,10000.:14999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,10000.:14999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,10000.:14999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,10000.:14999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,10000.:14999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng1[daycount,10000.:14999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght1[daycount,10000.:14999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth1[daycount,10000.:14999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax1+'_6.csv'
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
        total_popn1[daycount,15000.:19999.] = data1[ 0, daycount*5000:daycount*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data1[ 1, daycount*5000:daycount*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data1[ 2, daycount*5000:daycount*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data1[ 14, daycount*5000:daycount*5000+4999. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,15000.:19999.] = data2[ 0, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data2[ 1, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data2[ 2, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data2[ 14, (daycount-30.)*5000:(daycount-30.)*5000+4999. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,15000.:19999.] = data3[ 0, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data3[ 1, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data3[ 2, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data3[ 14, (daycount-60.)*5000:(daycount-60.)*5000+4999. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,15000.:19999.] = data4[ 0, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data4[ 1, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data4[ 2, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data4[ 14, (daycount-90.)*5000:(daycount-90.)*5000+4999. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn1[daycount,15000.:19999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng1[daycount,15000.:19999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght1[daycount,15000.:19999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth1[daycount,15000.:19999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END
  
  end_midnight = SYSTIME(/seconds)
  
endfor;---------------------------------------------------------------------------------------TIMING END

; initialize arrays to hold plotting data
tot_popn1    = fltarr(nDays)
wghted_leng1 = fltarr(nDays,20000)
wghted_wght1 = fltarr(nDays,20000)
wghted_dpth1 = fltarr(nDays,20000)
avg_leng1    = fltarr(nDays)
avg_wght1    = fltarr(nDays)
avg_dpth1    = fltarr(nDays)
biomass1     = fltarr(nDays)

; put data into arrays for plotting
for a = 0,nDays-1 do begin
  tot_popn1[a] = total(total_popn1[a,*])
  
  for r = 0,19999 do begin ; total up things for calculating weighted averages
    wghted_leng1[a,r] = total_leng1[a,r] * total_popn1[a,r]
    wghted_wght1[a,r] = total_wght1[a,r] * total_popn1[a,r]
    wghted_dpth1[a,r] = (total_dpth1[a,r]+1) * total_popn1[a,r] ; plus 1 because index starts at 0
  endfor
  
  avg_leng1[a] = ( total(wghted_leng1[a,*]) ) / tot_popn1[a]  ; weighted avg length
  avg_wght1[a] = ( total(wghted_wght1[a,*]) ) / tot_popn1[a]  ; weighted avg total weight
  avg_dpth1[a] = ( ( total(wghted_dpth1[a,*]) ) / tot_popn1[a] ) /2 ; weighted avg depth
                                       ; /2 because 2 cells per meter
  
endfor

biomass1 = avg_wght1 * tot_popn1

;-------------------------------------------------------------------END TAXON #1


;------------------------------------------------------------------BEGIN TAXON #2

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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,0.:4999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng2[daycount,0.:4999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght2[daycount,0.:4999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth2[daycount,0.:4999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,5000.:9999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng2[daycount,5000.:9999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght2[daycount,5000.:9999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth2[daycount,5000.:9999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,10000.:14999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng2[daycount,10000.:14999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght2[daycount,10000.:14999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth2[daycount,10000.:14999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax2+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn2[daycount,15000.:19999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng2[daycount,15000.:19999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght2[daycount,15000.:19999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth2[daycount,15000.:19999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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

;-------------------------------------------------------------------END TAXON #2

;------------------------------------------------------------------BEGIN TAXON #3

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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,0.:4999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng3[daycount,0.:4999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght3[daycount,0.:4999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth3[daycount,0.:4999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,5000.:9999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng3[daycount,5000.:9999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght3[daycount,5000.:9999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth3[daycount,5000.:9999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,10000.:14999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng3[daycount,10000.:14999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght3[daycount,10000.:14999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth3[daycount,10000.:14999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax3+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn3[daycount,15000.:19999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng3[daycount,15000.:19999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght3[daycount,15000.:19999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth3[daycount,15000.:19999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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

;-------------------------------------------------------------------END TAXON #3


;------------------------------------------------------------------BEGIN TAXON #4

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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,0.:4999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng4[daycount,0.:4999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght4[daycount,0.:4999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth4[daycount,0.:4999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,5000.:9999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng4[daycount,5000.:9999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght4[daycount,5000.:9999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth4[daycount,5000.:9999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,10000.:14999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng4[daycount,10000.:14999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght4[daycount,10000.:14999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth4[daycount,10000.:14999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutput'+tax4+'_6.csv'
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
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data5[ 0, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data5[ 1, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data5[ 2, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data5[ 14, (daycount-120.)*5000:(daycount-120.)*5000+4999. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        total_popn4[daycount,15000.:19999.] = data6[ 0, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_leng4[daycount,15000.:19999.] = data6[ 1, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_wght4[daycount,15000.:19999.] = data6[ 2, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
        total_dpth4[daycount,15000.:19999.] = data6[ 14, (daycount-150.)*5000:(daycount-150.)*5000+4999. ]
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

;-------------------------------------------------------------------END TAXON #4



;---------------------------------------------------------------------------------------------------
; end data organization, begin plotting
; comment out any taxa that are not wanted on each figure

; WAE=dark khaki, YEP=goldenrod, RAS=hot pink, EMS=lime green
; if figures don't look right: fix things, save, highlight plot text, press shift+F8 to run just that bit

; total population size
t1p = plot(axisdays, tot_popn1/1000000., 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Population Size (millions of fish)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[5,10000], /ylog)
t2p = plot(axisdays, tot_popn2/1000000., 'goldenrod', thick=3, name=tax2, /overplot)
t3p = plot(axisdays, tot_popn3/1000000., 'hot pink', thick=3, name=tax3, /overplot)
t4p = plot(axisdays, tot_popn4/1000000., 'lime green', thick=3, name=tax4, /overplot)
Lp  = legend(target=[t1p,t2p,t3p,t4p], position=[0.72,0.85], shadow=0)

; length
t1L = plot(axisdays, avg_leng1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Average Fish Length', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[0,300])
t2L = plot(axisdays, avg_leng2, 'goldenrod', thick=3, name=tax2, /overplot)
t3L = plot(axisdays, avg_leng3, 'hot pink', thick=3, name=tax3, /overplot)
t4L = plot(axisdays, avg_leng4, 'lime green', thick=3, name=tax4, /overplot)
LL  = legend(target=[t1L,t2L,t3L,t4L], position=[0.18,0.87], shadow=0)

; weight
;t1w = plot(axisdays, avg_wght1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
;      ytitle='Average Fish Weight', xrange=[startday,(startday+nDays-1)], title=fig_title, $
;      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct'.'Nov'], $
;      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], /ylog, yrange=[0.1,1000])
;t2w = plot(axisdays, avg_wght2, 'goldenrod', thick=3, name=tax2, /overplot)
;t3w = plot(axisdays, avg_wght3, 'hot pink', thick=3, name=tax3, /overplot)
;t4w = plot(axisdays, avg_wght4, 'lime green', thick=3, name=tax4, /overplot)
;Lw  = legend(target=[t1w,t2w,t3w,t4w], position=[0.72,0.29], shadow=0)

; biomass
t1b = plot(axisdays, biomass1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Biomass', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], /ylog, yrange=[100000000,100000000000])
t2b = plot(axisdays, biomass2, 'goldenrod', thick=3, name=tax2, /overplot)
t3b = plot(axisdays, biomass3, 'hot pink', thick=3, name=tax3, /overplot)
t4b = plot(axisdays, biomass4, 'lime green', thick=3, name=tax4, /overplot)
Lb  = legend(target=[t1b,t2b,t3b,t4b], position=[0.18,0.87], shadow=0)

; depth
t1d = plot(axisdays, avg_dpth1, 'dark khaki', thick=3, name=tax1, xtitle='Time', $
      ytitle='Depth (m)', xrange=[startday,(startday+nDays-1)], title=fig_title, $
      xticks=6, /data, xtickv=[152,182,212,242,272,302], xtickname=['Jun','Jul','Aug','Sep','Oct','Nov'], $
      xminor=0, xticklen=0, margin=[0.15,0.1,0.1,0.1], yrange=[24,0])
t2d = plot(axisdays, avg_dpth2, 'goldenrod', thick=3, name=tax2, /overplot)
t3d = plot(axisdays, avg_dpth3, 'hot pink', thick=3, name=tax3, /overplot)
t4d = plot(axisdays, avg_dpth4, 'lime green', thick=3, name=tax4, /overplot)
Ld  = legend(target=[t1d,t2d,t3d,t4d], position=[0.18,0.88], shadow=0)


end_time = systime(/seconds)
thismany = string((end_time - start_time)/60)
print,'Your figure(s) took '+thismany+' minutes to produce.'

end