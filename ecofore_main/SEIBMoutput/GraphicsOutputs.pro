;**************************************************************************************************************
; The following example uses the data from the ASCII file. This file contains scattered elevation 
;data of a model of an inlet. This scattered elevation data contains two duplicate locations.

; The GRID_INPUT procedure is used to omit the duplicate locations for the GRIDDATA function. The GRIDDATA function 
;is then used to grid the data using the Radial Basis Function method. This method is specified by setting the METHOD 
;keyword the RadialBasisFunction string, although it could easily be done using the RADIAL_BASIS_FUNCTION keyword. 

; Note: Execute all of the following example sections in the order they are presented here.
;First, we import the data: 
;file = FILEPATH('irreg_grid1.txt', SUBDIRECTORY = ['examples', 'data'])

; Import the data from the file into a structure.
;dataStructure = READ_ASCII(file)

; Get the imported array from the first field of the structure.
;dataArray = TRANSPOSE(dataStructure.field1)

; Initialize the variables of this example from the imported array.
;x = dataArray[*, 0]
;y = dataArray[*, 1]
;data = dataArray[*, 2]

;filename = FILEPATH('LakeErieCB.jpg', /TMP)
;read_png, filename, TVRD(/TRUE);, /TRUE
;TV, filename
;***END OF THE EXAMPLE***************************************************



;***To Create graphic output files for 3D-SEIBM****************************************************************************************
; Time steps of simulations
;ts = 15L ;minutes in a time step
;td = (60L/ts)*24L ; number of time steps in a day

nGridcell = 77500L; the number of total grid cells
nEnvir3d = 77500*24L
TotBenBio = FLTARR(nGridcell)
Envir3d2 = FLTARR(16L, nGridcell)
;***************************************Spatial Component***********************************************
Grid3D2 =FLTARR(5L, nGridcell)
Grid2D2 = FLTARR(4L, 3875L)
Grid3D = GridCells3D()
Grid3D2 = Grid3D
;GrdCell3D[0, *] = xloc
;GrdCell3D[1, *] = yloc
;GrdCell3D[2, *] = zloc
;GrdCell3D[3, *] = GridID; for x and y
;GrdCell3D[4, *] = GridNo
Grid2D = GridCells2D()
Grid2D2 = Grid2D
InputArray =  FLTARR(10L, 1860000L)
EnvirArray = FLTARR(16, 1860000L)
;xyH[0, *] = xH
;xyH[1, *] = yH
;xyH[2, *] = xyID
;xyH[3, *] = Dpt
;********************************************************************************************************
;**The number of days in each month of 2005, DOY = iday + 1L***********************************
;IF (DOY GE 1L) AND (DOY LE 31L) January 1-31 (31d)
;IF (DOY GE 32L) AND (DOY LE 59L) February 1-28 (28d) 
;IF (DOY GE 60L) AND (DOY LE 90L) March 1-31 (31d)
;IF (DOY GE 91L) AND (DOY LE 120L) April 1-30 (30d)
;IF (DOY GE 121L) AND (DOY LE 151L) May 1-31 (31d)
;IF (DOY GE 152L) AND (DOY LE 181L) June 1-30 (30d)
;IF (DOY GE 182L) AND (DOY LE 212L) July 1-31 (31d)
;IF (DOY GE 213L) AND (DOY LE 243L) August 1-31 (31d)
;IF (DOY GE 244L) AND (DOY LE 273L) September 1-30 (30d)
;IF (DOY GE 274L) AND (DOY LE 304L) October 1-31 (31d)
;IF (DOY GE 305L) AND (DOY LE 334L) November 1-30 (30d)
;IF (DOY GE 335L) AND (DOY LE 365L) December 1-31 (31d)   
;***********************************************************************************************

;FOR iDay = 182L - 1L, 273L - 1L DO BEGIN;(Change iday values in other sub routines)*************DAYLY LOOP***************************************************************
;  PRINT, 'DAY', iday + 1L; day of the year 
;  counter =  iDay - 182L + 1L;*****FOR OUTPUT FILES (DOY)**************** 
  ;******DO THE SAME FOR the initialization (DOY-1) AND TotBenBio (DOY-1)********************
;  PRINT, 'Counter', counter
  
  ; For an input file counter
  iday = 289 - 1; iday = DOY-1L
  
  ; For the file names...
  DOY = iday+1; Day of year for environmental parameters, adjust accordingly...
;  DOY = 197 ; Day of year for fish outputs
  DOY = STRING(DOY)
  
  
  ; Average 2.702. in g/m2, total benthic biomass without mussels in June of 2005 from Lake Erie IfYLE data  
  ; Initial total benthic biomasss in May
  ;******INITIAL TOTAL BENTHIC BIOMASS-> NEED IT ONLY ONCE MAYBE MOVE TO "INITIAL FUNCTION"
  IF iDAY EQ 303 THEN BEGIN; ONLY DONE ONCE AT THE BEGINNING OF SIMULATIONS--> DOY NEEDS TO BE CHANGED WHEN TESTING
    BottomCell = WHERE(Grid3D2[2, *] EQ 20L , BottomCellcount, complement = NonBottomCell, ncomplement = NonBottomCellcount)
    IF BottomCellcount GT 0. THEN TotBenBio[BottomCell] = RANDOMU(seed, BottomCellcount)*(MAX(6.679) - MIN(0.4431)) + MIN(0.4431)
  ENDIF ELSE TotBenBio = TotBenBio

  
  ; Read a daily environmental input
  Envir3d = EcoForeInputFiles(iday, TotBenBio, Grid3D2, InputArray, EnvirArray) 

  
;  FOR iHour = 0L, 23L DO BEGIN;************************************HOURLY LOOP***************************************************************
;    PRINT,  'DAY', iday + 1L, '     HOUR', ihour + 1L
    ;inputcounter =  ihour + 24L * (iday); inpucounter + 1
    ;PRINT, 'INPUT COUNTER', inputcounter


    ; Call only an hourly input from a daily input read from the file
     ihour = 12L; 0 to 23L
     Envir3d2 = Envir3d[*, 77500L * ihour : 77500L * ihour + 77499L]



;   ENDFOR  
;ENDFOR
;PRINT, Envir3d2
newinput = Envir3d2; newinput[*, 77500L * ihour : 77500L * ihour + 77499L]

;***Horizontal map*****************************************************************************
xHV = transpose(Grid3D[0, *])
yHV = transpose(Grid3D[1, *])
z = transpose(Grid3D[2, *])
VerLay = 20L; vertical layer
Zindex = WHERE(z EQ VerLay, Zindexcount)
;PRINT, n_elements(Zindex)

x = xHV[Zindex]; y ID
y = yHV[Zindex]; z ID


; Zooplankton only
Zoop2Dpre = FLTARR(3, nGridcell)
Zoop2D = FLTARR(3, 3875L)
jv = 19L
FOR iv = 0L, nGridcell - 1L DO BEGIN
  ; Calculate cumulative biomass for each horizontal cell
  Zoop2Dpre[0, iv] = TOTAL(newinput[5, iv : jv]) 
  Zoop2Dpre[1, iv] = TOTAL(newinput[6, iv : jv]) 
  Zoop2Dpre[2, iv] = TOTAL(newinput[7, iv : jv]) 
  iv = jv
  jv = jv + 20L
ENDFOR
Zoop2D[0, *] = Zoop2Dpre[0, 0:77499L:20L]
Zoop2D[1, *] = Zoop2Dpre[1, 0:77499L:20L]
Zoop2D[2, *] = Zoop2Dpre[2, 0:77499L:20L]

;***FOR MAKING PLOTS FOR ENVIRONMENTAL INPUTS***********************************************
;DATA = TRANSPOSE(newinput[10, Zindex]) < 14.; FOR DO only;
DATA = TRANSPOSE(Zoop2D[0, *] + Zoop2D[1, *] + Zoop2D[2, *]) * 1000000.< 1000.; X1000 FOR Zooplankton


; FOR DO only
;Hypoxiadata = WHERE(DATA LT 4., Hypoxiadatacount)
;PRINT, transpose(newinput[3, Zindex])
;PRINT, 'NUMBER OF HYPOXIA CELLS =', N_ELEMENTS(Hypoxiadata)
;PRINT, '% OF HYPOXIA CELLS =', N_ELEMENTS(Hypoxiadata)*1./N_ELEMENTS(data)*100.
;PRINT, 'LOCATIONS OF HYPOXIA CELLS', (Hypoxiadata)




; For titles
;Parameter = 'Bottom Dissolved Oxygen (mg/L)'
;Parameter = 'Temperature (C)'
Parameter = 'Zooplankton (ug/l)'

; For the graphic output file name...
;EnvPar ='Dissolved oxygen'
;EnvPar ='Temperature'
EnvPar ='Zooplankton'
;***********************************************************************************************

;;***FOR MAKING PLOTS FOR SEIBM OUTPUTS**********************************************************
;FISH2D = FISH2DArray() 
;DATA = TRANSPOSE(FISH2D[4, *]/1000.) < 15000.; DIVIDE BIOMASS WITH 1000 TO CONVERT TO /kg
;; MAX: USE 15000 FOE WAE
;; 40000 FOR YEP
;; 10000 FOR RAS WITHOUT DIVIDING BY 1000 (g)
; 
;; ***NEED TO CHANGE THE SUBSCRIPT FOR EACH SPECIES (VERTICAL AS WELL)
;;PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;;PreyFish[1, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;;PreyFish[2, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;;PreyFish[3, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;;PreyFish[4, WAE[14, *]] = WAE[0, *]; ABUNDANCE

;; For titles
;Parameter = 'Fish Biomass (kg)'
;;Parameter = ' ()'

;; For the graphic output file name...
;Species = 'WAE'
;AgeClass = 'All'
;treatment = 'HH_ON_DD_ON_NIGHT_'
;*******************************************************************************************

;data = transpose(Grid3D[5, Zindex])
;PRINT, (x)
;PRINT, (y)
;PRINT, (DATA)
PRINT, MEAN(DATA), MIN(DATA), MAX(DATA)
;x = transpose(Grid2D[0, *])
;y = transpose(Grid2D[1, *])
;data = transpose(Grid2D[3, *])
;PRINT, (x)
;PRINT, (y)
;PRINT, (DATA)


; Next, display the data by scaling it to range from 1 to 253 so a color table can be applied. The values of 0, 254, 
;and 255 are reserved as outliers. We tell IDL to use decomposed color mode (a maximum of 256 colors) and load a color 
;table, then plot the data and show the data values in color. 

scaled = BYTSCL(data, MIN = 0, MAX = 1000, TOP = !D.TABLE_SIZE - 4) + 1B; ***Adjust MAX and MIN values for different parameters***
; For DO, 0 to 14
; For temperature, 0 to 30 for most months
; For fish biomass, 0 to 15000 FOR WAE; 40000 FOR YEP *** CHECK MAX VALUES
; For zooplankton, 0 to 

; Load colors
DEVICE, DECOMPOSED = 0
LOADCT, 39; 4, 5, 13, 26, 27, 32, 34&36 with a different background, 38, 39, 40; not bad; 14, 17, 20, 27 maybe
; 0 = BALCK TO WHITE
; 1 = BLUE/WHITE -> FOR DEPTH
; 2 = GREEN BACKGROUND 
; 3 = RED TO WHITE
; 5 = BLUE/RED/YELLOW/WHITE ->
; 7= PURPLE
; 8, 9, 10 = GREEN TO WHITE
; 11 = TRANSPARENT BACKGROUND FOR ZOOP AND FISH?
; 12 = GREEN BACKGROUND FOR PATCHY DATA
; 13 = PURPLE/BLUE/GREEN/YELLOW/RED FOR FOR ZOOP AND FISH?
; 14 = GREEN/BLUE/PURPLE/RED (GOOD FOR PATCHY DATA) FOR ZOOP AND FISH?
; 15 = RED/BLUE/GREEN/WHITE FOR ZOOP AND FISH?
; 16 = WHITE/BLUE/BROWN
; 17 = BLUE/GREEN/RED
; 23 = PURPLE/BLUE/GREEN/RED FOR DO ZOOP AND FISH?
; 24 = BREEN/YELLOW/BLUE/BLACK FOR DO?
; 26 = BLUE/GREEN/YELLOW/RED WITH RED LETTER -> FOR ZOOP AND FISH?
; 27 = BLUE/GREEN/YELLOW/RED
; 33 = BLUE/YELLOW/RED
; 36 =  MAYBE FOR DO
; 38 = PURPLE/BLUE/GREEN/BROWN (GOOD FOR PATCHY DATA) FOR ZOOP?
; 39 = PURPLE/BLUE/GREEN/YELLOW/RED FOR TEMP AND DO. AND ZOOP?
; 40 = RED LETTER


; Open a display window and plot the data points.
WINDOW, 0, Xsize = 1150, Ysize = 800
;graphic = PLOT(x, y,  LINESTYLE = 1, $ ; /XSTYLE, /YSTYLE,
    ;TITLE = 'Original Data, Scaled (1 to 253)');, $
    ;XTITLE = 'x', YTITLE = 'y', CharSize = 2., Xstyle = 4, Ystyle = 4, Zstyle = 4, BACKGROUND=0);
   
PLOT, x, y,  LINESTYLE = 1, $ ; /XSTYLE, /YSTYLE,
   TITLE = 'Lake Erie Central Basin '+Parameter, $
   XTITLE = 'x', YTITLE = 'y', CharSize = 2., Xstyle = 4, Ystyle = 4, Zstyle = 4, BACKGROUND=0; /NODATA 
  
; Now display the data values with respect to the color table.
FOR i = 0L, (N_ELEMENTS(x) - 1) DO PLOTS, x[i], y[i], PSYM = SYM(5), SYMSIZE = 1.65, COLOR = (scaled[i])

; FOR i = 0L, (N_ELEMENTS(x) - 1) DO PLOT(x[i], y[i], PSYM = SYM(5), SYMSIZE = 1.65, COLOR = (scaled[i], /OVERPLOT)
;colorbar, position = [.05,.15,.07,.95], range = [0, MAX(data)], /NAN, /vertical, format='(i5)', title=Parameter, CharSize = 1.5
colorbar, position = [.05,.15,.07,.95], range = [0, 1000], /NAN, /vertical, format='(i5)', title=Parameter, CharSize = 1.5
; ***Adjust range for different parameters***
; For DO, 0 to 14
; For Temperature, 0 to 30 for most months
; For fish biomass, 0 to 15000 FOR WAE; 40000 FOR YEP ***check max values
; For zooplankton, 0 to 


; (OPTIONAL) Add a box in the plot to emphasize
box_x_coords=[.4,.4,.6,.6,.4]
box_y_coords=[.4,.6,.6,.4,.4]
;plots, box_x_coords, box_y_coords,color=3,/normal
;xyouts, .5, .3, 'Non-hypoxic zone', color=10, size=2, alignment=.5, /normal
  
; (OPTIONAL) Add marker symbols
;index = round(randomu(seed, 300)*(max(n_elements(x))-min(0))+min(0)); RANDOM LOCATION FOR TESTING
;plots, x[index], y[index], psym=SYM(1), color=0, symsize=1.5;randomu(seed, N_ELEMENTS(index))*(max(4.)-min(1.))+min(1.)


; Create a graphic output file
;***filename=filepath(test, root_dir=['C:'], subdir=['Users\dgoto'])
; For fish outputs...
;HorizontalGrid=TREATMENT+species+'_'+ageclass+'_DOY'+DOY+'_HorGrid.PNG'

; For environmental parameters...
HorizontalGrid=EnvPar+'_DOY'+DOY+'_HorGrid.PNG'

PRINT, HorizontalGrid
filename = FILEPATH(HorizontalGrid, Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); /TMP)
WRITE_PNG, filename, TVRD(/TRUE);, /TRUE


; *Next, grid the data using the radial basis function method: 

; Preprocess and sort the data. GRID_INPUT will
; remove any duplicate locations.
GRID_INPUT, x, y, data, xSorted, ySorted, dataSorted


; Initialize the grid parameters.
gridSize = [500, 500]


; Use the equation of a straight line and the grid parameters to determine the x of the resulting grid.
slope = (MAX(xSorted) - MIN(xSorted))/(gridSize[0] - 1)
intercept = MIN(xSorted)
xGrid = (slope*FINDGEN(gridSize[0])) + intercept


; Use the equation of a straight line and the grid parameters to determine the y of the resulting grid.
slope = (MAX(ySorted) - MIN(ySorted))/(gridSize[1] - 1)
intercept = MIN(ySorted)
yGrid = (slope*FINDGEN(gridSize[1])) + intercept


; Grid the data with the Radial Basis Function method.
TRIANGULATE, x, y, tr
grid = GRIDDATA(xSorted, ySorted, dataSorted, DIMENSION = gridSize, METHOD = 'linear', TRIANGLES=tr); Quintic OR Linear
; NO COLOR IN LAND


; Finally, open a second display window and contour the Radial Basis Function results: 
WINDOW, 1, xsize=1150, ysize=800

scaled = BYTSCL(grid, MIN = 0, MAX = 1000, TOP = !D.TABLE_SIZE - 4) + 1B; ***Adjust MAX and MIN values for different parameters***
; For DO, 0 to 14
; For Temperature, 0 to 30 for most months
; For fish biomass, 0 to 15000 FOR WAE; 40000 FOR YEP ***check max values
; For zooplankton, 0 to 

GRIDZ = WHERE(GRID EQ 0., GRIDZCOUNT)
IF GRIDZCOUNT GT 0. THEN SCALED[GRIDZ] = 0.


CONTOUR, scaled, xGrid, YGrid, /CELL_FILL, LEVELS = BYTSCL(INDGEN(18), TOP = !D.TABLE_SIZE - 4) + 1B, $ ; , /XSTYLE, /YSTYLE
   C_COLORS = BYTSCL(INDGEN(18), TOP = !D.TABLE_SIZE - 4) + 1B, $
   TITLE = 'Lake Erie Central Basin '+Parameter, $
   XTITLE = 'x', YTITLE = 'y', CharSize=2., Xstyle=4, Ystyle=4, Zstyle=4, BACKGROUND=0;, /FOLLOW, C_LABELS=[0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0];, C_ANNOTATION=INDGEN(17); [2.0, 4.0, 8.0] 
;CONTOUR, scaled, xGrid, YGrid, LEVELS = BYTSCL(INDGEN(17), TOP = !D.TABLE_SIZE - 4) + 1B, $ ; , /XSTYLE, /YSTYLE
;   C_LABELS=[0,1,0,1,0,0,0,1,0,0,0,0,0,0], /OVERPLOT


; (OPTIONAL) Add a box in the plot to emphasize
box_x_coords=[.4,.4,.6,.6,.4]
box_y_coords=[.4,.6,.6,.4,.4]
;plots, box_x_coords, box_y_coords,color=3,/normal 
;xyouts, .5, .3, 'critical zone', color=10, size=2, alignment=.5, /normal
   
; (OPTIONAL) Add marker symbols
;index = round(randomu(seed, 300)*(max(n_elements(x))-min(0))+min(0))
;plots, x[index], y[index], psym=SYM(1), color=0, symsize=1.5;randomu(seed, N_ELEMENTS(index))*(max(4.)-min(1.))+min(1.)


; Create a color bar
;colorbar, position = [.05,.15,.07,.95], range=[0, MAX(data)], /vertical, format='(i5)', title=Parameter, CharSize = 1.5
colorbar, position = [.05,.15,.07,.95], range=[0, 1000], /vertical, format='(i5)', title=Parameter, CharSize = 1.5
; ***Adjust range for different parameters***
; For DO, 0 to 14
; For temperature, 0 to 30 for most months
; For fish biomass, 0 to 15000 FOR WAE; 40000 FOR YEP  ***check max values
; For zooplankton,  0 to 15000


; Create a graphic output file
; For fish outputs...
;HorizontalGrid2=TREATMENT+species+'_'+ageclass+'_DOY'+DOY+'_HorGrid2.PNG'

; For environmental parameters...
HorizontalGrid2=EnvPar+'_DOY'+DOY+'_HorGrid2.PNG'

filename = FILEPATH(HorizontalGrid2, Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); /TMP) 
WRITE_PNG, filename, TVRD(/TRUE);, /TRUE




;******VERTICAL TRANSECT*********************************************************************************************************
xHV = transpose(Grid3D[0, *])
yHV = transpose(Grid3D[1, *])
z = transpose(Grid3D[5, *])

;TransectX = transpose(round(RANDOMU(seed, 1)*(MAX(139L) - MIN(43L)) + MIN(43L))); 43 - 140, x is constant
;PRINT, TRANSECTX
TransectX = 65L
PRINT, TRANSECTX
Xindex = WHERE(xHV EQ TransectX, Xindexcount)
;PRINT,'xindex'
;PRINT, xindex

x = yHV[Xindex]; y ID
y = z[Xindex]; z ID


;***FOR MAKING PLOTS FOR ENVIRONMENTAL INPUTS ONLY*****************
;DATA = NewInput[10, Xindex] < 14.; Use <14. FOR DO only...
DATA = (NewInput[5, Xindex] + NewInput[6, Xindex] + NewInput[7, Xindex])* 1000000.; < 250.; Use <14. FOR zooplankton only


;; FOR DO only
;Hypoxiadata = WHERE(DATA LT 4., Hypoxiadatacount)
;;PRINT, transpose(newinput[3, Zindex])
;PRINT, 'NUMBER OF HYPOXIA CELLS', N_ELEMENTS(Hypoxiadata)
;PRINT, '% OF HYPOXIA CELLS', N_ELEMENTS(Hypoxiadata)*1./N_ELEMENTS(data)*100.
;print,'yHV[index2]', yHV[index2]
;print, 'z[index2]', z[index2]
;print, 'depth2', transpose(depth2)

;***FOR MAKING PLOTS FOR SEIBM OUTPUTS ONLY************************
;FISH3D = FISH3DArray() 
;DATA = TRANSPOSE(FISH3D[4, Xindex] / 1000.) < 2500.; ***DIVIDE BIOMASS WITH 1000 TO CONVERT TO /kg
; MAX 2500 FOR WAE
; 4500 FOR YEP
;PreyFish[0, YP[14, *]] = YP[0, *]; ABUNDANCE
;PreyFish[1, EMS[14, *]] = EMS[0, *]; ABUNDANCE
;PreyFish[2, RAS[14, *]] = RAS[0, *]; ABUNDANCE
;PreyFish[3, ROG[14, *]] = ROG[0, *]; ABUNDANCE
;PreyFish[4, WAE[14, *]] = WAE[0, *]; ABUNDANCE

PRINT, MEAN(DATA), MIN(DATA), MAX(DATA)


scaled = BYTSCL(DATA, MIN = 0, MAX = 10, TOP = !D.TABLE_SIZE - 4) + 1B; ***Adjust MAX and MIN values for different parameters***
; For DO, 0 to 14
; For Temperature, 0 to 30 for most months
; For biomass, 0 to 2500 FOR WAE, 4500 FOR YEP ***check max values
; For Zooplankton, 0 to 

; Load a color map
DEVICE, DECOMPOSED = 0
LOADCT, 14; 33 for temperature 
; 14 FOR ZOOP AND FISH?

; Open a display window and plot the data points.
WINDOW, 2, Xsize = 1200, Ysize = 350
PLOT, x, y,  LINESTYLE = 1, $ ; /XSTYLE, /YSTYLE,
   TITLE = 'Lake Erie Central Basin '+Parameter, yrange=[MAX(y), 0], $
   XTITLE = 'x', YTITLE = 'y', CharSize = 1.5, Xstyle = 4, Ystyle = 1, Zstyle = 4, BACKGROUND=0;

    
; Now display the data values with respect to the color table.
FOR i = 0L, (N_ELEMENTS(x) - 1) DO PLOTS, x[i], y[i], PSYM = SYM(5), $
   SYMSIZE = 4., COLOR = (scaled[i])


; Create a color bar
;colorbar, position = [.05,.15,.07,.95], range=[0, MAX(DATA)],/vertical, format='(i5)', title=Parameter, CharSize = 1.5
colorbar, position = [.05,.15,.07,.95], range=[0, 10],/vertical, format='(i5)', title=Parameter, CharSize = 1.5
; ***Adjust range for different parameters***
; For DO, 0 to 14
; For temperature, 0 to 30 for most months
; For fish biomass, 0 to 2500 FOR WAE; 4500 FOR YEP ***check max values
; For zooplankton, 0 to 


; (OPTIONAL) Add a box in the plot to emphasize
box_x_coords=[.4,.4,.6,.6,.4]
box_y_coords=[.4,.6,.6,.4,.4]
;plots, box_x_coords, box_y_coords, color=0, /normal 
;xyouts, .5, .3, 'critical zone', color=0, size=1.5, alignment=.5, /normal
  
; (OPTIONAL) Add marker symbols
;index = round(randomu(seed, 100)*(max(n_elements(x))-min(0))+min(0))
;plots, x[index], y[index], psym=SYM(1), color=0, symsize=1.5;randomu(seed, N_ELEMENTS(index))*(max(4.)-min(1.))+min(1.)


; Create a graphic output file
; For fish outputs...
;VerticalGrid=TREATMENT+species+'_'+ageclass+'_DOY'+DOY+'_VerGrid.jpg'

; For environmental parameters...
VerticalGrid=EnvPar+'_DOY'+DOY+'_VerGrid.jpg'

PRINT, VerticalGrid
filename = FILEPATH(VerticalGrid, Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); /TMP)
WRITE_PNG, filename, TVRD(/TRUE);, /TRUE


; Next, grid the data using the radial basis function method: 

; Preprocess and sort the data. GRID_INPUT will
; remove any duplicate locations.
GRID_INPUT, x, y, data, xSorted, ySorted, dataSorted


; Initialize the grid parameters.
gridSize = [500, 500]


; Use the equation of a straight line and the grid parameters to determine the x of the resulting grid.
slope = (MAX(xSorted) - MIN(xSorted))/(gridSize[0] - 1)
intercept = MIN(xSorted)
xGrid = (slope*FINDGEN(gridSize[0])) + intercept


; Use the equation of a straight line and the grid parameters to determine the y of the resulting grid.
slope = (MAX(ySorted) - MIN(ySorted))/(gridSize[1] - 1)
intercept = MIN(ySorted)
yGrid = (slope*FINDGEN(gridSize[1])) + intercept


; Grid the data with the Radial Basis Function method.
TRIANGULATE, x, y, tr
grid = GRIDDATA(xSorted, ySorted, dataSorted, DIMENSION = gridSize, METHOD = 'linear', TRIANGLES=tr) 
;grid = GRIDDATA(xSorted, ySorted, dataSorted, DIMENSION = gridSize, METHOD = 'RadialBasisFunction') 


; Finally, open a second display window and contour: 
WINDOW, 3, xsize=1200, ysize=350

scaled = BYTSCL(grid, MIN = 0, MAX = 10, TOP = !D.TABLE_SIZE - 4) + 1B; ***Adjust MAX and MIN values for different parameters***
; For DO, 0 to 14
; For temperature, 0 to 30 for most months
; For fish biomass, 0 to 2500 FOR WAE 4500 FOR YEP ***check max values
; For zooplankton, 0 to 


CONTOUR, scaled, xGrid, YGrid, /CELL_FILL, LEVELS = BYTSCL(INDGEN(18), TOP = !D.TABLE_SIZE - 4) + 1B, $ ; , /XSTYLE, /YSTYLE
   C_COLORS = BYTSCL(INDGEN(18), TOP = !D.TABLE_SIZE - 4) + 1B, $
   TITLE = 'Lake Erie Central Basin '+Parameter, $
   XTITLE = 'x', YTITLE = 'y', CharSize=1.5,xstyle=4, ystyle=1, zstyle=4, Yrange=[MAX(y), 0], BACKGROUND=0, /FOLLOW;


; (OPTIONAL) Add a box in the plot to emphasize
box_x_coords=[.4,.4,.6,.6,.4]
box_y_coords=[.4,.6,.6,.4,.4]
;plots, box_x_coords, box_y_coords,color=0,/normal 
;xyouts, .5, .3, 'critical zone', color=0, size=2., alignment=.5, /normal

; (OPTIONAL) Add marker symbols
;index = round(randomu(seed, 100)*(max(n_elements(x))-min(0))+min(0))
;plots, x[index], y[index], psym=SYM(1), color=0, symsize=1.5;randomu(seed, N_ELEMENTS(index))*(max(4.)-min(1.))+min(1.)


; Create a color bar
;colorbar, position = [.05,.15,.07,.95], range=[0, MAX(DATA)], /vertical, format='(i5)', title=Prameter, CharSize = 1.5
colorbar, position = [.05,.15,.07,.95], range=[0, 10], /vertical, format='(i5)', title=Prameter, CharSize = 1.5
; ***Adjust range for different parameters***
; For DO, 0 to 14
; For Temperature, 0 to 30 for most months
; For fish biomass, 0 to 2500 FOR WAE, 4500 FOR YEP ***check max values
; For zooplankton 0 to

; Create a graphic output file
; For fish outputs...
;VerticalGrid2=TREATMENT+species+'_'+ageclass+'_DOY'+DOY+'_VerGrid2.PNG'

; For environmental parameters...
VerticalGrid2=EnvPar+'_DOY'+DOY+'_VerGrid2.PNG'

;PRINT, VerticalGrid2
filename = FILEPATH(VerticalGrid2, Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); /TMP)
WRITE_PNG, filename, TVRD(/TRUE);, /TRUE
;********************************************************************************************************************************8

END