![license](https://img.shields.io/github/license/wevbarker/HiGGS)
[![arXiv](https://img.shields.io/badge/arXiv-2206.00658-b31b1b.svg)](https://arxiv.org/abs/2206.00658)
[![arXiv](https://img.shields.io/badge/arXiv-2205.13534-b31b1b.svg)](https://arxiv.org/abs/2205.13534)
[![arXiv](https://img.shields.io/badge/arXiv-2101.02645-b31b1b.svg)](https://arxiv.org/abs/2101.02645)
<!--[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4361667.svg)](https://zenodo.org/badge/latestdoi/291184118)-->
<img src="xAct/HiGGS/Documentation/Examples/peta4.rdm.png" width="1000">

# Hamiltonian Gauge Gravity Surveyor (HiGGS)
## Version 1.2.3

- **Feature:** abstract indices representing gauge-fixed theory given cleaner formatting with Gothic script, extended indices `a1`, `b1`, `c1` etc. denoted by primes.
- **Feature:** provide more intuitive formatting of Poisson brackets in terms of smearing functions, as seen in output of `PoissonBracket` and `ViewTheory`.
- **Patch:** fix shadowing error messages during the `Needs` or `Get` package call preamble.
- **Patch:** fix [Issue #1](https://github.com/wevbarker/HiGGS/issues/1), loading of binaries on Windows.
- **Patch:** fix errors produced by `PoissonBracket` with the option `"Surficial"->True`. This error follows from sign errors in line two of Equation (E3) in [2205.13534](https://arxiv.org/abs/2205.13534), and generates nonphysical surface terms. My particular thanks to [Manuel Hohmann](https://github.com/xenos1984) for identifying this.

## License

Copyright © 2022 Will E. V. Barker

HiGGS is distributed as free software under the [GNU General Public License (GPL)](https://www.gnu.org/licenses/gpl-3.0.en.html).

HiGGS is provided without warranty, or the implied warranty of merchantibility or fitness for a particular purpose.

Users of HiGGS, including authors of derivative works as defined by the GPL, are kindly requested to cite the 2022 HiGGS papers ([2206.00658](https://arxiv.org/abs/2206.00658) and [2205.13534](https://arxiv.org/abs/2205.13534)) in their resulting publications.

These conditions apply to all software in this repository, including "HPC-EEG" visualisation tools.

## About

HiGGS is an (unofficial) part of the [xAct bundle](http://www.xact.es/). It provides tools for the Hamiltonian constraint analysis (canoncical analysis or Dirac-Bergmann algorithm) of gravity with spacetime curvature and torsion. HiGGS can be used on a desktop PC, but it is parallelised for theory surveys on clusters and supercomputers.

## Installation

#### Requirements 
HiGGS has been tested in the following environment(s):
- Linux x86 (64-bit), specifically Manjaro, Arch, CentOS, Scientific Linux and Ubuntu
- Windows 10, as of HiGGS v 1.2.3
- Mathematica v 11.3.0.0
- xAct v 1.2.0
#### Install 
1. Make sure you have [installed xAct](http://www.xact.es/download.html).
2. Download HiGGS:
	```bash, git
	git clone https://github.com/wevbarker/HiGGS
	cd HiGGS
	```
3. Place the `./xAct/HiGGS` directory relative to your xAct install. A global install might have ended up at: 
	```bash
	/usr/share/Mathematica/Applications/xAct
	```
## Quickstart 

The package loads just like any other part of xAct, just open a fresh notebook and run:
```wolfram
Needs["xAct`HiGGS`"];
```
This loads the package (i.e. the names of the functions provided), along with its dependencies in the xAct bundle. However it does _not_ load the physics. To construct the HiGGS environment, one must run:
```wolfram
BuildHiGGS[];
```
The build process may take about a minute or so. When it has concluded, you should be able to proceed to science. For example, try evaluating the Poisson bracket between the spin-parity 2<sup>+</sup> irreducible component of the foliation-projected momentum of the translational gauge field, and the 1<sup>-</sup> irrep of the foliation-projected torsion tensor, without first defining a constraint shell for a particular theory, type:
```wolfram
PoissonBracket[PiPB2p[-a, -b], TP1m[-c], "ToShell" -> False];
```
<img src="xAct/HiGGS/Documentation/Examples/tutor.png" width="1000">

If you want to try something more ambitious, build the constraint structure for Einstein-Cartan theory:
```wolfram
DefTheory[{Alp1 == 0, Alp2 == 0, Alp3 == 0, Alp4 == 0, Alp5 == 0, 
   Alp6 == 0, Bet1 == 0, Bet2 == 0, Bet3 == 0, cAlp1 == 0, cAlp2 == 0,
    cAlp3 == 0, cAlp4 == 0, cAlp5 == 0, cAlp6 == 0, cBet1 == 0, 
   cBet2 == 0, cBet3 == 0}, "Export" -> "EinsteinCartan"];
```
That output is less easy to show.

#### Installation test

More general examples can be found in the notebook `./xAct/HiGGS/Documentation/Examples/tutor.nb`. This notebook also acts as an install test.
1. Move the test files into your working directory, e.g. for a global install: 
	```bash
	cp /usr/share/Mathematica/Applications/xAct/HiGGS/Documentation/Examples/tutor.nb ./
	cp -r /usr/share/Mathematica/Applications/xAct/HiGGS/Documentation/Examples/svy ./
	mkdir ./fig
	```
2. Open Mathematica and run `./tutor.nb` in a notebook front end. Make sure you run all the initialisation cells, from the beginning, to the end.

## What's in the box? 

The HiGGS package has the following structure:

```
xAct
└── HiGGS
    ├── bin
    │   └── build
    │       ├── CanonicalPhiToggle.mx
    │       ├── CDPiPToCDPiPO3.mx
    │       ├── ChiPerpToggle.mx
    │       ├── ChiSingToggle.mx
    │       ├── CompleteO3ProjectionsToggle.mx
    │       ├── GeneralComplementsToggle.mx
    │       ├── NesterFormIfConstraints.mx
    │       ├── NonCanonicalPhiToggle.mx
    │       ├── O13ProjectionsToggle.mx
    │       ├── ProjectionNormalisationsToggle.mx
    │       └── VelocityToggle.mx
    ├── COPYING
    ├── Documentation
    │   ├── Examples
    │   │   ├── appcg.job.m
    │   │   ├── appcg.job.nb
    │   │   ├── appcg.job.sh
    │   │   ├── appcg.plt.py
    │   │   ├── appcg.plt.sh
    │   │   ├── peta4.job.m
    │   │   ├── peta4.job.nb
    │   │   ├── peta4.job.sh
    │   │   ├── peta4.job.slm
    │   │   ├── peta4.plt.py
    │   │   ├── peta4.plt.sh
    │   │   ├── peta4.rdm.png
    │   │   ├── peta4.svy.m
    │   │   ├── peta4.svy.nb
    │   │   ├── svy
    │   │   │   ├── EinsteinCartan.thr.mx
    │   │   │   ├── EinsteinCartan_vel.thr.mx
    │   │   │   ├── simple_spin_1p.thr.mx
    │   │   │   └── simple_spin_1p_vel.thr.mx
    │   │   ├── tutor.nb
    │   │   └── tutor.png
    │   ├── HiGGS.pdf
    │   └── HiGGS_sources.pdf
    ├── HiGGS.m
    ├── HiGGS.nb
    ├── HiGGS_smearing_functions_global.m
    ├── HiGGS_smearing_functions.m
    ├── HiGGS_SO3.m
    ├── HiGGS_SO3.nb
    ├── HiGGS_sources.m
    ├── HiGGS_sources.nb
    ├── HiGGS_variations.m
    └── Kernel
        └── init.wl
```

The license is in `COPYING`.

The file `init.wl` is called when the package is invoked, and points to `HiGGS.m`, a small Wolfram language file and main package file sourced by the notebook `HiGGS.nb`. 

When the HiGGS environment is actually built, `HiGGS.m` is actually running `HiGGS_sources.m` - the larger "physics package" sourced by `HiGGS_source.nb`.

During the course of the build, the binaries `./xAct/HiGGS/bin/build/*.mx` are incorporated; these contain some heavy expressions.

The sub-package `HiGGS_variations.m` incorporates elements of [Cyril Pitrou's](https://github.com/CyrilPitrou) code from [this repository](https://github.com/xAct-contrib/examples).

The files `HiGGS.pdf` and `HiGGS_sources.pdf` are carbon copies of the source notebooks.

The notebook `tutor.nb` contains some more basic examples, and it relies on the `*.thr.mx` files in the `svy` directory.

The Wolfram Language files which refer to smearing functions are patches in version 1.2.2.

#### What are peta4 and appcg? 

The files `./xAct/HiGGS/Documentation/Examples/peta4.*` and `./xAct/HiGGS/Documentation/Examples/appcg.*` refer to the jobs which implement the [HiGGS Commissioning Survey](https://wevbarker.com/higgs.html) and various unit tests. HiGGS does _not_ need these files to function. The names refer to two computing services: 
1. [Peta-4](https://www.hpc.cam.ac.uk/systems/peta-4) is a supercomputer, the CPU component of the heterogeneous [CSD3](https://www.hpc.cam.ac.uk/high-performance-computing) facility belonging to the [University of Cambridge](https://www.cam.ac.uk/).
2. [appcg](https://www.astro.phy.cam.ac.uk/local/computing) is a small, private compute server belonging to the [Cavendish Laboratory Astrophysics Group]().

These sources are included to give inspiration to users who which to perform HPC surveys, though the user's architecture may well differ.

## Contribute

Please do! I'm always responsive to emails (about science), so be sure to reach out at [wb263@cam.ac.uk](mailto:wb263@cam.ac.uk). I will also do my best to get your code working if you are just trying to use HiGGS.

## Acknowledgements

This work was performed using resources provided by the Cambridge Service for Data Driven Discovery (CSD3) operated by the University of Cambridge Research Computing Service ([www.csd3.cam.ac.uk](www.csd3.cam.ac.uk)), provided by Dell EMC and Intel using Tier-2 funding from the Engineering and Physical Sciences Research Council (capital grant EP/T022159/1), and DiRAC funding from the Science and Technology Facilities Council ([www.dirac.ac.uk](www.dirac.ac.uk)).

I am grateful for the kind hospitality of Leiden University and the [Lorentz Institute](https://www.lorentz.leidenuniv.nl/), and am supported by [Girton College, Cambridge](https://www.girton.cam.ac.uk/).
