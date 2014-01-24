init; % initialize

% for each subject
for i = 1:length(SUBJECT_LIST)

	% for debug
	% i = 1;
	
	% Initialize Subject Path
	SUBJECT_PATH = strcat(SUBJECT_FILE_FOLDER, SUBJECT_LIST{i} , '\');
    
    % result is a structure for output
    clear result;
	clear outputValue;
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
        
        % Save MVC EA value into result
        result.MVC.(MUSCLE_LIST{j}).mvcEA = mvcEA;
        
        %%%%%%%% STATIC
        STATIC_FILE_PATH = strcat(SUBJECT_PATH , 'STATIC.asc');
		STATIC_MARKER_PATH = strcat(SUBJECT_PATH , 'STATIC_M.asc');
        static_result = runTask(STATIC_FILE_PATH, STATIC_MARKER_PATH, j, fs);
        staticEA = static_result.totalEA;
        
        % Save STATIC EA value into result
        result.MVC.(MUSCLE_LIST{j}).staticEA = staticEA;
    end
    %%%%% End Calculate MVC for each muscle
	
	% for each task
	for j = 1:TASK_NUM
	
        TASK_FILE_PATH = strcat(SUBJECT_PATH , 'TASK', int2str(j), '\TASK', int2str(j) ,'.asc');
        TASK_MARKER_PATH = strcat(SUBJECT_PATH , 'TASK',  int2str(j), '\TASK',  int2str(j) ,'_M.asc');
		
        outputValue = cell(length(MUSCLE_LIST), 5);
		% for each muscle
		for k = 1:length(MUSCLE_LIST)
        
            task_result = runTask(TASK_FILE_PATH, TASK_MARKER_PATH, k, fs);
            
			result.(strcat('TASK', int2str(j))).(MUSCLE_LIST{k}).totalEA = task_result.totalEA;
			result.(strcat('TASK', int2str(j))).(MUSCLE_LIST{k}).detailEA = task_result.detailEA;
		
			taskEA = task_result.totalEA;
			detailEA = task_result.detailEA;

			result.(strcat('TASK', int2str(j))).(MUSCLE_LIST{k}).taskEA = taskEA;
		
			%%%%%%%% Calculate %MVE
			taskMVE = (taskEA - result.MVC.(MUSCLE_LIST{k}).staticEA) / (result.MVC.(MUSCLE_LIST{k}).mvcEA - result.MVC.(MUSCLE_LIST{k}).staticEA);

			result.(strcat('TASK', int2str(j))).(MUSCLE_LIST{k}).taskMVE = taskMVE;
			
			%%%%%%% Plot 
			name = strcat(SUBJECT_LIST{i}, '-TASK',  int2str(j), '-', MUSCLE_LIST{k}, '-EA');
			fig = figure('name', name);
			hold on;
			
			%%%%%%%% Plot TASK EA (In 3 minutes)
			plot(1:length(detailEA), detailEA);
			p = polyfit(1:length(detailEA), detailEA,1);
			vectors = polyval(p, 1:length(detailEA));
			plot(1:length(detailEA), vectors, 'r');
			slope = p(1);
			axis tight;
			
			saveas(fig, strcat(OUTPUT_FILE_FOLDER, name), 'jpg');
			
			hold off;
            
            
            %%%%%%% Calculate POST %MVE
            POST_MVE_FILE_PATH = strcat(SUBJECT_PATH , 'TASK', int2str(j), '\TASK', int2str(j) , '_',MUSCLE_LIST{k},'.asc');
            POST_MVE_MARKER_PATH = strcat(SUBJECT_PATH , 'TASK', int2str(j), '\TASK', int2str(j) , '_',MUSCLE_LIST{k}, '_M','.asc');
			
            post_result = runTask(POST_MVE_FILE_PATH, POST_MVE_MARKER_PATH, 1, fs);
            postEA = post_result.totalEA;
            
			outputValue{k, 1} = result.MVC.(MUSCLE_LIST{k}).mvcEA;
            outputValue{k, 2} = postEA;
            outputValue{k, 3} = taskMVE;
            outputValue{k, 4} = slope;
			outputValue{k, 5} = result.MVC.(MUSCLE_LIST{k}).staticEA;
		end
		
		%%%%%%%% Export Task to Excel
		% Initalize Output Path
		excelFileName = strcat(OUTPUT_FILE_FOLDER, SUBJECT_LIST{i}, '.xlsx');

		% if file already exist, don't delete default sheet
		deleteFlag = 1;
		if(exist(excelFileName, 'file') == 2)
			deleteFlag = 0;
		end
		 
		header = {'PRE_MVE','POST_MVE','Progress_%MVE','Progress_slope','STATIC_MVE'};
		 
		%%%% write out to sheet
		xlswrite(fullfile(excelFileName), header, strcat('TASK', int2str(j)), 'B1');
		xlswrite(fullfile(excelFileName), transpose(MUSCLE_LIST), strcat('TASK', int2str(j)), 'A2');
		xlswrite(fullfile(excelFileName), outputValue, strcat('TASK', int2str(j)), 'B2');
		 
		% if file not exist, delete default sheet
		if(deleteFlag == 1)
			% Delete Default Sheet
			% Open Excel file.
			objExcel = actxserver('Excel.Application');
			objExcel.Workbooks.Open(fullfile(excelFileName)); % Full path is necessary!

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
	
end