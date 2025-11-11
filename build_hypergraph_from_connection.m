function [hyperEdges, connection_initial_index] = build_hypergraph_from_connection(connection_matrix)
% BUILD_HYPERGRAPH_FROM_CONNECTION  Construct 2- and 3-node hyperedges.
%
%   [hyperEdges, connection_initial_index] = build_hypergraph_from_connection(connection_matrix)
%
%   INPUT
%       connection_matrix      - dc x dc binary adjacency matrix.
%
%   OUTPUT
%       hyperEdges             - cell array of hyperedges (each is a row vector of node indices).
%       connection_initial_index - M x 3 matrix of triangle-based 3-node hyperedges.

    kk = size(connection_matrix, 1);
    d = [];

    % Find triangles (3-cliques)
    for i = 1:kk
        for j = 1:kk
            for k = 1:kk
                if connection_matrix(i,j) && connection_matrix(i,k) && connection_matrix(j,k) == 1
                    b = [i j k];
                    d = [d; b];
                end
            end
        end
    end

    connection_initial_index = unique(sort(d, 2), 'rows', 'stable');

    % 3-node hyperedges
    M = size(connection_initial_index, 1);
    hyperEdges_dim3 = mat2cell(connection_initial_index, ones(1, M), 3)';

    % 2-node hyperedges from edges
    [row, col] = find(triu(connection_matrix, 1));
    hyperEdges_dim2 = arrayfun(@(i) [row(i), col(i)], 1:length(row), 'UniformOutput', false);

    % Combine
    hyperEdges = [hyperEdges_dim3; hyperEdges_dim2(:)];
end
