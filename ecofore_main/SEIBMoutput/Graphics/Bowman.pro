x=findgen(11)
y=sqrt(x)
plot, x,y
oplot,x,2.*y

plot,x[1:10],y[1:10],/xlog,/ylog,psym=-4

plot,x,y
for i=1,7 do oplot, x, y/i, psym=i


plot,x,y
for i=1,7 do oplot, x, y/i, psym=-i;'-' sign connect symbols and lines

                                   ;'+' signs are useful for scatter plots     

plot,x,y
for i=1,5 do oplot, x, y/i, linestyle=i

plot, x,y
for i=1,5 do oplot, x, y/i, linestyle=i, psym=-i

plot,x,y, title='square-root function', xtitle='x',ytitle='y',subtitle='you can have a subtitle, too'




















































end