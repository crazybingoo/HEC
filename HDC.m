function node_degree = HDC(num_nodes, hyperEdges)
% HDC  Hypergraph degree centrality for each node.
%
%   node_degree = HDC(num_nodes, hyperEdges)
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
%       node_degree - Column vector of size (num_nodes x 1) containing
%                     the degree of each node, defined as the number of
%                     hyperedges in which that node appears.
%
%   DESCRIPTION
%       This function computes a simple hypergraph degree centrality:
%
%           HDC(i) = number of hyperedges that contain node i.
%
%       If a node appears multiple times in the same hyperedge (which is
%       unusual in standard hypergraph definitions), this implementation
%       counts it only once per hyperedge.
%
%   EXAMPLE
%       num_nodes  = 5;
%       hyperEdges = { [1 2 3], [2 4], [1 5] };
%       node_degree = HDC(num_nodes, hyperEdges);
%
%   See also: HCC, HGC, VC

    % Initialize degree vector
    node_degree = zeros(num_nodes, 1);

    % Accumulate degrees
    for e = 1:length(hyperEdges)
        edge = hyperEdges{e};
        edge = unique(edge);  % ensure each node is counted once per hyperedge
        for j = 1:length(edge)
            node = edge(j);
            node_degree(node) = node_degree(node) + 1;
        end
    end

end

