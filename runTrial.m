function [result] = runTrial(handles)

% File loading
muscle = cellstr(handles.muscle_list{handles.selectedMuscle});

temp_1 = importdata(muscle{2});
temp_1 = temp_1(~any(isnan(temp_1), 2), :); % nan filter

temp_2 = importdata(muscle{3});
temp_2 = temp_2(~any(isnan(temp_2), 2), :); % nan filter

muscle{4} = handles.selectedMuscle;

EMG = abs(handles.walking_trial(:,[1 handles.selectedMuscle+1]));
% MVE = funMVE(temp_1, temp_2, handles.markerTemp, handles.fs, handles.windowLength, handles.fLow, handles.duration, handles.shift, muscle{1},'mean');
MVE = funMVE(temp_1, temp_2, handles.markerTemp, handles.fs, handles.windowLength, handles.fLow, handles.duration, handles.shift, muscle,'mean');

marker = handles.time_byMVN(:,1);

% Goal
result.EA = emgEA(EMG, marker, handles.fs, handles.fLow, 'marker', MVE(1));
result.LE = emgLE(EMG, marker, handles.fs, handles.fLow, 'marker', MVE(2));
result.MA = emgMA(EMG, marker, handles.fs, handles.fLow, 'marker', MVE(3));
result.RMS = emgRMS(EMG, marker, handles.fs, handles.fLow, 'marker', MVE(4));
result.RMS_s = emgRMS_slide(EMG, marker, handles.fs, handles.fLow, 'marker', MVE(4));