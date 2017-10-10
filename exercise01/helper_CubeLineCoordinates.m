function [x_vec, y_vec] = helper_CubeLineCoordinates(Pp)
% [x_vec, y_vec] = helper_CubeLineCoordinates(Pp);
% combines points of cube to draw it
% Input:
%   Pp      projected points in pixel coordinate system
% Output:
%   x_vec   x-coordinate to draw
%   y_vec   y-coordinate to draw
% Samuel Nyffenegger, 10.10.17

%% calculations

% generate line to draw the cube
x_vec = [Pp(1,1),Pp(2,1),Pp(4,1),Pp(3,1),Pp(1,1), ...
         Pp(5,1),Pp(6,1),Pp(8,1),Pp(7,1),Pp(5,1), Pp(1,1), ...
         Pp(2,1),Pp(6,1),Pp(8,1),Pp(4,1),Pp(3,1), Pp(7,1)];
y_vec = [Pp(1,2),Pp(2,2),Pp(4,2),Pp(3,2),Pp(1,2), ...
         Pp(5,2),Pp(6,2),Pp(8,2),Pp(7,2),Pp(5,2), Pp(1,2)...
         Pp(2,2),Pp(6,2),Pp(8,2),Pp(4,2),Pp(3,2), Pp(7,2)];
     
end
