function patch = getWarpedPatch(I, W, x_T, r_T)
% patch = getWarpedPatch(I, W, x_T, r_T);
% x_T is 1x2 and contains [x_T y_T] as defined in the statement. patch is
% (2*r_T+1)x(2*r_T+1) and arranged consistently with the input image I.
% Input:
%   I, image
%   W, 2x3 affine transformation matrix
%   x_T, 1x2 patch translation (x,y)
%   r_T, scalar, patch radius
% Output:
%   patch, s_T x s_T patch, s_T = 2*r_T+1

%% calculations
clc

try
    I = I_R;
    W = getSimWarp(0, 0, 0, 1);
catch
end

[height, width] = size(I);
s_T = 2*r_T+1; 
patch = zeros(s_T, s_T);

for y = -r_T:r_T
    for x = -r_T:r_T
        % dp: difference coordinate arround patch center
        dp = floor( W*[x;y;1] ); % TODO: bilinear interpolation 
        
        % update patch if inside
        if 1 <= dp(2)+x_T(2) && dp(2)+x_T(2) <= height && ...
           1 <= dp(1)+x_T(1) && dp(1)+x_T(1) <= width
            patch(y+r_T+1,x+r_T+1) = I(x_T(2)+dp(2),x_T(1)+dp(1)); 
        end
    end
end

% dummy assignement
if ~exist('patch','var'); patch = zeros(2*r_T+1,2*r_T+1); end

end