function [dx, ssds] = trackBruteForce(I_R, I, x_T, r_T, r_D)
% I_R: reference image, I: image to track point in, x_T: point to track,
% expressed as [x y]=[col row], r_T: radius of patch to track, r_D: radius
% of patch to search dx within; dx: translation that best explains where
% x_T is in image I, ssds: SSDs for all values of dx within the patch
% defined by center x_T and radius r_D.
% Input:
%   I_R, reference image
%   I, warped image (where to search) 
%   x_T, 1x2, point to track (centre of patch)
%   r_T, scalar, patch radius
%   r_D, scalar, search radius
% Output:
%   dx, 2x1, best guess of translation
%   ssds, s_D x s_D, errors, s_D = 2*r_D+1

%% calculations

% init 
s_D = 2*r_D+1;
ssds = zeros(s_D,s_D); 
W0 = getSimWarp(0, 0, 0, 1);
template = getWarpedPatch(I_R, W0, x_T, r_T);
        
% loop through all guesses
search_area = -r_D:r_D; 
for y = search_area
    for x = search_area
        W = getSimWarp(x, y, 0, 1); % translation recovery only
        patch = getWarpedPatch(I, W, x_T, r_T);
        
        diff = patch(:) - template(:);
        ssd = sum(diff.^2);
        
        ssds(x+r_D+1,y+r_D+1) = ssd; 
        
    end
end

% get best guess for displacement (and thus W)
[~, idx] = min(ssds(:));
[idx_row,idx_col] = ind2sub(size(ssds),idx);
dx = [search_area(idx_col), search_area(idx_row)]; 

end