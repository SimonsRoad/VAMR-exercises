%% datasample
clc
asdf = 1:3;
n_samples = 2;
datasample(asdf,n_samples,2,'Replace',false)

%% idx
A = 1:10;
idx = find(A<7);
B = A(idx); 

%% dist
clc
a = [1 1 0;0 0 0];
b = [0 0 3;1 0 0]; 
diff = (a-b); 
dist = sqrt(diff(1,:).^2+diff(2,:).^2)



