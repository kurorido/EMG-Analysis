init; % initialize

% for each subject
for i = 1:length(SUBJECT_LIST)

	% for debug
	% i = 1;
	
	% Initialize Subject Path
	SUBJECT_PATH = strcat(SUBJECT_FILE_FOLDER, SUBJECT_LIST{i} , '\');
    
    % result is a structure for output
    clear result;
    result.subjectName = SUBJECT_LIST{i};
    
    %%%%% Calculate MVC for each muscle
    for j = 1:length(MUSCLE_LIST)
        %%%%%%%% MVC
      	MVC_FILE_PATH = strcat(SUBJECT_PATH , 'PRE\', 'PRE_', MUSCLE_LIST{j}, '.asc');
        MVC_MARKER_PATH = strcat(SUBJECT_PATH , 'PRE\', 'PRE_', MUSCLE_LIST{j}, '_M', '.asc');  
       
		rawEMG = load(MVC_FILE_PATH, '-ascii');
		filteredEMG = filterRawEMG(rawEMG, fs);
		marker = dlmread(MVC_MARKER_PATH);
		marker = transpose(marker);
		firstEA_result = calcEA(filteredEMG, marker(1), marker(2), fs);
        firstEA = firstEA_result.totalEA;
		secondEA_result = calcEA(filteredEMG, marker(3), marker(4), fs);
        secondEA = secondEA_result.totalEA;
		mvcEA = (firstEA + secondEA) / 2;
        
        % Save value into result
        result.MVC.(MUSCLE_LIST{j}).mvcEA = mvcEA;
        
        %%%%%%%% STATIC
        STATIC_FILE_PATH = strcat(SUBJECT_PATH , 'STATIC.asc');
		STATIC_MARKER_PATH = strcat(SUBJECT_PATH , 'STATIC_M.asc');
        static_result = runTask(STATIC_FILE_PATH, STATIC_MARKER_PATH);
        staticEA = static_result.totalEA;
        
        % Save value into result
        result.MVC.(MUSCLE_LIST{j}).staticEA = staticEA;

    end
    
	% for each muscle
	for j = 1:length(MUSCLE_LIST)
	
        TASK_FILE_PATH = strcat(SUBJECT_PATH , 'TASK', j, '\TASK', j ,'.asc');
        TASK_MARKER_PATH = strcat(SUBJECT_PATH , 'TASK', j, '\TASK', j ,'_M.asc');
        task_result = runTask(TASK_FILE_PATH, TASK_MARKER_PATH, j, fs);
        
        result.(strcat('TASK', j)).(MUSCLE_LIST{j}).totalEA = task_result.totalEA;
        result.(strcat('TASK', j)).(MUSCLE_LIST{j}).detailEA = task_result.detailEA;
		% for debug
		% j = 1;
	
		%%%%%%% initialize path
		TASK_1_FILE_PATH = strcat(SUBJECT_PATH , 'TASK1\', 'TASK1.asc');
		TASK_1_MARKER_PATH = strcat(SUBJECT_PATH , 'TASK1\', 'TASK1_M.asc');
		TASK_2_FILE_PATH = strcat(SUBJECT_PATH , 'TASK2\' ,'TASK2.asc');
		TASK_2_MARKER_PATH = strcat(SUBJECT_PATH , 'TASK2\', 'TASK2_M.asc');
		
		%%%%%%%% TASK 1
		rawEMG = load(TASK_1_FILE_PATH, '-ascii');
		rawEMG = rawEMG(:, [1 j+1]);
		filteredEMG = filterRawEMG(rawEMG, fs);
		marker = dlmread(TASK_1_MARKER_PATH);
		marker = transpose(marker);
		task1EA_result = calcEA(filteredEMG, marker(1), marker(2), fs);
		task1EA = task1EA_result.totalEA;
        
        result.(MUSCLE_LIST{j}).task1EA = task1EA;
		
		%%%%%%%% TASK 2
		rawEMG = load(TASK_2_FILE_PATH, '-ascii');
		rawEMG = rawEMG(:, [1 j+1]);
		filteredEMG = filterRawEMG(rawEMG, fs);
		marker = dlmread(TASK_2_MARKER_PATH);
		marker = transpose(marker);
		task2EA_result = calcEA(filteredEMG, marker(1), marker(2), fs);
		task2EA = task2EA_result.totalEA;
        
        result.(MUSCLE_LIST{j}).task2EA = task2EA;
		
		%%%%%%% Plot 
        name = strcat(SUBJECT_LIST{i}, '-EA-', MUSCLE_LIST{j});
		figure('name', name);
		hold on;
		
		%%%%%%%% Plot TASK 1 EA (In 3 minutes)
		detailEA_1 = task1EA_result.detailEA;
		plot(1:length(detailEA_1), detailEA_1);
		
		%%%%%%%% Plot TASK 2 EA (In 3 minutes)
		detailEA_2 = task2EA_result.detailEA;
		plot(1:length(detailEA_2), detailEA_2, 'r');
		
		axis tight;
		
		%%%%%%%% Calculate %MVE
		task1MVE = (task1EA - staticEA) / (mvcEA - staticEA);
		task2MVE = (task2EA - staticEA) / (mvcEA - staticEA);  
        
        result.(MUSCLE_LIST{j}).task2MVE = task2MVE;
        result.(MUSCLE_LIST{j}).task2MVE = task2MVE;
		
    end
    
     %%%%%%%% Export Value to Excel
     % Initalize Output Path
     excelFileName = strcat(OUTPUT_FILE_FOLDER, SUBJECT_LIST{i});

     % if file already exist, don't delete default sheet
     deleteFlag = 1;
     if(exist(excelFileName, 'file') == 2)
          deleteFlag = 0;
     end
     
     header = {'PRE_MVE','POST_MVE','Progress_%MVE','Progress_slope','STATIC_MVE'};
     
     
     
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
	
end