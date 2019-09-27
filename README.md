# Supplemental materials for the paper of ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''

These supplemental materials contain the minimum inputs of ecalj for the calculation
shown in the main text of the paper ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''.
Samples here are for five ionic crystals LiF, MgO, NaCl, KF and CaO, where
all of them have NaCl-type crystal structure.


###Fitting in ESM calculation(results in Table I in the paper)

Let us open the ``LiF-ESM`` for example.
We find ``LiF-ESM/gga`` and ``LiF-ESM/qsgw``.
These contains the input files 
to calculates the results shown in Table1 of the main text.

Here we go down int the ``LiF-ESM/qsgw``.
We firstly find ``GWinput`` and ``ctrl.lif``.
Although these two are essential for performing calculations in ecalj (both for GGA and QSGW),
here we skip these two files,
noticing just only that ``ctrl.lif`` here is the case for 9-layers of slab(see the line 40-57).


The outputs we need here are ``0.0/charge_pot.dat`` and ``0.2/charge_pot.dat``.
These two are final results of the QSGW+ESM calculation for LiF slab.
Numbers 0.0 and 0.2 indicate the bias voltage of
external electric fields in Rydberg unit (see the main text).
These two contain
the electrostatic potential expressed in the top panel of Fig. 1 of the main text.
To extract data for fitting expressed in the bottom panel, 
let us type the following on the terminal.
````
python chp.py && gnuplot fit.gnu
````
If we succeeded, we will see following lines at the bottom of the console:
````
slope in slab region   = 0.00241103317365848
slope in vacuum region = 0.00468083482024795
dielectric constant    = 1.94142281880979
````
The dielectric constant 1.94 is the same results for the slab calculation in QSGW shown in Table I of the main text.
Please check ``fit.eps`` and if the two fitting results are rational (compare with Fig. 1 of the main text).


###How to re-perform the first-principles calculations

In the following, we explain how to make the final output ``charge_pot.dat``.

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
where the $EXEPATH indicates ``bin`` directory generated in the installation of ecalj.
Here ``lif`` is the suffix indicating the ctrl files(see ecaljmanual for more details).


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




