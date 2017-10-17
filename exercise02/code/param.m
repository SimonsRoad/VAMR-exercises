% parameter file
% Samuel Nyffenegger, 16.10.17

classdef param
   properties (Constant)
        % control parameters 
        dockFig = true;             % dock all figures
        fps = 30;                   % frame rate for the video
        
        % parameters
        n_reference_points = 12;    % number of reference points
        m_images = 749;             % number of images
        scale = 1/100;              % scaling factor cm to m
   end
end