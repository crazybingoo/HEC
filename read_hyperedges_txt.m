function hyperEdges = read_hyperedges_txt(txtFilename, delimiter)
% READ_HYPEREDGES_TXT  Read hyperedges from a text file into a cell array.
%
%   hyperEdges = read_hyperedges_txt(txtFilename, delimiter)
%
%   INPUT
%       txtFilename - Full path to the text file containing hyperedges.
%                     Each line corresponds to one hyperedge, e.g.:
%                         "1 5 10"
%                         "2 3"
%                         "4 7 8 9"
%
%       delimiter   - (optional) Delimiter used to separate node indices
%                     in each line. Default is a space ' '.
%
%   OUTPUT
%       hyperEdges  - Cell array of hyperedges. Each cell contains a row
%                     vector of node indices (double), e.g.:
%                         hyperEdges{1} = [1 5 10]
%                         hyperEdges{2} = [2 3]
%
%   EXAMPLE
%       hyperEdges = read_hyperedges_txt('hyperedges.txt');
%       hyperEdges = read_hyperedges_txt('hyperedges.txt', ',');
%
%   NOTE
%       - Lines are assumed to contain integer node indices separated by
%         the specified delimiter.
%       - Empty lines are skipped.

    if nargin < 2 || isempty(delimiter)
        delimiter = ' ';  % default: space
    end

    fileID = fopen(txtFilename, 'r');
    if fileID == -1
        error('Cannot open file: %s', txtFilename);
    end

    hyperEdges = {};
    lineIndex = 1;

    while ~feof(fileID)
        currentLine = fgetl(fileID);
        if ~ischar(currentLine)
            break;
        end

        currentLine = strtrim(currentLine);
        if isempty(currentLine)
            continue;  % skip empty lines
        end

        % Split by delimiter
        splitLine = strsplit(currentLine, delimiter);

        % Convert to numeric
        nums = str2double(splitLine);

        % Remove possible NaNs (if extra spaces or delimiters)
        nums = nums(~isnan(nums));

        hyperEdges{lineIndex} = nums;
        lineIndex = lineIndex + 1;
    end

    fclose(fileID);
end
