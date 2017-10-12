eval(['img_d = rgb2gray(imread(''data/images/img_',num2str(0001,'%04.0f'),'.jpg''));'])

%%
clc

eval(['imwrite(img_u,''data/images_undistorted/img_',num2str(2,'%04.0f'),'.jpg'');'])

