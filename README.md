# LC-MS Peak Picker (XCMS CentWave)

Galaxy wrapper for the Bioconductor XCMS CentWave algorithm. Performs peak detection on raw `.mzML` and `.mzXML` files without requiring users to write R code.

[![Launch Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/hardiksood21/lc_ms_peak_picker/HEAD?filepath=lc_ms_peak_picker_demo.ipynb)

## Galaxy Tool Shed
https://toolshed.g2.bx.psu.edu/view/hardiksood21/lc_ms_peak_picker

## IUC Review
https://github.com/galaxyproject/tools-iuc/issues/8110

## UseGalaxy.* Installation Request
https://github.com/galaxyproject/usegalaxy-tools/issues/1539

## Dependencies
- `r-base`
- `bioconductor-msnbase`
- `bioconductor-xcms`

All dependencies are available via Bioconda.

## Live Demo
Click the **"Launch Binder"** badge above to run an interactive Jupyter notebook demonstrating the peak detection algorithm on real LC-MS data.

## Inputs
- Raw LC-MS files (`.mzML`, `.mzXML`)
- CentWave parameters (ppm, peakwidth, snthresh, etc.)

## Outputs
- Peak list with m/z, retention time, and intensity values

## Citation
If you use this tool, please cite the XCMS package:  
Smith, C.A. et al. (2006). XCMS: Processing Mass Spectrometry Data for Metabolite Profiling. *Analytical Chemistry*, 78(3), 779–787.
