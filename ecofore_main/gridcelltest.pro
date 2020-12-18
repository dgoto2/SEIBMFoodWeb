Grid2D = GridCells2D()
Grid3D = GridCells3D()
ihour = 22L
NewInput = EcoForeInputFiles()
newinput = newinput[*, 77500L * ihour : 77500L * ihour + 77499L]

; Horizontal map*************************************
xHV = transpose(Grid3D[0, *])
yHV = transpose(Grid3D[1, *])
z = transpose(Grid3D[2, *])
VerLay = 20L; vertical layer
Zindex = WHERE(z EQ VerLay, Zindexcount)
PRINT, n_elements(Zindex)


x = xHV[Zindex]; y ID
y = yHV[Zindex]; z ID
data = transpose(newinput[10, Zindex]) < 20.; FOR DO; X1000 FOR ZOOP
Hypoxiadata = WHERE(DATA LT 4., Hypoxiadatacount)
PRINT, 'LOCATIONS OF horizontal CELLSx',transpose(newinput[0, Zindex])
PRINT, 'LOCATIONS OF horizontal CELLSy',transpose(newinput[1, Zindex])
PRINT, 'LOCATIONS OF horizontal CELLSid',transpose(newinput[3, Zindex])


;PRINT, 'NUMBER OF HYPOXIA CELLS', N_ELEMENTS(Hypoxiadata)
;PRINT, '% OF HYPOXIA CELLS', N_ELEMENTS(Hypoxiadata)*1./N_ELEMENTS(data)*100.
;PRINT, 'LOCATIONS OF HYPOXIA CELLS', (Hypoxiadata)

;data = transpose(Grid3D[5, Zindex])
;PRINT, (x)
;PRINT, (y)
;PRINT, (DATA)
;PRINT, MIN(DATA), MAX(DATA)
;x = transpose(Grid2D[0, *])
;y = transpose(Grid2D[1, *])
;data = transpose(Grid2D[3, *])
;PRINT, (x)
;PRINT, (y)
;PRINT, (DATA)


END