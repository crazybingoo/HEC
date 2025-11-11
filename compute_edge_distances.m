function edgeDistances = compute_edge_distances(hyperEdges)
    numEdges = length(hyperEdges);
    
    % Initialize edge distances matrix
    edgeDistances = inf(numEdges, numEdges);
    
    % Compute distances for each pair of hyperedges
    for i = 1:numEdges
        for j = 1:numEdges
            if i ~= j
                % Check if hyperedges share at least one node
                if ~isempty(intersect(hyperEdges{i}, hyperEdges{j}))
                    % If they share nodes, the distance is 1
                    edgeDistances(i, j) = 1;
                else
                    % Otherwise, compute distance using BFS
                    distance = bfs_distance(hyperEdges, i, j);
                    edgeDistances(i, j) = distance;
                end
            end
        end
    end
end

