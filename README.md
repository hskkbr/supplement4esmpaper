# Supplemental materials for the paper of ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''

These supplemental materials contain the minimum inputs of ecalj for the calculation
shown in the main text of the paper ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''.
Samples here are for five ionic crystals LiF, MgO, NaCl, KF and CaO, where
all of them have NaCl-type crystal structure.


###Fitting in ESM calculation(results in Table I in the paper)

Let us open the ``LiF-ESM'' for example.
We find ``LiF-ESM/gga'' and ``LiF-ESM/qsgw''.
These contains the input files 
to calculates the results shown in Table1 of the main text.

Here we go down int the ``LiF-ESM/qsgw''.
We firstly find ``GWinput'' and ``ctrl.lif''.
These two are essential input files of ecalj (for GGA and QSGW).

The final output is already included in 0.0 and 0.2, 
where the numbers indicates the bias voltage in Rydberg unit of
external electric fields (see the main text).
The files ``charge_pot.dat'' in each directory store
the electrostatic potential expressed in the top panel of Fig. 1 of the main text.
To extract data for fitting expressed in the bottom panel, 
we should type the following on the terminal.
````
python chp.py && gnuplot fit.gnu
````
If we succeeded, we will see following lines:

````
E=  0.00241103317365848
E0=  0.00468083482024795
E/E0=  1.94142281880979
````
where E and E0 are the slopes of the voltage in medium(slab) and vacuum region.
Please check ``fit.eps'' and if the two fitting results are rational (compare with Fig. 1 of the main text).
E/E0 is the same results as the 1.94 for the slab calculation in QSGW shown in Table I of the main text.

###How to re-perform the first-principles calcuations

In the following, we explain how to make the final output ``charge_pot.dat''.

First of all, copy these two files by typing as follows:
````
cp GWinput *
cp ctrl.lif *
````

After that, we should perform slab calculation in GGA(LDA) level.
For example, we 
````
$EXEPATH/lmfa  lif  >llmfa
mpirun -n 36 $EXEPATH/lmf-MPIK  lif  >llmf
````
where the $EXEPATH indicates ``bin'' directory generated in the installation of ecalj.
Here ``lif'' is the suffix indicating the ctrl files(see ecaljmanual for more details).


Optionally, we may save the density of states (DOS) in GGA(LDA) level for this moment.
````
$EXEPATH/job_tdos lif -np 36  >llmf_tdos
````
And then it is safer to save the GGA(LDA) results in case of re-calculations.
``
mkdir GGA
cp *dos* GGA
cp llmf* GGA
cp charge_pot.dat GGA
``




