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
outlier_removal = 1;
sub_pixel_refinement = 0;
scaling_ambiguous = 1.5;
early_stopping_pixels_per_dimension = [1, 5];


% debug modus, if debugging stop parallel computing
debug_modus = 0; 
early_stopping = 0;
plot_left_patch = 1;
plot_right_strip = 1;
plot_euclidean_distance = 1;

% init
r = patch_radius; 
patch_size = 2 * r + 1; 
[H, W] = size(left_img); 
disp_img = zeros(H,W); 


parfor h_l = (r+1):(H-r) 
    warning('off','all')
    for w_l = (r+1+max_disp):(W-r) 
        % abort computations after some pixels
        if early_stopping
            if h_l >= r+1+early_stopping_pixels_per_dimension(1); continue; end            
            if w_l >= r+1+max_disp+early_stopping_pixels_per_dimension(2); continue; end
        end
        
        % get patch of left image
        query_descriptors = left_img(h_l-r:h_l+r, ...
                                   w_l-r:w_l+r);
        query_descriptors = query_descriptors(:);

        % get strip from right image on horizontal epipolar line
        database_descriptors = [];
        strip_cols = w_l - (max_disp:-1:min_disp);
        for w_r = strip_cols
            database_descriptor = right_img(h_l-r:h_l+r, ...
                                              w_r-r:w_r+r);
            database_descriptors = [database_descriptors, database_descriptor(:)];
        end

        % get distance
        D = pdist2(single(query_descriptors'),single(database_descriptors'),'squaredeuclidean');
        [min_D, idx_D] = min(D);
        disparity = max_disp - idx_D;

        if outlier_removal
            % filter 1: reject ambiguous matches
            n_ambiguous = length(D(D < scaling_ambiguous*min_D)); 
            if n_ambiguous > 2
                disp_img(h_l,w_l) = 0;
                continue;
            end

            % filter 2: reject bound estimates
            if D(idx_D) == D(1)  || D(idx_D) == D(end)
                disp_img(h_l,w_l) = 0;
                continue;
            end
        end
            
        % sub-pixel refinement
        if sub_pixel_refinement
            X = [idx_D-1, idx_D, idx_D+1];
            Y = D(X);
            p = polyfit(X,Y,2);
            idx_D_refined = -p(2)/(2*p(1));
            disparity = max_disp - idx_D_refined;
        end

        % update
        disp_img(h_l,w_l) = disparity;

        % debug modus, print a lot
        if debug_modus            
            % plot left patch
            if plot_left_patch
                figure(1); clf; 
                    imagesc(uint8(reshape(query_descriptors, [patch_size patch_size])));
                    axis equal; title('left patch')
            end
            
            % plot right strip
            if plot_right_strip
                right_strip = right_img(h_l-r:h_l+r,w_l-max_disp:w_l-min_disp);
                figure(2); clf; 
                    imagesc(right_strip);
                    axis equal; title('right strip')
            end
            
            % plot correspondance of left/right patches
            if plot_euclidean_distance
                figure(3); clf; 
                    plot(min_disp:max_disp,D','*-')
                    xlim([min_disp,max_disp])
                    title('euclidean distance vs disparity')
            end
            pause

        end
            
    end
end

warning on

end
