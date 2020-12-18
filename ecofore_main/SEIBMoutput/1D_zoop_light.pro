; 1D_zoop_light.pro
; density plots of zooplankton and light for EcoFore 1D model
; TM Sesterhnn, February 2012

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

; taxa: 'YEP' = yellow perch, 'WAE' = walleye, 'EMS' = emerald shiner, 'RAS' = rainbow smelt
;thing1 = 'WAE'
;thing2 = 'YEP'
;thing3 = 'RAS'
;thing4 = 'EMS'

;--------------------------------------------------------------------------------------------------------
; from here down it should run just fine by itself with no changes needed (except maybe figure stuff)
;--------------------------------------------------------------------------------------------------------

;nDays    = 137.  ; how many days the model ran (for mid-October runs)
nDays    = 164.  ; for mid-November runs
startday = 152.  ; what day the model started on
axisdays = indgen(nDays) + startday  ; makes array for x-axis on figures

; initialize plot arrays
SmZoop_Mo = fltarr(nDays,48)  ; morning (Mo), small (Sm) zooplankton
SmZoop_Md = fltarr(nDays,48)  ; midday (Md)
SmZoop_Af = fltarr(nDays,48)  ; afternoon (Af)
SmZoop_Ni = fltarr(nDays,48)  ; night (Ni)
MdZoop_Mo = fltarr(nDays,48)  ; medium (Md) zooplankton
MdZoop_Md = fltarr(nDays,48)
MdZoop_Af = fltarr(nDays,48)
MdZoop_Ni = fltarr(nDays,48)
LgZoop_Mo = fltarr(nDays,48)  ; large (Lg) zooplankton
LgZoop_Md = fltarr(nDays,48)
LgZoop_Af = fltarr(nDays,48)
LgZoop_Ni = fltarr(nDays,48)
Lght_Mo   = fltarr(nDays,48)  ; light level
Lght_Md   = fltarr(nDays,48)
Lght_Af   = fltarr(nDays,48)
Lght_Ni   = fltarr(nDays,48)


; access data files
daycount = 0.

for timing = 0,3 do begin;-------------------------------------------------------------------TIMING BEGIN
  
  if timing eq 0 then begin;----------------------------------------------------MORNING BEGIN
    time = 'Morning'
    print,time
    ; compile names of data files for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(16,1440)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(16,1440)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(16,1440)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(16,1440)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
;    openr, lun, file5, /get_lun
;    data5 = fltarr(16,816)
;    readf, lun, data5
;    free_lun, lun
;    print,'file 5 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(16,1440)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(16,672)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data1[ 5, daycount*48:daycount*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data1[ 6, daycount*48:daycount*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data1[ 7, daycount*48:daycount*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data1[ 11, daycount*48:daycount*48+47. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data2[ 5, (daycount-30.)*48:(daycount-30.)*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data2[ 6, (daycount-30.)*48:(daycount-30.)*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data2[ 7, (daycount-30.)*48:(daycount-30.)*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data2[ 11, (daycount-30.)*48:(daycount-30.)*48+47. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data3[ 5, (daycount-60.)*48:(daycount-60.)*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data3[ 6, (daycount-60.)*48:(daycount-60.)*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data3[ 7, (daycount-60.)*48:(daycount-60.)*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data3[ 11, (daycount-60.)*48:(daycount-60.)*48+47. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data4[ 5, (daycount-90.)*48:(daycount-90.)*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data4[ 6, (daycount-90.)*48:(daycount-90.)*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data4[ 7, (daycount-90.)*48:(daycount-90.)*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data4[ 11, (daycount-90.)*48:(daycount-90.)*48+47. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data5[ 5, (daycount-120.)*48:(daycount-120.)*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data5[ 6, (daycount-120.)*48:(daycount-120.)*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data5[ 7, (daycount-120.)*48:(daycount-120.)*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data5[ 11, (daycount-120.)*48:(daycount-120.)*48+47. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Mo[daycount,0.:47.]  = data6[ 5, (daycount-150.)*48:(daycount-150.)*48+47. ]
        MdZoop_Mo[daycount,0.:47.]  = data6[ 6, (daycount-150.)*48:(daycount-150.)*48+47. ]
        LgZoop_Mo[daycount,0.:47.]  = data6[ 7, (daycount-150.)*48:(daycount-150.)*48+47. ]
        Lght_Mo[  daycount,0.:47.] = data6[ 11, (daycount-150.)*48:(daycount-150.)*48+47. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------------MORNING END
  
  
  if timing eq 1 then begin;-----------------------------------------------------------MIDDAY BEGIN
    time = 'Midday'
    print,time
    ; compile names of data files for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(16,1440)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(16,1440)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(16,1440)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(16,1440)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
;    openr, lun, file5, /get_lun
;    data5 = fltarr(16,816)
;    readf, lun, data5
;    free_lun, lun
;    print,'file 5 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(16,1440)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(16,672)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data1[ 5, daycount*48:daycount*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data1[ 6, daycount*48:daycount*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data1[ 7, daycount*48:daycount*48+47. ]
        Lght_Md[  daycount,0.:47.] = data1[ 11, daycount*48:daycount*48+47. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data2[ 5, (daycount-30.)*48:(daycount-30.)*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data2[ 6, (daycount-30.)*48:(daycount-30.)*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data2[ 7, (daycount-30.)*48:(daycount-30.)*48+47. ]
        Lght_Md[  daycount,0.:47.] = data2[ 11, (daycount-30.)*48:(daycount-30.)*48+47. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data3[ 5, (daycount-60.)*48:(daycount-60.)*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data3[ 6, (daycount-60.)*48:(daycount-60.)*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data3[ 7, (daycount-60.)*48:(daycount-60.)*48+47. ]
        Lght_Md[  daycount,0.:47.] = data3[ 11, (daycount-60.)*48:(daycount-60.)*48+47. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data4[ 5, (daycount-90.)*48:(daycount-90.)*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data4[ 6, (daycount-90.)*48:(daycount-90.)*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data4[ 7, (daycount-90.)*48:(daycount-90.)*48+47. ]
        Lght_Md[  daycount,0.:47.] = data4[ 11, (daycount-90.)*48:(daycount-90.)*48+47. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data5[ 5, (daycount-120.)*48:(daycount-120.)*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data5[ 6, (daycount-120.)*48:(daycount-120.)*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data5[ 7, (daycount-120.)*48:(daycount-120.)*48+47. ]
        Lght_Md[  daycount,0.:47.] = data5[ 11, (daycount-120.)*48:(daycount-120.)*48+47. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Md[daycount,0.:47.]  = data6[ 5, (daycount-150.)*48:(daycount-150.)*48+47. ]
        MdZoop_Md[daycount,0.:47.]  = data6[ 6, (daycount-150.)*48:(daycount-150.)*48+47. ]
        LgZoop_Md[daycount,0.:47.]  = data6[ 7, (daycount-150.)*48:(daycount-150.)*48+47. ]
        Lght_Md[  daycount,0.:47.] = data6[ 11, (daycount-150.)*48:(daycount-150.)*48+47. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;-------------------------------------------------------------------------------MIDDAY END
  
  
  if timing eq 2 then begin;----------------------------------------------------AFTERNOON BEGIN
    time = 'Afternoon'
    print,time
    ; compile names of data files for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(16,1440)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(16,1440)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(16,1440)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(16,1440)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
;    openr, lun, file5, /get_lun
;    data5 = fltarr(16,816)
;    readf, lun, data5
;    free_lun, lun
;    print,'file 5 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(16,1440)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(16,672)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data1[ 5, daycount*48:daycount*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data1[ 6, daycount*48:daycount*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data1[ 7, daycount*48:daycount*48+47. ]
        Lght_Af[  daycount,0.:47.] = data1[ 11, daycount*48:daycount*48+47. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data2[ 5, (daycount-30.)*48:(daycount-30.)*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data2[ 6, (daycount-30.)*48:(daycount-30.)*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data2[ 7, (daycount-30.)*48:(daycount-30.)*48+47. ]
        Lght_Af[  daycount,0.:47.] = data2[ 11, (daycount-30.)*48:(daycount-30.)*48+47. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data3[ 5, (daycount-60.)*48:(daycount-60.)*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data3[ 6, (daycount-60.)*48:(daycount-60.)*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data3[ 7, (daycount-60.)*48:(daycount-60.)*48+47. ]
        Lght_Af[  daycount,0.:47.] = data3[ 11, (daycount-60.)*48:(daycount-60.)*48+47. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data4[ 5, (daycount-90.)*48:(daycount-90.)*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data4[ 6, (daycount-90.)*48:(daycount-90.)*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data4[ 7, (daycount-90.)*48:(daycount-90.)*48+47. ]
        Lght_Af[  daycount,0.:47.] = data4[ 11, (daycount-90.)*48:(daycount-90.)*48+47. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data5[ 5, (daycount-120.)*48:(daycount-120.)*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data5[ 6, (daycount-120.)*48:(daycount-120.)*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data5[ 7, (daycount-120.)*48:(daycount-120.)*48+47. ]
        Lght_Af[  daycount,0.:47.] = data5[ 11, (daycount-120.)*48:(daycount-120.)*48+47. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Af[daycount,0.:47.]  = data6[ 5, (daycount-150.)*48:(daycount-150.)*48+47. ]
        MdZoop_Af[daycount,0.:47.]  = data6[ 6, (daycount-150.)*48:(daycount-150.)*48+47. ]
        LgZoop_Af[daycount,0.:47.]  = data6[ 7, (daycount-150.)*48:(daycount-150.)*48+47. ]
        Lght_Af[  daycount,0.:47.] = data6[ 11, (daycount-150.)*48:(daycount-150.)*48+47. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;----------------------------------------------------------------------------------AFTERNOON END
  
  
  if timing eq 3 then begin;----------------------------------------------------MIDNIGHT BEGIN
    time = 'Midnight'
    print,time
    ; compile names of data files for this time period
    file1 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_1.csv'
    file2 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_2.csv'
    file3 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_3.csv'
    file4 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_4.csv'
    file5 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_5.csv'
    file6 = drive+dir+'HH_'+HH+'_DD_'+DD+'_'+time+'__Rep_'+year+'_1D_ONE_IDLoutputENV_6.csv'
    ; move all data from files into IDL matrices
    openr, lun, file1, /get_lun
    data1 = fltarr(16,1440)
    readf, lun, data1
    free_lun, lun
    print,'file 1 of 6 complete'
    openr, lun, file2, /get_lun
    data2 = fltarr(16,1440)
    readf, lun, data2
    free_lun, lun
    print,'file 2 of 6 complete'
    openr, lun, file3, /get_lun
    data3 = fltarr(16,1440)
    readf, lun, data3
    free_lun, lun
    print,'file 3 of 6 complete'
    openr, lun, file4, /get_lun
    data4 = fltarr(16,1440)
    readf, lun, data4
    free_lun, lun
    print,'file 4 of 6 complete'
;    openr, lun, file5, /get_lun
;    data5 = fltarr(16,816)
;    readf, lun, data5
;    free_lun, lun
;    print,'file 5 of 5 complete'
    openr, lun, file5, /get_lun
    data5 = fltarr(16,1440)
    readf, lun, data5
    free_lun, lun
    print,'file 5 of 6 complete'
    openr, lun, file6, /get_lun
    data6 = fltarr(16,672)
    readf, lun, data6
    free_lun, lun
    print,'file 6 of 6 complete'
    for daycount = 0.,nDays-1. do begin;---------------DAYS BEGIN
      if daycount lt 30 then begin  ;because data files are in chunks of 30 days (until file 5)
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data1[ 5, daycount*48:daycount*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data1[ 6, daycount*48:daycount*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data1[ 7, daycount*48:daycount*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data1[ 11, daycount*48:daycount*48+47. ]
      endif
      if daycount ge 30 && daycount lt 60 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data2[ 5, (daycount-30.)*48:(daycount-30.)*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data2[ 6, (daycount-30.)*48:(daycount-30.)*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data2[ 7, (daycount-30.)*48:(daycount-30.)*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data2[ 11, (daycount-30.)*48:(daycount-30.)*48+47. ]
      endif
      if daycount ge 60 && daycount lt 90 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data3[ 5, (daycount-60.)*48:(daycount-60.)*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data3[ 6, (daycount-60.)*48:(daycount-60.)*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data3[ 7, (daycount-60.)*48:(daycount-60.)*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data3[ 11, (daycount-60.)*48:(daycount-60.)*48+47. ]
      endif
      if daycount ge 90 && daycount lt 120 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data4[ 5, (daycount-90.)*48:(daycount-90.)*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data4[ 6, (daycount-90.)*48:(daycount-90.)*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data4[ 7, (daycount-90.)*48:(daycount-90.)*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data4[ 11, (daycount-90.)*48:(daycount-90.)*48+47. ]
      endif
      if daycount ge 120 && daycount lt 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data5[ 5, (daycount-120.)*48:(daycount-120.)*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data5[ 6, (daycount-120.)*48:(daycount-120.)*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data5[ 7, (daycount-120.)*48:(daycount-120.)*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data5[ 11, (daycount-120.)*48:(daycount-120.)*48+47. ]
      endif
      if daycount ge 150 then begin
        ; cycle through and pick out the data that is wanted, put it in a smaller file for plotting
        SmZoop_Ni[daycount,0.:47.]  = data6[ 5, (daycount-150.)*48:(daycount-150.)*48+47. ]
        MdZoop_Ni[daycount,0.:47.]  = data6[ 6, (daycount-150.)*48:(daycount-150.)*48+47. ]
        LgZoop_Ni[daycount,0.:47.]  = data6[ 7, (daycount-150.)*48:(daycount-150.)*48+47. ]
        Lght_Ni[  daycount,0.:47.] = data6[ 11, (daycount-150.)*48:(daycount-150.)*48+47. ]
      endif
    endfor;---------------------------------------------DAYS END
  endif;--------------------------------------------------------------------------MIDNIGHT END

  
endfor;---------------------------------------------------------------------------------------TIMING END


; any other combinations that may need to be graphed
SmZoop_allday = (SmZoop_Mo + SmZoop_Md + SmZoop_Af + SmZoop_Ni) /4.
MdZoop_allday = (MdZoop_Mo + MdZoop_Md + MdZoop_Af + MdZoop_Ni) /4.
LgZoop_allday = (LgZoop_Mo + LgZoop_Md + LgZoop_Af + LgZoop_Ni) /4.

AllZoop_Mo = SmZoop_Mo + MdZoop_Mo + LgZoop_Mo
AllZoop_Md = SmZoop_Md + MdZoop_Md + LgZoop_Md
AllZoop_Af = SmZoop_Af + MdZoop_Af + LgZoop_Af
AllZoop_Ni = SmZoop_Ni + MdZoop_Ni + LgZoop_Ni
AllZoop_allday = SmZoop_allday + MdZoop_allday + LgZoop_allday

; plot stuff
depthY = findgen(48)
device, decomposed = 0  ; use 24-bit color

; zooplankton
xscale = findgen(50)
zooplevels = xscale^10
zooplevels = (zooplevels/max(zooplevels))*max(AllZoop_af)

window,0,xsize=700,ysize=500
loadct,8  ; greenscale color table
contour, AllZoop_af, axisdays, depthY, levels = zooplevels, yrange = [47,0], /fill, $
         title = fig_title+', All Zoop, Afternoon', background = [255], xstyle = 1, ystyle = 1, $
         ytickv = [40,30,20,10,0], ytickname = ['20','15','10','5','0'], ytitle = 'Depth (m)', $
         xtickv = [152,182,212,242,272,302], xtickname = ['Jun','Jul','Aug','Sep','Oct','Nov'], $
         color = 0, xminor = 1, xticks = 5, xmargin = [10,15], ymargin = [4,4], yminor = 5
colorbar,bottom=0,color=0,divisions=4,ncolors=255,minor=1,position=[0.87,0.08,0.92,0.92],$
         ticknames=['0','0.0001','0.0006','0.0014','0.0025'],/right,/vertical

; light levels
lghtlevels = xscale^20.
lghtlevels = (lghtlevels/max(lghtlevels))*max(Lght_Md)

window,1,xsize=700,ysize=500
loadct, 1  ; bluescale color table
contour, Lght_Md, axisdays, depthY, levels = lghtlevels, yrange = [47,0], /fill, $
         title = fig_title+', Light', background = [255], xstyle = 1, ystyle = 1, $
         ytickv = [40,30,20,10,0], ytickname = ['20','15','10','5','0'], ytitle = 'Depth (m)', $
         xtickv = [152,182,212,242,272,302], xtickname = ['Jun','Jul','Aug','Sep','Oct','Nov'], $
         color = 0, xminor = 1, xticks = 5, xmargin = [10,15], ymargin = [4,4], yminor = 5
colorbar,bottom=0,color=0,divisions=4,ncolors=255,minor=1,position=[0.87,0.08,0.92,0.92],$
         ticknames=['0','2.5e-8','0.1','1000','700K'],/right,/vertical
         
; this is how you save things: write_png,'filename.png',tvrd(/true)
; it saves the highest-numbered open graphics window
; saves to same directory where workspace is located

end