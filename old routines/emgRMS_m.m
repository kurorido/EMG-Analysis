



function [result] = emgRMS_m(filteredEMG, timeMarker, fs, windowLength, MVE)
% emgLE calculate the time domain EMG parameter - Linear Envelope by
% passing the filtered EMG data through a low-pass filter.

error(nargchk(4,5,nargin));

RMSfun = inline('sqrt(mean(x.^2))','x') ;

time = (1:length(filteredEMG))'/fs;

cRMS = zeros(length(time),2);
cRMS(:,2)=slidefun(RMSfun,windowLength,filteredEMG)';
cRMS(:,1) =  time;

if nargin == 5
    cRMS(:,2) = 100 *(cRMS(:,2)/MVE);
end

for ii = 1: length(timeMarker)
    kk = ii +1;
    if kk > length(timeMarker)
        break;
    end
    
   gc = cRMS( find( timeMarker(ii) < time & time < timeMarker(kk)), :);
   
   %keyboard
   
   duration = (timeMarker(kk) - timeMarker(ii));
   gc(:,1) = (100*( gc(:,1) - timeMarker(ii)) / duration) ;
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