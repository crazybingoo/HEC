function nodeDistances = compute_node_distances(hyperEdges, edgeDistances)
% COMPUTE_NODE_DISTANCES  Compute higher-order distances between nodes in a hypergraph.
%
%   nodeDistances = compute_node_distances(hyperEdges, edgeDistances)
%
%   INPUT
%       hyperEdges    - Cell array of hyperedges. Each element is a row
%                      vector of node indices, e.g.:
%                          hyperEdges = { [1 2 3], [2 4], [3 5 6], ... }.
%
%       edgeDistances - Matrix of pairwise distances between hyperedges,
%                      of size E x E, where E = length(hyperEdges).
%                      edgeDistances(e1, e2) encodes the distance between
%                      hyperedge e1 and hyperedge e2.
%
%   OUTPUT
%       nodeDistances - Matrix of pairwise distances between nodes,
%                      of size N x N, where N is the number of nodes
%                      (inferred from hyperEdges). nodeDistances(i, j)
%                      represents the higher-order distance between
%                      node i and node j.
%
%   DESCRIPTION
%       This function computes node-to-node distances in a hypergraph
%       using distances between hyperedges:
%
%         - The number of nodes N is inferred as the maximum node index
%           present in all hyperedges.
%         - If two nodes i and j appear in at least one common hyperedge,
%           their distance is set to 1.
%         - Otherwise, their distance is defined as:
%
%                1 + min_{e1 ∋ i, e2 ∋ j} edgeDistances(e1, e2)
%
%           i.e., one step to move from node i to a hyperedge containing i,
%           plus the minimal hyperedge-to-hyperedge distance, plus one step
%           to reach node j.
%
%       The diagonal nodeDistances(i, i) is set to 0 for all i.
%
%   NOTE
%       - The implementation is straightforward and may be computationally
%         expensive for large hypergraphs (triple nested loops over nodes
%         and hyperedges).
%       - It assumes node indices in hyperEdges are positive integers that
%         are consistent with the indexing of nodeDistances.
%
%   See also: graph, distances

    % Infer the number of nodes from the maximum node index appearing
    % in all hyperedges
    numNodes = max(cellfun(@max, hyperEdges));

    % Number of hyperedges
    numHyperEdges = length(hyperEdges); %#ok<NASGU> % kept for clarity if needed later

    % Initialize node distance matrix with infinity
    nodeDistances = inf(numNodes, numNodes);

    % Distance from a node to itself is zero
    for i = 1:numNodes
        nodeDistances(i, i) = 0;
    end

    % Precompute which hyperedges contain each node (for efficiency)
    % nodeToEdges{i} = list of hyperedge indices that contain node i
    nodeToEdges = cell(numNodes, 1);
    for e = 1:length(hyperEdges)
        nodesInEdge = hyperEdges{e};
        for n = nodesInEdge(:)'
            nodeToEdges{n} = [nodeToEdges{n}, e];
        end
    end

    % Compute node-to-node distances
    for i = 1:numNodes
        for j = 1:numNodes
            if i ~= j
                edgesContainingI = nodeToEdges{i};
                edgesContainingJ = nodeToEdges{j};

                % If i and j are in at least one common hyperedge, distance = 1
                if ~isempty(intersect(edgesContainingI, edgesContainingJ))
                    nodeDistances(i, j) = 1;
                else
                    % Otherwise, use hyperedge distances + 1
                    minDistance = inf;
                    for e1 = edgesContainingI
                        for e2 = edgesContainingJ
                            minDistance = min(minDistance, edgeDistances(e1, e2) + 1);
                        end
                    end
                    nodeDistances(i, j) = minDistance;
                end
            end
        end
    end
end
