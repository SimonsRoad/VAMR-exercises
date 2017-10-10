clc; 
r = pi/3*[0,0,1];
theta = norm(r);
axis = r/norm(r);

R = vrrotvec2mat([axis, theta])





