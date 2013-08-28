function handles = config(handles)

% Folders & Files Setting
handles.filePrefix = 'B02-1';
handles.fileSuffix = '-sk-stair-down-one';
handles.MVC_folder = '..\MVC\';
handles.output_folder = 'C:\Users\Roliroli\Desktop\output';

% Walking Trial
handles.walking_file = '..\B02-1-sk-stair-down-one.asc';
handles.mvn_marker = '..\time_byMVN.txt';

% MVC Trial
handles.encoding = '-ascii';
handles.mvc_marker = '..\MVC\MVC_marker.txt';

%% Don't touch this
MVC_path = strcat(handles.MVC_folder, handles.filePrefix);
%%

% Common
handles.fs = 960;
handles.windowLength = 50;
handles.fLow = 10;
handles.duration = 3000;
handles.shift = 1000;

% Muscles
handles.muscle_list = {};
handles.muscle_list{1} = {'RF', strcat(MVC_path, '-MVC-RF-one.asc'), strcat(MVC_path, '-MVC-RF-two.asc')};
handles.muscle_list{2} = {'BF', strcat(MVC_path, '-MVC-BF-one.asc'), strcat(MVC_path, '-MVC-BF-two.asc')};
handles.muscle_list{3} = {'TA', strcat(MVC_path, '-MVC-TA-one.asc'), strcat(MVC_path, '-MVC-TA-two.asc')};
handles.muscle_list{4} = {'GAS', strcat(MVC_path, '-MVC-GAS-one.asc'), strcat(MVC_path, '-MVC-GAS-two.asc')};
handles.muscle_list{5} = {'ES', strcat(MVC_path, '-MVC-ES-one.asc'), strcat(MVC_path, '-MVC-ES-two.asc')};
handles.muscle_list{6} = {'RA', strcat(MVC_path, '-MVC-RA-one.asc'), strcat(MVC_path, '-MVC-RA-two.asc')};

% Don't Touch!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Config Processing
handles.muscle_names = {};
for i = 1 : length(handles.muscle_list)
	muscle = cellstr(handles.muscle_list{i});
	handles.muscle_names{i} = muscle{1};
end

% load marker files in advance
handles.markerTemp = dlmread(handles.mvc_marker);

walk = importdata(handles.walking_file);
handles.walking_trial = walk(~any(isnan(walk), 2), :); % nan filter

handles.time_byMVN = load(handles.mvn_marker, '-ascii');

handles.selectedMuscle = 1;