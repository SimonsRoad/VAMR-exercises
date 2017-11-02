%% snippets

%% show left and right image
clc
figure(1); clf
    imshow(left_img)
figure(2); clf
    imshow(right_img)


%% parallel computing
clc
parfor i = 1:10
   disp(i) 
end

