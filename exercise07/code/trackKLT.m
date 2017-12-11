function [W, p_hist] = trackKLT(I_R, I, x_T, r_T, num_iters)
% I_R: reference image, I: image to track point in, x_T: point to track,
% expressed as [x y]=[col row], r_T: radius of patch to track, n_iters:
% amount of iterations to run; W(2x3): final W estimate, p_hist 
% (6x(n_iters+1)): history of p estimates, including the initial
% (identity) estimate
% Input:
%   I_R, reference image
%   I, warped image (where to search) 
%   x_T, 1x2, point to track (centre of patch)
%   r_T, scalar, patch radius
%   n_iters, numbers of iteration for Newton Method
% Output:
%   W, 2x3 recovered estimated of affine transformation matrix
%   p_hist, 6x(n_iters+1) history of p estimates, W = [p1 p3 p5; p2 p4 p6]

p_hist = zeros(6, num_iters+1);
W = getSimWarp(0, 0, 0, 1); % identity
p_hist(:, 1) = W(:); % p is just a reshape of W

% T suffix indicates image evaluated for patch T
I_RT = getWarpedPatch(I_R, W, x_T, r_T); % patch of reference image
i_R = I_RT(:); % the template vector i_R never changes.

% x and y coordinates of the patch also never change
xs = -r_T:r_T;
ys = -r_T:r_T;
n = numel(xs);
xy1 = [kron(xs, ones([1 n]))' kron(ones([1 n]), ys)' ones([n*n 1])];
dwdx = kron(xy1, eye(2));

do_plot = false;

if do_plot
    figure(3);
end

for iter = 1:num_iters
    % Getting more, for a valid convolution.
    big_IWT = getWarpedPatch(I, W, x_T, r_T + 1);
    IWT = big_IWT(2:end-1, 2:end-1);
    i = IWT(:);
    
    % getting di/dp
    IWTx = conv2(1, [1 0 -1], big_IWT(2:end-1, :), 'valid');
    IWTy = conv2([1 0 -1], 1, big_IWT(:, 2:end-1), 'valid');
    didw = [IWTx(:) IWTy(:)]; % as written in the statement
    didp = zeros(n*n, 6);
    for pixel_i = 1:n*n
        didp(pixel_i, :) = didw(pixel_i, :) * ...
            dwdx(pixel_i*2-1:pixel_i*2, :);
    end
    
    % Hessian
    H = didp' * didp;
    
    % Putting it together and incrementing
    delta_p = H^-1 * didp' * (i_R - i);
    W = W + reshape(delta_p, [2 3]);
        
    if do_plot
        subplot(3, 1, 1);
        imagesc([IWT I_RT (I_RT - IWT)]);
        title('I(W(T)), I_R(T) and the difference')
        colorbar;
        axis equal;
        subplot(3, 1, 2);
        imagesc([IWTx IWTy]);
        title('warped gradients')
        colorbar;
        axis equal;
        subplot(3, 1, 3);
        descentcat = zeros(n, 6*n);
        for j = 1:6
            descentcat(:, (j-1)*n+1:j*n) = reshape(didp(:, j), [n n]);
        end
        imagesc(descentcat);
        title('steepest descent images');
        colorbar;
        axis equal;
        pause(0.1)
    end
    
    p_hist(:, iter + 1) = W(:);
    
    if norm(delta_p) < 1e-3
       p_hist = p_hist(:, 1:iter+1);
       return
    end
end

%% calculations
% clc
% 
% % control parameters
% plot_steps = []; % 1:5; 
% 
% % init
% s_T = 2*r_T+1; 
% T = s_T^2;
% W0 = getSimWarp(0,0,0,1); 
% p = W0(:);
% kernel = [1 0 -1]; 
% template = getWarpedPatch(I_R, W0, x_T, r_T);
% p_hist = zeros(6,n_iters+1);
% p_hist(:,1) = p;
% patch_I_R = getWarpedPatch(I_R, W0, x_T, r_T);
% patch_i_R = patch_I_R(:); % size: T,1
% % dx_array = repmat(-r_T:r_T,s_T,1); dx_array = dx_array(:);
% % dy_array = repmat((-r_T:r_T)',1,s_T); dy_array = dy_array(:);
% 
% % x and y coordinates of the patch also never change
% xs = -r_T:r_T;
% ys = -r_T:r_T;
% n = numel(xs);
% xy1 = [kron(xs, ones([1 n]))' kron(ones([1 n]), ys)' ones([n*n 1])];
% dW_dx = kron(xy1, eye(2));
%
% 
% % loop
% for n = 1:n_iters
%     
%     % get patch i
%     W = reshape(p,2,3);
%     patch_I = getWarpedPatch(I, W, x_T, r_T);
%     patch_i = patch_I(:); % size: T,1
%     
%     % get patch gradients i_x, i_y
%     I_x = conv2( padarray(patch_I,[0,1,0],'both') ,kernel, 'valid');
%     I_y = conv2( padarray(patch_I,[1,0,0],'both') ,kernel', 'valid');
%     i_x = I_x(:); % size: T,1
%     i_y = I_y(:); % size: T,1
%     di_dw = [i_x i_y];
% 
%     
%     % get derivative of i wrt to p
%     di_dp = zeros(T,6);
%     for pixel_i = 1:T
%         di_dp(pixel_i, :) = di_dw(pixel_i, :)*dW_dx(pixel_i*2-1:pixel_i*2, :);
%     end
%     
%     % hessian matrix, its inverse and correction term
%     H = di_dp'*di_dp;
%     dp = H\(di_dp'*(patch_i_R-patch_i));
%     
%     % update
%     p = W(:);
%     p = p + dp; 
%     p_hist(:,n+1) = p;
%     
%     % early stopping
%     if norm(dp) < 1e-3
%        p_hist = p_hist(:, 1:n+1);
%        return
%     end
% 
%     
%     % print
%     fprintf('p(%i) \t= ',n); fprintf('%2.2f    ',p'); fprintf('\n')
%     
%     % plot steps
%     if ~isempty( find(n == plot_steps, 1) )
%         figure(1); clf;
%             subplot(311);
%                 imagesc([patch_I, patch_I_R, (patch_I_R-patch_I)]);
%                 axis equal; colorbar; 
%                 title('I(W(T)), I_R(T) and difference');
%             subplot(312);
%                 imagesc([I_x, I_y]);
%                 axis equal; colorbar;
%                 title('warped gradients')
%             subplot(313);
%                 imagesc([reshape(di_dp(:,1),s_T,s_T), ...
%                          reshape(di_dp(:,2),s_T,s_T), ...
%                          reshape(di_dp(:,3),s_T,s_T), ...
%                          reshape(di_dp(:,4),s_T,s_T), ...
%                          reshape(di_dp(:,5),s_T,s_T), ...
%                          reshape(di_dp(:,6),s_T,s_T)]);
%                 axis equal; colorbar;
%                 title('steepest descent images')
%         pause(0.1);
%     end
% end
% 
% disp(['Point moved by ' num2str(W(:, end)') ', should move by (-10, -6)']);

end