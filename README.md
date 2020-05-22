# pulsefilter-for-COMSOL
A MATLAB function to post-process frequency-domain COMSOL simulation results for optical pulse shaping. 

This function takes an input pulse electric field waveform, and produces the electric field waveform, the envelope, the frequency vector, and the frequency-domain complex electric field, after enhancement induced by a nanostructure simulated in COMSOL. 

## Prerequisites
* Numerical computing environment: [MATLAB](https://www.mathworks.com/products/matlab.html)
* A data file with wavelength (or frequency) dependent complex field enhancement values, exported from [COMSOL](https://www.comsol.com/) frequency-domain simulation

## Function, inputs, and outputs
```
function [Etenhance Atenhance f Efenhanceshift] = pulsefilter(t, E, FEname)
```
### Inputs
* `t`: time vector of the input pulse (requires uniform spacing)

* `E`: input pulse electric field waveform

* `FEname`: filename of field enhancement .csv file exported from COMSOL frequency-domain simulation. The file format is preassumed as the defualt .csv file format by exporting a table from COMSOL

### Outputs
* `Etenhance`: output pulse electric field waveform after field enhancement

* `Atenhance`: output pulse envelope  

* `f`: frequency vector for frequency domain response

* `Efenhanceshift`: complex electric field in frequency domain (to get the correct spectral phase, the time domain waveform is shifted, so that time t = 0 corresponds to the envelope peak and is at the start of the time vector)

## Example
The script `example_wire_x.m` provides an example showing how to use `pulsefilter` function.

The auxiliary function `cos2pulse` produces the electric field and intensity envelope (each normalized to peak of 1) of a cos<sup>2</sup>-shaped pulse.

The script calculates enhanced waveforms from frequency-domain COMSOL simulation results. This example compares the effect of 5 different nanostructures modeled in COMSOL. The frequency-domain responses simulated in COMSOL are contained in the data files: `ET016aDose8ArrayC_wire_x200_normalE.csv`, `ET016aDose8ArrayC_wire_x120_normalE.csv`, `ET016aDose8ArrayC_wire_x50_normalE.csv`, `ET016aDose8ArrayC_wire_vacuum_normalE`, and `ET016aDose8ArrayC_nowire_normalE`.

The resulting figures plot enhanced electric field waveforms, spectra of the waveforms, and spectral phases of the waveforms.

## How to cite
Please cite the following papers in any published work for which you used this function or a modified version of it.

(1) 	Yang, Y.; Turchetti, M.; Vasireddy, P.; Putnam, W. P.; Karnbach,
O.; Nardi, A.; Kärtner, F. X.; Berggren, K. K.; Keathley, P. D. Light
Phase Detection with On-Chip Petahertz Electronic Networks.
[arXiv:1912.07130](https://arxiv.org/abs/1912.07130) [physics] 2019.

(2) 	Keathley, P. D.; Putnam, W. P.; Vasireddy, P.; Hobbs, R. G.; Yang,
Y.; Berggren, K. K.; Kärtner, F. X. Vanishing
Carrier-Envelope-Phase-Sensitive Response in Optical-Field Photoemission
from Plasmonic Nanoantennas. Nature Physics 2019, 15 (11), 1128–1133.
https://doi.org/10.1038/s41567-019-0613-6.

(3) 	Putnam, W. P.; Hobbs, R. G.; Keathley, P. D.; Berggren, K. K.;
Kärtner, F. X. Optical-Field-Controlled Photoemission from Plasmonic
Nanoparticles. Nature Physics 2017, 13 (4), 335–339.
https://doi.org/10.1038/nphys3978.

