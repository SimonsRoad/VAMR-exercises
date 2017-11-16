function descriptors = describeKeypoints(img, keypoints, r)
% Returns a (2r+1)^2xN matrix of image patch vectors based on image
% img and a 2xN matrix containing the keypoint coordinates.
% r is the patch "radius".

%% calculations
clc;

try
    % launched inside describeKeypoints
   	r = descriptor_radius;
    num = 1; 
catch
    % launched from main
    num = size(keypoints,2);
end

% init
D = (2*r+1).^2;
K = size(keypoints,2);
descriptors = zeros(D,K);

% blow up picture to prevent array out of bound
img_p = padarray(img,r*ones(2,1),'both');
[h_p, w_p] = size(img_p);

for i = 1:num
    y = keypoints(1,i); y_p = y+r;
    x = keypoints(2,i); x_p = x+r;
    patch = img_p(y_p-r:y_p+r,x_p-r:x_p+r); 
    descriptors(:,i) = patch(:);   
end


end
