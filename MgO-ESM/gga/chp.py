#!/usr/bin/env python2.7

import sys
 
import numpy as np
#import gnuplot as gp

linr=40
csvold=0
cor=0.001

ch1f = open("0.0/charge_pot.dat", "r")
ch2f = open("0.2/charge_pot.dat", "r")

out1 = open("out1", "w")
out2d = open("out2d", "w")
out3 = open("out3", "w")

swt=0
ml=9

c1 = ch1f.readlines()
c2 = ch2f.readlines()

iend=(len(c1))-6

chl=[]
 
csv=0
zsv=0
i=0
Ed=100

for i in range(3,iend):
    

    cdum=c1[i].split()
    z1=float(cdum[0])
    ch1=float(cdum[2])

    cdum=c2[i].split()
    z2=float(cdum[0])
    ch2=float(cdum[2])
    cdif=ch2-ch1

    out_list=[cdum[0],"  ",str(cdif),"\n"]
    out1.writelines(out_list)
    
    if cdif-csv >= 0 and (cdif-csv)/(z1-zsv) <= Ed and swt >= 1 and swt < ml :
#    if cdif-csv >= 0 and swt >= 1 and swt < ml :
#        print z1,cdif    
        out_list=[cdum[0],"  ",str(cdif),"\n"]
        out2d.writelines(out_list)
    if cdif < csv  and csv > csvold :
        swt=swt+1

    if i == 3:
        ea=ch2-ch1
        za=z1

    if i == 4:
        eb=ch2-ch1   
        zb=z1
        Ed=(cdif-csv)/(z1-zsv)-cor

    if i <= linr:
        out3.writelines(out_list)


    csvold=csv
    csv=ch2-ch1    
    zsv=z1


eps0=(eb-ea)/(zb-za)

print "eps_0=",eps0

out2d.close()
print "close out2d"

out2d = open("out2d", "r")
out2 = open("out2", "w")
out2f= out2d.readlines()

for i in range(len(out2f)-1):

    val0=float(out2f[i].split()[1])
    val1=float(out2f[i+1].split()[1])

    if val1 > val0  :
#        print val0
        out_list=[out2f[i].split()[0],"  ",out2f[i].split()[1],"\n"]
        out2.writelines(out_list)



#gp.c("f(x)=a*x+b")
#gp.c("fit f(x) 'out2' using 1:2 via a,b")
#gp.c("print a")


