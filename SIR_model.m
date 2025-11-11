clc; clear;
close all;

% Example: SIR model on a hypergraph

% Define the hypergraph incidence matrix.
% In this simple example, each row represents a hyperedge (node group),
% and each column represents a node. A value of 1 indicates that the node
% belongs to the corresponding hyperedge.
hypergraph = [
    1 0 1 1 0;
    0 1 1 0 1;
    1 0 0 1 1
];

% Model parameters
beta  = 0.3;  % infection (transmission) rate
gamma = 0.1;  % recovery rate

% Initial infected nodes (indices of nodes/columns in the hypergraph)
initial_infected = [1, 2];

% Simulation settings
steps = 10;  % number of time steps

% Run SIR simulation on the hypergraph
[S, I, R] = SIR_simulation_hypergraph(hypergraph, beta, gamma, initial_infected, steps);

% Time vector for plotting
t = 1:steps;

% Plot the results
figure;
plot(t, S, 'b-', t, I, 'r-', t, R, 'g-', 'LineWidth', 2);
xlabel('Time step');
ylabel('Number of nodes');
legend({'Susceptible', 'Infected', 'Recovered'}, 'Location', 'best');
title('SIR dynamics on a hypergraph');
set(gca, 'FontSize', 12);
set(gca, 'FontName', 'Times New Roman');
grid on;
