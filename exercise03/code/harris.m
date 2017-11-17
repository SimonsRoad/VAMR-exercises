function scores = harris(img, patch_size, kappa)

%% calculations

% bridge
try 
    % launched inside harris
    patch_size = harris_patch_size;
    kappa = harris_kappa;
catch
    % launched in main
end

% calculate radius
patch_radius = floor((patch_size-1)/2);

% define filters
sobel_x = [-1,0,1;-2,0,2;-1,0,1];
sobel_y = sobel_x';

% do intermediate steps
I_x = conv2(img,sobel_x,'valid');
I_y = conv2(img,sobel_y,'valid');
I_x2 = I_x.^2;
I_y2 = I_y.^2;
I_xy = I_x.*I_y;
patch = ones(patch_size)./(patch_size^2);
sI_x2 = conv2(I_x2,patch,'valid');
sI_y2 = conv2(I_y2,patch,'valid');
sI_xy = conv2(I_xy,patch,'valid');

% calculate M, M_uv = reshape(M(u,v,:),2,2)
M = zeros([size(sI_x2),4]);
M(:,:,1) = sI_x2; 
M(:,:,2) = sI_xy;
M(:,:,3) = sI_xy;
M(:,:,4) = sI_y2; 

% calculate harris score, R_uv = det(M_uv) − κ*trace(M_uv)^2
R = M(:,:,1).*M(:,:,4) - M(:,:,2).*M(:,:,3) - kappa*(M(:,:,1)+M(:,:,4)).^2;

% add zeros at the border
scores = padarray(R,(patch_radius+1)*[1,1,0],'both');

% replace negative score with zeros
scores(scores < 0) = 0;


end
