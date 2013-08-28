function handles = runMultiCycleSequential(handles, startCycle, endCycle)

result = handles.result;
muscle = cellstr(handles.muscle_list{handles.selectedMuscle});

%startCycle = str2double(get(handles.startCycleEditText,'String'));
%endCycle = str2double(get(handles.endCycleEditText,'String'));

cc=hsv(128);
j = 1; delta = 30;
list = get(handles.goalList, 'String');
name = strcat(muscle{1}, '-Multi Cycle(', list{get(handles.goalList, 'Value')}, ')');
figure('name', name);
hold on;
for i = startCycle : endCycle
    switch get(handles.goalList, 'Value')
        case 1
            plot(result.EA.cycle(i).data(:,3), result.EA.cycle(i).data(:,2), 'color', cc(j*delta,:))
        case 2
            plot(result.LE.cycle(i).data(:,3), result.LE.cycle(i).data(:,2), 'color', cc(j*delta,:))
        case 3
            plot(result.MA.cycle(i).data(:,3), result.MA.cycle(i).data(:,2), 'color', cc(j*delta,:))
        case 4
           plot(result.RMS.cycle(i).data(:,3), result.RMS.cycle(i).data(:,2), 'color', cc(j*delta,:))
        case 5
           plot(result.RMS_s.cycle(i).data(:,3), result.RMS_s.cycle(i).data(:,2), 'color', cc(j*delta,:))           
    end
    legendString{j} = sprintf('Cycle %d', i);
    j = j + 1;
end
hold off;
legend(legendString); grid on;



