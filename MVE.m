function [output] = MVE(test_1, test_2, markerTemp, fs, windowLength, fLow,duration, shift, muscle, mode)

test_1 = temp_1;
test_2 = temp_2;
muscle = 'GAS';
mode = 'mean';


%if 'mode' argument does not be provided in the argument list, the function
% will output the max value for that particular duraiton in the order of
% [EA LE MA RMS]

% the numbering for the column for specific muscle had pre-assigned
% in the code

% last updated - 6/01/2013
% - conduct band-passed filtering for input raw EMG data first


% butterworh 3rd order bandpass filter btw 10 and 479Hz
fn=fs/2;    %Hz - Nyquist Frequency - 1/2 Sampling Frequency
[B,A]= butter(3,[10,479]/fn); 
filtered_1 = zeros(size(test_1,1),size(test_1,2));
filtered_1(:, 2:end)=filtfilt(B, A, test_1(:, 2:end)); 
filtered_1(:,1) = test_1(:, 1);
filtered_2 = zeros(size(test_2,1),size(test_2,2));
filtered_2(:, 2:end)=filtfilt(B, A, test_2(:, 2:end)); 
filtered_2(:,1) = test_2(:, 1);
clear A B
% isequal(test_2(:,1), filtered_2(:,1))
% isequal(test_1(:,7), filtered_1(:,7))
% plot(test_2(:,1),test_2(:,4), filtered_2(:,1),filtered_2(:,4))
% legend('raw EMG', 'filtered EMG');grid on;
% plot(test_2(:,1),filtered_2(:,4), filtered_2(:,1),test_2(:,4)- filtered_2(:,4))
% legend('filtered EMG', 'diff btw raw and filtered EMG');grid on;

%keyboard

%error(nargchk(9,10,nargin));
narginchk(9,10);

if strcmp(muscle,'RF')
    marker = markerTemp(1:2);
    muscle_1 = filtered_1(:,1:2);
    muscle_2 = filtered_2(:,1:2);
    
elseif strcmp(muscle,'BF')
    marker = markerTemp(3:4);
    muscle_1 = filtered_1(:,[1 3]);
    muscle_2 = filtered_2(:,[1 3]);
    
elseif strcmp(muscle,'TA')
    marker = markerTemp(5:6);
    muscle_1 = filtered_1(:,[1 4]);
    muscle_2 = filtered_2(:,[1 4]);
    
elseif strcmp(muscle,'GAS')
    marker = markerTemp(7:8);
    muscle_1 = filtered_1(:,[1 5]);
    muscle_2 = filtered_2(:,[1 5]);
    
elseif strcmp(muscle,'ES')
    marker = markerTemp(9:10);
    muscle_1 = filtered_1(:,[1 6]);
    muscle_2 = filtered_2(:,[1 6]);
    
elseif strcmp(muscle,'RA')
    marker = markerTemp(11:12);
    muscle_1 = filtered_1(:,[1 7]);
    muscle_2 = filtered_2(:,[1 7]);
end

markerMVC = [marker+ shift/1000 ; marker + (shift + duration) /1000];

%keyboard

%EA1 = emgEA(muscle_1, markerMVC(:,1), fs, windowLength);
%keyboard
%plot(EA1.cycle.data(:,1), EA1.cycle.data(:,2), EA1_new.cycle.data(:,3), EA1_new.cycle.data(:,2))
%legend('EA1', 'EA1new')

EA1 = emgEA(muscle_1, markerMVC(:,1), fs, windowLength, 'marker');
result.EA.rep(1).data = EA1.cycle(1).data;
result.EA.rep(1).max = max(EA1.cycle(1).data(:,2));
result.EA.rep(1).mean = mean(EA1.cycle(1).data(:,2));

EA2 = emgEA(muscle_2, markerMVC(:,2), fs, windowLength, 'marker'); 
result.EA.rep(2).data = EA2.cycle(1).data;
result.EA.rep(2).max = max(EA2.cycle(1).data(:,2));
result.EA.rep(2).mean = mean(EA2.cycle(1).data(:,2));
             
LE1 = emgLE(muscle_1, markerMVC(:,1), fs, fLow, 'marker');
%LE1_old = emgLE_old(muscle_1(:,2), markerMVC(:,1), fs, fLow);
result.LE.rep(1).data = LE1.cycle(1).data;
result.LE.rep(1).max = LE1.cycle(1).peak;
result.LE.rep(1).mean = LE1.cycle(1).mean;

%plot(LE1.cycle(1).data(:,1), LE1.cycle(1).data(:,2), LE1.cycle(1).LE.data(:,1),LE1.cycle(1).LE.data(:,2))

LE2 = emgLE(muscle_2, markerMVC(:,2), fs, fLow, 'marker');
result.LE.rep(2).data = LE2.cycle(1).data;
result.LE.rep(2).max = LE2.cycle(1).peak;
result.LE.rep(2).mean = LE2.cycle(1).mean;
%plot(LE1.cycle(1).LE.data(:,3),LE1.cycle(1).LE.data(:,2), LE2.cycle(1).LE.data(:,3),LE2.cycle(1).LE.data(:,2))

MA1 = emgMA(muscle_1, markerMVC(:,1), fs, windowLength, 'marker');
result.MA.rep(1).data = MA1.cycle(1).data;
result.MA.rep(1).max = max(MA1.cycle(1).data(:,2));
result.MA.rep(1).mean = mean(MA1.cycle(1).data(:,2));

MA2 = emgMA(muscle_2, markerMVC(:,2), fs, windowLength, 'marker'); 
result.MA.rep(2).data = MA2.cycle(1).data;
result.MA.rep(2).max = max(MA2.cycle(1).data(:,2));
result.MA.rep(2).mean = mean(MA2.cycle(1).data(:,2));

%keyboard

RMS1 = emgRMS(muscle_1, markerMVC(:,1), fs, windowLength, 'marker');
RMS1_s = emgRMS_slide(muscle_1, markerMVC(:,1), fs, windowLength, 'marker');
%RMS1_old = emgRMS_old(muscle_1(:,2), markerMVC(:,1), fs, windowLength);
result.RMS.rep(1).data = RMS1.cycle(1).data;
result.RMS.rep(1).max = RMS1.cycle(1).peak;
result.RMS.rep(1).mean = RMS1.cycle(1).mean;

RMS2 = emgRMS(muscle_2, markerMVC(:,2), fs, windowLength, 'marker'); 
result.RMS.rep(2).data = RMS2.cycle(1).data;
result.RMS.rep(2).max = RMS2.cycle(1).peak;
result.RMS.rep(2).mean = RMS2.cycle(1).mean;

%keyboard
%plot(RMS1_old.cycle.data(:,1),RMS1_old.cycle.data(:,2), RMS1.cycle.RMS.data(:,3),RMS1.cycle.RMS.data(:,2), LE1.cycle.data(:,1),LE1.cycle.data(:,2) )
plot(EA1.cycle.data(:,3), EA1.cycle.data(:,2), LE1.cycle.data(:,3),LE1.cycle.data(:,2),MA1.cycle.data(:,3), MA1.cycle.data(:,2),RMS1.cycle.data(:,3),RMS1.cycle.data(:,2), RMS1_s.cycle.data(:,3),RMS1_s.cycle.data(:,2))
legend('EA1', 'LE1', 'MA1', 'RMS1', 'RMS1_s');grid on;

if nargin < 10
    output(1) = max([result.EA.rep.max]);
    output(2) = max([result.LE.rep.max]);
    output(3) = max([result.MA.rep.max]);
    output(4) = max([result.RMS.rep.max]);
end

if nargin == 10
    if strcmp(mode,'max')
        output(1) = max([result.EA.rep.max]);
        output(2) = max([result.LE.rep.max]);
        output(3) = max([result.MA.rep.max]);
        output(4) = max([result.RMS.rep.max]);
        
    elseif strcmp(mode,'mean')
        output(1) = mean([result.EA.rep.mean]);
        output(2) = mean([result.LE.rep.mean]);
        output(3) = mean([result.MA.rep.mean]);
        output(4) = mean([result.RMS.rep.mean]);
        
    elseif strcmp(mode,'all')
        output = result;
    end
    
    
end

