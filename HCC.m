function hypercloseness = HCC(num_nodes, hyperEdges)
% HCC  Compute hypergraph closeness centrality for each node.
%
%   hypercloseness = HCC(num_nodes, hyperEdges)
%
%   INPUT
%       num_nodes  - Number of nodes in the hypergraph. Nodes are assumed
%                    to be indexed from 1 to num_nodes.
%
%       hyperEdges - Cell array of hyperedges. Each cell contains a row
%                    vector with the node indices belonging to that
%                    hyperedge, e.g.:
%                        hyperEdges = { [1 2 5], [2 3], [1 4 6], ... }.
%
%   OUTPUT
%       hypercloseness - Column vector of size (num_nodes x 1) containing
%                        the hypergraph closeness centrality of each node.
%
%   DESCRIPTION
%       This function computes a closeness-type centrality on a hypergraph:
%
%       1) A node每node distance matrix is constructed by connecting any
%          pair of nodes that co-occur in at least one hyperedge with
%          distance = 1 (i.e., projection of the hypergraph onto a simple
%          graph).
%
%       2) The all-pairs shortest path distances are computed using the
%          Floyd每Warshall algorithm.
%
%       3) For each node i, the hypergraph closeness centrality is defined as
%
%              C(i) = (N - 1) / sum_j d(i, j)
%
%          where N is the number of nodes and d(i, j) is the shortest-path
%          distance between nodes i and j in the projected graph.
%
%       Nodes that are not connected to the rest of the graph (infinite
%       distance to some nodes) are assigned zero centrality.
%
%   NOTE
%       - This implementation uses Floyd每Warshall (O(N^3)), which is
%         suitable for moderate-sized graphs. For large N, consider using
%         more efficient shortest-path algorithms on sparse graphs
%         (e.g. repeated Dijkstra).
%
%   See also: graph, distances

    % ---------------------------------------------------------------------
    % 1. Initialize node每node distance matrix
    % ---------------------------------------------------------------------
    distance_matrix = inf(num_nodes);   % start with +Inf

    % For each hyperedge, connect all node pairs within the hyperedge
    for e = 1:length(hyperEdges)
        edge = hyperEdges{e};
        edge = unique(edge);   % ensure no duplicates inside one hyperedge
        for j = 1:length(edge)
            for k = j+1:length(edge)
                node1 = edge(j);
                node2 = edge(k);
                distance_matrix(node1, node2) = 1;
                distance_matrix(node2, node1) = 1;
            end
        end
    end

    % Set diagonal to zero: distance from a node to itself
    for i = 1:num_nodes
        distance_matrix(i, i) = 0;
    end

    % ---------------------------------------------------------------------
    % 2. Floyd每Warshall algorithm for all-pairs shortest paths
    % ---------------------------------------------------------------------
    for k = 1:num_nodes
        for i = 1:num_nodes
            for j = 1:num_nodes
                if distance_matrix(i, j) > distance_matrix(i, k) + distance_matrix(k, j)
                    distance_matrix(i, j) = distance_matrix(i, k) + distance_matrix(k, j);
                end
            end
        end
    end

    % ---------------------------------------------------------------------
    % 3. Compute hypergraph closeness centrality
    % ---------------------------------------------------------------------
    hypercloseness = zeros(num_nodes, 1);

    for i = 1:num_nodes
        rowDistances = distance_matrix(i, :);

        % If some nodes are unreachable (Inf), treat sum as Inf
        if any(isinf(rowDistances))
            hypercloseness(i) = 0;
        else
            sum_distances = sum(rowDistances);
            if sum_distances > 0
                hypercloseness(i) = (num_nodes - 1) / sum_distances;
            else
                hypercloseness(i) = 0;
            end
        end
    end

end
