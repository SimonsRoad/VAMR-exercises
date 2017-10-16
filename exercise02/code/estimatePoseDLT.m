function M = estimatePoseDLT(p, P, K)
% M = estimatePoseDLT(p, P, K);
% estimates the pose (hence [R|t]) of the camera with given K
% Input:
%   p       calibrated (normalized) coordinates, p = [xi; yi; 1]
%   P       corner coordinates in world frame, P = [x1, y1, z1 ; ... ; xn, yn, zn] 
%   K       Camera matrix
% Output:
%   M       homog. transformation, "camera pose", M = [R|t] 
% Samuel Nyffenegger, 16.10.17

%% calculations


end