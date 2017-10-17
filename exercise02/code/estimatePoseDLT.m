function M = estimatePoseDLT(p, P, K)
% M = estimatePoseDLT(p, P, K);
% estimates the pose (hence [R|t]) of the camera with given K
% Input:
%   p       calibrated (normalized) coordinates, p = [xi; yi; 1]
%   P       corner coordinates in world frame, P = [x1, y1, z1 ; ... ; xn, yn, zn] 
%   K       Camera matrix
% Output:
%   M       homog. transformation, "camera pose", M = [R|t] 
% Samuel Nyffenegger, 16.10.17

%% calculations

% get Q Matrix, Q*M_row=0
Q = zeros(2*param.n_reference_points,12); 

for i = 1:param.n_reference_points
    % get ith point coordinates
    Pi = [P(i,:)';1];
    pi = p(2*i-1:2*i)';
    
    % fill in Q
    Q(2*i-1,1:4) = Pi; 
    Q(2*i-1,9:12) = kron(Pi',-pi(1));
    Q(2*i,5:8) = Pi; 
    Q(2*i,9:12) = kron(Pi',-pi(2)); 
    
end

% solve over-determined system, min ||Q*M|| st. ||M||=1
% M is eig-vec of smallest eig-val of Q'*Q
[U,S,V] = svd(Q'*Q);
M_vec = V(:,end);

% reshape M and ensureing proper rotation matrix
M = reshape(M_vec,4,3)';
M = M*sign(M(3,4));

% sovle Orthogonal Procrustes problem, get proper rotation matrix
R = M(1:3,1:3); t = M(:,4);
[U,S,V] = svd(R);
R_tilde = U*V';

% check if rotaton matrix is valid
tol = 1e-15;
assert(norm( det(R_tilde)-1 ) < tol,'R_tilde is not a orthogonal rotation matrix');
assert( max(max(R_tilde'-inv(R_tilde))) < tol, 'R_tilde is not a orthogonal rotation matrix');

% recovering the scale of the projection matrix M
alpha = norm(R_tilde, 'fro')/norm(R, 'fro');

% finally get projection matrix
M = [R_tilde,alpha*t];

end