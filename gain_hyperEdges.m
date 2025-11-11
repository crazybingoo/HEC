clc; clear;
close all;

% File name of the hyperedge list
txtFilename = 'D:\wcldematlab\keep\new_idea\new_2\cat-edge-vegas-bars-reviews\hyperedges.txt';

% Open file for reading
fileID = fopen(txtFilename, 'r');
if fileID == -1
    error('Cannot open file: %s', txtFilename);
end

% Initialize cell array to store hyperedges (one hyperedge per line)
hyperEdges = {};

lineIndex = 1;
while ~feof(fileID)
    % Read current line as text
    currentLine = fgetl(fileID);
    if ~ischar(currentLine)
        break;  % safety check
    end
    
    % Split line by spaces (change delimiter if needed)
    splitLine = strsplit(strtrim(currentLine), ' ');
    
    % Convert to numeric and store in cell array
    hyperEdges{lineIndex} = str2double(splitLine);
    
    lineIndex = lineIndex + 1;
end

% Close file
fclose(fileID);

% Now "hyperEdges" is a cell array, where each cell is a row vector
% of node indices for one hyperedge.
