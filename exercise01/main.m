%   Vision Algorithms for Mobile Robots
%   Exercise 01
%   Augmented reality wireframe cube
%   Samuel Nyffenegger
%   09.10.2017

%%  calculations

clear all; close all; clc;
init('VAMR/exercise01');
data = loadData();

%%  projective equation: grid on checkerboard

% get image from data container
img = data.img_0001_u;

% generate matrix of checkerboard corners Pw = [x1,y1,z1; x2,y2,z2; ...]
spacing = 0.04; % [cm]
dim_checkerboard = [8; 5];
points_x = spacing*[0:dim_checkerboard(1)]; points_x = points_x(:);
points_y = spacing*[0:dim_checkerboard(2)]; points_y = points_y(:);
[Pw_y, Pw_x] = meshgrid(points_y,points_x); Pw_x = Pw_x(:); Pw_y = Pw_y(:);
Pw = zeros(size(Pw_x,1),3);
Pw(:,1) = Pw_x'; 
Pw(:,2) = Pw_y'; 
Pw(:,3) = 0; 

% superimpose the projected corners to the undistorted image
pose = poses(1,:);
RT = poseVectorToTransformationMatrix(pose);
points = projectPoints(Pw, K, RT);

% plot
figure(1); clf; hold on;
    imshow(img,'InitialMagnification','fit');
    scatter(points(:,1),points(:,2),'*r');

%% generate cube
clc; 

% cube parameters
cube.x = 2; % x position [units] of top left corner
cube.y = 2; % y position [units] of top left corner
cube.a = 2; % length of cube [units]

% generate corners
Pw = spacing*[cube.x,           cube.y       , 0; ...
              cube.x+cube.a,    cube.y       , 0; ...
              cube.x,           cube.y+cube.a, 0; ...
              cube.x+cube.a,    cube.y+cube.a, 0; ...
              cube.x,           cube.y       , -cube.a; ...
              cube.x+cube.a,    cube.y       , -cube.a; ...
              cube.x,           cube.y+cube.a, -cube.a; ...
              cube.x+cube.a,    cube.y+cube.a, -cube.a]; 

          

% project corner to image plane
pose = poses(1,:);
RT = poseVectorToTransformationMatrix(pose);
points = projectPoints(Pw, K, RT);

% generate line to draw the cube
x_vec = [points(1,1),points(2,1),points(4,1),points(3,1),points(1,1), ...
         points(5,1),points(6,1),points(8,1),points(7,1),points(5,1), points(1,1), ...
         points(2,1),points(6,1),points(8,1),points(4,1),points(3,1), points(7,1)];
y_vec = [points(1,2),points(2,2),points(4,2),points(3,2),points(1,2), ...
         points(5,2),points(6,2),points(8,2),points(7,2),points(5,2), points(1,2)...
         points(2,2),points(6,2),points(8,2),points(4,2),points(3,2), points(7,2)];

% plot
figure(1); clf; hold on;
    imshow(img,'InitialMagnification','fit');
    line(x_vec,y_vec,'LineWidth',3,'Color','r')


