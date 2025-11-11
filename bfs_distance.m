function distance = bfs_distance(hyperedges, startEdge, endEdge)
    % Perform BFS to find the shortest distance between two hyperedges
    queue = {startEdge};
    visited = false(1, length(hyperedges));
    visited(startEdge) = true;
    distance = 0;
    
    while ~isempty(queue)
        distance = distance + 1;
        newQueue = {};
        for i = 1:length(queue)
            currentEdge = queue{i};
            for j = 1:length(hyperedges)
                if ~visited(j) && have_common_node(hyperedges{currentEdge}, hyperedges{j})
                    if j == endEdge
                        return;
                    end
                    newQueue{end+1} = j;
                    visited(j) = true;
                end
            end
        end
        queue = newQueue;
    end
end

