function data = loadData()
% data = loadData();
% loads data
% Output:
%   data    struct containing all data
% Samuel Nyffenegger, 10.10.17

%%  calculations

% load camera data and poses
data.K = load('data/K.txt');
data.D = load('data/D.txt');
data.poses = load('data/poses.txt'); 

% load undistorted first image
data.img_0001_u = rgb2gray(imread('data/images_undistorted/img_0001.jpg'));

% load distorted first image
data.img_0001 = rgb2gray(imread('data/images/img_0001.jpg'));



end