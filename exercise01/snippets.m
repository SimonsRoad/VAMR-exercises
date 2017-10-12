%%
tform = affine2d([1 0 0; .5 1 0; 0 0 1])


%%
clc;
p_d = [20,30,1]'
x_d = inv(data.K)*p_d
y_d = x_d(1:2)
r = sqrt(y_d(1).^2 + y_d(2).^2)
y_u = 1/(1 + D(1)*r.^2 + D(2)*r.^4) * y_d
x_u = [y_u;1]
p_u = data.K*x_u
%; p_u = p_u./p_u(3)

