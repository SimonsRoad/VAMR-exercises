function [best_guess_history, max_num_inliers_history] = ...
    parabolaRansac(data, max_noise)
% data is 2xN with the data points given column-wise, 
% best_guess_history is 3xnum_iterations with the polynome coefficients 
%   from polyfit of the BEST GUESS SO FAR at each iteration columnwise and
% max_num_inliers_history is 1xnum_iterations, with the inlier count of the
%   BEST GUESS SO FAR at each iteration.

%% calculations
clc

% param
n_iterations = 100; 
s = 3;

% init
n_inliers = 0; 
best_guess_history = zeros(3,n_iterations);
max_num_inliers_history = zeros(1,n_iterations);

% loop
for i = 1:n_iterations
    n_inliers_old = n_inliers;
    points = datasample(data,s,2,'Replace',false); 
    P = polyfit(points(1,:),points(2,:),s-1);
    y = polyval(P,data(1,:));
    n_inliers = sum( abs(y-data(2,:)) < max_noise ); 
    
    if n_inliers > n_inliers_old 
        % new best guess
        best_guess_history(:,i) = P';
    else
        % old guess is best guess
        best_guess_history(:,i) = best_guess_history(:,i-1);
        n_inliers = max_num_inliers_history(i-1);
    end
    max_num_inliers_history(i) = n_inliers;
    
end

% reestimate using inliers
P = best_guess_history(:,end);
y = polyval(P,data(1,:));
idx = find( abs(y-data(2,:)) < max_noise ); 
P_new = polyfit(data(1,idx),data(2,idx),s-1);
y_new = polyval(P_new,data(1,:));
n_inliers_new = sum( abs(y_new-data(2,:)) < max_noise ); 
best_guess_history(:,end) = P_new';
max_num_inliers_history(end) = n_inliers_new;

end