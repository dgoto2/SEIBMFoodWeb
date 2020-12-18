PRO PointSourceOverlay

   ; Obtain the data: lat, lon, soilc.
   Restore, File='ptsource_carbon.sav'

   ; Set up color model, open window.
   Device, Decomposed=0, Get_Decomposed=currentColorModel
   Window, /Free, XSize=600, YSize=400, Title='Point Source Overlay on Map'

   ; Set up the soil carbon colors.
   soil_colors = ['purple', 'dodger blue', 'dark green', 'lime green', $
             'green yellow', 'yellow', 'hot pink', 'crimson']
   TVLCT, FSC_Color(soil_colors, /Triple), 1
   soilc_colors = BytScl(soilc, Top=7) + 1B

   ; Set up the map projecton data space.
   Erase, Color=FSC_Color('white')
   Map_Set, /Cylindrical, /NoBorder, /NoErase, $
   Limit=[41, -84, 43, -78], Position=[0.1, 0.1, 0.8, 0.9]

   ; Create a land mask.
   Map_Continents, Color=FSC_Color('black'), /Fill
   mask = TVRD()

   ; Plot only those points that are over "land".
   dc = Convert_Coord(lon, lat, /Data, /To_Device)
   indices = Where(mask[dc[0,*],dc[1,*]] EQ 0)
   PlotS, lon[indices ], lat[indices ], PSym=Symcat(15), $
      Color=soilc_colors[indices ], SymSize=0.5

   ; Pretty everything up.
   Map_Continents, Color=FSC_Color('charcoal')
   Map_Grid, /Box, Color=FSC_Color('charcoal')
   Colorbar, /Vertical, Position=[0.87, 0.1, 0.9, 0.9], Bottom=1, NColors=8, $
      Divisions=8, Minor=0, YTicklen=1, Range=[0,Max(soilc)], Color=FSC_Color('charcoal'), $
      /Right, Title='Ton/ha', Format='(F5.3)'

   ; Switch back to color model in effect before we changed it.
   Device, Decomposed=currentColorModel

END
