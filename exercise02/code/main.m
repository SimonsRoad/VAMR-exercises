%   Vision Algorithms for Mobile Robots
%   Exercise 02
%   The Perspective-n-Point (PnP) problem
%   Samuel Nyffenegger
%   16.10.2017

%%  calculations

% init and load
clear all; close all; clc;
init('VAMR/exercise02');
data = loadData();

%% Calculate [R|T] with first image using DLT algorithm

% load data
img = data.img_0001;
corners = data.detected_corners(1,:);
P = data.p_W; 

% convert pixel coordinates to 
p = pixel2calibratedCoordinates(corners, data.K); 

% estimate pose using the DLT algorithm
M = estimatePoseDLT(p, P, data.K);

% reproject checker points
points = reprojectPoints(P, data.K, M);

% plot first image
figure(1); clf; hold on;
    imshow(data.img_0001,'InitialMagnification','fit');
    scatter(points(:,1),points(:,2),'*r');

%% create camera pose estimation video 
% upper part need to run in advance

% checker points 
P = data.p_W; 
pts3d = P'*param.scale;

% create array to store data
transl = zeros(3,param.m_images);
quats = zeros(4,param.m_images);

% loop over images
for i = 1:param.m_images
    % load data
    corners_i = data.detected_corners(i,:);
    
    % convert pixel coordinates to 
    pi = pixel2calibratedCoordinates(corners_i, data.K); 
    
    % estimate pose using the DLT algorithm
    Mi = estimatePoseDLT(pi, P, data.K);
    
    % convert from cm to meters, invert M, convert into quaternions
    Ri = Mi(1:3,1:3)';
    ti = -Ri*Mi(:,4)*param.scale;
    qi = rotMatrix2Quat([Ri,ti]);
    
    % update
    transl(:,i) = ti; 
    quats(:,i) = qi;
end

% make video
plotTrajectory3D(param.fps, transl,quats, pts3d)


