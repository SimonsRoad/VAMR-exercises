%% idx
clc
A = magic(6)
[~, idx] = min(A(:));
[idx_row,idx_col] = ind2sub(size(A),idx)




