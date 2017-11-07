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


        
        