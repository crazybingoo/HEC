clc; clear; close all;

%% ================== 1. Load patient data & select channels ==================

FileName = 'wc_cut03\wangchun_cut03.mat';
% Example channel indices for this patient (modify as needed)
chanIdx  = [1:10, 100:104, 58:62];  

X1 = load_patient_data(FileName, chanIdx);

%% ================== 2. Select time window (e.g., seizure segment) ==========

fs = 1024;                 % sampling frequency
startSec = 200;            % start time (s)
endSec   = 285;            % end time (s)

Xseg = select_time_window(X1, startSec, endSec, fs);

%% ================== 3. Compute PLV connectivity matrix =====================

PLV = compute_plv_matrix(Xseg);

%% ================== 4. Build binary connection matrix ======================

perc = 0.65;   % keep top 35% non-zero PLV entries
[connection_matrix, threshold] = build_connection_matrix(PLV, perc);

%% ================== 5. Build hypergraph from connection matrix =============

[num_nodes, ~] = size(connection_matrix);
[hyperEdges, triIndex] = build_hypergraph_from_connection(connection_matrix);

%% ================== 6. Compute node-level centrality =======================

% method can be: 'HDC', 'HGC', 'VC', 'HCC', 'HEC1' (depending on your implementations)
method = 'HDC';
nodes_vector = compute_node_centrality(num_nodes, hyperEdges, method, ...
                                       connection_matrix, triIndex);

%% ================== 7. Map to DataL/DataR and save =========================

% Here we assume first 10 channels are EZs, last 10 are NEZs
DataL(:,10) = nodes_vector(1:10,:);
DataR(:,10) = nodes_vector(11:20,:);

savepath = 'D:\wcldematlab\keep\new_idea\new_2\2\HDC\';
if ~exist(savepath, 'dir'), mkdir(savepath); end

save(fullfile(savepath, 'DataL.mat'), 'DataL');
save(fullfile(savepath, 'DataR.mat'), 'DataR');

%% ================== 8. Boxplot + permutation test ==========================

p_perm = boxplot_permtest_HEC(DataL, DataR);
fprintf('Permutation test p-value (EZ vs NEZ) = %.4g\n', p_perm);

%% ================== 9. Violin plot across patients =========================

Name      = {'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9', 'P10'};
ClassName = {'EZs','NEZs'};
Condition = {'*','**','**','***','*','*','*','**','***','***'};  % example labels

violin_HEC(DataL, DataR, Name, ClassName, Condition);
