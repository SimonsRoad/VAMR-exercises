function  img_u = undistort_image(img_d, D)
% img_u = undistort_image(img_d, D);
% undistorts an image
% Input:
%   img_d   distorted image
%   D       distortion model, two parameters
% Output:
%   img_u   undistorted image
% Samuel Nyffenegger, 10.10.17
    
%%  calculations

% loop over points
for i = 1:N

    % 
    pc = #
    
    % map into image plane with normalized coordinates
    p = [p_c(1)/p_c(3); p_c(2)/p_c(3)];

    % apply lens distortion
    r = sqrt(p(1).^2 + p(2).^2);
    p_d = (1 + D(1)*r.^2 + D(2)*r.^4) * p; 
    p_d_tilde = [p_d;1];
    p_tilde = K*p_d_tilde; 

    % get discretized pixel coordinates 
    u = p_tilde(1)/p_tilde(3);
    v = p_tilde(2)/p_tilde(3);

    % update
    points(i,:) = [u, v];
end




end

