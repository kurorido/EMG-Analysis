function [result] = emgLE(inputEMG, duration, fs, fLow, type, MVE)
% emgLE calculate the time domain EMG parameter - Linear Envelope by
% passing the filtered EMG data through a low-pass filter.

% v1.1      10/28/2012 - fix the time column problem
% v1.2      6/5/2013   - do the low-passed filtering first, then the
%                        normalization procedure

time = inputEMG(:,1);
absEMG = abs(inputEMG(:,2));

fn=fs/2;    %Hz - Nyquist Frequency - 1/2 Sampling Frequency
[B,A]= butter(3,fLow/fn, 'low'); 
filteredEMG = zeros(length(time),2);
filteredEMG(:,2)=filtfilt(B,A, absEMG );
filteredEMG(:,1) =  time;

%keyboard
%plot(time, absEMG,time, filteredEMG(:,2));figure(gcf)


narginchk(5,6);

if nargin == 5
    rectifiedEMG = filteredEMG(:,2);
elseif nargin ==6 % normalized to MVE 
    n =length(MVE);
    if n ==1
        rectifiedEMG = 100*(filteredEMG(:,2)./MVE);        
    elseif n == 2
        rectifiedEMG = 100*((filteredEMG(:,2) -MVE(2))./ (MVE(1) - MVE(2)));
    else
        error ('the input MVE var should be either [max] or [max min] only')
    end
    %keyboard
end

tempEMG = [time rectifiedEMG];


if strcmp(type,'marker')
    if time(end) > duration(end)
        tempTimeMarker = duration;
    else duration(end) = time(end);
        tempTimeMarker = duration;
    end    
elseif strcmp(type, 'fixed') % creat a vector from beign time to end time with equal duration sepeated 
    tempTimeMarker = [time(1): duration: time(end) time(end)];
end

%keyboard


for ii=1:length(tempTimeMarker)
    jj = ii+1;
    if jj > length(tempTimeMarker)
        break
    end
    %seg = tempEMG( find( (tempTimeMarker(ii) < time) & (time < tempTimeMarker(jj))), :);
    logIndx = (tempTimeMarker(ii) < time) & (time < tempTimeMarker(jj));
    
    %temp.cycle(ii).data =filteredEMG( logIndx,:);
    temp.cycle(ii).data=tempEMG( logIndx, :);
    temp.cycle(ii).duration = [tempTimeMarker(ii) tempTimeMarker(jj)];
    temp.cycle(ii).data(:,3) = 100*( temp.cycle(ii).data(:,1) - temp.cycle(ii).duration(1)) / (temp.cycle(ii).duration(end)- temp.cycle(ii).duration(1));  % covert time unit to % 
    temp.cycle(ii).mean = mean ( temp.cycle(ii).data(:,2));
    [peak, pindex] = max(temp.cycle(ii).data(:,2));
    temp.cycle(ii).peak = peak;
    temp.cycle(ii).time2Peak = temp.cycle(ii).data(pindex,3);
    temp.cycle(ii).area = trapz(temp.cycle(ii).data(:,1), temp.cycle(ii).data(:,2) ); 
    temp.cycle(ii).median = median ( temp.cycle(ii).data(:,2));
    temp.cycle(ii).p10 = prctile ( temp.cycle(ii).data(:,2), 10);
    temp.cycle(ii).p90 = prctile ( temp.cycle(ii).data(:,2), 90);
    temp.cycle(ii).range = prctile ( temp.cycle(ii).data(:,2), 95) - prctile ( temp.cycle(ii).data(:,2), 5);
    temp.cycle(ii).var = var ( temp.cycle(ii).data(:,2));
end


result =temp;

end
