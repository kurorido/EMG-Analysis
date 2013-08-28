function [result] = emgLE_old(filteredEMG, timeMarker, fs, fLow, MVE)
% emgLE calculate the time domain EMG parameter - Linear Envelope by
% passing the filtered EMG data through a low-pass filter.

error(nargchk(4,5,nargin));

rectifiedEMG = abs(filteredEMG);

if nargin == 5
    rectifiedEMG = 100 *(rectifiedEMG/MVE);
end

time = (1:length(rectifiedEMG))'/fs;

fn=fs/2;    %Hz - Nyquist Frequency - 1/2 Sampling Frequency

[B,A]= butter(3,fLow/fn, 'low'); 

linEnv = zeros(length(time),2);
linEnv(:,2)=filtfilt(B,A,rectifiedEMG);
linEnv(:,1) =  time;

for ii = 1: length(timeMarker)
    kk = ii +1;
    if kk > length(timeMarker)
        break;
    end
    
   gc = linEnv( find( timeMarker(ii) < time & time < timeMarker(kk)), :);
   duration = (timeMarker(kk) - timeMarker(ii));
   gc(:,1) = (100*( gc(:,1) - timeMarker(ii)) / duration) ;
   [peak, index] = max ( gc(:,2));
   time2Peak = gc(index,1);
   area = trapz(gc(:,2));
   
    result.cycle(ii).data = gc;
    result.cycle(ii).duration = timeMarker(ii:kk);
    result.cycle(ii).mean = mean ( gc(:,2));
    result.cycle(ii).peak = peak;
    result.cycle(ii).time2Peak = time2Peak;
    result.cycle(ii).area = area;
        
end