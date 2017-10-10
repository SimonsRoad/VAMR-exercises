%   Vision Algorithms for Mobile Robots
%   Exercise 01
%   Augmented reality wireframe cube
%   Samuel Nyffenegger
%   09.10.2017

%%  calculations

clear all; close all; clc;
init('VAMR/exercise01');
data = loadData();

%% superimpose projected grid points on checkerboard

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
Pp = projectPoints(Pw, K, RT);

% generate line to draw the cube
x_vec = [Pp(1,1),Pp(2,1),Pp(4,1),Pp(3,1),Pp(1,1), ...
         Pp(5,1),Pp(6,1),Pp(8,1),Pp(7,1),Pp(5,1), Pp(1,1), ...
         Pp(2,1),Pp(6,1),Pp(8,1),Pp(4,1),Pp(3,1), Pp(7,1)];
y_vec = [Pp(1,2),Pp(2,2),Pp(4,2),Pp(3,2),Pp(1,2), ...
         Pp(5,2),Pp(6,2),Pp(8,2),Pp(7,2),Pp(5,2), Pp(1,2)...
         Pp(2,2),Pp(6,2),Pp(8,2),Pp(4,2),Pp(3,2), Pp(7,2)];

% plot
figure(1); clf; hold on;
    imshow(img,'InitialMagnification','fit');
    line(x_vec,y_vec,'LineWidth',3,'Color','r')


