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
sI_x2 = conv2(I_x2,ones(patch_size),'valid');
sI_y2 = conv2(I_y2,ones(patch_size),'valid');
sI_xy = conv2(I_xy,ones(patch_size),'valid');

% calculate M, M_uv = reshape(M(u,v,:),2,2)
M = zeros([size(sI_x2),4]);
M(:,:,1) = sI_x2; 
M(:,:,2) = sI_xy;
M(:,:,3) = sI_xy;
M(:,:,4) = sI_y2; 

% calculate harris score, R_uv = det(M_uv) − κ*trace(M_uv)^2
M_ad = M(:,:,1).*M(:,:,4);
M_bc = M(:,:,2).*M(:,:,3);
R = M_ad - M_bc - kappa*(M_ad).^2;

% add zeros at the border
scores = padarray(R,(patch_radius+1)*[1,1,0],'both');

% replace negative score with zeros
idx = find(scores < 0);
scores(idx) = 0;


end
