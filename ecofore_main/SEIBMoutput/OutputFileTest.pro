FOR IDAY=244-1, 285-1 DO BEGIN
ihour=24
;iDay = STRING(iDay)
;ihour = STRING(ihour)
data = FINDGEN(30)
nYP =1L
nWAE =1L
HYPOXIA='ON'
DENSITYDEPENDENCE='ON'
counter =  iday - 244L + 1L
pointer = nYP * counter; 1st line to read in 
; Set up variables.
;OutputYEP1='HH_'+Hypoxia+'_DD_'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputYEP.csv'
OutputYEP2='HH_'+Hypoxia+'_DD_'+DensityDependence+'_IDLoutputYEP.csv'
filename1 = OutputYEP2
;filename2 = OutputYEP1
 
;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
 s = Size(data, /Dimensions)
 xsize = s[0]
 lineWidth = 1600
 comma = ","
 
;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;; Write the data to the file.
; sData = StrTrim(data,2)
; sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
; PrintF, lun, sData
; Free_Lun, lun
 
IF counter EQ 0L THEN BEGIN; 
; Open the data file for writing.
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer, /lines
  READF, lun
ENDIF
; Write the data to the file.
 sData = StrTrim(data,2)
 sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
 PrintF, lun, sData
; Close the file.
 Free_Lun, lun
PRINT, '"Your YEP Output File is Ready"'

;***Creat an output file for WAE*********************************************************
;counter =  iday - 182L; Same as the initial day of a daily loop 
;PRINT, 'Counter', counter
;PRINT, 'DAY', day
;PRINT, nWAE; rowS
pointer = nWAE * counter; 1st line to read in 
data = FINDGEN(30)*5.
; Set up variables.
;OutputWAE1='HH_'+Hypoxia+'_DD_'+DensityDependence+'DOY_'+iDAY+'_Hour_'+iHOUR+'_IDLoutputWAE.csv'
OutputWAE2='HH_'+Hypoxia+'_DD_'+DensityDependence+'_IDLoutputWAE.csv'
filename1 = OutputWAE2
;filename2 = OutputWAE1

;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 1600
comma = ","

;OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;
;; Write the data to the file.
;sData = StrTrim(data,2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;Free_Lun, lun
 
IF counter EQ 0L THEN BEGIN; 
; Open the data file for writing.
   OpenW, lun, filename1, /Get_Lun, Width=lineWidth
ENDIF
IF counter GT 0L THEN BEGIN; 
  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  SKIP_LUN, lun, pointer, /lines
  READF, lun
ENDIF
; Write the data to the file.
   sData = StrTrim(data,2)
   sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
   PrintF, lun, sData
; Close the file.
   Free_Lun, lun

;*************************************************************************************
ENDFOR
PRINT, '"Your WAE Output File is Ready"'
END