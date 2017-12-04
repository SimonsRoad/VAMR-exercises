function I1 = warpImage(I0, W)
% I1 = warpImage(I0, W); 
% warps image with given affine warping matrix
% Input:
%   I0, original image
%   W, 2x3 affine transformation matrix
% Output:
%   I1, size(I_R), warped image (floor integer values)

%% calculations

[height, width] = size(I0);
I1 = zeros(size(I0));

for y = 1:height
    for x = 1:width
        p = floor( W*[x; y; 1] ); % TODO: bilinear interpolation
        if 1 <= p(2) && p(2) <= height && 1 <= p(1) && p(1) <= width
            I1(y,x) = I0(p(2),p(1));
        end       
    end
end

end