function [R_C_W, t_C_W, query_keypoints, all_matches, best_inlier_mask, ...
    max_num_inliers_history] = ransacLocalization(...
    query_image, database_image, database_keypoints, p_W_landmarks, K)
% query_keypoints should be 2x1000
% all_matches should be 1x1000 and correspond to the output from the
%   matchDescriptors() function from exercise 3.
% best_inlier_mask should be 1xnum_matched (!!!) and contain, only for the
%   matched keypoints (!!!), 0 if the match is an outlier, 1 otherwise.

%% calculations

% bridge
try 
    % launched inside ransacLocalization
    if ~exist('query_image','var'); query_image = imread('../data/000001.png'); end
catch
    % launched from main
end

%% keypoint matching
clc
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

% calculate keypoints and descriptors for database image
database_harris = harris(database_image, harris_patch_size, harris_kappa);
database_keypoints = selectKeypoints(database_harris, num_keypoints, nonmaximum_supression_radius);
database_descriptors = describeKeypoints(database_image, database_keypoints, descriptor_radius); 

% match query and database keypoints and plot it
matches = [1:length(query_descriptors); zeros(1,length(query_descriptors))];
matches(2,:) = matchDescriptors(query_descriptors, database_descriptors, match_lambda);
[~, found_matches_index] = find(matches(2,:) > 0);
found_matches = matches(:,found_matches_index);
plotMatches(matches(2,:), query_keypoints, database_keypoints, query_image, 1, found_matches_index(1:8)); 

%% RANSAC with DLT and 8-point algorithm
clc
n_iterations = 1; %2000; 
s = 8; 
[H, W] = size(query_image);

for i = 1:n_iterations
    % randomly sample to get 8 matches
    % chosen_matches = datasample(found_matches,s,2,'Replace',false); 
    chosen_matches = found_matches(:,1:s); % tmp
    
    % convert indeces to homogeneous coordinates
    query_homog_coord = K\[query_keypoints(:,chosen_matches(1,:));ones(1,s)];      % [y1..y8;x1..x8]
    database_homog_coord = K\[database_keypoints(:,chosen_matches(2,:));ones(1,s)]; 
    
    % calculate essential matrix and R,t
    E = estimateEssentialMatrix(database_homog_coord,query_homog_coord, K, K)
    [Rots,u3] = decomposeEssentialMatrix(E);
    [R,T] = disambiguateRelativePose(Rots,u3,database_homog_coord,query_homog_coord,K,K)
end


%% tmp
n_matched = 100;
R_C_W = eye(3); 
t_C_W = zeros(3,1);
query_keypoints = zeros(2,1000);
all_matches = zeros(1,1000);
best_inlier_mask = ones(1,n_matched);
max_num_inliers_history = ones(1,2000); 

end