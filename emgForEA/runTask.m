function [ task_result ] = runTask( TASK_FILE_PATH, TASK_MARKER_PATH, MUSCLE_INDEX, fs, interval, last)
	rawEMG = load(TASK_FILE_PATH, '-ascii');
	rawEMG = rawEMG(:, [1 MUSCLE_INDEX+1]);
	filteredEMG = filterRawEMG(rawEMG, fs);
	marker = dlmread(TASK_MARKER_PATH);
	marker = transpose(marker);
	task_result = calcEA(filteredEMG, marker(1), marker(2), fs, interval, last);
end

