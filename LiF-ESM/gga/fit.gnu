set xlabel "z[bohr]"
set ylabel "{/Symbol D}V [Ry]"
g(x)=c*x+d
fit g(x) "out3" using 1:2 via c,d
f(x)=a*x+b
fit f(x) "out2" using 1:2 via a,b
print c/a
plot "out1" w l title "{/Symbol D}V" , "out2" title "for fitting {/Symbol e}", \
"out3" title "for fitting {/Symbol e}_0", f(x) title "{/Symbol e}(tangent)",g(x) title "{/Symbol e}_0(tangent)"
set terminal postscript color enhanced eps 
set output "fit.eps"
set label 1 at -30,0.3 sprintf("{{/Symbol e}(tangent)=%10.3e}", a) 
set label 2 at -30,0.25 sprintf("{{/Symbol e}_0(tangent)=%10.3e}", c)
set label 3 at -30,0.20 sprintf("{{/Symbol e}/{/Symbol e}_0=%10.3e}", c/a)
replot

print "E=  ",a
print "E0=  ",c
print "E/E0=  ",c/a
