%% idx
clc
A = magic(6)
[~, idx] = min(A(:));
[idx_row,idx_col] = ind2sub(size(A),idx)

%% indexing
clc
A = 1:6;
A = reshape(A,2,3)

%% dW_dp
clc
r_T = 15;
s_T = 2*r_T + 1;
T = s_T^2;
dW_dp = [[repmat(-r_T:r_T,s_T,1), zeros(s_T); zeros(s_T),repmat(-r_T:r_T,s_T,1)], ...
         [repmat((-r_T:r_T)',1,s_T), zeros(s_T); zeros(s_T),repmat((-r_T:r_T)',1,s_T)], ...
         [ones(s_T),zeros(s_T); zeros(s_T), ones(s_T)] ]
imagesc(dW_dp); axis equal

%% find
clc
A = 1:5;
a = 2;
~isempty( find(A == a) )

%%
clc
% x and y coordinates of the patch also never change
r_T = 2;
xs = -r_T:r_T;
ys = -r_T:r_T;
n = numel(xs);
xy1 = [kron(xs, ones([1 n]))' kron(ones([1 n]), ys)' ones([n*n 1])];
dwdx = kron(xy1, eye(2)); 
imagesc(dwdx); axis equal
