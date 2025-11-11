function [connection_matrix, threshold] = build_connection_matrix(plvMatrix, perc)
% BUILD_CONNECTION_MATRIX  Threshold PLV matrix to obtain binary connections.
%
%   [connection_matrix, threshold] = build_connection_matrix(plvMatrix, perc)
%
%   INPUT
%       plvMatrix - dc x dc PLV matrix.
%       perc      - percentile (0–1) used to define threshold
%                   e.g., perc = 0.65 means keep top 35% non-zero entries.
%
%   OUTPUT
%       connection_matrix - dc x dc binary matrix.
%       threshold         - PLV threshold used.

    dc = size(plvMatrix, 1);

    % Remove diagonal
    plvMatrix_noDiag = plvMatrix - eye(dc);
    upperPart = triu(plvMatrix_noDiag);
    vec = reshape(upperPart, [], 1);
    sorted_vec = sort(vec, 'descend');
    nonZero_sorted_vec = sorted_vec(sorted_vec ~= 0);

    threshold = nonZero_sorted_vec(round(size(nonZero_sorted_vec, 1) * perc), 1);

    % Build binary connection matrix
    connection_matrix = plvMatrix >= threshold;
    connection_matrix = connection_matrix - eye(dc);  % remove self-loops
end
