# QSMART: Quantitative Susceptibility Mapping Artifact Reduction Technique

QSMART reconstructs tissue bulk magnetic susceptibility from complex MRI images. 

## Installing QSMART

1. Download QSMART [repository](https://github.com/wtsyeda/QSMART.git) 
2. To install QSMART, a number of dependencies need to be available on your system, as listed below. These depedencies can be added to the MATLAB path or placed directly in the folder *'QSMART_toolbox_v1.0'*.

Required dependencies:
1. [Frangi filter](https://au.mathworks.com/matlabcentral/fileexchange/24409-hessian-based-frangi-vesselness-filter) 
2. [STI suite v2.2](https://people.eecs.berkeley.edu/~chunlei.liu/software.html)
3. Code for [phase unwrapping](https://github.com/sunhongfu/QSM/tree/master/phase_unwrapping)
4. [Nifti tools](https://au.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image)

## Usage



![Overview of QSMART pipeline](/images/QSMART_schematic.png)

## References

**QSMART Reference:** Yaghmaie, N., W. Syeda, C. Wu, Y. Zhang, T. Zhang, E.L. Burrows, B.A. Moffat, D.K. Wright, R. Glarin, S. Kolbe, L.A. Johnston, QSMART: Quantitative Susceptibility Mapping Artifact Reduction Technique, 2020.

QSMART uses helper codes from following references:

Dirk-Jan Kroon (2020). Hessian based Frangi Vesselness filter (https://www.mathworks.com/matlabcentral/fileexchange/24409-hessian-based-frangi-vesselness-filter), MATLAB Central File Exchange. Retrieved September 6, 2020.
H. Sun, J.O. Cleary, R. Glarin, S.C. Kolbe, R.J. Ordidge, B.A. Moffat, G.B. Pike; Extracting more for less: Multi-echo MP2RAGE for simultaneous T1-weighted imaging, T1 mapping, R2* mapping, SWI, and QSM from a single acquisition.

 Markup : * Bullet list
              * Nested bullet
                  * Sub-nested bullet etc
          * Bullet list item 2








