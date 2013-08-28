function [subStrings] = getSplitCycles(string)

delimiter = ',';    % For tabs, use: delimiter = sprintf('\t');

% Find the delimiters
delimIdx = find(string == delimiter);

% Pretend there are delimiters at the beginning and end, for the loop below
delimIdx = [0  delimIdx  length(string)+1];

% Preallocate cell array to hold substrings
subStrings = cell(1, length(delimIdx) - 1);

% Process each element
for i = 1:length(subStrings)

    % Find the text between the delimiters
    %(don't include the delimiters)
    startOffset = delimIdx(i)   + 1;
    endOffset   = delimIdx(i+1) - 1;

    % Get the element
    txt = string(startOffset:endOffset);

    % Attempt conversion to number
    num = sscanf(txt, '%f');

    % Number conversion successful if no error message
    if isempty(num)
        subStrings{i} = txt;
    else
        subStrings{i} = num;
    end

end