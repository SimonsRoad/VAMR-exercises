function Pw = generateRealWorldPoints(option)
% Pw = generateRealWorldPoints(option);
% generates Points in real world coordinate system
% Input:
%   option  'grid' or 'cube'
% Output:
%   Pw      data points, Pw = [x1,y1,z1; x2,y2,z2; ...]
% Samuel Nyffenegger, 10.10.17


if strcmp(option,'grid')
    %% generate checkerboard grid 
    
    % get data from data container
    spacing = param.spacing;
    Nx = param.n_units_x;
    Ny = param.n_units_y;

    % generate 1d grid
    points_x = spacing*[0:Nx]; points_x = points_x(:);
    points_y = spacing*[0:Ny]; points_y = points_y(:);

    % generate 3d grid
    [Pw_y, Pw_x] = meshgrid(points_y,points_x); 
    Pw_x = Pw_x(:); Pw_y = Pw_y(:);
    Pw = zeros(size(Pw_x,1),3);
    Pw(:,1) = Pw_x'; 
    Pw(:,2) = Pw_y'; 
    Pw(:,3) = 0;
    return;
    
elseif strcmp(option,'cube')
    %% generate corners of the cube 
    
    % get data from data container
    spacing = param.spacing;
    x = param.cube_x;
    y = param.cube_y;
    a = param.cube_a;

    % generate corners of cube
    Pw = spacing*...
        [x,     y,     0; ...
         x+a,   y,     0; ...
         x,     y+a,   0; ...
         x+a,   y+a,   0; ...
         x,     y,     -a; ...
         x+a,   y,     -a; ...
         x,     y+a,   -a; ...
         x+a,   y+a,   -a]; 
    
else
    error('option not assigned correctly');
    return; 
    
end

end