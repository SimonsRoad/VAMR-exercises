%   Vision Algorithms for Mobile Robots
%   Exercise 01
%   Augmented reality wireframe cube
%   Samuel Nyffenegger
%   09.10.2017

%%  calculations

clear all; close all; clc;
init('VAMR/exercise01');
data = loadData();

%% superimpose projected grid points and checkerboard

% generate grid points in real world cooridnate frame
Pw = generateRealWorldPoints('grid');

% get relative position and orientation
pose = data.poses(1,:);
RT = poseVectorToTransformationMatrix(pose);

% project points to pixel coordinate system
Pp = projectPoints(Pw, data.K, RT);

% plot
figure(1); clf; hold on;
    imshow(data.img_0001_u,'InitialMagnification','fit');
    scatter(Pp(:,1),Pp(:,2),'*r');

%% superimpose cube and checkerboad

% generate grid points in real world cooridnate frame
Pw = generateRealWorldPoints('cube');

% get relative position and orientation
pose = data.poses(1,:);
RT = poseVectorToTransformationMatrix(pose);

% project points to pixel coordinate system
Pp = projectPoints(Pw, data.K, RT);

% connect points to a cube
[x_vec, y_vec] = helper_CubeLineCoordinates(Pp);

% plot
figure(1); clf; hold on;
    imshow(data.img_0001_u,'InitialMagnification','fit');
    line(x_vec,y_vec,'LineWidth',3,'Color','r')

%% radial distortion






