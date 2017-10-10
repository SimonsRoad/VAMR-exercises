function  points = projectPoints(Pw, K, RT)
% points = projectPoints(Pw, K, RT);
% projects points in world coordinate Pw frame to image (u,v)
% Input:
%   Pw      Points in world frame Pw = [x1,y1,z1; x2,y2,z2; ...]
%   K       Camera matrix
%   RT      transformation
% Output:
%   points  discretized pixel coordinates, points = [u1, v1; u2, v2; ...]
% Samuel Nyffenegger, 09.10.17
    
%%  calculations
N = size(Pw,1); 
points = zeros(N,2);

% loop over points
for i = 1:N
    % get single point in homogeneous coordinates
    point_tilde = [Pw(i,:)';1];

    % perspective projection
    p_tilde = K*RT*point_tilde; 
    u = p_tilde(1)/p_tilde(3);
    v = p_tilde(2)/p_tilde(3);
    
    % update
    points(i,:) = [u, v];
end

end

