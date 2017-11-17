%% datasample
clc
asdf = 1:3;
n_samples = 2;
datasample(asdf,n_samples,2,'Replace',false)

%% idx
A = 1:10;
idx = find(A<7);
B = A(idx); 




