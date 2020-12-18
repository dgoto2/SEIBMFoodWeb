MAP_SET, /SATELLITE, SAT_P=[1.0251, 55, 150], 41.5, -74., $
   /ISOTROPIC, /HORIZON, $
   LIMIT=[39, -74, 33, -80, 40, -77, 41,-74], $
   /CONTINENTS, TITLE='Satellite / Tilted Perspective'
; Set up the satellite projection:
MAP_GRID, /LABEL, LATLAB=-75, LONLAB=39, LATDEL=1, LONDEL=1
; Get North vector:
p = convert_coord(-74.5, [40.2, 40.5], /TO_NORM)
; Draw North arrow:
ARROW, p(0,0), p(1,0), p(0,1), p(1,1), /NORMAL
XYOUTS, -74.5, 40.1, 'North', ALIGNMENT=0.5
;41, -84, 43, -78

MAP_SET, /GNOMIC, 42, -81, LIMIT = [41, -84, 43, -78], $
   /ISOTROPIC, /GRID, /CONTINENT, $
   TITLE = 'Oblique Gnomonic'

 datafile = 'gshhs_h.b'
 Window, XSize=500, YSize=350
 pos = [0.1,0.1, 0.9, 0.8]
 Map_Set, -25.0, 135.0, Position=pos, Scale=64e6, /Mercator, /NoBorder
 Polyfill, [pos[0], pos[0], pos[2], pos[2], pos[0]], $
           [pos[1], pos[3], pos[3], pos[1], pos[1]], $
           /Normal, Color=FSC_Color('Almond')
 Map_GSHHS_Shoreline, datafile, /Fill, Level=3, /Outline
 XYOutS, 0.5, 0.85, 'Australia', Font=0, Color=FSC_Color('Almond'), $
       /Normal, Alignment=0.5


END