function generate_video()
% generate_video;
% creates a video
% Input:
%   Files in data/images_undistorted/img_xxxx.jpg
% Output:
%   Files in data/AR_cube.avi
% Samuel Nyffenegger, 12.10.17

%% calculations
fprintf('Generating video... ')


% param
outputVideo = VideoWriter('data/AR_cube');
outputVideo.FrameRate = 30;

% make movie
open(outputVideo)
for i = 1:param.n_frames
   eval(['img = imread(''data/images_undistorted/img_',num2str(i,'%04d'),'.jpg'');'])
   writeVideo(outputVideo,img)
end
close(outputVideo)

fprintf('done! \n')
end