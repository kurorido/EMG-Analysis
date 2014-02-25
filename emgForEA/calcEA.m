% Input:
%	filteredEMG
%	startMarker
%   endMarker
% Output:
%   resultEA
%	resultEA.totalEA
%	resultEA.detailEA

function [resultEA] = calcEA(filteredEMG, startMarker, endMarker, fs, interval, last)

% for debug
%startMarker = marker(1);
%endMarker = marker(2);

muscleEMG = filteredEMG(:,1:2); % only want first and second column
muscleEMG = abs(muscleEMG);

timeIndex1 = find(muscleEMG(:,1) - startMarker > 0);
timeIndex1 = timeIndex1(1);
timeIndex2 = find(muscleEMG(:,1) - endMarker > 0);
timeIndex2 = timeIndex2(2);

tmp = trapz(muscleEMG(timeIndex1:timeIndex2, 1), muscleEMG(timeIndex1:timeIndex2, 2));
resultEA.totalEA = tmp / (muscleEMG(timeIndex2, 1) - muscleEMG(timeIndex1, 1));

% For each step sample, calculate a EA
detailEA = [];
step = fs * (interval / 1000);
if(last == -1)
    for i = timeIndex1 : step : timeIndex2
        tmp = trapz(muscleEMG(i:i+step, 1), muscleEMG(i:i+step, 2));
        tmp = tmp / step;
        detailEA = [detailEA tmp];
    end
else
    currentLast = timeIndex2;
    for i = 1 : (last / (interval / 1000))
        tmp = trapz(muscleEMG(currentLast-step:currentLast, 1), muscleEMG(currentLast-step:currentLast, 2));
        tmp = tmp / step;
        detailEA = [tmp detailEA];
        currentLast = currentLast - step;
    end
end

resultEA.detailEA = detailEA;