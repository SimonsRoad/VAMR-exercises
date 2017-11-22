function [R_C_W, t_C_W_guess, query_keypoints, all_matches, best_inlier_mask, ...
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

% for i = 1:n_iterations
%     % get k random samples and corresponding landmarks
%     [sample_keypoints, idx] = datasample(matched_query_keypoints,k,2,'Replace',false);
%     sample_landmarks = corresponding_landmarks(:,idx);
%     
%     % guess R,t
%     M_C_W_guess = estimatePoseDLT(sample_keypoints', sample_landmarks', K); 
%     R_C_W_guess = M_C_W_guess(1:3,1:3);
%     t_C_W_guess = M_C_W_guess(1:3,4);
%     
%     % reproject
%     % corresponding_landmarks_C = R_C_W_guess*corresponding_landmarks + t_C_W_guess; 
%     % reprojected_points = projectPoints(corresponding_landmarks_C, K); 
%     reprojected_points = projectPoints(...
%         (R_C_W_guess(:,:,1) * corresponding_landmarks) + ...
%         repmat(t_C_W_guess(:,:,1), ...
%         [1 size(corresponding_landmarks, 2)]), K);
% 
%     % error analysis
%     difference = reprojected_points - matched_query_keypoints; 
%     pixel_errors = sqrt( sum(difference.^2, 1) );
%     inlier_mask = (pixel_errors < pixel_tolerance);
%     n_inliers =  length( pixel_errors( pixel_errors < pixel_tolerance) );
%     
%     % update
%     if n_inliers > best_n_inliers
%        best_n_inliers = n_inliers;
%        best_inlier_mask = inlier_mask;
%     end
%     max_num_inliers_history(i) = best_n_inliers; 
%     
% end

% RANSAC
num_iterations = n_iterations;
for i = 1:num_iterations
    % Model from k samples (DLT or P3P)
    [landmark_sample, idx] = datasample(...
        corresponding_landmarks, k, 2, 'Replace', false);
    keypoint_sample = matched_query_keypoints(:, idx);
    
    use_p3p = false;
    if use_p3p
        % Backproject keypoints to unit bearing vectors.
        normalized_bearings = K\[keypoint_sample; ones(1, 3)];
        for ii = 1:3
            normalized_bearings(:, ii) = normalized_bearings(:, ii) / ...
                norm(normalized_bearings(:, ii), 2);
        end
        
        poses = p3p(landmark_sample, normalized_bearings);
        
        % Decode p3p output
        R_C_W_guess = zeros(3, 3, 2);
        t_C_W_guess = zeros(3, 1, 2);
        for ii = 0:1
            R_W_C_ii = real(poses(:, (2+ii*4):(4+ii*4)));
            t_W_C_ii = real(poses(:, (1+ii*4)));
            R_C_W_guess(:,:,ii+1) = R_W_C_ii';
            t_C_W_guess(:,:,ii+1) = -R_W_C_ii'*t_W_C_ii;
        end
    else
        M_C_W_guess = estimatePoseDLT(...
            keypoint_sample', landmark_sample', K);
        R_C_W_guess = M_C_W_guess(:, 1:3);
        t_C_W_guess = M_C_W_guess(:, end);
    end
    
    % Count inliers:
    projected_points = projectPoints(...
        (R_C_W_guess(:,:,1) * corresponding_landmarks) + ...
        repmat(t_C_W_guess(:,:,1), ...
        [1 size(corresponding_landmarks, 2)]), K);
    difference = matched_query_keypoints - projected_points;
    errors = sum(difference.^2, 1);
    is_inlier = errors < pixel_tolerance^2;
    
    % If we use p3p, also consider inliers for the alternative solution.
    if use_p3p
        projected_points = projectPoints(...
            (R_C_W_guess(:,:,2) * corresponding_landmarks) + ...
            repmat(t_C_W_guess(:,:,2), ...
            [1 size(corresponding_landmarks, 2)]), K);
        difference = matched_query_keypoints - projected_points;
        errors = sum(difference.^2, 1);
        alternative_is_inlier = errors < pixel_tolerance^2;
        if nnz(alternative_is_inlier) > nnz(is_inlier)
            is_inlier = alternative_is_inlier;
        end
    end
    
    tweaked_for_more = false;
    if tweaked_for_more
        min_inlier_count = 30;
    else
        min_inlier_count = 6;
    end
    
    max_num_inliers = 0;
    if nnz(is_inlier) > max_num_inliers && ...
            nnz(is_inlier) >= min_inlier_count
        max_num_inliers = nnz(is_inlier);        
        best_inlier_mask = is_inlier;
    end
    
    max_num_inliers_history(i) = max_num_inliers;
end

% DLT with found inliers
if best_n_inliers == 0
    warning('R_C_W and t_C_w not found!')
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