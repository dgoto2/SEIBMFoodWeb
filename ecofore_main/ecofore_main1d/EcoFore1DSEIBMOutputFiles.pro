FUNCTION EcoFore1DSEIBMOutputFiles, counter, nYP, nEMS, nRAS, nROG, nWAE, nVerLay, YP, EMS, RAS, ROG, WAE, Hypoxia, DensityDependence, Time, Rep, Envir1D3

PRINT, 'OutputFiles BEGINS HERE'
tstart = SYSTIME(/seconds)
 
 
;***Creat an output file for YEP*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter
PRINT, nYP; rowS


pointer1 = nYP * counter; 1st line to read in 
pointer2 = nYP * (counter - 30L)
pointer3 = nYP * (counter - 60L)
pointer4 = nYP * (counter - 90L)
pointer5 = nYP * (counter - 120L)
pointer6 = nYP * (counter - 150L)
pointer7 = nYP * (counter - 180L)
pointer8 = nYP * (counter - 210L)
;iDay = STRING(iDay)
;iHour = STRING(iHour)

data = YP

; Set up variables.
;OutputYEP1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputYEP.csv'
OutputYEP1='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_1.csv'
filename1 = OutputYEP1
OutputYEP2='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_2.csv'
filename2 = OutputYEP2
OutputYEP3='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_3.csv'
filename3 = OutputYEP3
OutputYEP4='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_4.csv'
filename4 = OutputYEP4
OutputYEP5='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_5.csv'
filename5 = OutputYEP5
OutputYEP6='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_6.csv'
filename6 = OutputYEP6
OutputYEP7='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_7.csv'
filename7 = OutputYEP7
OutputYEP8='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputYEP_8.csv'
filename8 = OutputYEP8


;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","


;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun


; Open the data file for writing.
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L AND counter LT 30L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer1, /lines
  READF, lun
ENDIF

IF counter EQ 30L THEN BEGIN; 
   OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 30L AND counter LT 60L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer2, /lines
  READF, lun
ENDIF

IF counter EQ 60L THEN BEGIN; 
   OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 60L AND counter LT 90L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer3, /lines
  READF, lun
ENDIF

IF counter EQ 90L THEN BEGIN; 
   OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 90L AND counter LT 120L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer4, /lines
  READF, lun
ENDIF

IF counter EQ 120L THEN BEGIN; 
   OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 120L AND counter LT 150L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer5, /lines
  READF, lun
ENDIF

IF counter EQ 150L THEN BEGIN; 
   OpenW, lun, filename6, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 150L AND counter LT 180L THEN BEGIN; 
  OpenU, lun, filename6, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer6, /lines
  READF, lun
ENDIF

IF counter EQ 180L THEN BEGIN; 
   OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 180L AND counter LT 210L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer7, /lines
  READF, lun
ENDIF

IF counter EQ 210L THEN BEGIN; 
   OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 210L AND counter LT 240L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer8, /lines
  READF, lun
ENDIF


; Write the data to the file.
sData = StrTrim(data,2)
sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
PrintF, lun, sData


; Close the file.
Free_Lun, lun
PRINT, '"Your YEP Output File is Ready"'
;****************************************************************************************


;***Creat an output file for WAE*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter
;PRINT, 'DAY', day
PRINT, nWAE; rowS


pointer1 = nWAE * counter; 1st line to read in 
pointer2 = nWAE * (counter - 30L)
pointer3 = nWAE * (counter - 60L)
pointer4 = nWAE * (counter - 90L)
pointer5 = nWAE * (counter - 120L)
pointer6 = nWAE * (counter - 150L)
pointer7 = nWAE * (counter - 180L)
pointer8 = nWAE * (counter - 210L)


data = WAE


; Set up variables.
;OutputWAE1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputWAE.csv'
OutputWAE1='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_1.csv'
filename1 = OutputWAE1 
OutputWAE2='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_2.csv'
filename2 = OutputWAE2
OutputWAE3='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_3.csv'
filename3 = OutputWAE3
OutputWAE4='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_4.csv'
filename4 = OutputWAE4
OutputWAE5='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_5.csv'
filename5 = OutputWAE5
OutputWAE6='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_6.csv'
filename6 = OutputWAE6
OutputWAE7='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_7.csv'
filename7 = OutputWAE7
OutputWAE8='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputWAE_8.csv'
filename8 = OutputYEP8


;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","

;OpenW, lun, filename2, /Get_Lun, Width=lineWidth


;; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun


; Open the data file for writing.
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L AND counter LT 30L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer1, /lines
  READF, lun
ENDIF

IF counter EQ 30L THEN BEGIN; 
   OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 30L AND counter LT 60L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer2, /lines
  READF, lun
ENDIF

IF counter EQ 60L THEN BEGIN; 
   OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 60L AND counter LT 90L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer3, /lines
  READF, lun
ENDIF

IF counter EQ 90L THEN BEGIN; 
   OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 90L AND counter LT 120L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer4, /lines
  READF, lun
ENDIF

IF counter EQ 120L THEN BEGIN; 
   OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 120L AND counter LT 150L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer5, /lines
  READF, lun
ENDIF

IF counter EQ 150L THEN BEGIN; 
   OpenW, lun, filename6, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 150L AND counter LT 180L THEN BEGIN; 
  OpenU, lun, filename6, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer6, /lines
  READF, lun
ENDIF

IF counter EQ 180L THEN BEGIN; 
   OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 180L AND counter LT 210L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer7, /lines
  READF, lun
ENDIF

IF counter EQ 210L THEN BEGIN; 
   OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 210L AND counter LT 240L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer8, /lines
  READF, lun
ENDIF


; Write the data to the file.
sData = StrTrim(data,2)
sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
PrintF, lun, sData

; Close the file.
Free_Lun, lun
PRINT, '"Your WAE Output File is Ready"'
;****************************************************************************************


;***Creat an output file for RAS*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter
;PRINT, 'DAY', day
PRINT, nRAS; rowS


pointer1 = nRAS * counter; 1st line to read in 
pointer2 = nRAS * (counter - 30L)
pointer3 = nRAS * (counter - 60L)
pointer4 = nRAS * (counter - 90L)
pointer5 = nRAS * (counter - 120L)
pointer6 = nRAS * (counter - 150L)
pointer7 = nRAS * (counter - 180L)
pointer8 = nRAS * (counter - 210L)


data = RAS


; Set up variables.
;OutputRAS1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputRAS.csv'
OutputRAS1='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_1.csv'
filename1 = OutputRAS1
OutputRAS2='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_2.csv'
filename2 = OutputRAS2
OutputRAS3='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_3.csv'
filename3 = OutputRAS3
OutputRAS4='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_4.csv'
filename4 = OutputRAS4
OutputRAS5='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_5.csv'
filename5 = OutputRAS5
OutputRAS6='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_6.csv'
filename6 = OutputRAS6
OutputRAS7='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_7.csv'
filename7 = OutputRAS7
OutputRAS8='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputRAS_8.csv'
filename8 = OutputYEP8
  
  
;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","

;OpenW, lun, filename2, /Get_Lun, Width=lineWidth


; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun


; Open the data file for writing.
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L AND counter LT 30L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer1, /lines
  READF, lun
ENDIF

IF counter EQ 30L THEN BEGIN; 
   OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 30L AND counter LT 60L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer2, /lines
  READF, lun
ENDIF

IF counter EQ 60L THEN BEGIN; 
   OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 60L AND counter LT 90L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer3, /lines
  READF, lun
ENDIF

IF counter EQ 90L THEN BEGIN; 
   OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 90L AND counter LT 120L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer4, /lines
  READF, lun
ENDIF

IF counter EQ 120L THEN BEGIN; 
   OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 120L AND counter LT 150L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer5, /lines
  READF, lun
ENDIF

IF counter EQ 150L THEN BEGIN; 
   OpenW, lun, filename6, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 150L AND counter LT 180L THEN BEGIN; 
  OpenU, lun, filename6, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer6, /lines
  READF, lun
ENDIF

IF counter EQ 180L THEN BEGIN; 
   OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 180L AND counter LT 210L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer7, /lines
  READF, lun
ENDIF

IF counter EQ 210L THEN BEGIN; 
   OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 210L AND counter LT 240L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer8, /lines
  READF, lun
ENDIF


; Write the data to the file.
sData = StrTrim(data,2)
sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
PrintF, lun, sData

 
; Close the file.
Free_Lun, lun
PRINT, '"Your RAS Output File is Ready"'
;****************************************************************************************


;***Creat an output file for EMS*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter
;PRINT, 'DAY', day
PRINT, nEMS; rowS


pointer1 = nEMS * counter; 1st line to read in 
pointer2 = nEMS * (counter - 30L)
pointer3 = nEMS * (counter - 60L)
pointer4 = nEMS * (counter - 90L)
pointer5 = nEMS * (counter - 120L)
pointer6 = nEMS * (counter - 150L)
pointer7 = nEMS * (counter - 180L)
pointer8 = nEMS * (counter - 210L)


data = EMS


; Set up variables.
;OutputEMS1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputEMS.csv'
OutputEMS1='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_1.csv'
filename1 = OutputEMS1
OutputEMS2='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_2.csv'
filename2 = OutputEMS2
OutputEMS3='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_3.csv'
filename3 = OutputEMS3
OutputEMS4='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_4.csv'
filename4 = OutputEMS4
OutputEMS5='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_5.csv'
filename5 = OutputEMS5
OutputEMS6='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_6.csv'
filename6 = OutputEMS6
OutputEMS7='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_7.csv'
filename7 = OutputEMS7
OutputEMS8='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputEMS_8.csv'
filename8 = OutputYEP8
  
  
;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","

;OpenW, lun, filename2, /Get_Lun, Width=lineWidth


;; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun


; Open the data file for writing.
IF counter EQ 0L THEN BEGIN; 
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L AND counter LT 30L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer1, /lines
  READF, lun
ENDIF

IF counter EQ 30L THEN BEGIN; 
   OpenW, lun, filename2, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 30L AND counter LT 60L THEN BEGIN; 
  OpenU, lun, filename2, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer2, /lines
  READF, lun
ENDIF

IF counter EQ 60L THEN BEGIN; 
   OpenW, lun, filename3, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 60L AND counter LT 90L THEN BEGIN; 
  OpenU, lun, filename3, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer3, /lines
  READF, lun
ENDIF

IF counter EQ 90L THEN BEGIN; 
   OpenW, lun, filename4, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 90L AND counter LT 120L THEN BEGIN; 
  OpenU, lun, filename4, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer4, /lines
  READF, lun
ENDIF

IF counter EQ 120L THEN BEGIN; 
   OpenW, lun, filename5, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 120L AND counter LT 150L THEN BEGIN; 
  OpenU, lun, filename5, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer5, /lines
  READF, lun
ENDIF

IF counter EQ 150L THEN BEGIN; 
   OpenW, lun, filename6, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 150L AND counter LT 180L THEN BEGIN; 
  OpenU, lun, filename6, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer6, /lines
  READF, lun
ENDIF

IF counter EQ 180L THEN BEGIN; 
   OpenW, lun, filename7, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 180L AND counter LT 210L THEN BEGIN; 
  OpenU, lun, filename7, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer7, /lines
  READF, lun
ENDIF

IF counter EQ 210L THEN BEGIN; 
   OpenW, lun, filename8, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 210L AND counter LT 240L THEN BEGIN; 
  OpenU, lun, filename8, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer8, /lines
  READF, lun
ENDIF


; Write the data to the file.
 sData = StrTrim(data,2)
 sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
 PrintF, lun, sData
   
   
; Close the file.
Free_Lun, lun
PRINT, '"Your EMS Output File is Ready"'
;****************************************************************************************


;  ;***Creat an output file for ROG*********************************************************
;  ;counter =  iDay - 213L + 1L; Same as the initial day of a daily loop 
;  ;PRINT, 'Counter', counter
;  ;PRINT, 'DAY', day
;  PRINT, nROG; rowS
;  
;  ;pointer = nROG * counter; 1st line to read in 
;pointer1 = nROG * counter; 1st line to read in 
;pointer2 = nROG * (counter - 30L)
;pointer3 = nROG * (counter - 60L)
;pointer4 = nROG * (counter - 90L)
;pointer5 = nROG * (counter - 120L)
;pointer6 = nROG * (counter - 150L)
;pointer7 = nROG * (counter - 180L)
;pointer8 = nROG * (counter - 210L)
;  
;  
;  data = ROG
;  
;  
;  ; Set up variables.
;  ;OutputROG1='HH'+Hypoxia+'DD'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputROG.csv'
;  OutputROG1='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_1.csv'
;  filename1 = OutputROG1
;  OutputROG2='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_2.csv'
;  filename2 = OutputROG2
;  OutputROG3='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_3.csv'
;  filename3 = OutputROG3
;  OutputROG4='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_4.csv'
;  filename4 = OutputROG4
;  OutputROG5='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_5.csv'
;  filename5 = OutputROG5
;  OutputROG6='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_6.csv'
;  filename6 = OutputROG6
;  OutputROG7='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_7.csv'
;  filename7 = OutputROG7
;  OutputROG8='HH_'+Hypoxia+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputROG_8.csv'
;  filename8 = OutputROG8
;    
;    
;  ;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
;  s = Size(data, /Dimensions)
;  xsize = s[0]
;  lineWidth = 1600
;  comma = ","
;  ;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;  
;  
;  ;; Write the data to the file.
;  ;sData = StrTrim(data,2)
;  ;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;  ;PrintF, lun, sData
;  ;Free_Lun, lun
;  
;  
; ; Open the data file for writing.
;  IF counter EQ 0L THEN BEGIN; 
;     OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 0L AND counter LT 30L THEN BEGIN; 
;    OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer1, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 30L THEN BEGIN; 
;     OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 30L AND counter LT 60L THEN BEGIN; 
;    OpenU, lun, filename2, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer2, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 60L THEN BEGIN; 
;     OpenW, lun, filename3, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 60L AND counter LT 90L THEN BEGIN; 
;    OpenU, lun, filename3, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer3, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 90L THEN BEGIN; 
;     OpenW, lun, filename4, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 90L AND counter LT 120L THEN BEGIN; 
;    OpenU, lun, filename4, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer4, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 120L THEN BEGIN; 
;     OpenW, lun, filename5, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 120L AND counter LT 150L THEN BEGIN; 
;    OpenU, lun, filename5, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer5, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 150L THEN BEGIN; 
;     OpenW, lun, filename6, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 150L AND counter LT 180L THEN BEGIN; 
;    OpenU, lun, filename6, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer6, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 180L THEN BEGIN; 
;     OpenW, lun, filename7, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 180L AND counter LT 210L THEN BEGIN; 
;    OpenU, lun, filename7, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer7, /lines
;    READF, lun
;  ENDIF
;  
;  IF counter EQ 210L THEN BEGIN; 
;     OpenW, lun, filename8, /Get_Lun, Width=lineWidth
;  ENDIF
;  IF counter GT 210L AND counter LT 240L THEN BEGIN; 
;    OpenU, lun, filename8, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer8, /lines
;    READF, lun
;  ENDIF
;  
;  ; Write the data to the file.
;  sData = StrTrim(data,2)
;  sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;  PrintF, lun, sData
;     
;  ; Close the file.
;  Free_Lun, lun
;  PRINT, '"Your ROG Output File is Ready"'


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
PRINT, 'OutputFiles ENDS HERE'
;RETURN
END