;First, we define a procedure called EX_BOX, which draws a box given the coordinates of two diagonal corners:

; Define a procedure that draws a box, using POLYFILL, 

; whose corners are (X0, Y0) and (X1, Y1):

PRO EX_BOX, X0, Y0, X1, Y1, color

   ; Call POLYFILL:

   POLYFILL, [X0, X0, X1, X1], [Y0, Y1, Y1, Y0], COL = color

END

;Next, create a procedure to draw the bar graph:

PRO EX_BARGRAPH, minval

   ; Define variables:

   @plot01

   ; Width of bars in data units:

   del = 1./5.

   ; The number of colors used in the bar graph is

   ; defined by the number of colors available on your system:

   ncol=!D.N_COLORS/5

   ; Create a vector of color indices to be used in this procedure:

   colors = ncol*INDGEN(4)+ncol

   ; Loop for each sample:

   FOR iscore = 0, 3 DO BEGIN

   ; The y value of annotation. Vertical separation is 20 data

   ; units:

   yannot = minval + 20 *(iscore+1)

   ; Label for each bar:

   XYOUTS, 1984, yannot, names[iscore]

   ; Bar for annotation:

   EX_BOX, 1984, yannot - 6, 1988, yannot - 2, colors[iscore]

   ; The x offset of vertical bar for each sample:

   xoff = iscore * del - 2 * del

   ; Draw vertical box for each year's sample:

   FOR iyr=0, N_ELEMENTS(year)-1 DO $

      EX_BOX, year[iyr] + xoff, minval, $

      year[iyr] + xoff + del, $

      allpts[iyr, iscore], $

      colors[iscore]

   ENDFOR

END

