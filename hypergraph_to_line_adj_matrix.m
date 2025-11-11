function line_adj_matrix = hypergraph_to_line_adj_matrix(adj_tensor)
%HYPERGRAPH_TO_LINE_ADJ_MATRIX  Construct 1-line graph adjacency from a 3-uniform hypergraph.
%
%   line_adj_matrix = hypergraph_to_line_adj_matrix(adj_tensor)
%
%   INPUT
%       adj_tensor       - Adjacency tensor of a 3-uniform hypergraph,
%                          of size v x v x v, where v is the number of vertices.
%                          A value adj_tensor(i,j,k) = 1 indicates the presence
%                          of a hyperedge {i,j,k}.
%
%   OUTPUT
%       line_adj_matrix  - Adjacency matrix of the 1-line graph, of size e x e,
%                          where e is the number of hyperedges in the hypergraph.
%                          Each node in the line graph represents a hyperedge,
%                          and two nodes are connected if the corresponding
%                          hyperedges share at least one common vertex.
%
%   DESCRIPTION
%       This function:
%         1) Counts the number of hyperedges e from the adjacency tensor;
%         2) Initializes an e-by-e zero matrix;
%         3) For each hyperedge, finds all other hyperedges that share at
%            least one vertex with it;
%         4) Marks these pairs as adjacent in the 1-line graph adjacency
%            matrix.
%
%   NOTE
%       - The implementation assumes a 3-uniform hypergraph (each hyperedge
%         contains exactly three vertices).
%       - The current implementation uses multiple nested loops and may be
%         computationally expensive for large v.
%
%   See also: graph

    % Number of vertices
    v = size(adj_tensor, 1);

    % ---------------------------------------------------------------------
    % Step 1: Count the number of hyperedges
    % ---------------------------------------------------------------------
    e = 0;  % number of hyperedges, initialized to 0

    for i = 1:v
        for j = 1:v
            for k = 1:v
                if adj_tensor(i, j, k) == 1
                    e = e + 1;
                end
            end
        end
    end

    % ---------------------------------------------------------------------
    % Step 2: Initialize adjacency matrix of the 1-line graph
    % ---------------------------------------------------------------------
    line_adj_matrix = zeros(e, e);

    % ---------------------------------------------------------------------
    % Step 3: Traverse the adjacency tensor and construct the 1-line graph
    % ---------------------------------------------------------------------
    edge_index = 0;  % index of the current hyperedge (will range from 1 to e)

    for i = 1:v
        for j = 1:v
            for k = 1:v
                if adj_tensor(i, j, k) == 1

                    % Current hyperedge index
                    edge_index = edge_index + 1;

                    % Search for other hyperedges that share any vertex with {i, j, k}
                    for m = 1:v
                        for n = 1:v
                            for o = 1:v
                                if adj_tensor(m, n, o) == 1

                                    % Check if there is at least one shared vertex
                                    if (i == m || i == n || i == o) || ...
                                       (j == m || j == n || j == o) || ...
                                       (k == m || k == n || k == o)

                                        % -------------------------------------------------
                                        % Compute the index of the other hyperedge
                                        % (i.e., the index of {m, n, o} in the ordering)
                                        % -------------------------------------------------
                                        other_edge_index = 0;
                                        for p = 1:m
                                            for q = 1:n
                                                for r = 1:o
                                                    if adj_tensor(p, q, r) == 1
                                                        other_edge_index = other_edge_index + 1;
                                                    end
                                                end
                                            end
                                        end

                                        % Mark the connection in the 1-line graph
                                        line_adj_matrix(edge_index, other_edge_index) = 1;
                                        line_adj_matrix(other_edge_index, edge_index) = 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

end
