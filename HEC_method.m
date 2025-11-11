function [combined_matrix, nodes_vector] = HEC_method(connection_matrix, connection_initial_index)
%HEC_method   Hyperedge-based Exponential Centrality (HEC) for node importance.
%
%   [combined_matrix, nodes_vector] = HEC_method(connection_matrix, connection_initial_index)
%
%   INPUT
%       connection_matrix         - Adjacency matrix of the original graph
%                                   (used to construct the first set of hyperedges).
%       connection_initial_index  - Matrix containing an additional set of
%                                   hyperedges (e.g., initial hyperedge indices).
%
%   OUTPUT
%       combined_matrix           - Matrix storing all hyperedges and their
%                                   associated features:
%                                     cols 1¨C3 : node indices in each hyperedge
%                                     col 4    : Laplacian energy centrality (rescaled)
%                                     col 5    : sum of shortest-path distances
%                                     col 6    : exponential model value
%       nodes_vector              - Node-level importance scores obtained by
%                                   aggregating hyperedge scores.
%
%   This function:
%       1) Converts the adjacency matrix into a hyperedge incidence matrix;
%       2) Builds a hyperedge adjacency graph of hyperedges and computes the Laplacian
%          energy centrality for each hyperedge;
%       3) Computes the sum of shortest-path distances between hyperedges;
%       4) Combines these features through an exponential model;
%       5) Maps hyperedge scores back to node-level importance.
%
%   NOTE:
%       - Functions convert_adj_matrix_to_edges and generate_line_graph
%         must be available on the MATLAB path.
%       - The parameter beta in the exponential model must be defined
%         in the workspace or added as an input argument.
%       - The parameter dc (number of nodes) is currently fixed to 20 and
%         should be modified if the graph size changes.

    %% Construct hyperedge adjacency graph adjacency_matrix and combined_matrix

    % Convert adjacency matrix to a hyperedge matrix
    hyperedges_matrix_1 = convert_adj_matrix_to_edges(connection_matrix);

    % Second hyperedge matrix is given as input
    hyperedges_matrix_2 = connection_initial_index;

    % Build hyperedge adjacency graph from hyperedges
    adjacency_matrix = generate_line_graph(hyperedges_matrix_1, hyperedges_matrix_2);

    % Concatenate the two hyperedge matrices into a combined matrix
    [num_edges_1, cols_1] = size(hyperedges_matrix_1);
    [num_edges_2, cols_2] = size(hyperedges_matrix_2);
    combined_matrix = zeros(num_edges_1 + num_edges_2, max(cols_1, cols_2));

    combined_matrix(1:num_edges_1, 1:cols_1) = hyperedges_matrix_1;
    combined_matrix((num_edges_1 + 1):(num_edges_1 + num_edges_2), 1:cols_2) = hyperedges_matrix_2;

    %% Build hyperedge adjacency graph

    G = graph(adjacency_matrix);
    % plot(G, 'Layout', 'force'); % force-directed layout (optional)

    %% Third Laplacian energy centrality

    D = eig(full(laplacian(graph(adjacency_matrix))));
    E = sum(D.^3);
    original_matrix = adjacency_matrix; % store original adjacency matrix

    LC = zeros(size(adjacency_matrix, 1), 1);

    for i = 1:size(adjacency_matrix, 1)

        % Remove i-th node from the hyperedge adjacency graph
        adjacency_matrix(i, :) = [];
        adjacency_matrix(:, i) = [];

        % Recompute Laplacian eigenvalues and energy
        D_i = eig(full(laplacian(graph(adjacency_matrix))));
        E_i = sum(D_i.^3);

        % Laplacian energy centrality contribution of node i
        LC(i, :) = E - E_i;

        % Restore original adjacency matrix
        adjacency_matrix = original_matrix;

    end

    % Rescale LC to [0, 1]
    LC_rescaled = rescale(LC, 0, 1);

    % Store LC in the 4th column of combined_matrix
    combined_matrix(:, 4) = LC_rescaled;

    %% Shortest-path distances in the hyperedge adjacency graph

    % Number of nodes in the hyperedge adjacency graph
    num_nodes = numnodes(G);

    % Column vector storing the sum of shortest-path lengths for each node
    sum_of_shortest_paths = zeros(num_nodes, 1);

    % Compute sum of shortest-path lengths from each node to all others
    for source = 1:num_nodes
        shortest_paths = distances(G, source);
        sum_of_shortest_paths(source) = sum(shortest_paths);
    end

    % Store shortest-path sums in the 5th column
    combined_matrix(:, 5) = sum_of_shortest_paths;

    %% Exponential model

    alpha = 1;
    % beta must be defined elsewhere or added as an input parameter
    e_model = alpha * LC_rescaled .* exp(-beta * sum_of_shortest_paths);

    % Store exponential model values in the 6th column
    combined_matrix(:, 6) = e_model;

    %% Map hyperedge scores back to node-level scores

    dc = 20;  % number of nodes (modify as needed)

    % Preallocate containers
    result_cell = cell(dc, 1);
    non_zero_count_per_row = cell(dc, 1);
    sixth_column = cell(dc, 1);
    result_vector = cell(dc, 1);
    nodes_vector = zeros(dc, 1);

    for i = 1:dc
        % Logical index: rows where any of the first three columns equals i
        logical_index = any(combined_matrix(:, 1:3) == i, 2);

        % Extract hyperedges containing node i
        result_cell{i} = combined_matrix(logical_index, :);

        % First three columns correspond to node indices in the hyperedge
        first_three_columns = result_cell{i}(:, 1:3);

        % Count non-zero entries per row (hyperedge size)
        non_zero_count_per_row{i} = sum(first_three_columns ~= 0, 2);

        % Extract the sixth column (exponential model values)
        sixth_column{i} = result_cell{i}(:, 6);

        % Normalize by hyperedge size
        result_vector{i} = sixth_column{i} ./ non_zero_count_per_row{i};

        % Aggregate to obtain the node-level score
        nodes_vector(i, :) = sum(result_vector{i});
    end

    % figure;
    % plot(nodes_vector,'-r*');

end
