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

% plot first image
figure(1); clf; hold on;
    imshow(data.img_0001,'InitialMagnification','fit');

% convert pixel coordinates to 
p = pixel2calibratedCoordinates(corners, data.K); 

% estimate pose using the DLT algorithm
M = estimatePoseDLT(p, P, data.K);


