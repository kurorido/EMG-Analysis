
%%%%%% apparently, LE and MA is more adequate in gait analysis
%%%%%  EA and RMS introduces a dealy depending on the specific time windows

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate MVE value using the RMS method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% latest updated - 10/29/2012 - think how to seg GC into diff stages

%% setup the constants
fs = 960;
windowLength = 50;
fLow = 10;
duration = 3000;
shift = 1000;
beginCycle = 3;
endCycle = 7;
%%

%%   obatain values required for normalization 
markerTemp = dlmread('..\MVC\MVC_marker.txt'); % 12 values match 12 MVC files - 2 files for each muscle

temp_1 = load('..\MVC\B02-1-MVC-RF-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-RF-two.asc','-ascii');
RFMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow, duration, shift,'RF','mean');
%RFMVE1 = MVE(temp_1, temp_2, markerTemp, fs, windowLength, duration, shift,'RF','all');
%plot(RFMVE1.EA.rep(1).data(:,1),RFMVE1.EA.rep(1).data(:,2), RFMVE1.LE.rep(1).data(:,1),RFMVE1.LE.rep(1).data(:,2),RFMVE1.MA.rep(1).data(:,1),RFMVE1.MA.rep(1).data(:,2),RFMVE1.RMS.rep(1).data(:,1),RFMVE1.RMS.rep(1).data(:,2))
%legend('EA', 'LE', 'MA', 'RMS')

temp_1 = load('..\MVC\B02-1-MVC-BF-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-BF-two.asc','-ascii');
BFMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow,duration, shift,'BF','mean');
 
temp_1 = load('..\MVC\B02-1-MVC-TA-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-TA-two.asc','-ascii');
TAMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow, duration, shift,'TA','mean');

temp_1 = load('..\MVC\B02-1-MVC-GAS-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-GAS-two.asc','-ascii');
GASMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow, duration, shift,'GAS','mean');

temp_1 = load('..\MVC\B02-1-MVC-ES-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-ES-two.asc','-ascii');
ESMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow, duration, shift,'ES','mean');

temp_1 = load('..\MVC\B02-1-MVC-RA-one.asc','-ascii');
temp_2 = load('..\MVC\B02-1-MVC-RA-two.asc','-ascii');
RAMVE = MVE(temp_1, temp_2, markerTemp, fs, windowLength, fLow, duration, shift,'RA','mean');
%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate time-domain parameters - EA or LE 
% make sure the locaiton of RF. BF is correct
% make sure the MVE value is selected correctly from the MVE array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load '..\B02-1-sk-stair-down-one.asc' -ascii

rf = abs(B02_1_sk_stair_down_one(:,[1 2]));
bf = abs(B02_1_sk_stair_down_one(:,[1 3]));
ta = abs(B02_1_sk_stair_down_one(:,[1 4]));
gas = abs(B02_1_sk_stair_down_one(:,[1 5]));
es = abs(B02_1_sk_stair_down_one(:,[1 6]));
ra = abs(B02_1_sk_stair_down_one(:,[1 7]));

%marker information - only the first column will be used, rest 11 cols
%belong to?
% the time info should already be shifted back to EMG time line from MVN time line  

load '..\time_byMVN.txt' -ascii
marker = time_byMVN(:,1);


%%%%%%%%%%%%%%% EA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

result.RF.EA = emgEA(rf, marker, 960, 50, 'marker', RFMVE(1));
result.BF.EA = emgEA(bf, marker, 960, 50, 'marker', BFMVE(1));
result.TA.EA = emgEA(ta, marker, 960, 50, 'marker', TAMVE(1));
result.GAS.EA = emgEA(gas, marker, 960, 50, 'marker', GASMVE(1));
result.ES.EA = emgEA(es, marker, 960, 50, 'marker', ESMVE(1));
result.RA.EA = emgEA(ra, marker, 960, 50, 'marker', RAMVE(1));


%%%%%%%%%%% Hof et al 2002 low-pass filter =< 25hz
%%%%%%%%%%% but bandwidth of 10hz seems more resemble to the original trace

result.RF.LE = emgLE(rf, marker, fs, fLow, 'marker', RFMVE(2));
%result.RF.LE_old = emgLE_old(rf(:,2), marker, 960, 10, RFMVE(2));
%plot(result.RF.LE.cycle(1,1).LE.data(:,3),result.RF.LE.cycle(1,1).LE.data(:,2),result.RF.LE_old.cycle(1,1).data(:,1),result.RF.LE_old.cycle(1,1).data(:,2))

result.BF.LE = emgLE(bf, marker, fs, fLow, 'marker', BFMVE(2));
result.TA.LE = emgLE(ta, marker, fs, fLow, 'marker', TAMVE(2));
result.GAS.LE = emgLE(gas, marker, fs, fLow, 'marker', GASMVE(2));
result.ES.LE = emgLE(es, marker, fs, fLow, 'marker',ESMVE(2));
result.RA.LE = emgLE(ra, marker, fs, fLow, 'marker', RAMVE(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% centered moving average with a fixed time window
result.RF.MA = emgMA(rf, marker, 960, 50, 'marker', RFMVE(3));
result.BF.MA = emgMA(bf, marker, 960, 50, 'marker', BFMVE(3));
result.TA.MA = emgMA(ta, marker, 960, 50, 'marker', TAMVE(3));
result.GAS.MA = emgMA(gas, marker, 960, 50, 'marker', GASMVE(3));
result.ES.MA = emgMA(es, marker, 960, 50, 'marker', ESMVE(3));
result.RA.MA = emgMA(ra, marker, 960, 50, 'marker', RAMVE(3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% RMS with a fixed time window shift 
%%%%%%%%%%% change to emgRMS_slide for using the centered method

result.RF.RMS = emgRMS(rf, marker, fs, windowLength, 'marker', RFMVE(4));
%result.RF.RMS_new = emgRMS_new(rf, marker, 960, 50, RFMVE(4));
%plot(result.RF.RMS.cycle(1,1).RMS.data(:,3), result.RF.RMS.cycle(1,1).RMS.data(:,2))
result.BF.RMS = emgRMS(bf, marker, 960, 50, 'marker', BFMVE(4));
%result.BF.RMS_s = emgRMS_slide(bf, marker, 960, 50, 'marker', BFMVE(4));
result.TA.RMS = emgRMS(ta, marker, 960, 50, 'marker', TAMVE(4));
result.GAS.RMS = emgRMS(gas, marker, 960, 50, 'marker', GASMVE(4));
result.ES.RMS = emgRMS(es, marker, 960, 50, 'marker', ESMVE(4));
result.RA.RMS = emgRMS(ra, marker, 960, 50, 'marker', RAMVE(4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure(1);
plot(result.TA.LE.cycle(1).data(:,1), result.TA.LE.cycle(1).data(:,2),result.TA.LE.cycle(2).data(:,1), result.TA.LE.cycle(2).data(:,2), result.TA.LE.cycle(3).data(:,1), result.TA.LE.cycle(3).data(:,2))
legend ('cycle 1', 'cycle 2', 'cycle 3'); grid on;

figure(2);
plot(result.RF.EA.cycle(4).data(:,3), result.RF.EA.cycle(4).data(:,2),result.RF.EA.cycle(5).data(:,3), result.RF.EA.cycle(5).data(:,2), result.RF.EA.cycle(6).data(:,3), result.RF.EA.cycle(6).data(:,2))
legend ('cycle 4', 'cycle 5', 'cycle 6'); grid on;

figure(3);
plot(result.BF.EA.cycle(4).data(:,3), result.BF.EA.cycle(4).data(:,2),result.BF.LE.cycle(4).data(:,3), result.BF.LE.cycle(4).data(:,2),result.BF.MA.cycle(4).data(:,3), result.BF.MA.cycle(4).data(:,2), result.BF.RMS.cycle(4).data(:,3), result.BF.RMS.cycle(4).data(:,2))
hold on;
plot(result.BF.RMS_s.cycle(4).data(:,3), result.BF.RMS_s.cycle(4).data(:,2),'k*');
hold off;
legend ('EA', 'LE','MA', 'RMS'); grid on;


%%

%%
%%%%%%%%% calculate mean, median values for all cycles and then
%%%%%%%%% combine all info into one dataset

figure(4);
plot(result.BF.LE.cycle(1).data(:,3), result.BF.LE.cycle(1).data(:,2), result.BF.LE.cycle(2).data(:,3), result.BF.LE.cycle(2).data(:,2), result.BF.LE.cycle(3).data(:,3), result.BF.LE.cycle(3).data(:,2));
hold on;
plot(result.BF.LE.cycle(4).data(:,3), result.BF.LE.cycle(4).data(:,2),result.BF.LE.cycle(5).data(:,3), result.BF.LE.cycle(5).data(:,2),result.BF.LE.cycle(6).data(:,3), result.BF.LE.cycle(6).data(:,2));
hold on;
plot(result.BF.LE.cycle(7).data(:,3), result.BF.LE.cycle(7).data(:,2),result.BF.LE.cycle(8).data(:,3), result.BF.LE.cycle(8).data(:,2),result.BF.LE.cycle(9).data(:,3), result.BF.LE.cycle(9).data(:,2));
hold off;
legend ('cycle 1', 'cycle 2', 'cycle 3','cycle 4', 'cycle 5', 'cycle 6','cycle 7', 'cycle 8', 'cycle 9'); grid on;


[qq, parameterSAS] = cycleReduce(result, 3, 7);

figure(5);
plot(qq.RF.LE.medianCycle.data(:,1), qq.RF.LE.medianCycle.data(:,2) ,'-b')
hold on
errorbar(qq.RF.LE.meanCycle.data(:,1), qq.RF.LE.meanCycle.data(:,2),qq.RF.LE.stdCycle.data(:,2),'xr')
hold on
errorbar(qq.RF.LE.meanCycle.data(:,1), qq.RF.LE.meanCycle.data(:,2), qq.RF.LE.stdCycle.data(:,2)/sqrt(7-3),'--g')
hold off
legend('median Cycle', 'mean Cycle with SD', 'mean Cycle with SE')
axis ([0 100 -10 60]);grid on;
 

%% 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Generate the final struct array (finalResult) containing all data processed 

%%%%%%%%% and then write summary stat data to an excel file, where

%%%%%%%%% row contents - BF, RF, TA, GAS, ES. RA (the same order as the inputed data file from the SciWork)
%%%%%%%%% column contents -   mean, peak, time2Peak, min, range, area, VR
%%%%%%%%% sheet contents -   EA. LE, MA, RMS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear finalResult
fn1 = fieldnames(qq);
fn2 = fieldnames(qq.BF);
for ii = 1:length(fn1)
    for jj = 1: length(fn2)
        finalResult.(fn1{ii}).(fn2{jj}) = setfield (qq.(fn1{ii}).(fn2{jj}),'cycle', getfield(result.(fn1{ii}).(fn2{jj}), 'cycle') );
    end
end

save matlabResult;  % save all matlab-generated data for later retrived
% load matlabResult;

xlsFile = 'parameterOut.xls';
for ii = 1:length(fn2)
     xlswrite (xlsFile, parameterSAS(:,:,ii), fn2{ii})
end

dos(['start ' xlsFile]); % open the generated excel file


figure(6)
plot(finalResult.BF.RMS.cycle(3).data(:,3), finalResult.BF.RMS.cycle(3).data(:,2),finalResult.BF.RMS.cycle(5).data(:,3), finalResult.BF.RMS.cycle(5).data(:,2), finalResult.BF.RMS.cycle(7).data(:,3),finalResult.BF.RMS.cycle(7).data(:,2))
hold on;
plot(finalResult.BF.RMS.medianCycle.data(:,1), finalResult.BF.RMS.medianCycle.data(:,2), finalResult.BF.RMS.meanCycle.data(:,1), finalResult.BF.RMS.meanCycle.data(:,2))
hold off;
legend('Cycle 3','Cycle 5','Cycle 7','Median GC', 'Mean GC');
axis ([0 100 0 60]);grid on;

%%

clear all;clc;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compare all muscles %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6)
subplot(2,3,1)
plot(finalResult.RF.EA.medianCycle.data(:,1), finalResult.RF.EA.medianCycle.data(:,2), finalResult.RF.LE.medianCycle.data(:,1), finalResult.RF.LE.medianCycle.data(:,2),finalResult.RF.MA.medianCycle.data(:,1), finalResult.RF.MA.medianCycle.data(:,2), finalResult.RF.RMS.medianCycle.data(:,1), finalResult.RF.RMS.medianCycle.data(:,2))
axis([0 100 0 25]);
title('Within-session average of GC for RF')
legend('EA','LE', 'MA', 'RMS')
grid on

subplot(2,3,4)
plot(finalResult.BF.EA.medianCycle.data(:,1), finalResult.BF.EA.medianCycle.data(:,2), finalResult.BF.LE.medianCycle.data(:,1), finalResult.BF.LE.medianCycle.data(:,2),finalResult.BF.MA.medianCycle.data(:,1), finalResult.BF.MA.medianCycle.data(:,2), finalResult.BF.RMS.medianCycle.data(:,1), finalResult.BF.RMS.medianCycle.data(:,2))
axis([0 100 0 25]);
title('Within-session average of GC for BF')
legend('EA','LE', 'MA', 'RMS')
grid on

subplot(2,3,2)
plot(finalResult.TA.EA.medianCycle.data(:,1), finalResult.TA.EA.medianCycle.data(:,2), finalResult.TA.LE.medianCycle.data(:,1), finalResult.TA.LE.medianCycle.data(:,2),finalResult.TA.MA.medianCycle.data(:,1), finalResult.TA.MA.medianCycle.data(:,2), finalResult.TA.RMS.medianCycle.data(:,1), finalResult.TA.RMS.medianCycle.data(:,2))
axis([0 100 0 25]);
title('Within-session average of GC for TA')
legend('EA','LE', 'MA', 'RMS')
grid on

subplot(2,3,5)
plot(finalResult.GAS.EA.medianCycle.data(:,1), finalResult.GAS.EA.medianCycle.data(:,2), finalResult.GAS.LE.medianCycle.data(:,1), finalResult.GAS.LE.medianCycle.data(:,2),finalResult.GAS.MA.medianCycle.data(:,1), finalResult.GAS.MA.medianCycle.data(:,2), finalResult.GAS.RMS.medianCycle.data(:,1), finalResult.GAS.RMS.medianCycle.data(:,2))
axis([0 100 0 50]);
title('Within-session average of GC for GAS')
legend('EA','LE', 'MA', 'RMS')
grid on

subplot(2,3,3)
plot(finalResult.ES.EA.medianCycle.data(:,1), finalResult.ES.EA.medianCycle.data(:,2), finalResult.ES.LE.medianCycle.data(:,1), finalResult.ES.LE.medianCycle.data(:,2),finalResult.ES.MA.medianCycle.data(:,1), finalResult.ES.MA.medianCycle.data(:,2), finalResult.ES.RMS.medianCycle.data(:,1), finalResult.ES.RMS.medianCycle.data(:,2))
axis([0 100 0 25]);
title('Within-session average of GC for ES')
legend('EA','LE', 'MA', 'RMS')
grid on

subplot(2,3,6)
plot(finalResult.RA.EA.medianCycle.data(:,1), finalResult.RA.EA.medianCycle.data(:,2), finalResult.RA.LE.medianCycle.data(:,1), finalResult.RA.LE.medianCycle.data(:,2), finalResult.RA.RMS.medianCycle.data(:,1), finalResult.RA.RMS.medianCycle.data(:,2),finalResult.RA.MA.medianCycle.data(:,1), finalResult.RA.MA.medianCycle.data(:,2))
axis([0 100 0 10]);
title('Within-session average of GC for RA')
legend('EA','LE', 'MA', 'RMS')
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 




ts2 = timeseries(gc(:,2), gc(:,1));
ts2_res = resample(ts2, 1:100))



%%%%%%%%%%%%%%%%%%%%%%%% casual system - lag3 moving average
a = 1;
b = [1/4 1/4 1/4 1/4];
y = filter(b,a,result.BF.EA.cycle(1).data(:,2));
plot(result.BF.EA.cycle(1).data(:,1), result.BF.EA.cycle(1).data(:,2), result.BF.EA.cycle(1).data(:,1), y)
legend('original GC', 'lag-3 moving average GC')

%%%%%%%%%%%%%%%%%%%%%% transfer nonequal-spaced GCs into equal-spaced GCs
temp1=0
n = 0
out = zeros(100,2,length(result.BF.LE.cycle));


 for jj = 1:length(result.BF.LE.cycle)
     qq = getfield(result.BF.LE.cycle, {jj},'data');
     for kk=1:length(out)
         for ii = 1:length(qq)
             if qq(ii,1) > kk-1 & qq(ii,1) < kk
                 temp1 = temp1 + qq(ii,2);
                 n = n +1;
             end
             out(kk,1,jj) = kk;
             out(kk,2,jj) = temp1/n;
         end
         temp1 = 0;
         n = 0;
     end
 end
 

%%%%%% nonequal-spaced GC vs equal-space GC (unit:1% GC) 
figure(4)
plot(result.BF.LE.cycle(1).data(:,1),result.BF.LE.cycle(1).data(:,2), out(:,1,1), out(:,2,1))


%%%%%%%%%%%%%%%% retrive the data from the struct array %%%%%%%%%%%%%%%%%%%%
nSample = length(result.BF.LE.cycle);
for i= 1: nSample
    resultLE(i,:) = [i result.BF.LE.cycle(i).time2Peak  result.BF.LE.cycle(i).peak  result.BF.LE.cycle(i).area ];
end

figure(3)
subplot(3,1,1); bar(resultLE(:,3)); grid on;axis([-inf, inf, 0,0.15]);title('max value in each gait cycle');
subplot(3,1,2); bar(resultLE(:,2)); grid on;axis([-inf, inf, 0,100]);title('normalized time to the max value in each gait cycle');
subplot(3,1,3); bar(resultLE(:,4)); grid on;axis([-inf, inf, 0,50]);title('area under the linear envelop per cycle');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate the mean peak LE from all cycles
mean([result.BF.LE.cycle.peak])    

getfield(result.BF.LE.cycle, {3},'peak')
result.BF.LE.cycle(3).peak

getfield(result.BF.LE.cycle, {1},'data',{1:3})

qq = getfield(result.BF.LE.cycle, {1},'data');

%%%%%%%%%%%%%%% EA  - nonequal-spaced EA for 1st GC vs equal-space EA for 1st GC (unit:1% GC via
%%%%%%%%%%%%%%% spline interpolation) vs equal-spaced LE for 1st GC
 
out = zeros(2,100,length(result.BF.EA.cycle));
for ii= 1:length(result.BF.EA.cycle)
    aa  = result.BF.EA.cycle(ii).data;
    out(:,:,ii) = [1:100 ; interp1(aa(:,1), aa(:,2), 1:100, 'spline')];
end


figure(3)
plot( result.BF.EA.cycle(2).data(:,1), result.BF.EA.cycle(2).data(:,2), out(1,:,2), out(2,:,2));
legend('original EA', 'spline EA', 'original LE')
grid on

 
%%%%%% average GC with error bar
figure(6)
errorbar(meanGC(1,:), meanGC(2,:), stdGC(2,:), 'xr');
axis tight
grid on
