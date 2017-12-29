% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly executed under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 3497.673830523122888 ; 3436.600461727959555 ];

%-- Principal point:
cc = [ 2092.390680264923049 ; 1314.419670867956256 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.041670623254021 ; 0.321102525084805 ; 0.004501528746101 ; 0.006577787021434 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 87.058490892822562 ; 73.094265149490710 ];

%-- Principal point uncertainty:
cc_error = [ 38.392704322088107 ; 83.688024198294116 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.032852829217688 ; 0.133310052781285 ; 0.004862254497602 ; 0.004355019456175 ; 0.000000000000000 ];

%-- Image size:
nx = 3968;
ny = 2976;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 8;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ 2.043817e+00 ; 1.319294e+00 ; -3.753477e-01 ];
Tc_1  = [ -1.368322e+02 ; -4.569724e+01 ; 4.368397e+02 ];
omc_error_1 = [ 1.669892e-02 ; 1.130364e-02 ; 1.608729e-02 ];
Tc_error_1  = [ 4.831074e+00 ; 1.054052e+01 ; 1.084666e+01 ];

%-- Image #2:
omc_2 = [ 1.935918e+00 ; 2.150809e+00 ; -4.144512e-01 ];
Tc_2  = [ 2.147294e+01 ; -8.695907e+01 ; 5.448013e+02 ];
omc_error_2 = [ 1.088522e-02 ; 1.170967e-02 ; 2.215639e-02 ];
Tc_error_2  = [ 6.041827e+00 ; 1.287891e+01 ; 1.357429e+01 ];

%-- Image #3:
omc_3 = [ 2.050694e+00 ; 1.886486e+00 ; -3.026216e-01 ];
Tc_3  = [ -2.276900e+02 ; -7.309237e+01 ; 5.502260e+02 ];
omc_error_3 = [ 1.102063e-02 ; 1.260239e-02 ; 2.087465e-02 ];
Tc_error_3  = [ 6.148367e+00 ; 1.328089e+01 ; 1.391475e+01 ];

%-- Image #4:
omc_4 = [ 2.057182e+00 ; 2.096233e+00 ; -2.758279e-01 ];
Tc_4  = [ -7.085525e+01 ; -1.534776e+02 ; 5.437744e+02 ];
omc_error_4 = [ 1.059524e-02 ; 1.246335e-02 ; 2.278746e-02 ];
Tc_error_4  = [ 6.105070e+00 ; 1.264435e+01 ; 1.367497e+01 ];

%-- Image #5:
omc_5 = [ 1.963283e+00 ; 2.002202e+00 ; -4.142262e-01 ];
Tc_5  = [ -6.984742e+01 ; -3.452707e+01 ; 5.655779e+02 ];
omc_error_5 = [ 1.093021e-02 ; 1.173779e-02 ; 1.993929e-02 ];
Tc_error_5  = [ 6.204855e+00 ; 1.363044e+01 ; 1.399617e+01 ];

%-- Image #6:
omc_6 = [ 1.468676e+00 ; 2.342658e+00 ; -2.773576e-01 ];
Tc_6  = [ -1.545133e+01 ; -8.873138e+01 ; 5.709216e+02 ];
omc_error_6 = [ 1.114054e-02 ; 1.330454e-02 ; 1.988059e-02 ];
Tc_error_6  = [ 6.266906e+00 ; 1.357617e+01 ; 1.413829e+01 ];

%-- Image #7:
omc_7 = [ 9.126989e-01 ; 2.498472e+00 ; -1.247841e-01 ];
Tc_7  = [ 7.692342e-01 ; -9.969282e+01 ; 5.744659e+02 ];
omc_error_7 = [ 1.170236e-02 ; 1.527853e-02 ; 2.125725e-02 ];
Tc_error_7  = [ 6.312567e+00 ; 1.379448e+01 ; 1.411299e+01 ];

%-- Image #8:
omc_8 = [ 2.140535e+00 ; 1.888636e+00 ; -1.312248e-01 ];
Tc_8  = [ -1.184585e+02 ; -7.216227e+01 ; 4.534685e+02 ];
omc_error_8 = [ 1.151652e-02 ; 9.901791e-03 ; 1.920354e-02 ];
Tc_error_8  = [ 5.027933e+00 ; 1.086234e+01 ; 1.123303e+01 ];

%% Sam
K = [fc(1),0,cc(1); 0,fc(2),cc(2); 0,0,1]
