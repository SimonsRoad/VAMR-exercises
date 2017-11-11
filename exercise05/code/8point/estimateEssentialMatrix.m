function E = estimateEssentialMatrix(p1, p2, K1, K2)
% estimateEssentialMatrix_normalized: estimates the essential matrix
% given matching point coordinates, and the camera calibration K
%
% Input: point correspondences
%  - p1(3,N): homogeneous coordinates of 2-D points in image 1
%  - p2(3,N): homogeneous coordinates of 2-D points in image 2
%  - K1(3,3): calibration matrix of camera 1
%  - K2(3,3): calibration matrix of camera 2
%
% Output:
%  - E(3,3) : fundamental matrix

%% calculations

% bridge
try
    % launched inside estimateEssentialMatrix
    K1 = K;
    K2 = K;
catch
    % launched from main
end

p1_tilde = (K1^-1*p1)';
p2_tilde = (K2^-1*p2)';
Q = [p1_tilde(:,1).*p2_tilde(:,1) , ...
     p1_tilde(:,2).*p2_tilde(:,1) , ...
     p1_tilde(:,3).*p2_tilde(:,1) , ...
     p1_tilde(:,1).*p2_tilde(:,2) , ...
     p1_tilde(:,2).*p2_tilde(:,2) , ...
     p1_tilde(:,3).*p2_tilde(:,2) , ...
     p1_tilde(:,1).*p2_tilde(:,3) , ...
     p1_tilde(:,2).*p2_tilde(:,3) , ...
     p1_tilde(:,3).*p2_tilde(:,3) ] ;

[~,~,V] = svd(Q);
E_vec = V(:,end);
E = reshape(E_vec,3,3)';

end