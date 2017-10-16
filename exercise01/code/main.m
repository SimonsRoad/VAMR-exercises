%   Vision Algorithms for Mobile Robots
%   Exercise 01
%   Augmented reality wireframe cube
%   Samuel Nyffenegger
%   09.10.2017

%%  calculations

% init and load
clear all; close all; clc;
init('VAMR/exercise01');
data = loadData();

%% superimpose projected grid points and checkerboard on undistorted image

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

%% superimpose projected grid points and checkerboard on distorted image

% generate grid points in real world cooridnate frame
Pw = generateRealWorldPoints('grid');

% get relative position and orientation
pose = data.poses(1,:);
RT = poseVectorToTransformationMatrix(pose);

% project points to pixel coordinate system
Pp = projectPoints(Pw, data.K, RT, data.D);

% plot
figure(1); clf; hold on;
    imshow(data.img_0001,'InitialMagnification','fit');
    scatter(Pp(:,1),Pp(:,2),'*r');

%% undistortd distorted image

% source image: distorted, destination image: undistorted (for checking)
img_d = data.img_0001;
img_u_solution = data.img_0001_u;

% undistort image
img_u_i = undistort_image(img_d, data.K, data.D, 'interpolation');

% plot
figure(1); clf; hold on;
    imshow(img_u_i,'InitialMagnification','fit');
% figure(2); clf; hold on;
%     imshowpair(img_u_i,img_u_solution,'diff');
    
%% create video: undistort images and superimpose with cube

% undistort images and superimpose cube
undistort_and_superimpose_cube(data);

% convert image frames to video
generate_video();


