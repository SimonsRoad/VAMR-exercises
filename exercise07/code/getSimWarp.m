function W = getSimWarp(dx, dy, alpha_deg, lambda)
% W = getSimWarp(dx, dy, alpha_deg, lambda);
% gives affine transformation matrix
% Input:
%   dx, translation in x direction
%   dy, translation in y direction
%   alpha, degrees, rotaion arrount positive z-axis
%   lambda, scaling 
% Output:
%   W, 2x3 affine transformation matrix

%% calculations

W = [lambda.*[cos(deg2rad(alpha_deg)), - sin(deg2rad(alpha_deg)) ; ...
    sin(deg2rad(alpha_deg)), cos(deg2rad(alpha_deg))], [dx; dy]];

end
