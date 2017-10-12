function undistort_and_superimpose_cube()
% undistort_and_superimpose_cube();
% undistorts images and superimposes a cube
% Input:
%   Files in data/images/img_xxxx.jpg
% Output:
%   Files in data/images_undistorted/img_xxxx.jpg
% Samuel Nyffenegger, 12.10.17

%% calculations
fprintf(['Starting to undistort images and superimpose a cube on ', ...
    num2str(param.n_frames),' frames... \n'])

for i = 1:param.n_frames
    % print status message
    fprintf(['\tUndistort image ',num2str(i),' of ',num2str(param.n_frames),'\n'])
    
    % load image
    eval(['img_d = rgb2gray(imread(''data/images/img_',num2str(i,'%04.0f'),'.jpg''));'])
    
    % undistort image
    img_u = undistort_image(img_d, data.K, data.D, 'interpolation');

    % generate grid points in real world cooridnate frame
    Pw = generateRealWorldPoints('cube');

    % get relative position and orientation
    pose = data.poses(i,:);
    RT = poseVectorToTransformationMatrix(pose);

    % project points to pixel coordinate system
    Pp = projectPoints(Pw, data.K, RT);

    % connect points to a cube
    [x_vec, y_vec] = helper_CubeLineCoordinates(Pp);

    % plot
    figure(i); clf; hold on;
        imshow(img_u,'InitialMagnification','fit');
        line(x_vec,y_vec,'LineWidth',3,'Color','r')

    % save image
    eval(['imwrite(img_u,''data/images_undistorted/img_',num2str(2,'%04.0f'),'.jpg'');']);
     
end


end