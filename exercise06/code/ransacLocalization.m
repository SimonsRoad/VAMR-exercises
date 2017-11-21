function [R_C_W, t_C_W, query_keypoints, all_matches, best_inlier_mask, ...
    max_num_inliers_history] = ransacLocalization(...
    query_image, database_image, database_keypoints, p_W_landmarks, K)
% query_keypoints should be 2x1000
% all_matches should be 1x1000 and correspond to the output from the
%   matchDescriptors() function from exercise 3.
% best_inlier_mask should be 1xnum_matched (!!!) and contain, only for the
%   matched keypoints (!!!), 0 if the match is an outlier, 1 otherwise.
% p_W_landmarks (3d world coordinate points) corresponds to database_keypoints

%% calculations

% bridge
try 
    % launched inside ransacLocalization
    database_keypoints = keypoints;
    if ~exist('query_image','var'); query_image = imread('../data/000001.png'); end
catch
    % launched from main
end

%% keypoint matching

harris_patch_size = 9;
harris_kappa = 0.08;
num_keypoints = 1000;
nonmaximum_supression_radius = 8;
descriptor_radius = 9;
match_lambda = 5;

% calculate keypoints and descriptors for query image
query_harris = harris(query_image, harris_patch_size, harris_kappa);
query_keypoints = selectKeypoints(query_harris, num_keypoints, nonmaximum_supression_radius);
query_descriptors = describeKeypoints(query_image, query_keypoints, descriptor_radius); 

% % calculate keypoints and descriptors for database image
% database_harris = harris(database_image, harris_patch_size, harris_kappa);
% database_keypoints = selectKeypoints(database_harris, num_keypoints, nonmaximum_supression_radius);
database_descriptors = describeKeypoints(database_image, database_keypoints, descriptor_radius); 

% match query and database keypoints and plot it
% matches = [index query for all points; index database for all points]
matches = [1:length(query_descriptors); zeros(1,length(query_descriptors))];
matches(2,:) = matchDescriptors(query_descriptors, database_descriptors, match_lambda);
[~, found_matches_index] = find(matches(2,:) > 0);
found_matches = matches(:,found_matches_index);
j = 28;
plotMatches(matches(2,:), query_keypoints, database_keypoints, query_image, 1, found_matches(1,j:j+7)); 

% solution
all_matches = matchDescriptors(query_descriptors, database_descriptors, match_lambda);
% Drop unmatched keypoints and get 3d landmarks for the matched ones.
matched_query_keypoints = query_keypoints(:, all_matches > 0);
corresponding_matches = all_matches(all_matches > 0);
corresponding_landmarks = p_W_landmarks(:, corresponding_matches);

%% RANSAC
% Initialize RANSAC.
num_iterations = 2000;
pixel_tolerance = 10;
k = 6;

best_inlier_mask = zeros(1, size(matched_query_keypoints, 2));
% (row, col) to (u, v)
matched_query_keypoints = flipud(matched_query_keypoints);
max_num_inliers_history = zeros(1, num_iterations);
max_num_inliers = 0;
% Replace the following with the path to your camera projection code:
addpath('../../Solution 1/code');
addpath('../../Solution 2/code');

% RANSAC
for i = 1:num_iterations
    % Model from k samples (DLT or P3P)
    [landmark_sample, idx] = datasample(...
        corresponding_landmarks, k, 2, 'Replace', false);
    keypoint_sample = matched_query_keypoints(:, idx);
    
    M_C_W_guess = estimatePoseDLT(...
        keypoint_sample', landmark_sample', K);
    R_C_W_guess = M_C_W_guess(:, 1:3);
    t_C_W_guess = M_C_W_guess(:, end);
    
    % Count inliers:
    projected_points = projectPoints(...
        (R_C_W_guess(:,:,1) * corresponding_landmarks) + ... %this was my fault
        repmat(t_C_W_guess(:,:,1), ...
        [1 size(corresponding_landmarks, 2)]), K);
    difference = matched_query_keypoints - projected_points;
    errors = sum(difference.^2, 1);
    is_inlier = errors < pixel_tolerance^2;
    
    min_inlier_count = 6;
    
    if nnz(is_inlier) > max_num_inliers && ...
            nnz(is_inlier) >= min_inlier_count
        max_num_inliers = nnz(is_inlier);        
        best_inlier_mask = is_inlier;
    end
    
    max_num_inliers_history(i) = max_num_inliers;
end

if max_num_inliers == 0
    R_C_W = [];
    t_C_W = [];
else
    M_C_W = estimatePoseDLT(...
        matched_query_keypoints(:, best_inlier_mask>0)', ...
        corresponding_landmarks(:, best_inlier_mask>0)', K);
    R_C_W = M_C_W(:, 1:3);
    t_C_W = M_C_W(:, end);
end


end