function  img_u = undistort_image(img_d, D)
% img_u = undistort_image(img_d, D);
% undistorts an image
% Input:
%   img_d   distorted image
%   D       distortion model, two parameters
% Output:
%   img_u   undistorted image
% Samuel Nyffenegger, 10.10.17
    
%%  calculations
img_d = data.img_0001;
D = data.D;

clc

img_u = img_d;
[Wy, Wx] = size(img_d); 

% loop over pixels
for x = 1:Wx
    for y = 1:Wy
        % generate normalized distorted pixel coordinate 
        p_d = [x/Wx; y/Wy];
        
        % correct for lens distorsion
        r = sqrt(p_d(1).^2 + p_d(2).^2);
        p = 1/(1 + D(1)*r.^2 + D(2)*r.^4) * p_d;
        
        % generate normalized distorted pixel coordinate 
        p_u = [round(Wx*p(1)); round(Wy*p(2))];
        img_u(p_u(2),p_u(1)) = data.img_0001(y,x);
        
        % insert into undistorted image
        
    end
end




end

