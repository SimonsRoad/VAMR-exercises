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
all_matches = matchDescriptors(query_descriptors, database_descriptors, match_lambda);
corresponding_matches = all_matches(all_matches > 0);
matched_query_keypoints = query_keypoints(:,all_matches > 0);
matched_database_keypoints = database_keypoints(:,corresponding_matches);
corresponding_landmarks = p_W_landmarks(:,corresponding_matches); 

%% RANSAC
% params RANSAC.
n_iterations = 2000;
pixel_tolerance = 10;
k = 6;

% init
n_matches = size(corresponding_matches,2);
best_n_inliers = 0; 
best_inlier_mask = zeros(1,n_matches);
max_num_inliers_history = zeros(1,n_iterations);
matched_query_keypoints = flipud(matched_query_keypoints); % (row, col) to (u, v)

for i = 1:n_iterations
    % get k random samples and corresponding landmarks
    [sample_keypoints, idx] = datasample(matched_query_keypoints,k,2,'Replace',false);
    sample_landmarks = corresponding_landmarks(:,idx);
    
    % guess R,t
    M_C_W_guess = estimatePoseDLT(sample_keypoints', sample_landmarks', K); 
    R_C_W_guess = M_C_W_guess(1:3,1:3);
    t_C_W_guess = M_C_W_guess(1:3,4);
    
    % reproject
    corresponding_landmarks_C = R_C_W_guess*corresponding_landmarks + t_C_W_guess; 
    reprojected_points = projectPoints(corresponding_landmarks_C, K); 

    % error analysis
    difference = reprojected_points - matched_query_keypoints; 
    pixel_errors = sqrt( sum(difference.^2, 1) );
    inlier_mask = (pixel_errors < pixel_tolerance);
    n_inliers =  length( pixel_errors( pixel_errors < pixel_tolerance) );
    
    % update
    if n_inliers > best_n_inliers
       best_n_inliers = n_inliers;
       best_inlier_mask = inlier_mask;
    end
    max_num_inliers_history(i) = best_n_inliers; 
    
end

% recalculate R,t using all inliers
if best_n_inliers == 0
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