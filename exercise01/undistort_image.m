function  img_u = undistort_image(img_d, K, D)
% img_u = undistort_image(img_d, K, D);
% undistorts an image
% Input:
%   img_d   distorted image
%   K       Camera matrix
%   D       distortion model, two parameters
% Output:
%   img_u   undistorted image
% Samuel Nyffenegger, 10.10.17
    
%%  calculations

% initialize image
img_u = img_d;
[Wy, Wx] = size(img_d); 

% double loop over pixels
for u = 1:Wx
    for v = 1:Wy
        % undistorted homogeneous Discretized pixel coordinates (u, v)
        p_D = [u; v; 1];
        
        % map into image plane with Normalized coordinates (x, y)
        p_N = K\p_D;
                
        % correct for lens distorsion (x_d, y_d)
        r = sqrt(p_N(1).^2 + p_N(2).^2);
        p_N_d = [(1 + D(1)*r.^2 + D(2)*r.^4) * p_N(1:2); 1]; 
        
        % distorted homogeneous Discretizised pixel coordinated (u_d, v_d)
        p_D_d = K*p_N_d;
             
        % closest neighbour approach, bounded "into" picture
        u_d = round(p_D_d(1)/p_D_d(3));
        v_d = round(p_D_d(2)/p_D_d(3)); 
        
        % update through backward warping
        img_u(v,u) = img_d(v_d,u_d);
                                
    end
end




end



%         % distorted homogeneous discretized pixel coordinates (u_d,v_d)
%         pc_d = [u_d; v_d; 1];
%         
%         % map into image plane with normalized coordinates (x_d, y_d)
%         p0_d = inv(K)*pc_d;
%         x_d = p0_d(1)/p0_d(3);
%         y_d = p0_d(2)/p0_d(3);
%                 
%         % correct for lens distorsion
%         r = sqrt(x_d.^2 + y_d.^2);
%         p0 = ones(3,1);
%         p0(1:2) = 1/(1 + D(1)*r.^2 + D(2)*r.^4) * p0_d(1:2); 
%              
%         % get discretized pixel coordinates 
%         pC = K*p0; 
%         u = round(pC(1)/pC(3));
%         v = round(pC(2)/pC(3));
%         
%         % fprintf(['u_d=',num2str(u_d),', v_d=',num2str(v_d),' u=',num2str(u),', v=',num2str(v),', r=',num2str(r),'\n'])
%         
%         % update rounded distorted pixel coordinate 
%         if 0<u && u<=Wx && 0<v && v<=Wy
%             img_u(round(v),round(u)) = img_d(v_d,u_d);
%         end
%                

