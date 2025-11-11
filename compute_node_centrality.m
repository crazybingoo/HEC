function nodes_vector = compute_node_centrality(num_nodes, hyperEdges, method, connection_matrix, triIndex)
% COMPUTE_NODE_CENTRALITY  Wrapper to compute node-level centrality.
%
%   nodes_vector = compute_node_centrality(num_nodes, hyperEdges, method, ...
%                                          connection_matrix, triIndex)
%
%   INPUT
%       num_nodes        - number of nodes in the hypergraph.
%       hyperEdges       - cell array of hyperedges.
%       method           - 'HDC', 'HGC', 'VC', 'HCC', 'HEC', etc.
%       connection_matrix- (optional) adjacency matrix (needed for some methods).
%       triIndex         - (optional) triangle index (for HEC, etc.).
%
%   OUTPUT
%       nodes_vector     - column vector of node centrality scores.

    switch upper(method)
        case 'HDC'
            nodes_vector = HDC(num_nodes, hyperEdges);

        case 'HGC'
            nodes_vector = HGC(num_nodes, hyperEdges);

        case 'VC'
            nodes_vector = VC(num_nodes, hyperEdges);

        case 'HCC'
            nodes_vector = HCC(num_nodes, hyperEdges);

        case 'HEC'
            % Requires connection_matrix and triIndex to be passed in
            if nargin < 5
                error('HEC1 requires connection_matrix and triIndex (connection_initial_index).');
            end
            [combined_matrix, nodes_vector] = HEC_method(connection_matrix, triIndex);
            %#ok<NASGU> % combined_matrix not used here

        otherwise
            error('Unknown centrality method: %s', method);
    end
end
