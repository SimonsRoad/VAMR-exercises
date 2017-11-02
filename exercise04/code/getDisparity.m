function disp_img = getDisparity(...
    left_img, right_img, patch_radius, min_disp, max_disp)
% left_img and right_img are both H x W and you should return a H x W
% matrix containing the disparity d for each pixel of left_img. Set
% disp_img to 0 for pixels where the SSD and/or d is not defined, and for d
% estimates rejected in Part 2. patch_radius specifies the SSD patch and
% each valid d should satisfy min_disp <= d <= max_disp.

%% calculations
clc

% control center
plot_left_patch = false;
plot_right_patch = false;
plot_eucllidean_distance = false;
early_stopping = true;

% init
[H, W] = size(left_img); 
disp_img = zeros(H,W); 

i = 0; I = 5000;

for h_l = 1:H
    for w_l = 1:W
        if (w_l <= patch_radius+max_disp) || (w_l >= W-patch_radius) || ... 
           (h_l <= patch_radius)          || (h_l >= H-patch_radius)
            % disparity not defined, set to zero
            disp_img(h_l,w_l) = 0;
        else
            % early stopping after I disparity calculations
            if i >= I && early_stopping; break; else; i=i+1; end 

            % get patch of left image
            query_descriptors = left_img(h_l-patch_radius:h_l+patch_radius, ...
                                       w_l-patch_radius:w_l+patch_radius);
            query_descriptors = query_descriptors(:);
                    
            if plot_left_patch
                figure(1); clf;
                    patch_size = 2 * patch_radius + 1;
                    imagesc(uint8(reshape(query_descriptors, [patch_size patch_size])));
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
            [~, disp_i] = min(D);
            disp_i = disp_i - max_disp; 
            if plot_eucllidean_distance
                figure(3); clf;
                    plot(1:length(D),D','*-')
                    xlim([1,50])
            end
                    
%             % get patch of right image
%             right_patch = right_img(h_l-patch_radius:h_l+patch_radius, ...
%                                        w_l-patch_radius+disp_i:w_l+patch_radius+disp_i);
%             right_patch = right_patch(:);
%                     
%             if plot_right_patch
%                 figure(2); clf;
%                     patch_size = 2 * patch_radius + 1;
%                     imagesc(uint8(reshape(right_patch, [patch_size patch_size])));
%             end
            
            
            % update
            disp_img(h_l,w_l) = disp_i-w_l;
        end
    end
end
% squaredeuclidean

% pdist2, convert input to single




end
