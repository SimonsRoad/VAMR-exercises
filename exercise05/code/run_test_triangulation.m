clear all % clear all variables in the workspace
close all % close all figures
clc       % clear the command window

addpath('8point/');
addpath('triangulation/');
addpath('plot/');
addpath('utilities/');

rng(42);

%% Test linear triangulation
clc
N = 10;         % Number of 3-D points
P = randn(4,N);  % Homogeneous coordinates of 3-D points
P(3, :) = P(3, :) * 5 + 10;
P(4, :) = 1;

M1 =   [500 0 320 0
        0 500 240 0
        0 0 1 0];

M2 =   [500 0 320 -100
        0 500 240 0
        0 0 1 0];
				
p1 = M1 * P;     % Image (i.e., projected) points
p2 = M2 * P;

P_est = linearTriangulation(p1,p2,M1,M2);

err = P_est-P;

% print infos
fprintf('SN:Info: ')
if max(max(err)) < 1e-10
    cprintf([0,0.5,0],'triangulation was successful\n')
else
    cprintf([0.9,0,0],'triangulation failed\n')
end
