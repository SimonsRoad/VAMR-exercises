function init(folder)
% init();
% initiates session
% Input:
%   folder  path from matlab folder which should be initialized
% Samuel Nyffenegger, 10.10.17

%%  calculations
    
% change path and add subfolders
eval(['cd ~/Documents/MATLAB/',folder])
addpath(genpath('data'));
addpath(genpath('code'));

% apply command from control center
if param.dockFig
    set(0,'DefaultFigureWindowStyle','docked');
else
    set(0,'DefaultFigureWindowStyle','normal');
end

end