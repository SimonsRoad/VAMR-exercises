function Pw = generateRealWorldPoints(option)


if strcmp(option,'grid')
    % generate matrix of checkerboard corners Pw = [x1,y1,z1; x2,y2,z2; ...]
    
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
    % tba
    
else
    error('option not assigned correctly');
    return; 
    
end

end