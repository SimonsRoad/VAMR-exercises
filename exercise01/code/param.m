% parameter file
% Samuel Nyffenegger, 10.10.17

classdef param
   properties (Constant)
        % control parameters 
        dockFig = false;     % dock all figures
        cube_x = 2;         % x position [units] of top left corner
        cube_y = 3;         % y position [units] of top left corner
        cube_a = 2;         % length of cube [units]
        n_frames = 10; %736;       % number of video frames, -1 to inherit 
        
        % parameters
        spacing = 0.04;     % length of checkerboard square [m]
        n_units_x = 8;      % number of checkerboards in x direction
        n_units_y = 5;      % number of checkerboards in y direction
   
   end
end