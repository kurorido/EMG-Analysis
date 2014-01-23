% Input:
%	filteredEMG
%	startMarker
%   endMarker
% Output:
%   resultEA
%	resultEA.totalEA
%	resultEA.detailEA

function [resultEA] = calcEA(filteredEMG, startMarker, endMarker, fs)

% for debug
% startMarker = marker(1);
% endMarker = marker(2);

muscleEMG = filteredEMG(:,1:2); % only want first and second column
muscleEMG = abs(muscleEMG);

timeIndex1 = find(muscleEMG(:,1) - startMarker > 0);
timeIndex1 = timeIndex1(1);
timeIndex2 = find(muscleEMG(:,1) - endMarker > 0);
timeIndex2 = timeIndex2(2);

tmp = trapz(muscleEMG(timeIndex1:timeIndex2, 1), muscleEMG(timeIndex1:timeIndex2, 2));
resultEA.totalEA = tmp / (muscleEMG(timeIndex2, 1) - muscleEMG(timeIndex1, 1));

% For each fs sample, calculate a EA
detailEA = [];
for i = timeIndex1 : fs : timeIndex2
	tmp = trapz(muscleEMG(i:i+fs, 1), muscleEMG(i:i+fs, 2));
	tmp = tmp / fs;
	detailEA = [detailEA tmp];
end

resultEA.detailEA = detailEA;