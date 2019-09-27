# Calculation details of ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''

Above files contain the minimum inputs of ecalj for the calculation
shown in the main text of the paper 
``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''.
Inputs are for five NaCl-type ionic crystals LiF, MgO, NaCl, KF, and CaO.
We use nine-layer slabs for GGA and QSGW calculations.


###Dielectric constant from the results of ESM calculation

Here we explain how to calculate dielectric constants in slab model.

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


###How to perform the slab calculation for obtaining charge_pot.dat

In the following, we explain how to obtain the file of ``charge_pot.dat``.

First of all, copy these two files by typing as follows:
````
cp GWinput *
cp ctrl.lif *
````

After that, we can perform slab calculation in GGA(LDA) level.
For example, we can type as followings for initialization and main calculations,
````
$EXEPATH/lmfa  lif  >llmfa
mpirun -n 36 $EXEPATH/lmf-MPIK  lif  >llmf
````
, where the $EXEPATH indicates ``bin`` directory generated in the installation of ecalj
and 36 is the number of MPI cores.
Here ``lif`` is the suffix indicating the ctrl files(see ecaljmanual for more details).

Optionally, we may calculate and save the density of states (DOS) in GGA(LDA) level for this moment.
````
$EXEPATH/job_tdos lif -np 36  >llmf_tdos
````
And then it is safer to save the GGA(LDA) results in case of re-calculations.
````
mkdir GGA
cp *dos* GGA
cp llmf* GGA
cp charge_pot.dat GGA
````

After the convergence of GGA calculations, we can perform QSGW calculations.
Please check if the GWinput file is in the working directory.
The we can type as below:
````
$EXEPATH/gwsc 5 -np 12  lif  >lqsgw
$EXEPATH/eps_lmfh -np 36  lif  > leps_lmfh
````
Then we obtain the ``charge_pot.dat`` file if the calculation ran successfully.
Optionally, we can calculate DOS for QSGW in the same way for GGA(LDA) calculations.

###How to perform bulk calculations

Let us explain the bulk calculations, of which results are shown in Table 2 of the main text.

Go down from the top directory to ``LiF-bulk``, for example.
Then we see
````
gga-band
gga-eps
qsgw-band
qsgw-eps
qsgw80-band
qsgw80nsc-band
````

###How to display the results of RPA calculations

Let us explain how to perform RPA for bulk systems.
Firstly, go down to ``LiF-bulk/qsgw-eps``.
Then we can find EPS00*.dat and EPS00*.nlfc.dat files,
where the formers are for the case with local-field corrections
and the latters are for the case without local-field corrections.
The we can type 
````
./eps.sh
````
and then we can see 
````
E(infty)= 1.67126801245751
E(infty,no-LFC)= 1.72891260859192
````
in the bottom two lines of the console.
These two results are the same with the results for LiF shown in Table I of the main text.
As for the GGA calculation, we can see in the ``LiF-bulk/gga-eps``.


###How to perform RPA calculation for bulk systems
