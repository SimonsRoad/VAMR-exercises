% TODOs:
%   - can be implemented using only one for loop

function [points, intensities] = disparityToPointCloud(...
    disp_img, K, baseline, left_img)
% points should be 3xN and intensities 1xN, where N is the amount of pixels
% which have a valid disparity. I.e., only return points and intensities
% for pixels of left_img which have a valid disparity estimate! The i-th
% intensity should correspond to the i-th point.

%% calculations
clc

% init
[H, W] = size(left_img); 

points = []; intensities = [];
b = [baseline; 0; 0]; 

parfor h = 1:H
    for w = 1:W
        d = disp_img(h,w);
        
        if d > 0  
            % point cloud triangulation using least squares
            p0 = [w; h];
            p1 = [w-d; h];
            A = K^-1*[p0 -p1; 1 -1]; 
            lambda = A\b; % overdeterimed
            P = lambda(1) * K^-1*[p0; 1];

            % update
            points = [points, [P(1);P(2);P(3)]];
            intensities = [intensities, left_img(h,w)]; 
        end
    end
end


end