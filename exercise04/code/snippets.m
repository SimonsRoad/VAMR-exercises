%% snippets

%% show left and right image
clc
figure(1); clf
    imshow(left_img)
figure(2); clf
    imshow(right_img)


%% parallel computing
clc
tic
parfor (i=1:1000, 15)
    A = rand(100,100); 
end
time = toc

%% Fit a polynomial p of degree 1 to the (x,y) data:
clc
x = -10:50;
y = 0.1*x.^2 - 2;
p = polyfit(x,y,2);
f = polyval(p,x);
[y_min,x_min_idx] = min(f); x_min=x(x_min_idx)
roots(p)
        
        