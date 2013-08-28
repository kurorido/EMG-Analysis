function [result] = calMedianCycle(cycleStruct, cycles)

% cycleStruct = handles.result; cycles = getSplitCycles('1,2,3,4,5');

fn2 = fieldnames(cycleStruct); % indicator field (ex: EA, LE, MA, RMS, RMS_s)

% Go through each indicator
for j = 1 : length(fn2)
	
	out = zeros(100,2, length(cycles)); % initial a array for output
	nn = 0;
	
	for kk = 1 : length(cycles) % Go thorugh each cycle
		
		nn = nn +1;
		
		% get a cycle data
		aa  = cycleStruct.(fn2{j}).cycle(cycles{kk}).data;
		
		if size(aa,2) > 2 
			out(:,:,nn) = [1:100 ; interp1(aa(:,3), aa(:,2), 1:100, 'pchip') ]';
        else
			out(:,:,nn) = [1:100 ; interp1(aa(:,1), aa(:,2), 1:100, 'pchip') ]';
		end
		
	end
	
	% Calculate mean, median, std
    meanGC = mean(out,3);
    medianGC = median(out,3);
    stdGC = std(out,0, 3);
	
	% mean, P50, std, P5, P95, P10, P90, max(peak), min, time2peak, area
	% Median Cycle
    result.(fn2{j}).medianCycle.data = medianGC;
    result.(fn2{j}).medianCycle.mean = mean(medianGC(:,2));
    [result.(fn2{j}).medianCycle.peak, result.(fn2{j}).medianCycle.time2Peak] = max(medianGC(:,2));
    result.(fn2{j}).medianCycle.min = min(medianGC(:,2));
    result.(fn2{j}).medianCycle.area = trapz(medianGC(:,1), medianGC(:,2));
	result.(fn2{j}).medianCycle.p5 = prctile(medianGC(:,2), 5);
	result.(fn2{j}).medianCycle.p10 = prctile(medianGC(:,2), 10);
	result.(fn2{j}).medianCycle.p50 = prctile(medianGC(:,2), 50);
	result.(fn2{j}).medianCycle.p90 = prctile(medianGC(:,2), 90);
	result.(fn2{j}).medianCycle.p95 = prctile(medianGC(:,2), 95);
	result.(fn2{j}).medianCycle.std = std(medianGC(:,2));
	
	% Mean Cycle
    result.(fn2{j}).meanCycle.data = mean(out,3);
    result.(fn2{j}).meanCycle.mean = mean(meanGC(:,2));
    [result.(fn2{j}).meanCycle.peak, result.(fn2{j}).meanCycle.time2Peak] = max(meanGC(:,2));
    result.(fn2{j}).meanCycle.min = min(meanGC(:,2));
    result.(fn2{j}).meanCycle.area = trapz(meanGC(:,2));
	result.(fn2{j}).meanCycle.p5 = prctile(meanGC(:,2), 5);
	result.(fn2{j}).meanCycle.p10 = prctile(meanGC(:,2), 10);
	result.(fn2{j}).meanCycle.p50 = prctile(meanGC(:,2), 50);
	result.(fn2{j}).meanCycle.p90 = prctile(meanGC(:,2), 90);
	result.(fn2{j}).meanCycle.p95 = prctile(meanGC(:,2), 95);	
	result.(fn2{j}).meanCycle.std = std(meanGC(:,2));
    
	% std Cycle
    result.(fn2{j}).stdCycle.data = stdGC;
    result.(fn2{j}).stdCycle.mean = mean(stdGC(:,2));
end