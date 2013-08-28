function exportToExcel(handles)

result = handles.reducedData;
muscle = cellstr(handles.muscle_list{handles.selectedMuscle});
% Excel Output
excelFileName = strcat(handles.filePrefix, handles.fileSuffix, '-', muscle{1}, '.xls');
excelFilePath = handles.output_folder;

% if file already exist, don't delete default sheet
deleteFlag = 1;
if(exist(fullfile(excelFilePath, excelFileName), 'file') == 2)
    deleteFlag = 0;
end
indicators = fieldnames(result); % get indicator
ind_len = length(indicators);
central = {'mean', 'median'};
cycleType = {'meanCycle', 'medianCycle'};
d = {'central method', 'method', 'mean', 'p50','std', 'p5', 'p95', 'p10', 'p90', 'max', 'min', 'time2peak', 'area'};
raw = cell(100, 2 * ind_len); % 100 rows, 2 * ind_len column
raw_header = cell(1, 2 * ind_len);
raw(:,1) = num2cell(1:100);
for c = 1 : 2
	for j = 1 : ind_len
		
		% main data sheet
		row = ind_len * (c-1) + (j+1);
		col = 1;
		% central method
		d(row,col) = { central{c} }; col = col + 1;
		% method
		d(row,col) = { indicators{j} }; col = col + 1;
		% mean, P50, std, P5, P95, P10, P90, max(peak), min, time2peak, area
		d(row,col) = { result.(indicators{j}).(cycleType{c}).mean }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).p50 }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).std }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).p5 }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).p95 }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).p10 }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).p90 }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).peak }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).min }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).time2Peak }; col = col + 1;
		d(row,col) = { result.(indicators{j}).(cycleType{c}).area };
		
		% raw data sheet
        raw_header(1, row) = { strcat(cycleType{c}, '-', indicators{j}) }; % header
		raw(:,row) = num2cell(result.(indicators{j}).(cycleType{c}).data(:,2)); % data
		
	end
end

xlswrite(fullfile(excelFilePath, excelFileName), d, 'Result');
xlswrite(fullfile(excelFilePath, excelFileName), raw, 'Raw', 'A2');
xlswrite(fullfile(excelFilePath, excelFileName), raw_header, 'Raw', 'A1');

% if file not exist, delete default sheet
if(deleteFlag == 1)
    % Delete Default Sheet
    % Open Excel file.
    objExcel = actxserver('Excel.Application');
    objExcel.Workbooks.Open(fullfile(excelFilePath, excelFileName)); % Full path is necessary!

    % Delete sheets.
    try
    % Throws an error if the sheets do not exist.
    objExcel.ActiveWorkbook.Worksheets.Item(1).Delete;
    objExcel.ActiveWorkbook.Worksheets.Item(1).Delete;
    objExcel.ActiveWorkbook.Worksheets.Item(1).Delete;
    catch
    ; % Do nothing.
    end

    % Save, close and clean up.
    objExcel.ActiveWorkbook.Save;
    objExcel.ActiveWorkbook.Close;
    objExcel.Quit;
    objExcel.delete;
end