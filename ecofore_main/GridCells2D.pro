FUNCTION GridCells2D
;PRO GridCells2D

; 2D horizontal cells with ID
; Specify the file location
;gridfile2 = FILEPATH('XYgridcells.csv', Root_dir = '/home/ba01/u133/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM'); COATES DIRECTORY
;gridfile2 = FILEPATH('XYgridcells.csv', Root_dir = '/scratch/lustreA/d/dgoto', SUBDIR = 'EcoFore10_IDL_SEIBM'); COATES DIRECTORY
;gridfile2 = FILEPATH('XYgridcells.csv', Root_dir = 'C:', SUBDIR = 'Users\dgoto\Desktop'); DESKTOP
gridfile2 = FILEPATH('XYgridcells.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'); LAPTOP

OPENR, lun2, gridfile2, /get_lun
;header = STRARR(4)
;readf, lun, header
;read in the number of rows in the data file
maxrowhh = 3875L; max number of rows for horizontal cells
xyH = FLTARR(4L, maxrowhh)
xH = FLTARR(maxrowhh)
yH = FLTARR(maxrowhh)
xyID = FLTARR(maxrowhh)
Dpt = FLTARR(maxrowhh)

xHo = 0L
yHo = 0L
xyHo = 0L
Dept = 0.0
count2 = 0L
WHILE (NOT EOF(lun2)) DO BEGIN
  READF, lun2, xHo, yHo, xyHo, Dept
  xH(count2) = xHo
  yH(count2) = yHo
  xyID(count2) = xyHo
  Dpt(count2) = Dept
  count2 = count2 + 1
ENDWHILE
FREE_LUN, lun2

xH = xH(0 : count2 - 1L)
yH = yH(0 : count2 - 1L)
xyID = xyID(0 : count2 - 1L)
Dpt = Dpt(0 : count2 - 1L)

xyH[0, *] = xH
xyH[1, *] = yH
xyH[2, *] = xyID
xyH[3, *] = Dpt

;PRINT, xyH
RETURN, xyH
END