% UT  - 1
% PCH - 2
% BRA - 3
% MD  - 4
% PD  - 5
% TRI - 6
% SS  - 7
MUSCLE_LIST(1) = {'UT'};
MUSCLE_LIST(2) = {'PCH'}; 
MUSCLE_LIST(3) = {'AD'};
MUSCLE_LIST(4) = {'MD'};
MUSCLE_LIST(5) = {'PD'};
MUSCLE_LIST(6) = {'BI'};
MUSCLE_LIST(7) = {'SS'};

TEST_CASE_FILE = 'E:\FTP\EMG-Analysis\emgForEA\test_case_file.xlsx';
SPECIAL_CASE_FILE = 'E:\FTP\EMG-Analysis\emgForEA\special_case.xlsx';
SUBJECT_FILE_FOLDER = 'M:\PRE-TEST\';
OUTPUT_FILE_FOLDER = 'M:\PRE-TEST\output\';
TASK_NUM = 2;

%% configuration
fs = 960;

%% Don't Touch
% Load subject list
[~, ~, rawTable] = xlsread(TEST_CASE_FILE);
SUBJECT_LIST = transpose(rawTable(:,1));

SPECIAL_CASE_LIST = struct;
[~, ~, specialTable] = xlsread(SPECIAL_CASE_FILE);
for i = 1 : size(specialTable, 1)
    SPECIAL_CASE_LIST.(specialTable{i,1}).(specialTable{i,2}).(specialTable{i,3}) = 1;
end