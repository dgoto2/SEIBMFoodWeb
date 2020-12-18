FUNCTION GridCells3D

;FOR TESTING-------------
;PRO GridCells3D; FOR TESTING
;Grid2D = GridCells2D()
;------------------------

; 3D horizontal cells
; Specify the file location
;gridfile = FILEPATH('gridcells.csv', Root_dir = '/home/ba01/u133/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM'); COATES DIRECTORY
;gridfile = FILEPATH('gridcells.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM'); COATES DIRECTORY
;gridfile = FILEPATH('gridcells.csv', Root_dir = 'C:', SUBDIR = 'Users\dgoto\Desktop'); DESKTOP
gridfile = FILEPATH('gridcells.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); LAPTOP

OPENR, lun1, gridfile, /get_lun
;header = STRARR(4)
;readf, lun, header
;read in the number of rows in the data file
maxrow = 77500L; max number of rows allowed in the input file 
maxrowh = 6700L; max number of rows for horizontal cells + buffer cells
GrdCell3D = FLTARR(7L, maxrow)
xloc = INTARR(maxrow)
yloc = INTARR(maxrow)
GridNo = FLTARR(maxrow);
depth = FLTARR(maxrow)
x = 0L
y = 0L
GN = 0L
dep = 0.
;idep =0.
count = 0L

WHILE (NOT EOF(lun1)) DO BEGIN
  READF, lun1, x, y, GN, dep
  xloc(count) = x
  yloc(count) = y
  GridNo(count) = GN
  depth(count) = dep
  count = count + 1L
ENDWHILE
FREE_LUN, lun1
xloc = xloc(0 : count - 1L)
yloc = yloc(0 : count - 1L)
GridNo = GridNo(0 : count - 1L)
depth = depth(0 : count - 1L)
;idepth = idepth(0 : count - 1L)

; Create vertical layers
zloc = INTARR(maxrow)
VerLay = INDGEN(20); 1 = top layer; 20 = bottom layer
j = 19L
FOR d = 0L, maxrow - 1L DO BEGIN
  zloc[d:j] = VerLay + 1L
  d = j
  j = j + 20L
ENDFOR

buffer = FLTARR(3L, maxrowh)
bufferX = INTARR(maxrowh)
bufferY = INTARR(maxrowh)

bufferID = INDGEN(maxrowh)
; Create horizontal buffer cells
xbuffer = INTARR(67) + 42L; = FID
jjjjj = 66L
FOR iiiii = 0L, maxrowh - 1L DO BEGIN
  bufferx[iiiii:jjjjj] = xbuffer 
  iiiii = jjjjj
  jjjjj = jjjjj + 67L
  xbuffer = xbuffer + 1L
ENDFOR

yBuffer = INDGEN(67) + 6L; 1 = top layer; 20 = bottom layer
jjjj = 66L
FOR iiii = 0L, maxrowh - 1L DO BEGIN
  buffery[iiii:jjjj] = yBuffer + 1
  iiii = jjjj
  jjjj = jjjj + 67L
ENDFOR

GridID = FLTARR(maxrow)
;depthHV = FLTARR(maxrow)
; Create grid IDs for x and y
gID = FLTARR(20); = FID
;dHV = FLTARR(20)
jj = 19L
FOR ii = 0L, maxrow - 1L DO BEGIN
  GridID[ii:jj] = gID
  ;depthHV[ii:jj] = depth
  ii = jj
  jj = jj + 20L
  gID = gID + 1L
  ;dHV = dHV + 1L
ENDFOR
depthHV = depth / 20. * zloc

;;***********************************************************************************
;;Create depth array
;Grid2D = GridCells2D()
;depth2 = grid2d[3, *]
;newdepth = fltarr(20L, 3875L)
;newdepth[0, *] = depth2
;newdepth[1, *] = depth2
;newdepth[2, *] = depth2
;newdepth[3, *] = depth2
;newdepth[4, *] = depth2
;newdepth[5, *] = depth2
;newdepth[6, *] = depth2
;newdepth[7, *] = depth2
;newdepth[8, *] = depth2
;newdepth[9, *] = depth2
;newdepth[10, *] = depth2
;newdepth[11, *] = depth2
;newdepth[12, *] = depth2
;newdepth[13, *] = depth2
;newdepth[14, *] = depth2
;newdepth[15, *] = depth2
;newdepth[16, *] = depth2
;newdepth[17, *] = depth2
;newdepth[18, *] = depth2
;newdepth[19, *] = depth2
;newdepth=TRANSPOSE(NEWDEPTH)
;;print, 'newdepth', transpose(newdepth)
;newdepth2 = fltarr(77500L)
;
;DATA2 = fltarr(1,77500L)
;U=19L
;FOR T=0, 3874L do begin
;  FOR TTT=0, 19L do begin
;  data2[0, TTT] = newdepth[T, 0:19]
;  TTT = U
;  U = U + 20L
;  DATA = DATA2
;  pointer = T*20L
;  ; Set up variables.
;     filename = 'newdepth.csv'  
;     ;;****the files should be in the same directory as the "IDLWorksapce80" default folder.****
;     s = Size(data, /Dimensions)
;     xsize = s[0]
;     lineWidth = 1600
;     comma = ","
;    OpenU, lun, filename, /Get_Lun, Width=lineWidth
;    SKIP_LUN, lun, pointer, /lines
;    READF, lun
;  ; Write the data to the file.
;     sData = StrTrim(data,2)
;     sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;     PrintF, lun, sData
;  ; Close the file.
;     Free_Lun, lun
;  PRINT, '"Your Output File is Ready"'
;  ENDFOR
;ENDFOR
;;*******************************************************************************
  
GrdCell3D[0, *] = xloc
GrdCell3D[1, *] = yloc
GrdCell3D[2, *] = zloc
GrdCell3D[3, *] = GridID; for x and y
GrdCell3D[4, *] = GridNo
GrdCell3D[5, *] = DepthHV; 
GrdCell3D[6, *] = Depth; 

buffer[0, *] = bufferX
buffer[1, *] = bufferY
buffer[2, *] = bufferID
;PRINT, buffer

;PRINT, GrdCell3D
RETURN, GrdCell3D; TURN OFF WHEN TESTING
END