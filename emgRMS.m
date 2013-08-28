function [result] = emgRMS(filteredEMG, duration, fs, windowLength, type, MVE)
% EMGRMS calculate the time domain EMG parameter - RMS with 
% a constant time window (ie. not moving method) from EMG data filtered by a band-pass filter.
% 
% filtered EMG have 2 columns - 1st one is time, 2nd one is EMG data

% type: 'marker' or 'fixed' (seperated data into sections with fixed length) 

% MVE: can be scalr or 1-by-2 vector (use slient data for normalization)


% v2.1    - 10.29.2012
% v2.2    - 6/5/2013
%         - include the error check for MVE argument

% RMS(index,1) = temp.cycle(kk).duration(1) + passedTime;
% change to  RMS(index,1) = temp.cycle(kk).data(1,1) + passedTime;

%name = genvarname('filteredEMG');

narginchk(5,6);

if nargin < 6
    rectifiedEMG = abs(filteredEMG(:,2));
elseif nargin ==6
    
    n =length(MVE);
    if n ==1
        %rectifiedEMG = 100*(abs(filteredEMG(:,2))./MVE); % normalized to MVE
        % tempo change - backpack data has time info in the 1st column
        % what does this mean? 6/5/2013
               
        rectifiedEMG = 100*(abs(filteredEMG(:,2))./MVE); % normalized to MVE
        
    elseif n == 2
        if MVE(1) > MVE(2)  
            rectifiedEMG = 100*((abs(filteredEMG(:,2)) -MVE(2))./ (MVE(1) - MVE(2)));
        else error ('the MVE vector should be in the max min] format')
        end
    else
        error ('the input MVE var should be either [max] or [max min] only')
    end
    %keyboard
end
    
time = filteredEMG(:,1);
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
    seg = tempEMG( find( (tempTimeMarker(ii) < time) & (time < tempTimeMarker(jj))), :);
    temp.cycle(ii).data =seg;
    temp.cycle(ii).duration = [tempTimeMarker(ii) tempTimeMarker(jj)];
    if jj == length(tempTimeMarker)
        break
    end
end

%keyboard

%zero padding for all segments
num = ceil(windowLength/(1000/fs));
% for ii=1:length(temp.cycle)
%     indices = 1:num:length(temp.cycle(ii).data); 
%     %keyboard
%     if length(temp.cycle(ii).data) - indices(end) + 1 < num
%         temp.cycle(ii).data(indices(end):end, :) = []; % remove those data points less than the window length 
%         %temp.cycle(ii).data(end+1:indices(end)+num-1, 1) = temp.cycle(ii).data(end,1);  % zero padding -1
%         %temp.cycle(ii).data(end+1:indices(end)+num-1, 2) = 0; % zero padding -2
%     end
% end

% calculate RMS with a constant window for all segments
for kk =1:length(temp.cycle)
    
    indices = 1:num:length(temp.cycle(kk).data);
    n = size(temp.cycle(kk).data,1);
    
    RMS = zeros(length(indices),3);
    index =0;
    for ii = indices
        index = index +1;
        if index ~=  size(indices,2)
            passedTime = temp.cycle(kk).data((ii + num-1),1) - temp.cycle(kk).data(1,1);
            RMS(index,1) = temp.cycle(kk).data(1,1) + passedTime;
            RMS(index,2) = rms( temp.cycle(kk).data(ii:(ii + num-1), 2) ); % calculate the RMS            
        else
            passedTime = temp.cycle(kk).data(n,1) - temp.cycle(kk).data(1,1);
            RMS(index,1) = temp.cycle(kk).data(1,1) + passedTime;
            %keyboard
            RMS(index,2) = rms(temp.cycle(kk).data(ii:n, 2) ); 
        end
            
%         temp.cycle(kk).RMS.data=RMS;
%         temp.cycle(kk).RMS.data(:,3) = 100*( temp.cycle(kk).RMS.data(:,1) - temp.cycle(kk).duration(1)) / (temp.cycle(kk).RMS.data(end,1)- temp.cycle(kk).duration(1));  % covert time unit to % 
%         temp.cycle(kk).RMS.mean = mean ( temp.cycle(kk).RMS.data(:,2));
%         [peak, pindex] = max(temp.cycle(kk).RMS.data(:,2));
%         temp.cycle(kk).RMS.peak = peak;
%         temp.cycle(kk).RMS.time2Peak = temp.cycle(kk).RMS.data(pindex,3);
%         temp.cycle(kk).RMS.area = trapz(temp.cycle(kk).RMS.data(:,1), temp.cycle(kk).RMS.data(:,2) );
%         keyboard
%         note - move to the outer loop in the next

    end
    %keyboard
    
    result.cycle(kk).data=RMS;
    result.cycle(kk).duration = temp.cycle(kk).duration;
    result.cycle(kk).data(:,3) = 100*( result.cycle(kk).data(:,1) - temp.cycle(kk).duration(1)) / (temp.cycle(kk).duration(end)- temp.cycle(kk).duration(1));  % covert time unit to % 
    result.cycle(kk).mean = mean ( result.cycle(kk).data(:,2));
    [peak, pindex] = max(result.cycle(kk).data(:,2));
    result.cycle(kk).peak = peak;
    result.cycle(kk).time2Peak = result.cycle(kk).data(pindex,3);
    result.cycle(kk).area = trapz(result.cycle(kk).data(:,1), result.cycle(kk).data(:,2) );
    result.cycle(kk).median = median ( result.cycle(kk).data(:,2));
    result.cycle(kk).p10 = prctile ( result.cycle(kk).data(:,2), 10);
    result.cycle(kk).p90 = prctile ( result.cycle(kk).data(:,2), 90);
    result.cycle(kk).range = prctile ( result.cycle(kk).data(:,2), 95) - prctile ( result.cycle(kk).data(:,2), 5);
    result.cycle(kk).var = var ( result.cycle(kk).data(:,2));
    
    %keyboard
    
    %% Microbreaks may be quantified as EMG activity lower than 0.5% MVC for 0.2 seconds or longer
    logIndx = result.cycle(kk).data(: , 2) < 0.5;
    count = [];
    jj=0;
    for ii=1: size(logIndx,1)        
        if logIndx(ii,1) == 1       
            jj = jj+1;
        else
            if jj ~=0
                count = [ count jj ];
            end
            jj=0;
        end
    end
    if jj ~=0
        count = [ count jj];
    end
    
    count (( count.* windowLength ) < 200 ) = 0;
    %keyboard
    result.cycle(kk).gap = sum(count) / size (logIndx,1);     
    %%
        
end

%keyboard
%result = temp;

end





