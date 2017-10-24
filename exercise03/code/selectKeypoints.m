function keypoints = selectKeypoints(scores, num, r)
% Selects the num best scores as keypoints and performs non-maximum 
% supression of a (2r + 1)*(2r + 1) box around the current maximum.

%% calculations
clc;

% bridge
try
    % launched inside selectKeypoints
    scores = harris_scores;
    num = 16; % num_keypoints;
    r = nonmaximum_supression_radius;
    scores = scores(20:25,20:26);
catch
    % launched from main
end

% init
[h, w] = size(scores);
keypoints = zeros(2,num);

% loop over keypoint selection
for i = 1:1%num
    % find maximum
    [~, idx] = max(scores(:));
    [y,x] = ind2sub([h,w],idx);
    keypoints(:,i) = [x; y];
    
    
end





end