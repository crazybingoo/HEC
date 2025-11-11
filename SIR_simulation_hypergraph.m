function [S, I, R] = SIR_simulation_hypergraph(hypergraph, beta, gamma, initial_infected, steps)
% SIR_SIMULATION_HYPERGRAPH  Simulate SIR dynamics on a hypergraph.
%
%   [S, I, R] = SIR_simulation_hypergraph(hypergraph, beta, gamma, ...
%                                         initial_infected, steps)
%
%   INPUT
%       hypergraph        - Incidence matrix of the hypergraph.
%                           Size: E x N, where E is the number of hyperedges
%                           and N is the number of nodes. hypergraph(e, n) = 1
%                           if node n belongs to hyperedge e; 0 otherwise.
%
%       beta              - Infection (transmission) rate.
%       gamma             - Recovery rate.
%       initial_infected  - Row vector of indices of initially infected nodes
%                           (indices refer to columns of 'hypergraph').
%       steps             - Number of time steps to simulate.
%
%   OUTPUT
%       S                 - Column vector (steps x 1). Number of susceptible
%                           nodes at each time step.
%       I                 - Column vector (steps x 1). Number of infected
%                           nodes at each time step.
%       R                 - Column vector (steps x 1). Number of recovered
%                           nodes at each time step.
%
%   DESCRIPTION
%       This function implements a simple SIR model on a hypergraph. Each node
%       can be in one of three states:
%           0 - susceptible
%           1 - infected
%           2 - recovered
%
%       The infection spreads along hyperedges: an infected node may infect
%       other nodes that share at least one hyperedge with it, with
%       probability 'beta'. Each infected node recovers with probability
%       'gamma' at each time step.
%
%   NOTE
%       - This is a basic illustrative implementation; for large hypergraphs,
%         more efficient data structures and vectorized operations are
%         recommended.
%
%   EXAMPLE
%       hypergraph = [1 0 1; 0 1 1];
%       beta  = 0.3;
%       gamma = 0.1;
%       initial_infected = [1];
%       steps = 20;
%       [S, I, R] = SIR_simulation_hypergraph(hypergraph, beta, gamma, initial_infected, steps);

    % Number of hyperedges (E) and nodes (N)
    [E, N] = size(hypergraph);

    % Preallocate S, I, R
    S = zeros(steps, 1);  % susceptible
    I = zeros(steps, 1);  % infected
    R = zeros(steps, 1);  % recovered

    % Infection state of each node:
    %   0 - susceptible, 1 - infected, 2 - recovered
    infected = zeros(N, 1);
    infected(initial_infected) = 1;  % set initially infected nodes

    % Time evolution
    for t = 1:steps
        new_infected = [];

        % ----------------- Infection process -----------------
        % For each infected node, try to infect other nodes that share
        % at least one hyperedge with it.
        infected_nodes = find(infected == 1)';

        for i = infected_nodes
            % Find hyperedges that contain node i
            incident_hyperedges = find(hypergraph(:, i));

            % Nodes that share at least one hyperedge with node i
            neighbor_nodes = find(any(hypergraph(incident_hyperedges, :), 1));

            % Try to infect susceptible neighbors
            for j = neighbor_nodes
                if infected(j) == 0 && rand() < beta
                    new_infected = [new_infected, j]; %#ok<AGROW>
                end
            end
        end

        % ----------------- Recovery process ------------------
        % Each infected node recovers with probability gamma
        for i = infected_nodes
            if rand() < gamma
                infected(i) = 2;  % recovered state
            end
        end

        % Update infection states for newly infected nodes
        infected(new_infected) = 1;

        % ----------------- Count S, I, R ---------------------
        S(t) = sum(infected == 0);
        I(t) = sum(infected == 1);
        R(t) = sum(infected == 2);

        % Optional consistency check
        total_nodes = S(t) + I(t) + R(t);
        if total_nodes ~= N
            fprintf('Warning: total number of nodes at time step %d is %d (expected %d).\n', ...
                    t, total_nodes, N);
        end
    end

end
