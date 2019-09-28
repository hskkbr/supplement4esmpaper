# Calculation details of ``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method'' #

Above files contain the minimum inputs of ecalj for the calculation
shown in the paper 
``A finite electric-field approach to evaluate the vertex correction for the screened Coulomb interaction in the quasiparticle self-consistent GW method''.
Inputs are for five NaCl-type ionic crystals LiF, MgO, NaCl, KF, and CaO.
We use nine-layer slabs for GGA and QSGW calculations.

Convergence check of the calculations
---------------------------------

For the convergence, see the file ``conv_esmgw.pdf`` listed on the above.


Dielectric constant from the results of ESM calculation
---------------------------------

Here we explain how to calculate dielectric constants in slab model.

Let us open the ``LiF-ESM`` for example.
We find ``LiF-ESM/gga`` and ``LiF-ESM/qsgw``.
These contains the input files 
to calculates the results shown in Table1 of the main text.

Here we go down to the ``LiF-ESM/qsgw``.
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
The dielectric constant 1.94 is the same result for the slab calculation in QSGW shown in Table I.
Please check ``fit.eps`` and if the two fitting results are rational (compare with Fig. 1 of the main text).


How to perform the slab calculation for obtaining charge_pot.dat
---------------------------------

In the following, we explain how to obtain the file of ``charge_pot.dat``.

Please use restart-files ``0.0/rst.lif`` and ``0.0/sigm.lif`` if you know how to use them.
The directory 0.2 also contains rst and sigm files.

If you do not know, you should perform GGA(LDA) and QSGW calculations.
First of all, copy these two files and go down to 0.0 directory by typing as follows:
````
cp GWinput 0.0
cp ctrl.lif 0.0
cd 0.0
````

After that, we can perform slab calculation in GGA(LDA) level.
For example, we can type as followings for initialization and main calculations,
````
$EXEPATH/lmfa  lif  >llmfa
mpirun -np 36 $EXEPATH/lmf-MPIK  lif  >llmf
````
, where the $EXEPATH indicates ``bin`` directory generated in the installation of ecalj
and 36 is the number of MPI cores.
Here ``lif`` is the suffix indicating the ctrl files(see ecaljmanual for more details).

Optionally, we may calculate and save the density of states (DOS) in GGA(LDA) level for this moment.
````
$EXEPATH/job_tdos lif -np 36  >llmf_tdos
````
And then it is safer to save the all results of GGA(LDA) in case of re-calculations.
````
mkdir GGA
cp *dos* GGA
cp llmf* GGA
cp charge_pot.dat GGA
````

After the convergence of GGA calculations, we can perform QSGW calculations.
Please check if the GWinput file is in the working directory.
Then we can type
````
$EXEPATH/gwsc 5 -np 12  lif  >lqsgw
````
for the self-consistent calculation in QSGW, where we perform for five iterations.
After the calculation, we can type,
````
$EXEPATH/eps_lmfh -np 36  lif  > leps_lmfh
````
, to obtain the ``charge_pot.dat``
(optionally, we can calculate DOS for QSGW in the same way for GGA(LDA) calculations).

We should also perform the same calculation in directory ``0.2``.
The difference between  ``0.0`` and ``0.2`` is in the left side of the line 4 of the ``esm_input.dat``.
We can change the bias voltage by changing the line 4.


How to perform bulk calculations
---------------------------------

Let us explain the bulk calculations, of which results are shown in Table 2 of the main text.

Firstly, go down from the top directory to ``LiF-bulk``, for example.
Then we see,
````
gga-band
gga-eps
qsgw-band
qsgw-eps
qsgw80-band
qsgw80nsc-band
````
, where *-eps are for the RPA calculation of dielectric constant (results are shown in Table 1 of the paper)
and *-band are for the calculation of band gaps (results are shown in Table 2 of the paper).
gga-*, qsgw-*, qsgw80-*, qsgw80nsc-* are for the QSGW calculations and 

How to display the results of RPA calculations
---------------------------------

Let us explain how to perform RPA for bulk systems (in *-eps directory).
Firstly, go down to ``LiF-bulk/qsgw-eps``.
Then we can find EPS00*.dat and EPS00*.nlfc.dat files,
where the formers are for the case with local-field corrections
and the latters are for the case without local-field corrections.
We can type 
````
./eps.sh
````
and then we can see 
````
E(infty)= 1.67126801245751
E(infty,no-LFC)= 1.72891260859192
````
in the bottom two lines of the console.
E(infty) and E(infty,no-LFC) are the dielectric constants with and without local-field correction, respectively.
These two results are the same with the results for LiF shown in Table I of the main text.
As for the GGA calculation, we can see in the ``LiF-bulk/gga-eps``.

Note that we obtain the dielectric constants at q=0 by linear extrapolation 
from finite values of |q|.
Please check the file ``fit-bulk.eps`` and  ``fit-nlfc.eps`` generated by eps.sh.
In the two figures, the x-axis(y-axis) indicates q-vector(dielectric constant epsilon).
We obtain the value of dielectric constant from the y-intercept 
of the fitting line of q-epsilon curve.
We can specify the finite q-vectors in the GWinput as explained later.


How to perform RPA calculation for bulk systems
---------------------------------

Let us explain how to obtain the EPS00*.dat files.
At first, we perform self-consistent calculations in GGA(LDA) and/or QSGW.
Then we can perform 
````
$EXEPATH/eps_lmfh -np 36  lif  > leps_lmfh
````
in the same manner with slab calculations.

Note that we can change the number of q-points(n1n2n3) in GWinput 
between the self-consistent calculations and ``eps_lmfh``.
For example, we perform QSGW taking 8*8*8 q-points and 
perform `eps_lmfh`` taking 20*20*20 q-points in the paper.


We can chose the finite q-vector at which we calculate dielectric constant.
For example, we can write the following lines in GWinput:
````
<QforEPS>
 0d0 0d0 0.005d0
 0d0 0d0 0.01d0
 0d0 0d0 0.0125d0
 0d0 0d0 0.015d0
 0d0 0d0 0.0175d0
 0d0 0d0 0.02d0
 0d0 0d0 0.025d0
 0d0 0d0 0.03d0
 0d0 0d0 0.035d0
 0d0 0d0 0.04d0
 0d0 0d0 0.05d0
</QforEPS>
````
Then we can use these 11 points to extrapolate the dielectric constant at q=0.
Usually, we ignore the values at small q-vector at which non-linearity is obvious.

How to estimate the band gap from output files
---------------------------------

Let us explain how to calculate the band gaps shown in Table 2
 (for bulk systems, see *-band directory).
 
 The directories ``gga-band``, ``qsgw-band``, ``qsgw80-band``, and ``qsgw80nsc-band``
 are for the GGA, QSGW, QSGW80 with local-field correction
 and QSGW80 without correction, respectively (for QSGW80, see the main text). 
 
 For example, go down to the ``LiF-bulk/qsgw80-band`` directory.
 Firstly, type 
 ````
 gnuplot bandplot.isp1.glt 
 ````
 then we can see the band structure along symmetric lines.
 
To obtain the explicit values of band gap, please open the file ``bnd001.spin1``.
 The energy eigenvalues are written 
 in the third column in eV unit.
By finding the lowest unoccupied state (larger than 0.000)
and the highest occupied state (smaller than 0.000),
we can obtain the value of the band gap.
For example, we can see the following in ``LiF-bulk/qsgw80-band/bnd001.spin1``,
```` 
 80|    5   0.86602540    -0.0000000663     0.0000000000   0.00000  0.00000  0.00000
 81|
 82|    6   0.00000000    16.1650617140     0.0000000000   0.50000  0.50000  0.50000
 83|    6   0.06185896    16.1715188710     0.0156421512   0.46429  0.46429  0.46429
 84|    6   0.12371791    16.1868538452     0.0201049505   0.42857  0.42857  0.42857
 85|    6   0.18557687    16.1995284276     0.0303383616   0.39286  0.39286  0.39286
 86|    6   0.24743583    16.2291202540    -0.0148518386   0.35714  0.35714  0.35714
 87|    6   0.30929479    16.1788373340    -0.1127713211   0.32143  0.32143  0.32143
 88|    6   0.37115374    16.0720109538    -0.1981411116   0.28571  0.28571  0.28571
 89|    6   0.43301270    15.9027936462    -0.2826858843   0.25000  0.25000  0.25000
 90|    6   0.49487166    15.6781822660    -0.3482546803   0.21429  0.21429  0.21429
 91|    6   0.55673062    15.4176166656    -0.3799594825   0.17857  0.17857  0.17857
 92|    6   0.61858957    15.1488351965    -0.3703099399   0.14286  0.14286  0.14286
 93|    6   0.68044853    14.9017130219    -0.3198944720   0.10714  0.10714  0.10714
 94|    6   0.74230749    14.7031687265    -0.2348073666   0.07143  0.07143  0.07143
 95|    6   0.80416645    14.5745871122    -0.1242412497   0.03571  0.03571  0.03571
 96|    6   0.86602540    14.5300798987     0.0000000000   0.00000  0.00000  0.00000
````
, thus we can obtain the value as the  direct gap at q=(0,0,0)
as 14.53-0.00=14.53, same as the 4th column in Table 2 of the main text.
The all values in Table 2 are direct gap at q=(0,0,0) except in the case of CaO.

The QSGW80 is performed by changing the parameter ``ssig`` in ctrl files (for more details, see ecaljmanual).
 
 Note that the files ``bnd00*.spin1`` are obtained by performing the self-consistent 
 calculations and 
 ````
 job_band lif -np 4 > ljob
 ````
, which requires syml.* files (for more informations about ``job_band``, see ecaljmanual). 
 


