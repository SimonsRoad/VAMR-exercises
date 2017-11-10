function F = fundamentalEightPoint(p1,p2)
% fundamentalEightPoint  The 8-point algorithm for the estimation of the fundamental matrix F
%
% The eight-point algorithm for the fundamental matrix with a posteriori
% enforcement of the singularity constraint (det(F)=0).
% Does not include data normalization.
%
% Reference: "Multiple View Geometry" (Hartley & Zisserman 2000), Sect. 10.1 page 262.
%
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%
% Output:
%  - F(3,3) : fundamental matrix

%% calculaitons

% bridge
try
    % lauched inside fundamentalEightPoint
    p1 = x1; 
    p2 = x2;
catch
    % launched from main   
end

p1_ = p1';
p2_ = p2';
Q = [p1_(:,1).*p2_(:,1) , ...
     p1_(:,2).*p2_(:,1) , ...
     p1_(:,3).*p2_(:,1) , ...
     p1_(:,1).*p2_(:,2) , ...
     p1_(:,2).*p2_(:,2) , ...
     p1_(:,3).*p2_(:,2) , ...
     p1_(:,1).*p2_(:,3) , ...
     p1_(:,2).*p2_(:,3) , ...
     p1_(:,3).*p2_(:,3) ] ;

[~,~,V] = svd(Q);
F_vec = V(:,end);
F = reshape(F_vec,3,3)';
 
% enforcing det(F)=2
[U,S,V] = svd(F);
S(end,end) = 0; 
F = U*S*V';

end