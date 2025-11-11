function HG_c = HGC(num_nodes, hyperEdges)
% HGC  Hypergraph gravity centrality for each node.
%
%   HG_c = HGC(num_nodes, hyperEdges)
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
%       HG_c       - Column vector of size (num_nodes x 1) containing the
%                    hypergraph gravity centrality of each node.
%
%   DESCRIPTION
%       This function computes a gravity-inspired centrality on a hypergraph.
%       The main steps are:
%
%         1) Compute pairwise distances between hyperedges using
%            compute_edge_distances(hyperEdges).
%
%         2) Compute higher-order node-to-node distances based on hyperedge
%            distances via compute_node_distances(hyperEdges, edgeDistances).
%
%         3) Compute the hypergraph degree centrality for each node using HDC.
%
%         4) For each node i, the hypergraph gravity centrality is defined as
%
%                HGC(i) = sum_{j ¡Ù i}  [ deg(i) * deg(j) / d(i,j)^2 ],
%
%            where deg(i) is the hypergraph degree of node i and d(i,j) is
%            the higher-order distance between nodes i and j.
%
%       Intuitively, nodes with high degree that are close to other
%       high-degree nodes (in the hypergraph sense) will have larger HGC.
%
%   REQUIREMENTS
%       - compute_edge_distances.m
%       - compute_node_distances.m
%       - HDC.m
%
%   See also: HDC, HCC, compute_node_distances, compute_edge_distances
%
%   ------------------------------------------------------------------------

    % 1) Hyperedge-level distances (E x E)
    edgeDistances = compute_edge_distances(hyperEdges);

    % 2) Node-level higher-order distances (N x N)
    nodeDistances = compute_node_distances(hyperEdges, edgeDistances);

    % 3) Hypergraph degree centrality
    node_degree = HDC(num_nodes, hyperEdges);

    % 4) Hypergraph gravity centrality
    HG_c = zeros(num_nodes, 1);

    for i = 1:num_nodes
        for j = 1:num_nodes
            if i ~= j && nodeDistances(i, j) > 0 && ~isinf(nodeDistances(i, j))
                HG_c(i) = HG_c(i) + ...
                    (node_degree(i) * node_degree(j)) / (nodeDistances(i, j)^2);
            end
        end
    end
end
