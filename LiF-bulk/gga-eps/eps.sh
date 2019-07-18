#!/bin/bash


rm eps.dat
for i in `seq 1 9`
do   
    head -2 EPS000$i.dat | tail -1 | awk '{ print $3 " " $5}' >> eps.dat
done

for i in `seq 10 11`
do  
    head -2 EPS00$i.dat | tail -1 | awk '{ print $3 " " $5}' >> eps.dat
done

rm fit-bulk.gnu
rm data-epsilon

echo "unset key" >> fit-bulk.gnu
echo "set terminal postscript color enhanced eps" >> fit-bulk.gnu
echo "set output 'fit-bulk.eps'" >> fit-bulk.gnu
echo "f(x)=a*x+b" >> fit-bulk.gnu
echo "fit [0.02:0.05] f(x) 'eps.dat' u 1:2 via a,b" >> fit-bulk.gnu
echo "plot[0:0.05] f(x) ,'eps.dat' w lp pt 3 lt 3" >> fit-bulk.gnu
echo "print 'E(infty)=',b" >> fit-bulk.gnu
echo "set print 'data-epsilon'" >> fit-bulk.gnu
echo "print 'E(infty)= ',b" >> fit-bulk.gnu
gnuplot fit-bulk.gnu


rm nlfc.dat
for i in `seq 1 9`
do   
    head -2 EPS000$i.nlfc.dat | tail -1 | awk '{ print $3 " " $5}' >> nlfc.dat
done

for i in `seq 10 11`
do  
    head -2 EPS00$i.nlfc.dat | tail -1 | awk '{ print $3 " " $5}' >> nlfc.dat
done

rm fit-nlfc.gnu


echo "unset key" >> fit-nlfc.gnu
echo "set terminal postscript color enhanced eps" >> fit-nlfc.gnu
echo "set output 'fit-nlfc.eps'" >> fit-nlfc.gnu
echo "f(x)=a*x+b" >> fit-nlfc.gnu
echo "fit [0.02:0.05] f(x) 'nlfc.dat' u 1:2 via a,b" >> fit-nlfc.gnu
echo "plot[0:0.05] f(x) ,'nlfc.dat' w lp pt 3 lt 3" >> fit-nlfc.gnu
echo "print 'E(infty,no-LFC)=',b" >> fit-nlfc.gnu
echo "set print 'data-epsilon' append" >> fit-nlfc.gnu
echo "print 'E(infty,no-LFC)= ',b" >> fit-nlfc.gnu
gnuplot fit-nlfc.gnu
cat data-epsilon
