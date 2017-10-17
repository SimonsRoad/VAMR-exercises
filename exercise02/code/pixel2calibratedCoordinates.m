function p_c = pixel2calibratedCoordinates(p_p, K)
% p_c = pixel2calibratedCoordinates(p_p, K);
% converts from pixel to calibrated (normalized) coordinates
% Input: 
%   p_p     coordinates in pixel coordinates of n points p_p = [x1, y2; ...; xn, yn]
%   K       Camera matrix
% Output:
%   p_c     coordinates in calibrated coordinates of n points p_c = [x1, y2; ...; xn, yn]
% Samuel Nyffenegger, 16.10.17

%% calculations

% prepare size of p_c
p_c = zeros(size(p_p)); 

% loop over reference points
for i = 1:param.n_reference_points
    % get homogeneous representation
    pi_p = [p_p(2*i-1:2*i)';1]; 
    
    % apply transformation
    pi_c = K\pi_p;
    
    % update 
    p_c(2*i-1:2*i) = [pi_c(1)/pi_c(3), pi_c(2)/pi_c(3)];
end


end