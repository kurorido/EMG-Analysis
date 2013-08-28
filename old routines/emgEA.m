function [result] = emgEA(filteredEMG, timeMarker, fs, windowLength, MVE)
% emgEA calculate the time domain EMG parameter - Electrical Activity with
% a constant time windows from EMG data filtered by a band-pass filter.

%name = genvarname('filteredEMG');
error(nargchk(4,5,nargin));

rectifiedEMG = abs(filteredEMG(:,2));

time = filteredEMG(:,1);

num = ceil(windowLength/(1000/fs));
indices = 1:num:length(rectifiedEMG);

if length(rectifiedEMG) - indices(end) + 1 < num
    rectifiedEMG(end+1:indices(end)+num-1) = 0; % zero padding
end



EA = zeros(length(indices),3);

index =0;
for ii = indices
    index = index +1;
    EA(index,1)=index*windowLength/1000;
    
    %keyboard
    
    
    if nargin < 5
        EA(index,2) = trapz(rectifiedEMG(ii:(ii + num-1)))/windowLength;
        EA(index, 3) = trapz (filteredEMG( (ii:(ii + num-1)), 1), abs(filteredEMG( (ii:(ii + num-1)), 2)))/0.05;
        
    elseif nargin == 5
        EA(index,2) = 100* ((trapz(rectifiedEMG(ii:(ii + num-1)))/windowLength)/MVE); %normalized to MVE
        EA(index, 3) = (100/MVE) * trapz (filteredEMG( (ii:(ii + num-1)), 1), abs(filteredEMG( (ii:(ii + num-1)), 2)))/0.05;
    end
end


%keyboard

time = EA(:,1);

for ii = 1: length(timeMarker)
    kk = ii +1;
    if kk > length(timeMarker)
        break;
    end
    gc = EA( find( timeMarker(ii) < time & time < timeMarker(kk)), :); % gc with absoutel time unit
    duration = (timeMarker(kk) - timeMarker(ii));
    gc(:,1) = 100*( gc(:,1) - timeMarker(ii)) / duration ;   % covert time unit to % 
    [peak, index] = max ( gc(:,2));
    time2Peak = gc(index,1);
    area = trapz(gc(:,2));
    
    %keyboard
    
    result.cycle(ii).data = gc;
    result.cycle(ii).duration = timeMarker(ii:kk);
    result.cycle(ii).mean = mean ( gc(:,2));
    result.cycle(ii).peak = peak;
    result.cycle(ii).time2Peak = time2Peak;
    result.cycle(ii).area = area;
    
   
end