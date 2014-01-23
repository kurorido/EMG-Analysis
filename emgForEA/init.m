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

TEST_CASE_FILE = 'E:\FTP\emgCode\test_case_file.xlsx';
SUBJECT_FILE_FOLDER = 'L:\PRE-TEST\';
OUTPUT_FILE_FOLDER = 'E:\FTP\emgCode\output\';
TASK_NUM = 2;

%% configuration
fs = 960;

%% Don't Touch
% Load subject list
[~, ~, rawTable] = xlsread(TEST_CASE_FILE);
SUBJECT_LIST = transpose(rawTable(:,1));