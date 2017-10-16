function RT = poseVectorToTransformationMatrix(pose)
% RT = poseVectorToTransformationMatrix(pose);
% converts pose vector to homogeneous transformation matrix [R|T]
% Input:
%   pose    [w_x, w_y, w_z, t_x, t_y, t_z] (1x6 or 6x1 vector)
% Output:
%   RT      3x4 matrix
% Samuel Nyffenegger, 09.10.17

%% calculations
r = pose(1:3);
theta = norm(r);
axis = r/norm(r);
R = vrrotvec2mat([axis, theta]);
T = pose(4:6); T = T(:);
RT = [R,T];

end

