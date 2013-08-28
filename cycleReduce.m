function [result, parameterSAS ] = cycleReduce(cycleStruct, beginCycle, endCycle)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% M1: cycleReduce(cycleStruct) - all available cycles in the input array
% M2: cycleReduce(cycleStruct, beginCycle, endCycle)

% result - a structure arrays with medianCycle, meanCycle, 
%         and stdCycle (for VR, variability ratio, Merlo et al 2007)
% 
% parameter - summary descriptive stats from median Cycle 
%              it is [x, y, z] matrix 
%              x - parameter   y- spec muscle
%              z - EMG method (EA, LE, MA, RMS)

%v1.1 - 10/29/2012

 

fn1 = fieldnames(cycleStruct);

%fn2 = fieldnames(cycleStruct.RF); %%% this need to be made more flexible
fn2 = fieldnames(cycleStruct.(fn1{1})); 


narginchk(1,3);

if nargin == 1
    beginCycle = 1
    endCycle = length(cycleStruct.(fn1{1}).(fn2{1}).cycle)
    num = endCycle - beginCycle +1;
else
    num =  endCycle - beginCycle +1;
    
end
    

%parameter = zeros(3, length(fn2)*2,length(fn1));


%%
for kk = 1: length(fn2)
    for jj = 1: length(fn1)
        %num = length(cycleStruct.(fn1{jj}).EA.cycle);
        out = zeros(100,2, num);
        nn = 0;
        for ii= beginCycle:endCycle
            nn = nn +1;
            aa  = cycleStruct.(fn1{jj}).(fn2{kk}).cycle(ii).data; 
            if size(aa,2) > 2 
                out(:,:,nn) = [1:100 ; interp1(aa(:,3), aa(:,2), 1:100, 'pchip') ]';
            else  out(:,:,nn) = [1:100 ; interp1(aa(:,1), aa(:,2), 1:100, 'pchip') ]';
            end
        end
        
        meanGC = mean(out,3);
        medianGC = median(out,3);
        stdGC = std(out,0, 3);
        result.(fn1{jj}).(fn2{kk}).medianCycle.data = medianGC;      
        result.(fn1{jj}).(fn2{kk}).medianCycle.mean = mean(medianGC(:,2));
        [result.(fn1{jj}).(fn2{kk}).medianCycle.peak, result.(fn1{jj}).(fn2{kk}).medianCycle.time2Peak] = max(medianGC(:,2));
        result.(fn1{jj}).(fn2{kk}).medianCycle.min = min(medianGC(:,2));
        result.(fn1{jj}).(fn2{kk}).medianCycle.range = result.(fn1{jj}).(fn2{kk}).medianCycle.peak - result.(fn1{jj}).(fn2{kk}).medianCycle.min;
        result.(fn1{jj}).(fn2{kk}).medianCycle.area = trapz(medianGC(:,1), medianGC(:,2));
        
        result.(fn1{jj}).(fn2{kk}).meanCycle.data = mean(out,3);
        result.(fn1{jj}).(fn2{kk}).meanCycle.mean = mean(meanGC(:,2));
        [result.(fn1{jj}).(fn2{kk}).meanCycle.peak, result.(fn1{jj}).(fn2{kk}).meanCycle.time2Peak] = max(meanGC(:,2));
        result.(fn1{jj}).(fn2{kk}).meanCycle.min = min(meanGC(:,2));
        result.(fn1{jj}).(fn2{kk}).meanCycle.area = trapz(meanGC(:,2));
        
        result.(fn1{jj}).(fn2{kk}).stdCycle.data = stdGC; 
        result.(fn1{jj}).(fn2{kk}).stdCycle.mean = mean( stdGC(:,2) );
        
        if nargout == 2
            parameter (1, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'mean');
            parameter (2, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'peak');
            parameter (3, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'time2Peak');
            parameter (4, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'min');
            parameter (5, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'range');
            parameter (6, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).medianCycle,'area');
            parameter (7, jj, kk) = getfield(result.(fn1{jj}).(fn2{kk}).stdCycle,'mean'); % this is VA
        end
            
end
    
    
end
%%

%keyboard
%test = reshape(1:12,3,[])
%b = flipdim(rot90(test,3),2)

for mm= 1:size(parameter,3)
    %keyboard
    parameterSAS(:,:,mm) = flipdim(rot90(parameter(:,:,mm),3),2);
end

end






