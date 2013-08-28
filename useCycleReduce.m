function [result] = useCycleReduce(handles)

result = handles.result;
muscle = cellstr(handles.muscle_list{handles.selectedMuscle});

muscleResult.target.EA = result.EA;
muscleResult.target.LE = result.LE;
muscleResult.target.MA = result.MA;
muscleResult.target.RMS = result.RMS;
muscleResult.target.RMS_s = result.RMS_s;

startCycle = str2double(get(handles.startCycleEditText,'String'));
endCycle = str2double(get(handles.endCycleEditText,'String'));

[qq, parameterSAS] = cycleReduce(muscleResult, startCycle, endCycle);

list = get(handles.goalList, 'String');
% name = strcat(muscle{1}, '-Median Cycle(', list{get(handles.goalList, 'Value')}, ')' , ' From ' , double2str(startCycle), ' To',  double2str(endCycle));
name = strcat(muscle{1}, '-Median Cycle(', list{get(handles.goalList, 'Value')}, ')');
figure('name', name);

    switch get(handles.goalList, 'Value')
        case 1
            plot(qq.target.EA.medianCycle.data(:,1), qq.target.EA.medianCycle.data(:,2) ,'-b')
            hold on
            errorbar(qq.target.EA.meanCycle.data(:,1), qq.target.EA.meanCycle.data(:,2), qq.target.LE.stdCycle.data(:,2),'xr')
            hold on
            errorbar(qq.target.EA.meanCycle.data(:,1), qq.target.EA.meanCycle.data(:,2), qq.target.LE.stdCycle.data(:,2)/sqrt(7-3),'--g')
            hold off
        case 2
            plot(qq.target.LE.medianCycle.data(:,1), qq.target.LE.medianCycle.data(:,2) ,'-b')
            hold on
            errorbar(qq.target.LE.meanCycle.data(:,1), qq.target.LE.meanCycle.data(:,2), qq.target.LE.stdCycle.data(:,2),'xr')
            hold on
            errorbar(qq.target.LE.meanCycle.data(:,1), qq.target.LE.meanCycle.data(:,2), qq.target.LE.stdCycle.data(:,2)/sqrt(7-3),'--g')
            hold off
        case 3
            plot(qq.target.MA.medianCycle.data(:,1), qq.target.MA.medianCycle.data(:,2) ,'-b')
            hold on
            errorbar(qq.target.MA.meanCycle.data(:,1), qq.target.MA.meanCycle.data(:,2), qq.target.MA.stdCycle.data(:,2),'xr')
            hold on
            errorbar(qq.target.MA.meanCycle.data(:,1), qq.target.MA.meanCycle.data(:,2), qq.target.MA.stdCycle.data(:,2)/sqrt(7-3),'--g')
            hold off
        case 4
            plot(qq.target.RMS.medianCycle.data(:,1), qq.target.RMS.medianCycle.data(:,2) ,'-b')
            hold on
            errorbar(qq.target.RMS.meanCycle.data(:,1), qq.target.RMS.meanCycle.data(:,2), qq.target.RMS.stdCycle.data(:,2),'xr')
            hold on
            errorbar(qq.target.RMS.meanCycle.data(:,1), qq.target.RMS.meanCycle.data(:,2), qq.target.RMS.stdCycle.data(:,2)/sqrt(7-3),'--g')
            hold off
        case 5
            plot(qq.target.RMS_s.medianCycle.data(:,1), qq.target.RMS_s.medianCycle.data(:,2) ,'-b')
            hold on
            errorbar(qq.target.RMS_s.meanCycle.data(:,1), qq.target.RMS_s.meanCycle.data(:,2), qq.target.RMS_s.stdCycle.data(:,2),'xr')
            hold on
            errorbar(qq.target.RMS_s.meanCycle.data(:,1), qq.target.RMS_s.meanCycle.data(:,2), qq.target.RMS_s.stdCycle.data(:,2)/sqrt(7-3),'--g')
            hold off            
    end
    legend('median Cycle', 'mean Cycle with SD', 'mean Cycle with SE')
    axis ([0 100 -10 60]);grid on;