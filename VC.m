function vector_centrality = VC(num_nodes, hyperEdges)
% VC  Hypergraph vector centrality for each node.
%
%   vector_centrality = VC(num_nodes, hyperEdges)
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
%       vector_centrality - Column vector of size (num_nodes x 1)
%                          containing the vector centrality of each node.
%
%   DESCRIPTION
%       This function implements a simple hyperedge-based vector centrality:
%
%         1) For each hyperedge e, we define its centrality as
%
%                c_e = |e| / (sum over all hyperedges of |e|),
%
%            i.e., hyperedge centrality is proportional to its size and
%            normalized across all hyperedges.
%
%         2) The contribution of hyperedge e to node i is then defined as
%
%                c_e / |e|    if i ¡Ê e,
%                0            otherwise.
%
%            Thus, the contribution is evenly distributed among all nodes
%            within that hyperedge.
%
%         3) For each node i, the vector centrality is given by the sum of
%            its contributions over all incident hyperedges:
%
%                VC(i) = sum_{e: i ¡Ê e} (c_e / |e|).
%
%       Intuitively, nodes that participate in many large hyperedges will
%       have larger vector centrality.
%
%   EXAMPLE
%       num_nodes  = 5;
%       hyperEdges = { [1 2 3], [2 4], [1 5] };
%       vc = VC(num_nodes, hyperEdges);
%
%   See also: HDC, HCC, HGC
%
%   ------------------------------------------------------------------------

    % Number of hyperedges
    num_edges = length(hyperEdges);

    % Hyperedge sizes
    edge_sizes = cellfun(@length, hyperEdges);

    % Hyperedge centrality (normalized by total hyperedge size)
    edge_centrality = edge_sizes / sum(edge_sizes);

    % Node-hyperedge contribution matrix
    % node_vector_centrality(i, j) = contribution of hyperedge j to node i
    node_vector_centrality = zeros(num_nodes, num_edges);

    % Distribute each hyperedge's centrality equally among its nodes
    for j = 1:num_edges
        edge = hyperEdges{j};
        edge = unique(edge);   % ensure no duplicates within a hyperedge
        for i = edge
            node_vector_centrality(i, j) = edge_centrality(j) / length(edge);
        end
    end

    % Aggregate contributions for each node
    vector_centrality = zeros(num_nodes, 1);
    for i = 1:num_nodes
        related_edges = any(node_vector_centrality(i, :), 1);  % hyperedges incident to node i
        vector_centrality(i) = sum(node_vector_centrality(i, related_edges));
    end
end
