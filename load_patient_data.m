function X1 = load_patient_data(FileName, chanIdx)
% LOAD_PATIENT_DATA  Load SEEG data and select channels of interest.
%
%   X1 = load_patient_data(FileName, chanIdx)
%
%   INPUT
%       FileName - full path of the .mat file.
%       chanIdx  - row indices of channels to be selected.
%
%   OUTPUT
%       X1       - matrix (channels x time) for selected channels.

    load(FileName);  % assumes the main variable is known/unique

    % You may need to adjust this depending on variable name in the .mat file:
    % Example:
    %   Xraw = wangchun_cut03;
    %   X1   = Xraw(chanIdx, :);

    vars = whos;
    % pick the first non-struct variable as data (you can also hard-code)
    dataVarName = vars(1).name;
    Xraw = eval(dataVarName);

    X1 = Xraw(chanIdx, :);
end
