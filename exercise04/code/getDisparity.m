% TODOs:
%   - skip patches with disparity > max_disp
%   - rectified: database patches only once for whole column
%   - apply debug modus

function disp_img = getDisparity(...
    left_img, right_img, patch_radius, min_disp, max_disp)
% left_img and right_img are both H x W and you should return a H x W
% matrix containing the disparity d for each pixel of left_img. Set
% disp_img to 0 for pixels where the SSD and/or d is not defined, and for d
% estimates rejected in Part 2. patch_radius specifies the SSD patch and
% each valid d should satisfy min_disp <= d <= max_disp.

%% calculations

% control center
plot_left_patch = 0;
plot_right_patch = 0;
plot_eucllidean_distance = 0;
early_stopping = 0;
sub_pixel_refinement = 1;

% init
[H, W] = size(left_img); 
disp_img = zeros(H,W); 

parfor h_l = 1:((1-early_stopping)*H + early_stopping*10)
    warning('off','all')
    for w_l = 1:W
        if (w_l <= patch_radius+max_disp) || (w_l >= W-patch_radius) || ... 
           (h_l <= patch_radius)          || (h_l >= H-patch_radius)
            % disparity not defined, set to zero
            disp_img(h_l,w_l) = 0;
        else            
            % get patch of left image
            query_descriptors = left_img(h_l-patch_radius:h_l+patch_radius, ...
                                       w_l-patch_radius:w_l+patch_radius);
            query_descriptors = query_descriptors(:);
                    
            if plot_left_patch
                figure(1); clf; 
                    patch_size = 2 * patch_radius + 1;
                    imagesc(uint8(reshape(query_descriptors, [patch_size patch_size])));
                    axis equal; 
            end
            
            % get candidate patches from right image on epipolar line
            w_idx = patch_radius+1:W-patch_radius-1;
            database_descriptors = zeros(length(query_descriptors),length(w_idx));
            j = 1;
            for w_r = w_idx
                database_descriptor_j = right_img(h_l-patch_radius:h_l+patch_radius, ...
                                                  w_r-patch_radius:w_r+patch_radius);
                database_descriptor_j = database_descriptor_j(:);
                database_descriptors(:,j) = database_descriptor_j;
                j = j+1;
            end
                        
            % get distance
            D = pdist2(single(query_descriptors'),single(database_descriptors'),'squaredeuclidean');
            [min_D, idx_D] = min(D);
            w_r = idx_D + patch_radius;
            disp_i = w_l - w_r; 
            
            % filter 1: reject ambiguous matches
            scaling_ambiguous = 1.5;
            n_ambiguous = length(D(D < scaling_ambiguous*min_D)); 
            if n_ambiguous > 2
                disp_i = 0;
                continue;
            end
            
            % filter 2: reject bound estimates
            % disp_i = min(max(disp_i,min_disp),max_disp);
            if disp_i > max_disp || disp_i < min_disp
                disp_i = 0;
                continue;
            end            

            % plot correspondance of left/right patches
            if plot_eucllidean_distance
                figure(3); clf;
                    plot(1:length(D),D','*-')
                    xlim([20,50])
            end
                    
            % get patch of right image
            right_patch = right_img(h_l-patch_radius:h_l+patch_radius, ...
                                       w_r-patch_radius:w_r+patch_radius);
            right_patch = right_patch(:);
                    
            if plot_right_patch
                figure(2); clf; 
                    patch_size = 2 * patch_radius + 1;
                    imagesc(uint8(reshape(right_patch, [patch_size patch_size])));
                    axis equal
            end
            
            % sub-pixel refinement
            if sub_pixel_refinement
                X = [idx_D-1, idx_D, idx_D+1];
                Y = D(X);
                p = polyfit(X,Y,2);
                idx_D_refined = -p(2)/(2*p(1));
                w_r = idx_D_refined + patch_radius;
                disp_i = w_l - w_r; 
            end

            % update
            disp_img(h_l,w_l) = disp_i;
        end
    end
end

warning on

end
